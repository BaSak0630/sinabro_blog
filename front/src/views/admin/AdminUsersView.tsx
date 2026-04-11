import React, { useEffect, useState } from 'react'
import { container } from 'tsyringe'
import type AdminUser from '@/entity/admin/AdminUser'
import Paging from '@/entity/data/Paging'
import AdminRepository from '@/repository/AdminRepository'

const ADMIN_REPOSITORY = container.resolve(AdminRepository)

const ROLES = ['USER', 'MANAGER', 'ROLE_ADMIN']

export default function AdminUsersView() {
  const [userList, setUserList] = useState<Paging<AdminUser>>(new Paging<AdminUser>())
  const [updatingId, setUpdatingId] = useState<number | null>(null)

  function getList(page = 1) {
    ADMIN_REPOSITORY.getUsers(page).then(setUserList).catch(console.error)
  }

  useEffect(() => { getList() }, [])

  async function handleRoleChange(userId: number, role: string) {
    setUpdatingId(userId)
    try {
      await ADMIN_REPOSITORY.updateUserRole(userId, role)
      getList(userList.page)
    } catch (e) {
      console.error(e)
    } finally {
      setUpdatingId(null)
    }
  }

  const totalPages = Math.ceil(userList.totalCount / 10)

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-slate-800">유저 관리</h1>
      <p className="text-sm text-slate-400">총 {userList.totalCount}명</p>

      <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-slate-100 bg-slate-50 text-xs text-slate-500 uppercase tracking-wide">
              <th className="px-4 py-3 text-left">아이디</th>
              <th className="px-4 py-3 text-left">이름</th>
              <th className="px-4 py-3 text-left">이메일</th>
              <th className="px-4 py-3 text-left">역할</th>
              <th className="px-4 py-3 text-left">가입일</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {userList.items.length === 0 ? (
              <tr>
                <td colSpan={5} className="px-4 py-8 text-center text-slate-300">유저 없음</td>
              </tr>
            ) : (
              userList.items.map((user) => (
                <tr key={(user as AdminUser).id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-4 py-3 font-medium text-slate-700">{(user as AdminUser).accountId}</td>
                  <td className="px-4 py-3 text-slate-600">{(user as AdminUser).username}</td>
                  <td className="px-4 py-3 text-slate-500">{(user as AdminUser).email}</td>
                  <td className="px-4 py-3">
                    <select
                      value={(user as AdminUser).role}
                      disabled={updatingId === (user as AdminUser).id}
                      onChange={(e) => handleRoleChange((user as AdminUser).id, e.target.value)}
                      className="text-xs border border-slate-200 rounded-lg px-2 py-1 bg-white text-slate-700 focus:outline-none focus:ring-1 focus:ring-slate-400 disabled:opacity-50"
                    >
                      {ROLES.map((r) => (
                        <option key={r} value={r}>{r}</option>
                      ))}
                    </select>
                  </td>
                  <td className="px-4 py-3 text-slate-400 text-xs">
                    {(user as AdminUser).createAt ? (user as AdminUser).createAt.substring(0, 10) : '-'}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {totalPages > 1 && (
        <div className="flex justify-center gap-1.5">
          <button
            className="px-3 py-1.5 text-sm border border-slate-200 rounded-lg bg-white text-slate-500 hover:bg-slate-50 disabled:opacity-30 transition-colors"
            disabled={userList.page <= 1}
            onClick={() => getList(userList.page - 1)}
          >
            ‹
          </button>
          {Array.from({ length: totalPages }, (_, i) => i + 1).map((p) => (
            <button
              key={p}
              className={`px-3 py-1.5 text-sm border rounded-lg transition-colors ${
                p === userList.page
                  ? 'bg-slate-800 text-white border-slate-800'
                  : 'border-slate-200 bg-white text-slate-500 hover:bg-slate-50'
              }`}
              onClick={() => getList(p)}
            >
              {p}
            </button>
          ))}
          <button
            className="px-3 py-1.5 text-sm border border-slate-200 rounded-lg bg-white text-slate-500 hover:bg-slate-50 disabled:opacity-30 transition-colors"
            disabled={userList.page >= totalPages}
            onClick={() => getList(userList.page + 1)}
          >
            ›
          </button>
        </div>
      )}
    </div>
  )
}
