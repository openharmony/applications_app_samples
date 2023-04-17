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

@Entry
@Component
struct DiversionSample {
  @State currentBreakpoint: string = 'md'
  @State imgHeight: number = 0
  @State textHeight: number = 0

  build() {
    Row() {
      GridRow() {
        GridCol({ span: { sm: 12, md: 6, lg: 6 } }) {
          Column() {
            Row() {
              Image($r('app.media.illustrator'))
            }
            .width('100%')
            .aspectRatio(1)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .onAreaChange((oldArea: Area, newArea: Area) => {
          this.imgHeight = newArea.height as number
        })

        GridCol({ span: { sm: 12, md: 6, lg: 6 } }) {
          Column() {
            Text($r('app.string.user_improvement'))
              .textAlign(TextAlign.Center)
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
            Text($r('app.string.user_improvement_tips'))
              .textAlign(TextAlign.Center)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
          }
          .onAreaChange((oldArea: Area, newArea: Area) => {
            this.textHeight = newArea.height as number
          })
          .padding({ left: 24, right: 24 })
          .justifyContent(FlexAlign.Center)
        }
        .padding({ top: this.currentBreakpoint === 'sm' ? 0 : (this.imgHeight - this.textHeight) / 2 })
      }
      .onBreakpointChange((breakPoint: string) => {
        this.currentBreakpoint = breakPoint
      })
    }
    .height('100%')
    .backgroundColor('#F1F3f5')
  }
}