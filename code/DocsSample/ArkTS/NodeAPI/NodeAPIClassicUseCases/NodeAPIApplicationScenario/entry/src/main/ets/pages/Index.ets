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
// [Start napi_call_threadsafe_function_with_priority_ets]
// [Start napi_event_loop_ets]
// [Start napi_ark_runtime_ets]
import testNapi from 'libentry.so';
// [StartExclute napi_call_threadsafe_function_with_priority_ets]
// [StartExclute napi_event_loop_ets]
// [StartExclute napi_ark_runtime_ets]
// [Start napi_thread_safety_ets]
import nativeModule from 'libentry1.so';
// [StartExclute napi_thread_safety_ets]
@Entry
@Component
struct Index {
  @State message: string = 'NodeAPI';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.createArkRuntime'))
        .width('70%')
        .onClick(() => {
          // [EndExclute napi_ark_runtime_ets]
          testNapi.createArkRuntime();
          // [End napi_ark_runtime_ets]
          this.message = 'ArkRuntime success';
        })
      Button($r('app.string.runEventLoop'))
        .width('70%')
        .onClick(() => {
          // [EndExclute napi_event_loop_ets]
          testNapi.runEventLoop(true);
          // [End napi_event_loop_ets]
          this.message = 'EventLoop success';
        })
      Button($r('app.string.CallThreadSafeWithPriority'))
        .width('70%')
        .onClick(() => {
          // [EndExclute napi_call_threadsafe_function_with_priority_ets]
          let callback = (a: number, b: number): number => {
            console.info('result is ' + (a + b))
            return a + b;
          }
          testNapi.callThreadSafeWithPriority(callback);
          // [End napi_call_threadsafe_function_with_priority_ets]
          this.message = 'ThreadSafeWithPriority success';
        })
      Button($r('app.string.startThread'))
        .width('70%')
        .onClick(() => {
          // [EndExclute napi_thread_safety_ets]
          let callback = (): Promise<string> => {
            return new Promise((resolve) => {
              setTimeout(() => {
                resolve('string from promise');
              }, 5000);
            });
          }
          nativeModule.startThread(callback);
          // [End napi_thread_safety_ets]
          this.message = 'StartThread success';
        })
    }
    .width('100%')
    .height('100%')
  }
}
