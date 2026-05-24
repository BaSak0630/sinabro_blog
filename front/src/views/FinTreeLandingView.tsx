import React, { useCallback, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'

interface Indicator {
  symbol: string
  label: string
  unit: string
  flag: string
  decimals: number
}

interface CardState {
  indicator: Indicator
  price: number | null
  change: number | null
  changePercent: number | null
  marketTime: number | null   // Unix seconds (UTC)
  timezone: string | null
  loading: boolean
  error: boolean
}

const INDICATORS: Indicator[] = [
  { symbol: '^KS11',         label: '코스피',         unit: 'pt', flag: '🇰🇷', decimals: 2 },
  { symbol: '^GSPC',         label: 'S&P 500',       unit: 'pt', flag: '🇺🇸', decimals: 2 },
  { symbol: 'KRW=X',         label: '달러 / 원',      unit: '₩',  flag: '💱',  decimals: 2 },
  { symbol: '^VIX',          label: '공포지수 (VIX)', unit: '',   flag: '😨',  decimals: 2 },
  { symbol: '^TNX',          label: '미국 10년 국채', unit: '%',  flag: '📈',  decimals: 3 },
  { symbol: '^IRJPY10YT=RR', label: '일본 10년 국채', unit: '%',  flag: '🇯🇵', decimals: 3 },
]

// ─── 포맷 유틸 ───────────────────────────────────────────
function formatPrice(val: number, unit: string, decimals: number): string {
  if (unit === '₩')  return val.toLocaleString('ko-KR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
  if (unit === 'pt') return val.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
  return val.toFixed(decimals)
}

function formatMarketTime(unixSeconds: number, timezone: string): string {
  const date = new Date(unixSeconds * 1000)
  try {
    const localStr = date.toLocaleString('ko-KR', {
      timeZone: timezone,
      year:   'numeric',
      month:  '2-digit',
      day:    '2-digit',
      hour:   '2-digit',
      minute: '2-digit',
      hour12: false,
    })
    const abbr = new Intl.DateTimeFormat('en', {
      timeZone: timezone,
      timeZoneName: 'short',
    }).formatToParts(date).find(p => p.type === 'timeZoneName')?.value ?? ''

    return `${localStr} ${abbr}`
  } catch {
    return date.toUTCString()
  }
}

// ─── 카드 컴포넌트 ────────────────────────────────────────
function MarketCard({ card }: { card: CardState }) {
  const { indicator, price, change, changePercent, marketTime, timezone, loading, error } = card
  const isUp       = (change ?? 0) >= 0
  const changeColor = isUp ? 'text-emerald-400' : 'text-red-400'
  const bgAccent   = isUp ? 'bg-emerald-900/20' : 'bg-red-900/20'
  const arrow      = isUp ? '▲' : '▼'

  return (
    <div className="bg-[#1e293b] border border-slate-700/60 rounded-2xl p-5 flex flex-col gap-2.5 hover:border-slate-600 transition-colors">
      {/* 헤더 */}
      <div className="flex items-center gap-2">
        <span className="text-xl">{indicator.flag}</span>
        <span className="text-slate-400 text-xs font-semibold tracking-wide">{indicator.label}</span>
      </div>

      {/* 본문 */}
      {loading ? (
        <div className="space-y-2 pt-1">
          <div className="h-6 bg-slate-700 rounded-lg animate-pulse w-3/4" />
          <div className="h-3.5 bg-slate-700 rounded-lg animate-pulse w-1/2" />
          <div className="h-3 bg-slate-700/60 rounded-lg animate-pulse w-2/3 mt-1" />
        </div>
      ) : error || price === null ? (
        <div className="pt-1">
          <p className="text-slate-500 text-lg font-semibold">—</p>
          <p className="text-slate-600 text-xs mt-0.5">데이터 없음</p>
        </div>
      ) : (
        <>
          {/* 현재가 */}
          <p className="text-white font-bold text-xl leading-none">
            {formatPrice(price, indicator.unit, indicator.decimals)}
            {indicator.unit && (
              <span className="text-slate-500 text-xs font-normal ml-1.5">{indicator.unit}</span>
            )}
          </p>

          {/* 등락 */}
          {change !== null && changePercent !== null && (
            <div className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-md w-fit ${bgAccent}`}>
              <span className={`text-xs font-semibold ${changeColor}`}>
                {arrow} {Math.abs(change).toFixed(indicator.decimals)}
              </span>
              <span className={`text-xs ${changeColor} opacity-80`}>
                ({Math.abs(changePercent).toFixed(2)}%)
              </span>
            </div>
          )}

          {/* 기준 시간 */}
          {marketTime != null && timezone && (
            <p className="text-slate-600 text-[10px] leading-tight mt-0.5">
              기준 {formatMarketTime(marketTime, timezone)}
            </p>
          )}
        </>
      )}
    </div>
  )
}

// ─── 메인 뷰 ─────────────────────────────────────────────
export default function FinTreeLandingView() {
  const navigate = useNavigate()

  const [cards, setCards] = useState<CardState[]>(
    INDICATORS.map(ind => ({
      indicator: ind,
      price: null, change: null, changePercent: null,
      marketTime: null, timezone: null,
      loading: true, error: false,
    }))
  )
  const [lastUpdated, setLastUpdated] = useState<Date | null>(null)
  const [fetching, setFetching]       = useState(false)

  const fetchMarketData = useCallback(async () => {
    setFetching(true)
    setCards(prev => prev.map(c => ({ ...c, loading: true, error: false })))
    try {
      const res = await fetch('/api/market/quotes')
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const list: {
        symbol: string
        price: number | null
        change: number | null
        changePercent: number | null
        marketTime: number | null
        timezone: string | null
      }[] = await res.json()

      setCards(
        INDICATORS.map(ind => {
          const r = list.find(q => q.symbol === ind.symbol)
          return {
            indicator:     ind,
            price:         r?.price         ?? null,
            change:        r?.change        ?? null,
            changePercent: r?.changePercent ?? null,
            marketTime:    r?.marketTime    ?? null,
            timezone:      r?.timezone      ?? null,
            loading: false,
            error:   r == null || r.price == null,
          }
        })
      )
      setLastUpdated(new Date())
    } catch {
      setCards(prev => prev.map(c => ({ ...c, loading: false, error: true })))
    } finally {
      setFetching(false)
    }
  }, [])

  useEffect(() => { fetchMarketData() }, [fetchMarketData])

  return (
    <div className="flex flex-col gap-6">

      {/* ── 히어로 ── */}
      <div className="bg-[#0f172a] rounded-2xl border border-slate-800 p-8 flex flex-col sm:flex-row items-center gap-6">
        <div className="flex-shrink-0 text-7xl select-none">🌳</div>

        <div className="flex-1 text-center sm:text-left">
          <h1 className="text-2xl font-extrabold text-white tracking-tight mb-1">
            Fin<span style={{ color: '#34d399' }}>Tree</span>
          </h1>
          <p className="text-slate-400 text-sm leading-relaxed mb-5">
            투자 · 보험 · 연금 · 세금 · 부동산 · 신용까지<br />
            금융 지식을 단계별 스킬트리로 체계적으로 쌓아보세요
          </p>
          <button
            onClick={() => navigate('/fintree/tree')}
            className="bg-emerald-600 hover:bg-emerald-500 active:bg-emerald-700 text-white text-sm font-bold px-7 py-2.5 rounded-xl transition-colors shadow-lg shadow-emerald-900/40"
          >
            스킬트리 시작하기 →
          </button>
        </div>
      </div>

      {/* ── 시장 현황 ── */}
      <div>
        <div className="flex items-end justify-between mb-4">
          <div>
            <h2 className="text-slate-800 font-bold text-base tracking-tight">글로벌 시장 현황</h2>
            <p className="text-slate-400 text-xs mt-0.5">
              {lastUpdated
                ? `페이지 로드 ${lastUpdated.toLocaleTimeString('ko-KR')} 기준 · 시장 데이터는 15–20분 지연`
                : '데이터 불러오는 중…'}
            </p>
          </div>
          <button
            onClick={fetchMarketData}
            disabled={fetching}
            className="text-xs text-slate-500 hover:text-emerald-600 disabled:opacity-40 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-lg transition-colors flex items-center gap-1.5"
          >
            <span className={fetching ? 'animate-spin inline-block' : ''}>↻</span>
            새로고침
          </button>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
          {cards.map(card => (
            <MarketCard key={card.indicator.symbol} card={card} />
          ))}
        </div>
      </div>
    </div>
  )
}
