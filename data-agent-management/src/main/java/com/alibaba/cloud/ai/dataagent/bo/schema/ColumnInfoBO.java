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
package com.alibaba.cloud.ai.dataagent.bo.schema;

import com.alibaba.cloud.ai.dataagent.entity.SemanticModel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.StringUtils;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ColumnInfoBO {

	private String name;

	private String tableName;
	/**
	 * 业务名/别名 (例如: 客户满意度分数)
	 */
	private String businessName;

	private String description;

	private String type;

	private boolean primary;

	private boolean notnull;

	private String samples;

	/**
	 * 是否隐藏该字段
	 */
	private boolean hidden = false;

	public String getBusinessName(){
		if (StringUtils.isBlank(this.businessName) && !StringUtils.isBlank(this.description)) {
			if(this.description.length()<16){
				return this.description;
			}
		}
		return this.businessName;
	}

	public String getDescription(){
		if (!StringUtils.isBlank(this.businessName)) {
			if(StringUtils.isBlank(this.description)){
				return this.businessName;
			}
			return this.businessName+" -- "+this.description;
		}
		return this.description;
	}

	public int fillWith(SemanticModel sm){
		int c = 0;
		if(!StringUtils.isBlank(sm.getBusinessName())) {
			if (StringUtils.isBlank(this.businessName)) {
				this.businessName = sm.getBusinessName();
			}
			else if(!this.businessName.equalsIgnoreCase(sm.getBusinessName())){
				this.businessName = this.businessName + ","+ sm.getBusinessName();
			}
			c++;
		}
		if(!StringUtils.isBlank(sm.getSynonyms())) {
			if (StringUtils.isBlank(this.businessName)) {
				this.businessName = sm.getSynonyms();
			}
			else if(!this.businessName.equalsIgnoreCase(sm.getSynonyms())){
				this.businessName = this.businessName + ",同义:"+ sm.getSynonyms();
			}
			c++;
		}
		if(!StringUtils.isBlank(sm.getBusinessDescription())) {
			if (StringUtils.isBlank(this.description)) {
				this.description = sm.getBusinessDescription();
			}
			else if(!this.description.equalsIgnoreCase(sm.getBusinessDescription())){
				this.description = this.description + ";"+ sm.getBusinessDescription();
			}
			c++;
		}
		if(!StringUtils.isBlank(sm.getColumnComment())) {
			if (StringUtils.isBlank(this.description)) {
				this.description = sm.getColumnComment();
			}
			else if(!this.description.equalsIgnoreCase(sm.getColumnComment())){
				this.description = this.description + ";"+ sm.getColumnComment();
			}
			c++;
		}
		if(sm.getStatus()!=null && sm.getStatus()==0){
			this.hidden = true;
		}
		return c;
	}

}
