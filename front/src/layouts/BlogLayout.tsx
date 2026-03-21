import React from 'react'
import { Outlet } from 'react-router-dom'
import BlogNav from '@/components/BlogNav'

export default function BlogLayout() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-blue-50">
      <BlogNav />
      <main className="max-w-6xl mx-auto px-8 py-10">
        <Outlet />
      </main>
    </div>
  )
}
