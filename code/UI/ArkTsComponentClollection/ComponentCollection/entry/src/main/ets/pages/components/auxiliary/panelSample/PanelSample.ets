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
import { fruitArray } from '../../ComponentData'
import { getStringArrayData, getStringData } from '../../../../data/ResourceDataHandle'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
}

@Extend(Text) function subTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Column) function itemCardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(10)
}

@Entry
@Component
struct PanelSample {
  @State minShow: boolean = false
  @State foldableShow: boolean = false
  @State temporaryShow: boolean = false
  @State selectIndex: number = 0
  private panelMode: PanelMode = PanelMode.Half
  private miniPanelMode: PanelMode = PanelMode.Full
  private fruitArray: string[] = getStringArrayData(fruitArray)
  private radioGroupName: string = getStringData($r('app.string.panel_radio_groupname'))

  build() {
    Column() {
      TitleBar({ title: $r('app.string.auxiliary_panel') })
      Column() {
        Column({ space: 20 }) {
          Button(this.minShow ? $r('app.string.panel_close_minibar') : $r('app.string.panel_show_minibar'))
            .width('80%')
            .onClick(() => {
              this.minShow = !this.minShow
            })
          Button(this.foldableShow ? $r('app.string.panel_close_foldable') : $r('app.string.panel_show_foldable'))
            .width('80%')
            .onClick(() => {
              this.foldableShow = !this.foldableShow
            })
          Button(this.temporaryShow ? $r('app.string.panel_close_temporary') : $r('app.string.panel_show_temporary'))
            .onClick(() => {
              this.temporaryShow = !this.temporaryShow
            })
            .width('80%')
        }.width('100%')
      }.cardStyle()
      .margin({ top: 20 })

      Panel(this.minShow) {
        Column({ space: 5 }) {
          ForEach(this.fruitArray, (item: string, index: number) => {
            Column() {
              Row() {
                Text(item)
                  .fontSize(15)
                Blank()
                Radio({ value: item, group: this.radioGroupName })
                  .checked(this.selectIndex === index)
              }.width('100%')
            }.itemCardStyle()
            .onClick(() => {
              this.selectIndex = index
            })
          })
        }.margin({ left: 10, right: 10 })
      }
      .mode(this.miniPanelMode)
      .type(PanelType.Minibar)
      .borderWidth(1)
      .borderRadius(24)

      Panel(this.foldableShow) {
        Column({ space: 5 }) {
          ForEach(this.fruitArray, (item: string, index: number) => {
            Column() {
              Row() {
                Text(item)
                  .fontSize(15)
                Blank()
                Radio({ value: item, group: this.radioGroupName })
                  .checked(this.selectIndex === index)
              }.width('100%')
            }.itemCardStyle()
            .onClick(() => {
              this.selectIndex = index
            })
          })
        }.margin({ left: 10, right: 10 })
      }.onChange((width, height, mode) => {
        this.panelMode = mode
      })
      .mode(this.panelMode)
      .borderWidth(1)
      .borderRadius(24)

      Panel(this.temporaryShow) {
        Column({ space: 5 }) {
          ForEach(this.fruitArray, (item: string, index: number) => {
            Column() {
              Row() {
                Text(item)
                  .fontSize(15)
                Blank()
                Radio({ value: item, group: this.radioGroupName })
                  .checked(this.selectIndex === index)
              }.width('100%')
            }.itemCardStyle()
            .onClick(() => {
              this.selectIndex = index
            })
          })
        }.margin({ left: 10, right: 10 })
      }.onChange((width, height, mode) => {
        this.panelMode = mode
      })
      .type(PanelType.Temporary)
      .borderWidth(1)
      .borderRadius(24)

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding(12)
  }
}