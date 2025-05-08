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
    '1.napiIsPromise',
    '2.napiDeferred'
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
                } else if (item === '1.napiIsPromise') {
                  // [Start ark_napi_is_promise]
                  // napi_is_promise
                  let value = Promise.resolve();
                  // 传入的对象为Promise时，返回true，否则返回false
                  hilog.info(0x0000, 'Node-API', 'napi_is_promise %{public}s', testNapi.isPromise(value));
                  hilog.info(0x0000, 'Node-API', 'napi_is_promise string %{public}s', testNapi.isPromise(''));
                  // [End ark_napi_is_promise]
                  this.result = 'napiIsPromiseSuccess';
                } else if (item === '2.napiDeferred') {
                  // [Start ark_napi_resolve_reject_deferred]
                  // napi_resolve_deferred & napi_reject_deferred
                  // 创建promise如果创建成功返回true，创建失败返回false
                  hilog.info(0x0000, 'Node-API', 'napi_create_promise %{public}s', testNapi.createPromise());
                  // 调用resolveRejectDeferred函数设置resolve和reject的返回结果以及Promise状态
                  // Promise状态为true时设置resolve，返回结果在then函数中获得
                  let promiseSuccess: Promise<string> =
                    testNapi.resolveRejectDeferred('success', 'fail', true) as Promise<string>;
                  promiseSuccess.then((res) => {
                    hilog.info(0x0000, 'Node-API', 'get_resolve_deferred resolve %{public}s', res)
                    // [StartExclude ark_napi_resolve_reject_deferred]
                    this.result = 'napiDeferredSuccess';
                    // [EndExclude ark_napi_resolve_reject_deferred]
                  }).catch((err: Error) => {
                    hilog.info(0x0000, 'Node-API', 'get_resolve_deferred reject %{public}s', err)
                    // [StartExclude ark_napi_resolve_reject_deferred]
                    this.result = 'napiDeferredFail';
                    // [EndExclude ark_napi_resolve_reject_deferred]
                  })
                  // Promise状态为false时设置reject，返回结果在catch函数中获得
                  let promiseFail: Promise<string> =
                    testNapi.resolveRejectDeferred('success', 'fail', false) as Promise<string>;
                  promiseFail.then((res) => {
                    hilog.info(0x0000, 'Node-API', 'get_resolve_deferred resolve %{public}s', res)
                    // [StartExclude ark_napi_resolve_reject_deferred]
                    this.result = 'napiDeferredSuccess';
                    // [EndExclude ark_napi_resolve_reject_deferred]
                  }).catch((err: Error) => {
                    hilog.info(0x0000, 'Node-API', 'get_resolve_deferred reject %{public}s', err)
                    // [StartExclude ark_napi_resolve_reject_deferred]
                    this.result = 'napiDeferredFail';
                    // [EndExclude ark_napi_resolve_reject_deferred]
                  })
                  // [End ark_napi_resolve_reject_deferred]
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