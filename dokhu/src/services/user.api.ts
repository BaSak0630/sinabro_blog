import { api } from './api'
import type { UserProfile, Notice } from '@/types'

export async function getMe(): Promise<UserProfile> {
  const { data } = await api.get('/users/me')
  return data
}

export async function getNotices(): Promise<Notice[]> {
  const { data } = await api.get('/dokhu/notices')
  return data
}

export async function logout(): Promise<void> {
  await api.post('/logout')
}
