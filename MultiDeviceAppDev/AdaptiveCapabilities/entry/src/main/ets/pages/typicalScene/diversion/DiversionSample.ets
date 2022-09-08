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
  @State currentBreakPoint: string = 'sm'

  build() {
    Row() {
      GridRow({ columns: 24 }) {
        GridCol({ span: { xs: 2, sm: 24, md: 12, lg: 12 } }) {
          Column() {
            Row() {
              Image($r('app.media.illustrator'))
            }
            .width('100%')
            .aspectRatio(1)
          }
          .width('100%')
          .height('100%')
          .justifyContent((this.currentBreakPoint === 'xs' || this.currentBreakPoint === 'sm') ? FlexAlign.End : FlexAlign.Center)
        }

        GridCol({ span: { xs: 2, sm: 24, md: 12, lg: 12 } }) {
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
          .padding({ left: 24, right: 24 })
          .height('100%')
          .justifyContent((this.currentBreakPoint === 'xs' || this.currentBreakPoint === 'sm') ? FlexAlign.Start : FlexAlign.Center)
        }
      }
      .onBreakpointChange((breakPoint: string) => {
        this.currentBreakPoint = breakPoint
      })
    }
    .height('100%')
    .alignItems((VerticalAlign.Center))
    .backgroundColor('#F1F3f5')
  }
}