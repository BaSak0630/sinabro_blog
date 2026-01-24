export default class commentList<T> {
  public totalCount = 0
  public items: T[] = []

  public setComments(items: T[]) {
    this.items = items
    this.totalCount = items.length
  }
}
