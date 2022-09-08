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
struct GridContainerSample {
  build() {
    Row() {
      GridRow({ columns: 24 }) {
        GridCol({ span: { xs: 4, sm: 4, md: 2, lg: 2 }, offset: 0 }) {
          Row() {
            Text($r('app.string.left'))
              .fontSize(25)
          }
          .height('100%')
          .backgroundColor(0x66bbb2cb)
        }

        GridCol({ span: { xs: 12, sm: 12, md: 15, lg: 15 }, offset: { xs: 2, sm: 2, md: 1, lg: 1 } }) {
          Row() {
            Text($r('app.string.center'))
              .fontSize(25)
          }
          .height('100%')
          .backgroundColor(0x66b6c5d1)
        }

        GridCol({ span: { xs: 4, sm: 4, md: 5, lg: 5 }, offset: { xs: 2, sm: 2, md: 1, lg: 1 } }) {
          Row() {
            Text($r('app.string.right'))
              .fontSize(25)
          }
          .height('100%')
          .backgroundColor(0x66bbb2cb)
        }
      }
      .height(200)
      .backgroundColor(0xf1f3f5)
      .margin({ top: 10 })
      .padding({ left: 14, right: 14 })
    }
    .padding({ left: 10, right: 10 })
  }
}