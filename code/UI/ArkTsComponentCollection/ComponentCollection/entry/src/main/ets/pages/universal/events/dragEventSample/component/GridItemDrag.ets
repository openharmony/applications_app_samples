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
export struct GridItemDrag {
  @State numbers: string[] = new Array(15).fill('').map((item: string, i: number) => {
    return i.toString()
  });
  @State dragIndex: number = -1;

  // 自定义拖拽过程中显示的内容
  @Builder
  pixelMapBuilder(item: string) {
    Text(item)
      .fontSize(16)
      .width(80)
      .height(60)
      .backgroundColor(0xF9CF93)
      .textAlign(TextAlign.Center)
  }

  changeIndex(index1: number, index2: number) {
    let temp = this.numbers[index1];
    this.numbers[index1] = this.numbers[index2];
    this.numbers[index2] = temp;
  }

  build() {
    Grid() {
      ForEach(this.numbers, (item: string, index) => {
        GridItem() {
          Text(item)
            .id('gridItem' + index)
            .fontSize(16)
            .backgroundColor(0xF9CF93)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
        }
        .visibility(this.dragIndex === index ? Visibility.Hidden : Visibility.Visible)
      }, (item: string) => item)
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr 1fr')
    .width(400)
    .height(180)
    .editMode(true)
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