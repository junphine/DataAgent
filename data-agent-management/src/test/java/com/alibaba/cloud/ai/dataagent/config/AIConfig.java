package com.alibaba.cloud.ai.dataagent.config;

import com.alibaba.cloud.ai.dashscope.api.DashScopeApi;
import com.alibaba.cloud.ai.dashscope.chat.DashScopeChatModel;
import com.alibaba.cloud.ai.dashscope.chat.DashScopeChatOptions;
import com.alibaba.cloud.ai.dashscope.spec.DashScopeApiSpec;
import io.netty.channel.ChannelOption;
import io.netty.handler.timeout.ReadTimeoutHandler;
import io.netty.handler.timeout.WriteTimeoutHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.JdkClientHttpRequestFactory;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.client.RestClient;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import reactor.netty.resources.ConnectionProvider;

import java.time.Duration;

@Configuration
public class AIConfig {


    @Bean
    public DashScopeChatModel getDashScopeChatModel() {

        return DashScopeChatModel.builder()
                .dashScopeApi(getDashscopeAPI()).defaultOptions(
                        DashScopeChatOptions.builder()
                                .model("qwen-plus")
                                .enableSearch(true)
                                .searchOptions(DashScopeApiSpec.SearchOptions.builder()
                                        .enableSource(true)
                                        .forcedSearch(true)
                                        .searchStrategy("turbo")
                                        .build()
                                ).build()
                ).build();
    }

    private static DashScopeApi getDashscopeAPI() {

        // 配置HTTP连接池
        ConnectionProvider provider = ConnectionProvider.builder("dashscope")
                .maxConnections(500)
                .maxIdleTime(Duration.ofMinutes(10))  // 空闲连接保持10分钟
                .maxLifeTime(Duration.ofMinutes(30))  // 连接最大生命周期30分钟
                .evictInBackground(Duration.ofSeconds(60))  // 每60秒清理一次过期连接
                .build();

        // 配置HTTP客户端
        HttpClient httpClient = HttpClient.create(provider)
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 10000)  // 连接超时10秒
                .responseTimeout(Duration.ofSeconds(60))  // 响应超时60秒
                .doOnConnected(conn -> conn
                        .addHandlerLast(new ReadTimeoutHandler(60))  // 读超时60秒
                        .addHandlerLast(new WriteTimeoutHandler(10))  // 写超时10秒
                );

        // 构建WebClient实例
        WebClient.Builder webClientbuilder = WebClient.builder()
                .clientConnector(new ReactorClientHttpConnector(httpClient));


        return DashScopeApi.builder()
                .apiKey("sk-xxx")
                .webClientBuilder(webClientbuilder)
                .restClientBuilder(RestClient.builder().requestFactory(new JdkClientHttpRequestFactory()))
                .build();
    }
}
