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

// [Start prevent_bubbling]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_MultipleFingerInformation]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyApp_MultipleFingerInformation';

@Entry
@ComponentV2
struct PreventBubbling {
  build() {
    RelativeContainer() {
      Column() { // 父组件
        //$r('app.string.xxx')需要替换为开发者所需的资源文件
        Text($r('app.string.preventEvent'))
          .fontColor(Color.White)
          .height('40%')
          .width('80%')
          .backgroundColor(Color.Brown)
          .alignSelf(ItemAlign.Center)
          .padding(10)
          .margin(20)
          .onTouch((event: TouchEvent) => {
            event.stopPropagation(); // 子组件优先接收到触摸事件后，阻止父组件接收事件
          })
      }
      .justifyContent(FlexAlign.End)
      .backgroundColor(Color.Green)
      .height('100%')
      .width('100%')
      .onTouch((event: TouchEvent) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'touch event received on parent');
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End prevent_bubbling]