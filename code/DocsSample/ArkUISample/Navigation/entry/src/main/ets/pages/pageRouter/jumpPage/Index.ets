/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start jump_click]
import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0xF811;
const TAG = '[Sample_ArkTSRouter]';

@Entry
@Component
struct Index {
  // 在Home页面中
  onJumpClick(): void {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/pageRouter/jumpPage/Detail' // 目标url
    }, router.RouterMode.Standard, (err) => {
      if (err) {
        hilog.error(DOMAIN, TAG,`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.info(DOMAIN, TAG,'Invoke pushUrl succeeded.');
    });
  }

  build() {
    // [StartExclude jump_click]
    Row() {
      Column() {
        Text('Home Page')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('Jump to Detail', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.onJumpClick();
          })
      }.width('100%')
    }.height('100%')
    // [EndExclude jump_click]
  }
}
// [End jump_click]