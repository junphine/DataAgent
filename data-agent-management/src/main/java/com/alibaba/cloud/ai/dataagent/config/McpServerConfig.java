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

import java.util.ArrayList;
import java.util.List;
import com.alibaba.cloud.ai.dataagent.annotation.McpServerTool;
import com.alibaba.cloud.ai.dataagent.service.mcp.McpServerService;
import com.alibaba.cloud.ai.dataagent.util.McpServerToolUtil;
import io.modelcontextprotocol.server.McpServerFeatures;

import org.springframework.ai.tool.ToolCallback;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.ai.tool.resolution.DelegatingToolCallbackResolver;
import org.springframework.ai.tool.resolution.SpringBeanToolCallbackResolver;
import org.springframework.ai.tool.resolution.StaticToolCallbackResolver;
import org.springframework.ai.tool.resolution.ToolCallbackResolver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.GenericApplicationContext;
import static io.modelcontextprotocol.spec.McpSchema.*;


// TODO 2025/12/08 合并包后移动到DataAgentConfiguration  中
@Configuration
public class McpServerConfig {

	// McpServerTool自定义注解 是为了解决如下场景：
	// ChatClient初始化依赖 chatModel，而如dashscopeChatModel等通过starter装配的ChatModel初始化会
	// 立马扫描tool了，但是我们的tool功能需要依赖LLM（比如NL2SQL），所以间接依赖了chatClient，循环依赖。
	@Bean
	@McpServerTool
	public ToolCallbackProvider mcpServerTools(McpServerService mcpServerService) {
		return MethodToolCallbackProvider.builder().toolObjects(mcpServerService).build();
	}


	@Bean
	public ToolCallbackResolver toolCallbackResolver(GenericApplicationContext context) {
		List<ToolCallback> allFunctionAndToolCallbacks = new ArrayList<>(
				McpServerToolUtil.excludeMcpServerTool(context, ToolCallback.class));
		McpServerToolUtil.excludeMcpServerTool(context, ToolCallbackProvider.class)
				.stream()
				.map(pr -> List.of(pr.getToolCallbacks()))
				.forEach(allFunctionAndToolCallbacks::addAll);

		var staticToolCallbackResolver = new StaticToolCallbackResolver(allFunctionAndToolCallbacks);

		var springBeanToolCallbackResolver = SpringBeanToolCallbackResolver.builder()
				.applicationContext(context)
				.build();

		return new DelegatingToolCallbackResolver(List.of(staticToolCallbackResolver, springBeanToolCallbackResolver));
	}

	@Bean
	public List<McpServerFeatures.SyncCompletionSpecification> codeCompletions() {


		var completion = new McpServerFeatures.SyncCompletionSpecification(
				new PromptReference("code-completion","sql gen","Provides code completion suggestions"),
				(exchange, request) -> {
					// 返回完成建议的实现
					return new CompleteResult(
							new CompleteResult.CompleteCompletion(List.of("suggestion1", "First suggestion"),2,false)

					);
				}
		);

		return List.of(completion);
	}

}
