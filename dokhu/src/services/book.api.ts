import { api } from './api'
import type { Book } from '@/types'

export async function getBooks(keyword?: string, genre?: string, size = 60): Promise<Book[]> {
  const params: Record<string, string | number> = { size }
  if (keyword) params.keyword = keyword
  if (genre) params.genre = genre
  const { data } = await api.get('/dokhu/books', { params })
  return data
}

export async function getBook(bookId: number): Promise<Book> {
  const { data } = await api.get(`/dokhu/books/${bookId}`)
  return data
}

export async function getGenres(): Promise<string[]> {
  const { data } = await api.get('/dokhu/books/genres')
  return data
}
