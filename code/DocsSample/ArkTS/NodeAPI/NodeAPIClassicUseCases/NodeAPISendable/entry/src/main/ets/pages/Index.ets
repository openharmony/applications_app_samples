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

import hilog from '@ohos.hilog';
import { MyObject } from 'libentry.so'
let object : MyObject = new MyObject(0);
object.value = 1023;
const DOMAIN = 0x0000;

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
          .onClick(() => {
            // [Start run_arkts_call]
            let object : MyObject = new MyObject(0);
            object.value = 1023;
            hilog.info(0x0000, 'testTag', 'MyObject value after set: %{public}d', object.value);
            hilog.info(0x0000, 'testTag', 'MyObject plusOne: %{public}d', object.plusOne());
            // [End run_arkts_call]
            this.message = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}