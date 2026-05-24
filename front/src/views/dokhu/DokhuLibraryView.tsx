import React, { useEffect, useRef, useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import type { UserBook, ReadingStatus } from '@/entity/dokhu/UserBook'
import { useTheme } from '@/context/ThemeContext'

const REPO = container.resolve(DokhuRepository)

type Filter = 'ALL' | ReadingStatus
type ViewMode = 'SPINE' | 'FLAT'

const FILTERS: { key: Filter; label: string }[] = [
  { key: 'ALL', label: '전체' },
  { key: 'READING', label: '읽는 중' },
  { key: 'ADDING', label: '읽을 예정' },
  { key: 'COMPLETED', label: '완독' },
]

const SPINE_COLORS = [
  '#1e3a5f', '#2d4a1e', '#4a1e1e', '#2d1e4a',
  '#1e4a3a', '#4a3a1e', '#1e2a4a', '#3a1e2d',
  '#3d2b1f', '#1f3d2b', '#2b1f3d', '#3d1f2b',
]

const SHELF_KEY = 'dokhu-shelves'
const BOOKS_PER_ROW = 15

/* ── 카테고리 타입 ── */
interface ShelfCategory {
  id: string
  name: string
  bookIds: number[]
}

function loadCategories(): ShelfCategory[] {
  try {
    const s = localStorage.getItem(SHELF_KEY)
    if (s) return JSON.parse(s)
  } catch {}
  return [{ id: 'default', name: '서재', bookIds: [] }]
}

function saveCategories(cats: ShelfCategory[]) {
  localStorage.setItem(SHELF_KEY, JSON.stringify(cats))
}

/* ── 책 추가 모달 ── */
function AddBookModal({ onClose, onAdd }: { onClose: () => void; onAdd: (d: any) => void }) {
  const [form, setForm] = useState({
    title: '', author: '', isbn: '', coverImageUrl: '',
    publisher: '', genre: '', totalPages: '', publishDate: '', synopsis: '',
  })
  function submit(e: React.FormEvent) {
    e.preventDefault()
    if (!form.title || !form.author) return
    onAdd({ ...form, totalPages: form.totalPages ? Number(form.totalPages) : undefined })
  }
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: 'rgba(0,0,0,0.85)' }}>
      <div className="w-full max-w-md rounded-2xl overflow-hidden shadow-2xl" style={{ background: '#1a1a1a', border: '1px solid #2a2a2a' }}>
        <div className="px-5 py-4 flex items-center justify-between" style={{ borderBottom: '1px solid #2a2a2a' }}>
          <h3 className="text-white font-bold text-sm">책 직접 추가</h3>
          <button onClick={onClose} className="text-slate-500 hover:text-slate-300 text-lg leading-none">✕</button>
        </div>
        <form onSubmit={submit} className="p-5 flex flex-col gap-3 max-h-[70vh] overflow-y-auto">
          {[
            { k: 'title', label: '제목 *', ph: '책 제목' },
            { k: 'author', label: '저자 *', ph: '저자명' },
            { k: 'coverImageUrl', label: '표지 이미지 URL', ph: 'https://...' },
            { k: 'isbn', label: 'ISBN', ph: '978-...' },
            { k: 'publisher', label: '출판사', ph: '' },
            { k: 'genre', label: '장르', ph: '소설, 자기계발...' },
            { k: 'totalPages', label: '총 페이지', ph: '000' },
            { k: 'publishDate', label: '출간일', ph: '2024-01-01' },
          ].map(f => (
            <div key={f.k}>
              <label className="text-[10px] text-slate-500 mb-1 block">{f.label}</label>
              <input
                className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border focus:border-orange-500 transition-colors"
                style={{ background: '#111', borderColor: '#2a2a2a' }}
                placeholder={f.ph}
                value={(form as any)[f.k]}
                onChange={e => setForm(p => ({ ...p, [f.k]: e.target.value }))}
              />
            </div>
          ))}
          <div>
            <label className="text-[10px] text-slate-500 mb-1 block">책 소개</label>
            <textarea
              className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border resize-none h-20 focus:border-orange-500 transition-colors"
              style={{ background: '#111', borderColor: '#2a2a2a' }}
              value={form.synopsis}
              onChange={e => setForm(p => ({ ...p, synopsis: e.target.value }))}
            />
          </div>
          <button type="submit" className="w-full py-2.5 rounded-xl text-white text-sm font-semibold bg-orange-500 hover:bg-orange-600 transition-colors mt-1">
            추가하기
          </button>
        </form>
      </div>
    </div>
  )
}

/* ── 평대(Flat) 뷰 ── */
function FlatView({ books, onBook, onAdd, c }: { books: UserBook[]; onBook: (id: number) => void; onAdd: () => void; c: any }) {
  return (
    <div className="px-5 pb-8 grid gap-3" style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(118px, 1fr))' }}>
      {books.map(ub => (
        <div key={ub.id} onClick={() => onBook(ub.id)} className="cursor-pointer group">
          <div className="relative rounded-xl overflow-hidden mb-1.5" style={{ aspectRatio: '2/3', background: c.card }}>
            {ub.book.coverImageUrl ? (
              <img src={ub.book.coverImageUrl} alt={ub.book.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
            ) : (
              <div className="w-full h-full flex items-end p-2" style={{ background: SPINE_COLORS[ub.id % SPINE_COLORS.length] }}>
                <span className="text-white/70 text-[9px] font-medium leading-tight line-clamp-3">{ub.book.title}</span>
              </div>
            )}
            <div className="absolute bottom-0 left-0 right-0 h-0.5" style={{ background: 'rgba(0,0,0,0.2)' }}>
              <div className="h-full bg-orange-500" style={{ width: `${ub.progressPercent}%` }} />
            </div>
            {ub.status === 'COMPLETED' && (
              <div className="absolute top-1.5 right-1.5 w-5 h-5 rounded-full bg-orange-500 flex items-center justify-center shadow">
                <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              </div>
            )}
            {ub.status === 'READING' && ub.progressPercent > 0 && (
              <div className="absolute bottom-2 left-2 text-[8px] text-orange-400 font-bold bg-black/60 px-1.5 py-0.5 rounded">
                {ub.progressPercent}%
              </div>
            )}
          </div>
          <p className="text-[10px] font-medium truncate leading-tight" style={{ color: c.text }}>{ub.book.title}</p>
          <p className="text-[9px] truncate mt-0.5" style={{ color: c.textMuted }}>{ub.book.author}</p>
        </div>
      ))}
      <div onClick={onAdd} className="cursor-pointer group">
        <div className="rounded-xl flex flex-col items-center justify-center mb-1.5 transition-colors group-hover:border-orange-500/50"
          style={{ aspectRatio: '2/3', background: c.card, border: `2px dashed ${c.border}` }}>
          <span className="text-2xl font-thin transition-colors group-hover:text-orange-400" style={{ color: c.textMuted }}>+</span>
          <span className="text-[9px] mt-1 group-hover:text-orange-400" style={{ color: c.textMuted }}>책 추가</span>
        </div>
      </div>
    </div>
  )
}

/* ── 드롭 인디케이터 ── */
function DropLine() {
  return (
    <div
      className="flex-shrink-0 self-stretch rounded-full"
      style={{ width: 3, background: '#f97316', boxShadow: '0 0 6px rgba(249,115,22,0.8)', margin: '0 1px' }}
    />
  )
}

/* ── 책등(Spine) 뷰 ── */
interface DragState {
  bookId: number
  fromCatId: string
}

interface DropState {
  catId: string
  insertBeforeBookId: number | null  // null = insert at end
}

function SpineView({
  library,
  categories,
  filter,
  search,
  onBook,
  onCategoriesChange,
}: {
  library: UserBook[]
  categories: ShelfCategory[]
  filter: Filter
  search: string
  onBook: (id: number) => void
  onCategoriesChange: (cats: ShelfCategory[]) => void
}) {
  const [dragging, setDragging] = useState<DragState | null>(null)
  const [dropState, setDropState] = useState<DropState | null>(null)
  const [tooltip, setTooltip] = useState<number | null>(null)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [editName, setEditName] = useState('')
  const [menuId, setMenuId] = useState<string | null>(null)
  const editInputRef = useRef<HTMLInputElement>(null)

  const bookMap = new Map(library.map(b => [b.id, b]))

  useEffect(() => {
    if (editingId) editInputRef.current?.focus()
  }, [editingId])

  /* 카테고리 내 보이는 책 목록 */
  function getVisibleBooks(cat: ShelfCategory): UserBook[] {
    return cat.bookIds
      .map(id => bookMap.get(id))
      .filter((b): b is UserBook => {
        if (!b) return false
        if (filter !== 'ALL' && b.status !== filter) return false
        if (search && !b.book.title.toLowerCase().includes(search.toLowerCase()) &&
          !b.book.author.toLowerCase().includes(search.toLowerCase())) return false
        return true
      })
  }

  /* 카테고리 관리 */
  function addCategory() {
    const newCat: ShelfCategory = { id: `cat_${Date.now()}`, name: '새 책장', bookIds: [] }
    const updated = [...categories, newCat]
    onCategoriesChange(updated)
    setEditingId(newCat.id)
    setEditName('새 책장')
    setMenuId(null)
  }

  function confirmRename(id: string) {
    const name = editName.trim() || '책장'
    onCategoriesChange(categories.map(c => c.id === id ? { ...c, name } : c))
    setEditingId(null)
  }

  function deleteCategory(id: string) {
    if (categories.length <= 1) return
    const toDelete = categories.find(c => c.id === id)!
    const remaining = categories.filter(c => c.id !== id)
    if (toDelete.bookIds.length > 0) {
      remaining[0] = { ...remaining[0], bookIds: [...remaining[0].bookIds, ...toDelete.bookIds] }
    }
    onCategoriesChange(remaining)
    setMenuId(null)
  }

  /* 드래그 & 드롭 핸들러 */
  function handleDragStart(e: React.DragEvent, bookId: number, fromCatId: string) {
    e.dataTransfer.effectAllowed = 'move'
    setDragging({ bookId, fromCatId })
    setTooltip(null)
  }

  function handleDragOver(e: React.DragEvent, catId: string, bookId: number, el: HTMLElement) {
    e.preventDefault()
    e.stopPropagation()
    const rect = el.getBoundingClientRect()
    const isLeftHalf = e.clientX < rect.left + rect.width / 2
    if (isLeftHalf) {
      setDropState({ catId, insertBeforeBookId: bookId })
    } else {
      // find next visible book after this one
      const cat = categories.find(c => c.id === catId)
      if (!cat) return
      const visible = getVisibleBooks(cat)
      const idx = visible.findIndex(b => b.id === bookId)
      const next = visible[idx + 1]
      setDropState({ catId, insertBeforeBookId: next?.id ?? null })
    }
  }

  function handleShelfDragOver(e: React.DragEvent, catId: string) {
    e.preventDefault()
    if (!dropState || dropState.catId !== catId) {
      setDropState({ catId, insertBeforeBookId: null })
    }
  }

  function handleDrop(e: React.DragEvent, catId: string) {
    e.preventDefault()
    e.stopPropagation()
    if (!dragging || !dropState) { setDragging(null); setDropState(null); return }

    const updated = categories.map(c => ({ ...c, bookIds: [...c.bookIds] }))
    const srcCat = updated.find(c => c.id === dragging.fromCatId)!
    const tgtCat = updated.find(c => c.id === dropState.catId)!

    // 소스에서 제거
    srcCat.bookIds = srcCat.bookIds.filter(id => id !== dragging.bookId)

    // 타겟에 삽입
    if (dropState.insertBeforeBookId === null) {
      tgtCat.bookIds.push(dragging.bookId)
    } else {
      const insertIdx = tgtCat.bookIds.indexOf(dropState.insertBeforeBookId)
      tgtCat.bookIds.splice(insertIdx === -1 ? tgtCat.bookIds.length : insertIdx, 0, dragging.bookId)
    }

    onCategoriesChange(updated)
    setDragging(null)
    setDropState(null)
  }

  function handleDragEnd() {
    setDragging(null)
    setDropState(null)
  }

  return (
    <div className="px-4 pb-8 flex flex-col gap-6" onClick={() => setMenuId(null)}>
      {categories.map(cat => {
        const visibleBooks = getVisibleBooks(cat)
        // 보이는 책 행으로 분할
        const rows: UserBook[][] = []
        for (let i = 0; i < (visibleBooks.length > 0 ? visibleBooks.length : 1); i += BOOKS_PER_ROW) {
          rows.push(visibleBooks.slice(i, i + BOOKS_PER_ROW))
        }
        const isEmpty = visibleBooks.length === 0

        return (
          <div key={cat.id}>
            {/* 카테고리 헤더 */}
            <div className="flex items-center gap-2 mb-2 px-1">
              {editingId === cat.id ? (
                <input
                  ref={editInputRef}
                  className="rounded-lg px-2 py-0.5 text-sm font-bold outline-none border focus:border-orange-500"
                  style={{ background: '#1a1a1a', borderColor: '#2a2a2a', color: '#fff', minWidth: 80 }}
                  value={editName}
                  onChange={e => setEditName(e.target.value)}
                  onBlur={() => confirmRename(cat.id)}
                  onKeyDown={e => { if (e.key === 'Enter') confirmRename(cat.id); if (e.key === 'Escape') setEditingId(null) }}
                />
              ) : (
                <button
                  className="text-sm font-bold text-white hover:text-orange-400 transition-colors"
                  onClick={() => { setEditingId(cat.id); setEditName(cat.name) }}
                  title="클릭하여 이름 변경"
                >
                  {cat.name}
                </button>
              )}
              <span className="text-[10px]" style={{ color: '#555' }}>{cat.bookIds.length}권</span>

              <div className="ml-auto relative">
                <button
                  className="w-6 h-6 flex items-center justify-center rounded-lg hover:bg-white/10 transition-colors text-slate-600 hover:text-slate-300"
                  onClick={e => { e.stopPropagation(); setMenuId(menuId === cat.id ? null : cat.id) }}
                >
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
                    <circle cx="5" cy="12" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="19" cy="12" r="2"/>
                  </svg>
                </button>
                {menuId === cat.id && (
                  <div
                    className="absolute right-0 top-full mt-1 z-40 rounded-xl overflow-hidden shadow-2xl"
                    style={{ background: '#1a1a1a', border: '1px solid #2a2a2a', minWidth: 130 }}
                    onClick={e => e.stopPropagation()}
                  >
                    <button
                      className="w-full text-left px-4 py-2.5 text-xs text-white hover:bg-white/10 transition-colors flex items-center gap-2"
                      onClick={() => { setEditingId(cat.id); setEditName(cat.name); setMenuId(null) }}
                    >
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                      이름 변경
                    </button>
                    <button
                      className="w-full text-left px-4 py-2.5 text-xs text-red-400 hover:bg-white/10 transition-colors flex items-center gap-2 disabled:opacity-40"
                      onClick={() => deleteCategory(cat.id)}
                      disabled={categories.length <= 1}
                    >
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                      책장 삭제
                    </button>
                  </div>
                )}
              </div>
            </div>

            {/* 선반 행들 */}
            {isEmpty ? (
              /* 빈 책장 드롭존 */
              <div
                onDragOver={e => handleShelfDragOver(e, cat.id)}
                onDrop={e => handleDrop(e, cat.id)}
              >
                <div
                  className="flex items-center justify-center rounded-t-md"
                  style={{
                    background: '#070707',
                    minHeight: 90,
                    border: dropState?.catId === cat.id ? '1px dashed #f97316' : '1px dashed #1e1e1e',
                    transition: 'border-color 0.15s',
                  }}
                >
                  <span className="text-[11px]" style={{ color: dropState?.catId === cat.id ? '#f97316' : '#333' }}>
                    {dragging ? '여기에 드롭' : '책을 드래그해서 이동하세요'}
                  </span>
                </div>
                <div style={{ height: 12, background: 'linear-gradient(to bottom, #7a5230 0%, #5a3a1a 40%, #3d2510 100%)', borderRadius: '0 0 4px 4px', boxShadow: '0 6px 12px rgba(0,0,0,0.6)' }} />
              </div>
            ) : (
              rows.map((rowBooks, rowIdx) => (
                <div key={rowIdx} style={{ marginBottom: 2 }}>
                  <div
                    className="flex items-end px-3 pt-10"
                    style={{ background: '#070707', minHeight: 175, gap: 1, borderRadius: rowIdx === 0 ? '6px 6px 0 0' : '0' }}
                    onDragOver={e => handleShelfDragOver(e, cat.id)}
                    onDrop={e => handleDrop(e, cat.id)}
                  >
                    {rowBooks.map((ub) => {
                      const pages = ub.book.totalPages ?? 220
                      const h = Math.min(155, Math.max(110, 95 + pages / 7))
                      const spineColor = SPINE_COLORS[ub.id % SPINE_COLORS.length]
                      const isDragging = dragging?.bookId === ub.id
                      const showDropBefore = dropState?.catId === cat.id && dropState.insertBeforeBookId === ub.id

                      return (
                        <React.Fragment key={ub.id}>
                          {/* 드롭 인디케이터 (이 책 앞) */}
                          {showDropBefore && <DropLine />}

                          {/* 책등 */}
                          <div
                            className="relative flex-shrink-0 cursor-grab active:cursor-grabbing"
                            style={{ width: 30, opacity: isDragging ? 0.3 : 1, transition: 'opacity 0.15s' }}
                            draggable
                            onDragStart={e => handleDragStart(e, ub.id, cat.id)}
                            onDragEnd={handleDragEnd}
                            onDragOver={e => handleDragOver(e, cat.id, ub.id, e.currentTarget)}
                            onDrop={e => handleDrop(e, cat.id)}
                            onMouseEnter={() => !dragging && setTooltip(ub.id)}
                            onMouseLeave={() => setTooltip(null)}
                            onClick={e => { if (!dragging) { e.stopPropagation(); onBook(ub.id) } }}
                          >
                            {/* 호버 툴팁 */}
                            {tooltip === ub.id && !dragging && (
                              <div
                                className="absolute z-30 pointer-events-none rounded-xl shadow-2xl"
                                style={{
                                  bottom: 'calc(100% + 10px)',
                                  left: '50%',
                                  transform: 'translateX(-50%)',
                                  background: '#1a1a1a',
                                  border: '1px solid #2a2a2a',
                                  minWidth: 120,
                                  padding: '8px 10px',
                                }}
                              >
                                <p className="text-white text-[11px] font-semibold truncate max-w-[140px]">{ub.book.title}</p>
                                <p className="text-slate-500 text-[9px] truncate mt-0.5">{ub.book.author}</p>
                                <div className="flex items-center gap-1.5 mt-1.5">
                                  <div className="flex-1 h-0.5 rounded-full" style={{ background: '#2a2a2a' }}>
                                    <div className="h-full rounded-full bg-orange-500" style={{ width: `${ub.progressPercent}%` }} />
                                  </div>
                                  <span className="text-[9px] text-orange-400 font-bold flex-shrink-0">{ub.progressPercent}%</span>
                                </div>
                              </div>
                            )}

                            {/* 책등 본체 */}
                            <div
                              className="rounded-sm overflow-hidden"
                              style={{
                                height: h,
                                background: ub.book.coverImageUrl ? undefined : spineColor,
                                transform: tooltip === ub.id && !dragging ? 'translateY(-18px)' : 'translateY(0)',
                                transition: 'transform 0.15s ease, box-shadow 0.15s ease',
                                boxShadow: tooltip === ub.id && !dragging
                                  ? '3px -4px 18px rgba(0,0,0,0.95), -1px 0 8px rgba(0,0,0,0.6)'
                                  : '1px 0 4px rgba(0,0,0,0.6)',
                              }}
                            >
                              {ub.book.coverImageUrl ? (
                                <img src={ub.book.coverImageUrl} alt={ub.book.title} className="w-full h-full object-cover" />
                              ) : (
                                <div
                                  className="w-full h-full flex items-center justify-center overflow-hidden"
                                  style={{ writingMode: 'vertical-rl', textOrientation: 'mixed' }}
                                >
                                  <span style={{
                                    fontSize: 8,
                                    color: 'rgba(255,255,255,0.6)',
                                    fontWeight: 500,
                                    maxHeight: '85%',
                                    overflow: 'hidden',
                                    textOverflow: 'ellipsis',
                                    whiteSpace: 'nowrap',
                                    padding: '0 2px',
                                  }}>
                                    {ub.book.title}
                                  </span>
                                </div>
                              )}
                              {/* 완독 오렌지 상단 선 */}
                              {ub.status === 'COMPLETED' && (
                                <div className="absolute top-0 left-0 right-0 h-1 bg-orange-500" />
                              )}
                            </div>
                          </div>
                        </React.Fragment>
                      )
                    })}

                    {/* 드롭 인디케이터 (맨 끝) */}
                    {dropState?.catId === cat.id && dropState.insertBeforeBookId === null && <DropLine />}
                  </div>
                  {/* 나무 선반 */}
                  <div style={{
                    height: 12,
                    background: 'linear-gradient(to bottom, #7a5230 0%, #5a3a1a 40%, #3d2510 100%)',
                    borderRadius: '0 0 4px 4px',
                    boxShadow: '0 6px 12px rgba(0,0,0,0.6)',
                  }} />
                </div>
              ))
            )}
          </div>
        )
      })}

      {/* 새 책장 추가 버튼 */}
      <button
        onClick={addCategory}
        className="flex items-center gap-2 px-4 py-3 rounded-xl text-sm transition-colors self-start"
        style={{ background: '#111', border: '1px dashed #2a2a2a', color: '#555' }}
        onMouseEnter={e => { (e.currentTarget as HTMLElement).style.borderColor = '#f97316'; (e.currentTarget as HTMLElement).style.color = '#f97316' }}
        onMouseLeave={e => { (e.currentTarget as HTMLElement).style.borderColor = '#2a2a2a'; (e.currentTarget as HTMLElement).style.color = '#555' }}
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        새 책장 추가
      </button>
    </div>
  )
}

/* ── 메인 컴포넌트 ── */
export default function DokhuLibraryView() {
  const navigate = useNavigate()
  const location = useLocation()
  const { c } = useTheme()
  const [library, setLibrary] = useState<UserBook[]>([])
  const [categories, setCategories] = useState<ShelfCategory[]>(loadCategories)
  const [filter, setFilter] = useState<Filter>('ALL')
  const [view, setView] = useState<ViewMode>('SPINE')
  const [search, setSearch] = useState('')
  const [showSearch, setShowSearch] = useState(false)
  const [showAdd, setShowAdd] = useState((location.state as any)?.add ?? false)
  const [loading, setLoading] = useState(true)
  const searchRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    REPO.getLibrary().then(setLibrary).catch(() => {}).finally(() => setLoading(false))
  }, [])

  /* 라이브러리 로드 후 카테고리와 동기화 */
  useEffect(() => {
    if (loading) return
    setCategories(prev => {
      const allCatIds = new Set(prev.flatMap(c => c.bookIds))
      const libraryIds = new Set(library.map(b => b.id))

      // 삭제된 책 제거
      const cleaned = prev.map(c => ({
        ...c,
        bookIds: c.bookIds.filter(id => libraryIds.has(id)),
      }))

      // 새로 추가된 책(어느 카테고리에도 없는) → 첫 번째 책장에 추가
      const unassigned = library.map(b => b.id).filter(id => !allCatIds.has(id))
      if (unassigned.length > 0 && cleaned.length > 0) {
        cleaned[0] = { ...cleaned[0], bookIds: [...cleaned[0].bookIds, ...unassigned] }
      }

      saveCategories(cleaned)
      return cleaned
    })
  }, [library, loading])

  useEffect(() => {
    if (showSearch) searchRef.current?.focus()
  }, [showSearch])

  function handleAdd(data: any) {
    REPO.registerBook(data)
      .then(ub => {
        setLibrary(prev => [ub, ...prev])
        // 새 책을 첫 번째 카테고리에 추가
        setCategories(prev => {
          const updated = prev.map(c => ({ ...c, bookIds: [...c.bookIds] }))
          if (updated.length > 0) updated[0].bookIds.unshift(ub.id)
          saveCategories(updated)
          return updated
        })
        setShowAdd(false)
      })
      .catch(() => alert('책 추가에 실패했습니다.'))
  }

  function handleCategoriesChange(updated: ShelfCategory[]) {
    saveCategories(updated)
    setCategories(updated)
  }

  /* 평대 뷰용 filtered 목록 */
  const flatFiltered = library
    .filter(b => filter === 'ALL' || b.status === filter)
    .filter(b => !search || b.book.title.toLowerCase().includes(search.toLowerCase()) || b.book.author.toLowerCase().includes(search.toLowerCase()))

  return (
    <div className="min-h-screen" style={{ background: c.bg }}>
      {showAdd && <AddBookModal onClose={() => setShowAdd(false)} onAdd={handleAdd} />}

      {/* ── 헤더 ── */}
      <div className="px-5 pt-6 pb-3" style={{ borderBottom: `1px solid ${c.borderSub}` }}>
        <div className="flex items-start justify-between mb-3">
          <div>
            <h1 className="text-xl font-bold" style={{ color: c.text }}>서재</h1>
            <p className="text-xs mt-0.5" style={{ color: c.textMuted }}>총 {library.length}권의 도서</p>
          </div>
          <div className="flex items-center gap-1.5 pt-0.5">
            {/* 검색 */}
            <div className="flex items-center gap-1">
              {showSearch && (
                <input
                  ref={searchRef}
                  className="rounded-lg px-3 py-1.5 text-xs outline-none border w-28"
                  style={{ background: c.card, borderColor: c.border, color: c.text }}
                  placeholder="제목, 저자 검색..."
                  value={search}
                  onChange={e => setSearch(e.target.value)}
                  onBlur={() => { if (!search) setShowSearch(false) }}
                />
              )}
              <button
                onClick={() => setShowSearch(s => !s)}
                className="w-8 h-8 flex items-center justify-center rounded-lg transition-colors"
                style={{ background: showSearch ? c.border : 'transparent', color: showSearch ? c.text : c.textSub }}
              >
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
              </button>
            </div>
            {/* 뷰 전환 */}
            <div className="flex rounded-lg overflow-hidden" style={{ border: `1px solid ${c.border}` }}>
              <button
                onClick={() => setView('SPINE')}
                className="w-8 h-8 flex items-center justify-center transition-colors"
                style={{ background: view === 'SPINE' ? '#f97316' : c.card, color: view === 'SPINE' ? '#fff' : c.textMuted }}
                title="책등 보기"
              >
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                  <rect x="2" y="3" width="5" height="18" rx="1"/>
                  <rect x="9" y="6" width="5" height="15" rx="1"/>
                  <rect x="16" y="2" width="5" height="19" rx="1"/>
                </svg>
              </button>
              <button
                onClick={() => setView('FLAT')}
                className="w-8 h-8 flex items-center justify-center transition-colors"
                style={{ background: view === 'FLAT' ? '#f97316' : c.card, color: view === 'FLAT' ? '#fff' : c.textMuted }}
                title="평대 보기"
              >
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <rect x="3" y="3" width="7" height="7" rx="1"/>
                  <rect x="14" y="3" width="7" height="7" rx="1"/>
                  <rect x="14" y="14" width="7" height="7" rx="1"/>
                  <rect x="3" y="14" width="7" height="7" rx="1"/>
                </svg>
              </button>
            </div>
          </div>
        </div>

        {/* 필터 칩 */}
        <div className="flex items-center gap-1.5">
          {FILTERS.map(f => {
            const count = f.key === 'ALL' ? library.length : library.filter(b => b.status === f.key).length
            const active = filter === f.key
            return (
              <button
                key={f.key}
                onClick={() => setFilter(f.key)}
                className="px-3 py-1 rounded-full text-xs font-medium transition-all"
                style={{
                  background: active ? '#f97316' : c.card,
                  color: active ? '#fff' : c.textMuted,
                  border: `1px solid ${active ? '#f97316' : c.border}`,
                }}
              >
                {f.label} <span style={{ opacity: active ? 0.85 : 0.6 }}>{count}</span>
              </button>
            )
          })}
          <button
            onClick={() => setShowAdd(true)}
            className="ml-auto px-3 py-1 rounded-full text-xs font-semibold text-white bg-orange-500 hover:bg-orange-600 transition-colors"
          >
            + 추가
          </button>
        </div>
      </div>

      {/* ── 콘텐츠 ── */}
      <div className="pt-5">
        {loading ? (
          <div className="flex justify-center py-32">
            <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : library.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-32 text-center gap-2">
            <span style={{ fontSize: 40 }}>📚</span>
            <p className="text-sm font-medium" style={{ color: c.textSub }}>아직 책이 없어요</p>
            <p className="text-xs" style={{ color: c.textMuted }}>첫 번째 책을 추가해보세요</p>
            <button
              onClick={() => setShowAdd(true)}
              className="mt-3 px-5 py-2 rounded-xl text-sm font-semibold text-white bg-orange-500 hover:bg-orange-600 transition-colors"
            >
              + 책 추가하기
            </button>
          </div>
        ) : view === 'FLAT' ? (
          <FlatView
            books={flatFiltered}
            onBook={id => navigate(`/dokhu/book/${id}`)}
            onAdd={() => setShowAdd(true)}
            c={c}
          />
        ) : (
          <SpineView
            library={library}
            categories={categories}
            filter={filter}
            search={search}
            onBook={id => navigate(`/dokhu/book/${id}`)}
            onCategoriesChange={handleCategoriesChange}
          />
        )}
      </div>
    </div>
  )
}
