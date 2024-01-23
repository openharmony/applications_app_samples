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
struct ListExpandSafeArea {
  private counts: number[] = [];
  @State expand: boolean = false;

  aboutToAppear() {
    for (let i = 0; i < 20; i++) {
      this.counts.push(i);
    }
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navigation_list_expand_title') })
      Button() {
        Text($r('app.string.navigation_expand'))
          .height(28)
          .fontSize(12)
          .borderRadius(14)
      }
      .width('88%')
      .margin({ bottom: '2%' })
      .backgroundColor(this.expand ? $r('app.color.button_default_bg_color') : $r('app.color.background_grey'))
      .onClick(() => {
        this.expand = !this.expand;
      })

      List({ space: 12, initialIndex: 0 }) {
        ForEach(this.counts, () => {
          ListItem() {
            Row() {
              Text('Single list')
                .fontSize(16)
            }
            .height(48)
            .margin({ left: 24 })
          }
        })
      }
      .backgroundColor(Color.White)
      .borderRadius(24)
      .height('88%')
      .width('93%')
      .padding({ top: '5%' })
      .expandSafeArea(this.expand ? [SafeAreaType.SYSTEM] : [], this.expand ? [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM] : [])
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}