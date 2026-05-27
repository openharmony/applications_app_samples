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
import type { SideListItem } from '../common/bean/SideListItem';
import CategoryViewModel from '../viewmodel/CategoryViewModel';

/**
 * Category side list component.
 */
@Component
export struct SideListComponent {
  scroller?: Scroller;
  @Prop sideListBreakpoint: string;
  @Link sideListIndex: number;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      List() {
        ForEach(CategoryViewModel.getSideListData(), (item: SideListItem, index: number) => {
          ListItem() {
            Text(item.title)
              .fontSize($r('app.string.List_item_text_size'))
              .fontWeight(CommonConstants.INDEX_LIST_FONT_WEIGHT)
              .fontColor(this.sideListIndex === index ?
              $r('app.color.tab_text_activated') : $r('app.color.list_text_normal'))
              .textAlign(TextAlign.Start)
              .margin({
                top: $r('app.string.List_item_text_margin_top'),
                bottom: $r('app.string.side_list_text_margin_bottom'),
                left: this.sideListBreakpoint === CommonConstants.BREAK_POINT_SM ?
                $r('app.string.text_margin_left_xs') : $r('app.string.text_margin_left_normal')
              })
              .width(CommonConstants.FULL_WIDTH_PERCENT)
              .onClick(() => {
                this.sideListIndex = index;
                this.scroller?.scrollToIndex(this.sideListIndex);
              });
          };
        }, (item: SideListItem, index: number) => index + JSON.stringify(item));
      }
      .constraintSize({
        minWidth: $r('app.string.side_minWidth')
      })
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .height(CommonConstants.FULL_HEIGHT_PERCENT)
      .margin({ top: $r('app.string.side_list_margin_top') });

      Divider()
        .vertical(true)
        .color($r('app.color.divider'))
        .strokeWidth(CommonConstants.DIVIDER_STROKE_WIDTH)
        .margin({ bottom: $r('app.string.divider_margin_bottom') });
    };
  }
}