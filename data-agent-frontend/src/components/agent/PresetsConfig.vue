<!--
 * Copyright 2025 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
-->

<template>
  <div style="padding: 20px">
    <div style="margin-bottom: 20px">
      <h2>预设问题管理</h2>
    </div>
    <el-divider />

    <div style="margin-bottom: 30px">
      <el-row style="display: flex; justify-content: space-between; align-items: center">
        <el-col :span="12">
          <h3>预设问题列表</h3>
        </el-col>
        <el-col :span="12" style="text-align: right">
          <el-button
            @click="refreshVectorStore"
            v-if="!refreshLoading"
            size="large"
            type="success"
            round
            :icon="Document"
          >
            同步到向量库
          </el-button>
          <el-button @click="openCreateDialog" size="large" type="primary" round :icon="Plus">
            添加问题
          </el-button>
        </el-col>
      </el-row>
    </div>

    <el-table :data="presetQuestionList" style="width: 100%" border>
      <el-table-column prop="id" label="ID" min-width="60px" />
      <el-table-column prop="question" label="问题" min-width="250px" show-overflow-tooltip />
      <el-table-column prop="sortOrder" label="排序" min-width="80px" />
      <el-table-column label="状态" min-width="80px">
        <template #default="scope">
          <el-tag :type="scope.row.isActive ? 'success' : 'info'" round>
            {{ scope.row.isActive ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="是否召回" min-width="80px">
        <template #default="scope">
        <el-tag :type="scope.row.isRecall ? 'success' : 'info'" round>
          {{ scope.row.isRecall ? '已召回' : '禁用' }}
        </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" min-width="150px" />
      <el-table-column label="操作" min-width="200px">
        <template #default="scope">
          <el-button @click="editQuestion(scope.row)" size="small" type="primary" round plain>
            编辑
          </el-button>
           <el-button
              v-if="scope.row.isRecall"
              @click="toggleRecall(scope.row, false)"
              size="small"
              type="warning"
              round
              plain
            >
              取消召回
            </el-button>
            <el-button
              v-if="scope.row.answer && !scope.row.isRecall"
              @click="toggleRecall(scope.row, true)"
              size="small"
              type="success"
              round
              plain
            >
              设为召回
          </el-button>
          <el-button @click="deleteQuestion(scope.row)" size="small" type="danger" round plain>
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>

  <!-- 添加/编辑预设问题Dialog -->
  <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑预设问题' : '添加预设问题'" width="600">
    <el-form :model="questionForm" label-width="80px" ref="questionFormRef">
      <el-form-item label="问题" prop="question" required>
        <el-input
          v-model="questionForm.question"
          type="textarea"
          :rows="4"
          placeholder="请输入预设问题"
        />
      </el-form-item>

      <el-form-item label="排序" prop="sortOrder">
        <el-input-number v-model="questionForm.sortOrder" :min="0" controls-position="right" />
      </el-form-item>

      <el-form-item label="状态" prop="isActive">
        <el-switch v-model="questionForm.isActive" />
      </el-form-item>

      <el-form-item label="答案" prop="answer">
        <el-input v-model="questionForm.answer"
          type="textarea"
          :rows="6"
          placeholder="请输入回答预设问题的SQL语句，可以留空"
        />
      </el-form-item>

    </el-form>

    <template #footer>
      <div style="text-align: right">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveQuestion">
          {{ isEdit ? '更新' : '创建' }}
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script lang="ts">
  import { defineComponent, ref, onMounted, Ref } from 'vue';
  import { Plus } from '@element-plus/icons-vue';
  import presetQuestionService from '@/services/presetQuestion';
  import { PresetQuestion, PresetQuestionDTO } from '@/services/presetQuestion';
  import { ElMessage, ElMessageBox } from 'element-plus';

  export default defineComponent({
    name: 'AgentPresetsConfig',
    props: {
      agentId: {
        type: Number,
        required: true,
      },
    },
    setup(props) {
      const presetQuestionList: Ref<PresetQuestion[]> = ref([]);
      const dialogVisible: Ref<boolean> = ref(false);
      const isEdit: Ref<boolean> = ref(false);
      const refreshLoading: Ref<boolean> = ref(false);
      const questionForm: Ref<PresetQuestion> = ref({
        agentId: props.agentId,
        question: '',
        answer: '',
        sortOrder: 0,
        isActive: true,
        isRecall: false
      });
      const currentEditId: Ref<number | null> = ref(null);

      const openCreateDialog = () => {
        isEdit.value = false;
        questionForm.value = {
          agentId: props.agentId,
          question: '',
          sortOrder: 0,
          isActive: true,
        };
        dialogVisible.value = true;
      };

      const loadPresetQuestions = async () => {
        try {
          presetQuestionList.value = await presetQuestionService.list(props.agentId);
        } catch (error) {
          ElMessage.error('加载预设问题列表失败');
          console.error('加载预设问题失败:', error);
        }
      };

      const editQuestion = (question: PresetQuestion) => {
        isEdit.value = true;
        currentEditId.value = question.id || null;
        questionForm.value = { ...question };
        dialogVisible.value = true;
      };

      const deleteQuestion = async (question: PresetQuestion) => {
        if (!question.id) return;

        try {
          await ElMessageBox.confirm(
            `确定要删除预设问题 "${question.question.substring(0, 50)}..." 吗？`,
            '确认删除',
            {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning',
            },
          );

          const result = await presetQuestionService.delete(props.agentId, question.id);
          if (result) {
            ElMessage.success('删除成功');
            await loadPresetQuestions();
          } else {
            ElMessage.error('删除失败');
          }
        } catch {
          // 用户点击取消按钮，忽略此错误
        }
      };

      const saveQuestion = async () => {
        try {
          if (!questionForm.value.question || questionForm.value.question.trim() === '') {
            ElMessage.error('请输入预设问题');
            return;
          }

          let questionsToSave: PresetQuestionDTO[] = [];

          if (isEdit.value && currentEditId.value) {
            questionsToSave = presetQuestionList.value.map(q => {
              const dto: PresetQuestionDTO = {
                question: q.id === currentEditId.value ? questionForm.value.question : q.question,
              };
              if (q.id === currentEditId.value) {
                dto.isActive = questionForm.value.isActive === true;
                dto.answer =  questionForm.value.answer;
              } else {
                dto.isActive = q.isActive === true;
                dto.answer =  q.answer;
              }
              return dto;
            });
          } else {
            questionsToSave = [
              ...presetQuestionList.value.map(q => ({
                question: q.question,
                answer: q.answer,
                isActive: q.isActive === true,
              })),
              {
                question: questionForm.value.question,
                answer: questionForm.value.answer,
                isActive: questionForm.value.isActive === true,
              },
            ];
          }

          console.log('发送的数据:', JSON.stringify(questionsToSave));

          const result = await presetQuestionService.batchSave(props.agentId, questionsToSave);
          if (result) {
            ElMessage.success(isEdit.value ? '更新成功' : '创建成功');
          } else {
            ElMessage.error(isEdit.value ? '更新失败' : '创建失败');
            return;
          }

          dialogVisible.value = false;
          await loadPresetQuestions();
        } catch (error) {
          ElMessage.error(`${isEdit.value ? '更新' : '创建'}失败`);
          console.error('保存预设问题失败:', error);
        }
      };

       // 切换召回状态
    const toggleRecall = async (knowledge: PresetQuestion, isRecall: boolean) => {
      if (!knowledge.id) return;

      try {
        const result = await presetQuestionService.updateRecallStatus(knowledge.id, isRecall);
        if (result) {
          ElMessage.success(`${isRecall ? '设为召回' : '取消召回'}成功`);
          knowledge.isRecall = isRecall;
        } else {
          ElMessage.error(`${isRecall ? '设为召回' : '取消召回'}失败`);
        }
      } catch (error) {
        ElMessage.error(`${isRecall ? '设为召回' : '取消召回'}失败`);
        console.error('Failed to toggle recall:', error);
      }
    };

    // 刷新向量存储
    const refreshVectorStore = async () => {
      try {
        await ElMessageBox.confirm(
          '如果所有向量状态正常，即无需同步。确定要清除现有数据并开始重新同步吗？',
          '确认同步',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
          },
        );

        refreshLoading.value = true;
        const result = await presetQuestionService.refreshAllQAToVectorStore(
          props.agentId.toString(),
        );
        if (result) {
          ElMessage.success('同步到向量库成功');
        } else {
          ElMessage.error('同步到向量库失败');
        }
      } catch (error) {
        if (error !== 'cancel') {
          ElMessage.error('同步到向量库失败');
          console.error('Failed to refresh vector store:', error);
        }
      } finally {
        refreshLoading.value = false;
      }
    };


      onMounted(() => {
        loadPresetQuestions();
      });

      return {
        Plus,
        presetQuestionList,
        dialogVisible,
        isEdit,
        questionForm,
        refreshLoading,
        openCreateDialog,
        editQuestion,
        deleteQuestion,
        saveQuestion,
        refreshVectorStore,
        toggleRecall
      };
    },
  });
</script>

<style scoped></style>
