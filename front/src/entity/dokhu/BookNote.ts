export interface BookNote {
  id: number
  userBookId: number
  title: string
  content: string
  createdAt: string
  updatedAt: string
}

export interface BookMemo {
  id: number
  userBookId: number
  content: string
  pageNumber?: number
  createdAt: string
}
