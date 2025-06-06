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
    '1.napiCreateDate',
    '2.napiGetDateValue',
    '3.napiIsDate'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(25)
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
                } else if (item === '1.napiCreateDate') {
                  // [Start ark_napi_create_date]
                  // napi_create_date
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_date: %{public}s',
                    testNapi.createDate().toString());
                  // [End ark_napi_create_date]
                  this.result = 'napiCreateDateSuccess';
                } else if (item === '2.napiGetDateValue') {
                  // [Start ark_napi_get_date_value]
                  // napi_get_date_value
                  try {
                    const date = new Date();
                    hilog.info(0x0000, 'testTag', 'Node-API: output the Unix Time Stamp: %{public}d', date.getTime());
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_date_value: %{public}d',
                      testNapi.getDateValue(date));
                    // [StartExclude ark_napi_get_date_value]
                    this.result = 'napiGetDateValueSuccess';
                    // [EndExclude ark_napi_get_date_value]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_get_date_value error: %{public}s',
                      error.message);
                    // [StartExclude ark_napi_get_date_value]
                    this.result = 'napiGetDateValueFail';
                    // [EndExclude ark_napi_get_date_value]
                  }
                  // [End ark_napi_get_date_value]
                } else if (item === '3.napiIsDate') {
                  // [Start ark_napi_is_date]
                  // napi_is_date
                  try {
                    let now: Date = new Date();
                    let date = "123";
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_date: %{public}s', testNapi.isDate(now));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_date: %{public}s', testNapi.isDate(date));
                    // [StartExclude ark_napi_is_date]
                    this.result = 'napiIsDateSuccess';
                    // [EndExclude ark_napi_is_date]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_date error: %{public}s', error.message);
                    // [StartExclude ark_napi_is_date]
                    this.result = 'napiIsDateFail';
                    // [EndExclude ark_napi_is_date]
                  }
                  // [End ark_napi_is_date]
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
