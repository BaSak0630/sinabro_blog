import HttpRepository from '@/repository/HttpRepository'
import type Login from '@/entity/user/Login'
import type SignUp from '@/entity/user/SignUp'
import { inject, singleton } from 'tsyringe'
import UserProfile from '@/entity/user/UserProfile'
import PublicProfile from '@/entity/user/PublicProfile'

@singleton()
export default class AccountRepository {
  constructor(@inject(HttpRepository) private readonly httpRepository: HttpRepository) {}

  private profilePromise: Promise<UserProfile> | null = null

  public login(request: Login) {
    return this.httpRepository.post({
      path: '/api/auth/login',
      body: request,
    })
  }

  public getProfile() {
    if (!this.profilePromise) {
      this.profilePromise = this.httpRepository
        .get<UserProfile>({ path: '/api/users/me' }, UserProfile)
        .catch((e) => {
          this.profilePromise = null
          throw e
        })
    }
    return this.profilePromise
  }

  public signUp(request: SignUp) {
    return this.httpRepository.post({
      path: '/api/auth/signup',
      body: request,
    })
  }

  public googleLogin(){
    return this.httpRepository.post({
      path: '/api/oauth2/authorization/google',
    })
  }

  public getPublicProfile(accountId: string) {
    return this.httpRepository.get<PublicProfile>(
      { path: `/api/users/${accountId}` },
      PublicProfile
    )
  }
}
