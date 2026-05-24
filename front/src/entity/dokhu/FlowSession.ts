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
