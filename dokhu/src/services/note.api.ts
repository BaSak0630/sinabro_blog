import { api } from './api'
import type { BookNote, BookMemo } from '@/types'

export async function getNote(userBookId: number): Promise<BookNote | null> {
  try {
    const { data } = await api.get(`/dokhu/notes/${userBookId}`)
    return data
  } catch {
    return null
  }
}

export async function saveNote(userBookId: number, title: string, content: string): Promise<BookNote> {
  const { data } = await api.post('/dokhu/notes', { userBookId, title, content })
  return data
}

export async function getMemos(userBookId: number): Promise<BookMemo[]> {
  const { data } = await api.get(`/dokhu/memos/${userBookId}`)
  return data
}

export async function addMemo(userBookId: number, content: string, pageNumber?: number): Promise<BookMemo> {
  const { data } = await api.post('/dokhu/memos', { userBookId, content, pageNumber })
  return data
}
