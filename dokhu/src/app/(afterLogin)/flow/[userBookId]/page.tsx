'use client'
import { useEffect, useRef, useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { useQuery, useMutation } from '@tanstack/react-query'
import { getUserBook } from '@/services/library.api'
import { startSession, endSession } from '@/services/flow.api'
import { formatTime, spineColor } from '@/lib/utils'
import { ArrowLeft, Play, Pause, Square, Link as LinkIcon } from 'lucide-react'
import { Button } from '@/components/ui/button'
import type { FlowSession } from '@/types'

function getYoutubeEmbedUrl(url: string): string | null {
  const match = url.match(/(?:youtu\.be\/|youtube\.com\/watch\?v=)([\w-]+)/)
  return match ? `https://www.youtube.com/embed/${match[1]}?autoplay=1` : null
}

export default function FlowPage() {
  const { userBookId } = useParams<{ userBookId: string }>()
  const router = useRouter()
  const id = Number(userBookId)

  const { data: ub } = useQuery({
    queryKey: ['userBook', id],
    queryFn: () => getUserBook(id),
  })

  const [session, setSession] = useState<FlowSession | null>(null)
  const [elapsed, setElapsed] = useState(0)
  const [isRunning, setIsRunning] = useState(false)
  const [videoUrl, setVideoUrl] = useState('')
  const [showEnd, setShowEnd] = useState(false)
  const [endMemo, setEndMemo] = useState('')
  const [endPage, setEndPage] = useState('')
  const [memoList, setMemoList] = useState<string[]>([])
  const [memoInput, setMemoInput] = useState('')
  const [showPanel, setShowPanel] = useState(false)

  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const embedUrl = videoUrl ? getYoutubeEmbedUrl(videoUrl) : null

  const startMutation = useMutation({
    mutationFn: () => startSession(id, videoUrl || undefined),
    onSuccess: (s) => {
      setSession(s)
      setIsRunning(true)
      timerRef.current = setInterval(() => setElapsed(e => e + 1), 1000)
    },
  })

  const endMutation = useMutation({
    mutationFn: () => endSession(session!.id, endMemo || undefined, endPage ? Number(endPage) : undefined),
    onSuccess: () => router.push(`/book/${id}`),
  })

  function pause() {
    if (timerRef.current) clearInterval(timerRef.current)
    setIsRunning(false)
  }

  function resume() {
    setIsRunning(true)
    timerRef.current = setInterval(() => setElapsed(e => e + 1), 1000)
  }

  function stop() {
    if (timerRef.current) clearInterval(timerRef.current)
    setIsRunning(false)
    setShowEnd(true)
  }

  useEffect(() => () => { if (timerRef.current) clearInterval(timerRef.current) }, [])

  if (!ub) return null

  const hasVideo = session && embedUrl

  return (
    <div className="flex h-screen bg-black overflow-hidden">
      {/* 세션 종료 모달 */}
      {showEnd && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/90">
          <div className="w-full max-w-sm rounded-2xl overflow-hidden border border-white/10 bg-[#111]">
            <div className="px-5 py-4 border-b border-white/10">
              <p className="text-white font-bold text-sm">세션 종료</p>
              <p className="text-slate-500 text-xs mt-0.5">집중 시간: {formatTime(elapsed)}</p>
            </div>
            <div className="p-5 space-y-3">
              <div>
                <label className="block text-[10px] text-slate-500 mb-1">메모 (선택)</label>
                <textarea
                  className="w-full rounded-lg px-3 py-2 text-sm text-white bg-black/50 border border-white/10 placeholder-slate-700 outline-none focus:border-highlight resize-none h-20 transition-colors"
                  placeholder="오늘 읽은 내용..."
                  value={endMemo}
                  onChange={e => setEndMemo(e.target.value)}
                />
              </div>
              <div>
                <label className="block text-[10px] text-slate-500 mb-1">북마크 페이지</label>
                <input
                  type="number"
                  className="w-full rounded-lg px-3 py-2 text-sm text-white bg-black/50 border border-white/10 placeholder-slate-700 outline-none focus:border-highlight transition-colors"
                  placeholder="멈춘 페이지"
                  value={endPage}
                  onChange={e => setEndPage(e.target.value)}
                />
              </div>
              <Button
                className="w-full"
                variant="highlight"
                onClick={() => endMutation.mutate()}
                disabled={endMutation.isPending}
              >
                {endMutation.isPending ? '저장 중...' : '저장하고 종료'}
              </Button>
              <button
                onClick={() => { setShowEnd(false); resume() }}
                className="w-full text-sm text-slate-600 hover:text-slate-400 transition-colors text-center"
              >
                계속 읽기
              </button>
            </div>
          </div>
        </div>
      )}

      {/* 메인 */}
      <div className="flex-1 flex flex-col min-w-0">
        {/* 상단 바 */}
        <div className="flex items-center justify-between px-6 pt-5 pb-3">
          <button
            onClick={() => router.push(`/book/${id}`)}
            className="text-slate-700 hover:text-slate-400 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          {session && (
            <button
              onClick={() => setShowPanel(p => !p)}
              className={`text-xs border rounded-lg px-3 py-1.5 transition-colors ${
                showPanel ? 'text-highlight border-highlight' : 'text-slate-600 border-white/10'
              }`}
            >
              메모 패널
            </button>
          )}
        </div>

        {/* 유튜브 영상 */}
        {hasVideo && (
          <div className="mx-6 rounded-xl overflow-hidden aspect-video">
            <iframe
              src={embedUrl!}
              className="w-full h-full"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
            />
          </div>
        )}

        {/* 타이머 */}
        <div className="flex-1 flex flex-col items-center justify-center gap-8">
          <p className="text-slate-800 text-xs tracking-widest font-mono uppercase truncate max-w-xs text-center px-4">
            {ub.book.title}
          </p>

          <div
            className="font-mono font-bold text-white tracking-tighter select-none"
            style={{ fontSize: hasVideo ? 'clamp(36px,6vw,60px)' : 'clamp(52px,10vw,96px)' }}
          >
            {formatTime(elapsed)}
          </div>

          {/* 컨트롤 */}
          {!session ? (
            <div className="flex flex-col items-center gap-5 w-full max-w-xs px-4">
              <div className="w-full flex items-center gap-2 rounded-xl px-4 py-2.5 bg-white/5 border border-white/10">
                <LinkIcon className="w-3.5 h-3.5 text-slate-600 shrink-0" />
                <input
                  className="flex-1 bg-transparent text-white text-xs placeholder-slate-700 outline-none"
                  placeholder="유튜브 링크 (선택)"
                  value={videoUrl}
                  onChange={e => setVideoUrl(e.target.value)}
                />
              </div>
              <button
                onClick={() => startMutation.mutate()}
                disabled={startMutation.isPending}
                className="w-16 h-16 rounded-full flex items-center justify-center text-white bg-white/10 border border-white/20 hover:scale-105 active:scale-95 transition-transform shadow-lg"
              >
                <Play className="w-6 h-6" />
              </button>
            </div>
          ) : (
            <div className="flex items-center gap-5">
              {isRunning ? (
                <>
                  <button
                    onClick={pause}
                    className="w-12 h-12 rounded-full flex items-center justify-center bg-white/5 border border-white/10 text-slate-500 hover:text-slate-300 transition-colors"
                  >
                    <Pause className="w-5 h-5" />
                  </button>
                  <button
                    onClick={stop}
                    className="w-16 h-16 rounded-full flex items-center justify-center bg-white/10 border border-white/20 text-slate-300 hover:scale-105 active:scale-95 transition-transform"
                  >
                    <Square className="w-5 h-5" />
                  </button>
                </>
              ) : (
                <>
                  <button
                    onClick={resume}
                    className="w-16 h-16 rounded-full flex items-center justify-center bg-white/10 border border-white/20 text-white hover:scale-105 active:scale-95 transition-transform"
                  >
                    <Play className="w-6 h-6" />
                  </button>
                  <button
                    onClick={stop}
                    className="w-12 h-12 rounded-full flex items-center justify-center bg-white/5 border border-white/10 text-slate-600 hover:text-slate-400 transition-colors"
                  >
                    <Square className="w-4 h-4" />
                  </button>
                </>
              )}
            </div>
          )}
        </div>

        {/* 하단 진행률 */}
        {ub.book.totalPages && (
          <div className="px-6 pb-5 flex items-center gap-3">
            <div className="flex-1 h-px bg-white/5" />
            <span className="text-slate-800 text-[10px] font-mono">
              {ub.progressPercent}% · {ub.currentPage}p / {ub.book.totalPages}p
            </span>
            <div className="flex-1 h-px bg-white/5" />
          </div>
        )}
      </div>

      {/* 메모 사이드 패널 */}
      {showPanel && session && (
        <div className="flex flex-col shrink-0 border-l border-white/10 bg-[#0a0a0a]" style={{ width: 220 }}>
          <div className="px-4 py-3.5 border-b border-white/10">
            <p className="text-white text-xs font-semibold truncate">{ub.book.title}</p>
            <p className="text-slate-600 text-[10px]">{ub.book.author}</p>
          </div>
          <div className="flex-1 overflow-y-auto p-3 space-y-2 no-scrollbar">
            {memoList.length === 0 ? (
              <p className="text-slate-700 text-[10px]">작성된 메모가 표시됩니다.</p>
            ) : (
              memoList.map((m, i) => (
                <div key={i} className="rounded-lg p-2.5 text-[10px] text-slate-400 leading-relaxed bg-white/5 border border-white/5">
                  {m}
                </div>
              ))
            )}
          </div>
          <div className="p-3 border-t border-white/10">
            <textarea
              className="w-full text-[11px] text-white placeholder-slate-700 bg-transparent outline-none resize-none"
              style={{ height: 72 }}
              placeholder="메모..."
              value={memoInput}
              onChange={e => setMemoInput(e.target.value)}
              onKeyDown={e => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault()
                  if (memoInput.trim()) { setMemoList(p => [...p, memoInput]); setMemoInput('') }
                }
              }}
            />
            <button
              onClick={() => { if (memoInput.trim()) { setMemoList(p => [...p, memoInput]); setMemoInput('') } }}
              className="w-full text-[10px] text-highlight border border-highlight/30 rounded-lg py-1.5 hover:bg-highlight/10 transition-colors"
            >
              추가
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
