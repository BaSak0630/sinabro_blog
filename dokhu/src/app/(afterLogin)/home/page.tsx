'use client'
import { useQuery } from '@tanstack/react-query'
import { useRouter } from 'next/navigation'
import { getLibrary } from '@/services/library.api'
import { getNotices } from '@/services/user.api'
import PageContainer from '@/components/PageContainer'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Skeleton } from '@/components/ui/skeleton'
import { Button } from '@/components/ui/button'
import { spineColor } from '@/lib/utils'
import { BookOpen, BookMarked, TrendingUp, Bell } from 'lucide-react'
import { useUserStore } from '@/stores/useUserStore'
import Image from 'next/image'

export default function HomePage() {
  const router = useRouter()
  const { profile } = useUserStore()

  const { data: library = [], isLoading } = useQuery({
    queryKey: ['library'],
    queryFn: () => getLibrary(),
  })

  const { data: notices = [] } = useQuery({
    queryKey: ['notices'],
    queryFn: getNotices,
  })

  const reading = library.filter(b => b.status === 'READING')
  const totalRead = library.filter(b => b.status === 'COMPLETED').length
  const avgProgress = reading.length
    ? Math.round(reading.reduce((s, b) => s + b.progressPercent, 0) / reading.length)
    : 0

  return (
    <PageContainer className="space-y-6">
      {/* 인사말 */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">
            안녕하세요{profile ? `, ${profile.accountId}님` : ''} 👋
          </h1>
          <p className="text-sm text-muted-foreground mt-0.5">오늘도 독서를 시작해볼까요?</p>
        </div>
        <Button variant="highlight" onClick={() => router.push('/books')}>
          <BookOpen className="w-4 h-4" />
          책 탐색
        </Button>
      </div>

      {/* 통계 카드 */}
      <div className="grid grid-cols-3 gap-4">
        {[
          { label: '읽는 중', value: reading.length, icon: BookOpen, color: 'text-highlight' },
          { label: '완독', value: totalRead, icon: BookMarked, color: 'text-green-500' },
          { label: '평균 진행', value: `${avgProgress}%`, icon: TrendingUp, color: 'text-blue-500' },
        ].map(stat => (
          <Card key={stat.label}>
            <CardContent className="pt-5">
              <div className="flex items-center gap-3">
                <stat.icon className={`w-5 h-5 ${stat.color}`} />
                <div>
                  <p className="text-xl font-bold text-foreground">{stat.value}</p>
                  <p className="text-xs text-muted-foreground">{stat.label}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* 읽는 중인 책 */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>읽는 중</CardTitle>
            <Button variant="ghost" size="sm" onClick={() => router.push('/library')}>
              전체 보기
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="space-y-3">
              {[1, 2].map(i => <Skeleton key={i} className="h-16 w-full" />)}
            </div>
          ) : reading.length === 0 ? (
            <div className="flex flex-col items-center py-8 gap-3">
              <BookOpen className="w-10 h-10 text-muted-foreground/40" />
              <p className="text-sm text-muted-foreground">읽는 중인 책이 없어요</p>
              <Button variant="highlight" size="sm" onClick={() => router.push('/books')}>
                책 추가하기
              </Button>
            </div>
          ) : (
            <div className="space-y-3">
              {reading.slice(0, 5).map(ub => (
                <div
                  key={ub.id}
                  className="flex items-center gap-3 p-3 rounded-lg hover:bg-accent cursor-pointer transition-colors"
                  onClick={() => router.push(`/book/${ub.id}`)}
                >
                  <div
                    className="w-9 h-13 rounded shrink-0 flex items-end overflow-hidden"
                    style={{
                      width: 36, height: 52,
                      background: ub.book.coverImageUrl ? undefined : spineColor(ub.id),
                    }}
                  >
                    {ub.book.coverImageUrl && (
                      <img src={ub.book.coverImageUrl} alt={ub.book.title} className="w-full h-full object-cover" />
                    )}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium truncate text-foreground">{ub.book.title}</p>
                    <p className="text-xs text-muted-foreground truncate">{ub.book.author}</p>
                    <div className="flex items-center gap-2 mt-1.5">
                      <Progress value={ub.progressPercent} className="h-1.5 flex-1" />
                      <span className="text-[10px] text-muted-foreground shrink-0">{ub.progressPercent}%</span>
                    </div>
                  </div>
                  <Button variant="highlight" size="sm" onClick={e => { e.stopPropagation(); router.push(`/flow/${ub.id}`) }}>
                    읽기
                  </Button>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* 공지 */}
      {notices.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Bell className="w-4 h-4" />
              공지사항
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {notices.slice(0, 3).map(n => (
                <div key={n.id} className="p-3 rounded-lg bg-muted/50">
                  <p className="text-sm font-medium text-foreground">{n.title}</p>
                  <p className="text-xs text-muted-foreground mt-0.5 line-clamp-2">{n.content}</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </PageContainer>
  )
}
