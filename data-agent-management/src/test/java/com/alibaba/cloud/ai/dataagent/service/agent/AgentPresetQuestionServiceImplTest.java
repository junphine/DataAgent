/*
 * Copyright 2026 the original author or authors.
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

import com.alibaba.cloud.ai.dataagent.entity.AgentPresetQuestion;
import com.alibaba.cloud.ai.dataagent.mapper.AgentPresetQuestionMapper;
import com.alibaba.cloud.ai.dataagent.service.vectorstore.AgentVectorStoreService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AgentPresetQuestionServiceImplTest {

	private AgentPresetQuestionServiceImpl service;

	@Mock
	private AgentPresetQuestionMapper mapper;

	@Mock
	AgentVectorStoreService agentVectorStoreService;

	@BeforeEach
	void setUp() {
		service = new AgentPresetQuestionServiceImpl(mapper,agentVectorStoreService);
	}

	@Test
	void testFindByAgentId() {
		AgentPresetQuestion q = new AgentPresetQuestion();
		when(mapper.selectByAgentId(1)).thenReturn(List.of(q));

		List<AgentPresetQuestion> result = service.findByAgentId(1);
		assertEquals(1, result.size());
	}

	@Test
	void testFindAllByAgentId() {
		when(mapper.selectAllByAgentId(1)).thenReturn(List.of());

		List<AgentPresetQuestion> result = service.findAllByAgentId(1);
		assertTrue(result.isEmpty());
	}

	@Test
	void testCreate_setsDefaults() {
		AgentPresetQuestion q = new AgentPresetQuestion();

		service.create(q);

		assertEquals(0, q.getSortOrder());
		assertTrue(q.getIsActive());
		verify(mapper).insert(q);
	}

	@Test
	void testCreate_preservesExistingValues() {
		AgentPresetQuestion q = new AgentPresetQuestion();
		q.setSortOrder(5);
		q.setIsActive(false);

		service.create(q);

		assertEquals(5, q.getSortOrder());
		assertFalse(q.getIsActive());
		verify(mapper).insert(q);
	}

	@Test
	void testUpdate() {
		AgentPresetQuestion q = new AgentPresetQuestion();
		service.update(10, q);

		assertEquals(10, q.getId());
		verify(mapper).update(q);
	}

	@Test
	void testDeleteById() {
		service.deleteById(10);
		verify(mapper).deleteById(10);
	}

	@Test
	void testDeleteByAgentId() {
		service.deleteByAgentId(1);
		verify(mapper).deleteByAgentId(1);
	}

	@Test
	void testBatchSave() {
		AgentPresetQuestion q1 = new AgentPresetQuestion();
		q1.setQuestion("q1");
		AgentPresetQuestion q2 = new AgentPresetQuestion();
		q2.setQuestion("q2");

		service.batchSave(1, List.of(q1, q2));

		verify(mapper).deleteByAgentId(1);

		ArgumentCaptor<AgentPresetQuestion> captor = ArgumentCaptor.forClass(AgentPresetQuestion.class);
		verify(mapper, times(2)).insert(captor.capture());

		List<AgentPresetQuestion> inserted = captor.getAllValues();
		assertEquals(1, inserted.get(0).getAgentId());
		assertEquals(0, inserted.get(0).getSortOrder());
		assertEquals(1, inserted.get(1).getAgentId());
		assertEquals(1, inserted.get(1).getSortOrder());
	}

	@Test
	void testBatchSave_emptyList() {
		service.batchSave(1, List.of());
		verify(mapper).deleteByAgentId(1);
		verify(mapper, never()).insert(any());
	}

}
