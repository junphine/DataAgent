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
package com.alibaba.cloud.ai.dataagent.service.agent;

import com.alibaba.cloud.ai.dataagent.constant.DocumentMetadataConstant;
import com.alibaba.cloud.ai.dataagent.entity.AgentPresetQuestion;
import com.alibaba.cloud.ai.dataagent.mapper.AgentPresetQuestionMapper;
import com.alibaba.cloud.ai.dataagent.service.vectorstore.AgentVectorStoreService;
import com.alibaba.cloud.ai.dataagent.util.DocumentConverterUtil;
import lombok.AllArgsConstructor;
import org.springframework.ai.document.Document;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * AgentPresetQuestion Service Class
 */
@Service
@AllArgsConstructor
public class AgentPresetQuestionServiceImpl implements AgentPresetQuestionService {

	private final AgentPresetQuestionMapper agentPresetQuestionMapper;

	private final AgentVectorStoreService agentVectorStoreService;

	@Override
	public List<AgentPresetQuestion> findByAgentId(Long agentId) {
		return agentPresetQuestionMapper.selectByAgentId(agentId);
	}

	@Override
	public List<AgentPresetQuestion> findAllByAgentId(Long agentId) {
		return agentPresetQuestionMapper.selectAllByAgentId(agentId);
	}

	@Override
	public AgentPresetQuestion create(AgentPresetQuestion question) {
		// Ensure default values
		if (question.getSortOrder() == null) {
			question.setSortOrder(0);
		}
		if (question.getIsActive() == null) {
			question.setIsActive(true);
		}

		agentPresetQuestionMapper.insert(question);
		return question; // ID will be auto-filled by MyBatis
	}

	@Override
	public void update(Long id, AgentPresetQuestion question) {
		question.setId(id); // Ensure the ID is set
		agentPresetQuestionMapper.update(question);
	}

	@Override
	public void deleteById(Long id) {
		agentPresetQuestionMapper.deleteById(id);
	}

	@Override
	public void deleteByAgentId(Long agentId) {
		agentPresetQuestionMapper.deleteByAgentId(agentId);
	}

	@Override
	public void batchSave(Long agentId, List<AgentPresetQuestion> questions) {
		// Step 1: Delete all existing preset questions for the agent
		deleteByAgentId(agentId);

		// Step 2: Insert new questions with proper order and active status
		for (int i = 0; i < questions.size(); i++) {
			AgentPresetQuestion question = questions.get(i);
			question.setAgentId(agentId);
			question.setSortOrder(i);
			if (question.getIsActive() == null) {
				question.setIsActive(true);
			}
			create(question); // Reuses create() which sets defaults and inserts
		}
	}

	@Override
	public void updateRecallStatus(Long id, Boolean isRecall) {
		// 从数据库获取原始数据
		AgentPresetQuestion knowledge = agentPresetQuestionMapper.selectById(id);
		if (knowledge == null) {
			throw new RuntimeException("Preset question not found with id: " + id);
		}
		// 更新数据库即可，不需要更新向量库，混合检索的的时候DynamicFilterService会根据 isRecall 字段过滤了
		knowledge.setIsRecall(isRecall);
		agentPresetQuestionMapper.updateById(knowledge);
	}

	@Override
	public void refreshAllQAToVectorStore(Long agentId) throws Exception {
		agentVectorStoreService.deleteDocumentsByVectorType(agentId.toString(), DocumentMetadataConstant.AGENT_KNOWLEDGE);

		// 获取所有 isRecall 等于 1 且未逻辑删除的 BusinessKnowledge
		List<AgentPresetQuestion> questions = findByAgentId(agentId);
		List<AgentPresetQuestion> recalledQuestions = questions.stream()
				.filter(knowledge -> knowledge.getIsRecall() != null && knowledge.getIsRecall())
				.filter(knowledge -> knowledge.getAgentId() != null)
				.filter(knowledge -> agentId.equals(knowledge.getAgentId()))
				.toList();

		// 转换为 Document 并插入到 vectorStore
		if (!recalledQuestions.isEmpty()) {
			List<Document> documents = recalledQuestions.stream()
					.map(DocumentConverterUtil::convertQaFaqKnowledgeToDocument)
					.toList();
			agentVectorStoreService.addDocuments(agentId.toString(), documents);
		}
	}

}
