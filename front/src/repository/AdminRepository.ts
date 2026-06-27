import AdminStats from '@/entity/admin/AdminStats'
import AdminUser from '@/entity/admin/AdminUser'
import Post from '@/entity/post/Post'
import type { Book } from '@/entity/dokhu/UserBook'
import HttpRepository from '@/repository/HttpRepository'
import AxiosHttpClient from '@/http/AxiosHttpClient'
import { inject, singleton } from 'tsyringe'

interface AdminPage<T> { page: number; size: number; totalCount: number; items: T[] }
interface BookForm {
  title: string; author: string; isbn?: string; coverImageUrl?: string
  publisher?: string; genre?: string; totalPages?: number; publishDate?: string; synopsis?: string
}

@singleton()
export default class AdminRepository {
  constructor(
    @inject(HttpRepository) private readonly httpRepository: HttpRepository,
    @inject(AxiosHttpClient) private readonly client: AxiosHttpClient,
  ) {}

  public getStats() {
    return this.httpRepository.get<AdminStats>({ path: '/api/admin/stats' }, AdminStats)
  }

  public getUsers(page: number, size = 10) {
    return this.httpRepository.getList<AdminUser>(
      { path: `/api/admin/users?page=${page}&size=${size}` },
      AdminUser
    )
  }

  public updateUserRole(id: number, role: string) {
    return this.httpRepository.patch({
      path: `/api/admin/users/${id}/role`,
      body: { role }
    })
  }

  public getPosts(page: number, size = 10) {
    return this.httpRepository.getList<Post>(
      { path: `/api/admin/posts?page=${page}&size=${size}` },
      Post
    )
  }

  public deletePost(id: number) {
    return this.httpRepository.delete({ path: `/api/admin/posts/${id}` })
  }

  public getBooks(page = 1, size = 20, keyword?: string): Promise<AdminPage<Book>> {
    const params: Record<string, string | number> = { page, size }
    if (keyword) params.keyword = keyword
    return this.client.request({ method: 'GET', path: '/api/admin/books', params })
  }

  public createBook(data: BookForm): Promise<Book> {
    return this.client.request({ method: 'POST', path: '/api/admin/books', body: data })
  }

  public updateBook(id: number, data: BookForm): Promise<Book> {
    return this.client.request({ method: 'PATCH', path: `/api/admin/books/${id}`, body: data })
  }

  public deleteBook(id: number): Promise<void> {
    return this.client.request({ method: 'DELETE', path: `/api/admin/books/${id}` })
  }
}
