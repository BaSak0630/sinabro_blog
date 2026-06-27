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

export interface FlowSession {
  id: number
  userBookId: number
  startTime: string
  endTime?: string
  totalSeconds?: number
  videoUrl?: string
  bookmarkPage?: number
  memo?: string
}

export interface BookNote {
  id: number
  userBookId: number
  title: string
  content: string
  updatedAt: string
}

export interface BookMemo {
  id: number
  userBookId: number
  content: string
  pageNumber?: number
  createdAt: string
}

export interface Notice {
  id: number
  title: string
  content: string
  createdAt: string
}

export interface UserProfile {
  id: number
  accountId: string
  role: string
}
