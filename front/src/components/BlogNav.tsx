import React, { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import type UserProfile from '@/entity/user/UserProfile'
import type HttpError from '@/http/HttpError'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)
const PROFILE_REPOSITORY = container.resolve(ProfileRepository)

export default function BlogNav() {
  const navigate = useNavigate()
  const [profile, setProfile] = useState<UserProfile | null>(null)

  useEffect(() => {
    USER_REPOSITORY.getProfile()
      .then((p) => {
        PROFILE_REPOSITORY.setProfile(p)
        setProfile(p)
      })
      .catch((e: HttpError) => {
        if (e.getCode() !== '401') console.error(e.getMessage())
      })
  }, [])

  function logout() {
    PROFILE_REPOSITORY.clear()
    location.href = '/api/logout'
  }

  return (
    <header className="sticky top-0 z-20 bg-white/80 backdrop-blur-sm border-b border-slate-100">
      <div className="max-w-6xl mx-auto px-8 h-14 flex items-center justify-between">

        {/* Back to Sinabro — 명확한 pill 버튼 */}
        <button
          onClick={() => navigate('/')}
          className="flex items-center gap-1.5 text-xs font-semibold text-slate-500 bg-slate-100 px-3 py-1.5 rounded-lg hover:bg-slate-200 transition-colors"
        >
          <span className="text-slate-400">◀</span> Sinabro
        </button>

        {/* Blog brand */}
        <span
          className="text-base font-bold tracking-tight text-slate-800 cursor-pointer hover:text-blue-600 transition-colors"
          onClick={() => navigate('/blog')}
        >
          sinabro_blog
        </span>

        {/* Right nav */}
        <nav className="flex items-center gap-5 text-sm text-slate-500">
          <Link to="/blog" className="hover:text-slate-800 transition-colors">홈</Link>

          {profile?.isAdmin() && (
            <Link to="/blog/write" className="hover:text-slate-800 transition-colors">글 작성</Link>
          )}

          {profile === null ? (
            <Link
              to="/login"
              state={{ from: '/blog' }}
              className="bg-slate-800 text-white text-xs font-medium px-3 py-1.5 rounded-lg hover:bg-slate-700 transition-colors"
            >
              로그인
            </Link>
          ) : (
            <div className="flex items-center gap-1.5 text-xs text-slate-400">
              <button
                onClick={() => navigate(`/blog/profile/${profile.accountId}`)}
                className="text-slate-600 font-medium hover:text-blue-600 transition-colors"
              >
                {profile.accountId}
              </button>
              <span>·</span>
              <button onClick={logout} className="hover:text-slate-700 transition-colors">
                로그아웃
              </button>
            </div>
          )}
        </nav>
      </div>
    </header>
  )
}
