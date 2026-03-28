import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import type UserProfile from '@/entity/user/UserProfile'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'

const USER_REPOSITORY = container.resolve(AccountRepository)
const PROFILE_REPOSITORY = container.resolve(ProfileRepository)

interface ServiceCard {
  name: string
  description: string
  tag: string
  path: string
  available: boolean
  color: string
}

const SERVICES: ServiceCard[] = [
  {
    name: 'sinabro_blog',
    description: '기술과 경험을 기록하고 공유하는 블로그',
    tag: 'BLOG',
    path: '/blog',
    available: true,
    color: 'from-blue-500 to-blue-600',
  },
  {
    name: 'FinTree',
    description: '금융 지식을 체계적으로 배우는 튜토리얼 서비스',
    tag: 'FINANCE',
    path: '/fintree',
    available: true,
    color: 'from-emerald-500 to-teal-600',
  },
]

export default function MainView() {
  const navigate = useNavigate()
  const [profile, setProfile] = useState<UserProfile | null>(null)
  useEffect(() => {
    USER_REPOSITORY.getProfile()
      .then((p) => {
        PROFILE_REPOSITORY.setProfile(p)
        setProfile(p)
      })
      .catch(() => {/* 비로그인 상태 */})
  }, [])

  function logout() {
    PROFILE_REPOSITORY.clear()
    location.href = '/api/logout'
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-blue-50">
      {/* Top nav */}
      <header className="px-10 py-5 flex items-center justify-between border-b border-slate-100 bg-white/70 backdrop-blur-sm">
        <span className="text-xl font-bold tracking-tight text-slate-800">Sinabro</span>

        <div className="flex items-center gap-3">
          {profile === null ? (
            <>
              <button
                onClick={() => navigate('/login', { state: { from: '/', tab: 'signup' } })}
                className="text-sm text-slate-500 hover:text-slate-800 transition-colors"
              >
                회원가입
              </button>
              <button
                onClick={() => navigate('/login', { state: { from: '/' } })}
                className="text-sm bg-slate-800 text-white px-4 py-1.5 rounded-lg hover:bg-slate-700 transition-colors"
              >
                로그인
              </button>
            </>
          ) : (
            <>
              <span className="text-sm text-slate-400">{profile.accountId}</span>
              <button
                onClick={logout}
                className="text-sm text-slate-500 hover:text-slate-800 transition-colors"
              >
                로그아웃
              </button>
            </>
          )}
        </div>
      </header>

      {/* Hero */}
      <main className="max-w-3xl mx-auto px-8 pt-20 pb-12 text-center">
        <div className="inline-block text-xs font-semibold tracking-widest text-blue-500 bg-blue-50 px-3 py-1 rounded-full mb-6">
          PLATFORM
        </div>
        <h1 className="text-5xl font-bold text-slate-800 mb-5 tracking-tight">Sinabro</h1>
        <p className="text-lg text-slate-400 font-light">
          모르는 사이에 조금씩 조금씩
        </p>
      </main>

      {/* Service cards */}
      <section className="max-w-3xl mx-auto px-8 pb-24">
        <p className="text-sm text-slate-400 mb-6 text-center tracking-wide uppercase">Services</p>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
          {SERVICES.map((svc) => (
            <div
              key={svc.name}
              onClick={() => svc.available && navigate(svc.path)}
              className={`
                relative rounded-2xl p-6 border transition-all duration-200
                ${svc.available
                  ? 'border-slate-200 bg-white shadow-sm hover:shadow-md hover:-translate-y-0.5 cursor-pointer'
                  : 'border-slate-100 bg-slate-50 cursor-default opacity-60'}
              `}
            >
              <span className={`
                inline-block text-[10px] font-bold tracking-widest px-2 py-0.5 rounded mb-4
                bg-gradient-to-r ${svc.color} text-white
              `}>
                {svc.tag}
              </span>

              {!svc.available && (
                <span className="absolute top-4 right-4 text-[10px] font-semibold text-slate-400 border border-slate-200 px-2 py-0.5 rounded-full">
                  Coming Soon
                </span>
              )}

              <h2 className="text-lg font-bold text-slate-800 mb-2">{svc.name}</h2>
              <p className="text-sm text-slate-400 leading-relaxed">{svc.description}</p>

              {svc.available && (
                <div className="mt-5 flex items-center text-xs font-medium text-blue-500">
                  바로가기 <span className="ml-1">→</span>
                </div>
              )}
            </div>
          ))}
        </div>
      </section>

      {/* Footer */}
      <footer className="text-center text-xs text-slate-300 pb-10">
        © 2025 Sinabro. All rights reserved.
      </footer>

    </div>
  )
}
