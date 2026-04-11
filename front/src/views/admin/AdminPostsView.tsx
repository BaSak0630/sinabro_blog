import React, { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { container } from 'tsyringe'
import type Post from '@/entity/post/Post'
import Paging from '@/entity/data/Paging'
import AdminRepository from '@/repository/AdminRepository'

const ADMIN_REPOSITORY = container.resolve(AdminRepository)

export default function AdminPostsView() {
  const [postList, setPostList] = useState<Paging<Post>>(new Paging<Post>())
  const [deletingId, setDeletingId] = useState<number | null>(null)

  function getList(page = 1) {
    ADMIN_REPOSITORY.getPosts(page).then(setPostList).catch(console.error)
  }

  useEffect(() => { getList() }, [])

  async function handleDelete(postId: number) {
    if (!confirm('정말 삭제하시겠습니까?')) return
    setDeletingId(postId)
    try {
      await ADMIN_REPOSITORY.deletePost(postId)
      getList(postList.page)
    } catch (e) {
      console.error(e)
    } finally {
      setDeletingId(null)
    }
  }

  const totalPages = Math.ceil(postList.totalCount / 10)

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-slate-800">게시글 관리</h1>
      <p className="text-sm text-slate-400">총 {postList.totalCount}개</p>

      <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-slate-100 bg-slate-50 text-xs text-slate-500 uppercase tracking-wide">
              <th className="px-4 py-3 text-left">제목</th>
              <th className="px-4 py-3 text-left">카테고리</th>
              <th className="px-4 py-3 text-left">작성자</th>
              <th className="px-4 py-3 text-left">조회수</th>
              <th className="px-4 py-3 text-left">댓글</th>
              <th className="px-4 py-3 text-left">작성일</th>
              <th className="px-4 py-3"></th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {postList.items.length === 0 ? (
              <tr>
                <td colSpan={7} className="px-4 py-8 text-center text-slate-300">게시글 없음</td>
              </tr>
            ) : (
              postList.items.map((post) => (
                <tr key={(post as Post).id} className="hover:bg-slate-50 transition-colors">
                  <td className="px-4 py-3 font-medium text-slate-700 max-w-xs truncate">
                    <Link to={`/blog/post/${(post as Post).id}`} className="hover:text-blue-600 transition-colors">
                      {(post as Post).title}
                    </Link>
                  </td>
                  <td className="px-4 py-3 text-slate-500">
                    {(post as Post).categoryName || <span className="text-slate-300">-</span>}
                  </td>
                  <td className="px-4 py-3 text-slate-600">{(post as Post).author}</td>
                  <td className="px-4 py-3 text-slate-500">{(post as any).viewCount ?? 0}</td>
                  <td className="px-4 py-3 text-slate-500">{((post as Post).comments ?? []).length}</td>
                  <td className="px-4 py-3 text-slate-400 text-xs">
                    {(post as Post).getDisplaySimpleRegDate?.() ?? '-'}
                  </td>
                  <td className="px-4 py-3">
                    <button
                      onClick={() => handleDelete((post as Post).id)}
                      disabled={deletingId === (post as Post).id}
                      className="text-xs text-red-500 hover:text-red-700 disabled:opacity-40 transition-colors"
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

      {totalPages > 1 && (
        <div className="flex justify-center gap-1.5">
          <button
            className="px-3 py-1.5 text-sm border border-slate-200 rounded-lg bg-white text-slate-500 hover:bg-slate-50 disabled:opacity-30 transition-colors"
            disabled={postList.page <= 1}
            onClick={() => getList(postList.page - 1)}
          >
            ‹
          </button>
          {Array.from({ length: totalPages }, (_, i) => i + 1).map((p) => (
            <button
              key={p}
              className={`px-3 py-1.5 text-sm border rounded-lg transition-colors ${
                p === postList.page
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
            disabled={postList.page >= totalPages}
            onClick={() => getList(postList.page + 1)}
          >
            ›
          </button>
        </div>
      )}
    </div>
  )
}
