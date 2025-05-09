/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct SwipeListItem {
  private index: number = 0;
  @State arr: number[] = [0, 1, 2, 3];

  // [Start build_the_tail_slide_out_component]
  @Builder
  itemEnd(index: number) {
    // 构建尾端滑出组件
    Button({ type: ButtonType.Circle }) {
      Image($r('sys.media.ohos_ic_bottomsheet_close'))
        .width(40)
        .height(40)
    }
    // [StartExclude build_the_tail_slide_out_component]
    .backgroundColor('#FFE1E2E3')
    // [EndExclude build_the_tail_slide_out_component]
    .onClick(() => {
      // this.messages为列表数据源，可根据实际场景构造。点击后从数据源删除指定数据项。
      this.arr.splice(index, 1);
    })
  }
  // [End build_the_tail_slide_out_component]

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SwipeListItem_titleExample') }) {
          List({ space: 12 }) {
            ForEach(this.arr, (item: number) => {
              // [Start bind_the_swipeAction_property_to_left_swipe_list_item]
              ListItem() {
                // [StartExclude bind_the_swipeAction_property_to_left_swipe_list_item]
                Text('Message ' + item)
                  .width('100%')
                  .height(50)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
                  .borderRadius(10)
                  .backgroundColor('#FFF1F3F5')
                // [EndExclude bind_the_swipeAction_property_to_left_swipe_list_item]
              }.swipeAction({
                end: {
                  // index为该ListItem在List中的索引值。
                  builder: () => {
                    this.index = this.arr.indexOf(item);
                    this.itemEnd(this.index);
                  },
                }
                // [End bind_the_swipeAction_property_to_left_swipe_list_item]
              })
            }, (item: number) => item.toString())
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SwipeListItem_title'))
  }
}