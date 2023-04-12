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

import { WorkSchedulerSystem } from '../feature/WorkSchedulerSystem'
import promptAction from '@ohos.promptAction'

const VERSION: string = '1.0'
const FONT_WEIGHT: number = 700
const LASTEST_VERSION: string = '1.1'

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
            .fontSize(20)
            .fontColor($r('app.color.fontColor'))
        }
        .margin({ top: 10 })

        Column() {
          Row() {
            Column({ space: 10 }) {
              Text($r('app.string.title1'))
                .fontSize(16)
                .fontWeight(FONT_WEIGHT)

              Text(VERSION === LASTEST_VERSION ? $r('app.string.isLatest') : LASTEST_VERSION)
                .fontSize(16)
                .fontColor($r('app.color.fontColor'))
            }
            .flexShrink(1)
            .flexGrow(1)
            .alignItems(HorizontalAlign.Start)

            Image($r('app.media.right'))
              .width(20)
              .height(20)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Divider()
            .width('100%')
            .strokeWidth(0.5)
            .color($r('app.color.fontColor'))
            .margin({ top: 12, bottom: 12 })

          Row() {
            Column({ space: 10 }) {
              Text($r('app.string.title2'))
                .fontSize(16)
                .fontWeight(FONT_WEIGHT)

              Text('https://www.openharmony.cn')
                .fontSize(16)
                .fontColor($r('app.color.fontColor'))
            }
            .flexShrink(1)
            .flexGrow(1)
            .alignItems(HorizontalAlign.Start)

            Image($r('app.media.right'))
              .width(20)
              .height(20)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.is_develop') })
          })

          Divider()
            .width('100%')
            .strokeWidth(0.5)
            .color($r('app.color.fontColor'))
            .margin({ top: 12, bottom: 12 })

          Row() {
            Column({ space: 10 }) {
              Text($r('app.string.title3'))
                .fontSize(16)
                .fontWeight(FONT_WEIGHT)

              Text('web@openharmony.io')
                .fontSize(16)
                .fontColor($r('app.color.fontColor'))
            }
            .flexShrink(1)
            .flexGrow(1)
            .alignItems(HorizontalAlign.Start)

            Image($r('app.media.right'))
              .width(20)
              .height(20)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            promptAction.showToast({ message: $r('app.string.is_develop') })
          })
        }
        .width('100%')
        .padding(12)
        .margin({ top: 50 })
        .backgroundColor(Color.White)
        .borderRadius(16)

      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .backgroundColor($r('app.color.bg1'))
      .padding({ left: 12, right: 12 })

      if (this.isShowDialog) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Black)
          .opacity(.5)
          .position({ x: 0, y: 0 })

        Column() {
          Column() {
            Row() {
              Text($r('app.string.dialogTitle'))
                .fontSize(20)
                .letterSpacing(1)
            }.padding({ top: 30, bottom: 30 })

            Row() {
              Text($r('app.string.btn1'))
                // 弹窗按钮需要占据一半宽度，这里使用50%
                .width('50%')
                .padding({ top: 10, bottom: 10 })
                .textAlign(TextAlign.Center)
                .fontSize(16)
                .letterSpacing(1)
                .backgroundColor($r('app.color.btn1'))
                .onClick(() => {
                  this.isShowDialog = false
                  WorkSchedulerSystem.publishNotification('permission', 'allow', 'allow install hap to update the application')
                })

              Text($r('app.string.btn2'))
                // 弹窗按钮需要占据一半宽度，这里使用50%
                .width('50%')
                .textAlign(TextAlign.Center)
                .padding({ top: 10, bottom: 10 })
                .fontSize(16)
                .letterSpacing(1)
                .backgroundColor($r('app.color.btn2'))
                .onClick(() => {
                  this.isShowDialog = false
                })
            }
          }
          .borderWidth(1)
          .borderColor($r('app.color.btn2'))
          .borderRadius(20)
          .backgroundColor(Color.White)
          .clip(true)
        }
        .padding(20)
        .position({ x: 0, y: '40%' })
      }
    }
  }
}