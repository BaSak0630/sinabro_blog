<script setup lang="ts">
import Login from '@/entity/user/Login'
import type HttpError from '@/http/HttpError'
import UserRepository from '@/repository/AccountRepository'
import { ElMessage } from 'element-plus'
import { container } from 'tsyringe'
import { reactive } from 'vue'

const state = reactive({
  login: new Login()
})

const USER_REPOSITORY = container.resolve(UserRepository)

function doLogin() {
  USER_REPOSITORY.login(state.login)
    .then(() => {
      ElMessage({ type: 'success', message: '환영합니다 :) ' })
      setTimeout(() => {
        location.href = '/'
      }, 400)
    })
    .catch((e: HttpError) => {
      ElMessage({ type: 'error', message: e.toString() })
    })
}
</script>

<template>
  <el-row>
    <el-col :span="10" :offset="7">
      <el-form label-position="top">
        <el-form-item label="아이디">
          <el-input v-model="state.login.accountId"></el-input>
        </el-form-item>

        <el-form-item label="비밀번호">
          <el-input v-model="state.login.password" type="password"></el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" style="width: 100%" @click="doLogin()">로그인</el-button>
        </el-form-item>
      </el-form>
    </el-col>
  </el-row>
</template>

<style></style>
