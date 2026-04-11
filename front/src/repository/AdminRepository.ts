import AdminStats from '@/entity/admin/AdminStats'
import AdminUser from '@/entity/admin/AdminUser'
import Post from '@/entity/post/Post'
import HttpRepository from '@/repository/HttpRepository'
import { inject, singleton } from 'tsyringe'

@singleton()
export default class AdminRepository {
  constructor(@inject(HttpRepository) private readonly httpRepository: HttpRepository) {}

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
}
