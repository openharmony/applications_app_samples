import type { DetailItemData } from './DetailItemData';

/**
 * Detail list item info.
 */
export class DetailListItem {
  /**
   * Detail list item index.
   */
  public index: number = 0;
  /**
   * Detail list item title.
   */
  public title?: Resource;
  /**
   * Detail list item data.
   */
  public detailItemData: DetailItemData[] = [];
}