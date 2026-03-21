import React, { useEffect, useState } from 'react'
import { container } from 'tsyringe'
import SignUp from '@/entity/user/SignUp'
import type HttpError from '@/http/HttpError'
import AccountRepository from '@/repository/AccountRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)

interface Props {
  onClose: () => void
  onSuccess: () => void
}

export default function SignUpModal({ onClose, onSuccess }: Props) {
  const [form, setForm] = useState<SignUp>(new SignUp())
  const [error, setError] = useState('')

  // ESC 키로 닫기
  useEffect(() => {
    const handler = (e: KeyboardEvent) => { if (e.key === 'Escape') onClose() }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [onClose])

  function doSignUp() {
    setError('')
    USER_REPOSITORY.signUp(form)
      .then(() => {
        alert('회원가입이 완료되었습니다. 로그인해주세요.')
        onSuccess()
      })
      .catch((e: HttpError) => {
        setError(e.getMessage?.() ?? e.toString())
      })
  }

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/40"
      onClick={(e) => { if (e.target === e.currentTarget) onClose() }}
    >
      <div className="bg-white rounded-lg shadow-lg w-full max-w-sm p-6">
        <div className="flex justify-between items-center mb-5">
          <h2 className="text-lg font-medium">회원가입</h2>
          <button
            className="text-gray-400 hover:text-gray-600 text-xl leading-none"
            onClick={onClose}
          >
            ✕
          </button>
        </div>

        <div className="flex flex-col gap-3">
          <div>
            <label className="block text-sm mb-1">이름</label>
            <input
              className="w-full border rounded px-3 py-2 text-sm"
              placeholder="이름을 입력해주세요"
              value={form.username}
              onChange={(e) => setForm({ ...form, username: e.target.value })}
            />
          </div>

          <div>
            <label className="block text-sm mb-1">아이디</label>
            <input
              className="w-full border rounded px-3 py-2 text-sm"
              placeholder="아이디를 입력해주세요"
              value={form.accountId}
              onChange={(e) => setForm({ ...form, accountId: e.target.value })}
            />
          </div>

          <div>
            <label className="block text-sm mb-1">비밀번호</label>
            <input
              className="w-full border rounded px-3 py-2 text-sm"
              type="password"
              placeholder="비밀번호를 입력해주세요"
              value={form.password}
              onChange={(e) => setForm({ ...form, password: e.target.value })}
            />
          </div>

          <div>
            <label className="block text-sm mb-1">이메일</label>
            <input
              className="w-full border rounded px-3 py-2 text-sm"
              type="email"
              placeholder="이메일을 입력해주세요"
              value={form.email}
              onChange={(e) => setForm({ ...form, email: e.target.value })}
            />
          </div>

          {error && (
            <p className="text-sm text-red-500">{error}</p>
          )}

          <button
            className="w-full bg-blue-500 text-white py-2 rounded text-sm hover:bg-blue-600 mt-1"
            onClick={doSignUp}
          >
            가입하기
          </button>
        </div>
      </div>
    </div>
  )
}
