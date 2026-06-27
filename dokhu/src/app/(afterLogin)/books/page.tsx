'use client'
import { useRef, useState } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import { useRouter } from 'next/navigation'
import { getBooks, getGenres } from '@/services/book.api'
import { addBookToLibrary } from '@/services/library.api'
import PageContainer from '@/components/PageContainer'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { spineColor } from '@/lib/utils'
import { Search, BookMarked, X, Check } from 'lucide-react'
import type { Book } from '@/types'

function BookDetailSheet({
  book, onClose, onAdd, adding, added,
}: {
  book: Book; onClose: () => void
  onAdd: (id: number) => void; adding: boolean; added: boolean
}) {
  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-black/70" onClick={onClose}>
      <div
        className="w-full max-w-2xl rounded-t-3xl overflow-hidden shadow-2xl bg-card max-h-[88vh] overflow-y-auto"
        onClick={e => e.stopPropagation()}
      >
        <div className="flex justify-center pt-3 pb-1">
          <div className="w-10 h-1 rounded-full bg-border" />
        </div>
        <div className="flex gap-5 px-6 pt-4 pb-5">
          <div
            className="shrink-0 rounded-xl overflow-hidden shadow-xl"
            style={{ width: 100, height: 148, background: book.coverImageUrl ? undefined : spineColor(book.id) }}
          >
            {book.coverImageUrl ? (
              <img src={book.coverImageUrl} alt={book.title} className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center p-2">
                <span className="text-white/50 text-[9px] text-center font-medium leading-tight">{book.title}</span>
              </div>
            )}
          </div>
          <div className="flex-1 min-w-0">
            {book.genre && (
              <span className="text-[10px] px-2 py-0.5 rounded-full border border-border text-muted-foreground inline-block mb-2">
                {book.genre}
              </span>
            )}
            <h2 className="text-lg font-bold leading-tight mb-1 text-foreground">{book.title}</h2>
            <p className="text-sm mb-3 text-muted-foreground">{book.author}</p>
            <div className="grid grid-cols-2 gap-1.5 text-[10px]">
              {[
                { label: '출판사', value: book.publisher },
                { label: '발행일', value: book.publishDate },
                { label: '페이지', value: book.totalPages ? `${book.totalPages}p` : null },
                { label: 'ISBN', value: book.isbn },
              ].filter(i => i.value).map(item => (
                <div key={item.label} className="rounded-lg px-2 py-1.5 bg-muted/50 border border-border">
                  <p className="text-muted-foreground">{item.label}</p>
                  <p className="truncate mt-0.5 font-medium text-foreground">{item.value}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
        {book.synopsis && (
          <div className="px-6 pb-5">
            <p className="text-[10px] font-semibold mb-2 text-muted-foreground">책 소개</p>
            <p className="text-xs leading-relaxed text-muted-foreground">{book.synopsis}</p>
          </div>
        )}
        <div className="px-6 pb-8 flex gap-2">
          <Button
            className="flex-1"
            variant={added ? 'secondary' : 'highlight'}
            onClick={() => onAdd(book.id)}
            disabled={adding || added}
          >
            {added ? <><Check className="w-4 h-4" />서재에 추가됨</> :
             adding ? <div className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" /> :
             <><BookMarked className="w-4 h-4" />내 서재에 추가</>}
          </Button>
          <Button variant="outline" onClick={onClose}><X className="w-4 h-4" /></Button>
        </div>
      </div>
    </div>
  )
}

export default function BooksPage() {
  const router = useRouter()
  const [keyword, setKeyword] = useState('')
  const [selectedGenre, setSelectedGenre] = useState('')
  const [selected, setSelected] = useState<Book | null>(null)
  const [addedIds, setAddedIds] = useState<Set<number>>(new Set())
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  const { data: genres = [] } = useQuery({ queryKey: ['genres'], queryFn: getGenres })

  const { data: books = [], isLoading, refetch } = useQuery({
    queryKey: ['books', keyword, selectedGenre],
    queryFn: () => getBooks(keyword || undefined, selectedGenre || undefined),
  })

  const addMutation = useMutation({
    mutationFn: (bookId: number) => addBookToLibrary(bookId),
    onSuccess: (_, bookId) => setAddedIds(prev => new Set([...prev, bookId])),
    onError: (err: any) => {
      if (err.response?.status === 401) router.push('/login')
      else alert('서재 추가에 실패했습니다.')
    },
  })

  function handleKeyword(val: string) {
    setKeyword(val)
    if (debounceRef.current) clearTimeout(debounceRef.current)
    debounceRef.current = setTimeout(() => refetch(), 400)
  }

  return (
    <PageContainer className="space-y-5">
      {selected && (
        <BookDetailSheet
          book={selected}
          onClose={() => setSelected(null)}
          onAdd={id => addMutation.mutate(id)}
          adding={addMutation.isPending}
          added={addedIds.has(selected.id)}
        />
      )}

      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">책 탐색</h1>
          <p className="text-sm text-muted-foreground mt-0.5">총 {books.length}권</p>
        </div>
        <Button variant="outline" size="sm" onClick={() => router.push('/library')}>
          <BookMarked className="w-4 h-4" />
          내 서재
        </Button>
      </div>

      {/* 검색 */}
      <div className="flex gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground pointer-events-none" />
          <input
            className="w-full rounded-xl pl-9 pr-4 py-2.5 text-sm outline-none border border-border bg-card focus:border-highlight transition-colors text-foreground"
            placeholder="제목, 저자로 검색..."
            value={keyword}
            onChange={e => handleKeyword(e.target.value)}
            onKeyDown={e => { if (e.key === 'Enter') refetch() }}
          />
        </div>
        <Button variant="highlight" onClick={() => refetch()}>검색</Button>
      </div>

      {/* 장르 필터 */}
      <div className="flex gap-1.5 overflow-x-auto pb-0.5 no-scrollbar">
        {['', ...genres].map(g => (
          <button
            key={g || 'all'}
            onClick={() => setSelectedGenre(g)}
            className={`shrink-0 px-3 py-1 rounded-full text-xs font-medium transition-colors ${
              selectedGenre === g
                ? 'bg-highlight text-highlight-foreground'
                : 'bg-secondary text-muted-foreground hover:text-foreground'
            }`}
          >
            {g || '전체'}
          </button>
        ))}
      </div>

      {/* 그리드 */}
      {isLoading ? (
        <div className="grid gap-4" style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(110px, 1fr))' }}>
          {Array.from({ length: 12 }).map((_, i) => <Skeleton key={i} className="aspect-[2/3] rounded-xl" />)}
        </div>
      ) : books.length === 0 ? (
        <div className="flex flex-col items-center py-24 gap-3">
          <Search className="w-10 h-10 text-muted-foreground/30" />
          <p className="text-sm text-muted-foreground">검색 결과가 없어요</p>
        </div>
      ) : (
        <div className="grid gap-4" style={{ gridTemplateColumns: 'repeat(auto-fill, minmax(110px, 1fr))' }}>
          {books.map(book => {
            const isAdded = addedIds.has(book.id)
            return (
              <div key={book.id} className="cursor-pointer group" onClick={() => setSelected(book)}>
                <div
                  className="relative rounded-xl overflow-hidden mb-2 shadow-md group-hover:shadow-xl transition-shadow"
                  style={{ aspectRatio: '2/3', background: spineColor(book.id) }}
                >
                  {book.coverImageUrl ? (
                    <img
                      src={book.coverImageUrl}
                      alt={book.title}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                  ) : (
                    <div className="w-full h-full flex items-end p-2">
                      <span className="text-white/60 text-[9px] font-medium leading-tight line-clamp-3">{book.title}</span>
                    </div>
                  )}
                  {book.genre && (
                    <div className="absolute top-1.5 left-1.5 px-1.5 py-0.5 rounded text-[8px] font-semibold bg-black/60 text-white/85">
                      {book.genre}
                    </div>
                  )}
                  {isAdded && (
                    <div className="absolute top-1.5 right-1.5 w-5 h-5 rounded-full bg-green-500 flex items-center justify-center shadow">
                      <Check className="w-3 h-3 text-white" />
                    </div>
                  )}
                </div>
                <p className="text-[11px] font-semibold leading-tight truncate text-foreground">{book.title}</p>
                <p className="text-[10px] truncate mt-0.5 text-muted-foreground">{book.author}</p>
              </div>
            )
          })}
        </div>
      )}
    </PageContainer>
  )
}
