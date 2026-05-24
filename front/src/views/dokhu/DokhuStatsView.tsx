import React, { useEffect, useState } from 'react'
import { container } from 'tsyringe'
import DokhuRepository from '@/repository/DokhuRepository'
import type { UserBook } from '@/entity/dokhu/UserBook'
import { useTheme } from '@/context/ThemeContext'

const REPO = container.resolve(DokhuRepository)

/* SVG 도넛 차트 */
function DonutChart({ data }: { data: { label: string; value: number; color: string }[] }) {
  const total = data.reduce((s, d) => s + d.value, 0)
  if (total === 0) return (
    <div className="w-28 h-28 rounded-full flex items-center justify-center" style={{ background: '#1a1a1a' }}>
      <span className="text-slate-600 text-xs">없음</span>
    </div>
  )

  const r = 40
  const circ = 2 * Math.PI * r
  let offset = 0

  return (
    <svg width="112" height="112" viewBox="0 0 112 112">
      <circle cx="56" cy="56" r={r} fill="none" stroke="#2a2a2a" strokeWidth="18" />
      {data.filter(d => d.value > 0).map((d, i) => {
        const dash = (d.value / total) * circ
        const gap = circ - dash
        const el = (
          <circle
            key={i}
            cx="56" cy="56" r={r}
            fill="none"
            stroke={d.color}
            strokeWidth="18"
            strokeDasharray={`${dash} ${gap}`}
            strokeDashoffset={-offset + circ * 0.25}
            strokeLinecap="butt"
          />
        )
        offset += dash
        return el
      })}
      <text x="56" y="52" textAnchor="middle" fill="white" fontSize="18" fontWeight="bold" fontFamily="monospace">{total}</text>
      <text x="56" y="66" textAnchor="middle" fill="#666" fontSize="9" fontFamily="sans-serif">총 권수</text>
    </svg>
  )
}

/* 가로 바 */
function Bar({ label, value, max, color, c }: { label: string; value: number; max: number; color: string; c: any }) {
  const pct = max > 0 ? Math.round((value / max) * 100) : 0
  return (
    <div className="flex items-center gap-3">
      <span className="text-xs w-20 truncate flex-shrink-0" style={{ color: c.textSub }}>{label}</span>
      <div className="flex-1 h-2 rounded-full overflow-hidden" style={{ background: c.border }}>
        <div className="h-full rounded-full transition-all duration-500" style={{ width: `${pct}%`, background: color }} />
      </div>
      <span className="text-xs w-6 text-right flex-shrink-0" style={{ color: c.textMuted }}>{value}</span>
    </div>
  )
}

export default function DokhuStatsView() {
  const { c, isDark } = useTheme()
  const [library, setLibrary] = useState<UserBook[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    REPO.getLibrary().then(setLibrary).catch(() => {}).finally(() => setLoading(false))
  }, [])

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center" style={{ background: c.bg }}>
      <div className="w-5 h-5 border-2 border-orange-500 border-t-transparent rounded-full animate-spin" />
    </div>
  )

  const completed = library.filter(b => b.status === 'COMPLETED')
  const reading = library.filter(b => b.status === 'READING')
  const adding = library.filter(b => b.status === 'ADDING')

  /* 장르 분포 */
  const genreMap: Record<string, number> = {}
  library.forEach(b => {
    const g = b.book.genre || '미분류'
    genreMap[g] = (genreMap[g] ?? 0) + 1
  })
  const genres = Object.entries(genreMap).sort((a, b) => b[1] - a[1]).slice(0, 6)
  const maxGenre = genres[0]?.[1] ?? 1

  /* 별점 분포 */
  const starMap: Record<number, number> = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }
  completed.forEach(b => { if (b.starRating > 0) starMap[b.starRating] = (starMap[b.starRating] ?? 0) + 1 })
  const maxStar = Math.max(...Object.values(starMap), 1)

  /* 완독 진행률 분포 */
  const pctBuckets = [
    { label: '0%', count: library.filter(b => b.progressPercent === 0).length },
    { label: '1–25%', count: library.filter(b => b.progressPercent > 0 && b.progressPercent <= 25).length },
    { label: '26–50%', count: library.filter(b => b.progressPercent > 25 && b.progressPercent <= 50).length },
    { label: '51–75%', count: library.filter(b => b.progressPercent > 50 && b.progressPercent <= 75).length },
    { label: '76–99%', count: library.filter(b => b.progressPercent > 75 && b.progressPercent < 100).length },
    { label: '100%', count: completed.length },
  ]
  const maxBucket = Math.max(...pctBuckets.map(b => b.count), 1)

  const donutData = [
    { label: '완독', value: completed.length, color: '#f97316' },
    { label: '읽는 중', value: reading.length, color: '#60a5fa' },
    { label: '읽을 예정', value: adding.length, color: '#4a4a4a' },
  ]

  const statCards = [
    { label: '총 도서', value: library.length, sub: '권', color: c.text },
    { label: '완독', value: completed.length, sub: '권', color: '#f97316' },
    { label: '읽는 중', value: reading.length, sub: '권', color: '#60a5fa' },
    { label: '읽을 예정', value: adding.length, sub: '권', color: c.textSub },
  ]

  return (
    <div className="min-h-screen" style={{ background: c.bg }}>
      {/* 헤더 */}
      <div className="px-6 pt-6 pb-5" style={{ borderBottom: `1px solid ${c.borderSub}` }}>
        <h1 className="font-bold text-xl" style={{ color: c.text }}>통계</h1>
        <p className="text-xs mt-0.5" style={{ color: c.textMuted }}>나의 독서 현황</p>
      </div>

      <div className="px-6 py-5 flex flex-col gap-5 max-w-2xl">

        {/* 상단 stat 카드 4개 */}
        <div className="grid grid-cols-4 gap-3">
          {statCards.map(s => (
            <div key={s.label} className="rounded-xl p-4 text-center" style={{ background: c.card, border: `1px solid ${c.border}` }}>
              <p className="font-black text-2xl" style={{ color: s.color }}>{s.value}</p>
              <p className="text-[10px] mt-0.5" style={{ color: c.textMuted }}>{s.label}</p>
            </div>
          ))}
        </div>

        {/* 상태 도넛 + 범례 */}
        <div className="rounded-2xl p-5" style={{ background: c.card, border: `1px solid ${c.border}` }}>
          <p className="text-xs font-semibold mb-4" style={{ color: c.text }}>독서 상태 분포</p>
          <div className="flex items-center gap-8">
            <DonutChart data={donutData} />
            <div className="flex flex-col gap-3">
              {donutData.map(d => (
                <div key={d.label} className="flex items-center gap-2.5">
                  <span className="w-2.5 h-2.5 rounded-full flex-shrink-0" style={{ background: d.color }} />
                  <span className="text-xs" style={{ color: c.textSub }}>{d.label}</span>
                  <span className="text-xs font-bold ml-auto" style={{ color: c.text }}>{d.value}권</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* 진행률 분포 */}
        <div className="rounded-2xl p-5" style={{ background: c.card, border: `1px solid ${c.border}` }}>
          <p className="text-xs font-semibold mb-4" style={{ color: c.text }}>진행률 분포</p>
          <div className="flex flex-col gap-3">
            {pctBuckets.map(b => (
              <Bar key={b.label} label={b.label} value={b.count} max={maxBucket} color="#f97316" c={c} />
            ))}
          </div>
        </div>

        {/* 장르 분포 */}
        {genres.length > 0 && (
          <div className="rounded-2xl p-5" style={{ background: c.card, border: `1px solid ${c.border}` }}>
            <p className="text-xs font-semibold mb-4" style={{ color: c.text }}>장르 분포</p>
            <div className="flex flex-col gap-3">
              {genres.map(([genre, count]) => (
                <Bar key={genre} label={genre} value={count} max={maxGenre} color="#60a5fa" c={c} />
              ))}
            </div>
          </div>
        )}

        {/* 별점 분포 */}
        {completed.length > 0 && (
          <div className="rounded-2xl p-5" style={{ background: c.card, border: `1px solid ${c.border}` }}>
            <p className="text-xs font-semibold mb-4" style={{ color: c.text }}>별점 분포</p>
            <div className="flex flex-col gap-3">
              {[5, 4, 3, 2, 1].map(star => (
                <div key={star} className="flex items-center gap-3">
                  <div className="flex gap-0.5 w-20 flex-shrink-0">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <span key={i} className="text-[11px]" style={{ color: i < star ? '#f97316' : c.border }}>★</span>
                    ))}
                  </div>
                  <div className="flex-1 h-2 rounded-full overflow-hidden" style={{ background: c.border }}>
                    <div
                      className="h-full rounded-full transition-all duration-500"
                      style={{ width: `${Math.round((starMap[star] / maxStar) * 100)}%`, background: '#f97316' }}
                    />
                  </div>
                  <span className="text-xs w-6 text-right flex-shrink-0" style={{ color: c.textMuted }}>{starMap[star]}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* 완독 목록 */}
        {completed.length > 0 && (
          <div className="rounded-2xl p-5" style={{ background: c.card, border: `1px solid ${c.border}` }}>
            <p className="text-xs font-semibold mb-4" style={{ color: c.text }}>완독 목록 ({completed.length}권)</p>
            <div className="flex flex-col gap-3">
              {completed.map((ub, i) => (
                <div key={ub.id} className="flex items-center gap-3">
                  <span className="text-xs w-5 text-right flex-shrink-0" style={{ color: c.textMuted }}>{i + 1}</span>
                  {ub.book.coverImageUrl ? (
                    <img src={ub.book.coverImageUrl} alt="" className="w-8 h-11 object-cover rounded flex-shrink-0" />
                  ) : (
                    <div className="w-8 h-11 rounded flex-shrink-0 bg-orange-500/20 flex items-center justify-center">
                      <span className="text-[8px] text-orange-400">📖</span>
                    </div>
                  )}
                  <div className="flex-1 min-w-0">
                    <p className="text-xs font-medium truncate" style={{ color: c.text }}>{ub.book.title}</p>
                    <p className="text-[10px] truncate" style={{ color: c.textMuted }}>{ub.book.author}</p>
                  </div>
                  <div className="flex gap-0.5 flex-shrink-0">
                    {Array.from({ length: 5 }).map((_, j) => (
                      <span key={j} className="text-[9px]" style={{ color: j < ub.starRating ? '#f97316' : c.border }}>★</span>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        <div className="h-6" />
      </div>
    </div>
  )
}
