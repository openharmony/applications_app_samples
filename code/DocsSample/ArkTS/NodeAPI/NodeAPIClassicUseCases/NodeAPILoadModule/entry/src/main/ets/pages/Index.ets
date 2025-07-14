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
import test1 from 'libentry2.so';
import test3 from 'libentry3.so';
import test4 from 'libentry4.so';
import test6 from 'libentry6.so';
import test7 from 'libentry7.so';
import test8 from 'libentry8.so';
import { har1LoadHar2 } from 'har1';

@Entry
@Component
struct Index {
  @State message: string = 'LoudModule';

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
      Button($r('app.string.loadModuleSystem'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          testNapi.loadModule();
          this.message = 'loadModuleSystem success';
        })
      Button($r('app.string.loadEtsDirModule'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test.loadModule();
          this.message = 'loadEtsDirModule success';
        })
      Button($r('app.string.loadModuleFile'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test8.loadModule();
          this.message = 'loadModuleFile success';
        })
      Button($r('app.string.loadHarModule'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test1.loadModule();
          this.message = 'loadHarModule success';
        })
      Button($r('app.string.loadHspModule'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test3.loadModule();
          this.message = 'loadHspModule success';
        })
      Button($r('app.string.loadFarHarModule'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test4.loadModule();
          this.message = 'loadFarHarModule success';
        })
      Button($r('app.string.loadOhpmModule'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test6.loadModule();
          this.message = 'loadOhpmModule success';
        })
      Button($r('app.string.loadNativeModule'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          test7.loadModule();
          this.message = 'loadNativeModule success';
        })
      Button($r('app.string.har1LodeHar2'))
        .margin(3)
        .width('70%')
        .onClick(() => {
          har1LoadHar2();
          this.message = 'har1LodeHar2 success';
        })
    }
    .width('100%')
    .height('100%')
  }
}
