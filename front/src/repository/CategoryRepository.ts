import axios from 'axios'
import { singleton } from 'tsyringe'
import type Category from '@/entity/post/Category'

@singleton()
export default class CategoryRepository {
  public getAll(): Promise<Category[]> {
    return axios.get<Category[]>('/api/categories', { withCredentials: true })
      .then(res => res.data)
  }

  public create(name: string): Promise<Category> {
    return axios.post<Category>('/api/admin/categories', { name }, { withCredentials: true })
      .then(res => res.data)
  }

  public delete(id: number): Promise<void> {
    return axios.delete(`/api/admin/categories/${id}`, { withCredentials: true })
      .then(() => undefined)
  }
}
