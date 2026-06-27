'use client'
import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { useRouter } from 'next/navigation'
import { getLibrary } from '@/services/library.api'
import PageContainer from '@/components/PageContainer'
import { Card, CardContent } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Skeleton } from '@/components/ui/skeleton'
import { Button } from '@/components/ui/button'
import { spineColor } from '@/lib/utils'
import { BookOpen, Play } from 'lucide-react'
import type { ReadingStatus } from '@/types'

const TABS: { label: string; value: string }[] = [
  { label: '전체', value: '' },
  { label: '읽는 중', value: 'READING' },
  { label: '완독', value: 'COMPLETED' },
  { label: '추가됨', value: 'ADDING' },
]

export default function LibraryPage() {
  const router = useRouter()
  const [status, setStatus] = useState('')

  const { data: books = [], isLoading } = useQuery({
    queryKey: ['library', status],
    queryFn: () => getLibrary(status || undefined),
  })

  return (
    <PageContainer className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">내 서재</h1>
          <p className="text-sm text-muted-foreground mt-0.5">총 {books.length}권</p>
        </div>
        <Button variant="highlight" size="sm" onClick={() => router.push('/books')}>
          <BookOpen className="w-4 h-4" />
          책 추가
        </Button>
      </div>

      {/* 탭 */}
      <div className="flex gap-1.5 flex-wrap">
        {TABS.map(tab => (
          <button
            key={tab.value}
            onClick={() => setStatus(tab.value)}
            className={`px-4 py-1.5 rounded-full text-xs font-medium transition-colors ${
              status === tab.value
                ? 'bg-highlight text-highlight-foreground'
                : 'bg-secondary text-muted-foreground hover:text-foreground'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {isLoading ? (
        <div className="grid grid-cols-2 gap-4 tablet:grid-cols-3">
          {[1, 2, 3, 4, 5, 6].map(i => <Skeleton key={i} className="h-48 rounded-xl" />)}
        </div>
      ) : books.length === 0 ? (
        <div className="flex flex-col items-center py-24 gap-3">
          <BookOpen className="w-12 h-12 text-muted-foreground/30" />
          <p className="text-sm text-muted-foreground">책이 없어요</p>
          <Button variant="highlight" onClick={() => router.push('/books')}>책 찾아보기</Button>
        </div>
      ) : (
        <div className="grid grid-cols-2 gap-4 tablet:grid-cols-3">
          {books.map(ub => (
            <Card
              key={ub.id}
              className="cursor-pointer hover:shadow-md transition-shadow overflow-hidden group"
              onClick={() => router.push(`/book/${ub.id}`)}
            >
              {/* 표지 */}
              <div
                className="relative w-full aspect-[2/3]"
                style={{ background: ub.book.coverImageUrl ? undefined : spineColor(ub.id) }}
              >
                {ub.book.coverImageUrl ? (
                  <img
                    src={ub.book.coverImageUrl}
                    alt={ub.book.title}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                ) : (
                  <div className="w-full h-full flex items-end p-3">
                    <span className="text-white/60 text-xs font-medium leading-tight line-clamp-3">{ub.book.title}</span>
                  </div>
                )}
                {/* 상태 배지 */}
                <div className="absolute top-2 left-2">
                  <span className={`text-[9px] px-1.5 py-0.5 rounded font-semibold ${
                    ub.status === 'COMPLETED' ? 'bg-green-500 text-white' :
                    ub.status === 'READING' ? 'bg-highlight text-highlight-foreground' :
                    'bg-black/50 text-white'
                  }`}>
                    {ub.status === 'COMPLETED' ? '완독' : ub.status === 'READING' ? '읽는 중' : '추가됨'}
                  </span>
                </div>
                {/* 읽기 버튼 오버레이 */}
                <button
                  onClick={e => { e.stopPropagation(); router.push(`/flow/${ub.id}`) }}
                  className="absolute inset-0 bg-black/0 group-hover:bg-black/30 transition-colors flex items-center justify-center"
                >
                  <Play className="w-8 h-8 text-white opacity-0 group-hover:opacity-100 transition-opacity" />
                </button>
              </div>
              <CardContent className="p-3">
                <p className="text-xs font-semibold truncate text-foreground">{ub.book.title}</p>
                <p className="text-[10px] text-muted-foreground truncate mt-0.5">{ub.book.author}</p>
                {ub.book.totalPages && (
                  <div className="mt-2 space-y-1">
                    <Progress value={ub.progressPercent} className="h-1" />
                    <p className="text-[9px] text-muted-foreground text-right">{ub.progressPercent}%</p>
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </PageContainer>
  )
}
