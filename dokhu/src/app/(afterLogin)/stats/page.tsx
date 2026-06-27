'use client'
import { useQuery } from '@tanstack/react-query'
import { getLibrary } from '@/services/library.api'
import PageContainer from '@/components/PageContainer'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Skeleton } from '@/components/ui/skeleton'
import { BookOpen, BookMarked, Star, TrendingUp } from 'lucide-react'
import { spineColor } from '@/lib/utils'

export default function StatsPage() {
  const { data: library = [], isLoading } = useQuery({
    queryKey: ['library'],
    queryFn: () => getLibrary(),
  })

  const total = library.length
  const completed = library.filter(b => b.status === 'COMPLETED').length
  const reading = library.filter(b => b.status === 'READING').length
  const avgRating = library.filter(b => b.starRating > 0).length
    ? (library.filter(b => b.starRating > 0).reduce((s, b) => s + b.starRating, 0) / library.filter(b => b.starRating > 0).length).toFixed(1)
    : '—'
  const totalPages = library.reduce((s, b) => s + (b.currentPage || 0), 0)

  const byGenre = library.reduce<Record<string, number>>((acc, b) => {
    const g = b.book.genre ?? '기타'
    acc[g] = (acc[g] ?? 0) + 1
    return acc
  }, {})

  if (isLoading) return (
    <PageContainer className="space-y-5">
      <Skeleton className="h-8 w-32" />
      <div className="grid grid-cols-2 gap-4">
        {[1,2,3,4].map(i => <Skeleton key={i} className="h-24" />)}
      </div>
    </PageContainer>
  )

  return (
    <PageContainer className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-foreground">독서 통계</h1>
        <p className="text-sm text-muted-foreground mt-0.5">나의 독서 기록</p>
      </div>

      {/* 요약 카드 */}
      <div className="grid grid-cols-2 gap-4">
        {[
          { label: '전체 책', value: total, icon: BookOpen, color: 'text-highlight' },
          { label: '완독', value: completed, icon: BookMarked, color: 'text-green-500' },
          { label: '읽는 중', value: reading, icon: TrendingUp, color: 'text-blue-500' },
          { label: '평균 별점', value: avgRating, icon: Star, color: 'text-yellow-500' },
        ].map(s => (
          <Card key={s.label}>
            <CardContent className="pt-5">
              <div className="flex items-center gap-3">
                <s.icon className={`w-5 h-5 ${s.color}`} />
                <div>
                  <p className="text-xl font-bold text-foreground">{s.value}</p>
                  <p className="text-xs text-muted-foreground">{s.label}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardContent className="pt-5">
          <p className="text-xs text-muted-foreground mb-1">총 읽은 페이지</p>
          <p className="text-3xl font-bold text-foreground">{totalPages.toLocaleString()}<span className="text-base font-normal text-muted-foreground ml-1">p</span></p>
        </CardContent>
      </Card>

      {/* 장르별 */}
      {Object.keys(byGenre).length > 0 && (
        <Card>
          <CardHeader><CardTitle className="text-base">장르별 독서</CardTitle></CardHeader>
          <CardContent className="space-y-3">
            {Object.entries(byGenre)
              .sort(([, a], [, b]) => b - a)
              .map(([genre, count]) => (
                <div key={genre}>
                  <div className="flex items-center justify-between text-sm mb-1">
                    <span className="text-foreground">{genre}</span>
                    <span className="text-muted-foreground">{count}권</span>
                  </div>
                  <Progress value={(count / total) * 100} />
                </div>
              ))}
          </CardContent>
        </Card>
      )}

      {/* 최근 완독 */}
      {completed > 0 && (
        <Card>
          <CardHeader><CardTitle className="text-base">완독한 책</CardTitle></CardHeader>
          <CardContent>
            <div className="flex flex-wrap gap-2">
              {library.filter(b => b.status === 'COMPLETED').slice(0, 10).map(ub => (
                <div
                  key={ub.id}
                  className="flex items-center gap-2 rounded-lg p-2 bg-muted/50"
                >
                  <div
                    className="w-6 h-9 rounded shrink-0 overflow-hidden"
                    style={{ background: ub.book.coverImageUrl ? undefined : spineColor(ub.id) }}
                  >
                    {ub.book.coverImageUrl && (
                      <img src={ub.book.coverImageUrl} alt="" className="w-full h-full object-cover" />
                    )}
                  </div>
                  <div>
                    <p className="text-xs font-medium text-foreground truncate max-w-[120px]">{ub.book.title}</p>
                    {ub.starRating > 0 && (
                      <p className="text-[10px] text-yellow-500">{'★'.repeat(ub.starRating)}</p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </PageContainer>
  )
}
