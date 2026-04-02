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
package com.alibaba.cloud.ai.dataagent.service.mcp;

import com.alibaba.cloud.ai.dataagent.entity.Agent;
import com.alibaba.cloud.ai.dataagent.mapper.AgentMapper;
import com.alibaba.cloud.ai.dataagent.service.graph.GraphService;
import com.alibaba.cloud.ai.dataagent.vo.ChatResponse;
import com.alibaba.cloud.ai.graph.exception.GraphRunnerException;
import com.fasterxml.jackson.annotation.JsonPropertyDescription;
import lombok.AllArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.alibaba.cloud.ai.dataagent.constant.Constant.*;

// 封装Mcp 服务
@Service
@AllArgsConstructor
public class McpServerService {

	private final AgentMapper agentMapper;

	private GraphService graphService;

	public record AgentListRequest(
			@JsonPropertyDescription("按状态过滤，例如 '状态：draft-待发布，published-已发布，offline-已下线") String status,

			@JsonPropertyDescription("按关键词搜索智能体名称或描述") String keyword) {
	}

	@Tool(name="list-data-agents", description = "查询智能体列表，支持按状态和关键词过滤。可以根据智能体的状态（如已发布PUBLISHED、草稿DRAFT等）进行过滤，也可以通过关键词搜索智能体的名称、描述或标签。返回按创建时间降序排列的智能体列表。")
	public List<Agent> listAgentsToolCallback(AgentListRequest agentListRequest) {
		return agentMapper.findByConditions(agentListRequest.status(), agentListRequest.keyword());
	}

	// NL2SQL 请求参数
	@Tool(name="nl2sql-agent",description = "将自然语言查询转换为SQL语句。使用指定的智能体将用户的自然语言查询描述转换为可执行的SQL语句，支持复杂的数据查询需求。")
	public String nl2SqlToolCallback(
			@ToolParam(description="自然语言查询描述") String naturalQuery,
			@ToolParam(description="智能体ID，用于指定使用哪个智能体进行NL2SQL转换") String agentId)
			throws GraphRunnerException {
		return graphService.nl2sql(naturalQuery, agentId);
	}

	@Tool(name="nl2sql2data-agent",description = "获取企业各方面的内部数据，将自然语言查询转换为SQL语句，然后再执行这个语句获取数据。",returnDirect = true)
	public ChatResponse nl2Sql2DataToolCallback(
			@ToolParam(description="自然语言查询描述") String naturalQuery,
			@ToolParam(description="智能体ID，用于指定使用哪个智能体进行NL2SQL转换") String agentId)
			throws GraphRunnerException {

		Assert.hasText(agentId, "AgentId cannot be empty");
		Assert.hasText(naturalQuery, "Natural query cannot be empty");
		Agent agent = agentMapper.findById(Integer.valueOf(agentId));
		McpAgentService mcpAgentSrv = new McpAgentService(agent,graphService);
		return mcpAgentSrv.nl2Sql2DataToolCallback(naturalQuery, null,false, 100, null);
	}

}
