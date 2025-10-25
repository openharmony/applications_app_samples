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

import router from '@kit.ArkUI';

@Entry
@Component
struct RenderTest {
  build() {
    Column() {
      Row() {
        Button('attribute modifier')
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({url:'pages/AttModifier'});
          })
        Button('attribute update')
          .margin({ bottom: 200, right: 12 })
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({url:'pages/AttUpdate'});
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}