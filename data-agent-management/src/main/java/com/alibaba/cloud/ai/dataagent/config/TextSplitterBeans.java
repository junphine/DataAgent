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

import com.alibaba.cloud.ai.dataagent.properties.DataAgentProperties;
import com.alibaba.cloud.ai.dataagent.splitter.LineTextSplitter;
import com.alibaba.cloud.ai.dataagent.splitter.ParagraphTextSplitter;
import com.alibaba.cloud.ai.dataagent.splitter.SemanticTextSplitter;
import com.alibaba.cloud.ai.dataagent.splitter.SentenceSplitter;
import com.alibaba.cloud.ai.transformer.splitter.RecursiveCharacterTextSplitter;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.transformer.splitter.TextSplitter;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class TextSplitterBeans {


    @Bean(name = "token")
    public TextSplitter textSplitter(DataAgentProperties properties) {
        DataAgentProperties.TextSplitter textSplitterProps = properties.getTextSplitter();
        DataAgentProperties.TextSplitter.TokenTextSplitterConfig config = textSplitterProps.getToken();
        return new TokenTextSplitter(textSplitterProps.getChunkSize(), config.getMinChunkSizeChars(),
                config.getMinChunkLengthToEmbed(), config.getMaxNumChunks(), config.isKeepSeparator());
    }

    /**
     * 递归字符文本分块器
     * @param properties 分块配置
     * @return RecursiveCharacterTextSplitter实例
     */
    @Bean(name = "recursive")
    public TextSplitter recursiveTextSplitter(DataAgentProperties properties) {
        DataAgentProperties.TextSplitter textSplitterProps = properties.getTextSplitter();
        DataAgentProperties.TextSplitter.RecursiveTextSplitterConfig config = textSplitterProps.getRecursive();
        // RecursiveCharacterTextSplitter
        String[] separators = config.getSeparators();
        if (separators != null && separators.length > 0) {
            return new RecursiveCharacterTextSplitter(textSplitterProps.getChunkSize(), separators);
        }
        else {
            return new RecursiveCharacterTextSplitter(textSplitterProps.getChunkSize());
        }
    }

    /**
     * 句子分块器
     * @param properties 分块配置
     * @return SentenceSplitter实例
     */
    @Bean(name = "sentence")
    public TextSplitter sentenceSplitter(DataAgentProperties properties) {
        DataAgentProperties.TextSplitter textSplitterConfig = properties.getTextSplitter();
        DataAgentProperties.TextSplitter.SentenceTextSplitterConfig sentenceConfig = textSplitterConfig.getSentence();

        return SentenceSplitter.builder()
                .withChunkSize(textSplitterConfig.getChunkSize())
                .withSentenceOverlap(sentenceConfig.getSentenceOverlap())
                .build();
    }

    /**
     * 语义分块器
     * @param properties 分块配置
     * @param embeddingModel Embedding 模型
     * @return SemanticTextSplitter实例
     */
    @Bean(name = "semantic")
    public TextSplitter semanticSplitter(DataAgentProperties properties, EmbeddingModel embeddingModel) {
        DataAgentProperties.TextSplitter textSplitterProps = properties.getTextSplitter();
        DataAgentProperties.TextSplitter.SemanticTextSplitterConfig config = textSplitterProps.getSemantic();
        return SemanticTextSplitter.builder()
                .embeddingModel(embeddingModel)
                .minChunkSize(config.getMinChunkSize())
                .maxChunkSize(config.getMaxChunkSize())
                .similarityThreshold(config.getSimilarityThreshold())
                .build();
    }

    /**
     * 段落分块器
     * @param properties 分块配置
     * @return ParagraphTextSplitter实例
     */
    @Bean(name = "paragraph")
    public TextSplitter paragraphSplitter(DataAgentProperties properties) {
        DataAgentProperties.TextSplitter textSplitterProps = properties.getTextSplitter();
        DataAgentProperties.TextSplitter.ParagraphTextSplitterConfig config = textSplitterProps.getParagraph();
        return ParagraphTextSplitter.builder()
                .chunkSize(textSplitterProps.getChunkSize())
                .paragraphOverlapChars(config.getParagraphOverlapChars())
                .build();
    }

    /**
     * 段落分块器
     * @param properties 分块配置
     * @return ParagraphTextSplitter实例
     */
    @Bean(name = "line")
    public TextSplitter lineSplitter(DataAgentProperties properties) {
        DataAgentProperties.TextSplitter textSplitterConfig = properties.getTextSplitter();
        DataAgentProperties.TextSplitter.SentenceTextSplitterConfig sentenceConfig = textSplitterConfig.getSentence();

        return LineTextSplitter.builder()
                .withChunkSize(textSplitterConfig.getChunkSize())
                .withSentenceOverlap(sentenceConfig.getSentenceOverlap())
                .build();
    }
}
