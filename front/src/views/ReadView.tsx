import React, { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { container } from 'tsyringe'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import Post from '@/entity/post/Post'
import CommentList from '@/entity/comment/CommentList'
import CommentEntity from '@/entity/comment/Comment'
import type HttpError from '@/http/HttpError'
import type UserProfile from '@/entity/user/UserProfile'
import PostRepository from '@/repository/PostRepository'
import AccountRepository from '@/repository/AccountRepository'
import Comments from '@/components/Comments'

const POST_REPOSITORY = container.resolve(PostRepository)
const USER_REPOSITORY = container.resolve(AccountRepository)

export default function ReadView() {
  const { postId } = useParams<{ postId: string }>()
  const navigate = useNavigate()
  const [post, setPost] = useState<Post>(new Post())
  const [commentList, setCommentList] = useState<CommentList<CommentEntity>>(new CommentList<CommentEntity>())
  const [profile, setProfile] = useState<UserProfile | null>(null)

  function getPost() {
    POST_REPOSITORY.get(Number(postId))
      .then((p: Post) => {
        setPost(p)
        const cl = new CommentList<CommentEntity>()
        cl.setComments(p.comments)
        setCommentList(cl)
      })
      .catch((e) => console.error(e))
  }

  function remove() {
    if (!window.confirm('정말로 삭제하시겠습니까?')) return
    POST_REPOSITORY.delete(Number(postId))
      .then(() => {
        alert('삭제되었습니다.')
        navigate('/blog')
      })
      .catch((error: HttpError) => alert(error.toString()))
  }

  useEffect(() => {
    getPost()
    USER_REPOSITORY.getProfile()
      .then(setProfile)
      .catch(() => {/* 비로그인 */})
  }, [postId])

  const isAdmin = profile?.isAdmin() ?? false

  return (
    <div className="max-w-2xl mx-auto">
      {/* Back */}
      <button
        onClick={() => navigate('/blog')}
        className="flex items-center gap-1 text-sm text-slate-400 hover:text-slate-700 mb-8 transition-colors"
      >
        ← 목록으로
      </button>

      {/* Article */}
      <article className="bg-white rounded-2xl border border-slate-100 shadow-sm p-8">
        <header className="mb-8 pb-6 border-b border-slate-100">
          <h1 className="text-3xl font-bold text-slate-800 tracking-tight leading-tight">
            {post.title}
          </h1>
          <p className="text-xs text-slate-400 mt-3 flex items-center gap-2">
            {post.getDisplayRegDate()}
            {post.author && (
              <>
                <span className="text-slate-300">·</span>
                <button
                  className="font-medium text-slate-500 hover:text-blue-600 transition-colors"
                  onClick={() => navigate(`/blog/profile/${post.author}`)}
                >
                  {post.author}
                </button>
              </>
            )}
            {post.categoryName && (
              <>
                <span className="text-slate-300">·</span>
                <span className="bg-blue-50 text-blue-600 rounded px-1.5 py-0.5 text-xs font-medium">
                  {post.categoryName}
                </span>
              </>
            )}
          </p>
        </header>

        <div className="prose max-w-none">
          <ReactMarkdown remarkPlugins={[remarkGfm]}>
            {post.content}
          </ReactMarkdown>
        </div>

        {/* Actions — 어드민만 표시 */}
        {isAdmin && (
          <footer className="mt-8 pt-6 border-t border-slate-100 flex justify-end gap-4">
            <button
              className="text-xs text-slate-400 hover:text-slate-700 transition-colors"
              onClick={() => navigate(`/blog/edit/${postId}`)}
            >
              수정
            </button>
            <button
              className="text-xs text-red-400 hover:text-red-600 transition-colors"
              onClick={remove}
            >
              삭제
            </button>
          </footer>
        )}
      </article>

      {/* Comments */}
      <div className="mt-6">
        <Comments commentList={commentList} postId={Number(postId)} onRefresh={getPost} />
      </div>
    </div>
  )
}
