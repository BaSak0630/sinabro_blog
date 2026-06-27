import { api } from './api'
import type { UserBook } from '@/types'

export async function getLibrary(status?: string): Promise<UserBook[]> {
  const { data } = await api.get('/dokhu/library', { params: status ? { status } : undefined })
  return data
}

export async function getUserBook(userBookId: number): Promise<UserBook> {
  const { data } = await api.get(`/dokhu/library/${userBookId}`)
  return data
}

export async function updateProgress(userBookId: number, currentPage: number): Promise<UserBook> {
  const { data } = await api.patch(`/dokhu/library/${userBookId}/progress`, { currentPage })
  return data
}

export async function updateRating(userBookId: number, starRating: number): Promise<UserBook> {
  const { data } = await api.patch(`/dokhu/library/${userBookId}/rating`, { starRating })
  return data
}

export async function deleteUserBook(userBookId: number): Promise<void> {
  await api.delete(`/dokhu/library/${userBookId}`)
}

export async function addBookToLibrary(bookId: number): Promise<UserBook> {
  const { data } = await api.post(`/dokhu/library/from/${bookId}`)
  return data
}

export async function registerBook(book: {
  title: string; author: string; isbn?: string; coverImageUrl?: string
  publisher?: string; genre?: string; totalPages?: number; publishDate?: string; synopsis?: string
}): Promise<UserBook> {
  const { data } = await api.post('/dokhu/library', book)
  return data
}
