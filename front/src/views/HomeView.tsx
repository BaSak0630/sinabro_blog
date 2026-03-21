import React, { useEffect, useState } from 'react'
import { container } from 'tsyringe'
import Paging from '@/entity/data/Paging'
import type Post from '@/entity/post/Post'
import PostRepository from '@/repository/PostRepository'
import PostComponent from '@/components/PostComponent'

const POST_REPOSITORY = container.resolve(PostRepository)

export default function HomeView() {
  const [postList, setPostList] = useState<Paging<Post>>(new Paging<Post>())

  function getList(page = 1) {
    POST_REPOSITORY.getList(page).then((list) => setPostList(list))
  }

  useEffect(() => { getList() }, [])

  const totalPages = Math.ceil(postList.totalCount / 3)

  return (
    <div>
      {/* Page header */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-slate-800 tracking-tight">글 목록</h1>
        <p className="text-sm text-slate-400 mt-1">총 {postList.totalCount}개의 글</p>
      </div>

      {/* Post list */}
      {postList.items.length === 0 ? (
        <div className="text-center py-20 text-slate-300">
          <p className="text-4xl mb-3">✏️</p>
          <p className="text-sm">아직 작성된 글이 없습니다.</p>
        </div>
      ) : (
        <ul className="list-none p-0 flex flex-col gap-4">
          {postList.items.map((post) => (
            <li key={post.id}>
              <PostComponent post={post as Post} />
            </li>
          ))}
        </ul>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex justify-center mt-10 gap-1.5">
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
