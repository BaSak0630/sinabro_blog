import { api } from './api'
import type { FlowSession } from '@/types'

export async function startSession(userBookId: number, videoUrl?: string): Promise<FlowSession> {
  const { data } = await api.post('/dokhu/sessions/start', { userBookId, videoUrl })
  return data
}

export async function endSession(sessionId: number, memo?: string, bookmarkPage?: number): Promise<FlowSession> {
  const { data } = await api.post(`/dokhu/sessions/${sessionId}/end`, { memo, bookmarkPage })
  return data
}

export async function getSessionHistory(userBookId: number): Promise<FlowSession[]> {
  const { data } = await api.get(`/dokhu/sessions/history/${userBookId}`)
  return data
}
