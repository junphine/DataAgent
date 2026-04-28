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
package com.alibaba.cloud.ai.dataagent.config;

import org.apache.ibatis.session.AutoMappingBehavior;
import org.apache.ibatis.type.BooleanTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandlerRegistry;

import org.mybatis.spring.annotation.MapperScan;

import org.mybatis.spring.boot.autoconfigure.ConfigurationCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("com.alibaba.cloud.ai.dataagent.mapper")
public class MyBatisTypeHandlerConfig {
    @Bean
    public ConfigurationCustomizer mybatisConfigurationCustomizer() {
        return configuration->{
            // 注册 TypeHandler
            TypeHandlerRegistry registry = configuration.getTypeHandlerRegistry();
            // 全局注册 Boolean 类型处理器
            registry.register(Boolean.class, new BooleanToSmallIntHandler());
            registry.register(boolean.class, new BooleanToSmallIntHandler());

            registry.register(Boolean.class, JdbcType.BOOLEAN, new BooleanTypeHandler());
            registry.register(boolean.class, JdbcType.BOOLEAN, new BooleanTypeHandler());


            configuration.setMapUnderscoreToCamelCase(true);
            configuration.setAutoMappingBehavior(AutoMappingBehavior.FULL);

        };
    }
}
