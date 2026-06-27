import React, { useCallback, useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import type { Book } from '@/entity/dokhu/UserBook'
import { useTheme } from '@/context/ThemeContext'

const REPO = container.resolve(DokhuRepository)

const SPINE_COLORS = [
  '#1e3a5f', '#2d4a1e', '#4a1e1e', '#2d1e4a',
  '#1e4a3a', '#4a3a1e', '#1e2a4a', '#3a1e2d',
  '#3d2b1f', '#1f3d2b', '#2b1f3d', '#3d1f2b',
]

/* ── 책 상세 바텀시트 ── */
function BookDetailSheet({
  book,
  onClose,
  onAddToLibrary,
  adding,
  added,
}: {
  book: Book
  onClose: () => void
  onAddToLibrary: (bookId: number) => void
  adding: boolean
  added: boolean
}) {
  const { c } = useTheme()
  const spineColor = SPINE_COLORS[book.id % SPINE_COLORS.length]

  return (
    <div
      className="fixed inset-0 z-50 flex items-end justify-center"
      style={{ background: 'rgba(0,0,0,0.7)' }}
      onClick={onClose}
    >
      <div
        className="w-full max-w-2xl rounded-t-3xl overflow-hidden shadow-2xl"
        style={{ background: c.bg, maxHeight: '88vh', overflowY: 'auto' }}
        onClick={e => e.stopPropagation()}
      >
        {/* 핸들 */}
        <div className="flex justify-center pt-3 pb-1">
          <div className="w-10 h-1 rounded-full" style={{ background: c.border }} />
        </div>

        {/* 상단 표지 + 정보 */}
        <div className="flex gap-5 px-6 pt-4 pb-5">
          {/* 표지 */}
          <div
            className="flex-shrink-0 rounded-xl overflow-hidden shadow-xl"
            style={{ width: 100, height: 148, background: spineColor }}
          >
            {book.coverImageUrl ? (
              <img src={book.coverImageUrl} alt={book.title} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center p-2">
                <span className="text-white/50 text-[9px] text-center font-medium leading-tight">{book.title}</span>
              </div>
            )}
          </div>

          {/* 기본 정보 */}
          <div className="flex-1 min-w-0">
            {book.genre && (
              <span
                className="text-[10px] px-2 py-0.5 rounded-full border inline-block mb-2"
                style={{ color: c.textSub, borderColor: c.border }}
              >
                {book.genre}
              </span>
            )}
            <h2 className="text-lg font-bold leading-tight mb-1" style={{ color: c.text }}>{book.title}</h2>
            <p className="text-sm mb-3" style={{ color: c.textSub }}>{book.author}</p>

            <div className="grid grid-cols-2 gap-1.5 text-[10px]">
              {[
                { label: '출판사', value: book.publisher },
                { label: '발행일', value: book.publishDate },
                { label: '페이지', value: book.totalPages ? `${book.totalPages}p` : null },
                { label: 'ISBN', value: book.isbn },
              ].filter(i => i.value).map(item => (
                <div key={item.label} className="rounded-lg px-2 py-1.5" style={{ background: c.card, border: `1px solid ${c.border}` }}>
                  <p style={{ color: c.textMuted }}>{item.label}</p>
                  <p className="truncate mt-0.5 font-medium" style={{ color: c.textSub }}>{item.value}</p>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* 책 소개 */}
        {book.synopsis && (
          <div className="px-6 pb-5">
            <p className="text-[10px] font-semibold mb-2" style={{ color: c.textMuted }}>책 소개</p>
            <p className="text-xs leading-relaxed" style={{ color: c.textSub }}>{book.synopsis}</p>
          </div>
        )}

        {/* 버튼 */}
        <div className="px-6 pb-8 flex gap-2">
          <button
            onClick={() => onAddToLibrary(book.id)}
            disabled={adding || added}
            className="flex-1 py-3 rounded-xl text-sm font-semibold text-white transition-all flex items-center justify-center gap-2"
            style={{
              background: added ? '#22c55e' : '#f97316',
              opacity: adding ? 0.7 : 1,
            }}
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
          <button
            onClick={onClose}
            className="px-5 py-3 rounded-xl text-sm font-semibold transition-colors"
            style={{ background: c.card, border: `1px solid ${c.border}`, color: c.textSub }}
          >
            닫기
          </button>
        </div>
      </div>
    </div>
  )
}

/* ── 메인 뷰 ── */
export default function DokhuBookStoreView() {
  const navigate = useNavigate()
  const { c } = useTheme()

  const [books, setBooks] = useState<Book[]>([])
  const [genres, setGenres] = useState<string[]>([])
  const [keyword, setKeyword] = useState('')
  const [selectedGenre, setSelectedGenre] = useState('')
  const [loading, setLoading] = useState(true)
  const [selected, setSelected] = useState<Book | null>(null)
  const [adding, setAdding] = useState(false)
  const [addedIds, setAddedIds] = useState<Set<number>>(new Set())

  const searchRef = useRef<HTMLInputElement>(null)
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    REPO.getGenres().then(setGenres).catch(() => {})
  }, [])

  const fetchBooks = useCallback((kw: string, genre: string) => {
    setLoading(true)
    REPO.getBooks(kw || undefined, genre || undefined)
      .then(setBooks)
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    fetchBooks('', '')
  }, [])

  function handleKeywordChange(val: string) {
    setKeyword(val)
    if (debounceRef.current) clearTimeout(debounceRef.current)
    debounceRef.current = setTimeout(() => fetchBooks(val, selectedGenre), 350)
  }

  function handleGenreSelect(genre: string) {
    const next = genre === selectedGenre ? '' : genre
    setSelectedGenre(next)
    fetchBooks(keyword, next)
  }

  function handleAddToLibrary(bookId: number) {
    setAdding(true)
    REPO.addExistingBookToLibrary(bookId)
      .then(() => {
        setAddedIds(prev => new Set([...prev, bookId]))
        setAdding(false)
      })
      .catch(err => {
        if (err?.response?.status === 401) {
          navigate('/login', { state: { from: '/dokhu/books' } })
        } else {
          alert('서재 추가에 실패했습니다.')
        }
        setAdding(false)
      })
  }

  return (
    <div className="min-h-screen" style={{ background: c.bg }}>
      {/* 상세 바텀시트 */}
      {selected && (
        <BookDetailSheet
          book={selected}
          onClose={() => setSelected(null)}
          onAddToLibrary={handleAddToLibrary}
          adding={adding}
          added={addedIds.has(selected.id)}
        />
      )}

      {/* 헤더 */}
      <div className="px-5 pt-6 pb-3" style={{ borderBottom: `1px solid ${c.borderSub}` }}>
        <div className="flex items-center justify-between mb-4">
          <div>
            <h1 className="text-xl font-bold" style={{ color: c.text }}>책 탐색</h1>
            <p className="text-xs mt-0.5" style={{ color: c.textMuted }}>총 {books.length}권</p>
          </div>
          <button
            onClick={() => navigate('/dokhu/library')}
            className="text-xs px-3 py-1.5 rounded-lg transition-colors"
            style={{ background: c.card, border: `1px solid ${c.border}`, color: c.textSub }}
          >
            내 서재
          </button>
        </div>

        {/* 검색창 */}
        <div className="flex gap-2 mb-3">
          <div className="relative flex-1">
            <svg
              className="absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none"
              width="14" height="14" viewBox="0 0 24 24" fill="none"
              stroke={c.textMuted} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
            >
              <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input
              ref={searchRef}
              className="w-full rounded-xl pl-9 pr-4 py-2.5 text-sm outline-none border focus:border-orange-500 transition-colors"
              style={{ background: c.card, borderColor: c.border, color: c.text }}
              placeholder="제목, 저자로 검색..."
              value={keyword}
              onChange={e => handleKeywordChange(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter') fetchBooks(keyword, selectedGenre) }}
            />
          </div>
          <button
            onClick={() => fetchBooks(keyword, selectedGenre)}
            className="px-4 py-2.5 rounded-xl text-xs font-semibold text-white transition-colors"
            style={{ background: '#f97316' }}
          >
            검색
          </button>
        </div>

        {/* 장르 필터 */}
        <div className="flex gap-1.5 overflow-x-auto pb-0.5 scrollbar-none">
          <button
            onClick={() => handleGenreSelect('')}
            className="flex-shrink-0 px-3 py-1 rounded-full text-xs font-medium transition-all"
            style={{
              background: selectedGenre === '' ? '#f97316' : c.card,
              color: selectedGenre === '' ? '#fff' : c.textMuted,
              border: `1px solid ${selectedGenre === '' ? '#f97316' : c.border}`,
            }}
          >
            전체
          </button>
          {genres.map(g => (
            <button
              key={g}
              onClick={() => handleGenreSelect(g)}
              className="flex-shrink-0 px-3 py-1 rounded-full text-xs font-medium transition-all"
              style={{
                background: selectedGenre === g ? '#f97316' : c.card,
                color: selectedGenre === g ? '#fff' : c.textMuted,
                border: `1px solid ${selectedGenre === g ? '#f97316' : c.border}`,
              }}
            >
              {g}
            </button>
          ))}
        </div>
      </div>

      {/* 책 그리드 */}
      <div className="p-5">
        {loading ? (
          <div className="flex justify-center py-32">
            <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : books.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-32 text-center gap-2">
            <span style={{ fontSize: 40 }}>🔍</span>
            <p className="text-sm font-medium" style={{ color: c.textSub }}>검색 결과가 없어요</p>
            <p className="text-xs" style={{ color: c.textMuted }}>다른 검색어나 장르를 시도해보세요</p>
          </div>
        ) : (
          <div className="grid gap-4" style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(110px, 1fr))' }}>
            {books.map(book => {
              const spineColor = SPINE_COLORS[book.id % SPINE_COLORS.length]
              const isAdded = addedIds.has(book.id)
              return (
                <div
                  key={book.id}
                  className="cursor-pointer group"
                  onClick={() => setSelected(book)}
                >
                  {/* 표지 */}
                  <div
                    className="relative rounded-xl overflow-hidden mb-2 shadow-md group-hover:shadow-xl transition-shadow"
                    style={{ aspectRatio: '2/3', background: spineColor }}
                  >
                    {book.coverImageUrl ? (
                      <img
                        src={book.coverImageUrl}
                        alt={book.title}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                      />
                    ) : (
                      <div className="w-full h-full flex items-end p-2">
                        <span className="text-white/60 text-[9px] font-medium leading-tight line-clamp-3">{book.title}</span>
                      </div>
                    )}
                    {/* 장르 배지 */}
                    {book.genre && (
                      <div
                        className="absolute top-1.5 left-1.5 px-1.5 py-0.5 rounded text-[8px] font-semibold"
                        style={{ background: 'rgba(0,0,0,0.6)', color: 'rgba(255,255,255,0.85)' }}
                      >
                        {book.genre}
                      </div>
                    )}
                    {/* 추가됨 뱃지 */}
                    {isAdded && (
                      <div className="absolute top-1.5 right-1.5 w-5 h-5 rounded-full bg-green-500 flex items-center justify-center shadow">
                        <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round">
                          <polyline points="20 6 9 17 4 12"/>
                        </svg>
                      </div>
                    )}
                  </div>

                  <p className="text-[11px] font-semibold leading-tight truncate" style={{ color: c.text }}>{book.title}</p>
                  <p className="text-[10px] truncate mt-0.5" style={{ color: c.textMuted }}>{book.author}</p>
                  {book.totalPages && (
                    <p className="text-[9px] mt-0.5" style={{ color: c.textMuted }}>{book.totalPages}p</p>
                  )}
                </div>
              )
            })}
          </div>
        )}
      </div>
    </div>
  )
}
