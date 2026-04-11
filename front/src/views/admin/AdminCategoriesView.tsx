import React, { useEffect, useState } from 'react'
import { container } from 'tsyringe'
import type Category from '@/entity/post/Category'
import CategoryRepository from '@/repository/CategoryRepository'

const CATEGORY_REPOSITORY = container.resolve(CategoryRepository)

export default function AdminCategoriesView() {
  const [categories, setCategories] = useState<Category[]>([])
  const [newName, setNewName] = useState('')

  function load() {
    CATEGORY_REPOSITORY.getAll().then(setCategories).catch(console.error)
  }

  useEffect(() => { load() }, [])

  async function handleAdd() {
    if (!newName.trim()) return
    try {
      await CATEGORY_REPOSITORY.create(newName.trim())
      setNewName('')
      load()
    } catch {
      alert('카테고리 추가에 실패했습니다.')
    }
  }

  async function handleDelete(id: number) {
    if (!confirm('정말 삭제하시겠습니까?')) return
    try {
      await CATEGORY_REPOSITORY.delete(id)
      load()
    } catch {
      alert('카테고리 삭제에 실패했습니다.')
    }
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-slate-800">카테고리 관리</h1>
      <p className="text-sm text-slate-400">총 {categories.length}개</p>

      <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-slate-100 bg-slate-50 text-xs text-slate-500 uppercase tracking-wide">
              <th className="px-4 py-3 text-left">이름</th>
              <th className="px-4 py-3"></th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {categories.length === 0 ? (
              <tr>
                <td colSpan={2} className="px-4 py-8 text-center text-slate-300">카테고리 없음</td>
              </tr>
            ) : (
              categories.map(c => (
                <tr key={c.id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-4 py-3 font-medium text-slate-700">{c.name}</td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => handleDelete(c.id)}
                      className="text-xs text-red-500 hover:text-red-700 transition-colors"
                    >
                      삭제
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <div className="flex items-center gap-2">
        <input
          className="border rounded px-3 py-2 text-sm"
          placeholder="새 카테고리 이름"
          value={newName}
          onChange={(e) => setNewName(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleAdd()}
        />
        <button
          onClick={handleAdd}
          className="bg-slate-800 text-white text-sm px-4 py-2 rounded-lg hover:bg-slate-700 transition-colors"
        >
          추가
        </button>
      </div>
    </div>
  )
}
