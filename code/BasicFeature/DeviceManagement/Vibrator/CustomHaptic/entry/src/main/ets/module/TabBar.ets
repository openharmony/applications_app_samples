/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import Logger from './Logger'

const TAG = '[TabBar]'

export class TabModel {
  index ?: number
  content ?: Resource
  left ?: number
  width ?: number
}

@Component
export default struct TabBar {
  private fontSizeNormal = 18
  private tabMargin = 15
  private titleLength = 3
  @Link titleArr: Resource[]
  @Link currentIndex: number
  private left: number = 0
  private tabSelected: (position: number, title: string) => void = (position: number, title: string) => {
    Logger.info(TAG, 'tabSelected position = ' + position + ', title = ' + title)
  }
  @State private tabDataArr: TabModel[] = []
  private scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.tabDataArr = this.titleArr.map((title: Resource, index: number) => {
      let tabModel = new TabModel()
      tabModel.index = index
      tabModel.content = title
      tabModel.left = this.left
      let width = this.titleLength * this.fontSizeNormal + this.tabMargin * 2
      tabModel.width = width
      tabModel.left = this.left
      this.left += width
      return tabModel
    })
  }

  build() {
    Scroll(this.scroller) {
      Flex({ direction: FlexDirection.Row }) {
        ForEach(this.tabDataArr, (item: TabModel) => {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
            Text(item.content)
              .fontSize(this.currentIndex === item.index ? this.fontSizeNormal + 3 : this.fontSizeNormal)
              .fontColor(this.currentIndex === item.index ? "#2AEFCC" : Color.White)
              .fontWeight(this.currentIndex === item.index ? FontWeight.Bold : FontWeight.Normal)
              .textAlign(TextAlign.Center)
            Column()
              .height(3)
              .width(item.width! - this.tabMargin * 2)
              .margin({ top: 10 })
              .backgroundColor("#2AEFCC")
              .visibility(this.currentIndex === item.index ? Visibility.Visible : Visibility.Hidden)
          }
          .width(item.width!)
          .height('100%')
          .backgroundColor("#00002222")
          .onClick(() => {
            if (item.index !== undefined) {
              this.currentIndex = item.index
            }
          })
        }, (item: TabModel) => item.index!.toString())
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
}
