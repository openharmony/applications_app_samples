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

import lock from '@ohos.runningLock'
import { LockSwitch } from '../common/lockSwitch'
import Logger from '../util/Logger'

const TAG: string = 'RunningLock'

@Entry
@Component
struct Index {
  @State output: Resource = $r('app.string.init_output')
  @State timeOut: number = 5000
  @State backgroundColor: Color = Color.White
  @State isDelayTime: boolean = true

  build() {
    Column() {
      Text($r('app.string.entry_MainAbility'))
        .width('100%')
        .height(50)
        .textAlign(TextAlign.Start)
        .fontColor(Color.White)
        .padding({ left: 10, top: 10 })
        .fontSize(30)
        .backgroundColor('#0D9FFB')

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
            .backgroundColor('#0D9FFB')
            .onClick(() => {
              lock.isRunningLockTypeSupported(lock.RunningLockType.BACKGROUND, (error, supported) => {
                if (typeof error === 'undefined') {
                  Logger.info(TAG, `BACKGROUND support status is: ${supported}`)
                  this.output = $r('app.string.supportLock')
                } else {
                  Logger.info(TAG, `error: ${error}`)
                  this.output = $r('app.string.unSupportLock')
                }
              })
            })

            Button() {
              Text($r('app.string.timingOut_screen'))
                .fontSize(15)
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
            }
            .key('timingOut')
            .backgroundColor('#0D9FFB')
            .width(200)
            .height(50)
            .margin({ left: 10, right: 5, top: 20 })
            .onClick(() => {
              if (this.isDelayTime === true) {
                setTimeout(() => {
                  this.backgroundColor = Color.Black
                }, this.timeOut)
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
    .backgroundColor(this.backgroundColor)
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.backgroundColor = Color.White
      }
    })
  }
}