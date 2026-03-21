import React, { useEffect, useRef, useState } from 'react'
import MDEditor from '@uiw/react-md-editor'
import { useNavigate, useParams } from 'react-router-dom'
import { container } from 'tsyringe'
import axios from 'axios'
import Post from '@/entity/post/Post'
import PostEdit from '@/entity/post/PostEdit'
import type HttpError from '@/http/HttpError'
import PostRepository from '@/repository/PostRepository'

const POST_REPOSITORY = container.resolve(PostRepository)

export default function EditView() {
  const { postId } = useParams<{ postId: string }>()
  const navigate = useNavigate()
  const [postEdit, setPostEdit] = useState<PostEdit>(new PostEdit())
  const [uploading, setUploading] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)

  function getPost() {
    POST_REPOSITORY.get(Number(postId))
      .then((post: Post) => {
        setPostEdit({ title: post.title, content: post.content })
      })
      .catch((e) => {
        console.error(e)
      })
  }

  function edit() {
    POST_REPOSITORY.update(Number(postId), postEdit)
      .then(() => {
        alert('글 수정이 완료되었습니다.')
        navigate(`/blog/post/${postId}`, { replace: true })
      })
      .catch((e: HttpError) => {
        alert(e.getMessage())
      })
  }

  async function handleImageUpload(file: File) {
    const formData = new FormData()
    formData.append('image', file)
    setUploading(true)
    try {
      const res = await axios.post<{ url: string }>('/api/upload/image', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
        withCredentials: true,
      })
      const markdownImage = `\n![image](${res.data.url})\n`
      setPostEdit(prev => ({ ...prev, content: (prev.content ?? '') + markdownImage }))
    } catch {
      alert('이미지 업로드에 실패했습니다.')
    } finally {
      setUploading(false)
    }
  }

  function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (file) handleImageUpload(file)
    e.target.value = ''
  }

  function handleEditorDrop(e: React.DragEvent<HTMLDivElement>) {
    const file = e.dataTransfer.files?.[0]
    if (file && file.type.startsWith('image/')) {
      e.preventDefault()
      handleImageUpload(file)
    }
  }

  function handleEditorPaste(e: React.ClipboardEvent<HTMLDivElement>) {
    const file = e.clipboardData.files?.[0]
    if (file && file.type.startsWith('image/')) {
      e.preventDefault()
      handleImageUpload(file)
    }
  }

  useEffect(() => {
    getPost()
  }, [postId])

  return (
    <div className="bg-white rounded-2xl border border-slate-100 shadow-sm p-8">
      <h1 className="text-xl font-bold text-slate-800 mb-6 tracking-tight">글 수정</h1>
      <div className="flex flex-col gap-4">
      <div>
        <label className="block text-sm mb-1 text-slate-500">제목</label>
        <input
          className="w-full border rounded px-3 py-2 text-base"
          value={postEdit.title}
          onChange={(e) => setPostEdit({ ...postEdit, title: e.target.value })}
        />
      </div>

      <div>
        <div className="flex items-center justify-between mb-1">
          <label className="block text-sm">내용</label>
          <button
            type="button"
            className="text-xs border border-gray-300 rounded px-2 py-1 hover:bg-gray-50 disabled:opacity-50"
            onClick={() => fileInputRef.current?.click()}
            disabled={uploading}
          >
            {uploading ? '업로드 중...' : '이미지 삽입'}
          </button>
        </div>
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          className="hidden"
          onChange={handleFileChange}
        />
        <div
          data-color-mode="light"
          onDrop={handleEditorDrop}
          onDragOver={(e) => e.preventDefault()}
          onPaste={handleEditorPaste}
        >
          <MDEditor
            value={postEdit.content}
            onChange={(val) => setPostEdit({ ...postEdit, content: val ?? '' })}
            height={650}
            preview="live"
          />
        </div>
        <p className="text-xs text-gray-400 mt-1">이미지를 드래그&드롭 하거나 붙여넣기(Ctrl+V) 할 수 있습니다.</p>
      </div>

      <button
        className="w-full bg-slate-800 text-white py-2.5 rounded-lg text-sm font-medium hover:bg-slate-700 transition-colors"
        onClick={edit}
      >
        수정완료
      </button>
      </div>
    </div>
  )
}
