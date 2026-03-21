import React, { useState } from 'react'
import { container } from 'tsyringe'
import Comment from '@/entity/comment/Comment'
import CommentList from '@/entity/comment/CommentList'
import CommentWrite from '@/entity/comment/CommentWrite'
import CommentRepository from '@/repository/CommentRepository'
import CommentComponent from './CommentComponent'

const COMMENT_REPOSITORY = container.resolve(CommentRepository)

interface Props {
  commentList: CommentList<Comment>
  postId: number
  onRefresh: () => void
}

export default function Comments({ commentList, postId, onRefresh }: Props) {
  const [commentWrite, setCommentWrite] = useState<CommentWrite>(new CommentWrite())

  function write() {
    COMMENT_REPOSITORY.write(commentWrite, postId)
      .then(() => {
        alert('댓글이 등록되었습니다.')
        setCommentWrite(new CommentWrite())
        onRefresh()
      })
      .catch((e) => {
        alert(e.toString())
      })
  }

  return (
    <div className="mt-20">
      <div className="text-2xl">{`댓글 ${commentList.totalCount}개`}</div>

      <ul className="list-none p-0 mt-12">
        {commentList.items.map((comment) => (
          <li key={(comment as Comment).id} className="mb-10 last:mb-0">
            <CommentComponent comment={comment as Comment} onRefresh={onRefresh} />
          </li>
        ))}
      </ul>

      <div className="flex flex-col gap-3 mt-4">
        <div className="flex gap-3">
          <div className="w-36">
            <div className="flex flex-col gap-1">
              <div>
                <label className="text-xs">작성자</label>
                <input
                  className="w-full border rounded px-2 py-1 text-sm"
                  placeholder="작성자"
                  value={commentWrite.author}
                  onChange={(e) => setCommentWrite({ ...commentWrite, author: e.target.value })}
                />
              </div>
              <div>
                <label className="text-xs">비밀번호</label>
                <input
                  className="w-full border rounded px-2 py-1 text-sm"
                  type="password"
                  placeholder="비밀번호"
                  value={commentWrite.password}
                  onChange={(e) => setCommentWrite({ ...commentWrite, password: e.target.value })}
                />
              </div>
            </div>
          </div>

          <div className="flex-grow">
            <label className="text-xs">내용</label>
            <textarea
              className="w-full border rounded px-2 py-1 text-sm"
              rows={5}
              value={commentWrite.content}
              onChange={(e) => setCommentWrite({ ...commentWrite, content: e.target.value })}
            />
          </div>
        </div>

        <button
          className="self-end bg-blue-500 text-white px-4 py-2 rounded text-sm hover:bg-blue-600"
          onClick={write}
        >
          댓글 등록
        </button>
      </div>
    </div>
  )
}
