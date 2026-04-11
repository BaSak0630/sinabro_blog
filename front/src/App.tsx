import React from 'react'
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import BlogLayout from '@/layouts/BlogLayout'
import FinTreeLayout from '@/layouts/FinTreeLayout'
import AdminLayout from '@/layouts/AdminLayout'
import RequireAdmin from '@/components/RequireAdmin'
import MainView from '@/views/MainView'
import LoginView from '@/views/LoginView'
import HomeView from '@/views/HomeView'
import WriteView from '@/views/WriteView'
import ReadView from '@/views/ReadView'
import EditView from '@/views/EditView'
import ProfileView from '@/views/ProfileView'
import FinTreeHomeView from '@/views/FinTreeHomeView'
import FinTreeNodeView from '@/views/FinTreeNodeView'
import AdminDashboardView from '@/views/admin/AdminDashboardView'
import AdminUsersView from '@/views/admin/AdminUsersView'
import AdminPostsView from '@/views/admin/AdminPostsView'
import AdminCategoriesView from '@/views/admin/AdminCategoriesView'

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
          <Route path="profile/:accountId" element={<ProfileView />} />
        </Route>

        {/* FinTree */}
        <Route path="/fintree" element={<FinTreeLayout />}>
          <Route index element={<FinTreeHomeView />} />
          <Route path="nodes/:nodeId" element={<FinTreeNodeView />} />
        </Route>

        {/* Admin */}
        <Route path="/admin" element={<RequireAdmin><AdminLayout /></RequireAdmin>}>
          <Route index element={<AdminDashboardView />} />
          <Route path="users" element={<AdminUsersView />} />
          <Route path="posts" element={<AdminPostsView />} />
          <Route path="categories" element={<AdminCategoriesView />} />
        </Route>

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
