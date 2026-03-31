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
package com.alibaba.cloud.ai.dataagent;

import com.alibaba.cloud.ai.dataagent.entity.Agent;
import com.alibaba.cloud.ai.dataagent.service.agent.AgentService;
import com.alibaba.cloud.ai.dataagent.service.graph.GraphService;
import com.alibaba.cloud.ai.dataagent.service.mcp.McpAgentService;
import io.modelcontextprotocol.server.McpServerFeatures;
import io.modelcontextprotocol.server.McpSyncServer;
import org.springframework.ai.mcp.McpToolUtils;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.ai.tool.definition.DefaultToolDefinition;
import org.springframework.ai.tool.metadata.ToolMetadata;
import org.springframework.ai.tool.method.MethodToolCallback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.lang.reflect.Method;
import java.util.List;

@EnableScheduling
@SpringBootApplication
public class DataAgentApplication implements ApplicationRunner {
	@Autowired
	private McpSyncServer mcpSyncServer;
	@Autowired
	private AgentService agentService;
	@Autowired
	private GraphService graphService;
	public static void main(String[] args) {
		SpringApplication.run(DataAgentApplication.class, args);
	}

	// 动态注册 tool
	public void registerDynamicTool(Agent agent) {
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
					"default": false,
					"description": "只返回生成的SQL语句，而不执行它。"
				},
                "limit": {
                    "type": "integer",
                    "default": 10,
                    "description": "要查询结果返回的最大数量"
                }
            },
            "required": ["naturalQuery"]
        }
        """;

		McpAgentService mcpAgent = new McpAgentService(agent,graphService);
		try {
			DefaultToolDefinition toolDef = new DefaultToolDefinition(agent.getName(),agent.getDescription(),inputSchema);
			Method toolMethod = McpAgentService.class.getMethod("nl2Sql2DataToolCallback", String.class,String.class,Boolean.class,Integer.class);
			ToolCallback toolCallback = new MethodToolCallback(toolDef, ToolMetadata.from(toolMethod),toolMethod,mcpAgent,null);
			McpServerFeatures.SyncToolSpecification tool = McpToolUtils.toSyncToolSpecification(toolCallback);
			mcpSyncServer.addTool(tool);
		} catch (NoSuchMethodException e) {
			throw new RuntimeException(e);
		}

	}

	// 动态注销 tool
	public void unregisterTool(String toolName) {
		mcpSyncServer.removeTool(toolName);
		mcpSyncServer.notifyToolsListChanged();
	}

	@Override
	public void run(ApplicationArguments args) throws Exception {
		System.out.println("应用启动后执行MCP服务的工具注册");
		List<Agent> agents = agentService.findByStatus("published");
		agents.forEach((Agent agent) -> {
			registerDynamicTool(agent);
		});

		// 通知客户端 tools 列表已变更
		mcpSyncServer.notifyToolsListChanged();
	}

}
