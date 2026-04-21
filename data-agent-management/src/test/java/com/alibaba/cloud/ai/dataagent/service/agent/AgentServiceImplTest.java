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

import com.alibaba.cloud.ai.dataagent.entity.Agent;
import com.alibaba.cloud.ai.dataagent.mapper.AgentMapper;
import com.alibaba.cloud.ai.dataagent.service.file.FileStorageService;
import com.alibaba.cloud.ai.dataagent.service.vectorstore.AgentVectorStoreService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AgentServiceImplTest {

	private AgentServiceImpl agentService;

	@Mock
	private AgentMapper agentMapper;

	@Mock
	private AgentVectorStoreService agentVectorStoreService;

	@Mock
	private FileStorageService fileStorageService;

	@BeforeEach
	void setUp() {
		agentService = new AgentServiceImpl(agentMapper, agentVectorStoreService, fileStorageService);
	}

	@Test
	void findAll_returnsList() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findAll()).thenReturn(List.of(agent));

		assertEquals(1, agentService.findAll().size());
	}

	@Test
	void findById_returnsAgent() {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setName("test");
		when(agentMapper.findById(1)).thenReturn(agent);

		assertEquals("test", agentService.findById(1).getName());
	}

	@Test
	void findByStatus_returnsList() {
		when(agentMapper.findByStatus("active")).thenReturn(List.of(new Agent()));

		assertEquals(1, agentService.findByStatus("active").size());
	}

	@Test
	void search_returnsList() {
		when(agentMapper.searchByKeyword("test")).thenReturn(List.of(new Agent()));

		assertEquals(1, agentService.search("test").size());
	}

	@Test
	void save_newAgent_insertsWithDefaults() {
		Agent agent = new Agent();

		agentService.save(agent);

		assertNotNull(agent.getCreateTime());
		assertNotNull(agent.getUpdateTime());
		assertEquals(0, agent.getApiKeyEnabled());
		verify(agentMapper).insert(agent);
	}

	@Test
	void save_existingAgent_updates() {
		Agent agent = new Agent();
		agent.setId(1);

		agentService.save(agent);

		assertNotNull(agent.getUpdateTime());
		verify(agentMapper).updateById(agent);
	}

	@Test
	void deleteById_deletesAgentAndCleansUp() throws Exception {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setAvatar("avatar.png");
		when(agentMapper.findById(1)).thenReturn(agent);

		agentService.deleteById(1);

		verify(agentMapper).deleteById(1);
		verify(agentVectorStoreService).deleteDocumentsByMetadata(eq("1"), any());
		verify(fileStorageService).deleteFile("avatar.png");
	}

	@Test
	void deleteById_vectorCleanupFails_doesNotThrow() throws Exception {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);
		doThrow(new RuntimeException("vector error")).when(agentVectorStoreService)
			.deleteDocumentsByMetadata(anyString(), any());

		assertDoesNotThrow(() -> agentService.deleteById(1));
		verify(agentMapper).deleteById(1);
	}

	@Test
	void generateApiKey_setsKeyAndEnabled() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);

		Agent result = agentService.generateApiKey(1);

		assertNotNull(result.getApiKey());
		assertEquals(1, result.getApiKeyEnabled());
		verify(agentMapper).updateApiKey(eq(1), anyString(), eq(1));
	}

	@Test
	void deleteApiKey_clearsKeyAndDisables() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);

		Agent result = agentService.deleteApiKey(1);

		assertNull(result.getApiKey());
		assertEquals(0, result.getApiKeyEnabled());
		verify(agentMapper).updateApiKey(1, null, 0);
	}

	@Test
	void toggleApiKey_enablesKey() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);

		Agent result = agentService.toggleApiKey(1, true);

		assertEquals(1, result.getApiKeyEnabled());
		verify(agentMapper).toggleApiKey(1, 1);
	}

	@Test
	void getApiKeyMasked_returnsNullWhenNoKey() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);

		assertNull(agentService.getApiKeyMasked(1));
	}

	@Test
	void getApiKeyMasked_returnsMaskedKey() {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setApiKey("da-abcdefghijklmnop");
		when(agentMapper.findById(1)).thenReturn(agent);

		String masked = agentService.getApiKeyMasked(1);
		assertNotNull(masked);
		assertTrue(masked.contains("****"));
	}

	@Test
	void requireAgent_notFound_throwsException() {
		when(agentMapper.findById(99)).thenReturn(null);

		assertThrows(IllegalArgumentException.class, () -> agentService.generateApiKey(99));
	}

	@Test
	void save_newAgent_withApiKeyEnabledSet_preservesValue() {
		Agent agent = new Agent();
		agent.setApiKeyEnabled(1);

		agentService.save(agent);

		assertEquals(1, agent.getApiKeyEnabled());
		verify(agentMapper).insert(agent);
	}

	@Test
	void save_existingAgent_withNullApiKeyEnabled_setsDefault() {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setApiKeyEnabled(null);

		agentService.save(agent);

		assertEquals(0, agent.getApiKeyEnabled());
		verify(agentMapper).updateById(agent);
	}

	@Test
	void resetApiKey_delegatesToGenerateApiKey() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);

		Agent result = agentService.resetApiKey(1);

		assertNotNull(result.getApiKey());
		assertEquals(1, result.getApiKeyEnabled());
		verify(agentMapper).updateApiKey(eq(1), anyString(), eq(1));
	}

	@Test
	void toggleApiKey_disablesKey() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);

		Agent result = agentService.toggleApiKey(1, false);

		assertEquals(0, result.getApiKeyEnabled());
		verify(agentMapper).toggleApiKey(1, 0);
	}

	@Test
	void getApiKeyMasked_blankKey_returnsNull() {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setApiKey("   ");
		when(agentMapper.findById(1)).thenReturn(agent);

		assertNull(agentService.getApiKeyMasked(1));
	}

	@Test
	void deleteById_noAvatar_skipsAvatarCleanup() {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setAvatar(null);
		when(agentMapper.findById(1)).thenReturn(agent);

		agentService.deleteById(1);

		verify(agentMapper).deleteById(1);
		verify(fileStorageService, never()).deleteFile(anyString());
	}

	@Test
	void deleteById_blankAvatar_skipsAvatarCleanup() {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setAvatar("   ");
		when(agentMapper.findById(1)).thenReturn(agent);

		agentService.deleteById(1);

		verify(fileStorageService, never()).deleteFile(anyString());
	}

	@Test
	void deleteById_avatarCleanupFails_doesNotThrow() {
		Agent agent = new Agent();
		agent.setId(1);
		agent.setAvatar("avatar.png");
		when(agentMapper.findById(1)).thenReturn(agent);
		doThrow(new RuntimeException("file error")).when(fileStorageService).deleteFile("avatar.png");

		assertDoesNotThrow(() -> agentService.deleteById(1));
		verify(agentMapper).deleteById(1);
	}

	@Test
	void deleteById_agentNotFoundInDb_stillDeletes() {
		when(agentMapper.findById(1)).thenReturn(null);

		agentService.deleteById(1);

		verify(agentMapper).deleteById(1);
	}

	@Test
	void deleteById_mapperThrows_propagatesException() {
		Agent agent = new Agent();
		agent.setId(1);
		when(agentMapper.findById(1)).thenReturn(agent);
		doThrow(new RuntimeException("db error")).when(agentMapper).deleteById(1);

		assertThrows(RuntimeException.class, () -> agentService.deleteById(1));
	}

	@Test
	void deleteApiKey_notFound_throwsException() {
		when(agentMapper.findById(99)).thenReturn(null);

		assertThrows(IllegalArgumentException.class, () -> agentService.deleteApiKey(99));
	}

	@Test
	void toggleApiKey_notFound_throwsException() {
		when(agentMapper.findById(99)).thenReturn(null);

		assertThrows(IllegalArgumentException.class, () -> agentService.toggleApiKey(99, true));
	}

	@Test
	void getApiKeyMasked_notFound_throwsException() {
		when(agentMapper.findById(99)).thenReturn(null);

		assertThrows(IllegalArgumentException.class, () -> agentService.getApiKeyMasked(99));
	}

}
