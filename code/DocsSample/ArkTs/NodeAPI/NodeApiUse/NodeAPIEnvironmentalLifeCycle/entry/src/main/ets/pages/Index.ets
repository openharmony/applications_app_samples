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
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiSetInstanceData',
    '2.napiGetInstanceData'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 3 })
      List({ space: '10vp' }) {
        ForEach(this.items, (item: string) => {
          ListItem() {
            Text(item)
              .fontSize(16)
              .width('100%')
              .height(60)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)
              .borderRadius(30)
              .backgroundColor(Color.White)
              .onClick(() => {
                if (item === 'Reset Result Message') {
                  this.result = '';
                } else if (item === '1.napiSetInstanceData') {
                  // napi_set_instance_data
                  let data = 5;
                  let value = testNapi.setInstanceData(data);
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_instance_data:%{public}s', value);
                  this.result = 'napiSetInstanceDataSuccess';
                } else if (item === '2.napiGetInstanceData') {
                  // napi_get_instance_data
                  let data = 5;
                  testNapi.setInstanceData(data);
                  let value = testNapi.getInstanceData();
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_set_instance_data:%{public}d', value);
                  this.result = 'napiGetInstanceDataSuccess';
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}
