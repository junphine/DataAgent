package com.alibaba.cloud.ai.dataagent.config;

import com.alibaba.cloud.ai.dataagent.service.agent.AgentService;
import com.alibaba.druid.util.StringUtils;
import com.drew.lang.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE) // 最高优先级
public class ApiKeyAuthInterceptor implements WebFilter {
    private static final String apiKeyHeader = "Authorization";

    // 名单路径，需要鉴权
    private static final List<String> URL_LIST = List.of(
            "/sse/",
            "/api/"
    );

    @Autowired
    private AgentService agentService;

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        String path = exchange.getRequest().getPath().value();

        // 非api名单直接放行
        if (!isHandleURLList(path)) {
            return chain.filter(exchange);
        }

        String apiKey = exchange.getRequest().getHeaders().getFirst(apiKeyHeader);
        apiKey = apiKey.replace("Bearer ","");

        String[] parts = path.split("/");
        String agentId = parts.length>2 ? parts[2] : null;
        if(agentId==null || StringUtils.isNumber(agentId)){
            // 验证API Key
            boolean isValid = agentService.validateApiKey(agentId,apiKey);

            if (!isValid) {
                exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
                return exchange.getResponse().setComplete();
            }
        }
        return chain.filter(exchange);
    }

    private boolean isHandleURLList(String path) {
        return URL_LIST.stream().anyMatch(path::startsWith);
    }
}
