import React, { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { container } from 'tsyringe'
import type PublicProfile from '@/entity/user/PublicProfile'
import type Post from '@/entity/post/Post'
import Paging from '@/entity/data/Paging'
import AccountRepository from '@/repository/AccountRepository'
import PostRepository from '@/repository/PostRepository'
import PostComponent from '@/components/PostComponent'

const USER_REPOSITORY = container.resolve(AccountRepository)
const POST_REPOSITORY = container.resolve(PostRepository)

export default function ProfileView() {
  const { accountId } = useParams<{ accountId: string }>()
  const navigate = useNavigate()
  const [profile, setProfile] = useState<PublicProfile | null>(null)
  const [postList, setPostList] = useState<Paging<Post>>(new Paging<Post>())
  const [page, setPage] = useState(1)
  const [notFound, setNotFound] = useState(false)

  useEffect(() => {
    if (!accountId) return
    USER_REPOSITORY.getPublicProfile(accountId)
      .then(setProfile)
      .catch(() => setNotFound(true))
  }, [accountId])

  useEffect(() => {
    if (!accountId) return
    POST_REPOSITORY.getListByAuthor(accountId, page)
      .then(setPostList)
      .catch(() => {})
  }, [accountId, page])

  if (notFound) {
    return (
      <div className="text-center py-32 text-slate-400">
        <p className="text-4xl mb-3">👤</p>
        <p className="text-sm">존재하지 않는 사용자입니다.</p>
        <button
          className="mt-4 text-xs text-slate-400 hover:text-slate-700 underline"
          onClick={() => navigate('/blog')}
        >
          목록으로
        </button>
      </div>
    )
  }

  const totalPages = Math.ceil(postList.totalCount / 10)

  return (
    <div className="max-w-2xl mx-auto">
      {/* Back */}
      <button
        onClick={() => navigate('/blog')}
        className="flex items-center gap-1 text-sm text-slate-400 hover:text-slate-700 mb-8 transition-colors"
      >
        ← 목록으로
      </button>

      {/* Profile card */}
      <div className="bg-white rounded-2xl border border-slate-100 shadow-sm p-8 mb-6">
        <div className="flex items-center gap-5">
          {/* Avatar */}
          <div className="w-16 h-16 rounded-full bg-slate-200 flex items-center justify-center text-2xl font-bold text-slate-500 shrink-0">
            {profile?.accountId?.[0]?.toUpperCase() ?? '?'}
          </div>
          <div>
            <h1 className="text-xl font-bold text-slate-800">{profile?.accountId}</h1>
            {profile?.username && (
              <p className="text-sm text-slate-400 mt-0.5">{profile.username}</p>
            )}
            <p className="text-xs text-slate-400 mt-2">
              작성한 글 <span className="font-semibold text-slate-600">{profile?.postCount ?? 0}</span>개
            </p>
          </div>
        </div>
      </div>

      {/* Posts */}
      <h2 className="text-sm font-semibold text-slate-500 mb-4">작성한 글</h2>

      {postList.items.length === 0 ? (
        <div className="text-center py-16 text-slate-300">
          <p className="text-sm">아직 작성된 글이 없습니다.</p>
        </div>
      ) : (
        <ul className="list-none p-0 flex flex-col gap-4">
          {postList.items.map((post) => (
            <li key={(post as Post).id}>
              <PostComponent post={post as Post} />
            </li>
          ))}
        </ul>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex justify-center mt-8 gap-1.5">
          <button
            className="px-3 py-1.5 text-sm border border-slate-200 rounded-lg bg-white text-slate-500 hover:bg-slate-50 disabled:opacity-30 transition-colors"
            disabled={page <= 1}
            onClick={() => setPage(page - 1)}
          >
            ‹
          </button>
          {Array.from({ length: totalPages }, (_, i) => i + 1).map((p) => (
            <button
              key={p}
              className={`px-3 py-1.5 text-sm border rounded-lg transition-colors ${
                p === page
                  ? 'bg-slate-800 text-white border-slate-800'
                  : 'border-slate-200 bg-white text-slate-500 hover:bg-slate-50'
              }`}
              onClick={() => setPage(p)}
            >
              {p}
            </button>
          ))}
          <button
            className="px-3 py-1.5 text-sm border border-slate-200 rounded-lg bg-white text-slate-500 hover:bg-slate-50 disabled:opacity-30 transition-colors"
            disabled={page >= totalPages}
            onClick={() => setPage(page + 1)}
          >
            ›
          </button>
        </div>
      )}
    </div>
  )
}
