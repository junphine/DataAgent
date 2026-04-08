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


import com.alibaba.cloud.ai.dataagent.dto.GraphRequest;
import com.alibaba.cloud.ai.dataagent.entity.Agent;
import com.alibaba.cloud.ai.dataagent.service.graph.GraphService;
import com.alibaba.cloud.ai.dataagent.util.FluxUtil;
import com.alibaba.cloud.ai.dataagent.util.JsonUtil;
import com.alibaba.cloud.ai.dataagent.vo.ChatResponse;
import com.alibaba.cloud.ai.dataagent.vo.GraphNodeResponse;
import com.alibaba.cloud.ai.graph.NodeOutput;
import com.alibaba.cloud.ai.graph.OverAllState;
import com.alibaba.cloud.ai.graph.exception.GraphRunnerException;
import com.fasterxml.jackson.annotation.JsonPropertyDescription;
import com.fasterxml.jackson.core.JsonProcessingException;
import io.modelcontextprotocol.spec.McpSchema;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springaicommunity.mcp.annotation.McpTool;
import org.springaicommunity.mcp.annotation.McpToolParam;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static com.alibaba.cloud.ai.dataagent.constant.Constant.*;

// 封装Mcp 服务
@Slf4j
@AllArgsConstructor
public class McpAgentService {

	private final Agent agent;

	private final GraphService graphService;

	public String nl2SqlToolCallback(String naturalQuery) throws GraphRunnerException {
		Assert.hasText(naturalQuery, "Natural query cannot be empty");
		return graphService.nl2sql(naturalQuery, agent.getId().toString());
	}

	@McpTool(name="nl2sql2data-agent",description = "获取企业各方面的内部数据，将自然语言查询转换为SQL语句，然后再执行这个语句获取数据。")
	public ChatResponse nl2Sql2DataToolCallback(@McpToolParam(description="自然语言查询描述") String naturalQuery,
												@McpToolParam(description="多轮对话中用户的反馈信息",required=false) String humanFeedbackContent,
												@McpToolParam(description="不生成报告",required=false) Boolean nl2sqlOnly,
												@McpToolParam(description="返回最大结果数",required=false) Integer limit,
												@McpToolParam(description="支持多轮对话时，需要传入当前对话的sessionId",required=false) String sessionId
												) throws GraphRunnerException{
		Assert.hasText(naturalQuery, "Natural query cannot be empty");
		String[] parts = naturalQuery.split(" // ");
		if(parts.length==2 && humanFeedbackContent==null){
			naturalQuery = parts[0];
			humanFeedbackContent = parts[1];
		}
		Map<String,Object> metaData = new HashMap<>();
		metaData.put(IS_ONLY_NL2SQL, nl2sqlOnly == null || nl2sqlOnly);
		metaData.put(AGENT_ID, agent.getId().toString());
		metaData.put(INPUT_KEY, naturalQuery);
		metaData.put("HUMAN_FEEDBACK_CONTENT", humanFeedbackContent);
		metaData.put(ONLY_DATA_LIMIT,limit); // 结果数
		metaData.put(TRACE_THREAD_ID,sessionId);

		return graphService.nl2sqlResult(naturalQuery, metaData, agent.getId().toString());
	}

	// Flux<ServerSentEvent<ChatResponse>> Mono<McpSchema.TextContent>

	@McpTool(name="nl2sql2data-async-agent", title="自然语言进行数据查询",description = "获取企业各方面的内部数据，将自然语言查询转换为SQL语句，然后再执行这个语句获取数据。")
	public List<ChatResponse> streamResultSet(
			 String naturalQuery,
			 String humanFeedbackContent,
			 Boolean nl2sqlOnly,Integer limit,String sessionId) {

		Sinks.Many<ServerSentEvent<GraphNodeResponse>> sink = Sinks.many().unicast().onBackpressureBuffer();
		boolean humanFeedback = humanFeedbackContent!=null && !humanFeedbackContent.isBlank();
		boolean rejectedPlan = false;
		boolean bNl2sqlOnly = nl2sqlOnly == null || nl2sqlOnly;
		final String threadId = sessionId!=null?sessionId:UUID.randomUUID().toString();

		GraphRequest request = GraphRequest.builder()
				.agentId(agent.getId().toString())
				.threadId(threadId)
				.query(naturalQuery)
				.humanFeedback(humanFeedback)
				.humanFeedbackContent(humanFeedbackContent)
				.rejectedPlan(rejectedPlan)
				.nl2sqlOnly(bNl2sqlOnly)
				.dataOnly(limit)
				.build();

		Flux<NodeOutput> nodeOutput = graphService.graphStreamProcess(sink, request);
		ChatResponse resp = toChatResponse(nodeOutput.blockLast());
		resp.setSessionId(threadId);
		return List.of(resp);
		/*
		long timestamp = System.currentTimeMillis();
		ServerSentEvent event = ServerSentEvent.builder(resp)
				.id(String.valueOf(timestamp))
				.event("streamResultSet")
				.build();
		return Flux.just(event);
		*/
		/**
		return nodeOutput.last().map((x)->{
			return toChatResponse(x);
		}).map(resp->{
			resp.setSessionId(threadId);
			try {
				return new McpSchema.TextContent(JsonUtil.getObjectMapper().writeValueAsString(resp));
			} catch (JsonProcessingException e) {
				return new McpSchema.TextContent("error: "+e.getMessage());
			}
		});
		 */
	}

	private ChatResponse toChatResponse(NodeOutput x){
		ChatResponse output = new ChatResponse();
		if(x==null){
			output.setMessageType("error");
			output.setMessage("Data agent not find anything!");
			return output;
		}
		OverAllState state = x.state();
		String sql = state.value(SQL_GENERATE_OUTPUT, "");
		output.setSql(sql);

		Map<String,Object> sqlStatements = state.value(SQL_EXECUTE_SQL_OUTPUT,Map.class).orElse(null);
		if(sqlStatements!=null && sqlStatements.size()>1){
			try {
				output.setSql(JsonUtil.getObjectMapper().writeValueAsString(sqlStatements));
			} catch (JsonProcessingException e) {
				e.printStackTrace();
			}
		}

		Map<String,Object> sqlOutput = state.value(SQL_EXECUTE_NODE_OUTPUT,Map.class).orElse(null);
		Object codeOutput = state.value(PYTHON_ANALYSIS_NODE_OUTPUT).orElse(null);
		if(sqlOutput!=null && codeOutput!=null){
			sqlOutput.put("pythonCodeOutput",codeOutput);
		}
		if(sqlOutput!=null){
			try {
				output.setResult(JsonUtil.getObjectMapper().writeValueAsString(sqlOutput));
			} catch (JsonProcessingException e) {
				e.printStackTrace();
			}
		}
		else {
			output.setMessageType("error");
			String scOutput = state.value(SEMANTIC_CONSISTENCY_NODE_OUTPUT, "");
			output.setMessage(scOutput);
		}
		return output;
	}

}
