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

import hilog from '@ohos.hilog';
import worker from '@ohos.worker';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State result: string = '';
  private items: string[] = [
    'Reset Result Message',
    '1.napiRemoveEnvCleanupHook',
    '2.napiRemoveAsyncCleanupHook'
  ];

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
                } else if (item === '1.napiRemoveEnvCleanupHook') {
                  let wk = new worker.ThreadWorker('entry/ets/workers/worker.ts');
                  // 发送消息到worker线程
                  wk.postMessage('test NapiEnvCleanUpHook');
                  // 处理来自worker线程的消息
                  wk.onmessage = (message) => {
                    hilog.info(0x0000, 'testTag', 'Test Node-API message from worker: %{public}s',
                      JSON.stringify(message));
                    wk.terminate();
                  };
                  this.result = 'napiRemoveEnvCleanupHookSuccess';
                } else if (item === '2.napiRemoveAsyncCleanupHook') {
                  try {
                    hilog.info(0x0000, 'testTag', 'Test Node-API napi_add_async_cleanup_hook: %{public}s',
                      testNapi.napiAsyncCleanUpHook());
                    this.result = 'napiRemoveAsyncCleanupHookSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag',
                      'Test Node-API napi_add_async_cleanup_hook error.message: %{public}s',
                      error.message);
                    this.result = 'napiRemoveAsyncCleanupHookFail';
                  }
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
