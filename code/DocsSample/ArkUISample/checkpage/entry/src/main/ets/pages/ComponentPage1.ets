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
import { hilog } from '@kit.PerformanceAnalysisKit';

//[Start componentIdentifier_start]
@Entry
@Component
struct ComponentPage {
  build() {
    Column() {
      Text('Hello World')
        .fontSize(20)
        .id('TEXT')
        .onClick(() => {
          hilog.info(0x0000,`Text is clicked`, 'isClicked');
        })
      Button('getInspectorByKey').onClick(() => {
        let result = getInspectorByKey('TEXT');
        hilog.info(0x0000,`result is ${result}`, 'result');
      })
      Button('getInspectorTree').onClick(() => {
        let result = getInspectorTree();
        hilog.info(0x0000,`result is ${JSON.stringify(result)}`, 'result');
      })
      Button('sendEventByKey').onClick(() => {
        sendEventByKey('TEXT', 10, '');
      })
    }
    .width('100%')
    .height('100%')
  }
}

//[End componentIdentifier_start]