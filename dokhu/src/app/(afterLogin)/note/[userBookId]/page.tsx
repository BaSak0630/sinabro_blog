'use client'
import { useEffect, useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { useQuery, useMutation } from '@tanstack/react-query'
import { getUserBook } from '@/services/library.api'
import { getNote, saveNote, getMemos, addMemo } from '@/services/note.api'
import PageContainer from '@/components/PageContainer'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { ArrowLeft, Save, Plus } from 'lucide-react'

export default function NotePage() {
  const { userBookId } = useParams<{ userBookId: string }>()
  const router = useRouter()
  const id = Number(userBookId)

  const { data: ub } = useQuery({ queryKey: ['userBook', id], queryFn: () => getUserBook(id) })
  const { data: note, isLoading: noteLoading } = useQuery({ queryKey: ['note', id], queryFn: () => getNote(id) })
  const { data: memos = [] } = useQuery({ queryKey: ['memos', id], queryFn: () => getMemos(id) })

  const [title, setTitle] = useState('')
  const [content, setContent] = useState('')
  const [memoInput, setMemoInput] = useState('')
  const [memoPage, setMemoPage] = useState('')

  useEffect(() => {
    if (note) { setTitle(note.title); setContent(note.content) }
  }, [note])

  const noteMutation = useMutation({
    mutationFn: () => saveNote(id, title, content),
    onSuccess: () => alert('저장됐습니다.'),
  })

  const memoMutation = useMutation({
    mutationFn: () => addMemo(id, memoInput, memoPage ? Number(memoPage) : undefined),
    onSuccess: () => { setMemoInput(''); setMemoPage('') },
  })

  return (
    <PageContainer className="space-y-5">
      <button
        onClick={() => router.push(`/book/${id}`)}
        className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors"
      >
        <ArrowLeft className="w-4 h-4" />
        책 상세로
      </button>

      {ub && (
        <div>
          <h1 className="text-xl font-bold text-foreground">{ub.book.title}</h1>
          <p className="text-sm text-muted-foreground">독서 노트</p>
        </div>
      )}

      {/* 노트 */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="text-base">노트</CardTitle>
            <Button size="sm" variant="highlight" onClick={() => noteMutation.mutate()} disabled={noteMutation.isPending}>
              <Save className="w-4 h-4" />
              {noteMutation.isPending ? '저장 중...' : '저장'}
            </Button>
          </div>
        </CardHeader>
        <CardContent className="space-y-3">
          {noteLoading ? <Skeleton className="h-32" /> : (
            <>
              <input
                className="w-full rounded-lg border border-border bg-background px-3 py-2 text-sm outline-none focus:border-highlight transition-colors text-foreground"
                placeholder="제목..."
                value={title}
                onChange={e => setTitle(e.target.value)}
              />
              <textarea
                className="w-full rounded-lg border border-border bg-background px-3 py-2 text-sm outline-none focus:border-highlight transition-colors text-foreground resize-none"
                style={{ minHeight: 200 }}
                placeholder="오늘 읽은 내용을 기록하세요..."
                value={content}
                onChange={e => setContent(e.target.value)}
              />
            </>
          )}
        </CardContent>
      </Card>

      {/* 메모 */}
      <Card>
        <CardHeader><CardTitle className="text-base">메모</CardTitle></CardHeader>
        <CardContent className="space-y-4">
          <div className="flex gap-2">
            <input
              type="number"
              className="w-24 rounded-lg border border-border bg-background px-3 py-2 text-sm outline-none focus:border-highlight transition-colors text-foreground"
              placeholder="페이지"
              value={memoPage}
              onChange={e => setMemoPage(e.target.value)}
            />
            <input
              className="flex-1 rounded-lg border border-border bg-background px-3 py-2 text-sm outline-none focus:border-highlight transition-colors text-foreground"
              placeholder="메모 내용..."
              value={memoInput}
              onChange={e => setMemoInput(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter' && memoInput.trim()) memoMutation.mutate() }}
            />
            <Button size="icon" variant="highlight" onClick={() => memoMutation.mutate()} disabled={!memoInput.trim() || memoMutation.isPending}>
              <Plus className="w-4 h-4" />
            </Button>
          </div>

          {memos.length === 0 ? (
            <p className="text-sm text-muted-foreground text-center py-4">메모가 없어요</p>
          ) : (
            <div className="space-y-2">
              {memos.map(m => (
                <div key={m.id} className="p-3 rounded-lg bg-muted/50 border border-border">
                  {m.pageNumber && <span className="text-[10px] text-highlight font-medium mr-2">{m.pageNumber}p</span>}
                  <span className="text-sm text-foreground">{m.content}</span>
                  <p className="text-[10px] text-muted-foreground mt-1">{new Date(m.createdAt).toLocaleDateString('ko')}</p>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </PageContainer>
  )
}
