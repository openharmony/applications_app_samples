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

// [Start use_napi_method_promise]
import testNapi from 'libentry.so';

export function SetTimeout(): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(42);
    }, 1000);
  })
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.Call_ArkTSAsync'))
          .onClick(() => {
            try {
              this.message = 'Result: napiMethodPromiseSuccess';
              testNapi.callArkTSAsync(SetTimeout);
            } catch (e) {
              this.message = 'Failed';
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End use_napi_method_promise]