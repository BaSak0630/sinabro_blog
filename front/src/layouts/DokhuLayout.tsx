import React, { useEffect, useState } from 'react'
import { Outlet, useNavigate, useLocation } from 'react-router-dom'
import { container } from 'tsyringe'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'
import type UserProfile from '@/entity/user/UserProfile'
import { ThemeProvider, useTheme } from '@/context/ThemeContext'

const USER_REPO = container.resolve(AccountRepository)
const PROFILE_REPO = container.resolve(ProfileRepository)

const SIDEBAR_W = 110

function NavItem({ icon, label, active, badge, onClick }: {
  icon: React.ReactNode
  label: string
  active?: boolean
  badge?: number
  onClick: () => void
}) {
  const { c } = useTheme()
  return (
    <button
      onClick={onClick}
      className="w-full flex items-center gap-3 px-4 py-2.5 rounded-xl transition-colors relative"
      style={{
        background: active ? c.borderSub : 'transparent',
        color: active ? '#f97316' : c.textMuted,
      }}
    >
      <span className="flex-shrink-0">{icon}</span>
      <span className="text-xs font-medium">{label}</span>
      {badge != null && badge > 0 && (
        <span className="ml-auto w-4 h-4 rounded-full bg-orange-500 flex items-center justify-center text-[9px] text-white font-bold flex-shrink-0">
          {badge}
        </span>
      )}
      {active && (
        <span className="absolute left-0 top-1/2 -translate-y-1/2 w-0.5 h-5 bg-orange-400 rounded-r-full" />
      )}
    </button>
  )
}

function DokhuLayoutInner() {
  const navigate = useNavigate()
  const location = useLocation()
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const { c, isDark, toggle } = useTheme()

  useEffect(() => {
    USER_REPO.getProfile()
      .then(p => { PROFILE_REPO.setProfile(p); setProfile(p) })
      .catch(() => {})
  }, [])

  const path = location.pathname

  return (
    <div className="flex min-h-screen" style={{ background: c.bg }}>
      {/* 사이드바 */}
      <aside
        className="fixed left-0 top-0 h-full flex flex-col z-30 border-r"
        style={{ width: SIDEBAR_W, background: c.sidebar, borderColor: c.borderSub }}
      >
        {/* 로고 */}
        <button
          onClick={() => navigate('/dokhu')}
          className="flex items-center px-4 py-3.5 border-b"
          style={{ borderColor: c.borderSub }}
        >
          <span className="text-orange-400 font-black text-sm tracking-tight">DOKHU</span>
        </button>

        {/* 메뉴 */}
        <nav className="flex flex-col flex-1 pt-3 px-2 gap-0.5">
          <NavItem label="홈" active={path === '/dokhu'} onClick={() => navigate('/dokhu')}
            icon={<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9,22 9,12 15,12 15,22"/></svg>}
          />
          <NavItem label="서재" active={path.startsWith('/dokhu/library') || path.startsWith('/dokhu/book')} onClick={() => navigate('/dokhu/library')}
            icon={<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>}
          />
          <NavItem label="통계" active={path === '/dokhu/stats'} onClick={() => navigate('/dokhu/stats')}
            icon={<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>}
          />
          <NavItem label="우편함" active={path === '/dokhu/mailbox'} onClick={() => navigate('/dokhu/mailbox')}
            icon={<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>}
          />
        </nav>

        {/* 하단 */}
        <div className="flex flex-col px-2 pb-3 gap-0.5 border-t pt-2" style={{ borderColor: c.borderSub }}>
          {/* 다크모드 토글 */}
          <button
            onClick={toggle}
            className="w-full flex items-center gap-3 px-4 py-2.5 rounded-xl transition-colors"
            style={{ color: c.textMuted }}
          >
            {isDark ? (
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
              </svg>
            ) : (
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
              </svg>
            )}
            <span className="text-xs font-medium">{isDark ? '라이트' : '다크'}</span>
          </button>

          {profile ? (
            <button
              onClick={() => navigate(`/blog/profile/${profile.accountId}`)}
              className="w-full flex items-center gap-3 px-4 py-2.5 rounded-xl transition-colors"
              style={{ color: c.textMuted }}
            >
              <div className="w-5 h-5 rounded-full bg-gradient-to-br from-orange-400 to-red-500 flex items-center justify-center text-white text-[9px] font-bold flex-shrink-0">
                {profile.accountId.charAt(0).toUpperCase()}
              </div>
              <span className="text-xs font-medium truncate">{profile.accountId}</span>
            </button>
          ) : (
            <button
              onClick={() => navigate('/login', { state: { from: '/dokhu' } })}
              className="w-full flex items-center gap-3 px-4 py-2.5 rounded-xl transition-colors"
              style={{ color: c.textMuted }}
            >
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
              </svg>
              <span className="text-xs font-medium">로그인</span>
            </button>
          )}
        </div>
      </aside>

      {/* 메인 콘텐츠 */}
      <main className="flex-1 min-h-screen" style={{ marginLeft: SIDEBAR_W }}>
        <Outlet />
      </main>
    </div>
  )
}

export default function DokhuLayout() {
  return (
    <ThemeProvider>
      <DokhuLayoutInner />
    </ThemeProvider>
  )
}
