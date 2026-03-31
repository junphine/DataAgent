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
import com.alibaba.cloud.ai.dataagent.service.graph.GraphService;
import com.alibaba.cloud.ai.dataagent.vo.ChatResponse;
import com.alibaba.cloud.ai.graph.exception.GraphRunnerException;
import com.fasterxml.jackson.annotation.JsonPropertyDescription;
import lombok.AllArgsConstructor;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.util.Assert;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.alibaba.cloud.ai.dataagent.constant.Constant.*;

// 封装Mcp 服务

@AllArgsConstructor
public class McpAgentService {

	private final Agent agent;

	private final GraphService graphService;


	public String nl2SqlToolCallback(String naturalQuery) throws GraphRunnerException {
		Assert.hasText(naturalQuery, "Natural query cannot be empty");
		return graphService.nl2sql(naturalQuery, agent.getId().toString());
	}

	@Tool(name="nl2sql2data-agent",description = "获取企业各方面的内部数据，将自然语言查询转换为SQL语句，然后再执行这个语句获取数据。",returnDirect = true)
	public ChatResponse nl2Sql2DataToolCallback(@ToolParam(description="自然语言查询描述") String naturalQuery,
												@ToolParam(description="多轮对话中用户的反馈信息",required=false) String humanFeedbackContent,
												@ToolParam(description="不执行SQL，只返回SQL语句",required=false) Boolean nl2sqlOnly,
												@ToolParam(description="返回最大结果数",required=false) Integer limit
												) throws GraphRunnerException{
		Assert.hasText(naturalQuery, "Natural query cannot be empty");
		String[] parts = naturalQuery.split(" // ");
		if(parts.length==2 && humanFeedbackContent==null){
			naturalQuery = parts[0];
			humanFeedbackContent = parts[1];
		}
		Map<String,Object> metaData = new HashMap<>();
		metaData.put(IS_ONLY_NL2SQL,nl2sqlOnly);
		metaData.put(AGENT_ID, agent.getId().toString());
		metaData.put(INPUT_KEY, naturalQuery);
		metaData.put("HUMAN_FEEDBACK_CONTENT", humanFeedbackContent);
		metaData.put(NOT_GENERATE_REPORT,true);

		return graphService.nl2sqlResult(naturalQuery, metaData, agent.getId().toString());
	}

}
