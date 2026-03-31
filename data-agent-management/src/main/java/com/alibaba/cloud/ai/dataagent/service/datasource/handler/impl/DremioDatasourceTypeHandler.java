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
package com.alibaba.cloud.ai.dataagent.service.datasource.handler.impl;

import com.alibaba.cloud.ai.dataagent.entity.Datasource;
import com.alibaba.cloud.ai.dataagent.enums.BizDataSourceTypeEnum;
import com.alibaba.cloud.ai.dataagent.service.datasource.handler.DatasourceTypeHandler;
import org.springframework.stereotype.Component;

@Component
public class DremioDatasourceTypeHandler implements DatasourceTypeHandler {

	@Override
	public String typeName() {
		return BizDataSourceTypeEnum.DREMIO.getTypeName();
	}

	@Override
	public String buildConnectionUrl(Datasource datasource) {
		if (!hasRequiredConnectionFields(datasource)) {
			return datasource.getConnectionUrl();
		}
		// 提取数据库名（format: "database|schema"，只取database部分）
		String spaceName = extractSchemaName(datasource);
		//"jdbc:arrow-flight-sql://data.dremio.cloud:443/?token=your_encoded_PAT_here&catalog=your_project_id&schema=Samples";

		return String.format(
				"jdbc:arrow-flight-sql://%s:%d/%s?token=%s&schema=%s",
				datasource.getHost(), datasource.getPort(), datasource.getPassword(),spaceName);
	}

	@Override
	public String extractSchemaName(Datasource datasource) {
		// 提取schema名（format: "database|schema"，取schema部分）
		String databaseName = datasource.getDatabaseName();
		if (databaseName != null && databaseName.contains("|")) {
			String[] parts = databaseName.split("\\|");
			return parts.length > 1 ? parts[1] : parts[0];
		}
		return databaseName;
	}

}
