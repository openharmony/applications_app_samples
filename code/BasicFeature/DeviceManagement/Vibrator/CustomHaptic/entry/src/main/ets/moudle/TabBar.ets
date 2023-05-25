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

export class TabModel {
  index: number
  content: string
  left: number
  width: number
}

@Component
export default struct TabLayout {
  private fontSizeNormal = 18
  private tabMargin = 15

  @Link titleArr: string[]
  @Link currentIndex:number
  private left: number = 0

  private tabSelected: (position: number, title: string) => void = (position: number, title: string) => {
    console.log('tabSelected position = ' + position + ', title = ' + title)
  }
  @State private tabDataArr: TabModel[] = []
  private scroller: Scroller = new Scroller()

  aboutToAppear() {
    this.tabDataArr = this.titleArr.map((title, index) => {
      let tabModel = new TabModel()
      tabModel.index = index
      tabModel.content = title
      tabModel.left = this.left
      let width = title.length * this.fontSizeNormal + this.tabMargin * 2
      tabModel.width = width
      tabModel.left = this.left
      this.left += width
      return tabModel
    })
  }

  build() {
    Scroll(this.scroller) {
      Flex({direction:FlexDirection.Row}) {
        ForEach(this.tabDataArr, (Item:TabModel) => {
          Flex({direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center}) {
            Text(Item.content)
              .fontSize(this.currentIndex == Item.index ? this.fontSizeNormal + 3 : this.fontSizeNormal)
              .fontColor(this.currentIndex == Item.index ? "#2AEFCC" : Color.White)
              .fontWeight(this.currentIndex == Item.index ? FontWeight.Bold : FontWeight.Normal)
              .textAlign(TextAlign.Center)
            Column()
              .height(3)
              .width(Item.width - this.tabMargin * 2)
              .margin({top:10})
              .backgroundColor("#2AEFCC")
              .visibility(this.currentIndex == Item.index ? Visibility.Visible : Visibility.Hidden)
          }.width(Item.width).height('100%').backgroundColor("#00002222")
          .onClick(()=> {
            this.currentIndex = Item.index
          })
        }, Item => Item.index)
      }
    }.scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
  }
}
