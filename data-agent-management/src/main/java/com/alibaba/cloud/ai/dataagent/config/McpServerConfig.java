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

import java.lang.reflect.Method;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import com.alibaba.cloud.ai.dataagent.entity.Agent;
import com.alibaba.cloud.ai.dataagent.service.agent.AgentService;
import com.alibaba.cloud.ai.dataagent.service.graph.GraphService;
import com.alibaba.cloud.ai.dataagent.service.mcp.McpAgentService;
import com.alibaba.cloud.ai.dataagent.service.mcp.McpServerService;
import com.alibaba.cloud.ai.dataagent.util.JsonUtil;
import com.alibaba.cloud.ai.dataagent.util.McpServerToolUtil;
import com.alibaba.cloud.ai.graph.exception.GraphRunnerException;
import io.modelcontextprotocol.json.jackson.JacksonMcpJsonMapper;
import io.modelcontextprotocol.server.McpAsyncServer;
import io.modelcontextprotocol.server.McpServer;
import io.modelcontextprotocol.server.McpServerFeatures;

import io.modelcontextprotocol.server.McpSyncServer;
import io.modelcontextprotocol.server.transport.WebFluxSseServerTransportProvider;
import io.modelcontextprotocol.server.transport.WebFluxStreamableServerTransportProvider;
import io.modelcontextprotocol.spec.McpSchema;
import org.springframework.ai.mcp.McpToolUtils;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.definition.DefaultToolDefinition;
import org.springframework.ai.tool.metadata.ToolMetadata;
import org.springframework.ai.tool.method.MethodToolCallback;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.ai.tool.resolution.DelegatingToolCallbackResolver;
import org.springframework.ai.tool.resolution.SpringBeanToolCallbackResolver;
import org.springframework.ai.tool.resolution.StaticToolCallbackResolver;
import org.springframework.ai.tool.resolution.ToolCallbackResolver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.support.GenericApplicationContext;
import org.springframework.core.env.Environment;
import org.springframework.web.reactive.function.server.RouterFunction;

import static io.modelcontextprotocol.spec.McpSchema.*;


@Configuration
public class McpServerConfig {

	@Autowired
	private AgentService agentService;
	@Autowired
	private GraphService graphService;

	@Autowired
	private Environment env;

		public boolean isTestEnv(){
		Optional<String> profile = Arrays.stream(env.getActiveProfiles()).filter(p->p.equals("test")).findFirst();
		if(profile.isPresent() && profile.get().equals("test")){
			return true;
		}
		return false;
	}


	// McpServerTool自定义注解 是为了解决如下场景：
	// ChatClient初始化依赖 chatModel，而如dashscopeChatModel等通过starter装配的ChatModel初始化会
	// 立马扫描tool了，但是我们的tool功能需要依赖LLM（比如NL2SQL），所以间接依赖了chatClient，循环依赖。
	//@Bean
	//@McpServerTool
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
				new PromptReference("sql-code-completion","Sql Generate","Provides sql code completion suggestions"),
				(exchange, request) -> {
					String name = request.argument().name();
					String value = request.argument().value();
					List<Agent> agents = agentService.findByStatus("published");
					List<String> suggestions = new ArrayList<>();
					agents.parallelStream().forEach((Agent agent) -> {
						try {
							String sql = graphService.nl2sql(value,agent.getId().toString());
							if(sql!=null && sql.toLowerCase().contains("SELECT")) {
								suggestions.add(sql);
							}
						} catch (GraphRunnerException e) {
							throw new RuntimeException(e);
						}
					});
					// 返回完成建议的实现
					return new CompleteResult(
							new CompleteResult.CompleteCompletion(suggestions,suggestions.size(),false)
					);
				}
		);

		return List.of(completion);
	}


	// 动态注册 tool
	public void registerAsyncTool(List<McpServerFeatures.AsyncToolSpecification> tools,Agent agent) {
		String inputSchema = """
        {
            "type": "object",
            "properties": {
            	"naturalQuery": {
    				"type": "string",
					"description": "数据查询语句"
				},
				"humanFeedbackContent": {
					"type": "string",
					"description": "多轮对话中用户的反馈信息"
				},
				"nl2sqlOnly": {
					"type": "boolean",
					"default": true,
					"description": "只返回生成的SQL语句和SQL执行结果，不生成结果分析报告。"
				},
                "limit": {
                    "type": "integer",
                    "default": 0,
                    "description": "要查询结果返回的最大数量，0代表不限制。"
                },
                "sessionId": {
					"type": "string",
					"description": "支持多轮对话时，需要传入当前对话的sessionId，sessionId从第一次对话返回结果里面取。"
				}
            },
            "required": ["naturalQuery"]
        }
        """;

		McpAgentService mcpAgent = new McpAgentService(agent,graphService);
		try {
			DefaultToolDefinition toolDef = new DefaultToolDefinition(agent.getName(),agent.getDescription(),inputSchema);
			Method toolMethod = McpAgentService.class.getMethod("streamResultSet", String.class,String.class,Boolean.class,Integer.class,String.class);
			ToolCallback toolCallback = new MethodToolCallback(toolDef, ToolMetadata.from(toolMethod),toolMethod,mcpAgent,null);
			McpServerFeatures.AsyncToolSpecification atool = McpToolUtils.toAsyncToolSpecification(toolCallback);
			tools.add(atool);
		} catch (NoSuchMethodException e) {
			throw new RuntimeException(e);
		}
	}

	public void registerSyncTool(List<McpServerFeatures.SyncToolSpecification> tools,Agent agent) {
		String inputSchema = """
        {
            "type": "object",
            "properties": {
            	"naturalQuery": {
    				"type": "string",
					"description": "数据查询语句"
				},
				"humanFeedbackContent": {
					"type": "string",
					"description": "多轮对话中用户的反馈信息"
				},
				"nl2sqlOnly": {
					"type": "boolean",
					"default": true,
					"description": "只返回生成的SQL语句和SQL执行结果，不生成结果分析报告。"
				},
                "limit": {
                    "type": "integer",
                    "default": 0,
                    "description": "要查询结果返回的最大数量，0代表不限制。"
                },
                "sessionId": {
					"type": "string",
					"description": "支持多轮对话时，需要传入当前对话的sessionId，sessionId从第一次对话返回结果里面取。"
				}
            },
            "required": ["naturalQuery"]
        }
        """;

		McpAgentService mcpAgent = new McpAgentService(agent,graphService);
		try {
			DefaultToolDefinition toolDef = new DefaultToolDefinition(agent.getName(),agent.getDescription(),inputSchema);

			Method syncToolMethod = McpAgentService.class.getMethod("nl2Sql2DataToolCallback", String.class,String.class,Boolean.class,Integer.class,String.class);
			ToolCallback toolSyncCallback = new MethodToolCallback(toolDef, ToolMetadata.from(syncToolMethod),syncToolMethod,mcpAgent,null);
			McpServerFeatures.SyncToolSpecification stool = McpToolUtils.toSyncToolSpecification(toolSyncCallback);
			tools.add(stool);

		} catch (NoSuchMethodException e) {
			throw new RuntimeException(e);
		}
	}



	// 专为 SSE 端点准备的工具集
	@Bean
	public List<McpServerFeatures.SyncToolSpecification> sseTools() {
		List<McpServerFeatures.SyncToolSpecification> tools = new ArrayList<>();
		String status = "published";
		if(isTestEnv()){
			status = "draft";
		}
		List<Agent> agents = agentService.findByStatus(status);
		agents.forEach((Agent agent) -> {
			registerSyncTool(tools,agent);
		});
		// 你可以在这里添加更多SSE专用的工具
		return tools;
	}

	// 专为 Streamable-HTTP 端点准备的工具集
	@Bean
	public List<McpServerFeatures.AsyncToolSpecification> streamableHttpTools() {
		List<McpServerFeatures.AsyncToolSpecification> tools = new ArrayList<>();
		String status = "published";
		if(isTestEnv()){
			status = "draft";
		}
		List<Agent> agents = agentService.findByStatus(status);
		agents.forEach((Agent agent) -> {
			registerAsyncTool(tools,agent);
		});
		// 你可以在这里添加更多HTTP专用的工具
		return tools;
	}

	// ================= 2. 为SSE端点创建并配置服务器 =================
	@Bean
	public McpSyncServer sseMcpServer(List<McpServerFeatures.SyncToolSpecification> sseTools,
									  @Qualifier("sseTransport") WebFluxSseServerTransportProvider sseTransport) {
		// 创建服务器实例，只注册 sseTools 这个Bean中的工具
		return McpServer.sync(sseTransport)
				.serverInfo("data-agent-sse-server", "1.0.0")
				.capabilities(McpSchema.ServerCapabilities.builder()
						.tools(true) // 开启工具能力
						.build())
				.tools(sseTools) // 关键：只注册SSE专用工具集
				.requestTimeout(Duration.ofMinutes(10))
				.build();
	}

	// ================= 3. 为Streamable-HTTP端点创建并配置服务器 =================
	@Bean
	@Primary
	public McpAsyncServer streamableHttpMcpServer(List<McpServerFeatures.AsyncToolSpecification> streamableHttpTools,WebFluxStreamableServerTransportProvider httpTransport) {
		// 创建服务器实例，只注册 streamableHttpTools 这个Bean中的工具
		return McpServer.async(httpTransport)
				.serverInfo("data-agent-streamable-http-server", "1.0.0")
				.capabilities(McpSchema.ServerCapabilities.builder()
						.tools(true)
						.build())
				.tools(streamableHttpTools) // 关键：只注册HTTP专用工具集
				.requestTimeout(Duration.ofMinutes(10))
				.build();
	}

	@Bean
	@Qualifier("sseTransport")
	public WebFluxSseServerTransportProvider sseTransport() {
		// 直接实例化 Provider
		return WebFluxSseServerTransportProvider.builder()
				.jsonMapper(new JacksonMcpJsonMapper(JsonUtil.getObjectMapper()))
				.messageEndpoint("/sse")
				.keepAliveInterval(Duration.ofMinutes(5))
				.build();
	}

	@Bean
	@Primary
	public WebFluxStreamableServerTransportProvider httpTransport() {
		// 直接实例化 Provider
		return WebFluxStreamableServerTransportProvider.builder()
				.jsonMapper(new JacksonMcpJsonMapper(JsonUtil.getObjectMapper()))
				.messageEndpoint("/mcp")
				.keepAliveInterval(Duration.ofMinutes(5))
				.build();
	}

	@Bean
	public RouterFunction<?> sseMcpRouterFunction(
			@Qualifier("sseTransport") WebFluxSseServerTransportProvider sseTransport) {
		return sseTransport.getRouterFunction();
	}
}
