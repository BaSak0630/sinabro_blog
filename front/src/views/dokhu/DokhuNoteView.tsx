import React, { useEffect, useState, useCallback } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import type { UserBook } from '@/entity/dokhu/UserBook'
import type { BookNote, BookMemo } from '@/entity/dokhu/BookNote'
import { useTheme } from '@/context/ThemeContext'

const REPO = container.resolve(DokhuRepository)

export default function DokhuNoteView() {
  const { userBookId } = useParams<{ userBookId: string }>()
  const navigate = useNavigate()
  const { c } = useTheme()

  const [userBook, setUserBook] = useState<UserBook | null>(null)
  const [note, setNote] = useState<BookNote | null>(null)
  const [memos, setMemos] = useState<BookMemo[]>([])
  const [noteTitle, setNoteTitle] = useState('')
  const [noteContent, setNoteContent] = useState('')
  const [memoInput, setMemoInput] = useState('')
  const [memPage, setMemPage] = useState('')
  const [saving, setSaving] = useState(false)
  const [activeTab, setActiveTab] = useState<'note' | 'memos'>('note')

  useEffect(() => {
    if (!userBookId) return
    const id = Number(userBookId)
    Promise.all([
      REPO.getUserBook(id),
      REPO.getNote(id),
      REPO.getMemos(id),
    ]).then(([ub, n, m]) => {
      setUserBook(ub)
      if (n) { setNote(n); setNoteTitle(n.title); setNoteContent(n.content) }
      setMemos(m)
    }).catch(() => navigate('/dokhu'))
  }, [userBookId])

  const saveNote = useCallback(() => {
    if (!userBookId) return
    setSaving(true)
    REPO.saveNote(Number(userBookId), noteTitle, noteContent)
      .then(setNote)
      .finally(() => setSaving(false))
  }, [userBookId, noteTitle, noteContent])

  function addMemo() {
    if (!userBookId || !memoInput.trim()) return
    REPO.addMemo(Number(userBookId), memoInput, memPage ? Number(memPage) : undefined)
      .then(m => { setMemos(prev => [m, ...prev]); setMemoInput(''); setMemPage('') })
      .catch(() => alert('메모 추가에 실패했습니다.'))
  }

  if (!userBook) {
    return (
      <div className="min-h-screen flex items-center justify-center" style={{ background: c.bg }}>
        <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="min-h-screen flex flex-col" style={{ background: c.bg }}>
      {/* 헤더 */}
      <div
        className="px-6 pt-5 pb-0 flex items-center gap-3 sticky top-0 z-10"
        style={{ background: c.bg }}
      >
        <button
          onClick={() => navigate(`/dokhu/book/${userBook.id}`)}
          className="transition-colors flex-shrink-0"
          style={{ color: c.textMuted }}
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
          </svg>
        </button>
        <span className="text-sm font-medium truncate flex-1" style={{ color: c.text }}>{userBook.book.title}</span>
        {activeTab === 'note' && (
          <button
            onClick={saveNote}
            disabled={saving}
            className="text-xs font-semibold text-orange-400 hover:text-orange-300 disabled:opacity-50 transition-colors flex-shrink-0"
          >
            {saving ? '저장 중...' : '저장'}
          </button>
        )}
      </div>

      {/* 탭 */}
      <div className="px-6 pt-4 pb-0 flex gap-1">
        {[
          { key: 'note' as const, label: '노트' },
          { key: 'memos' as const, label: `메모 ${memos.length}` },
        ].map(t => (
          <button
            key={t.key}
            onClick={() => setActiveTab(t.key)}
            className="px-4 py-2 rounded-t-lg text-xs font-medium transition-colors relative"
            style={{
              color: activeTab === t.key ? c.text : c.textMuted,
              background: activeTab === t.key ? c.card : 'transparent',
            }}
          >
            {t.label}
            {activeTab === t.key && (
              <span className="absolute bottom-0 left-0 right-0 h-px bg-orange-500" />
            )}
          </button>
        ))}
      </div>

      {/* 콘텐츠 */}
      <div className="flex-1 mx-6 mt-0 mb-6 rounded-b-2xl rounded-tr-2xl overflow-hidden" style={{ background: c.card, border: `1px solid ${c.border}` }}>
        {activeTab === 'note' ? (
          <div className="flex flex-col h-full">
            <div className="px-5 pt-5">
              <input
                className="w-full text-lg font-bold bg-transparent outline-none"
                style={{ color: c.text }}
                placeholder="노트 제목..."
                value={noteTitle}
                onChange={e => setNoteTitle(e.target.value)}
              />
            </div>
            <div className="px-5 py-2 border-b" style={{ borderColor: c.border }} />
            <textarea
              className="flex-1 w-full px-5 py-4 text-sm bg-transparent outline-none resize-none leading-relaxed"
              style={{ color: c.textSub, minHeight: 'calc(100vh - 280px)' }}
              placeholder={`${userBook.book.title}을 읽으며 느낀 점을 자유롭게 작성하세요...`}
              value={noteContent}
              onChange={e => setNoteContent(e.target.value)}
            />
            {note && (
              <div className="px-5 pb-4 border-t" style={{ borderColor: c.border }}>
                <p className="text-[10px] pt-3" style={{ color: c.textMuted }}>
                  마지막 저장: {new Date(note.updatedAt).toLocaleString('ko-KR')}
                </p>
              </div>
            )}
          </div>
        ) : (
          <div className="flex flex-col gap-0">
            {/* 메모 입력 */}
            <div className="px-5 py-4 border-b" style={{ borderColor: c.border }}>
              <textarea
                className="w-full bg-transparent text-sm outline-none resize-none"
                style={{ color: c.text, height: 72 }}
                placeholder="짧은 메모, 인상 깊은 문장, 질문..."
                value={memoInput}
                onChange={e => setMemoInput(e.target.value)}
                onKeyDown={e => { if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) addMemo() }}
              />
              <div className="flex items-center gap-2 mt-2">
                <input
                  type="number"
                  className="rounded-lg px-2 py-1.5 text-xs outline-none border"
                  style={{ background: c.input, borderColor: c.border, color: c.text, width: 90 }}
                  placeholder="페이지 (선택)"
                  value={memPage}
                  onChange={e => setMemPage(e.target.value)}
                />
                <button
                  onClick={addMemo}
                  className="px-4 py-1.5 rounded-lg text-xs font-semibold text-white bg-orange-500 hover:bg-orange-600 transition-colors"
                >
                  추가
                </button>
                <span className="text-[10px] ml-auto" style={{ color: c.textMuted }}>Ctrl+Enter</span>
              </div>
            </div>

            {/* 메모 목록 */}
            {memos.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-20 text-center">
                <p className="text-3xl mb-2" style={{ color: c.textMuted }}>🗒</p>
                <p className="text-sm" style={{ color: c.textSub }}>아직 메모가 없어요</p>
              </div>
            ) : (
              <div className="flex flex-col">
                {memos.map((m, idx) => (
                  <div
                    key={m.id}
                    className="px-5 py-4"
                    style={{ borderBottom: idx < memos.length - 1 ? `1px solid ${c.borderSub}` : undefined }}
                  >
                    <div className="flex items-center gap-2 mb-2">
                      {m.pageNumber && (
                        <span
                          className="text-[10px] font-semibold px-2 py-0.5 rounded-full"
                          style={{ background: 'rgba(249,115,22,0.15)', color: '#f97316' }}
                        >
                          p.{m.pageNumber}
                        </span>
                      )}
                      <span className="text-[10px]" style={{ color: c.textMuted }}>
                        {new Date(m.createdAt).toLocaleString('ko-KR')}
                      </span>
                    </div>
                    <p className="text-sm leading-relaxed whitespace-pre-wrap" style={{ color: c.textSub }}>{m.content}</p>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}
