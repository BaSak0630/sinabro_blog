import { inject, singleton } from 'tsyringe'
import AxiosHttpClient from '@/http/AxiosHttpClient'
import type Category from '@/entity/post/Category'

@singleton()
export default class CategoryRepository {
  constructor(@inject(AxiosHttpClient) private readonly client: AxiosHttpClient) {}

  public getAll(): Promise<Category[]> {
    return this.client.request({ method: 'GET', path: '/api/categories' })
  }

  public create(name: string): Promise<Category> {
    return this.client.request({ method: 'POST', path: '/api/admin/categories', body: { name } })
  }

  public delete(id: number): Promise<void> {
    return this.client.request({ method: 'DELETE', path: `/api/admin/categories/${id}` })
  }
}
