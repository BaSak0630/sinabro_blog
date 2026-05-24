import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import type UserProfile from '@/entity/user/UserProfile'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)
const PROFILE_REPOSITORY = container.resolve(ProfileRepository)

export default function FinTreeNav() {
  const navigate = useNavigate()
  const [profile, setProfile] = useState<UserProfile | null>(null)

  useEffect(() => {
    USER_REPOSITORY.getProfile()
      .then((p) => { PROFILE_REPOSITORY.setProfile(p); setProfile(p) })
      .catch(() => {})
  }, [])

  function logout() {
    PROFILE_REPOSITORY.clear()
    window.location.href = '/api/logout'
  }

  return (
    <header className="sticky top-0 z-20 bg-white/80 backdrop-blur-sm border-b border-slate-100">
      <div className="max-w-6xl mx-auto px-8 h-14 flex items-center justify-between">

        <button
          onClick={() => navigate('/')}
          className="flex items-center gap-1.5 text-xs font-semibold text-slate-500 bg-slate-100 px-3 py-1.5 rounded-lg hover:bg-slate-200 transition-colors"
        >
          <span className="text-slate-400">◀</span> Sinabro
        </button>

        <span
          className="text-base font-bold tracking-tight cursor-pointer hover:text-emerald-600 transition-colors"
          style={{ color: '#059669' }}
          onClick={() => navigate('/fintree')}
        >
          FinTree
        </span>

        <nav className="flex items-center gap-5 text-sm text-slate-500">
          <button
            onClick={() => navigate('/fintree/tree')}
            className="text-xs font-semibold text-slate-600 hover:text-emerald-600 transition-colors"
          >
            스킬트리
          </button>
          {profile === null ? (
            <button
              onClick={() => navigate('/login', { state: { from: '/fintree' } })}
              className="bg-emerald-700 text-white text-xs font-medium px-3 py-1.5 rounded-lg hover:bg-emerald-600 transition-colors"
            >
              로그인
            </button>
          ) : (
            <div className="flex items-center gap-1.5 text-xs text-slate-400">
              <button
                onClick={() => navigate(`/blog/profile/${profile.accountId}`)}
                className="text-slate-600 font-medium hover:text-emerald-600 transition-colors"
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
