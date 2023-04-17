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

import { LockSwitch } from '../common/LockSwitch'
import Logger from '../util/Logger'
import runningLock from '@ohos.runningLock'

const TAG: string = 'RunningLock'
const TIMEOUT: number = 5000

@Entry
@Component
struct Index {
  @State output: Resource = $r('app.string.init_output')
  @State indexBackgroundColor: Color = Color.White
  @State isDelayTime: boolean = true

  build() {
    Column() {
      Text($r('app.string.EntryAbility_label'))
        .width('100%')
        .height(50)
        .textAlign(TextAlign.Start)
        .fontColor(Color.White)
        .padding({ left: 10, top: 10 })
        .fontSize(30)
        .backgroundColor($r('app.color.main_background'))

      Scroll() {
        Column() {
          Row() {
            Text(this.output)
              .fontSize(15)
              .fontColor(Color.Red)
              .maxLines(10)
              .margin({ left: 10 })
              .fontWeight(FontWeight.Bold)
          }
          .width(340)
          .height(290)
          .margin({ top: 10, left: 10 })
          .border({ width: 2, radius: 5, color: Color.Gray })

          Column() {
            Button() {
              Text($r('app.string.search_support'))
                .fontSize(15)
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
            }
            .key('searchSupport')
            .type(ButtonType.Capsule)
            .width(200)
            .height(50)
            .margin({ left: 10, right: 5, top: 20 })
            .backgroundColor($r('app.color.main_background'))
            .onClick(() => {
              let isSupported = runningLock.isSupported(runningLock.RunningLockType.BACKGROUND)
              if (isSupported) {
                this.output = $r('app.string.supportLock')
              } else {
                this.output = $r('app.string.unSupportLock')
              }
            })

            Button() {
              Text($r('app.string.timingOut_screen'))
                .fontSize(15)
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
            }
            .key('timingOut')
            .backgroundColor($r('app.color.main_background'))
            .width(200)
            .height(50)
            .margin({ left: 10, right: 5, top: 20 })
            .onClick(() => {
              if (this.isDelayTime === true) {
                setTimeout(() => {
                  this.indexBackgroundColor = Color.Black
                }, TIMEOUT)
              }
            })

            LockSwitch({ output: $output, isDelayTime: $isDelayTime })
          }
          .width('100%')
        }
        .width('100%')
      }
      .width('100%')
      .height('85%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.indexBackgroundColor)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.indexBackgroundColor = Color.White
      }
    })
  }
}