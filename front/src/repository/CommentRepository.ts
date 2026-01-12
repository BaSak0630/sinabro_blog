import type CommentDelete from '@/entity/comment/CommentDelete'
import type CommentWrite from '@/entity/comment/CommentWrite'
import { inject, singleton } from 'tsyringe'
import HttpRepository from './HttpRepository'

@singleton()
export default class CommentRepository {
  constructor(@inject(HttpRepository) private readonly httpRepository: HttpRepository) {}

  public async write(commentWrite: CommentWrite, postId: number) {
    return this.httpRepository.post({
      path: '/api/posts/' + postId + '/comments',
      body: commentWrite
    })
  }

  public async delete(CommentDelete: CommentDelete, commentId: number) {
    return this.httpRepository.post({
      path: '/api/comments/' + commentId + '/delete',
      body: CommentDelete
    })
  }

  public async updateComment(comment: Comment) {
    return
  }
}
