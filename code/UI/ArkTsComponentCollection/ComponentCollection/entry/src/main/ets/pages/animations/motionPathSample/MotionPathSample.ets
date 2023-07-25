/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { TitleBar } from '../../../common/TitleBar';

@Entry
@Component
struct MotionPathSample {
  @State toggle: boolean = true;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.motion_path') })
      Scroll() {
        Column() {
          Button($r('app.string.motion_path_click_me'))
            .margin(50)
            .motionPath({
              path: 'Mstart.x start.y L300 200 L300 500 Lend.x end.y',
              from: 0.0,
              to: 1.0,
              rotatable: true
            })
            .onClick(() => {
              animateTo({ duration: 4000, curve: Curve.Linear }, () => {
                this.toggle = !this.toggle; // 通过this.toggle变化组件的位置
              })
            })
            .id('motion_click')
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius(24)
        .backgroundColor(Color.White)
        .height(400)
        .width('100%')
        .margin({ left: 12, right: 12 })
        .alignItems(this.toggle ? HorizontalAlign.Start : HorizontalAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}