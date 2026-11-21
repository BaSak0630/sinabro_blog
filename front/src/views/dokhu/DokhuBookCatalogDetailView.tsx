import React, { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import type { Book } from '@/entity/dokhu/UserBook'
import { useTheme } from '@/context/ThemeContext'

const REPO = container.resolve(DokhuRepository)
const SPINE_COLORS = ['#1e3a5f','#2d4a1e','#4a1e1e','#2d1e4a','#1e4a3a','#4a3a1e','#1e2a4a','#3a1e2d']

export default function DokhuBookCatalogDetailView() {
  const { bookId } = useParams<{ bookId: string }>()
  const navigate = useNavigate()
  const { c } = useTheme()
  const [book, setBook] = useState<Book | null>(null)
  const [loading, setLoading] = useState(true)
  const [adding, setAdding] = useState(false)
  const [added, setAdded] = useState(false)

  useEffect(() => {
    if (!bookId) return
    REPO.getBook(Number(bookId))
      .then(setBook)
      .catch(() => navigate('/dokhu/books'))
      .finally(() => setLoading(false))
  }, [bookId])

  function handleAddToLibrary() {
    if (!book) return
    setAdding(true)
    REPO.addExistingBookToLibrary(book.id)
      .then(() => setAdded(true))
      .catch(err => {
        if (err?.response?.status === 401) {
          navigate('/login', { state: { from: `/dokhu/books/${book.id}` } })
        } else {
          alert('서재 추가에 실패했습니다.')
        }
      })
      .finally(() => setAdding(false))
  }

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center" style={{ background: c.bg }}>
      <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
    </div>
  )
  if (!book) return null

  const spineColor = SPINE_COLORS[book.id % SPINE_COLORS.length]

  return (
    <div className="min-h-screen" style={{ background: c.bg }}>
      {/* 상단 뒤로가기 */}
      <div className="px-6 pt-5 pb-4">
        <button
          onClick={() => navigate('/dokhu/books')}
          className="flex items-center gap-1.5 transition-colors text-sm"
          style={{ color: c.textSub }}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
          </svg>
          책 탐색으로
        </button>
      </div>

      {/* 메인 영역: 좌측 표지 + 우측 정보 */}
      <div className="flex gap-6 px-6 pb-6">
        <div className="flex-shrink-0" style={{ width: 180 }}>
          <div
            className="w-full rounded-xl overflow-hidden shadow-2xl"
            style={{ height: 260, background: book.coverImageUrl ? undefined : spineColor }}
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

        <div className="flex-1 min-w-0">
          {book.genre && (
            <span
              className="text-xs px-2.5 py-1 rounded-full border inline-block mb-3"
              style={{ color: c.textSub, borderColor: c.border }}
            >
              {book.genre}
            </span>
          )}
          <h1 className="text-2xl font-bold leading-tight mb-1.5" style={{ color: c.text }}>{book.title}</h1>
          <p className="text-sm mb-5" style={{ color: c.textSub }}>{book.author}</p>

          <div className="grid grid-cols-2 gap-2 mb-5" style={{ maxWidth: 420 }}>
            {[
              { label: '출판사', value: book.publisher },
              { label: '발행일', value: book.publishDate },
              { label: '페이지', value: book.totalPages ? `${book.totalPages}p` : null },
              { label: 'ISBN', value: book.isbn },
            ].filter(i => i.value).map(item => (
              <div key={item.label} className="rounded-lg px-3 py-2" style={{ background: c.card, border: `1px solid ${c.border}` }}>
                <p className="text-xs" style={{ color: c.textMuted }}>{item.label}</p>
                <p className="text-sm truncate mt-0.5 font-medium" style={{ color: c.textSub }}>{item.value}</p>
              </div>
            ))}
          </div>

          <button
            onClick={handleAddToLibrary}
            disabled={adding || added}
            className="px-6 py-2.5 rounded-xl text-sm font-semibold text-white transition-all flex items-center justify-center gap-2 w-fit"
            style={{ background: added ? '#22c55e' : '#f97316', opacity: adding ? 0.7 : 1 }}
          >
            {added ? (
              <>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                서재에 추가됨
              </>
            ) : adding ? (
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                내 서재에 추가
              </>
            )}
          </button>
        </div>
      </div>

      {/* 책 소개 */}
      {book.synopsis && (
        <div className="px-6 pb-10" style={{ maxWidth: 640 }}>
          <p className="text-xs font-semibold mb-2" style={{ color: c.textMuted }}>책 소개</p>
          <p className="text-sm leading-relaxed" style={{ color: c.textSub }}>{book.synopsis}</p>
        </div>
      )}
    </div>
  )
}