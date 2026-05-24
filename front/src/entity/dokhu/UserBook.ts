export type ReadingStatus = 'ADDING' | 'READING' | 'COMPLETED'

export interface Book {
  id: number
  title: string
  author: string
  isbn?: string
  coverImageUrl?: string
  publisher?: string
  genre?: string
  totalPages?: number
  publishDate?: string
  synopsis?: string
}

export interface UserBook {
  id: number
  book: Book
  status: ReadingStatus
  currentPage: number
  progressPercent: number
  starRating: number
  registeredAt: string
  updatedAt: string
}
