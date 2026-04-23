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
package com.alibaba.cloud.ai.dataagent.controller;

import com.alibaba.cloud.ai.dataagent.dto.datasource.ToggleDatasourceDTO;
import com.alibaba.cloud.ai.dataagent.dto.datasource.UpdateDatasourceTablesDTO;
import com.alibaba.cloud.ai.dataagent.entity.AgentDatasource;
import com.alibaba.cloud.ai.dataagent.exception.InternalServerException;
import com.alibaba.cloud.ai.dataagent.service.datasource.AgentDatasourceService;
import com.alibaba.cloud.ai.dataagent.vo.ApiResponse;
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
class AgentDatasourceControllerTest {

	@Mock
	private AgentDatasourceService agentDatasourceService;

	private AgentDatasourceController controller;

	@BeforeEach
	void setUp() {
		controller = new AgentDatasourceController(agentDatasourceService);
	}

	@Test
	void initSchema_success_returnsSuccessResponse() {
		AgentDatasource ds = new AgentDatasource();
		ds.setDatasourceId(1);
		ds.setSelectTables(List.of("users", "orders"));
		when(agentDatasourceService.getCurrentAgentDatasource(1)).thenReturn(ds);
		when(agentDatasourceService.initializeSchemaForAgentWithDatasource(1, 1, List.of("users", "orders")))
			.thenReturn(true);

		ApiResponse<?> result = controller.initSchema(1);

		assertTrue(result.isSuccess());
	}

	@Test
	void initSchema_initFails_throwsException() {
		AgentDatasource ds = new AgentDatasource();
		ds.setDatasourceId(1);
		ds.setSelectTables(List.of("users"));
		when(agentDatasourceService.getCurrentAgentDatasource(1)).thenReturn(ds);
		when(agentDatasourceService.initializeSchemaForAgentWithDatasource(1, 1, List.of("users"))).thenReturn(false);

		assertThrows(InternalServerException.class, () -> controller.initSchema(1));
	}

	@Test
	void initSchema_nullDatasourceId_throwsException() {
		AgentDatasource ds = new AgentDatasource();
		ds.setDatasourceId(null);
		ds.setSelectTables(List.of("users"));
		when(agentDatasourceService.getCurrentAgentDatasource(1)).thenReturn(ds);

		assertThrows(InternalServerException.class, () -> controller.initSchema(1));
	}

	@Test
	void initSchema_emptyTables_throwsException() {
		AgentDatasource ds = new AgentDatasource();
		ds.setDatasourceId(1);
		ds.setSelectTables(List.of());
		when(agentDatasourceService.getCurrentAgentDatasource(1)).thenReturn(ds);

		assertThrows(InternalServerException.class, () -> controller.initSchema(1));
	}

	@Test
	void getAgentDatasource_success_returnsDatasources() {
		AgentDatasource ds = new AgentDatasource(1, 1);
		when(agentDatasourceService.getAgentDatasource(1)).thenReturn(List.of(ds));

		ApiResponse<List<AgentDatasource>> result = controller.getAgentDatasource(1);

		assertTrue(result.isSuccess());
		assertEquals(1, result.getData().size());
	}

	@Test
	void getActiveAgentDatasource_success_returnsActiveDatasource() {
		AgentDatasource ds = new AgentDatasource(1, 1);
		when(agentDatasourceService.getCurrentAgentDatasource(1)).thenReturn(ds);

		ApiResponse<AgentDatasource> result = controller.getActiveAgentDatasource(1);

		assertTrue(result.isSuccess());
		assertEquals(1, result.getData().getAgentId());
	}

	@Test
	void addDatasourceToAgent_success_returnsCreatedAssociation() {
		AgentDatasource ds = new AgentDatasource(1, 5);
		when(agentDatasourceService.addDatasourceToAgent(1, 5)).thenReturn(ds);

		ApiResponse<AgentDatasource> result = controller.addDatasourceToAgent(1, 5);

		assertTrue(result.isSuccess());
		assertEquals(5, result.getData().getDatasourceId());
	}

	@Test
	void updateDatasourceTables_success_returnsSuccess() {
		UpdateDatasourceTablesDTO dto = new UpdateDatasourceTablesDTO();
		dto.setDatasourceId(1);
		dto.setTables(List.of("users", "orders"));

		ApiResponse<?> result = controller.updateDatasourceTables(1, dto);

		assertTrue(result.isSuccess());
		verify(agentDatasourceService).updateDatasourceTables(1, 1, List.of("users", "orders"));
	}

	@Test
	void updateDatasourceTables_nullTables_defaultsToEmptyList() {
		UpdateDatasourceTablesDTO dto = new UpdateDatasourceTablesDTO();
		dto.setDatasourceId(1);
		dto.setTables(null);

		ApiResponse<?> result = controller.updateDatasourceTables(1, dto);

		assertTrue(result.isSuccess());
		verify(agentDatasourceService).updateDatasourceTables(1, 1, List.of());
	}

	@Test
	void removeDatasourceFromAgent_success_returnsSuccess() {
		ApiResponse<?> result = controller.removeDatasourceFromAgent(1, 5);

		assertTrue(result.isSuccess());
		verify(agentDatasourceService).removeDatasourceFromAgent(1, 5);
	}

	@Test
	void toggleDatasource_enable_returnsEnabled() {
		ToggleDatasourceDTO dto = new ToggleDatasourceDTO();
		dto.setDatasourceId(1);
		dto.setIsActive(true);
		AgentDatasource ds = new AgentDatasource(1, 1);
		when(agentDatasourceService.toggleDatasourceForAgent(1, 1, true)).thenReturn(ds);

		ApiResponse<AgentDatasource> result = controller.toggleDatasourceForAgent(1, dto);

		assertTrue(result.isSuccess());
		assertNotNull(result.getData());
	}

	@Test
	void toggleDatasource_nullIsActive_throwsException() {
		ToggleDatasourceDTO dto = new ToggleDatasourceDTO();
		dto.setDatasourceId(1);
		dto.setIsActive(null);

		assertThrows(InternalServerException.class, () -> controller.toggleDatasourceForAgent(1, dto));
	}

	@Test
	void toggleDatasource_nullDatasourceId_throwsException() {
		ToggleDatasourceDTO dto = new ToggleDatasourceDTO();
		dto.setDatasourceId(null);
		dto.setIsActive(true);

		assertThrows(InternalServerException.class, () -> controller.toggleDatasourceForAgent(1, dto));
	}

}
