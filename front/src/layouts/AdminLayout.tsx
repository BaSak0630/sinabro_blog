import React from 'react'
import { Link, Outlet, useLocation } from 'react-router-dom'

const NAV_ITEMS = [
  { label: '대시보드', path: '/admin' },
  { label: '유저 관리', path: '/admin/users' },
  { label: '게시글 관리', path: '/admin/posts' },
  { label: '카테고리 관리', path: '/admin/categories' },
]

export default function AdminLayout() {
  const location = useLocation()

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Top bar */}
      <header className="sticky top-0 z-20 bg-white border-b border-slate-200">
        <div className="max-w-6xl mx-auto px-8 h-14 flex items-center justify-between">
          <Link to="/admin" className="text-base font-bold text-slate-800 hover:text-blue-600 transition-colors">
            관리자 패널
          </Link>
          <Link to="/blog" className="text-xs text-slate-500 hover:text-slate-700 transition-colors">
            ← 블로그로
          </Link>
        </div>
      </header>

      <div className="max-w-6xl mx-auto px-8 py-8 flex gap-8">
        {/* Sidebar */}
        <aside className="w-48 shrink-0">
          <nav className="flex flex-col gap-1">
            {NAV_ITEMS.map((item) => {
              const isActive =
                item.path === '/admin'
                  ? location.pathname === '/admin'
                  : location.pathname.startsWith(item.path)
              return (
                <Link
                  key={item.path}
                  to={item.path}
                  className={`px-4 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                    isActive
                      ? 'bg-slate-800 text-white'
                      : 'text-slate-600 hover:bg-slate-100'
                  }`}
                >
                  {item.label}
                </Link>
              )
            })}
          </nav>
        </aside>

        {/* Main content */}
        <main className="flex-1 min-w-0">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
