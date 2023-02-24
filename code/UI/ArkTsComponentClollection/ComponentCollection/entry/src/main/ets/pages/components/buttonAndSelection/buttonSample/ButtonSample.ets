/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http:// www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import ShowToast from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'
import { getStringData } from '../../../../data/ResourceDataHandle'

@Extend(Column) function columnStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Extend(Row) function rowStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct ButtonSample {
  private context = getContext(this)

  @Styles buttonDefaultStyle() {
    .height(40)
    .layoutWeight(1)
    .margin({ left: 8, right: 8 })
    .backgroundColor($r('app.color.button_default_bg_color'))
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.button_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.button_type') })
          Column() {
            Row() {
              // Default style is capsule
              Button($r('app.string.button_confirm'))
                .buttonDefaultStyle()
                .onClick(() => {
                  ShowToast.longToast(`${getStringData($r('app.string.button_type_capsule'))}${getStringData($r('app.string.button_click'))}`)
                })
              // Set button type as parameter
              Button($r('app.string.button_confirm'), { type: ButtonType.Normal })
                .buttonDefaultStyle()
                .onClick(() => {
                  ShowToast.longToast(`${getStringData($r('app.string.button_type_normal'))}${getStringData($r('app.string.button_click'))}`)
                })
              Button() {
                Image($r('app.media.ic_button_circle_add'))
              }
              .buttonDefaultStyle()
              .type(ButtonType.Circle) // Set button type as attribute
              .onClick(() => {
                ShowToast.longToast(`${getStringData($r('app.string.button_type_circle'))}${getStringData($r('app.string.button_click'))}`)
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text($r('app.string.button_type_capsule'))
              Text($r('app.string.button_type_normal'))
              Text($r('app.string.button_type_circle'))
            }
            .width('100%')
            .margin({ top: 12 })
            .justifyContent(FlexAlign.SpaceAround)
          }
          .columnStyle()

          // State effect default is ture
          IntroductionTitle({ introduction: $r('app.string.button_state_effect') })
          Row() {
            // Set state effect as parameter
            Button($r('app.string.button_state_effect_true'), { stateEffect: true })
              .buttonDefaultStyle()
              .onClick(() => {
                ShowToast.longToast(`${getStringData($r('app.string.button_state_effect_true'))}${getStringData($r('app.string.button_click'))}`)
              })

            // No effect but response onClick event
            Button($r('app.string.button_state_effect_false'))
              .buttonDefaultStyle()
              .stateEffect(false) // Set button type as attribute
              .onClick(() => {
                ShowToast.longToast(`${getStringData($r('app.string.button_state_effect_false'))}${getStringData($r('app.string.button_click'))}`)
              })

            // Disable this button
            Button($r('app.string.button_disable_style'))
              .buttonDefaultStyle()
              .enabled(false) // If false will not response onClick event
              .opacity(0.4) // Opacity if disable
              .onClick(() => {
                // onClick event will not response
                ShowToast.longToast(`${getStringData($r('app.string.button_disable_style'))}${getStringData($r('app.string.button_click'))}`)
              })
          }
          .rowStyle()
          .justifyContent(FlexAlign.SpaceAround)

          IntroductionTitle({ introduction: $r('app.string.button_custom_style') })
          Row() {
            Button($r('app.string.button_border_radius'))
              .type(ButtonType.Normal)
              .borderRadius(6)
              .buttonDefaultStyle()
              .onClick(() => {
                // onClick event will not response
                ShowToast.longToast(`${getStringData($r('app.string.button_border_radius'))}${getStringData($r('app.string.button_click'))}`)
              })

            Button() {
              Row() {
                Image($r('app.media.ic_button_loading'))
                  .size({ width: 18, height: 18 })
                  .margin({ left: 6, right: 6 })
                Text($r('app.string.button_with_icon'))
                  .fontSize(16)
                  .fontColor(Color.White)
              }
            }
            .buttonDefaultStyle()
            .onClick(() => {
              // onClick event will not response
              ShowToast.longToast(`${getStringData($r('app.string.button_border_radius'))}${getStringData($r('app.string.button_click'))}`)
            })

            Button() {
              Text($r('app.string.button_custom_bg_color'))
                .fontSize(16)
                .fontColor(Color.White)
            }
            .buttonDefaultStyle()
            .backgroundColor($r('app.color.button_custom_color'))
            .onClick(() => {
              // onClick event will not response
              ShowToast.longToast(`${getStringData($r('app.string.button_custom_bg_color'))}${getStringData($r('app.string.button_click'))}`)
            })
          }
          .rowStyle()
          .justifyContent(FlexAlign.SpaceAround)
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
        .padding({ right: 16, left: 16 })
      }
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}