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

import { ChangePanel } from './ChangePanel'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { ShowToast } from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle () {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Extend(Column) function columnStyle () {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct SliderSample {
  @State minOrMaxValue: number = 60
  @State eventValue: number = 10
  @State sliderChangeMode: SliderChangeMode = SliderChangeMode.End
  @State blockColor: string = '#FFFFFFFF'
  @State selectColor: string = '#FF0A59F7'
  @State trackColor: string = '#19000000'
  @State trackThickness: number = 5
  private changeModes: string[] = ['Begin', 'Moving', 'End', 'Click']

  build() {
    Column() {
      TitleBar({ title: $r('app.string.slider_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.slider_current_value') })
          Row() {
            Slider({
              value: this.minOrMaxValue,
              min: 50,
              max: 130,
              style: SliderStyle.OutSet
            })
              .layoutWeight(1)
              .onChange((value: number) => {
                this.minOrMaxValue = value
              })
            Text(`${Math.trunc(this.minOrMaxValue)}`)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.slider_events') })
          Column() {
            Text(this.changeModes[this.sliderChangeMode])
            Slider({
              value: this.eventValue,
              style: SliderStyle.OutSet
            })
              .onChange((value: number, mode: SliderChangeMode) => {
                ShowToast.shortToast(`value: ${value}`)
                this.sliderChangeMode = mode
                this.eventValue = value
              })
          }
          .columnStyle()
          .justifyContent(FlexAlign.Center)

          IntroductionTitle({ introduction: $r('app.string.slider_step_tip') })
          Column() {
            Slider({
              value: 10,
              step: 10,
              min: 0,
              max: 100,
              style: SliderStyle.OutSet
            })
              .showTips(true)
              .showSteps(true)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.slider_attributes') })
          Column() {
            Slider({
              value: 10,
              style: SliderStyle.OutSet
            })
              .blockColor(this.blockColor)
              .trackColor(this.trackColor)
              .selectedColor(this.selectColor)
              .trackThickness(this.trackThickness)
            ChangePanel({
              blockColor: $blockColor,
              selectColor: $selectColor,
              trackColor: $trackColor,
              trackThickness: $trackThickness
            })
          }
          .columnStyle()
          .justifyContent(FlexAlign.Center)

          IntroductionTitle({ introduction: $r('app.string.slider_vertical_reverse') })
          Row() {
            Column() {
              Slider({
                value: 10,
                direction: Axis.Vertical,
                reverse: false,
                style: SliderStyle.OutSet
              })
                .layoutWeight(1)
              Text($r('app.string.slider_forward'))
            }

            Column() {
              Slider({
                value: 10,
                direction: Axis.Vertical,
                reverse: true,
                style: SliderStyle.OutSet
              })
                .layoutWeight(1)
              Text($r('app.string.slider_reverse'))
            }
          }
          .rowStyle()
          .height(240)
          .justifyContent(FlexAlign.SpaceAround)
          .margin({ bottom: 80 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
      }
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}