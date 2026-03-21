import React from 'react'
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import BlogLayout from '@/layouts/BlogLayout'
import RequireAdmin from '@/components/RequireAdmin'
import MainView from '@/views/MainView'
import LoginView from '@/views/LoginView'
import HomeView from '@/views/HomeView'
import WriteView from '@/views/WriteView'
import ReadView from '@/views/ReadView'
import EditView from '@/views/EditView'

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Sinabro 메인 허브 */}
        <Route path="/" element={<MainView />} />

        {/* Sinabro 공통 로그인/회원가입 */}
        <Route path="/login" element={<LoginView />} />

        {/* sinabro_blog */}
        <Route path="/blog" element={<BlogLayout />}>
          <Route index element={<HomeView />} />
          <Route path="write" element={<RequireAdmin><WriteView /></RequireAdmin>} />
          <Route path="post/:postId" element={<ReadView />} />
          <Route path="edit/:postId" element={<RequireAdmin><EditView /></RequireAdmin>} />
        </Route>

        {/* FinTree - 추후 개발 */}
        {/* <Route path="/finance" element={<FinTreeLayout />}> ... </Route> */}

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
