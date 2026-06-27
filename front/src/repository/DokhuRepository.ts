import { inject, singleton } from 'tsyringe'
import AxiosHttpClient from '@/http/AxiosHttpClient'
import type { Book, UserBook } from '@/entity/dokhu/UserBook'
import type { FlowSession } from '@/entity/dokhu/FlowSession'
import type { BookNote, BookMemo } from '@/entity/dokhu/BookNote'

@singleton()
export default class DokhuRepository {
  constructor(@inject(AxiosHttpClient) private readonly client: AxiosHttpClient) {}

  // Books (catalog)
  getBooks(keyword?: string, genre?: string): Promise<Book[]> {
    const params: Record<string, string> = {}
    if (keyword) params.keyword = keyword
    if (genre) params.genre = genre
    return this.client.request({ method: 'GET', path: '/api/dokhu/books', params })
  }

  getBook(bookId: number): Promise<Book> {
    return this.client.request({ method: 'GET', path: `/api/dokhu/books/${bookId}` })
  }

  getGenres(): Promise<string[]> {
    return this.client.request({ method: 'GET', path: '/api/dokhu/books/genres' })
  }

  addExistingBookToLibrary(bookId: number): Promise<UserBook> {
    return this.client.request({ method: 'POST', path: `/api/dokhu/library/from/${bookId}` })
  }

  // Library
  getLibrary(status?: string): Promise<UserBook[]> {
    return this.client.request({ method: 'GET', path: '/api/dokhu/library', params: status ? { status } : undefined })
  }

  getUserBook(userBookId: number): Promise<UserBook> {
    return this.client.request({ method: 'GET', path: `/api/dokhu/library/${userBookId}` })
  }

  registerBook(data: {
    title: string; author: string; isbn?: string; coverImageUrl?: string
    publisher?: string; genre?: string; totalPages?: number; publishDate?: string; synopsis?: string
  }): Promise<UserBook> {
    return this.client.request({ method: 'POST', path: '/api/dokhu/library', body: data })
  }

  updateProgress(userBookId: number, currentPage: number): Promise<UserBook> {
    return this.client.request({ method: 'PATCH', path: `/api/dokhu/library/${userBookId}/progress`, body: { currentPage } })
  }

  updateRating(userBookId: number, starRating: number): Promise<UserBook> {
    return this.client.request({ method: 'PATCH', path: `/api/dokhu/library/${userBookId}/rating`, body: { starRating } })
  }

  deleteUserBook(userBookId: number): Promise<void> {
    return this.client.request({ method: 'DELETE', path: `/api/dokhu/library/${userBookId}` })
  }

  // Flow Session
  startSession(userBookId: number, videoUrl?: string): Promise<FlowSession> {
    return this.client.request({ method: 'POST', path: '/api/dokhu/sessions/start', body: { userBookId, videoUrl } })
  }

  endSession(sessionId: number, memo?: string, bookmarkPage?: number): Promise<FlowSession> {
    return this.client.request({ method: 'POST', path: `/api/dokhu/sessions/${sessionId}/end`, body: { memo, bookmarkPage } })
  }

  getSessionHistory(userBookId: number): Promise<FlowSession[]> {
    return this.client.request({ method: 'GET', path: `/api/dokhu/sessions/history/${userBookId}` })
  }

  // Notes & Memos
  getNote(userBookId: number): Promise<BookNote | null> {
    return this.client.request({ method: 'GET', path: `/api/dokhu/notes/${userBookId}` })
  }

  saveNote(userBookId: number, title: string, content: string): Promise<BookNote> {
    return this.client.request({ method: 'POST', path: '/api/dokhu/notes', body: { userBookId, title, content } })
  }

  getMemos(userBookId: number): Promise<BookMemo[]> {
    return this.client.request({ method: 'GET', path: `/api/dokhu/memos/${userBookId}` })
  }

  addMemo(userBookId: number, content: string, pageNumber?: number): Promise<BookMemo> {
    return this.client.request({ method: 'POST', path: '/api/dokhu/memos', body: { userBookId, content, pageNumber } })
  }

  // Notices
  getNotices(): Promise<{ id: number; title: string; content: string; createdAt: string }[]> {
    return this.client.request({ method: 'GET', path: '/api/dokhu/notices' })
  }
}
