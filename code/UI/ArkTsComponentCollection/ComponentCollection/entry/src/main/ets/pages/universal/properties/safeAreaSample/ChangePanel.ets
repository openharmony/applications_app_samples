/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { getStringData } from '../../../../data//ResourceDataHandle'
import Logger from '../../../../util/Logger'

@Component
export struct ChangePanel {
  @Link mSafeAreaType: SafeAreaType[]
  @Link mSafeAreaEdge: SafeAreaEdge[]

  build() {
    Row() {
      Column() {
        Row() {
          CheckboxGroup({ group: getStringData($r('app.string.safe_area_type')) })
            .selectedColor(0xed6f21)
            .onChange((itemName: CheckboxGroupResult) => {
              this.mSafeAreaType = []
              for (let i = 0;i < itemName.name.length; i++) {
                if (itemName.name[i] == getStringData($r('app.string.safe_area_type_system'))) {
                  this.mSafeAreaType.push(SafeAreaType.SYSTEM)
                }
                else if (itemName.name[i] == getStringData($r('app.string.safe_area_type_cutout'))) {
                  this.mSafeAreaType.push(SafeAreaType.CUTOUT)
                }
                else if (itemName.name[i] == getStringData($r('app.string.safe_area_type_keyboard'))) {
                  this.mSafeAreaType.push(SafeAreaType.KEYBOARD)
                }
              }

              Logger.info(`checkbox group content ${JSON.stringify(this.mSafeAreaType)}`)
            }).id('test_selectAll')
          Text($r('app.string.checkbox_select_all')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({
            name: getStringData($r('app.string.safe_area_type_system')),
            group: getStringData($r('app.string.safe_area_type'))
          })
            .id('SYSTEM')
            .selectedColor($r('app.color.select_option_font_color'))
            .onChange((value: boolean) => {
              Logger.info(`Checkbox1 change is ${value}`)
            }).margin({ left: 30 })
          Text($r('app.string.safe_area_type_system')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({
            name: getStringData($r('app.string.safe_area_type_cutout')),
            group: getStringData($r('app.string.safe_area_type'))
          })
            .select(true)
            .selectedColor($r('app.color.select_option_font_color'))
            .onChange((value: boolean) => {
              Logger.info(`Checkbox2 change is ${value}`)
            }).margin({ left: 30 })
          Text($r('app.string.safe_area_type_cutout')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({
            name: getStringData($r('app.string.safe_area_type_keyboard')),
            group: getStringData($r('app.string.safe_area_type'))
          })
            .selectedColor($r('app.color.select_option_font_color'))
            .onChange((value: boolean) => {
              Logger.info(`Checkbox3 change is ${value}`)
            }).margin({ left: 30 })
          Text($r('app.string.safe_area_type_keyboard')).fontSize(20)
        }.width('100%')
      }
      .layoutWeight(1)

      Column() {
        Row() {
          CheckboxGroup({ group: getStringData($r('app.string.safe_area_edge')) })
            .selectedColor(0xed6f21)
            .onChange((itemName: CheckboxGroupResult) => {
              this.mSafeAreaEdge = []
              for (let i = 0;i < itemName.name.length; i++) {
                if (itemName.name[i] == getStringData($r('app.string.safe_area_edge_bottom'))) {
                  this.mSafeAreaEdge.push(SafeAreaEdge.BOTTOM)
                }
                else if (itemName.name[i] == getStringData($r('app.string.safe_area_edge_top'))) {
                  this.mSafeAreaEdge.push(SafeAreaEdge.TOP)
                }
                else if (itemName.name[i] == getStringData($r('app.string.safe_area_edge_start'))) {
                  this.mSafeAreaEdge.push(SafeAreaEdge.START)
                }
                else if (itemName.name[i] == getStringData($r('app.string.safe_area_edge_end'))) {
                  this.mSafeAreaEdge.push(SafeAreaEdge.END)
                }
              }
              Logger.info(`checkbox group content ${JSON.stringify(itemName)}`)
            }).id('test_selectAll')
          Text($r('app.string.checkbox_select_all')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({
            name: getStringData($r('app.string.safe_area_edge_top')),
            group: getStringData($r('app.string.safe_area_edge'))
          })
            .select(true)
            .selectedColor($r('app.color.select_option_font_color'))
            .onChange((value: boolean) => {
              Logger.info(`Checkbox1 change is ${value}`)
            }).margin({ left: 30 })
          Text($r('app.string.safe_area_edge_top')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({
            name: getStringData($r('app.string.safe_area_edge_bottom')),
            group: getStringData($r('app.string.safe_area_edge'))
          })
            .select(true)
            .selectedColor($r('app.color.select_option_font_color'))
            .onChange((value: boolean) => {
              Logger.info(`Checkbox2 change is ${value}`)
            }).margin({ left: 30 })
          Text($r('app.string.safe_area_edge_bottom')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({
            name: getStringData($r('app.string.safe_area_edge_start')),
            group: getStringData($r('app.string.safe_area_edge'))
          })
            .selectedColor($r('app.color.select_option_font_color'))
            .onChange((value: boolean) => {
              Logger.info(`Checkbox3 change is ${value}`)
            }).margin({ left: 30 })
          Text($r('app.string.safe_area_edge_start')).fontSize(20)
        }.width('100%')

        Row() {
          Checkbox({
            name: getStringData($r('app.string.safe_area_edge_end')),
            group: getStringData($r('app.string.safe_area_edge'))
          })
            .selectedColor($r('app.color.select_option_font_color'))
            .onChange((value: boolean) => {
              Logger.info(`Checkbox3 change is ${value}`)
            }).margin({ left: 30 })
          Text($r('app.string.safe_area_edge_end')).fontSize(20)
        }.width('100%')
      }
      .layoutWeight(1)
    }
  }
}