/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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