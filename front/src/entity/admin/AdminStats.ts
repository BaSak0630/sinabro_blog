export class PostSummary {
  public id = 0
  public title = ''
  public author = ''
  public regDate = ''
  public viewCount = 0
}

export class UserSummary {
  public id = 0
  public accountId = ''
  public username = ''
  public role = ''
  public createAt = ''
}

export default class AdminStats {
  public userCount = 0
  public postCount = 0
  public commentCount = 0
  public totalViewCount = 0
  public recentPosts: PostSummary[] = []
  public recentUsers: UserSummary[] = []
}
