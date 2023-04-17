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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import ShowToast from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle () {
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .size({ width: '100%', height: 70 })
}

@Entry
@Component
struct ToggleSample {
  @State isNormalSelect: boolean = false
  @State isCustomSelect: boolean = true
  private context: any = getContext(this)
  private toggleState: string = this.context.resourceManager.getStringSync($r('app.string.toggle_state').id)

  build() {
    Column() {
      TitleBar({ title: $r('app.string.toggle_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.toggle_type_switch') })
          Row() {
            Toggle({ type: ToggleType.Switch, isOn: false })
              .onChange((isOn: boolean) => {
                ShowToast.longToast(`${this.toggleState}${isOn}`)
              })

            Toggle({ type: ToggleType.Switch, isOn: true })
              .switchPointColor($r('app.color.background_blue'))
              .selectedColor($r('app.color.toggle_selected_color'))
              .onChange((isOn: boolean) => {
                ShowToast.longToast(`${this.toggleState}${isOn}`)
              })
          }
          .rowStyle()
          .justifyContent(FlexAlign.SpaceAround)

          IntroductionTitle({ introduction: $r('app.string.toggle_type_checkbox') })
          Row() {
            Row() {
              Toggle({ type: ToggleType.Checkbox, isOn: false })
                .onChange((isOn: boolean) => {
                  ShowToast.longToast(`${this.toggleState}${isOn}`)
                })
              Text($r('app.string.radio_beijing'))
            }

            Row() {
              Toggle({ type: ToggleType.Checkbox, isOn: true })
                .selectedColor($r('app.color.toggle_selected_color'))
                .onChange((isOn: boolean) => {
                  ShowToast.longToast(`${this.toggleState}${isOn}`)
                })
              Text($r('app.string.radio_shanghai'))
            }
          }
          .rowStyle()
          .justifyContent(FlexAlign.SpaceAround)

          IntroductionTitle({ introduction: $r('app.string.toggle_type_button') })
          Row() {
            Toggle({ type: ToggleType.Button, isOn: this.isNormalSelect }) {
              Text(this.isNormalSelect ? $r('app.string.toggle_select') : $r('app.string.toggle_unselect'))
                .fontSize(18)
            }
            .size({ width: 90, height: 35 })
            .onChange((isOn: boolean) => {
              this.isNormalSelect = isOn
              ShowToast.longToast(`${this.toggleState}${isOn}`)
            })

            Toggle({ type: ToggleType.Button, isOn: this.isCustomSelect }) {
              Text(this.isCustomSelect ? $r('app.string.toggle_select') : $r('app.string.toggle_unselect'))
                .fontSize(18)
            }
            .size({ width: 90, height: 35 })
            .selectedColor($r('app.color.toggle_selected_color'))
            .onChange((isOn: boolean) => {
              this.isCustomSelect = isOn
              ShowToast.longToast(`${this.toggleState}${isOn}`)
            })
          }
          .rowStyle()
          .justifyContent(FlexAlign.SpaceAround)
          .margin({ bottom: 80 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
      }
      .padding({ left: 12, right: 12 })
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
