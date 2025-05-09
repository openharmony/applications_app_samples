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
    '1.napiCreateBuffer',
    '2.napiCreateBufferCopy',
    '3.napiCreateExternalBuffer',
    '4.napiGetBufferInfo',
    '5.napiIsBuffer',
    '6.napiCreateExternalArraybuffer'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(20)
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
                } else if (item === '1.napiCreateBuffer') {
                  // napi_create_buffer
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_buffer: %{public}s',
                      testNapi.createBuffer().toString());
                    this.result = 'napiCreateBufferSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_create_buffer error');
                    this.result = 'napiCreateBufferFail';
                  }
                } else if (item === '2.napiCreateBufferCopy') {
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_buffer_copy: %{public}s',
                      testNapi.createBufferCopy().toString());
                    this.result = 'napiCreateBufferCopySuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_create_buffer_copy error');
                    this.result = 'napiCreateBufferCopyFail';
                  }
                } else if (item === '3.napiCreateExternalBuffer') {
                  // napi_create_external_buffer
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_create_external_buffer: %{public}s',
                      testNapi.createExternalBuffer()
                        .toString());
                    this.result = 'napiCreateExternalBufferSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_create_external_buffer error');
                    this.result = 'napiCreateExternalBufferFail';
                  }
                } else if (item === '4.napiGetBufferInfo') {
                  // napi_get_buffer_info
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_get_buffer_info: %{public}s',
                      testNapi.getBufferInfo().toString());
                    this.result = 'napiGetBufferInfoSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API napi_get_buffer_info error');
                    this.result = 'napiGetBufferInfoFail';
                  }
                } else if (item === '5.napiIsBuffer') {
                  // napi_is_buffer
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_buffer: %{public}s',
                      JSON.stringify(testNapi.isBuffer()));
                    this.result = 'napiIsBufferSuccess';
                  } catch (error) {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_is_buffer error');
                    this.result = 'napiIsBufferFail';
                  }
                } else if (item === '6.napiCreateExternalArraybuffer') {
                  // napi_create_external_arraybuffer
                  hilog.info(0x0000, 'testTag', 'Node-API createExternalArraybuffer: %{public}s',
                    JSON.stringify(testNapi.createExternalArraybuffer()));
                  this.result = 'napiCreateExternalArraybufferSuccess';
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
