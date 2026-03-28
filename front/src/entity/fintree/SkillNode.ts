export type NodeStatus = 'LOCKED' | 'UNLOCKED' | 'COMPLETED'
export type Difficulty = 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED'

export default class SkillNode {
  public id = 0
  public title = ''
  public description = ''
  public difficulty: Difficulty = 'BEGINNER'
  public estimatedMinutes = 0
  public orderIndex = 0
  public status: NodeStatus = 'LOCKED'
  public prerequisiteIds: number[] = []
}
