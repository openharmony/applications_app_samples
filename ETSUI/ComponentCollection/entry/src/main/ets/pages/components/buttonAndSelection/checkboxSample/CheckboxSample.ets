/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({left: 12, top: 12})
}

@Extend(Column)
function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Circle)
function colorPicker(color: Color | string, callback: ()=>void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles
function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Entry
@Component
struct CheckboxSample {
  @State rating: number = 1
  @State indicator: boolean = false
  @State stars: number = 5
  @State mColor: Color | number = 0xed6f21
  build() {
    Column() {
      TitleBar({title: $r('app.string.checkbox_checkboxgroup')})
      Text("Checkbox")
        .leftTitleStyle()
      Column() {
        Row() {
          Text($r('app.string.checkbox_apple')).fontSize(20)
          Blank()
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .selectedColor(this.mColor)
            .onChange((value: boolean) => {
              console.info('Checkbox1 change is' + value)
            })
        }.width('100%')
        Row() {
          Text($r('app.string.checkbox_blueberry')).fontSize(20)
          Blank()
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .selectedColor(this.mColor)
            .onChange((value: boolean) => {
              console.info('Checkbox1 change is' + value)
            })
        }.width('100%')
        Row() {
          Text($r('app.string.checkbox_banbana')).fontSize(20)
          Blank()
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .selectedColor(this.mColor)
            .onChange((value: boolean) => {
              console.info('Checkbox1 change is' + value)
            })
        }.width('100%')
        Row() {
          Text($r('app.string.checkbox_orange')).fontSize(20)
          Blank()
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .selectedColor(this.mColor)
            .onChange((value: boolean) => {
              console.info('Checkbox1 change is' + value)
            })
        }.width('100%')
        Column() {
          Text($r('app.string.checkbox_select_color')).fontSize(20)
            .margin(10)
          Row() {
            Blank()
            ForEach([0xed6f21, Color.Gray, Color.Red, Color.Yellow, Color.Pink, Color.Blue, Color.Green, Color.Orange], (item: Color) => {
              Circle({ width: 20, height: 20 })
                .colorPicker(item, () => {
                  this.mColor = item
                })
                .stateStyles({
                  pressed: pressedStyle,
                  normal: {
                    .borderRadius(20)
                    .borderWidth(1)
                  }
                })
              Blank()
            })
          }.width('100%')
        }
      }
      .cardStyle()
      .width('100%')

      Text("CheckboxGroup")
        .leftTitleStyle()
      Column() {
        Row() {
          CheckboxGroup({ group: 'checkboxGroup' })
            .selectedColor(0xed6f21)
            .onChange((itemName: CheckboxGroupResult) => {
              console.info("checkbox group content" + JSON.stringify(itemName))
            })
          Text($r('app.string.checkbox_select_all')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .selectedColor(0x39a2db)
            .onChange((value: boolean) => {
              console.info('Checkbox1 change is' + value)
            }).margin({left: 30})
          Text('Checkbox1').fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
            .selectedColor(0x39a2db)
            .onChange((value: boolean) => {
              console.info('Checkbox2 change is' + value)
            }).margin({left: 30})
          Text('Checkbox2').fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({ name: 'checkbox3', group: 'checkboxGroup' })
            .selectedColor(0x39a2db)
            .onChange((value: boolean) => {
              console.info('Checkbox3 change is' + value)
            }).margin({left: 30})
          Text('Checkbox3').fontSize(20)
        }.width('100%')
      }
      .cardStyle()
      .width('100%')

    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({left: 20, right: 20})
  }
}