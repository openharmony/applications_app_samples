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
struct NavigationExpandSafeArea {
  @State expand: boolean = false;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navigation_expand_title') })
      Button() {
        Text($r('app.string.navigation_unexpand'))
          .height(28)
          .fontSize(12)
          .borderRadius(14)
      }
      .width('88%')
      .margin({ bottom: '2%' })
      .backgroundColor(this.expand ? $r('app.color.background_grey') : $r('app.color.button_default_bg_color'))
      .onClick(() => {
        this.expand = !this.expand;
      })

      Navigation()
        .hideTitleBar(true)
        .backgroundColor(Color.White)
        .borderRadius(24)
        .height('88%')
        .width('93%')
        .expandSafeArea(this.expand ? [SafeAreaType.SYSTEM] : [SafeAreaType.CUTOUT], this.expand ? [SafeAreaEdge.BOTTOM] : [SafeAreaEdge.START])
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}