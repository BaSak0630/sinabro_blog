<script setup lang="ts">
import Post from '@/entity/post/Post'
import PostEdit from '@/entity/post/PostEdit'
import type HttpError from '@/http/HttpError'
import PostRepository from '@/repository/PostRepository'
import { ElMessage } from 'element-plus'
import { container } from 'tsyringe'
import { onMounted, reactive } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps<{
  postId: number
}>()

const POST_REPOSITORY = container.resolve(PostRepository)

const state = reactive({
  post: new Post(),
  postEdit: new PostEdit()
})

const router = useRouter()

function getPost() {
  POST_REPOSITORY.get(props.postId)
    .then((post: Post) => {
      state.post = post
      state.postEdit = {
        title: post.title,
        content: post.content
      }
    })
    .catch((e) => {
      console.error(e)
    })
}

function edit() {
  POST_REPOSITORY.update(props.postId, state.postEdit)
    .then(() => {
      ElMessage({ type: 'success', message: '글 수정이 완료되었습니다.' })
      router.replace('/post/' + props.postId)
    })
    .catch((e: HttpError) => {
      ElMessage({ type: 'error', message: e.getMessage() })
    })
}

onMounted(() => {
  getPost()
})
</script>

<template>
  <el-form label-position="top">
    <el-form-item label="제목">
      <el-input v-model="state.postEdit.title" size="large" />
    </el-form-item>

    <el-form-item label="내용">
      <el-input v-model="state.postEdit.content" type="textarea" rows="15" alt="내용" />
    </el-form-item>

    <el-form-item>
      <el-button type="primary" style="width: 100%" @click="edit()">수정완료</el-button>
    </el-form-item>
  </el-form>
</template>

<style></style>
