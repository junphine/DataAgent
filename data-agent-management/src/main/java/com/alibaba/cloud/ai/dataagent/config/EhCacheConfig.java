package com.alibaba.cloud.ai.dataagent.config;

import com.alibaba.cloud.ai.dataagent.vo.ChatResponse;
import org.ehcache.Cache;
import org.ehcache.CacheManager;
import org.ehcache.config.CacheConfiguration;
import org.ehcache.config.builders.CacheConfigurationBuilder;
import org.ehcache.config.builders.CacheManagerBuilder;
import org.ehcache.config.builders.ExpiryPolicyBuilder;
import org.ehcache.config.builders.ResourcePoolsBuilder;
import org.ehcache.config.units.MemoryUnit;
import org.ehcache.expiry.ExpiryPolicy;
import org.springframework.ai.chat.client.ChatClientResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;
import java.util.List;

@Configuration
public class EhCacheConfig {

    @Bean
    public CacheManager ehCacheManager() {
        return CacheManagerBuilder.newCacheManagerBuilder()
                // 配置 Call 缓存
                .withCache("call-cache", callCacheConfiguration())
                // 配置 Stream 缓存
                .withCache("stream-cache", streamCacheConfiguration())
                .build(true); // 初始化 CacheManager
    }

    private CacheConfiguration<String, ChatClientResponse> callCacheConfiguration() {
        return CacheConfigurationBuilder.newCacheConfigurationBuilder(
                        String.class, ChatClientResponse.class,
                        ResourcePoolsBuilder.heap(1000)) // 堆内最多 1000 个条目
                .withExpiry(ExpiryPolicyBuilder.timeToLiveExpiration(Duration.ofMinutes(30))) // TTL 10分钟
                .withExpiry(ExpiryPolicyBuilder.timeToIdleExpiration(Duration.ofMinutes(15)))   // TTI 5分钟
                .build();
    }

    private CacheConfiguration<String, List<ChatClientResponse>> streamCacheConfiguration() {
        return CacheConfigurationBuilder.newCacheConfigurationBuilder(
                        String.class, (Class<List<ChatClientResponse>>) (Class<?>) List.class,
                        ResourcePoolsBuilder.heap(5000))
                .withExpiry(ExpiryPolicyBuilder.timeToLiveExpiration(Duration.ofMinutes(30)))
                .build();
    }
}