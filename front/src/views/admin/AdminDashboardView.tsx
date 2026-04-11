import React, { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { container } from 'tsyringe'
import AdminStats from '@/entity/admin/AdminStats'
import AdminRepository from '@/repository/AdminRepository'

const ADMIN_REPOSITORY = container.resolve(AdminRepository)

export default function AdminDashboardView() {
  const [stats, setStats] = useState<AdminStats | null>(null)

  useEffect(() => {
    ADMIN_REPOSITORY.getStats().then(setStats).catch(console.error)
  }, [])

  if (!stats) {
    return (
      <div className="flex items-center justify-center py-32">
        <div className="w-5 h-5 border-2 border-slate-200 border-t-slate-600 rounded-full animate-spin" />
      </div>
    )
  }

  const statCards = [
    { label: '총 유저', value: stats.userCount },
    { label: '총 게시글', value: stats.postCount },
    { label: '총 댓글', value: stats.commentCount },
    { label: '총 조회수', value: stats.totalViewCount },
  ]

  return (
    <div className="space-y-8">
      <h1 className="text-2xl font-bold text-slate-800">대시보드</h1>

      {/* Stat cards */}
      <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
        {statCards.map((card) => (
          <div key={card.label} className="bg-white rounded-xl border border-slate-200 p-5">
            <p className="text-xs text-slate-400 font-medium uppercase tracking-wide">{card.label}</p>
            <p className="mt-1 text-3xl font-bold text-slate-800">{card.value.toLocaleString()}</p>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
        {/* Recent posts */}
        <div className="bg-white rounded-xl border border-slate-200 p-5">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-sm font-semibold text-slate-700">최근 게시글</h2>
            <Link to="/admin/posts" className="text-xs text-blue-500 hover:underline">전체 보기</Link>
          </div>
          {stats.recentPosts.length === 0 ? (
            <p className="text-xs text-slate-400">게시글 없음</p>
          ) : (
            <ul className="divide-y divide-slate-100">
              {stats.recentPosts.map((post) => (
                <li key={post.id} className="py-2.5 flex items-center justify-between gap-2">
                  <span className="text-sm text-slate-700 truncate">{post.title}</span>
                  <span className="text-xs text-slate-400 shrink-0">{post.author}</span>
                </li>
              ))}
            </ul>
          )}
        </div>

        {/* Recent users */}
        <div className="bg-white rounded-xl border border-slate-200 p-5">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-sm font-semibold text-slate-700">최근 가입 유저</h2>
            <Link to="/admin/users" className="text-xs text-blue-500 hover:underline">전체 보기</Link>
          </div>
          {stats.recentUsers.length === 0 ? (
            <p className="text-xs text-slate-400">유저 없음</p>
          ) : (
            <ul className="divide-y divide-slate-100">
              {stats.recentUsers.map((user) => (
                <li key={user.id} className="py-2.5 flex items-center justify-between gap-2">
                  <span className="text-sm text-slate-700">{user.accountId}</span>
                  <span className="text-xs bg-slate-100 text-slate-500 px-2 py-0.5 rounded-full">{user.role}</span>
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </div>
  )
}
