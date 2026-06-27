'use client'
import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useParams, useRouter } from 'next/navigation'
import { getUserBook, updateProgress, updateRating, deleteUserBook } from '@/services/library.api'
import { getSessionHistory } from '@/services/flow.api'
import PageContainer from '@/components/PageContainer'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { spineColor, formatTime } from '@/lib/utils'
import { ArrowLeft, Play, FileText, Trash2, Star, Clock } from 'lucide-react'

export default function BookDetailPage() {
  const { userBookId } = useParams<{ userBookId: string }>()
  const router = useRouter()
  const qc = useQueryClient()
  const id = Number(userBookId)

  const { data: ub, isLoading } = useQuery({
    queryKey: ['userBook', id],
    queryFn: () => getUserBook(id),
  })

  const { data: sessions = [] } = useQuery({
    queryKey: ['sessions', id],
    queryFn: () => getSessionHistory(id),
    enabled: !!ub,
  })

  const [progressInput, setProgressInput] = useState('')
  const [hoveredStar, setHoveredStar] = useState(0)

  const progressMutation = useMutation({
    mutationFn: (page: number) => updateProgress(id, page),
    onSuccess: (data) => {
      qc.setQueryData(['userBook', id], data)
      setProgressInput(String(data.currentPage))
    },
  })

  const ratingMutation = useMutation({
    mutationFn: (star: number) => updateRating(id, star),
    onSuccess: (data) => qc.setQueryData(['userBook', id], data),
  })

  const deleteMutation = useMutation({
    mutationFn: () => deleteUserBook(id),
    onSuccess: () => router.push('/library'),
  })

  // progressInput 초기화
  if (ub && progressInput === '') setProgressInput(String(ub.currentPage))

  const totalSessionSeconds = sessions.reduce((s, sess) => s + (sess.totalSeconds ?? 0), 0)

  if (isLoading) {
    return (
      <PageContainer className="space-y-5">
        <Skeleton className="h-8 w-32" />
        <div className="flex gap-5">
          <Skeleton className="w-36 h-52 rounded-xl" />
          <div className="flex-1 space-y-3">
            <Skeleton className="h-6 w-3/4" />
            <Skeleton className="h-4 w-1/2" />
            <Skeleton className="h-4 w-full" />
          </div>
        </div>
      </PageContainer>
    )
  }

  if (!ub) return null

  const { book } = ub

  return (
    <PageContainer className="space-y-5">
      {/* 뒤로 */}
      <button
        onClick={() => router.push('/library')}
        className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors"
      >
        <ArrowLeft className="w-4 h-4" />
        서재로
      </button>

      {/* 표지 + 기본 정보 */}
      <div className="flex gap-5">
        <div
          className="shrink-0 rounded-xl overflow-hidden shadow-xl"
          style={{ width: 140, height: 210, background: book.coverImageUrl ? undefined : spineColor(ub.id) }}
        >
          {book.coverImageUrl ? (
            <img src={book.coverImageUrl} alt={book.title} className="w-full h-full object-cover" />
          ) : (
            <div className="w-full h-full flex items-center justify-center p-3">
              <span className="text-white/60 text-xs text-center font-medium leading-tight">{book.title}</span>
            </div>
          )}
        </div>

        <div className="flex-1 min-w-0">
          {book.genre && (
            <span className="text-[10px] px-2 py-0.5 rounded-full bg-highlight/20 text-highlight font-medium mb-2 inline-block">
              {book.genre}
            </span>
          )}
          <h1 className="text-xl font-bold text-foreground leading-tight mb-1">{book.title}</h1>
          <p className="text-sm text-muted-foreground mb-3">{book.author}</p>

          {/* 별점 */}
          <div className="flex items-center gap-0.5 mb-4">
            {Array.from({ length: 5 }).map((_, i) => (
              <button
                key={i}
                onMouseEnter={() => setHoveredStar(i + 1)}
                onMouseLeave={() => setHoveredStar(0)}
                onClick={() => ratingMutation.mutate(i + 1)}
                className="transition-transform hover:scale-110"
              >
                <Star
                  className="w-5 h-5"
                  fill={i < (hoveredStar || ub.starRating) ? 'currentColor' : 'none'}
                  style={{ color: i < (hoveredStar || ub.starRating) ? '#f97316' : undefined }}
                />
              </button>
            ))}
          </div>

          {/* 메타 정보 */}
          <div className="grid grid-cols-2 gap-2">
            {[
              { label: '출판사', value: book.publisher },
              { label: '발행일', value: book.publishDate },
              { label: 'ISBN', value: book.isbn },
              { label: '총 페이지', value: book.totalPages ? `${book.totalPages}p` : null },
            ].filter(i => i.value).map(item => (
              <div key={item.label} className="rounded-lg p-2.5 bg-muted/50">
                <p className="text-[10px] text-muted-foreground">{item.label}</p>
                <p className="text-xs font-medium text-foreground mt-0.5 truncate">{item.value}</p>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* 행동 버튼 */}
      <div className="flex gap-2">
        <Button className="flex-1" variant="highlight" onClick={() => router.push(`/flow/${ub.id}`)}>
          <Play className="w-4 h-4" />
          {ub.status === 'ADDING' ? '읽기 시작' : '이어 읽기'}
        </Button>
        <Button variant="outline" onClick={() => router.push(`/note/${ub.id}`)}>
          <FileText className="w-4 h-4" />
          노트
        </Button>
      </div>

      {/* 진행률 */}
      {book.totalPages && (
        <Card>
          <CardHeader><CardTitle className="text-base">독서 진행</CardTitle></CardHeader>
          <CardContent className="space-y-3">
            <div className="flex items-center justify-between text-sm">
              <span className="text-muted-foreground">{ub.currentPage} / {book.totalPages}p</span>
              <span className="font-bold text-highlight">{ub.progressPercent}%</span>
            </div>
            <Progress value={ub.progressPercent} />
            <div className="flex gap-2 items-center">
              <input
                type="number" min={0} max={book.totalPages}
                className="w-28 h-9 rounded-lg border border-border bg-background px-3 text-sm outline-none focus:border-highlight transition-colors"
                placeholder="현재 페이지"
                value={progressInput}
                onChange={e => setProgressInput(e.target.value)}
              />
              <span className="text-xs text-muted-foreground">/ {book.totalPages}p</span>
              <Button
                size="sm"
                variant="secondary"
                onClick={() => progressMutation.mutate(Number(progressInput))}
                disabled={progressMutation.isPending}
                className="ml-auto"
              >
                업데이트
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* 책 소개 */}
      {book.synopsis && (
        <Card>
          <CardHeader><CardTitle className="text-base">책 소개</CardTitle></CardHeader>
          <CardContent>
            <p className="text-sm text-muted-foreground leading-relaxed">{book.synopsis}</p>
          </CardContent>
        </Card>
      )}

      {/* 세션 기록 */}
      {sessions.length > 0 && (
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="text-base flex items-center gap-2">
                <Clock className="w-4 h-4" />
                독서 기록
              </CardTitle>
              <span className="text-xs text-muted-foreground">총 {formatTime(totalSessionSeconds)}</span>
            </div>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {sessions.slice(0, 5).map(s => (
                <div key={s.id} className="flex items-center justify-between py-2 border-b border-border last:border-0">
                  <div>
                    <p className="text-xs text-foreground">{new Date(s.startTime).toLocaleDateString('ko')}</p>
                    {s.memo && <p className="text-[10px] text-muted-foreground mt-0.5 line-clamp-1">{s.memo}</p>}
                  </div>
                  <div className="text-right">
                    <p className="text-xs font-mono font-medium text-foreground">{formatTime(s.totalSeconds ?? 0)}</p>
                    {s.bookmarkPage && <p className="text-[10px] text-muted-foreground">{s.bookmarkPage}p</p>}
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* 삭제 */}
      <div className="flex justify-end pt-2 pb-8">
        <Button
          variant="ghost"
          size="sm"
          className="text-destructive hover:text-destructive hover:bg-destructive/10"
          onClick={() => { if (confirm('정말 삭제하시겠습니까?')) deleteMutation.mutate() }}
        >
          <Trash2 className="w-4 h-4" />
          서재에서 삭제
        </Button>
      </div>
    </PageContainer>
  )
}
