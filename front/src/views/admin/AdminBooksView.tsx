import React, { useEffect, useRef, useState } from 'react'
import { container } from 'tsyringe'
import AdminRepository from '@/repository/AdminRepository'
import type { Book } from '@/entity/dokhu/UserBook'

const REPO = container.resolve(AdminRepository)

interface BookForm {
  title: string; author: string; isbn: string; coverImageUrl: string
  publisher: string; genre: string; totalPages: string; publishDate: string; synopsis: string
}

const EMPTY_FORM: BookForm = {
  title: '', author: '', isbn: '', coverImageUrl: '',
  publisher: '', genre: '', totalPages: '', publishDate: '', synopsis: '',
}

function toPayload(f: BookForm) {
  return {
    title: f.title, author: f.author,
    isbn: f.isbn || undefined,
    coverImageUrl: f.coverImageUrl || undefined,
    publisher: f.publisher || undefined,
    genre: f.genre || undefined,
    totalPages: f.totalPages ? Number(f.totalPages) : undefined,
    publishDate: f.publishDate || undefined,
    synopsis: f.synopsis || undefined,
  }
}

/* ── 책 추가/수정 모달 ── */
function BookFormModal({
  initial, onClose, onSave,
}: {
  initial?: Book | null
  onClose: () => void
  onSave: (form: BookForm) => Promise<void>
}) {
  const [form, setForm] = useState<BookForm>(
    initial
      ? {
          title: initial.title, author: initial.author,
          isbn: initial.isbn ?? '', coverImageUrl: initial.coverImageUrl ?? '',
          publisher: initial.publisher ?? '', genre: initial.genre ?? '',
          totalPages: initial.totalPages ? String(initial.totalPages) : '',
          publishDate: initial.publishDate ?? '', synopsis: initial.synopsis ?? '',
        }
      : EMPTY_FORM
  )
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')

  function set(key: keyof BookForm, val: string) {
    setForm(prev => ({ ...prev, [key]: val }))
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!form.title.trim() || !form.author.trim()) {
      setError('제목과 저자는 필수입니다.')
      return
    }
    setSaving(true)
    try {
      await onSave(form)
      onClose()
    } catch {
      setError('저장에 실패했습니다.')
    } finally {
      setSaving(false)
    }
  }

  const fields: { key: keyof BookForm; label: string; placeholder?: string; textarea?: boolean; type?: string }[] = [
    { key: 'title', label: '제목 *', placeholder: '책 제목' },
    { key: 'author', label: '저자 *', placeholder: '저자명' },
    { key: 'publisher', label: '출판사', placeholder: '출판사' },
    { key: 'genre', label: '장르', placeholder: 'e.g. 소설, 기술, 경제' },
    { key: 'isbn', label: 'ISBN', placeholder: '9780000000000' },
    { key: 'totalPages', label: '총 페이지', placeholder: '300', type: 'number' },
    { key: 'publishDate', label: '발행일', placeholder: 'e.g. 2024-01-01' },
    { key: 'coverImageUrl', label: '표지 이미지 URL', placeholder: 'https://...' },
    { key: 'synopsis', label: '책 소개', textarea: true },
  ]

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50" onClick={onClose}>
      <div
        className="w-full max-w-lg bg-white rounded-2xl shadow-2xl overflow-hidden max-h-[90vh] flex flex-col"
        onClick={e => e.stopPropagation()}
      >
        <div className="px-6 py-4 border-b border-slate-100 flex items-center justify-between">
          <h2 className="text-base font-bold text-slate-800">{initial ? '책 수정' : '책 추가'}</h2>
          <button onClick={onClose} className="text-slate-400 hover:text-slate-600 text-lg leading-none">×</button>
        </div>

        <form onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-6 flex flex-col gap-3">
          {error && <p className="text-xs text-red-500 bg-red-50 px-3 py-2 rounded-lg">{error}</p>}
          {fields.map(f => (
            <div key={f.key}>
              <label className="block text-[11px] font-medium text-slate-500 mb-1">{f.label}</label>
              {f.textarea ? (
                <textarea
                  className="w-full text-sm border border-slate-200 rounded-lg px-3 py-2 outline-none focus:border-blue-400 resize-none h-24 transition-colors"
                  placeholder="책 소개..."
                  value={form[f.key]}
                  onChange={e => set(f.key, e.target.value)}
                />
              ) : (
                <input
                  type={f.type ?? 'text'}
                  className="w-full text-sm border border-slate-200 rounded-lg px-3 py-2 outline-none focus:border-blue-400 transition-colors"
                  placeholder={f.placeholder}
                  value={form[f.key]}
                  onChange={e => set(f.key, e.target.value)}
                />
              )}
            </div>
          ))}
        </form>

        <div className="px-6 py-4 border-t border-slate-100 flex justify-end gap-2">
          <button onClick={onClose} className="px-4 py-2 text-sm text-slate-500 hover:text-slate-700 transition-colors">취소</button>
          <button
            onClick={handleSubmit as any}
            disabled={saving}
            className="px-5 py-2 text-sm font-semibold text-white bg-slate-800 hover:bg-slate-700 rounded-lg disabled:opacity-50 transition-colors"
          >
            {saving ? '저장 중...' : '저장'}
          </button>
        </div>
      </div>
    </div>
  )
}

/* ── 메인 뷰 ── */
export default function AdminBooksView() {
  const [books, setBooks] = useState<Book[]>([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [keyword, setKeyword] = useState('')
  const [loading, setLoading] = useState(true)
  const [deletingId, setDeletingId] = useState<number | null>(null)
  const [modal, setModal] = useState<'add' | 'edit' | null>(null)
  const [editTarget, setEditTarget] = useState<Book | null>(null)
  const [expandedId, setExpandedId] = useState<number | null>(null)

  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const SIZE = 20
  const totalPages = Math.ceil(total / SIZE)

  function fetchBooks(p = 1, kw = keyword) {
    setLoading(true)
    REPO.getBooks(p, SIZE, kw || undefined)
      .then(res => { setBooks(res.items); setTotal(res.totalCount); setPage(p) })
      .catch(console.error)
      .finally(() => setLoading(false))
  }

  useEffect(() => { fetchBooks(1, '') }, [])

  function handleKeywordChange(val: string) {
    setKeyword(val)
    if (debounceRef.current) clearTimeout(debounceRef.current)
    debounceRef.current = setTimeout(() => fetchBooks(1, val), 350)
  }

  async function handleDelete(id: number) {
    if (!confirm('정말 삭제하시겠습니까?')) return
    setDeletingId(id)
    try {
      await REPO.deleteBook(id)
      fetchBooks(page)
    } catch { alert('삭제 실패') }
    finally { setDeletingId(null) }
  }

  async function handleSave(form: BookForm) {
    if (modal === 'edit' && editTarget) {
      await REPO.updateBook(editTarget.id, toPayload(form))
    } else {
      await REPO.createBook(toPayload(form))
    }
    fetchBooks(1, keyword)
  }

  return (
    <div className="space-y-6">
      {(modal === 'add' || modal === 'edit') && (
        <BookFormModal
          initial={modal === 'edit' ? editTarget : null}
          onClose={() => { setModal(null); setEditTarget(null) }}
          onSave={handleSave}
        />
      )}

      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-800">책 관리</h1>
          <p className="text-sm text-slate-400 mt-0.5">총 {total}권</p>
        </div>
        <button
          onClick={() => setModal('add')}
          className="px-4 py-2 text-sm font-semibold text-white bg-slate-800 hover:bg-slate-700 rounded-lg transition-colors"
        >
          + 책 추가
        </button>
      </div>

      {/* 검색 */}
      <div className="flex gap-2">
        <input
          className="flex-1 text-sm border border-slate-200 rounded-lg px-3 py-2 outline-none focus:border-slate-400 transition-colors"
          placeholder="제목, 저자로 검색..."
          value={keyword}
          onChange={e => handleKeywordChange(e.target.value)}
        />
        <button
          onClick={() => fetchBooks(1, keyword)}
          className="px-4 py-2 text-sm font-medium text-white bg-slate-600 hover:bg-slate-700 rounded-lg transition-colors"
        >
          검색
        </button>
      </div>

      {/* 테이블 */}
      <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
        {loading ? (
          <div className="flex justify-center py-16">
            <div className="w-5 h-5 border-2 border-slate-300 border-t-slate-600 rounded-full animate-spin" />
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-slate-100 bg-slate-50 text-[11px] text-slate-500 uppercase tracking-wide">
                <th className="px-4 py-3 text-left w-8">#</th>
                <th className="px-4 py-3 text-left">제목</th>
                <th className="px-4 py-3 text-left">저자</th>
                <th className="px-4 py-3 text-left">장르</th>
                <th className="px-4 py-3 text-left">출판사</th>
                <th className="px-4 py-3 text-left">페이지</th>
                <th className="px-4 py-3 text-left">ISBN</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {books.length === 0 ? (
                <tr><td colSpan={8} className="px-4 py-10 text-center text-slate-300 text-sm">책 없음</td></tr>
              ) : books.map(book => (
                <React.Fragment key={book.id}>
                  <tr
                    className="hover:bg-slate-50 transition-colors cursor-pointer"
                    onClick={() => setExpandedId(expandedId === book.id ? null : book.id)}
                  >
                    <td className="px-4 py-3 text-slate-400 text-xs">{book.id}</td>
                    <td className="px-4 py-3 font-medium text-slate-700 max-w-[180px] truncate">
                      <div className="flex items-center gap-2">
                        {book.coverImageUrl && (
                          <img src={book.coverImageUrl} alt="" className="w-6 h-9 object-cover rounded flex-shrink-0" />
                        )}
                        <span className="truncate">{book.title}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-slate-500 truncate max-w-[100px]">{book.author}</td>
                    <td className="px-4 py-3">
                      {book.genre && (
                        <span className="text-[10px] px-2 py-0.5 bg-slate-100 text-slate-500 rounded-full">{book.genre}</span>
                      )}
                    </td>
                    <td className="px-4 py-3 text-slate-400 text-xs truncate max-w-[100px]">{book.publisher ?? '—'}</td>
                    <td className="px-4 py-3 text-slate-400 text-xs">{book.totalPages ? `${book.totalPages}p` : '—'}</td>
                    <td className="px-4 py-3 text-slate-400 text-[10px] truncate max-w-[110px]">{book.isbn ?? '—'}</td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-2 justify-end" onClick={e => e.stopPropagation()}>
                        <button
                          onClick={() => { setEditTarget(book); setModal('edit') }}
                          className="text-xs text-blue-500 hover:text-blue-700 transition-colors"
                        >
                          수정
                        </button>
                        <button
                          onClick={() => handleDelete(book.id)}
                          disabled={deletingId === book.id}
                          className="text-xs text-red-500 hover:text-red-700 disabled:opacity-40 transition-colors"
                        >
                          삭제
                        </button>
                      </div>
                    </td>
                  </tr>

                  {/* 확장 행: 책 소개 */}
                  {expandedId === book.id && (
                    <tr className="bg-slate-50">
                      <td colSpan={8} className="px-6 py-4">
                        <div className="flex gap-4">
                          {book.coverImageUrl && (
                            <img src={book.coverImageUrl} alt={book.title} className="w-16 h-24 object-cover rounded-lg shadow flex-shrink-0" />
                          )}
                          <div className="flex-1 space-y-2">
                            <div className="grid grid-cols-3 gap-2 text-xs">
                              {[
                                { label: '발행일', value: book.publishDate },
                                { label: 'ISBN', value: book.isbn },
                                { label: '표지 URL', value: book.coverImageUrl },
                              ].map(i => (
                                <div key={i.label}>
                                  <p className="text-slate-400 mb-0.5">{i.label}</p>
                                  <p className="text-slate-600 truncate">{i.value ?? '—'}</p>
                                </div>
                              ))}
                            </div>
                            {book.synopsis && (
                              <div>
                                <p className="text-[10px] text-slate-400 mb-1">책 소개</p>
                                <p className="text-xs text-slate-600 leading-relaxed whitespace-pre-wrap">{book.synopsis}</p>
                              </div>
                            )}
                          </div>
                        </div>
                      </td>
                    </tr>
                  )}
                </React.Fragment>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* 페이지네이션 */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-1.5">
          <button
            className="px-3 py-1.5 text-sm border border-slate-200 rounded-lg bg-white text-slate-500 hover:bg-slate-50 disabled:opacity-30 transition-colors"
            disabled={page <= 1}
            onClick={() => fetchBooks(page - 1)}
          >‹</button>
          {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
            <button
              key={p}
              className={`px-3 py-1.5 text-sm border rounded-lg transition-colors ${
                p === page ? 'bg-slate-800 text-white border-slate-800' : 'border-slate-200 bg-white text-slate-500 hover:bg-slate-50'
              }`}
              onClick={() => fetchBooks(p)}
            >{p}</button>
          ))}
          <button
            className="px-3 py-1.5 text-sm border border-slate-200 rounded-lg bg-white text-slate-500 hover:bg-slate-50 disabled:opacity-30 transition-colors"
            disabled={page >= totalPages}
            onClick={() => fetchBooks(page + 1)}
          >›</button>
        </div>
      )}
    </div>
  )
}
