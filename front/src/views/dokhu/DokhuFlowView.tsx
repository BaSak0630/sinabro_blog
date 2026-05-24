import React, { useEffect, useRef, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import type { UserBook } from '@/entity/dokhu/UserBook'
import type { FlowSession } from '@/entity/dokhu/FlowSession'

const REPO = container.resolve(DokhuRepository)

function formatTime(seconds: number) {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  return `${String(h).padStart(3, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
}

function getYoutubeEmbedUrl(url: string): string | null {
  const match = url.match(/(?:youtu\.be\/|youtube\.com\/watch\?v=)([\w-]+)/)
  if (match) return `https://www.youtube.com/embed/${match[1]}?autoplay=1`
  return null
}

export default function DokhuFlowView() {
  const { userBookId } = useParams<{ userBookId: string }>()
  const navigate = useNavigate()

  const [userBook, setUserBook] = useState<UserBook | null>(null)
  const [session, setSession] = useState<FlowSession | null>(null)
  const [elapsed, setElapsed] = useState(0)
  const [isRunning, setIsRunning] = useState(false)
  const [videoUrl, setVideoUrl] = useState('')
  const [showPanel, setShowPanel] = useState(false)
  const [memo, setMemo] = useState('')
  const [memoList, setMemoList] = useState<string[]>([])
  const [bookmarkPage, setBookmarkPage] = useState('')
  const [showEnd, setShowEnd] = useState(false)
  const [loading, setLoading] = useState(true)

  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const embedUrl = videoUrl ? getYoutubeEmbedUrl(videoUrl) : null

  useEffect(() => {
    if (!userBookId) return
    REPO.getUserBook(Number(userBookId))
      .then(setUserBook)
      .catch(() => navigate('/dokhu'))
      .finally(() => setLoading(false))
    return () => { if (timerRef.current) clearInterval(timerRef.current) }
  }, [userBookId])

  function startSession() {
    if (!userBook) return
    REPO.startSession(userBook.id, videoUrl || undefined)
      .then(s => {
        setSession(s)
        setIsRunning(true)
        timerRef.current = setInterval(() => setElapsed(e => e + 1), 1000)
      })
      .catch(() => alert('세션 시작에 실패했습니다.'))
  }

  function pauseTimer() {
    if (timerRef.current) clearInterval(timerRef.current)
    setIsRunning(false)
  }

  function resumeTimer() {
    setIsRunning(true)
    timerRef.current = setInterval(() => setElapsed(e => e + 1), 1000)
  }

  function stopAndEnd() {
    if (timerRef.current) clearInterval(timerRef.current)
    setIsRunning(false)
    setShowEnd(true)
  }

  function endSession() {
    if (!session) return
    REPO.endSession(session.id, memo, bookmarkPage ? Number(bookmarkPage) : undefined)
      .then(() => navigate(`/dokhu/book/${userBook!.id}`))
      .catch(() => alert('세션 종료에 실패했습니다.'))
  }

  function addMemoEntry() {
    if (!memo.trim()) return
    setMemoList(prev => [...prev, memo])
    setMemo('')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center" style={{ background: '#000' }}>
        <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }
  if (!userBook) return null

  const hasVideo = session && embedUrl

  return (
    <div className="min-h-screen flex" style={{ background: '#000' }}>
      {/* 세션 종료 모달 */}
      {showEnd && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: 'rgba(0,0,0,0.92)' }}>
          <div className="w-full max-w-sm rounded-2xl overflow-hidden" style={{ background: '#111', border: '1px solid #2a2a2a' }}>
            <div className="px-5 py-4 border-b" style={{ borderColor: '#1e1e1e' }}>
              <p className="text-white font-bold text-sm">세션 종료</p>
              <p className="text-slate-500 text-xs mt-0.5">집중 시간: {formatTime(elapsed)}</p>
            </div>
            <div className="p-5 flex flex-col gap-3">
              <div>
                <label className="text-[10px] text-slate-500 mb-1 block">메모 (선택)</label>
                <textarea
                  className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border resize-none h-20 focus:border-orange-500 transition-colors"
                  style={{ background: '#0a0a0a', borderColor: '#2a2a2a' }}
                  placeholder="오늘 읽은 내용..."
                  value={memo}
                  onChange={e => setMemo(e.target.value)}
                />
              </div>
              <div>
                <label className="text-[10px] text-slate-500 mb-1 block">북마크 페이지</label>
                <input
                  type="number"
                  className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border focus:border-orange-500 transition-colors"
                  style={{ background: '#0a0a0a', borderColor: '#2a2a2a' }}
                  placeholder="멈춘 페이지"
                  value={bookmarkPage}
                  onChange={e => setBookmarkPage(e.target.value)}
                />
              </div>
              <button onClick={endSession} className="w-full py-2.5 rounded-xl text-white text-sm font-semibold bg-orange-500 hover:bg-orange-600 transition-colors">
                저장하고 종료
              </button>
              <button onClick={() => { setShowEnd(false); resumeTimer() }} className="text-sm text-slate-600 hover:text-slate-400 transition-colors text-center">
                계속 읽기
              </button>
            </div>
          </div>
        </div>
      )}

      {/* 메인 (타이머 영역) */}
      <div className={`flex flex-col transition-all ${showPanel ? 'flex-1' : 'flex-1'}`}>
        {/* 상단 바 */}
        <div className="flex items-center justify-between px-6 pt-5 pb-2">
          <button onClick={() => navigate(`/dokhu/book/${userBook.id}`)} className="text-slate-700 hover:text-slate-500 transition-colors">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
            </svg>
          </button>
          {session && (
            <button
              onClick={() => setShowPanel(p => !p)}
              className="flex items-center gap-1.5 text-xs border rounded-lg px-3 py-1.5 transition-colors"
              style={{ color: showPanel ? '#f97316' : '#555', borderColor: showPanel ? '#f97316' : '#222' }}
            >
              독서 메모 열기
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/><line x1="21" y1="3" x2="14" y2="10"/><line x1="3" y1="21" x2="10" y2="14"/></svg>
            </button>
          )}
        </div>

        {/* 비디오 (세션 + URL 있을 때) */}
        {hasVideo && (
          <div className="mx-6 rounded-xl overflow-hidden aspect-video bg-black">
            <iframe src={embedUrl!} className="w-full h-full" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowFullScreen />
          </div>
        )}

        {/* 타이머 */}
        <div className="flex-1 flex flex-col items-center justify-center gap-8">
          <p className="text-slate-800 text-xs tracking-widest font-mono uppercase truncate max-w-xs text-center">
            {userBook.book.title}
          </p>

          <div
            className="font-mono font-bold text-white tracking-tighter select-none"
            style={{ fontSize: hasVideo ? 'clamp(32px,6vw,56px)' : 'clamp(48px,10vw,88px)' }}
          >
            {formatTime(elapsed)}
          </div>

          {/* 컨트롤 */}
          {!session ? (
            <div className="flex flex-col items-center gap-6 w-full max-w-xs px-4">
              {/* 링크 입력 */}
              <div className="w-full flex items-center gap-2 rounded-xl px-4 py-2.5" style={{ background: '#111', border: '1px solid #1e1e1e' }}>
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#444" strokeWidth="2"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>
                <input
                  className="flex-1 bg-transparent text-white text-xs placeholder-slate-700 outline-none"
                  placeholder="링크를 입력하세요"
                  value={videoUrl}
                  onChange={e => setVideoUrl(e.target.value)}
                />
              </div>
              {/* 시작 버튼 */}
              <button
                onClick={startSession}
                className="w-16 h-16 rounded-full flex items-center justify-center text-white transition-transform hover:scale-105 active:scale-95 shadow-lg shadow-orange-500/20"
                style={{ background: '#1e1e1e', border: '1px solid #333' }}
              >
                <svg width="22" height="22" viewBox="0 0 24 24" fill="white"><polygon points="5,3 19,12 5,21"/></svg>
              </button>
            </div>
          ) : (
            <div className="flex items-center gap-5">
              {isRunning ? (
                <>
                  <button
                    onClick={pauseTimer}
                    className="w-12 h-12 rounded-full flex items-center justify-center transition-colors"
                    style={{ background: '#111', border: '1px solid #222' }}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#666"><rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/></svg>
                  </button>
                  <button
                    onClick={stopAndEnd}
                    className="w-16 h-16 rounded-full flex items-center justify-center text-white transition-transform hover:scale-105 active:scale-95"
                    style={{ background: '#1e1e1e', border: '1px solid #333' }}
                  >
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="#aaa"><rect x="3" y="3" width="18" height="18" rx="2"/></svg>
                  </button>
                </>
              ) : (
                <>
                  <button
                    onClick={resumeTimer}
                    className="w-16 h-16 rounded-full flex items-center justify-center transition-transform hover:scale-105 active:scale-95"
                    style={{ background: '#1e1e1e', border: '1px solid #333' }}
                  >
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="white"><polygon points="5,3 19,12 5,21"/></svg>
                  </button>
                  <button
                    onClick={stopAndEnd}
                    className="w-12 h-12 rounded-full flex items-center justify-center"
                    style={{ background: '#111', border: '1px solid #222' }}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#555"><rect x="3" y="3" width="18" height="18" rx="2"/></svg>
                  </button>
                </>
              )}
            </div>
          )}
        </div>

        {/* 하단 진행률 */}
        {userBook.book.totalPages && (
          <div className="px-6 pb-5 flex items-center gap-3">
            <div className="flex-1 h-px" style={{ background: '#111' }} />
            <span className="text-slate-800 text-[10px] font-mono">{userBook.progressPercent}% · {userBook.currentPage}p</span>
            <div className="flex-1 h-px" style={{ background: '#111' }} />
          </div>
        )}
      </div>

      {/* 우측 메모 패널 */}
      {showPanel && session && (
        <div className="flex flex-col flex-shrink-0 border-l" style={{ width: 220, borderColor: '#1e1e1e', background: '#0a0a0a' }}>
          <div className="px-4 py-3.5 border-b" style={{ borderColor: '#1e1e1e' }}>
            <p className="text-white text-xs font-semibold">{userBook.book.title}</p>
            <p className="text-slate-600 text-[10px]">{userBook.book.author}</p>
          </div>

          {/* 메모 목록 */}
          <div className="flex-1 overflow-y-auto p-3 flex flex-col gap-2">
            <p className="text-slate-600 text-[10px] font-semibold">작성된 독서 메모는</p>
            {memoList.length === 0 ? (
              <p className="text-slate-700 text-[10px]">작성된 독서 메모는 순서대로 표시됩니다.</p>
            ) : (
              memoList.map((m, i) => (
                <div key={i} className="rounded-lg p-2.5 text-[10px] text-slate-400 leading-relaxed" style={{ background: '#111', border: '1px solid #1e1e1e' }}>
                  {m}
                </div>
              ))
            )}
          </div>

          {/* 메모 입력 */}
          <div className="p-3 border-t" style={{ borderColor: '#1e1e1e' }}>
            <textarea
              className="w-full text-[11px] text-white placeholder-slate-700 bg-transparent outline-none resize-none"
              style={{ height: 72 }}
              placeholder="메모를 작성하세요..."
              value={memo}
              onChange={e => setMemo(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); addMemoEntry() } }}
            />
            <button
              onClick={addMemoEntry}
              className="w-full text-[10px] text-orange-400 border border-orange-400/30 rounded-lg py-1.5 hover:bg-orange-400/10 transition-colors"
            >
              추가
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
