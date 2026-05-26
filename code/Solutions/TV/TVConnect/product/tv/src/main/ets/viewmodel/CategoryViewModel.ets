import { CommonConstants } from '../common/constants/CommonConstants';
import { SideListItem } from '../common/bean/SideListItem';
import { DetailListItem } from '../common/bean/DetailListItem';
import { DetailItemData } from '../common/bean/DetailItemData';

/**
 * Category ability view model.
 */
export class CategoryViewModel {
  /**
   * Get index list data on the left.
   *
   * @return {Array<IndexListItem>} indexListItems
   */
  getSideListData(): Array<SideListItem> {
    let indexListItems: SideListItem[] = [];
    for (let index = 1; index <= CommonConstants.LIST_SIZE; index++) {
      let indexListItem = new SideListItem();
      indexListItem.title = $r('app.string.list_item_text', index);
      indexListItems.push(indexListItem);
    }
    return indexListItems;
  }

  /**
   * Get detail list item info.
   *
   * @return {Array<DetailListItem>} detailListItems
   */
  getDetailListItems(): Array<DetailListItem> {
    let detailListItems: DetailListItem[] = [];
    for (let i = 0; i < CommonConstants.LIST_SIZE; i++) {
      let detailListItem = new DetailListItem();
      detailListItem.index = i;
      detailListItem.title = $r('app.string.detail_list_item_text');
      detailListItem.detailItemData = this.getDetailItems();
      detailListItems.push(detailListItem);
    }
    return detailListItems;
  }

  /**
   * Get detail item info.
   *
   * @return {Array<DetailItemData>} gridData
   */
  private getDetailItems(): Array<DetailItemData> {
    let detailData: DetailItemData[] = [];
    for (let i = 0; i < CommonConstants.DETAIL_ITEM_SIZE; i++) {
      let gridItemData = new DetailItemData();
      gridItemData.content = $r('app.string.grid_item_text');
      detailData.push(gridItemData);
    }
    return detailData;
  }
}

let categoryViewModel = new CategoryViewModel();

export default categoryViewModel as CategoryViewModel;