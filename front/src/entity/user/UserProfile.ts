export default class UserProfile {
  public id = 0
  public accountId = ''
  public username = ''
  public role = ''

  public isAdmin(): boolean {
    return this.role === 'ROLE_ADMIN'
  }
}
