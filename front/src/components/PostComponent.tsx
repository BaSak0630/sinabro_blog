import React from 'react'
import { Link, useNavigate } from 'react-router-dom'
import type Post from '@/entity/post/Post'

interface Props {
  post: Post
}

export default function PostComponent({ post }: Props) {
  const navigate = useNavigate()
  const excerpt = post.content.replace(/[#*`>_\-!\[\]]/g, '').substring(0, 120)

  return (
    <Link
      to={`/blog/post/${post.id}`}
      className="group block rounded-xl border border-slate-100 bg-white p-6 hover:shadow-md hover:-translate-y-0.5 transition-all duration-200 no-underline"
    >
      <div className="flex items-start justify-between gap-4">
        <div className="flex-1 min-w-0">
          <p className="text-xs text-slate-400 mb-2 flex items-center gap-1.5">
            {post.getDisplaySimpleRegDate()}
            {post.author && (
              <>
                <span className="text-slate-300">·</span>
                <button
                  className="hover:text-blue-500 transition-colors"
                  onClick={(e) => { e.preventDefault(); navigate(`/blog/profile/${post.author}`) }}
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
          <h2 className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors truncate">
            {post.title}
          </h2>
          <p className="mt-2 text-sm text-slate-400 leading-relaxed line-clamp-2">
            {excerpt}
          </p>
        </div>
      </div>
      <div className="mt-4 text-xs font-medium text-blue-500 group-hover:gap-2 flex items-center gap-1 transition-all">
        Read more <span>→</span>
      </div>
    </Link>
  )
}
