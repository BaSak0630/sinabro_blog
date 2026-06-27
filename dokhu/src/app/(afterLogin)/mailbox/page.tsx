'use client'
import { useQuery } from '@tanstack/react-query'
import { getNotices } from '@/services/user.api'
import PageContainer from '@/components/PageContainer'
import { Card, CardContent } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { Bell } from 'lucide-react'

export default function MailboxPage() {
  const { data: notices = [], isLoading } = useQuery({
    queryKey: ['notices'],
    queryFn: getNotices,
  })

  return (
    <PageContainer className="space-y-5">
      <div>
        <h1 className="text-2xl font-bold text-foreground">공지사항</h1>
        <p className="text-sm text-muted-foreground mt-0.5">총 {notices.length}개</p>
      </div>

      {isLoading ? (
        <div className="space-y-3">
          {[1, 2, 3].map(i => <Skeleton key={i} className="h-24" />)}
        </div>
      ) : notices.length === 0 ? (
        <div className="flex flex-col items-center py-24 gap-3">
          <Bell className="w-10 h-10 text-muted-foreground/30" />
          <p className="text-sm text-muted-foreground">공지사항이 없어요</p>
        </div>
      ) : (
        <div className="space-y-3">
          {notices.map(n => (
            <Card key={n.id}>
              <CardContent className="pt-5">
                <div className="flex items-start gap-3">
                  <Bell className="w-4 h-4 text-highlight mt-0.5 shrink-0" />
                  <div>
                    <p className="font-semibold text-foreground">{n.title}</p>
                    <p className="text-sm text-muted-foreground mt-1 leading-relaxed">{n.content}</p>
                    <p className="text-[10px] text-muted-foreground/60 mt-2">
                      {new Date(n.createdAt).toLocaleDateString('ko')}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </PageContainer>
  )
}
