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


import XComponentContext from "../interface/XComponentContext";

const TAG = '[Sample_DrawingAPI]';

@Entry
@Component
struct Index {
  private xComponentContext: XComponentContext | undefined = undefined;

  build() {
    Column() {
      Row() {
        XComponent({ id: 'xcomponentId', type: XComponentType.SURFACE, libraryname: 'entry' })
          .onLoad((xComponentContext) => {
            this.xComponentContext = xComponentContext as XComponentContext;
          }).width('640px') // Multiples of 64
          .backgroundColor(Color.White)
      }.height('88%')
      Row() {
        Button($r("app.string.Button_label"))
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ bottom: 24, left: 12 })
          .onClick(() => {
            console.log(TAG, "draw text click");
            if (this.xComponentContext) {
              console.log(TAG, "draw text");
              this.xComponentContext.drawText();
            }
          })
          .width('33.6%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}
