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
import window from '@ohos.window';

@Entry
@Component
struct NavigationModeChange {
  isLandscape: window.Orientation = window.Orientation.PORTRAIT;
  @State mode: NavigationMode = NavigationMode.Stack;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navigation_modechange_title') })

      Navigation()
        .hideTitleBar(true)
        .backgroundColor(Color.White)
        .borderRadius(24)
        .height('40%')
        .width('93%')
        .mode(NavigationMode.Auto)
        .onNavigationModeChange((mode: NavigationMode) => {
          this.mode = mode;
        })

      Row() {
        Column() {
          Row() {
            Text($r('app.string.navigation_modevalue'))
              .fontSize(16)
              .fontWeight('500')
            Blank()
            Text(this.mode === NavigationMode.Stack ? 'Stack' : 'Split')
              .fontSize(14)
          }
          .height(48)
          .width('100%')

          Row() {
            Text($r('app.string.navigation_mode_callback'))
              .fontSize(16)
              .fontWeight('500')
            Blank()
            Text(this.mode === NavigationMode.Stack ? 'Stack' : 'Split')
              .fontSize(14)
          }
          .height(48)
          .width('100%')
        }
      }
      .borderRadius(24)
      .backgroundColor(Color.White)
      .width('93%')
      .margin({ top: 12 })
      .padding({ left: 12, right: 12, top: 4, bottom: 4 })

      Button() {
        Text($r('app.string.navigation_rotate_screen'))
          .height(28)
          .fontSize(12)
          .borderRadius(14)
      }
      .width('88%')
      .margin({ top: 12 })
      .onClick(() => {
        let context = getContext(this);
        window.getLastWindow(context).then((lastWindow) => {
          this.isLandscape = (this.isLandscape === window.Orientation.PORTRAIT) ? window.Orientation.LANDSCAPE : window.Orientation.PORTRAIT;
          lastWindow.setPreferredOrientation(this.isLandscape);
        });
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}