/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { UIContext } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Column() {
        // app.string.Linear_Gradient_Effect资源文件中的value值为'点击线性渐变效果'
        Text($r('app.string.Linear_Gradient_Effect')).backgroundColor(Color.Green)
      }.width('100%').height(50)
      .onClick(() => {
        const uiContext: UIContext = this.getUIContext();
        const router = uiContext.getRouter();
        router.pushUrl({ url: 'homePage/LinearGradientEffect' });
      })

      Column() {
        // app.string.Direction_Gradient_Effect资源文件中的value值为'点击角度渐变效果'
        Text($r('app.string.Direction_Gradient_Effect')).backgroundColor(Color.Green)
      }.width('100%').height(50)
      .onClick(() => {
        const uiContext: UIContext = this.getUIContext();
        const router = uiContext.getRouter();
        router.pushUrl({ url: 'homePage/DirectionGradientEffect' });
      })

      Column() {
        // app.string.Radial_Gradient_Effect资源文件中的value值为'点击径向渐变效果'
        Text($r('app.string.Radial_Gradient_Effect')).backgroundColor(Color.Green)
      }.width('100%').height(50)
      .onClick(() => {
        const uiContext: UIContext = this.getUIContext();
        const router = uiContext.getRouter();
        router.pushUrl({ url: 'homePage/RadialGradientEffect' });
      })
    }
  }
}