/**
 * Tab item info.
 */
export class TabItem {
  constructor(index: number, title: Resource, imageActivated: Resource, imageOriginal: Resource) {
    this.index = index;
    this.title = title;
    this.imageActivated = imageActivated;
    this.imageOriginal = imageOriginal;
  }

  /**
   * Tab item index.
   */
  public index: number;
  /**
   * Tab item title.
   */
  public title: Resource;
  /**
   * Image activated.
   */
  public imageActivated: Resource;
  /**
   * Image original.
   */
  public imageOriginal: Resource;
}