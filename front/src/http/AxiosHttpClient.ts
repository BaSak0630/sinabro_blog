import axios, { type AxiosError, type AxiosInstance, type AxiosResponse } from 'axios'
import { singleton } from 'tsyringe'
import HttpError from './HttpError'

export type HttpRequestConfig = {
  method?: 'GET' | 'POST' | 'PATCH' | 'DELETE'
  path: string
  params?: any
  body?: any
}

@singleton()
export default class AxiosHttpClient {
  private readonly client: AxiosInstance = axios.create({
    timeout: 3000,
    timeoutErrorMessage: '요청 시간이 초과되었습니다. '
  })

  public async request(config: HttpRequestConfig) {
    return this.client
      .request({
        method: config.method,
        url: config.path,
        params: config.params,
        data: config.body
      })
      .then((response: AxiosResponse) => {
        return response.data
      })
      .catch((e: AxiosError) => {
        const error = new HttpError(e)
        return Promise.reject(error)
      })
  }
}
