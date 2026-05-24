import React, { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import type { UserBook } from '@/entity/dokhu/UserBook'
import { useTheme } from '@/context/ThemeContext'

const REPO = container.resolve(DokhuRepository)
const SPINE_COLORS = ['#1e3a5f','#2d4a1e','#4a1e1e','#2d1e4a','#1e4a3a','#4a3a1e','#1e2a4a','#3a1e2d']

export default function DokhuBookDetailView() {
  const { userBookId } = useParams<{ userBookId: string }>()
  const navigate = useNavigate()
  const { c } = useTheme()
  const [userBook, setUserBook] = useState<UserBook | null>(null)
  const [loading, setLoading] = useState(true)
  const [progressInput, setProgressInput] = useState('')
  const [ratingInput, setRatingInput] = useState(0)
  const [hoveredStar, setHoveredStar] = useState(0)

  useEffect(() => {
    if (!userBookId) return
    REPO.getUserBook(Number(userBookId))
      .then(ub => { setUserBook(ub); setProgressInput(String(ub.currentPage)); setRatingInput(ub.starRating) })
      .catch(() => navigate('/dokhu/library'))
      .finally(() => setLoading(false))
  }, [userBookId])

  function handleProgressUpdate() {
    if (!userBook) return
    REPO.updateProgress(userBook.id, Number(progressInput)).then(setUserBook).catch(() => alert('업데이트 실패'))
  }

  function handleRating(star: number) {
    if (!userBook) return
    setRatingInput(star)
    REPO.updateRating(userBook.id, star).then(setUserBook).catch(() => {})
  }

  function handleDelete() {
    if (!userBook || !confirm('정말 삭제하시겠습니까?')) return
    REPO.deleteUserBook(userBook.id).then(() => navigate('/dokhu/library')).catch(() => alert('삭제 실패'))
  }

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center" style={{ background: c.bg }}>
      <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
    </div>
  )
  if (!userBook) return null

  const { book } = userBook
  const tags = [book.genre, book.publisher].filter(Boolean)

  return (
    <div className="min-h-screen" style={{ background: c.bg }}>
      {/* 상단 뒤로가기 + 메뉴 */}
      <div className="flex items-center justify-between px-6 pt-5 pb-4">
        <button
          onClick={() => navigate('/dokhu/library')}
          className="flex items-center gap-1.5 transition-colors text-sm"
          style={{ color: c.textSub }}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
          </svg>
          뒤로가기
        </button>
        <button className="transition-colors text-sm font-bold" style={{ color: c.textMuted }}>···</button>
      </div>

      {/* 메인 영역: 좌측 표지 + 우측 정보 */}
      <div className="flex gap-6 px-6 pb-6">
        {/* 좌측 표지 */}
        <div className="flex-shrink-0" style={{ width: 180 }}>
          <div
            className="w-full rounded-xl overflow-hidden shadow-2xl"
            style={{ height: 260, background: book.coverImageUrl ? undefined : SPINE_COLORS[userBook.id % SPINE_COLORS.length] }}
          >
            {book.coverImageUrl ? (
              <img src={book.coverImageUrl} alt={book.title} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center p-3">
                <span className="text-white/50 text-xs text-center font-medium leading-tight">{book.title}</span>
              </div>
            )}
          </div>
        </div>

        {/* 우측 정보 */}
        <div className="flex-1 min-w-0">
          {/* 태그 */}
          {tags.length > 0 && (
            <div className="flex gap-1.5 mb-2.5 flex-wrap">
              {tags.map(t => (
                <span key={t} className="text-[10px] px-2 py-0.5 rounded-full border" style={{ color: c.textSub, borderColor: c.border }}>{t}</span>
              ))}
            </div>
          )}

          {/* 제목, 저자 */}
          <h1 className="text-xl font-bold leading-tight mb-1" style={{ color: c.text }}>{book.title}</h1>
          <p className="text-sm mb-3" style={{ color: c.textSub }}>{book.author}</p>

          {/* 별점 */}
          <div className="flex items-center gap-1 mb-4">
            {Array.from({ length: 5 }).map((_, i) => (
              <button
                key={i}
                onMouseEnter={() => setHoveredStar(i + 1)}
                onMouseLeave={() => setHoveredStar(0)}
                onClick={() => handleRating(i + 1)}
                className="transition-transform hover:scale-110"
              >
                <span className="text-lg" style={{ color: i < (hoveredStar || ratingInput) ? '#f97316' : c.border }}>★</span>
              </button>
            ))}
          </div>

          {/* 정보 그리드 */}
          <div className="grid grid-cols-3 gap-2 mb-4">
            {[
              { label: 'ISBN', value: book.isbn || '—' },
              { label: '출판사', value: book.publisher || '—' },
              { label: '발행일', value: book.publishDate || '—' },
            ].map(item => (
              <div key={item.label} className="rounded-lg px-3 py-2.5" style={{ background: c.card, border: `1px solid ${c.border}` }}>
                <p className="text-[10px] mb-0.5" style={{ color: c.textMuted }}>{item.label}</p>
                <p className="text-xs truncate" style={{ color: c.textSub }}>{item.value}</p>
              </div>
            ))}
          </div>

          {/* 책 소개 */}
          {book.synopsis && (
            <div className="mb-4">
              <p className="text-[10px] font-semibold mb-1.5" style={{ color: c.textMuted }}>책 소개</p>
              <p className="text-xs leading-relaxed line-clamp-4" style={{ color: c.textSub }}>{book.synopsis}</p>
            </div>
          )}

          {/* CTA 버튼 */}
          <button
            onClick={() => navigate(`/dokhu/flow/${userBook.id}`)}
            className="w-full py-3 rounded-xl text-white text-sm font-semibold flex items-center justify-center gap-2 hover:opacity-90 transition-opacity mb-2"
            style={{ background: '#f97316' }}
          >
            <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor"><polygon points="5,3 19,12 5,21"/></svg>
            {userBook.status === 'ADDING' ? '읽기 시작' : '이어 읽기'}
          </button>

          <button
            onClick={() => navigate(`/dokhu/note/${userBook.id}`)}
            className="w-full py-2.5 rounded-xl text-sm font-semibold transition-colors mb-2"
            style={{ background: 'transparent', border: '1px solid #f97316', color: '#f97316' }}
          >
            ✏ 독서 노트
          </button>
        </div>
      </div>

      {/* 진행률 섹션 */}
      {book.totalPages && (
        <div className="mx-6 rounded-xl p-5 mb-4" style={{ background: c.card, border: `1px solid ${c.border}` }}>
          <div className="flex items-center justify-between mb-3">
            <span className="text-xs font-semibold" style={{ color: c.text }}>독서 진행</span>
            <span className="text-orange-400 text-xs font-bold">{userBook.progressPercent}%</span>
          </div>
          <div className="h-1 rounded-full mb-4 overflow-hidden" style={{ background: c.border }}>
            <div className="h-full bg-orange-500 rounded-full transition-all" style={{ width: `${userBook.progressPercent}%` }} />
          </div>
          <div className="flex items-center gap-2">
            <input
              type="number" min={0} max={book.totalPages}
              className="rounded-lg px-3 py-2 text-sm outline-none border focus:border-orange-500 transition-colors"
              style={{ background: c.input, borderColor: c.border, color: c.text, width: 110 }}
              placeholder="현재 페이지"
              value={progressInput}
              onChange={e => setProgressInput(e.target.value)}
            />
            <span className="text-xs" style={{ color: c.textMuted }}>/ {book.totalPages}p</span>
            <button onClick={handleProgressUpdate} className="ml-auto px-4 py-2 rounded-xl text-xs font-semibold text-white transition-colors" style={{ background: c.border }}>
              업데이트
            </button>
          </div>
        </div>
      )}

      {/* 책장에서 삭제 */}
      <div className="flex justify-end px-6 pb-8">
        <button onClick={handleDelete} className="text-xs hover:text-red-400 transition-colors" style={{ color: c.textMuted }}>
          책장에서 삭제
        </button>
      </div>
    </div>
  )
}
