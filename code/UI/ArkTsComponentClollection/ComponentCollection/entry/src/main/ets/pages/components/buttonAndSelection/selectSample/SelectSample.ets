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

@Entry
@Component
struct SelectSample {
  @State selectIndex: number = 0
  private context: any = getContext(this)
  private indexTitle: string = this.context.resourceManager.getStringSync($r('app.string.select_index').id)
  private valueTitle: string = this.context.resourceManager.getStringSync($r('app.string.select_value').id)
  private selectIcon: ResourceStr[] = [
    $r('app.media.ic_select_option_picture'),
    $r('app.media.ic_select_option_collection'),
    $r('app.media.ic_select_option_gesture')]
  private cityNames: SelectOption[] = [
    { value: $r('app.string.radio_beijing') },
    { value: $r('app.string.radio_shanghai') },
    { value: $r('app.string.radio_shenzhen') }]

  @Styles itemBorder() {
    .height(60)
    .width('100%')
    .borderRadius(24)
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.select_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.select_has_icon') })
          Row() {
            Image(this.selectIcon[this.selectIndex])
              .size({ width: 24, height: 24 })
            Select([
              { value: $r('app.string.select_picture'), icon: $r('app.media.ic_select_option_picture') },
              { value: $r('app.string.select_collection'), icon: $r('app.media.ic_select_option_collection') },
              { value: $r('app.string.select_gesture'), icon: $r('app.media.ic_select_option_gesture') }
            ])
              .font({ size: 20, weight: FontWeight.Normal })
              .selected(this.selectIndex)
              .onSelect((index: number, value: string) => {
                ShowToast.longToast(`${this.indexTitle}${index} ${this.valueTitle}${value}`)
                this.selectIndex = index
              })
          }
          .itemBorder()
          .justifyContent(FlexAlign.Center)

          IntroductionTitle({ introduction: $r('app.string.select_option_bg_and_text_style') })
          Column() {
            Select(this.cityNames)
              .selected(1)
              .font({ size: 20, weight: FontWeight.Normal })
              .selectedOptionBgColor($r('app.color.select_option_bg_color'))
              .selectedOptionFontColor($r('app.color.select_option_font_color'))
              .selectedOptionFont({ size: 25, weight: FontWeight.Medium })
              .onSelect((index: number, value: string) => {
                ShowToast.longToast(`${this.indexTitle}${index} ${this.valueTitle}${value}`)
              })
          }
          .itemBorder()
          .justifyContent(FlexAlign.Center)

          IntroductionTitle({ introduction: $r('app.string.select_unselect_option_style') })
          Column() {
            Select(this.cityNames)
              .selected(0)
              .font({ size: 20, weight: FontWeight.Normal })
              .optionBgColor($r('app.color.select_option_bg_color'))
              .optionFontColor(Color.White)
              .optionFont({ size: 25, weight: FontWeight.Normal })
              .onSelect((index: number, value: string) => {
                ShowToast.longToast(`${this.indexTitle}${index} ${this.valueTitle}${value}`)
              })
          }
          .itemBorder()
          .justifyContent(FlexAlign.Center)

          IntroductionTitle({ introduction: $r('app.string.select_button_style') })
          Column() {
            Select(this.cityNames)
              .selected(2)
              .font({ size: 20, weight: FontWeight.Normal })
              .fontColor(Color.Black)
              .onSelect((index: number, value: string) => {
                ShowToast.longToast(`${this.indexTitle}${index} ${this.valueTitle}${value}`)
              })
          }
          .itemBorder()
          .justifyContent(FlexAlign.Center)
        }
        .alignItems(HorizontalAlign.Start)
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen
      }
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}