import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import AccountRepository from '@/repository/AccountRepository'
import ProfileRepository from '@/repository/ProfileRepository'
import type { UserBook } from '@/entity/dokhu/UserBook'
import type UserProfile from '@/entity/user/UserProfile'

const REPO = container.resolve(DokhuRepository)
const ACCOUNT = container.resolve(AccountRepository)
const PROFILE_REPO = container.resolve(ProfileRepository)

/* 책 검색/직접 추가 모달 */
function BookSearchModal({ onClose, onSelect }: {
  onClose: () => void
  onSelect: (data: any) => void
}) {
  const [query, setQuery] = useState('')
  const [showManual, setShowManual] = useState(false)
  const [form, setForm] = useState({ title: '', author: '', isbn: '', coverImageUrl: '', publisher: '', genre: '', totalPages: '', publishDate: '', synopsis: '' })

  function handleManualSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!form.title || !form.author) return
    onSelect({ ...form, totalPages: form.totalPages ? Number(form.totalPages) : undefined })
  }

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center pt-16" style={{ background: 'rgba(0,0,0,0.85)' }}>
      <div className="w-full max-w-lg rounded-2xl overflow-hidden shadow-2xl" style={{ background: '#111', border: '1px solid #2a2a2a' }}>
        {/* 검색창 */}
        <div className="flex items-center gap-3 px-4 py-3.5" style={{ borderBottom: '1px solid #1e1e1e' }}>
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#666" strokeWidth="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
          <input
            autoFocus
            className="flex-1 bg-transparent text-white text-sm placeholder-slate-600 outline-none"
            placeholder="책 제목, 저자 검색"
            value={query}
            onChange={e => setQuery(e.target.value)}
          />
          <button onClick={onClose} className="text-slate-600 hover:text-slate-400 text-lg leading-none">✕</button>
        </div>

        {!showManual ? (
          <div className="p-5">
            <p className="text-slate-600 text-xs text-center py-4">찾으시는 책이 없나요?</p>
            <button
              onClick={() => setShowManual(true)}
              className="w-full text-sm text-orange-400 border border-orange-400/30 rounded-xl py-2.5 hover:bg-orange-400/10 transition-colors flex items-center justify-center gap-2"
            >
              <span>＋</span> 직접 추가하기
            </button>
          </div>
        ) : (
          <div style={{ background: '#0f0f0f' }}>
            {/* 직접 추가하기 모달 헤더 */}
            <div className="flex items-center justify-between px-5 py-3.5 border-b" style={{ borderColor: '#1e1e1e' }}>
              <div className="flex items-center gap-2">
                <span className="text-orange-400 text-xs">✎</span>
                <span className="text-white text-sm font-semibold">직접 추가하기</span>
              </div>
              <button onClick={() => setShowManual(false)} className="text-slate-600 hover:text-slate-400">✕</button>
            </div>
            <form onSubmit={handleManualSubmit} className="p-5 grid grid-cols-2 gap-3 max-h-96 overflow-y-auto">
              {/* 왼쪽: 표지 미리보기 + 스파인 */}
              <div className="col-span-2 flex gap-3 mb-1">
                <div className="w-24 h-32 rounded-lg border-2 border-dashed flex items-center justify-center flex-shrink-0" style={{ borderColor: '#333', background: '#111' }}>
                  {form.coverImageUrl ? (
                    <img src={form.coverImageUrl} alt="" className="w-full h-full object-cover rounded-lg" />
                  ) : (
                    <span className="text-slate-700 text-2xl">+</span>
                  )}
                </div>
                <div className="flex flex-col gap-2 flex-1">
                  <div>
                    <label className="text-[10px] text-slate-500 mb-1 block">제목 *</label>
                    <input className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border focus:border-orange-500 transition-colors" style={{ background: '#111', borderColor: '#2a2a2a' }} placeholder="도서명 입력" value={form.title} onChange={e => setForm(p => ({ ...p, title: e.target.value }))} />
                  </div>
                  <div>
                    <label className="text-[10px] text-slate-500 mb-1 block">저자</label>
                    <input className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border focus:border-orange-500 transition-colors" style={{ background: '#111', borderColor: '#2a2a2a' }} placeholder="저자명 입력" value={form.author} onChange={e => setForm(p => ({ ...p, author: e.target.value }))} />
                  </div>
                  <div>
                    <label className="text-[10px] text-slate-500 mb-1 block">출판사</label>
                    <input className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border focus:border-orange-500 transition-colors" style={{ background: '#111', borderColor: '#2a2a2a' }} placeholder="출판사 입력" value={form.publisher} onChange={e => setForm(p => ({ ...p, publisher: e.target.value }))} />
                  </div>
                </div>
              </div>
              <div>
                <label className="text-[10px] text-slate-500 mb-1 block">표지 이미지 URL</label>
                <input className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border focus:border-orange-500 transition-colors" style={{ background: '#111', borderColor: '#2a2a2a' }} placeholder="http://..." value={form.coverImageUrl} onChange={e => setForm(p => ({ ...p, coverImageUrl: e.target.value }))} />
              </div>
              <div>
                <label className="text-[10px] text-slate-500 mb-1 block">페이지 수 *</label>
                <input type="number" className="w-full rounded-lg px-3 py-2 text-sm text-white placeholder-slate-600 outline-none border focus:border-orange-500 transition-colors" style={{ background: '#111', borderColor: '#2a2a2a' }} placeholder="000" value={form.totalPages} onChange={e => setForm(p => ({ ...p, totalPages: e.target.value }))} />
              </div>
              <div className="col-span-2 flex gap-2 mt-1">
                <button type="button" onClick={() => setShowManual(false)} className="flex-1 text-sm text-slate-400 border border-slate-700 rounded-xl py-2.5 hover:bg-slate-800 transition-colors">취소</button>
                <button type="submit" className="flex-1 text-sm text-white bg-orange-500 rounded-xl py-2.5 hover:bg-orange-600 transition-colors font-semibold">추가</button>
              </div>
            </form>
          </div>
        )}
      </div>
    </div>
  )
}

/* 읽기 상태 카드 */
function ReadingStatusCard({ userBook, onRead, onNote }: { userBook: UserBook; onRead: () => void; onNote: () => void }) {
  const isCompleted = userBook.status === 'COMPLETED'

  if (isCompleted) {
    return (
      <div className="rounded-xl p-4 relative overflow-hidden" style={{ background: '#f97316' }}>
        <span className="absolute right-3 top-3 text-white/10 font-black text-4xl tracking-tighter select-none pointer-events-none">DOKHU</span>
        <p className="text-white/70 text-[10px] font-semibold mb-1.5">완독!</p>
        <h3 className="text-white font-bold text-sm leading-tight mb-0.5 truncate">{userBook.book.title}</h3>
        <p className="text-white/60 text-[11px] mb-3">{userBook.book.author}</p>
        <div className="flex items-center justify-between text-[10px] mb-1.5">
          <span className="text-white/60">완독 · {userBook.book.totalPages ?? userBook.currentPage}/{userBook.book.totalPages ?? userBook.currentPage}</span>
          <span className="text-white font-bold">100%</span>
        </div>
        <div className="h-0.5 bg-black/20 rounded-full mb-3 overflow-hidden">
          <div className="h-full bg-white rounded-full w-full" />
        </div>
        <div className="flex gap-2">
          <button onClick={onNote} className="flex-1 text-[11px] font-medium py-2 rounded-lg text-white/80 flex items-center justify-center gap-1" style={{ background: 'rgba(255,255,255,0.15)' }}>
            ✏ 독후감 작성
          </button>
          <button className="flex-1 text-[11px] font-medium py-2 rounded-lg text-white flex items-center justify-center gap-1" style={{ background: 'rgba(0,0,0,0.25)' }}>
            □ 다음 책 읽기
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="rounded-xl p-4" style={{ background: '#1a1a1a', border: '1px solid #2a2a2a' }}>
      <h3 className="text-white font-bold text-sm leading-tight mb-0.5 truncate">{userBook.book.title}</h3>
      <p className="text-slate-500 text-[11px] mb-3">{userBook.book.author}</p>
      {userBook.book.totalPages && (
        <div className="mb-3">
          <div className="flex justify-between text-[10px] text-slate-500 mb-1.5">
            <span>{userBook.currentPage}/{userBook.book.totalPages}</span>
            <span>{userBook.progressPercent}%</span>
          </div>
          <div className="h-0.5 rounded-full overflow-hidden" style={{ background: '#2a2a2a' }}>
            <div className="h-full bg-orange-500 rounded-full transition-all" style={{ width: `${userBook.progressPercent}%` }} />
          </div>
        </div>
      )}
      <button
        onClick={onRead}
        className="w-full py-2.5 rounded-lg text-white text-xs font-semibold flex items-center justify-center gap-2 hover:opacity-90 transition-opacity"
        style={{ background: '#f97316' }}
      >
        <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor"><polygon points="5,3 19,12 5,21"/></svg>
        이어 읽기
      </button>
    </div>
  )
}

/* 추가 상태 카드 (아직 읽는 책 없음) */
function AddingCard({ onAdd }: { onAdd: () => void }) {
  return (
    <div className="rounded-xl p-4" style={{ background: '#1a1a1a', border: '1px solid #2a2a2a' }}>
      <h3 className="text-white font-bold text-sm mb-1">책 추가하기</h3>
      <p className="text-slate-500 text-[11px] mb-3">서재에 책을 추가 해보세요</p>
      <button
        onClick={onAdd}
        className="w-full py-2.5 rounded-lg text-white text-xs font-semibold flex items-center justify-center gap-2 hover:opacity-90 transition-opacity"
        style={{ background: 'transparent', border: '1px solid #f97316', color: '#f97316' }}
      >
        + 책 추가하기
      </button>
    </div>
  )
}

export default function DokhuHomeView() {
  const navigate = useNavigate()
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [library, setLibrary] = useState<UserBook[]>([])
  const [loading, setLoading] = useState(true)
  const [showSearch, setShowSearch] = useState(false)

  useEffect(() => {
    ACCOUNT.getProfile()
      .then(p => { PROFILE_REPO.setProfile(p); setProfile(p); return REPO.getLibrary() })
      .then(setLibrary)
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  function handleAddBook(data: any) {
    REPO.registerBook(data)
      .then(ub => { setLibrary(prev => [ub, ...prev]); setShowSearch(false) })
      .catch(() => alert('책 추가에 실패했습니다.'))
  }

  const reading = library.filter(b => b.status === 'READING')
  const completed = library.filter(b => b.status === 'COMPLETED')
  const lastReadBook = reading[0] ?? completed[0] ?? null

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center" style={{ background: '#0f0f0f' }}>
      <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
    </div>
  )

  if (!profile) return (
    <div className="min-h-screen flex flex-col items-center justify-center px-8 text-center" style={{ background: '#0f0f0f' }}>
      <div className="w-16 h-16 rounded-2xl bg-orange-500/10 flex items-center justify-center mb-5">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#f97316" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
          <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
        </svg>
      </div>
      <h2 className="text-white text-xl font-bold mb-2">DOKHU</h2>
      <p className="text-slate-500 text-sm mb-6">독서를 기록하고 집중해서 책을 읽는 공간</p>
      <button onClick={() => navigate('/login', { state: { from: '/dokhu' } })} className="px-6 py-2.5 rounded-xl text-white text-sm font-semibold bg-orange-500 hover:bg-orange-600 transition-colors">
        로그인하기
      </button>
    </div>
  )

  return (
    <div className="flex flex-col min-h-screen" style={{ background: '#0f0f0f' }}>
      {showSearch && <BookSearchModal onClose={() => setShowSearch(false)} onSelect={handleAddBook} />}

      {/* 검색창 */}
      <div className="px-5 pt-4 pb-3" style={{ borderBottom: '1px solid #1a1a1a' }}>
        <button
          onClick={() => setShowSearch(true)}
          className="w-full flex items-center gap-3 px-4 py-2.5 rounded-xl text-slate-500 text-sm text-left transition-colors hover:border-slate-600"
          style={{ background: '#1a1a1a', border: '1px solid #252525' }}
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
          책 제목, 저자, 장르 검색
        </button>
      </div>

      {/* 콘텐츠 */}
      <div className="flex flex-1">
        {/* 좌측 패널 */}
        <div className="flex-shrink-0 flex flex-col gap-3 p-4 border-r" style={{ width: 260, borderColor: '#1a1a1a' }}>
          {/* 프로필 카드 */}
          <div className="rounded-xl p-4" style={{ background: '#1a1a1a', border: '1px solid #252525' }}>
            <div className="flex items-center justify-between mb-3">
              <span className="text-slate-600 text-[10px] font-semibold uppercase tracking-wider">프로필</span>
              <button className="text-slate-600 hover:text-slate-400 text-sm leading-none">···</button>
            </div>
            <div className="flex items-center gap-3 mb-3">
              <div className="w-11 h-11 rounded-full bg-gradient-to-br from-orange-400 to-red-500 flex items-center justify-center text-white font-bold text-base flex-shrink-0">
                {profile.accountId.charAt(0).toUpperCase()}
              </div>
              <div className="min-w-0">
                <p className="text-white font-bold text-sm truncate">{profile.accountId}</p>
                <p className="text-slate-500 text-[11px]">한 줄 소개</p>
              </div>
            </div>
            <div className="pt-2.5" style={{ borderTop: '1px solid #252525' }}>
              <p className="text-slate-500 text-[11px]">
                <span className="text-white font-semibold">완독 {completed.length}권</span>
                <span className="mx-1.5 text-slate-700">|</span>
                <span className="text-white font-semibold">독서 0시간</span>
              </p>
            </div>
          </div>

          {/* 오늘의 문학 카드 */}
          <div className="rounded-xl p-4" style={{ background: '#000', border: '1px solid #1e1e1e' }}>
            <p className="text-slate-600 text-[10px] font-semibold mb-2">오늘의 문학</p>
            <p className="text-slate-200 text-xs font-bold mb-0.5">서시</p>
            <p className="text-slate-500 text-[10px] mb-3">윤동주</p>
            <div className="text-slate-400 text-[11px] leading-relaxed space-y-0.5">
              <p>죽는 날까지 하늘을 우러러</p>
              <p>한 점 부끄럼이 없기를,</p>
              <p>잎새에 이는 바람에도</p>
              <p>나는 괴로워했다.</p>
              <p className="mt-2">별을 노래하는 마음으로</p>
              <p>모든 죽어가는 것을 사랑해야지</p>
              <p>그리고 나한테 주어진 길을</p>
              <p>걸어가야겠다.</p>
              <p className="mt-2">오늘 밤에도 별이 바람에 스치운다.</p>
            </div>
          </div>

          {/* 읽기 상태 카드 */}
          {lastReadBook ? (
            <ReadingStatusCard
              userBook={lastReadBook}
              onRead={() => navigate(`/dokhu/flow/${lastReadBook.id}`)}
              onNote={() => navigate(`/dokhu/note/${lastReadBook.id}`)}
            />
          ) : (
            <AddingCard onAdd={() => setShowSearch(true)} />
          )}
        </div>

        {/* 우측 콘텐츠 */}
        <div className="flex-1 flex flex-col gap-3 p-4">
          {/* 책 추가하기 */}
          <div className="rounded-xl p-5" style={{ background: '#1a1a1a', border: '1px solid #252525' }}>
            <p className="text-white font-bold text-sm mb-1">책 추가하기</p>
            <p className="text-slate-500 text-[11px] mb-3">서재에 책을 추가 해보세요</p>
            <button
              onClick={() => setShowSearch(true)}
              className="w-full py-2.5 rounded-xl text-white text-sm font-semibold flex items-center justify-center gap-2 hover:opacity-90 transition-opacity"
              style={{ background: '#f97316' }}
            >
              + 책 추가하기
            </button>
          </div>

          {/* 바로가기 버튼들 */}
          <button
            onClick={() => navigate('/dokhu/library')}
            className="w-full flex items-center justify-between px-5 py-4 rounded-xl text-white text-sm font-medium hover:opacity-80 transition-opacity"
            style={{ background: '#1a1a1a', border: '1px solid #252525' }}
          >
            <span>서재로 이동하기</span>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#555" strokeWidth="2"><polyline points="9 18 15 12 9 6"/></svg>
          </button>

          <button
            className="w-full flex items-center justify-between px-5 py-4 rounded-xl text-white text-sm font-medium hover:opacity-80 transition-opacity"
            style={{ background: '#1a1a1a', border: '1px solid #252525' }}
          >
            <span>피드백 보내기</span>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#555" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
          </button>

          <button
            className="w-full flex items-center justify-between px-5 py-4 rounded-xl text-white text-sm font-medium hover:opacity-80 transition-opacity"
            style={{ background: '#1a1a1a', border: '1px solid #252525' }}
          >
            <span>후원하기</span>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#555" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
          </button>
        </div>
      </div>
    </div>
  )
}
