import type { Difficulty, NodeStatus } from './SkillNode'

export class QuizOption {
  public id = 0
  public text = ''
}

export class Quiz {
  public id = 0
  public question = ''
  public options: QuizOption[] = []
}

export default class SkillNodeDetail {
  public id = 0
  public title = ''
  public content = ''
  public difficulty: Difficulty = 'BEGINNER'
  public estimatedMinutes = 0
  public status: NodeStatus = 'LOCKED'
  public prerequisiteIds: number[] = []
  public quizzes: Quiz[] = []
}
