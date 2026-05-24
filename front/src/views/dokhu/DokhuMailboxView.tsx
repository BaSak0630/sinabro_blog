import React, { useEffect, useState } from 'react'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'

const REPO = container.resolve(DokhuRepository)

interface Notice {
  id: number
  title: string
  content: string
  createdAt: string
}

type TabKey = 'notice' | 'mail'

export default function DokhuMailboxView() {
  const [notices, setNotices] = useState<Notice[]>([])
  const [selected, setSelected] = useState<Notice | null>(null)
  const [tab, setTab] = useState<TabKey>('notice')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    REPO.getNotices()
      .then(data => { setNotices(data); if (data.length > 0) setSelected(data[0]) })
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [])

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center" style={{ background: '#0f0f0f' }}>
        <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="min-h-screen flex flex-col" style={{ background: '#0f0f0f' }}>
      {/* 헤더 */}
      <div className="px-6 pt-6 pb-4" style={{ borderBottom: '1px solid #1a1a1a' }}>
        <h1 className="text-white text-lg font-bold">우편함</h1>
        <p className="text-slate-600 text-xs mt-0.5">공지와 우편 확인</p>
      </div>

      <div className="flex flex-1">
        {/* 좌측 목록 패널 */}
        <div className="flex-shrink-0 flex flex-col border-r" style={{ width: 260, borderColor: '#1a1a1a' }}>
          {/* 탭 */}
          <div className="flex border-b" style={{ borderColor: '#1a1a1a' }}>
            {([
              { key: 'notice' as TabKey, label: '공지', count: notices.length },
              { key: 'mail' as TabKey, label: '우편', count: 0 },
            ] as { key: TabKey; label: string; count: number }[]).map(t => (
              <button
                key={t.key}
                onClick={() => setTab(t.key)}
                className="flex-1 flex items-center justify-center gap-1.5 py-3 text-xs font-semibold transition-colors relative"
                style={{ color: tab === t.key ? '#fff' : '#555' }}
              >
                {t.label}
                {t.count > 0 && (
                  <span className="w-4 h-4 rounded-full bg-orange-500 flex items-center justify-center text-[9px] text-white font-bold">
                    {t.count}
                  </span>
                )}
                {tab === t.key && (
                  <span className="absolute bottom-0 left-0 right-0 h-0.5 bg-orange-400" />
                )}
              </button>
            ))}
          </div>

          {/* 목록 */}
          <div className="flex-1 overflow-y-auto">
            {tab === 'notice' && (
              notices.length === 0 ? (
                <div className="flex flex-col items-center justify-center py-16 text-center">
                  <p className="text-slate-700 text-2xl mb-2">📭</p>
                  <p className="text-slate-600 text-xs">공지사항이 없습니다</p>
                </div>
              ) : (
                notices.map(n => (
                  <button
                    key={n.id}
                    onClick={() => setSelected(n)}
                    className="w-full text-left px-4 py-3 border-b transition-colors"
                    style={{
                      borderColor: '#1a1a1a',
                      background: selected?.id === n.id ? '#1a1a1a' : 'transparent',
                    }}
                  >
                    <div className="flex items-center gap-2 mb-0.5">
                      <span className="w-1.5 h-1.5 rounded-full flex-shrink-0 bg-orange-500" />
                      <p className="text-xs font-medium truncate" style={{ color: selected?.id === n.id ? '#fff' : '#888' }}>
                        {n.title}
                      </p>
                    </div>
                    <p className="text-[10px] text-slate-700 pl-3.5">
                      {new Date(n.createdAt).toLocaleDateString('ko-KR')}
                      {' '}
                      {new Date(n.createdAt).toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' })}
                    </p>
                  </button>
                ))
              )
            )}
            {tab === 'mail' && (
              <div className="flex flex-col items-center justify-center py-16 text-center">
                <p className="text-slate-700 text-2xl mb-2">📭</p>
                <p className="text-slate-600 text-xs">우편이 없습니다</p>
              </div>
            )}
          </div>
        </div>

        {/* 우측 내용 패널 */}
        <div className="flex-1 relative">
          {selected && tab === 'notice' ? (
            <div className="p-4">
              {/* 내용 카드 (팝업 스타일) */}
              <div className="rounded-2xl overflow-hidden shadow-2xl" style={{ background: '#1a1a1a', border: '1px solid #2a2a2a' }}>
                {/* 카드 헤더 */}
                <div className="flex items-start justify-between px-5 py-4 border-b" style={{ borderColor: '#2a2a2a' }}>
                  <div className="flex-1 min-w-0 mr-3">
                    <div className="flex items-center gap-2 mb-1.5">
                      <span className="text-orange-500 text-xs">🚩</span>
                      <span className="text-slate-500 text-[10px]">
                        {new Date(selected.createdAt).toLocaleDateString('ko-KR')}
                        {' '}
                        {new Date(selected.createdAt).toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' })}
                      </span>
                    </div>
                    <h3 className="text-white text-sm font-bold leading-snug">{selected.title}</h3>
                  </div>
                  <div className="flex items-center gap-2 flex-shrink-0">
                    <button className="text-slate-600 hover:text-slate-400 transition-colors">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4h6v2"/></svg>
                    </button>
                    <button onClick={() => setSelected(null)} className="text-slate-600 hover:text-slate-400 transition-colors">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                    </button>
                  </div>
                </div>

                {/* 카드 내용 */}
                <div className="px-5 py-5">
                  <p className="text-slate-300 text-sm leading-relaxed whitespace-pre-wrap">{selected.content}</p>
                </div>
              </div>
            </div>
          ) : (
            <div className="flex items-center justify-center h-full min-h-48">
              <p className="text-slate-700 text-sm">
                {tab === 'notice' ? '공지를 선택하세요' : '우편이 없습니다'}
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
