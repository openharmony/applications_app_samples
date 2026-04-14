/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 

﻿export enum Direction {
  VOLUME,
  BRIGHTNESS,
}

// 弹窗组件
@Component
export struct BrightnessComponent {
  @Prop sliderMaxValue: number = 100 // 最大值
  @Prop brightValue: number = 50 // 当前值
  @Prop control: Direction = Direction.BRIGHTNESS // 判断是声音还是亮度

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Text(this.brightValue.toString())
        .fontSize('42lpx')
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)
      Column() {
        Flex({ direction: FlexDirection.ColumnReverse, justifyContent: FlexAlign.SpaceEvenly }) {
          ForEach(new Array(this.sliderMaxValue / 2).fill(0), (item: number, index: number) => {
            Row()
              .width(Math.floor(this.brightValue / 2) - 1 === index ? '40lpx' : '20lpx')

              .height(1)
              .backgroundColor(Math.floor(this.brightValue / 2) <= index ? '#40FFFFFF' : '#867EA9FF')
          }, (item: number, index: number) => item.toString() + index.toString()
          )
        }
      }
      .margin({ top: '16lpx', bottom: '16lpx', left: this.brightValue < 2 ? 0 : '18lpx' })

      Image(this.brightValue === 0 ? $r('app.media.ic_brightness_gray') : $r('app.media.ic_brightness'))
        .height('44lpx')
    }
    .width('100%')
    .height('100%')
  }
}