import React, { useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import Login from '@/entity/user/Login'
import SignUp from '@/entity/user/SignUp'
import type HttpError from '@/http/HttpError'
import AccountRepository from '@/repository/AccountRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)

type Tab = 'login' | 'signup'

export default function LoginView() {
  const navigate = useNavigate()
  const location = useLocation()
  const state = location.state as { from?: string; tab?: Tab } | null
  const from: string = state?.from ?? '/'

  const [tab, setTab] = useState<Tab>(state?.tab ?? 'login')
  const [login, setLogin] = useState<Login>(new Login())
  const [signUp, setSignUp] = useState<SignUp>(new SignUp())
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => { setError('') }, [tab])

  function doLogin() {
    setError('')
    setLoading(true)
    USER_REPOSITORY.login(login)
      .then(() => {
        setTimeout(() => { window.location.href = from }, 200)
      })
      .catch((e: HttpError) => {
        setError(e.toString())
        setLoading(false)
      })
  }

  function doGoogleLogin() {
    USER_REPOSITORY.googleLogin()
      .then(() => {
        setTimeout(() => { window.location.href = from }, 200)
      })
      .catch((e: HttpError) => {
        setError(e.toString())
      })
  }

  function doSignUp() {
    setError('')
    setLoading(true)
    USER_REPOSITORY.signUp(signUp)
      .then(() => {
        alert('회원가입이 완료되었습니다. 로그인해주세요.')
        setTab('login')
        setSignUp(new SignUp())
        setLoading(false)
      })
      .catch((e: HttpError) => {
        setError(e.getMessage?.() ?? e.toString())
        setLoading(false)
      })
  }

  function handleKeyDown(e: React.KeyboardEvent) {
    if (e.key === 'Enter') tab === 'login' ? doLogin() : doSignUp()
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-blue-50 flex flex-col">
      {/* Top bar */}
      <header className="px-10 py-5 flex items-center justify-between border-b border-slate-100 bg-white/70 backdrop-blur-sm">
        <button
          onClick={() => navigate(-1)}
          className="text-sm text-slate-400 hover:text-slate-700 transition-colors"
        >
          ← 돌아가기
        </button>
        <span
          className="text-lg font-bold tracking-tight text-slate-800 cursor-pointer"
          onClick={() => navigate('/')}
        >
          Sinabro
        </span>
      </header>

      {/* Card */}
      <div className="flex-1 flex items-center justify-center px-4 py-12">
        <div className="w-full max-w-sm bg-white rounded-2xl shadow-sm border border-slate-100 p-8">
          {/* Brand */}
          <div className="text-center mb-7">
            <h1 className="text-2xl font-bold text-slate-800 mb-1">Sinabro</h1>
            <p className="text-xs text-slate-400">모든 서비스를 하나의 계정으로</p>
          </div>

          {/* Tabs */}
          <div className="flex mb-6 bg-slate-100 rounded-lg p-1">
            {(['login', 'signup'] as Tab[]).map((t) => (
              <button
                key={t}
                onClick={() => setTab(t)}
                className={`
                  flex-1 py-1.5 text-sm font-medium rounded-md transition-all
                  ${tab === t ? 'bg-white text-slate-800 shadow-sm' : 'text-slate-400 hover:text-slate-600'}
                `}
              >
                {t === 'login' ? '로그인' : '회원가입'}
              </button>
            ))}
          </div>

          {/* Login form */}
          {tab === 'login' && (
            <div className="flex flex-col gap-3" onKeyDown={handleKeyDown}>
              <div>
                <label className="block text-xs text-slate-500 mb-1">아이디</label>
                <input
                  className="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-blue-400"
                  placeholder="아이디를 입력하세요"
                  value={login.accountId}
                  onChange={(e) => setLogin({ ...login, accountId: e.target.value })}
                />
              </div>
              <div>
                <label className="block text-xs text-slate-500 mb-1">비밀번호</label>
                <input
                  className="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-blue-400"
                  type="password"
                  placeholder="비밀번호를 입력하세요"
                  value={login.password}
                  onChange={(e) => setLogin({ ...login, password: e.target.value })}
                />
              </div>

              {error && <p className="text-xs text-red-500">{error}</p>}

              <button
                className="w-full bg-slate-800 text-white py-2.5 rounded-lg text-sm font-medium hover:bg-slate-700 transition-colors disabled:opacity-50 mt-1"
                onClick={doLogin}
                disabled={loading}
              >
                {loading ? '로그인 중...' : '로그인'}
              </button>

              <div className="flex items-center gap-3 my-1">
                <div className="flex-1 h-px bg-slate-100" />
                <span className="text-xs text-slate-300">또는</span>
                <div className="flex-1 h-px bg-slate-100" />
              </div>

              <button
                className="w-full flex items-center justify-center gap-2 border border-slate-200 py-2.5 rounded-lg text-sm text-slate-600 hover:bg-slate-50 transition-colors"
                onClick={doGoogleLogin}
              >
                <svg width="16" height="16" viewBox="0 0 24 24">
                  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                </svg>
                Google로 로그인
              </button>
            </div>
          )}

          {/* Signup form */}
          {tab === 'signup' && (
            <div className="flex flex-col gap-3" onKeyDown={handleKeyDown}>
              <div>
                <label className="block text-xs text-slate-500 mb-1">이름</label>
                <input
                  className="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-blue-400"
                  placeholder="이름을 입력하세요"
                  value={signUp.username}
                  onChange={(e) => setSignUp({ ...signUp, username: e.target.value })}
                />
              </div>
              <div>
                <label className="block text-xs text-slate-500 mb-1">아이디</label>
                <input
                  className="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-blue-400"
                  placeholder="아이디를 입력하세요"
                  value={signUp.accountId}
                  onChange={(e) => setSignUp({ ...signUp, accountId: e.target.value })}
                />
              </div>
              <div>
                <label className="block text-xs text-slate-500 mb-1">비밀번호</label>
                <input
                  className="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-blue-400"
                  type="password"
                  placeholder="비밀번호를 입력하세요"
                  value={signUp.password}
                  onChange={(e) => setSignUp({ ...signUp, password: e.target.value })}
                />
              </div>
              <div>
                <label className="block text-xs text-slate-500 mb-1">이메일</label>
                <input
                  className="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-blue-400"
                  type="email"
                  placeholder="이메일을 입력하세요"
                  value={signUp.email}
                  onChange={(e) => setSignUp({ ...signUp, email: e.target.value })}
                />
              </div>

              {error && <p className="text-xs text-red-500">{error}</p>}

              <button
                className="w-full bg-slate-800 text-white py-2.5 rounded-lg text-sm font-medium hover:bg-slate-700 transition-colors disabled:opacity-50 mt-1"
                onClick={doSignUp}
                disabled={loading}
              >
                {loading ? '처리 중...' : '가입하기'}
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
