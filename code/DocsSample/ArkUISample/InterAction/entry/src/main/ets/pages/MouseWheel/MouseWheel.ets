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

// [Start mouse_wheel]
import { ListDataSource } from './ListDataSource';

@Entry
@Component
struct MouseWheel {
  private arr: ListDataSource = new ListDataSource([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
  @State dir1: Axis = Axis.Vertical;

  build() {
    Column() {
      Button('Click to Change ListDirection')
        .margin(20)
        .onClick(() => {
          if (this.dir1 === Axis.Vertical) {
            this.dir1 = Axis.Horizontal;
          } else {
            this.dir1 = Axis.Vertical;
          }
        })
      List({ space: 20, initialIndex: 0 }) {
        LazyForEach(this.arr, (item: number) => {
          ListItem() {
            Text('' + item)
              .width('100%')
              .height(100)
              .fontSize(16)
              .textAlign(TextAlign.Center)
              .borderRadius(10)
              .backgroundColor(0xFFFFFF)
          }
          .margin(20)
          // 为ListItem绑定滑动手势，当在ListItem上滚动鼠标滚轮时，会优先触发ListItem的滑动手势
          .gesture(PanGesture({ direction: PanDirection.Vertical })
            .onActionStart(() => {
            })
            .onActionUpdate(() => {
            }))
        }, (item: number) => item.toString())
      }
      .borderWidth(1)
      .listDirection(this.dir1) // 排列方向
      .scrollBar(BarState.Off)
      .friction(0.6)
      .divider({
        strokeWidth: 2,
        color: 0xFFFFFF,
        startMargin: 20,
        endMargin: 20
      }) // 每行之间的分界线
      .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
      .width('90%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding(20)
  }
}
// [End mouse_wheel]