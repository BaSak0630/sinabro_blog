import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import type UserProfile from '@/entity/user/UserProfile'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'

const USER_REPO = container.resolve(AccountRepository)
const PROFILE_REPO = container.resolve(ProfileRepository)

export default function DokhuNav() {
  const navigate = useNavigate()
  const [profile, setProfile] = useState<UserProfile | null>(null)

  useEffect(() => {
    USER_REPO.getProfile()
      .then((p) => { PROFILE_REPO.setProfile(p); setProfile(p) })
      .catch(() => {})
  }, [])

  function logout() {
    PROFILE_REPO.clear()
    window.location.href = '/api/logout'
  }

  return (
    <header className="sticky top-0 z-20 bg-white/90 backdrop-blur-sm border-b border-amber-100">
      <div className="max-w-5xl mx-auto px-6 h-14 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate('/')}
            className="text-xs font-semibold text-slate-400 hover:text-slate-600 transition-colors"
          >
            ◀ Sinabro
          </button>
          <span className="text-slate-200">|</span>
          <button
            onClick={() => navigate('/dokhu')}
            className="text-base font-bold text-amber-600 hover:text-amber-700 transition-colors tracking-tight"
          >
            📚 DOKHU
          </button>
        </div>

        <nav className="flex items-center gap-1 text-sm">
          <button
            onClick={() => navigate('/dokhu')}
            className="px-3 py-1.5 rounded-lg text-slate-500 hover:bg-amber-50 hover:text-amber-700 transition-colors text-xs font-medium"
          >
            홈
          </button>
          <button
            onClick={() => navigate('/dokhu/library')}
            className="px-3 py-1.5 rounded-lg text-slate-500 hover:bg-amber-50 hover:text-amber-700 transition-colors text-xs font-medium"
          >
            책장
          </button>
          <button
            onClick={() => navigate('/dokhu/mailbox')}
            className="px-3 py-1.5 rounded-lg text-slate-500 hover:bg-amber-50 hover:text-amber-700 transition-colors text-xs font-medium"
          >
            공지
          </button>
        </nav>

        <div className="text-xs">
          {profile === null ? (
            <button
              onClick={() => navigate('/login', { state: { from: '/dokhu' } })}
              className="bg-amber-500 text-white px-3 py-1.5 rounded-lg hover:bg-amber-600 transition-colors font-medium"
            >
              로그인
            </button>
          ) : (
            <div className="flex items-center gap-2 text-slate-400">
              <span className="text-slate-600 font-medium">{profile.accountId}</span>
              <span>·</span>
              <button onClick={logout} className="hover:text-slate-700 transition-colors">
                로그아웃
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  )
}
