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
package com.alibaba.cloud.ai.dataagent.mapper;

import com.alibaba.cloud.ai.dataagent.entity.DataClass;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

/**
 * Data Class Mapper Interface
 *
 * @author Alibaba Cloud AI
 */
@Mapper
public interface DataClassMapper {

	@Select("SELECT * FROM data_class WHERE id = #{id}")
	DataClass selectById(@Param("id") String id);

	@Select("SELECT * FROM data_class")
	List<DataClass> selectAll();

	@Insert("""
			INSERT INTO data_class
			    (id, name, status, indexed, stored, keyword)
			VALUES (#{id}, #{name}, #{status}, #{indexed}, #{stored}, #{keyword})
			""")
	@Options(useGeneratedKeys = false, keyProperty = "id", keyColumn = "id")
	int insert(DataClass datacls);

	/**
	 * Update data source by id, only update non-null fields
	 */
	@Update("""
			<script>
			UPDATE data_class
			<set>
			    <if test="name != null">name = #{name},</if>
			    <if test="status != null">status = #{status},</if>
			</set>
			WHERE id = #{id}
			</script>
			""")
	int updateById(DataClass datasource);

	/**
	 * Query data source list by status
	 */
	@Select("SELECT * FROM data_class WHERE status = #{status}")
	List<DataClass> selectByStatus(@Param("status") String status);



	@Select("SELECT COUNT(*) FROM data_class")
	Long selectCount();

	@Delete("DELETE FROM data_class WHERE id = #{id}")
	int deleteById(String id);

}
