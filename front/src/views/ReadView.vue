<script setup lang="ts">
import Comments from '@/components/Comments.vue'
import { default as CommentList } from '@/entity/comment/CommentList'
import Post from '@/entity/post/Post'
import type HttpError from '@/http/HttpError'
import PostRepository from '@/repository/PostRepository'
import { ElMessage, ElMessageBox } from 'element-plus'
import { container } from 'tsyringe'
import { onMounted, reactive } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps<{
  postId: number
}>()

const POST_REPOSITORY = container.resolve(PostRepository)

type StateType = {
  post: Post
  commentList: CommentList<Comment>
}

const state = reactive<StateType>({
  post: new Post(),
  commentList: new CommentList<Comment>()
})

function getPost() {
  POST_REPOSITORY.get(props.postId)
    .then((post: Post) => {
      state.post = post
      state.commentList = new CommentList<Comment>()
      state.commentList.setComments(post.comments, post.comments.length)
    })
    .catch((e) => {
      console.error(e)
    })
}

const router = useRouter()

function remove() {
  ElMessageBox.confirm('정말로 삭제하시겠습니까?', 'Warning', {
    title: '삭제',
    confirmButtonText: '삭제',
    cancelButtonText: '취소',
    type: 'warning'
  }).then(() => {
    POST_REPOSITORY.delete(props.postId)
      .then(() => {
        ElMessage({ type: 'success', message: '성공적으로 삭제되었습니다.' })
        router.back()
      })
      .catch((error: HttpError) => {
        ElMessage({ type: 'error', message: error.toString() })
      })
  })
}

function update() {
  router.push(`/edit/${props.postId}`)
}

onMounted(() => {
  getPost()
})
</script>

<template>
  <el-row>
    <el-col :span="22" :offset="1">
      <div class="title">{{ state.post.title }}</div>
    </el-col>
  </el-row>

  <el-row>
    <el-col :span="10" :offset="7">
      <div class="title">
        <div class="regDate">Posted on {{ state.post.getDisplayRegDate() }}</div>
      </div>
    </el-col>
  </el-row>

  <el-row>
    <el-col>
      <div class="content">
        {{ state.post.content }}
      </div>

      <div class="footer">
        <div class="edit" @click="update()">수정</div>
        <div class="delete" @click="remove()">삭제</div>
      </div>
    </el-col>
  </el-row>

  <Comments :commentList="state.commentList" :postId="props.postId" />
</template>

<style scoped lang="scss">
.title {
  font-size: 1.8rem;
  font-weight: 400;
  text-align: center;
}

.regDate {
  margin-top: 0.5rem;
  font-size: 0.78rem;
  font-weight: 300;
}

.content {
  margin-top: 1.88rem;
  font-weight: 300;

  word-break: break-all;
  white-space: break-spaces;
  line-height: 1.4;
  min-height: 5rem;
}

hr {
  border-color: #f9f9f9;
  margin: 1.2rem 0;
}

.footer {
  margin-top: 1rem;
  display: flex;
  font-size: 0.78rem;
  justify-content: flex-end;
  gap: 0.8rem;

  .delete {
    color: red;
  }
}

.comments {
  margin-top: 4.8rem;
}
</style>
