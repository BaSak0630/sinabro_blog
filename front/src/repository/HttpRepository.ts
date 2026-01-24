import Null from '@/entity/data/Null'
import Paging from '@/entity/data/Paging'
import AxiosHttpClient, { type HttpRequestConfig } from '@/http/AxiosHttpClient'
import { plainToInstance, type ClassConstructor } from 'class-transformer'
import { inject, singleton } from 'tsyringe'

@singleton()
export default class HttpRepository {
  constructor(@inject(AxiosHttpClient) private readonly httpClient: AxiosHttpClient) {}

  public get<T>(config: HttpRequestConfig, clazz: ClassConstructor<T>): Promise<T> {
    return this.httpClient.request({ ...config, method: 'GET' }).then((response) =>
      plainToInstance<T, unknown>(clazz, response as unknown)
    )
  }

  public getList<T>(config: HttpRequestConfig, clazz: ClassConstructor<T>): Promise<Paging<T>> {
    return this.httpClient.request({ ...config, method: 'GET' }).then((response) => {
      const resp = response as unknown

      const paging = plainToInstance<Paging<T>, unknown>(
        Paging as unknown as ClassConstructor<Paging<T>>,
        resp
      )

      // backend returns items as a list inside the paging response
      const rawItems = (resp as any)?.items
      const items: T[] = Array.isArray(rawItems)
        ? (plainToInstance<T, unknown>(clazz, rawItems as unknown) as unknown as T[])
        : []

      paging.setItems(items)
      return paging
    })
  }

  public post<T>(config: HttpRequestConfig, clazz: ClassConstructor<T> | null = null): Promise<T> {
    return this.httpClient
      .request({ ...config, method: 'POST' })
      .then((response) => plainToInstance<T, unknown>(clazz ?? (Null as unknown as ClassConstructor<T>), response as unknown))
  }

  public patch<T>(config: HttpRequestConfig, clazz: ClassConstructor<T> | null = null): Promise<T> {
    return this.httpClient
      .request({
        ...config,
        method: 'PATCH'
      })
      .then((response) => plainToInstance<T, unknown>(clazz ?? (Null as unknown as ClassConstructor<T>), response as unknown))
  }

  public delete<T>(config: HttpRequestConfig, clazz: ClassConstructor<T> | null = null): Promise<T> {
    return this.httpClient
      .request({ ...config, method: 'DELETE' })
      .then((response) => plainToInstance<T, unknown>(clazz ?? (Null as unknown as ClassConstructor<T>), response as unknown))
  }
}
