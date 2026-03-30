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
package com.alibaba.cloud.ai.dataagent.service.business;

import com.alibaba.cloud.ai.dataagent.dto.knowledge.businessknowledge.CreateBusinessKnowledgeDTO;
import com.alibaba.cloud.ai.dataagent.dto.knowledge.businessknowledge.UpdateBusinessKnowledgeDTO;
import com.alibaba.cloud.ai.dataagent.vo.BusinessKnowledgeVO;

import java.util.List;

// TODO 添加一个分页查询的方法
public interface BusinessKnowledgeService {

	List<BusinessKnowledgeVO> getKnowledge(Integer agentId);

	List<BusinessKnowledgeVO> getAllKnowledge();

	List<BusinessKnowledgeVO> searchKnowledge(Integer agentId, String keyword);

	BusinessKnowledgeVO getKnowledgeById(Integer id);

	BusinessKnowledgeVO addKnowledge(CreateBusinessKnowledgeDTO knowledgeDTO);

	BusinessKnowledgeVO updateKnowledge(Integer id, UpdateBusinessKnowledgeDTO knowledgeDTO);

	void deleteKnowledge(Integer id);

	void recallKnowledge(Integer id, Boolean isRecall);

	void refreshAllKnowledgeToVectorStore(String agentId) throws Exception;

	void retryEmbedding(Integer id);

}
