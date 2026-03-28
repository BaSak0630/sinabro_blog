import { inject, singleton } from 'tsyringe'
import HttpRepository from '@/repository/HttpRepository'
import SkillNode from '@/entity/fintree/SkillNode'
import SkillNodeDetail from '@/entity/fintree/SkillNodeDetail'

@singleton()
export default class SkillTreeRepository {
  constructor(@inject(HttpRepository) private readonly httpRepository: HttpRepository) {}

  public getTree(): Promise<SkillNode[]> {
    return this.httpRepository
      .get<SkillNode[]>({ path: '/api/fintree/tree' }, Array as any)
      .then((raw: any) => (Array.isArray(raw) ? raw as SkillNode[] : []))
  }

  public getNode(nodeId: number): Promise<SkillNodeDetail> {
    return this.httpRepository.get<SkillNodeDetail>(
      { path: `/api/fintree/nodes/${nodeId}` },
      SkillNodeDetail
    )
  }

  public submitQuiz(nodeId: number, answers: Record<number, number>): Promise<any> {
    return this.httpRepository.post(
      { path: `/api/fintree/nodes/${nodeId}/quiz/submit`, body: { answers } },
      null
    )
  }
}
