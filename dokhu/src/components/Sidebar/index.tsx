'use client'
import { useSidebarStore } from '@/stores/useSidebarStore'
import { useUserStore } from '@/stores/useUserStore'
import { usePathname, useRouter } from 'next/navigation'
import { useTheme } from 'next-themes'
import Link from 'next/link'
import {
  Menu, Home, BookOpen, Search, BarChart3, Mail,
  Moon, Sun, LogOut, BookMarked, ChevronLeft,
} from 'lucide-react'
import { cn } from '@/lib/utils'
import { logout } from '@/services/user.api'
import { useEffect } from 'react'
import { getMe } from '@/services/user.api'

const NAV = [
  { href: '/home', icon: Home, label: '홈' },
  { href: '/library', icon: BookMarked, label: '서재' },
  { href: '/books', icon: Search, label: '책 탐색' },
  { href: '/mailbox', icon: Mail, label: '공지' },
  { href: '/stats', icon: BarChart3, label: '통계' },
]

const FLOW_HIDDEN = ['/flow', '/report']

export default function Sidebar({ children }: { children: React.ReactNode }) {
  const { isOpen, toggle } = useSidebarStore()
  const { profile, setProfile } = useUserStore()
  const pathname = usePathname()
  const router = useRouter()
  const { resolvedTheme, setTheme } = useTheme()

  useEffect(() => {
    if (!profile) {
      getMe().then(setProfile).catch(() => {})
    }
  }, [])

  const isHidden = FLOW_HIDDEN.some(p => pathname.startsWith(p))

  async function handleLogout() {
    try {
      await logout()
    } finally {
      setProfile(null)
      window.location.href = '/api/logout'
    }
  }

  if (isHidden) {
    return <main className="flex-1 h-screen overflow-hidden">{children}</main>
  }

  return (
    <div className="flex h-screen overflow-hidden bg-background">
      {/* 사이드바 */}
      <aside
        className={cn(
          'flex flex-col border-r border-border bg-background transition-all duration-200 shrink-0',
          isOpen ? 'w-48' : 'w-14'
        )}
      >
        {/* 상단 로고 + 토글 */}
        <div className="flex items-center justify-between border-b border-border px-3 h-14">
          {isOpen && (
            <Link href="/home" className="text-base font-bold text-foreground tracking-tight">
              📚 DOKHU
            </Link>
          )}
          <button
            onClick={toggle}
            className="ml-auto p-1.5 rounded-md hover:bg-accent transition-colors"
          >
            {isOpen ? <ChevronLeft className="w-4 h-4" /> : <Menu className="w-4 h-4" />}
          </button>
        </div>

        {/* 네비게이션 */}
        <nav className="flex-1 py-3 px-2 space-y-1 overflow-y-auto">
          {NAV.map(({ href, icon: Icon, label }) => {
            const active = pathname === href || pathname.startsWith(href + '/')
            return (
              <Link
                key={href}
                href={href}
                className={cn(
                  'flex items-center gap-3 rounded-lg px-2.5 py-2 text-sm font-medium transition-colors',
                  active
                    ? 'bg-highlight text-highlight-foreground'
                    : 'text-muted-foreground hover:bg-accent hover:text-foreground'
                )}
              >
                <Icon className="w-4 h-4 shrink-0" />
                {isOpen && <span className="truncate">{label}</span>}
              </Link>
            )
          })}
        </nav>

        {/* 하단 유저 정보 + 다크모드 */}
        <div className="border-t border-border p-2 space-y-1">
          <button
            onClick={() => setTheme(resolvedTheme === 'dark' ? 'light' : 'dark')}
            className="flex items-center gap-3 w-full rounded-lg px-2.5 py-2 text-sm text-muted-foreground hover:bg-accent hover:text-foreground transition-colors"
          >
            {resolvedTheme === 'dark'
              ? <Sun className="w-4 h-4 shrink-0" />
              : <Moon className="w-4 h-4 shrink-0" />}
            {isOpen && <span>{resolvedTheme === 'dark' ? '라이트 모드' : '다크 모드'}</span>}
          </button>

          {profile && (
            <>
              {isOpen && (
                <div className="px-2.5 py-1">
                  <p className="text-xs font-medium text-foreground truncate">{profile.accountId}</p>
                  <p className="text-[10px] text-muted-foreground">{profile.role}</p>
                </div>
              )}
              <button
                onClick={handleLogout}
                className="flex items-center gap-3 w-full rounded-lg px-2.5 py-2 text-sm text-muted-foreground hover:bg-destructive/10 hover:text-destructive transition-colors"
              >
                <LogOut className="w-4 h-4 shrink-0" />
                {isOpen && <span>로그아웃</span>}
              </button>
            </>
          )}

          {!profile && (
            <Link
              href="/login"
              className="flex items-center gap-3 rounded-lg px-2.5 py-2 text-sm text-highlight font-medium hover:bg-highlight/10 transition-colors"
            >
              <BookOpen className="w-4 h-4 shrink-0" />
              {isOpen && <span>로그인</span>}
            </Link>
          )}
        </div>
      </aside>

      {/* 메인 콘텐츠 */}
      <main className="flex-1 overflow-y-auto no-scrollbar">
        {children}
      </main>
    </div>
  )
}
