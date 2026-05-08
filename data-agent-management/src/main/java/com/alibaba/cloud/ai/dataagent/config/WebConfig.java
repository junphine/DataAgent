/*
 * Copyright 2024-2026 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.alibaba.cloud.ai.dataagent.config;

import com.alibaba.cloud.ai.dataagent.properties.FileStorageProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.config.ResourceHandlerRegistry;
import org.springframework.web.reactive.config.WebFluxConfigurer;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

import java.nio.file.Paths;
import java.time.Duration;
import java.util.concurrent.TimeUnit;

import static org.springframework.web.reactive.function.server.RequestPredicates.GET;

/**
 * Web配置类 (WebFlux 版本)
 */
@Configuration
public class WebConfig implements WebFluxConfigurer {

	@Autowired
	private FileStorageProperties fileStorageProperties;

	@Value("${web.build.path:classpath:/static/}")
	private String reactBuildPath = "classpath:/static/";

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		String uploadDir = Paths.get(fileStorageProperties.getPath()).toAbsolutePath().toString();

		registry.addResourceHandler(fileStorageProperties.getUrlPrefix() + "/**")
			.addResourceLocations("file:" + uploadDir + "/")
			.setCacheControl(CacheControl.maxAge(Duration.ofHours(1)));

		// 静态资源配置
		registry.addResourceHandler("/assets/**")
				.addResourceLocations(reactBuildPath + "assets/")
				.setCacheControl(CacheControl.maxAge(365, TimeUnit.DAYS));


		// favicon
		registry.addResourceHandler("/favicon.svg")
				.addResourceLocations(reactBuildPath)
				.setCacheControl(CacheControl.maxAge(30, TimeUnit.DAYS));


	}

	@Bean
	@Order(Ordered.LOWEST_PRECEDENCE)
	public RouterFunction<ServerResponse> spaRouter() {
		return RouterFunctions
				.route(
						GET("/**")
								.and(path -> !path.path().startsWith("/api/"))
								.and(path -> !path.path().startsWith("/actuator/"))
								.and(path -> !path.path().startsWith("/swagger"))
								.and(path -> !path.path().startsWith("/mcp"))
								.and(path -> !path.path().startsWith("/sse"))
								.and(path -> !path.path().matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|json)$")),
						request -> serveIndexHtml()
				);
	}

	private Mono<ServerResponse> serveIndexHtml() {
		try {
			Resource indexHtml = new ClassPathResource("static/index.html");
			if (indexHtml.exists()) {
				return ServerResponse.ok()
						.contentType(MediaType.TEXT_HTML)
						.bodyValue(indexHtml);
			}
		} catch (Exception e) {
			return ServerResponse.status(404).build();
		}
		return ServerResponse.status(404).build();
	}

}
