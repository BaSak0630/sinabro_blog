<script setup lang="ts">
import type UserProfile from '@/entity/user/UserProfile'
import type HttpError from '@/http/HttpError'
import ProfileRepository from '@/repository/ProfileRepository'
import UserRepository from '@/repository/AccountRepository'
import { ElMessage } from 'element-plus'
import { container } from 'tsyringe'
import { onBeforeMount, reactive } from 'vue'

const USER_REPOSITORY = container.resolve(UserRepository)
const PROFILE_REPOSITORY = container.resolve(ProfileRepository)

type StateType = {
  profile: UserProfile | null
}

const state = reactive<StateType>({
  profile: null
})

onBeforeMount(() => {
  USER_REPOSITORY.getProfile()
    .then((profile) => {
      PROFILE_REPOSITORY.setProfile(profile)
      state.profile = profile
    })
    .catch((e: HttpError) => {
      // 401은 로그인 안 된 상태 - 에러 표시 안 함
      if (e.getCode() !== '401') {
        console.error('프로필 조회 실패:', e.getMessage())
      }
      // 로그인 안 된 상태로 유지 (profile = null)
    })
})

function logout() {
  ElMessage({ type: 'success', message: '로그아웃 되었습니다.' })
  PROFILE_REPOSITORY.clear()
  location.href = '/api/logout'
}
</script>

<template>
  <ul class="menus">
    <li class="menu">
      <router-link to="/">홈으로</router-link>
    </li>

    <li v-if="state.profile !== null" class="menu">
      <router-link to="/write">글 작성</router-link>
    </li>

    <li v-if="state.profile === null" class="menu">
      <router-link to="/login">로그인</router-link>
    </li>
    <li v-else class="menu">
      <a href="#" @click="logout()">({{ state.profile!.accountId }}) 로그아웃</a>
    </li>
  </ul>
</template>

<style scoped lang="scss">
.menus {
  height: 20px;
  list-style: none;
  padding: 0;
  font-size: 0.88rem;
  font-weight: 300;
  text-align: left;
  margin-left: 50px;
}

.menu {
  display: inline;
  margin-right: 1rem;

  &:last-child {
    margin-right: 0;
  }

  a {
    color: inherit;
  }
}
</style>
