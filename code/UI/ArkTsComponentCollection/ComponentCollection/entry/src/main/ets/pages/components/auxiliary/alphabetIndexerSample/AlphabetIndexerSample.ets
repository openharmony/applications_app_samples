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

import { TitleBar } from '../../../../common/TitleBar'
import { getStringArrayData } from '../../../../data/ResourceDataHandle'
import { alphabetIndexerDataB, alphabetIndexerDataC, alphabetIndexerDataL, letterValue } from '../../ComponentData'
import Logger from '../../../../util/Logger'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Circle) function colorPicker(groupIndex: number, itemIndex: number, color: Color, callback: Function) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback(groupIndex, itemIndex, color)
  })
}


@Entry
@Component
struct AlphabetIndexerSample {
  private arrayA: string[] = getStringArrayData([$r('app.string.alphabetindexer_an')])
  private arrayB: string[] = getStringArrayData(alphabetIndexerDataB)
  private arrayC: string[] = getStringArrayData(alphabetIndexerDataC)
  private arrayL: string[] = getStringArrayData(alphabetIndexerDataL)
  private value: string[] = letterValue
  private scroller: Scroller = new Scroller()
  private currentSelectIndex: number = 0
  private totalArray: string[][] = [this.arrayA, this.arrayB, this.arrayC, this.arrayL]
  private colorArray: Color[] = [0xFFFFFF, Color.Red, Color.Yellow, Color.Pink]
  @State selectTextColor: Color | number = 0xFFFFFF
  @State popupColor: Color | number = 0xFFFAF0
  @State selectBackgroundColor: Color | number = 0xCCCCCC
  @State popupBackgroundColor: Color | number = 0xD2B48C
  @State needPopup: boolean = true
  @State selectTextIndex: number = -1
  @State selectBackGroundIndex: number = -1
  @State popupIndex: number = -1
  @State popupBackgroundIndex: number = -1
  private circleClick = (groupIndex: number, itemIndex: number, color: Color) => {
    switch (groupIndex) {
      case 1:
        this.selectTextColor = color
        this.selectTextIndex = itemIndex
        break
      case 2:
        this.selectBackgroundColor = color
        this.selectBackGroundIndex = itemIndex
        break
      case 3:
        this.popupColor = color
        this.popupIndex = itemIndex
        break
      case 4:
        this.popupBackgroundColor = color
        this.popupBackgroundIndex = itemIndex
        break
    }
  }
  private compare = (selectedIndex: number, itemIndex: number): number => {
    return selectedIndex == itemIndex ? 1 : 0.2
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.auxiliary_alphabetIndexer') })
      Stack({ alignContent: Alignment.Start }) {
        Row() {
          Blank()
          Column() {
            IntroductionTitle({ introduction: $r('app.string.alphabetindexer_list_display') })
            List({ space: 20, initialIndex: 0, scroller: this.scroller }) {
              ForEach(this.arrayA.concat(this.arrayB).concat(this.arrayC).concat(this.arrayL), (item: string) => {
                ListItem() {
                  Text(item)
                    .width('80%')
                    .fontSize(30)
                    .textAlign(TextAlign.Center)
                }.editable(true)
              }, (item: string) => JSON.stringify(item))
            }
            .width('100%')
            .height('50%')
            .backgroundColor(Color.White)
            .borderRadius(24)

            Blank()
            IntroductionTitle({ introduction: $r('app.string.alphabetindexer_color_select') })
            Column() {
              Row() {
                Text($r('app.string.alphabetindexer_selectedcolor_selectedcolor'))
                  .leftTitleStyle()
                  .width('50%')

                ForEach(this.colorArray, (item: Color, index: number) => {
                  Circle({ width: 20, height: 20 })
                    .colorPicker(1, index, item, this.circleClick)
                    .borderRadius(20)
                    .borderWidth(1)
                    .opacity(this.compare(this.selectTextIndex, index))
                  Blank()
                })
              }.width('100%')

              Row() {
                Text($r('app.string.alphabetindexer_selectedcolor_selectedbgcolor'))
                  .leftTitleStyle()
                  .width('50%')

                ForEach(this.colorArray, (item: Color, index: number) => {
                  Circle({ width: 20, height: 20 })
                    .colorPicker(2, index, item, this.circleClick)
                    .borderRadius(20)
                    .borderWidth(1)
                    .opacity(this.compare(this.selectBackGroundIndex, index))
                  Blank()
                })
              }.width('100%')

              Row() {
                Text($r('app.string.alphabetindexer_selectedcolor_popupcolor'))
                  .leftTitleStyle()
                  .width('50%')

                ForEach(this.colorArray, (item: Color, index) => {
                  Circle({ width: 20, height: 20 })
                    .colorPicker(3, index, item, this.circleClick)
                    .borderRadius(20)
                    .borderWidth(1)
                    .opacity(this.compare(this.popupIndex, index))
                  Blank()
                })
              }.width('100%')

              Row() {
                Text($r('app.string.alphabetindexer_selectedcolor_popupbackground'))
                  .leftTitleStyle()
                  .width('50%')
                ForEach(this.colorArray, (item: Color, index) => {
                  Circle({ width: 20, height: 20 })
                    .colorPicker(4, index, item, this.circleClick)
                    .borderRadius(20)
                    .borderWidth(1)
                    .opacity(this.compare(this.popupBackgroundIndex, index))
                  Blank()
                })
              }.width('100%')

              Row() {
                Text($r('app.string.alphabetindexer_selectedcolor_usingpopup'))
                  .leftTitleStyle()
                  .width('50%')
                Blank()
                Toggle({ type: ToggleType.Switch, isOn: this.needPopup })
                  .onChange((isOn) => {
                    this.needPopup = isOn
                  })
              }.width('100%')
            }.cardStyle()

          }.width('90%')
          .height('100%')
          .alignSelf(ItemAlign.Start)

          Blank()
          AlphabetIndexer({ arrayValue: this.value, selected: 0 })
            .selectedColor(this.selectTextColor) // 选中项文本颜色
            .popupColor(this.popupColor) // 弹出框文本颜色
            .selectedBackgroundColor(this.selectBackgroundColor) // 选中项背景颜色
            .popupBackground(this.popupBackgroundColor) // 弹出框背景颜色
            .usingPopup(this.needPopup) // 是否显示弹出框
            .selectedFont({ size: 16, weight: FontWeight.Bolder }) // 选中项字体样式
            .popupFont({ size: 30, weight: FontWeight.Bolder }) // 弹出框内容的字体样式
            .itemSize(28) // 每一项的尺寸大小
            .alignStyle(IndexerAlign.Right) // 弹出框在索引条左侧弹出
            .onSelect((index: number) => {
              Logger.info(`${this.value[index]} Selected!`);
              if (this.value[index] === 'A') {
                this.currentSelectIndex = 0;
                this.scroller.scrollToIndex(0);
                return this.arrayA; // 当选中A时，弹出框里面的提示文本列表显示A对应的列表arrayA，选中B、C、L时也同样
              } else if (this.value[index] === 'B') {
                this.currentSelectIndex = 1;
                this.scroller.scrollToIndex(this.arrayA.length);
                return this.arrayB;
              } else if (this.value[index] === 'C') {
                this.currentSelectIndex = 2;
                this.scroller.scrollToIndex(this.arrayA.length + this.arrayB.length);
                return this.arrayC;
              } else if (this.value[index] === 'L') {
                this.currentSelectIndex = 3;
                this.scroller.scrollToIndex(this.arrayA.length + this.arrayB.length + this.arrayC.length);
                return this.arrayL;
              } else {
                return []; // 选中其余子母项时，提示文本列表为空
              }
            })
            .id('test_alphabet')
            .onRequestPopupData((index: number) => {
              if (this.value[index] === 'A') {
                this.currentSelectIndex = 0
                this.scroller.scrollToIndex(0)
                return this.arrayA // 当选中A时，弹出框里面的提示文本列表显示A对应的列表arrayA，选中B、C、L时也同样
              } else if (this.value[index] === 'B') {
                this.currentSelectIndex = 1
                this.scroller.scrollToIndex(this.arrayA.length)
                return this.arrayB
              } else if (this.value[index] === 'C') {
                this.currentSelectIndex = 2
                this.scroller.scrollToIndex(this.arrayA.length + this.arrayB.length)
                return this.arrayC
              } else if (this.value[index] === 'L') {
                this.currentSelectIndex = 3
                this.scroller.scrollToIndex(this.arrayA.length + this.arrayB.length + this.arrayC.length)
                return this.arrayL
              } else {
                return [] // 选中其余子母项时，提示文本列表为空
              }
            })
            .onPopupSelect((index: number) => {
              let length = 0
              for (let i = 0; i < this.currentSelectIndex; i++) {
                length += this.totalArray[i].length
              }
              this.scroller.scrollToIndex(length + index)
            })
        }
        .padding(10)
        .width('100%')
        .height('90%')
      }
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
  }
}
