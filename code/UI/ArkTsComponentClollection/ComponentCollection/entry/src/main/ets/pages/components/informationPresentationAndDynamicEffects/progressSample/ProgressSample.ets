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

@Extend(Circle) function colorPicker(color: Color | string, callback: () => void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Entry
@Component
struct ProgressSample {
  @State accumulateTime: number = 0
  @State progress: number = 50
  controller: TextClockController = new TextClockController()

  build() {
    Column() {
      TitleBar({ title: $r('app.string.progress_name') })
      Text($r('app.string.progress_linear'))
        .leftTitleStyle()
      Column() {
        Column({ space: 15 }) {
          Progress({ value: this.progress, type: ProgressType.Linear }).width(200)
          Progress({ value: this.progress, total: 150, type: ProgressType.Linear })
            .color(Color.Grey)
            .width(200)
        }
      }.cardStyle()

      Text($r('app.string.progress_eclipse'))
        .leftTitleStyle()
      Column() {
        Row({ space: 40 }) {
          Progress({ value: this.progress, type: ProgressType.Eclipse }).width(50)
          Progress({ value: this.progress, total: 150, type: ProgressType.Eclipse }).width(50)
            .color(Color.Grey)
        }
      }.cardStyle()

      Text($r('app.string.progress_scalering'))
        .leftTitleStyle()
      Column({ space: 10 }) {
        Row({ space: 20 }) {
          Progress({ value: this.progress, type: ProgressType.ScaleRing }).width(50)
          Progress({ value: this.progress, total: 150, type: ProgressType.ScaleRing })
            .color(Color.Grey).width(50)
            .style({ strokeWidth: 15, scaleCount: 15, scaleWidth: 5 })
          Progress({ value: this.progress, total: 150, type: ProgressType.ScaleRing })
            .color(Color.Grey).width(50)
            .style({ strokeWidth: 20, scaleCount: 20, scaleWidth: 5 })
          Progress({ value: this.progress, total: 150, type: ProgressType.ScaleRing })
            .color(Color.Grey).width(50)
            .style({ strokeWidth: 20, scaleCount: 30, scaleWidth: 3 })
        }
      }.cardStyle()

      Text($r('app.string.progress_ring'))
        .leftTitleStyle()
      Column() {
        Row({ space: 40 }) {
          Progress({ value: this.progress, type: ProgressType.Ring }).width(50)
          Progress({ value: this.progress, total: 150, type: ProgressType.Ring })
            .color(Color.Grey).width(50)
            .style({ strokeWidth: 10, scaleCount: 30, scaleWidth: 20 })
        }
      }.cardStyle()

      Text($r('app.string.progress_capsule'))
        .leftTitleStyle()
      Column() {
        Row({ space: 40 }) {
          Progress({ value: this.progress, type: ProgressType.Capsule }).width(100).height(50)
          Progress({ value: this.progress, total: 150, type: ProgressType.Capsule })
            .color(Color.Grey)
            .width(100)
            .height(50)
        }
      }
      .cardStyle()
      .width('100%')

      Text($r('app.string.progress_change'))
        .leftTitleStyle()
      Column() {
        Row({ space: 10 }) {
          Slider({
            value: this.progress,
            min: 0,
            max: 100,
            style: SliderStyle.OutSet
          })
            .onChange((value: number) => {
              this.progress = value
            })
        }
      }
      .cardStyle()
      .width('100%')
    }.height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .padding({ left: 20, right: 20 })
  }
}