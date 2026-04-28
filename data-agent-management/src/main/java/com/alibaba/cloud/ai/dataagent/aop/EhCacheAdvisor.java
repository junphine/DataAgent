package com.alibaba.cloud.ai.dataagent.aop;

import lombok.Builder;
import lombok.Data;
import lombok.ToString;
import org.ehcache.Cache;
import org.ehcache.CacheManager;
import org.springframework.ai.chat.client.ChatClientRequest;
import org.springframework.ai.chat.client.ChatClientResponse;
import org.springframework.ai.chat.client.advisor.api.*;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Component;
import lombok.extern.slf4j.Slf4j;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import reactor.core.publisher.Flux;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

@Component
@Slf4j
public class EhCacheAdvisor implements CallAdvisor, StreamAdvisor {

    private final CacheManager cacheManager;
    private Cache<String, ChatClientResponse> callCache;
    private Cache<String, List<ChatClientResponse>> streamCache;

    private CacheStatistics statistics = new CacheStatistics();

    public EhCacheAdvisor(CacheManager cacheManager) {
        this.cacheManager = cacheManager;
    }

    @PostConstruct
    public void init() {
        this.callCache = cacheManager.getCache("call-cache", String.class, ChatClientResponse.class);
        this.streamCache = (Cache)cacheManager.getCache("stream-cache", String.class, List.class);
        log.info("EhCacheAdvisor initialized");
    }

    private String generateCacheKey(ChatClientRequest request) {
        return generateKey(request.prompt());
    }


    private String generateKey(Prompt prompt) {
        // 构建缓存键字符串
        StringBuilder keyBuilder = new StringBuilder();

        // 添加消息内容
        prompt.getInstructions().forEach(message -> {
            keyBuilder.append(message.getMessageType()).append(":")
                    .append(message.getText()).append("\n");
        });

        // 添加模型参数
        if (prompt.getOptions() != null) {
            keyBuilder.append("temperature:").append(prompt.getOptions().getTemperature()).append(";")
                    .append("maxTokens:").append(prompt.getOptions().getMaxTokens()).append(";")
                    .append("topP:").append(prompt.getOptions().getTopP()).append(";");
        }

        // 计算 MD5
        return md5(keyBuilder.toString());
    }

    private String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashBytes = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            log.error("MD5 algorithm not found", e);
            return String.valueOf(input.hashCode());
        }
    }

    // 手动清除缓存
    public void evictCallCache(String cacheKey) {
        callCache.remove(cacheKey);
        log.info("Evicted call cache for key: {}", cacheKey);
    }

    public void evictStreamCache(String cacheKey) {
        streamCache.remove(cacheKey);
        log.info("Evicted stream cache for key: {}", cacheKey);
    }

    public void evictByPrompt(Prompt prompt) {
        String key = generateKey(prompt);
        evictCallCache(key);
        evictStreamCache(key);
    }

    public void clearAllCache() {
        callCache.clear();
        streamCache.clear();
        log.info("All caches cleared");
    }

    // 获取缓存统计信息
    public CacheStatistics getStatistics() {
        return statistics;
    }

    @PreDestroy
    public void destroy() {
        if (cacheManager != null) {
            cacheManager.close();
            log.info("EhCacheManager closed");
        }
    }

    @Override
    public ChatClientResponse adviseCall(ChatClientRequest request, CallAdvisorChain chain) {
        String cacheKey = generateCacheKey(request);
        statistics.callRequests++;
        // 检查缓存
        ChatClientResponse cached = callCache.get(cacheKey);
        if (cached != null) {
            log.info("Call cache hit for key: {}", cacheKey);
            return cached;
        }
        statistics.callMiss++;
        // 缓存未命中，执行实际调用
        log.info("Call cache miss for key: {}", cacheKey);
        ChatClientResponse response = chain.nextCall(request);

        // 存入缓存
        callCache.put(cacheKey, response);
        log.info("Response cached for key: {}", cacheKey);

        return response;
    }

    @Override
    public Flux<ChatClientResponse> adviseStream(ChatClientRequest request, StreamAdvisorChain chain) {
        String cacheKey = generateCacheKey(request);
        statistics.streamRequests++;
        // 检查缓存
        List<ChatClientResponse> cached = streamCache.get(cacheKey);
        if (cached != null && !cached.isEmpty()) {
            log.info("Stream cache hit for key: {}, size: {}", cacheKey, cached.size());
            return Flux.fromIterable(cached);
        }
        statistics.streamMiss++;
        // 缓存未命中，执行实际调用并缓存结果
        log.info("Stream cache miss for key: {}", cacheKey);
        return chain.nextStream(request)
                .collectList()
                .doOnNext(responses -> {
                    streamCache.put(cacheKey, responses);
                    log.info("Stream responses cached for key: {}, size: {}", cacheKey, responses.size());
                })
                .flatMapMany(Flux::fromIterable);
    }

    @Override
    public String getName() {
        return "llm-call-cache";
    }

    @Override
    public int getOrder() {
        return 0;
    }

    @Data
    @ToString
    public static class CacheStatistics {
        private int callRequests;
        private int streamRequests;
        private int callMiss;
        private int streamMiss;
    }
}