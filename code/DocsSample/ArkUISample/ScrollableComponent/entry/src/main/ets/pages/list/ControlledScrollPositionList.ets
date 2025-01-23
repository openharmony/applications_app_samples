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
export struct ControlledScrollPositionList {
  private listScroller: Scroller = new Scroller();
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ControlledScrollPositionList_titleExample') }) {
          Stack({ alignContent: Alignment.Bottom }) {
            // 控制滚动位置示例List容器
            // 将listScroller用于初始化List组件的scroller参数，完成listScroller与列表的绑定。
            List({ space: 20, scroller: this.listScroller }) {
              // ...
              ForEach(this.arr, (item: number) => {
                ListItem() {
                  Text('新闻' + item)
                    .width('100%')
                    .height(100)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .borderRadius(10)
                    .backgroundColor('#FFF1F3F5')
                }
              }, (item: number) => item.toString())
            }

            Button() {
              // ...
              Image($r('sys.media.ohos_ic_public_arrow_up')).width(40).height(40)
            }
            .backgroundColor('#FFE0E2E4')
            .position({ x: '80%', y: '90%' })
            .onClick(() => {
              // 点击按钮时，指定跳转位置，返回列表顶部
              this.listScroller.scrollToIndex(0);
            })
          }.height('90%')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ControlledScrollPositionList_title'))
  }
}