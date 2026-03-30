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
package com.alibaba.cloud.ai.dataagent.service.knowledge;

import com.alibaba.cloud.ai.dataagent.constant.Constant;
import com.alibaba.cloud.ai.dataagent.constant.DocumentMetadataConstant;
import com.alibaba.cloud.ai.dataagent.enums.KnowledgeType;
import com.alibaba.cloud.ai.dataagent.util.DocumentConverterUtil;
import com.alibaba.cloud.ai.dataagent.entity.AgentKnowledge;
import com.alibaba.cloud.ai.dataagent.service.file.FileStorageService;
import com.alibaba.cloud.ai.dataagent.service.vectorstore.AgentVectorStoreService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.ai.document.Document;
import org.springframework.ai.reader.tika.TikaDocumentReader;
import org.springframework.ai.transformer.splitter.TextSplitter;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.*;

// 智能体知识的向量资源和文件资源管理
@Slf4j
@Component
public class AgentKnowledgeResourceManager {

	private final TextSplitterFactory textSplitterFactory;

	private final FileStorageService fileStorageService;

	private final AgentVectorStoreService agentVectorStoreService;

	public AgentKnowledgeResourceManager(TextSplitterFactory textSplitterFactory, FileStorageService fileStorageService,
			AgentVectorStoreService agentVectorStoreService) {
		this.textSplitterFactory = textSplitterFactory;
		this.fileStorageService = fileStorageService;
		this.agentVectorStoreService = agentVectorStoreService;
	}

	public void doEmbedingToVectorStore(AgentKnowledge agentKnowledge) throws Exception {
		// delete old data
		this.deleteFromVectorStore(agentKnowledge.getAgentId(), agentKnowledge.getId());

		if (KnowledgeType.QA.equals(agentKnowledge.getType()) || KnowledgeType.FAQ.equals(agentKnowledge.getType())) {
			processQaKnowledge(agentKnowledge);
		}
		else if (KnowledgeType.DOCUMENT.equals(agentKnowledge.getType())) {
			processDocumentKnowledge(agentKnowledge);
		}
		else {
			throw new RuntimeException("Unsupported KnowledgeType: " + agentKnowledge.getType());
		}
	}

	private void processQaKnowledge(AgentKnowledge knowledge) {
		Document document = DocumentConverterUtil.convertQaFaqKnowledgeToDocument(knowledge);
		agentVectorStoreService.addDocuments(knowledge.getAgentId().toString(), List.of(document));
		log.info("Successfully vectorized AgentKnowledge: id={}, type={}", knowledge.getId(), knowledge.getType());
	}

	private void processDocumentKnowledge(AgentKnowledge knowledge) {

		// 处理文档
		List<Document> documents = getAndSplitDocument(knowledge.getFilePath(), knowledge.getSplitterType());
		if (documents == null || documents.isEmpty()) {
			log.error("No documents extracted from file: knowledgeId={}, filePath={}", knowledge.getId(),
					knowledge.getFilePath());
			throw new RuntimeException("No documents extracted from file");
		}

		// 使用工具类为文档添加元数据
		List<Document> documentsWithMetadata = DocumentConverterUtil
			.convertAgentKnowledgeDocumentsWithMetadata(documents, knowledge);

		// 添加到向量存储
		agentVectorStoreService.addDocuments(knowledge.getAgentId().toString(), documentsWithMetadata);
		log.info("Successfully vectorized DOCUMENT knowledge: id={}, filePath={}, documentCount={}, splitterType={}",
				knowledge.getId(), knowledge.getFilePath(), documentsWithMetadata.size(), knowledge.getSplitterType());

	}

	private List<Document> getAndSplitDocument(String filePath, String splitterType) {
		// 使用FileStorageService获取文件资源对象
		Resource resource = fileStorageService.getFileResource(filePath);

		if(filePath.endsWith(".csv") && splitterType.equals("line")){
			return readCsvDocuments(resource,true);
		}

		// 使用TikaDocumentReader读取文件
		TikaDocumentReader tikaDocumentReader = new TikaDocumentReader(resource);
		List<Document> documents = tikaDocumentReader.read();

		// 根据splitterType获取对应的分块器
		TextSplitter splitter = textSplitterFactory.getSplitter(splitterType);
		log.info("Using splitter type: {} for document splitting", splitterType);

		return splitter.apply(documents);
	}


	/**
	 * 读取 CSV 文件，每行生成一个 Document
	 * @param resource CSV 文件资源
	 * @param hasHeader 是否有表头
	 * @return Document 列表
	 */
	public List<Document> readCsvDocuments(Resource resource, boolean hasHeader) {
		List<Document> documents = new ArrayList<>();
		List<String> headers = null;

		try (InputStreamReader reader = new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8);
			 CSVParser csvParser = CSVParser.parse(reader, CSVFormat.DEFAULT.builder()
					 .setHeader()
					 .setSkipHeaderRecord(hasHeader)
					 .get())) {

			// 获取表头
			headers = csvParser.getHeaderNames();

			// 遍历每一行
			int rowNumber = 0;
			for (CSVRecord record : csvParser) {
				rowNumber++;

				// 构建 Document 内容
				StringBuilder contentBuilder = new StringBuilder();
				Map<String, Object> metadata = new HashMap<>();

				// 添加行号到 metadata
				metadata.put("row_number", rowNumber);

				// 处理每一列
				for (String header : headers) {
					String value = record.get(header);

					// 将列信息添加到内容中
					if (contentBuilder.length() > 0) {
						contentBuilder.append(", ");
					}
					contentBuilder.append(header).append(": ").append(value);

					// 同时将每个字段也存储到 metadata 中，方便后续检索
					metadata.put(header, value);
				}

				// 创建 Document
				Document document = new Document(contentBuilder.toString(), metadata);
				documents.add(document);
			}

		} catch (Exception e) {
			throw new RuntimeException("Failed to read CSV file: " + resource.getFilename(), e);
		}

		return documents;
	}


	/**
	 * 从向量存储中删除知识
	 * @param agentId 代理ID
	 * @param knowledgeId 知识ID
	 * @return 是否删除成功（如果资源不存在也视为成功，实现等幂操作）
	 */
	public boolean deleteFromVectorStore(Integer agentId, Integer knowledgeId) {
		try {

			Map<String, Object> metadata = new HashMap<>();
			metadata.put(Constant.AGENT_ID, agentId);
			metadata.put(DocumentMetadataConstant.DB_AGENT_KNOWLEDGE_ID, knowledgeId);

			agentVectorStoreService.deleteDocumentsByMetedata(agentId.toString(), metadata);
			log.info("Successfully deleted knowledge from vector store, knowledgeId: {}", knowledgeId);
			return true;

		}
		catch (Exception e) {
			// 检查是否是资源不存在的错误，如果是则视为删除成功（等幂操作）
			if (e.getMessage() != null && (e.getMessage().contains("not found")
					|| e.getMessage().contains("does not exist") || e.getMessage().contains("already deleted"))) {
				log.info("Vector data already deleted or not found for knowledgeId: {}, treating as success",
						knowledgeId);
				return true;
			}
			else {
				log.error("Failed to delete knowledge from vector store, knowledgeId: {}", knowledgeId, e);
				return false;
			}
		}
	}

	/**
	 * 删除知识文件
	 * @param knowledge 知识对象
	 * @return 是否删除成功（如果不是文档类型或文件不存在也视为成功）
	 */
	public boolean deleteKnowledgeFile(AgentKnowledge knowledge) {
		// 只有文档类型且有文件路径的知识才需要删除文件
		if (!KnowledgeType.DOCUMENT.equals(knowledge.getType()) || !StringUtils.hasText(knowledge.getFilePath())) {
			log.info("Not a document type or no file path, knowledgeId: {}, treating as success", knowledge.getId());
			return true;
		}

		try {
			boolean fileDeleted = fileStorageService.deleteFile(knowledge.getFilePath());
			if (fileDeleted) {
				log.info("Successfully deleted knowledge file, filePath: {}", knowledge.getFilePath());
				return true;
			}
			else {
				log.error("Failed to delete knowledge file, filePath: {}", knowledge.getFilePath());
				return false;
			}

		}
		catch (Exception e) {
			// 检查是否是文件不存在的错误，如果是则视为删除成功（等幂操作）
			if (e.getMessage() != null
					&& (e.getMessage().contains("not found") || e.getMessage().contains("does not exist")
							|| e.getMessage().contains("already deleted") || e.getMessage().contains("No such file"))) {
				log.info("File already deleted or not found, filePath: {}, treating as success",
						knowledge.getFilePath());
				return true;
			}
			else {
				log.error("Exception when deleting knowledge file, filePath: {}", knowledge.getFilePath(), e);
				return false;
			}
		}
	}

}
