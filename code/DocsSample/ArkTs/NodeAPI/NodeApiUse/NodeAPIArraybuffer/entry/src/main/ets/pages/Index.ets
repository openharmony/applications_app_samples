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
    '1.napiIsArraybuffer',
    '2.napiGetArraybufferInfo',
    '3.napiDetachArraybuffer',
    '4.napiCreateArraybuffer'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
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
                } else if (item === '1.napiIsArraybuffer') {
                  // [Start ark_napi_is_arraybuffer]
                  // napi_is_arraybuffer
                  try {
                    let value = new ArrayBuffer(1);
                    let data = "123";
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_arraybuffer: %{public}s',
                      testNapi.isArrayBuffer(value));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_arraybuffer: %{public}s',
                      testNapi.isArrayBuffer(data));
                    // [StartExclude ark_napi_is_arraybuffer]
                    this.result = 'napiIsArraybufferSuccess';
                    // [EndExclude ark_napi_is_arraybuffer]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_arraybuffer error: %{public}s',
                      error.message);
                    // [StartExclude ark_napi_is_arraybuffer]
                    this.result = 'napiIsArraybufferFail';
                    // [EndExclude ark_napi_is_arraybuffer]
                  }
                  // [End ark_napi_is_arraybuffer]
                } else if (item === '2.napiGetArraybufferInfo') {
                  // [Start ark_napi_get_arraybuffer_info
                  // napi_get_arraybuffer_info
                  const buffer = new ArrayBuffer(10);
                  hilog.info(0x0000, 'testTag', 'Test Node-API get_arraybuffer_info:%{public}s ',
                    JSON.stringify(testNapi.getArraybufferInfo(buffer)));
                  // [End ark_napi_get_arraybuffer_info]
                  this.result = 'napiGetArraybufferInfoSuccess';
                } else if (item === '3.napiDetachArraybuffer') {
                  // [Start ark_napi_detach_arraybuffer]
                  // napi_detach_arraybuffer and napi_is_detached_arraybuffer
                  try {
                    const bufferArray = new ArrayBuffer(8);
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_detached_arraybuffer one: %{public}s',
                      testNapi.isDetachedArraybuffer(bufferArray));
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_detached_arraybuffer two: %{public}s ',
                      testNapi.isDetachedArraybuffer(testNapi.detachedArraybuffer(bufferArray)));
                    // [StartExclude ark_napi_detach_arraybuffer]
                    this.result = 'napiDetachArraybufferSuccess';
                    // [EndExclude ark_napi_detach_arraybuffer]
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_is_detached_arraybuffer error: %{public}s',
                      error.message);
                    // [StartExclude ark_napi_detach_arraybuffer]
                    this.result = 'napiDetachArraybufferFail';
                    // [EndExclude ark_napi_detach_arraybuffer]
                  }
                  // [End ark_napi_detach_arraybuffer]
                } else if (item === '4.napiCreateArraybuffer') {
                  // [Start ark_napi_create_arraybuffer]
                  // napi_create_arraybuffer
                  hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_arraybuffer:%{public}s',
                    testNapi.createArraybuffer(10).toString());
                  // [End ark_napi_create_arraybuffer]
                  this.result = 'napiCreateArraybufferSuccess';
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}