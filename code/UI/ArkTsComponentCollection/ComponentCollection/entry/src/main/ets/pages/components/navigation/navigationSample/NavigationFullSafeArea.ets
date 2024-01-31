/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { TitleBar } from '../../../../common/TitleBar';

@Entry
@Component
struct NavigationFullSafeArea {
  @State type: SafeAreaType[] = [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD];
  @State edge: SafeAreaEdge[] = [SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END];

  build() {
    Column() {
      Navigation() {
        TitleBar({ title: $r('app.string.navigation_safearea_title') })
        Row() {
          Text($r('app.string.navigation_safearea_default'))
            .fontSize(16)
          Blank()
          Radio({ value: 'default', group: 'safearea' })
            .onChange((checked: boolean) => {
              if (checked) {
                this.type = [SafeAreaType.SYSTEM, SafeAreaType.CUTOUT, SafeAreaType.KEYBOARD];
                this.edge = [SafeAreaEdge.BOTTOM, SafeAreaEdge.START, SafeAreaEdge.END];
              }
            })
            .checked(true)
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
        .height(48)

        Divider()
          .margin({ left: 12, right: 12 })

        Row() {
          Text($r('app.string.navigation_safearea_expand'))
            .fontSize(16)
          Blank()
          Radio({ value: 'expand', group: 'safearea' })
            .onChange((checked: boolean) => {
              if (checked) {
                this.type = [SafeAreaType.SYSTEM];
                this.edge = [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM];
              }
            })
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
        .height(48)

        Divider()
          .margin({ left: 12, right: 12 })

        Row() {
          Text($r('app.string.navigation_safearea_unexpand'))
            .fontSize(16)
          Blank()
          Radio({ value: 'unexpand', group: 'safearea' })
            .onChange((checked: boolean) => {
              if (checked) {
                this.type = [];
                this.edge = [];
              }
            })
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
        .height(48)
      }
      .hideTitleBar(true)
      .backgroundColor(Color.White)
      .borderRadius(24)
      .height('100%')
      .width('93%')
      .expandSafeArea(this.type, this.edge)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}