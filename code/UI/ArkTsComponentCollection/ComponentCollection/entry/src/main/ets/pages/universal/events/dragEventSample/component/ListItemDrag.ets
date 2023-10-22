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

@Component
export struct ListItemDrag {
  @State numbers: string[] = ['one', 'two', 'three', 'four', 'five', 'six']
  @State dragIndex: number = -1

  // 自定义拖拽过程中显示的内容
  @Builder pixelMapBuilder(item: string) {
    Text(item)
      .width(400)
      .height(80)
      .fontSize(16)
      .borderRadius(10)
      .textAlign(TextAlign.Center)
      .backgroundColor(0xAFEEEE)
  }

  changeIndex(index1: number, index2: number) {
    let temp = this.numbers[index1];
    this.numbers[index1] = this.numbers[index2];
    this.numbers[index2] = temp;
  }

  build() {
    List({ space: 20 }) {
      ForEach(this.numbers, (item: string, index: number) => {
        ListItem() {
          Text(item)
            .id('listItem' + index)
            .width('100%')
            .height(80)
            .fontSize(16)
            .borderRadius(10)
            .textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE)
        }
        .visibility(this.dragIndex === index ? Visibility.Hidden : Visibility.Visible)
      }, (item: string) => item)
    }
    .width(400)
    .height(200)
    .border({ width: 1 })
    .padding(15)
    .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 })
    .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
      this.dragIndex = itemIndex
      return this.pixelMapBuilder(this.numbers[itemIndex])
    })
    .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
      if (isSuccess === true) {
        this.changeIndex(itemIndex, insertIndex)
      }
      this.dragIndex = -1
    })
  }
}