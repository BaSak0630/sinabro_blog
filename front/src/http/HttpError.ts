import type { AxiosError } from 'axios'

export default class HttpError {
  private readonly code: string
  private readonly message: string

  constructor(e: AxiosError) {
    // 서버 응답이 있는 경우
    if (e.response) {
      const status = e.response.status
      this.code = String(status)

      // 서버에서 보낸 메시지가 있으면 사용
      const serverMessage = (e.response?.data as { message: string })?.message

      if (serverMessage) {
        this.message = serverMessage
      } else {
        // HTTP 상태 코드별 기본 메시지
        this.message = this.getDefaultMessage(status)
      }
    } else {
      // 네트워크 오류 (서버 응답 없음)
      this.code = 'NETWORK_ERROR'
      this.message = '네트워크 상태가 좋지 않습니다.'
    }
  }

  private getDefaultMessage(status: number): string {
    switch (status) {
      case 400:
        return '잘못된 요청입니다.'
      case 401:
        return '아이디 또는 비밀번호가 잘못되었습니다'
      case 403:
        return '권한이 없습니다.'
      case 404:
        return '요청한 리소스를 찾을 수 없습니다.'
      case 500:
        return '서버 오류가 발생했습니다.'
      default:
        return '알 수 없는 오류가 발생했습니다.'
    }
  }

  public getCode(): string {
    return this.code
  }

  public getMessage(): string {
    return this.message
  }

  public toString(): string {
    return `${this.code}: ${this.message}`
  }
}
