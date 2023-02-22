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

import { ChangePanel } from './ChangePanel'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import ShowToast from '../../../../util/ShowToast'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Extend(Column) function columnStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct SliderSample {
  @State eventValue: number = 10
  @State sliderChange: number = 2
  @State minOrMaxValue: number = 60
  @State blockColor: string = '#FFFFFFFF'
  @State selectColor: string = '#FF0A59F7'
  @State trackColor: string = '#19000000'
  @State trackThickness: number = 5
  private steps: string[] = ['10', '20', '30', '40', '50', '60', '70', '80', '90']
  private changeModes: Resource[] = [$r('app.string.slider_event_begin'), $r('app.string.slider_event_moving'),
  $r('app.string.slider_event_end'), $r('app.string.slider_event_click')]

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
            Text(this.changeModes[this.sliderChange])
            Slider({
              value: this.eventValue,
              style: SliderStyle.OutSet
            })
              .onChange((value: number, mode: SliderChangeMode) => {
                switch (mode) {
                  case SliderChangeMode.Begin:
                    this.sliderChange = 0
                    break
                  case SliderChangeMode.Moving:
                    this.sliderChange = 1
                    break
                  case SliderChangeMode.End:
                    this.sliderChange = 2
                    break
                  case SliderChangeMode.Click:
                    this.sliderChange = 3
                    break
                  default:
                    this.sliderChange = 2
                }
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
              min: 10,
              max: 90,
              style: SliderStyle.OutSet
            })
              .width('100%')
              .showTips(true)
              .showSteps(true)
              .padding({ left: 12, right: 12 })

            Row() {
              ForEach(this.steps, (item) => {
                Text(item)
                  .fontSize(18)
                  .textAlign(TextAlign.Center)
                  .constraintSize({ maxWidth: 30 })
              })
            }
            .height(20)
            .width('100%')
            .padding({ left: 12, right: 12 })
            .justifyContent(FlexAlign.SpaceBetween)
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