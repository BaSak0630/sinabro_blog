<script setup lang="ts">
import Comment from '@/entity/comment/Comment'
import CommentDelete from '@/entity/comment/CommentDelete'
import type HttpError from '@/http/HttpError'
import CommentRepository from '@/repository/CommentRepository'
import router from '@/router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { container } from 'tsyringe'
import { reactive } from 'vue'

const COMMENT_REPOSITORY = container.resolve(CommentRepository)

const props = defineProps<{
  comment: Comment
}>()

const state = reactive({
  comment: props.comment,
  commentDelete: new CommentDelete()
})

function remove() {
  ElMessageBox.confirm('정말로 삭제하시겠습니까?', {
    title: 'Warning',
    confirmButtonText: '삭제',
    showInput: true,
    inputPlaceholder: '비밀번호를 입력해주세요.',
    inputType: 'password',
    inputErrorMessage: '비밀번호를 입력해주세요.',
    cancelButtonText: '취소',
    type: 'warning',
    beforeClose: (action, instance, done) => {
      if (action === 'confirm') {
        state.commentDelete.password = instance.inputValue
      }
      done()
    }
  }).then(() => {
    console.log(state.commentDelete)
    COMMENT_REPOSITORY.delete(state.commentDelete, state.comment.id)
      .then(() => {
        ElMessage({ type: 'success', message: '성공적으로 삭제되었습니다.' })
        router.go(0)
      })
      .catch((error: HttpError) => {
        ElMessage({ type: 'error', message: error.toString() })
      })
  })
}
</script>

<template>
  <div class="comment">
    <div class="header">
      <div class="section">
        <div class="author">{{ state.comment.author }}</div>
      </div>
      <div class="delete" @click="remove()">삭제</div>
    </div>
    <div class="content">{{ state.comment.content }}</div>
  </div>
</template>

<style scoped lang="scss">
.comment {
  width: 100%;
}

.header {
  display: flex;
  justify-content: space-between;
}

.section {
  display: flex;
  flex-direction: column;
}

.author {
  font-weight: 600;
  font-size: 1.2rem;
}

.content {
  margin-top: 0.8rem;
  font-size: 0.88rem;
}

.delete {
  font-size: 0.78rem;
  color: red;
}
</style>
