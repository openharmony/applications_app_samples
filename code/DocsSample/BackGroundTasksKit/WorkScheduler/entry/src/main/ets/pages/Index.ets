/*
 * Copyright (c) 2023-2026 Huawei Device Co., Ltd.
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

import { WorkSchedulerSystem } from '../feature/WorkSchedulerSystem'
import { promptAction } from '@kit.ArkUI'

const VERSION: string = '1.0'
const FONT_WEIGHT: number = 700
const MODULE: string = 'WorkSchedulerSample'
@Entry
@Component
struct Index {
  @StorageLink('isShowDialog') isShowDialog: boolean = false

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.sampleName'))
            .fontSize(20)
            .fontColor($r('app.color.fontColor'))
            .fontWeight(FONT_WEIGHT)
            .margin({ top: 10 })
        }
        .width('100%')
        .padding({ top: 10 })

        Image($r('app.media.app_icon'))
          .width(100)
          .height(100)
          .margin({ top: 100 })

        Row() {
          Text($r('app.string.version'))
            .fontSize(20)
            .fontColor($r('app.color.fontColor'))

          Text(`：${VERSION}`)
            .id('version')
            .fontSize(20)
            .fontColor($r('app.color.fontColor'))
        }
        .margin({ top: 10 })

        Column() {
          Row() {
            Column({ space: 10 }) {
              Button($r('app.string.title2'))
                .id('btn_start_work')
                .fontSize(25)
                .fontWeight(FONT_WEIGHT)
            }
            .flexShrink(1)
            .flexGrow(1)
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            WorkSchedulerSystem.startUpdateSample(VERSION, MODULE);
          })

          Divider()
            .width('100%')
            .strokeWidth(0.5)
            .color($r('app.color.fontColor'))
            .margin({ top: 12, bottom: 12 })

          Row() {
            Column({ space: 10 }) {
              Button($r('app.string.title3'))
                .id('btn_stop_work')
                .fontSize(25)
                .fontWeight(FONT_WEIGHT)
            }
            .flexShrink(1)
            .flexGrow(1)
            .alignItems(HorizontalAlign.Center)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            WorkSchedulerSystem.stopWork(VERSION, MODULE);
          })
        }
        .width('100%')
        .padding(12)
        .margin({ top: 50 })
        .borderRadius(16)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .backgroundColor($r('app.color.bg1'))
      .padding({ left: 12, right: 12 })
    }
  }
}