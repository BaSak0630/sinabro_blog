import React, { useState } from 'react'
import { container } from 'tsyringe'
import Comment from '@/entity/comment/Comment'
import CommentDelete from '@/entity/comment/CommentDelete'
import type HttpError from '@/http/HttpError'
import CommentRepository from '@/repository/CommentRepository'

const COMMENT_REPOSITORY = container.resolve(CommentRepository)

interface Props {
  comment: Comment
  onRefresh: () => void
}

export default function CommentComponent({ comment, onRefresh }: Props) {
  const [showDeleteForm, setShowDeleteForm] = useState(false)
  const [commentDelete, setCommentDelete] = useState<CommentDelete>(new CommentDelete())

  function remove() {
    if (!commentDelete.password) {
      alert('비밀번호를 입력해주세요.')
      return
    }
    COMMENT_REPOSITORY.delete(commentDelete, comment.id)
      .then(() => {
        alert('성공적으로 삭제되었습니다.')
        onRefresh()
      })
      .catch((error: HttpError) => {
        alert(error.toString())
      })
  }

  return (
    <div className="w-full">
      <div className="flex justify-between">
        <div className="flex flex-col">
          <div className="font-semibold text-xl">{comment.author}</div>
        </div>
        <div
          className="text-xs text-red-500 cursor-pointer"
          onClick={() => setShowDeleteForm(!showDeleteForm)}
        >
          삭제
        </div>
      </div>

      <div className="mt-3 text-sm">{comment.content}</div>

      {showDeleteForm && (
        <div className="flex gap-2 mt-2 items-center">
          <input
            className="border rounded px-2 py-1 text-sm"
            type="password"
            placeholder="비밀번호를 입력해주세요."
            value={commentDelete.password}
            onChange={(e) => setCommentDelete({ password: e.target.value })}
          />
          <button
            className="bg-red-500 text-white px-3 py-1 rounded text-sm hover:bg-red-600"
            onClick={remove}
          >
            확인
          </button>
          <button
            className="border px-3 py-1 rounded text-sm"
            onClick={() => setShowDeleteForm(false)}
          >
            취소
          </button>
        </div>
      )}
    </div>
  )
}
