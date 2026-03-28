import React, { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { container } from 'tsyringe'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import type SkillNodeDetail from '@/entity/fintree/SkillNodeDetail'
import type { Quiz } from '@/entity/fintree/SkillNodeDetail'
import type UserProfile from '@/entity/user/UserProfile'
import SkillTreeRepository from '@/repository/SkillTreeRepository'
import AccountRepository from '@/repository/AccountRepository'

const REPOSITORY = container.resolve(SkillTreeRepository)
const ACCOUNT    = container.resolve(AccountRepository)

const DIFFICULTY_LABEL: Record<string, string> = {
  BEGINNER: '입문', INTERMEDIATE: '중급', ADVANCED: '심화',
}
const DIFFICULTY_COLOR: Record<string, string> = {
  BEGINNER: 'bg-emerald-50 text-emerald-600',
  INTERMEDIATE: 'bg-blue-50 text-blue-600',
  ADVANCED: 'bg-purple-50 text-purple-600',
}

export default function FinTreeNodeView() {
  const { nodeId } = useParams<{ nodeId: string }>()
  const [profile, setProfile] = useState<UserProfile | null | undefined>(undefined)
  const navigate   = useNavigate()
  const [node, setNode]       = useState<SkillNodeDetail | null>(null)
  const [loading, setLoading] = useState(true)

  // 퀴즈 상태: quizId → 선택한 optionId
  const [answers, setAnswers]     = useState<Record<number, number>>({})
  const [submitted, setSubmitted] = useState(false)
  const [result, setResult]       = useState<any>(null)
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    ACCOUNT.getProfile()
      .then(p => setProfile(p))
      .catch(() => setProfile(null))
  }, [])

  useEffect(() => {
    if (!nodeId) return
    setLoading(true)
    setSubmitted(false)
    setAnswers({})
    setResult(null)
    REPOSITORY.getNode(Number(nodeId))
      .then(setNode)
      .finally(() => setLoading(false))
  }, [nodeId])

  function handleSelect(quizId: number, optionId: number) {
    if (submitted) return
    setAnswers(prev => ({ ...prev, [quizId]: optionId }))
  }

  function handleSubmit() {
    if (!nodeId) return
    const allAnswered = node?.quizzes.every(q => answers[q.id] !== undefined)
    if (!allAnswered) { alert('모든 문제에 답해주세요.'); return }
    setSubmitting(true)
    REPOSITORY.submitQuiz(Number(nodeId), answers)
      .then(res => { setResult(res); setSubmitted(true) })
      .catch(() => alert('제출 중 오류가 발생했습니다.'))
      .finally(() => setSubmitting(false))
  }

  // 로그인 상태 확인 중
  if (profile === undefined) {
    return (
      <div className="flex items-center justify-center py-32">
        <div className="w-5 h-5 border-2 border-slate-200 border-t-emerald-500 rounded-full animate-spin" />
      </div>
    )
  }

  // 비로그인 → 로그인 유도
  if (profile === null) {
    return (
      <div className="max-w-3xl mx-auto">
        <button
          onClick={() => navigate('/fintree')}
          className="flex items-center gap-1 text-sm text-slate-400 hover:text-slate-700 mb-8 transition-colors"
        >
          ← 스킬 트리로
        </button>
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm p-16 text-center">
          <p className="text-5xl mb-5">🔑</p>
          <h2 className="text-xl font-bold text-slate-800 mb-2">로그인이 필요합니다</h2>
          <p className="text-sm text-slate-400 mb-8">
            학습 내용을 보고 퀴즈를 풀려면 로그인해주세요.
          </p>
          <div className="flex items-center justify-center gap-3">
            <button
              onClick={() => navigate('/login', { state: { from: `/fintree/nodes/${nodeId}` } })}
              className="text-sm bg-emerald-700 text-white px-6 py-2.5 rounded-lg hover:bg-emerald-600 transition-colors"
            >
              로그인
            </button>
            <button
              onClick={() => navigate('/login', { state: { from: `/fintree/nodes/${nodeId}`, tab: 'signup' } })}
              className="text-sm border border-slate-200 text-slate-600 px-6 py-2.5 rounded-lg hover:bg-slate-50 transition-colors"
            >
              회원가입
            </button>
          </div>
        </div>
      </div>
    )
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center py-32">
        <div className="w-5 h-5 border-2 border-slate-200 border-t-emerald-500 rounded-full animate-spin" />
      </div>
    )
  }

  if (!node) {
    return <div className="text-center py-32 text-slate-400 text-sm">노드를 찾을 수 없습니다.</div>
  }

  const isLocked    = node.status === 'LOCKED'
  const isCompleted = node.status === 'COMPLETED'

  return (
    <div className="max-w-3xl mx-auto">
      {/* 뒤로 */}
      <button
        onClick={() => navigate('/fintree')}
        className="flex items-center gap-1 text-sm text-slate-400 hover:text-slate-700 mb-8 transition-colors"
      >
        ← 스킬 트리로
      </button>

      {/* 노드 헤더 */}
      <div className="bg-white rounded-2xl border border-slate-100 shadow-sm p-8 mb-6">
        <div className="flex items-center gap-3 mb-4">
          <span className={`text-xs font-bold px-2 py-0.5 rounded ${DIFFICULTY_COLOR[node.difficulty]}`}>
            {DIFFICULTY_LABEL[node.difficulty]}
          </span>
          <span className="text-xs text-slate-400">⏱ {node.estimatedMinutes}분</span>
          {isCompleted && (
            <span className="text-xs font-semibold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full">
              ✅ 완료
            </span>
          )}
        </div>
        <h1 className="text-2xl font-bold text-slate-800 tracking-tight">{node.title}</h1>
      </div>

      {/* 잠금 상태 */}
      {isLocked ? (
        <div className="bg-slate-50 rounded-2xl border border-slate-200 p-12 text-center">
          <p className="text-4xl mb-4">🔒</p>
          <p className="text-slate-500 font-medium mb-2">선수 학습이 필요합니다</p>
          <p className="text-sm text-slate-400">이전 단계를 먼저 완료해주세요.</p>
          <button
            onClick={() => navigate('/fintree')}
            className="mt-6 text-xs text-emerald-600 hover:text-emerald-700 underline"
          >
            스킬 트리 보기
          </button>
        </div>
      ) : (
        <>
          {/* 학습 컨텐츠 */}
          {node.content && (
            <article className="bg-white rounded-2xl border border-slate-100 shadow-sm p-8 mb-6">
              <div className="prose max-w-none">
                <ReactMarkdown remarkPlugins={[remarkGfm]}>
                  {node.content}
                </ReactMarkdown>
              </div>
            </article>
          )}

          {/* 퀴즈 */}
          {node.quizzes.length > 0 && (
            <div className="bg-white rounded-2xl border border-slate-100 shadow-sm p-8">
              <h2 className="text-lg font-bold text-slate-800 mb-6">
                이해도 확인
                <span className="ml-2 text-sm font-normal text-slate-400">
                  {node.quizzes.length}문제
                </span>
              </h2>

              <div className="flex flex-col gap-8">
                {node.quizzes.map((quiz: Quiz, qi: number) => {
                  const isCorrect = submitted && result?.results?.[quiz.id] === true
                  const isWrong   = submitted && result?.results?.[quiz.id] === false
                  return (
                    <div key={quiz.id}>
                      <p className="text-sm font-semibold text-slate-700 mb-3">
                        <span className="text-slate-400 mr-1.5">Q{qi + 1}.</span>
                        {quiz.question}
                      </p>
                      <div className="flex flex-col gap-2">
                        {quiz.options.map(opt => {
                          const selected = answers[quiz.id] === opt.id
                          let optStyle = 'border-slate-200 bg-slate-50 text-slate-600'
                          if (selected && !submitted) optStyle = 'border-blue-400 bg-blue-50 text-blue-700 font-medium'
                          if (selected && isCorrect)  optStyle = 'border-emerald-400 bg-emerald-50 text-emerald-700 font-medium'
                          if (selected && isWrong)    optStyle = 'border-red-400 bg-red-50 text-red-700 font-medium'
                          return (
                            <label
                              key={opt.id}
                              className={`flex items-center gap-3 px-4 py-2.5 rounded-xl border text-sm transition-all ${optStyle} ${!submitted ? 'cursor-pointer hover:border-blue-300' : 'cursor-default'}`}
                            >
                              <input
                                type="radio"
                                name={`quiz-${quiz.id}`}
                                checked={selected}
                                onChange={() => handleSelect(quiz.id, opt.id)}
                                disabled={submitted}
                                className="accent-emerald-500"
                              />
                              {opt.text}
                            </label>
                          )
                        })}
                      </div>
                      {submitted && (
                        <p className={`mt-2 text-xs font-medium ${isCorrect ? 'text-emerald-600' : 'text-red-500'}`}>
                          {isCorrect ? '✓ 정답' : '✗ 오답'}
                        </p>
                      )}
                    </div>
                  )
                })}
              </div>

              {/* 결과 / 제출 */}
              {submitted ? (
                <div className={`mt-8 rounded-xl p-5 text-center ${result?.passed ? 'bg-emerald-50 border border-emerald-200' : 'bg-red-50 border border-red-200'}`}>
                  {result?.passed ? (
                    <>
                      <p className="text-2xl mb-2">🎉</p>
                      <p className="font-bold text-emerald-700">
                        통과! {result.correctCount}/{result.totalCount} 정답
                      </p>
                      {result.nodeCompleted && (
                        <p className="text-sm text-emerald-600 mt-1">이 노드가 완료되었습니다. 다음 노드가 해금되었습니다!</p>
                      )}
                      <button
                        onClick={() => navigate('/fintree')}
                        className="mt-4 text-sm bg-emerald-700 text-white px-5 py-2 rounded-lg hover:bg-emerald-600 transition-colors"
                      >
                        스킬 트리로 돌아가기
                      </button>
                    </>
                  ) : (
                    <>
                      <p className="text-2xl mb-2">😅</p>
                      <p className="font-bold text-red-600">
                        {result.correctCount}/{result.totalCount} 정답 — 다시 도전해보세요
                      </p>
                      <button
                        onClick={() => { setSubmitted(false); setAnswers({}) }}
                        className="mt-4 text-sm bg-slate-700 text-white px-5 py-2 rounded-lg hover:bg-slate-600 transition-colors"
                      >
                        다시 풀기
                      </button>
                    </>
                  )}
                </div>
              ) : (
                <button
                  onClick={handleSubmit}
                  disabled={submitting || Object.keys(answers).length < node.quizzes.length}
                  className="mt-8 w-full py-3 rounded-xl bg-emerald-700 text-white text-sm font-medium hover:bg-emerald-600 transition-colors disabled:opacity-40"
                >
                  {submitting ? '채점 중...' : '제출하기'}
                </button>
              )}
            </div>
          )}

          {/* 퀴즈 없는 경우 완료 안내 */}
          {node.quizzes.length === 0 && !isCompleted && (
            <div className="text-center py-6 text-sm text-slate-400">
              이 노드에는 퀴즈가 없습니다.
            </div>
          )}
        </>
      )}
    </div>
  )
}
