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

import testNapi from 'libentry.so';
import test from 'libentry1.so';

@Entry
@Component
struct Index {
  @State message: string = 'LoudModule';

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
      Button($r('app.string.loadModuleSystem))
        .margin(3)
        .width('70%')
        .onClick(() => {
          testNapi.loadModule();
          this.message = 'loadModuleSystem success';
        })
      Button($r('app.string.loadModuleFile))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test.loadModule();
          this.message = 'loadModuleFile success';
        })
    }
    .width('100%')
    .height('100%')
  }
}
