import React, { useEffect, useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { container } from 'tsyringe'
import type SkillNode from '@/entity/fintree/SkillNode'
import type { NodeStatus, Difficulty } from '@/entity/fintree/SkillNode'
import type UserProfile from '@/entity/user/UserProfile'
import SkillTreeRepository from '@/repository/SkillTreeRepository'
import AccountRepository from '@/repository/AccountRepository'

const REPO    = container.resolve(SkillTreeRepository)
const ACCOUNT = container.resolve(AccountRepository)

// ─────────────────── 레이아웃 상수 ───────────────────
const NODE_R      = 26   // 노드 원 반지름
const NODE_SLOT_W = 108  // 노드 가로 슬롯 (center-to-center)
const ROW_H       = 115  // 행 높이
const TITLE_H     = 34   // 노드 제목 공간
const PAD_X       = 60
const PAD_Y       = 44

// ─────────────────── 분기 컬러 팔레트 ───────────────────
// 공통 → 분기 라인 해금 구조에서 Lv2(depth 3) 노드의 column 순서로 색 결정
const BRANCH_COLORS = [
  '#f97316', // 보험    – 주황
  '#3b82f6', // 주식ETF – 파랑
  '#8b5cf6', // 연금    – 보라
  '#ef4444', // 부동산  – 빨강
  '#eab308', // 세금    – 노랑
  '#10b981', // 신용    – 초록
  '#06b6d4', // 암호화폐– 청록
]
const MASTER_COLOR  = '#f59e0b'  // 마스터 트리
const COMMON_COLOR  = '#94a3b8'  // 공통 트리

// ─────────────────── 깊이 계산 ───────────────────
function computeDepths(nodes: SkillNode[]): Map<number, number> {
  const nodeMap = new Map(nodes.map(n => [n.id, n]))
  const memo    = new Map<number, number>()
  function depth(id: number): number {
    if (memo.has(id)) return memo.get(id)!
    const node = nodeMap.get(id)
    if (!node || node.prerequisiteIds.length === 0) { memo.set(id, 0); return 0 }
    const d = Math.max(...node.prerequisiteIds.map(depth)) + 1
    memo.set(id, d); return d
  }
  nodes.forEach(n => depth(n.id))
  return memo
}

// ─────────────────── 분기 감지 ───────────────────
// 각 노드의 "조상 중 가장 얕은 비-공통 노드"를 찾아 branch 인덱스 부여
function computeBranchMap(
  nodes: SkillNode[],
  depths: Map<number, number>,
): Map<number, number | null> {
  const branchDepth = 3 // FinTree 구조에서 7개 분기가 시작되는 깊이
  const nodeMap = new Map(nodes.map(n => [n.id, n]))

  // depth == branchDepth 인 노드들 → 분기 루트, orderIndex 순 정렬
  const branchRoots = nodes
    .filter(n => depths.get(n.id) === branchDepth)
    .sort((a, b) => a.orderIndex - b.orderIndex)

  const branchOf = new Map<number, number>()
  branchRoots.forEach((r, i) => branchOf.set(r.id, i))

  // BFS 로 자식들에게 branch 인덱스 전파
  const queue = [...branchRoots.map(r => r.id)]
  const visited = new Set(queue)
  while (queue.length > 0) {
    const id = queue.shift()!
    const idx = branchOf.get(id)!
    const children = nodes.filter(n => n.prerequisiteIds.includes(id) && !visited.has(n.id))
    for (const c of children) {
      // 이미 다른 branch 에서 할당됐으면 덮어쓰지 않음 (마스터 트리 처리)
      if (!branchOf.has(c.id)) {
        branchOf.set(c.id, idx)
      }
      visited.add(c.id)
      queue.push(c.id)
    }
  }

  const result = new Map<number, number | null>()
  nodes.forEach(n => result.set(n.id, branchOf.get(n.id) ?? null))
  return result
}

// ─────────────────── 레이아웃 계산 ───────────────────
function computeLayout(nodes: SkillNode[]) {
  const depths = computeDepths(nodes)
  const rows   = new Map<number, SkillNode[]>()

  for (const node of nodes) {
    const d = depths.get(node.id) ?? 0
    if (!rows.has(d)) rows.set(d, [])
    rows.get(d)!.push(node)
  }
  for (const [, row] of rows) row.sort((a, b) => a.orderIndex - b.orderIndex)

  const maxRowCount = Math.max(...Array.from(rows.values()).map(r => r.length), 1)
  const maxDepth    = Math.max(...Array.from(rows.keys()), 0)
  const canvasW     = maxRowCount * NODE_SLOT_W + PAD_X * 2
  const canvasH     = PAD_Y + (maxDepth + 1) * ROW_H + NODE_R + TITLE_H + PAD_Y

  const positions = new Map<number, { cx: number; cy: number }>()
  for (const [d, rowNodes] of rows) {
    const rowW   = rowNodes.length * NODE_SLOT_W
    const startX = (canvasW - rowW) / 2 + NODE_SLOT_W / 2
    rowNodes.forEach((node, i) => {
      positions.set(node.id, {
        cx: startX + i * NODE_SLOT_W,
        cy: PAD_Y + d * ROW_H + NODE_R,
      })
    })
  }
  return { positions, canvasW, canvasH, depths }
}

// ─────────────────── 2등신 다람쥐 캐릭터 ───────────────────
function SquirrelSVG({ level }: { level: number }) {
  return (
    <div className="relative flex-shrink-0">
      <svg viewBox="0 0 70 82" width="88" height="104">
        {/* 꼬리 (뒤에 그리기) */}
        <ellipse cx="56" cy="62" rx="15" ry="21" fill="#d97706" transform="rotate(18,56,62)" />
        <ellipse cx="55" cy="61" rx="10" ry="16" fill="#fef3c7" transform="rotate(18,55,61)" />

        {/* 몸통 */}
        <ellipse cx="33" cy="66" rx="16" ry="14" fill="#f59e0b" stroke="#d97706" strokeWidth="1.4" />
        {/* 배 */}
        <ellipse cx="33" cy="67" rx="10" ry="9" fill="#fef3c7" />

        {/* 머리 (크게 — 2등신) */}
        <circle cx="33" cy="30" r="26" fill="#fde68a" stroke="#d97706" strokeWidth="1.4" />

        {/* 귀 */}
        <ellipse cx="14" cy="11" rx="7" ry="10" fill="#f59e0b" stroke="#d97706" strokeWidth="1.2" />
        <ellipse cx="52" cy="11" rx="7" ry="10" fill="#f59e0b" stroke="#d97706" strokeWidth="1.2" />
        {/* 귀 안쪽 */}
        <ellipse cx="14" cy="12" rx="3.5" ry="5.5" fill="#fca5a5" />
        <ellipse cx="52" cy="12" rx="3.5" ry="5.5" fill="#fca5a5" />

        {/* 눈 */}
        <circle cx="24" cy="27" r="7" fill="#1e293b" />
        <circle cx="42" cy="27" r="7" fill="#1e293b" />
        {/* 눈 하이라이트 */}
        <circle cx="26.5" cy="24.5" r="2.2" fill="white" />
        <circle cx="44.5" cy="24.5" r="2.2" fill="white" />
        {/* 작은 하이라이트 */}
        <circle cx="25" cy="28" r="1" fill="white" opacity="0.6" />
        <circle cx="43" cy="28" r="1" fill="white" opacity="0.6" />

        {/* 코 */}
        <ellipse cx="33" cy="37" rx="3.5" ry="2.5" fill="#92400e" />

        {/* 볼 (귀여운 포인트) */}
        <ellipse cx="18" cy="34" rx="6" ry="4" fill="#fca5a5" opacity="0.45" />
        <ellipse cx="48" cy="34" rx="6" ry="4" fill="#fca5a5" opacity="0.45" />

        {/* 입 */}
        <path d="M28 42 Q33 47 38 42" fill="none" stroke="#92400e" strokeWidth="1.4" strokeLinecap="round" />

        {/* 작은 팔 */}
        <ellipse cx="19" cy="64" rx="6" ry="4" fill="#f59e0b" stroke="#d97706" strokeWidth="1" />
        <ellipse cx="47" cy="64" rx="6" ry="4" fill="#f59e0b" stroke="#d97706" strokeWidth="1" />

        {/* 넥타이 (FinTree 초록) */}
        <rect x="30" y="51" width="6" height="4" rx="1.5" fill="#047857" />
        <path d="M30 55 L33 70 L36 55 Z" fill="#059669" />
        <line x1="30.5" y1="58" x2="35.5" y2="58" stroke="#047857" strokeWidth="0.8" />
      </svg>

      {/* 레벨 뱃지 */}
      <div className="absolute -bottom-1 -right-1 w-7 h-7 rounded-full bg-amber-400 border-2 border-white text-[11px] font-bold text-white flex items-center justify-center shadow-md">
        {level}
      </div>
    </div>
  )
}

// ─────────────────── 장비 슬롯 ───────────────────
const SLOT_LABELS = ['투구', '갑옷', '장갑', '바지', '신발', '반지']

function EquipSlot({ node, label }: { node?: SkillNode; label: string }) {
  const color = node
    ? ({ BEGINNER: '#059669', INTERMEDIATE: '#2563eb', ADVANCED: '#7c3aed' } as Record<Difficulty, string>)[node.difficulty]
    : undefined
  return (
    <div className="flex flex-col items-center gap-1">
      <div
        className={`w-10 h-10 rounded-xl border-2 flex items-center justify-center text-xs font-bold transition-all
          ${node ? 'bg-white shadow-sm' : 'bg-slate-800/60 border-dashed border-slate-600 text-slate-600'}`}
        style={node ? { borderColor: color, color } : undefined}
        title={node?.title}
      >
        {node ? node.title.slice(0, 2) : '＋'}
      </div>
      <span className="text-[9px] text-slate-500">{label}</span>
    </div>
  )
}

// ─────────────────── 노드 컴포넌트 ───────────────────
function TreeNode({
  node, pos, color, onClick,
}: {
  node: SkillNode
  pos: { cx: number; cy: number }
  color: string
  onClick: () => void
}) {
  const clickable  = node.status !== 'LOCKED'
  const isLocked   = node.status === 'LOCKED'
  const isCompleted = node.status === 'COMPLETED'
  const isUnlocked  = node.status === 'UNLOCKED'

  const fillColor   = isLocked ? '#1e293b' : isCompleted ? color : '#0f172a'
  const strokeColor = isLocked ? '#475569' : color
  const strokeW     = isLocked ? 1.5 : 2.5
  const textColor   = isLocked ? '#64748b' : isCompleted ? '#ffffff' : color

  return (
    <g
      style={{ cursor: clickable ? 'pointer' : 'default' }}
      onClick={clickable ? onClick : undefined}
      className={clickable ? 'transition-all' : ''}
    >
      {/* glow 링 (UNLOCKED) */}
      {isUnlocked && (
        <circle
          cx={pos.cx} cy={pos.cy} r={NODE_R + 5}
          fill="none" stroke={color} strokeWidth="1.5" opacity="0.3"
        />
      )}
      {/* 노드 원 */}
      <circle
        cx={pos.cx} cy={pos.cy} r={NODE_R}
        fill={fillColor}
        stroke={strokeColor}
        strokeWidth={strokeW}
        filter={isUnlocked ? `url(#glow-${color.replace('#','')})` : undefined}
      />
      {/* 아이콘 */}
      <text
        x={pos.cx} y={pos.cy + 5}
        textAnchor="middle"
        fontSize="16"
        fill={textColor}
      >
        {isLocked ? '🔒' : isCompleted ? '✓' : '▶'}
      </text>

      {/* 노드 제목 */}
      <foreignObject
        x={pos.cx - NODE_SLOT_W / 2}
        y={pos.cy + NODE_R + 4}
        width={NODE_SLOT_W}
        height={TITLE_H}
      >
        <div
          style={{ fontFamily: 'inherit', textAlign: 'center' }}
          className="text-[10px] leading-tight font-semibold px-0.5"
        >
          <span style={{ color: isLocked ? '#475569' : '#e2e8f0' }}>
            {node.title}
          </span>
        </div>
      </foreignObject>
    </g>
  )
}

// ─────────────────── 메인 ───────────────────
export default function FinTreeHomeView() {
  const navigate    = useNavigate()
  const [nodes, setNodes]     = useState<SkillNode[]>([])
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    Promise.all([
      REPO.getTree(),
      ACCOUNT.getProfile().catch(() => null),
    ]).then(([n, p]) => { setNodes(n); setProfile(p) })
      .finally(() => setLoading(false))
  }, [])

  const { positions, canvasW, canvasH, depths } = useMemo(
    () => computeLayout(nodes), [nodes]
  )
  const branchMap = useMemo(
    () => computeBranchMap(nodes, depths), [nodes, depths]
  )

  const nodeColor = (node: SkillNode): string => {
    const bi = branchMap.get(node.id)
    if (bi !== null && bi !== undefined) return BRANCH_COLORS[bi % BRANCH_COLORS.length]
    const depth = depths.get(node.id) ?? 0
    if (depth >= 7) return MASTER_COLOR
    return COMMON_COLOR
  }

  const edges = useMemo(
    () => nodes.flatMap(n => n.prerequisiteIds.map(pid => ({ from: pid, to: n.id }))),
    [nodes]
  )

  if (loading) {
    return (
      <div className="flex items-center justify-center py-32">
        <div className="w-6 h-6 border-2 border-slate-700 border-t-emerald-400 rounded-full animate-spin" />
      </div>
    )
  }

  const completed = nodes.filter(n => n.status === 'COMPLETED')
  const unlocked  = nodes.filter(n => n.status === 'UNLOCKED')
  const level     = Math.min(99, completed.length * 2 + unlocked.length + 1)
  const progress  = nodes.length > 0 ? Math.round((completed.length / nodes.length) * 100) : 0
  const equipped  = [...completed].slice(0, 6)

  // SVG 필터 유니크 컬러 목록
  const uniqueColors = Array.from(new Set([...BRANCH_COLORS, MASTER_COLOR, COMMON_COLOR]))

  return (
    <div className="flex flex-col gap-5">

      {/* ── 비로그인 로그인 유도 배너 ── */}
      {profile === null && (
        <div className="bg-[#1e293b] rounded-2xl border border-slate-700 p-6 flex items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <span className="text-3xl">🔑</span>
            <div>
              <p className="text-slate-200 font-semibold text-sm">로그인하면 더 많은 기능을 이용할 수 있어요</p>
              <p className="text-slate-500 text-xs mt-0.5">학습 진행, 퀴즈 채점, 캐릭터 성장이 가능합니다</p>
            </div>
          </div>
          <button
            onClick={() => navigate('/login', { state: { from: '/fintree' } })}
            className="flex-shrink-0 text-sm bg-emerald-700 hover:bg-emerald-600 text-white px-5 py-2 rounded-lg transition-colors"
          >
            로그인
          </button>
        </div>
      )}

      {/* ── 캐릭터 & 장비창 패널 (로그인 시에만) ── */}
      {profile !== null && (
      <div className="bg-[#1e293b] rounded-2xl border border-slate-700 p-5">
        <div className="flex items-center gap-5 flex-wrap">

          {/* 캐릭터 + 장비 */}
          <div className="flex items-center gap-4">
            {/* 왼쪽 장비 3칸 */}
            <div className="flex flex-col gap-2.5">
              <EquipSlot node={equipped[0]} label={SLOT_LABELS[0]} />
              <EquipSlot node={equipped[1]} label={SLOT_LABELS[1]} />
              <EquipSlot node={equipped[2]} label={SLOT_LABELS[2]} />
            </div>

            {/* 캐릭터 */}
            <div className="flex flex-col items-center gap-0.5">
              <SquirrelSVG level={level} />
              <span className="text-xs text-slate-400 font-medium mt-1">
                {profile?.accountId ?? '모험가'}
              </span>
            </div>

            {/* 오른쪽 장비 3칸 */}
            <div className="flex flex-col gap-2.5">
              <EquipSlot node={equipped[3]} label={SLOT_LABELS[3]} />
              <EquipSlot node={equipped[4]} label={SLOT_LABELS[4]} />
              <EquipSlot node={equipped[5]} label={SLOT_LABELS[5]} />
            </div>
          </div>

          {/* 구분선 */}
          <div className="hidden sm:block w-px h-32 bg-slate-700" />

          {/* 스탯 */}
          <div className="flex flex-col gap-3 min-w-[150px]">
            <div>
              <p className="text-[10px] text-slate-500 mb-0.5">레벨</p>
              <p className="text-2xl font-bold text-amber-400">Lv. {level}</p>
            </div>
            <div>
              <p className="text-[10px] text-slate-500 mb-1">완료 노드</p>
              <p className="text-sm font-semibold text-slate-200">
                {completed.length}
                <span className="text-slate-500 font-normal"> / {nodes.length}</span>
              </p>
            </div>
            <div>
              <div className="flex justify-between text-[10px] mb-1">
                <span className="text-slate-500">진행률</span>
                <span className="font-semibold text-emerald-400">{progress}%</span>
              </div>
              <div className="w-full h-1.5 bg-slate-700 rounded-full overflow-hidden">
                <div
                  className="h-full rounded-full transition-all duration-500"
                  style={{
                    width: `${progress}%`,
                    background: 'linear-gradient(to right, #34d399, #059669)',
                  }}
                />
              </div>
            </div>
            <div className="flex items-center gap-1.5">
              <span className="w-2 h-2 rounded-full bg-blue-400 inline-block animate-pulse" />
              <span className="text-[10px] text-slate-400">{unlocked.length}개 학습 가능</span>
            </div>
          </div>

          {/* 범례 */}
          <div className="ml-auto flex flex-col gap-2">
            <p className="text-[10px] text-slate-500 font-semibold mb-0.5">범례</p>
            {([
              { s: 'LOCKED',    c: '#475569', label: '잠금' },
              { s: 'UNLOCKED',  c: '#3b82f6', label: '학습 가능' },
              { s: 'COMPLETED', c: '#10b981', label: '완료' },
            ] as const).map(({ c, label }) => (
              <div key={label} className="flex items-center gap-2 text-[10px] text-slate-400">
                <svg width="14" height="14">
                  <circle cx="7" cy="7" r="6" fill={c} opacity={0.8} />
                </svg>
                {label}
              </div>
            ))}
          </div>
        </div>
      </div>
      )}

      {/* ── 스킬 트리 캔버스 ── */}
      <div className="bg-[#0f172a] rounded-2xl border border-slate-800 overflow-x-auto p-4">
        <p className="text-[10px] text-slate-600 font-semibold mb-3 ml-1 tracking-widest uppercase">
          🌳 Skill Tree
        </p>

        {nodes.length === 0 ? (
          <div className="text-center py-24 text-slate-600">
            <p className="text-4xl mb-3">🌱</p>
            <p className="text-sm">등록된 학습 내용이 없습니다.</p>
          </div>
        ) : (
          <svg
            width={canvasW}
            height={canvasH}
            style={{ display: 'block', margin: '0 auto' }}
          >
            <defs>
              {/* glow 필터 — 각 색상별 */}
              {uniqueColors.map(c => (
                <filter key={c} id={`glow-${c.replace('#', '')}`} x="-50%" y="-50%" width="200%" height="200%">
                  <feGaussianBlur stdDeviation="4" result="blur" />
                  <feFlood floodColor={c} floodOpacity="0.6" result="color" />
                  <feComposite in="color" in2="blur" operator="in" result="glow" />
                  <feMerge>
                    <feMergeNode in="glow" />
                    <feMergeNode in="SourceGraphic" />
                  </feMerge>
                </filter>
              ))}
            </defs>

            {/* 연결선 */}
            {edges.map(({ from, to }) => {
              const p = positions.get(from)
              const c = positions.get(to)
              if (!p || !c) return null
              const toNode = nodes.find(n => n.id === to)
              const fromNode = nodes.find(n => n.id === from)
              const bothDone = toNode?.status === 'COMPLETED' && fromNode?.status === 'COMPLETED'
              const color = nodeColor(toNode ?? nodes[0])
              const x1 = p.cx, y1 = p.cy + NODE_R
              const x2 = c.cx, y2 = c.cy - NODE_R
              const my = (y1 + y2) / 2
              return (
                <path
                  key={`${from}-${to}`}
                  d={`M${x1},${y1} C${x1},${my} ${x2},${my} ${x2},${y2}`}
                  fill="none"
                  stroke={bothDone ? color : '#334155'}
                  strokeWidth={bothDone ? 2 : 1.5}
                  strokeDasharray={bothDone ? undefined : '5,4'}
                  opacity={bothDone ? 0.75 : 0.45}
                />
              )
            })}

            {/* 노드 */}
            {nodes.map(node => {
              const pos = positions.get(node.id)
              if (!pos) return null
              return (
                <TreeNode
                  key={node.id}
                  node={node}
                  pos={pos}
                  color={nodeColor(node)}
                  onClick={() => navigate(`/fintree/nodes/${node.id}`)}
                />
              )
            })}
          </svg>
        )}
      </div>
    </div>
  )
}
