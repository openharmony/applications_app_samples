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
import napiHar from 'libentryone.so';
import napiRemoteHar from 'libentrytwo.so';
import napiAPI from 'libentrythree.so';
import napiFile from 'libentryfour.so'
import { tests } from 'har1';

@Entry
@Component
struct Index {
  @State message: string = 'LoadModule';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bolder)
      Button($r('app.string.loadModuleFile))
        .width('70%')
        .onClick(() => {
          napiFile.loadModule();
          this.message = 'loadModuleFile success';
        })
      Button($r('app.string.loadModuleHarName))
        .width('70%')
        .onClick(() => {
          napiHar.loadModule();
          this.message = 'loadModuleHarName success';
        })
      Button($r('app.string.loadModuleRemoteHar))
        .width('70%')
        .onClick(() => {
          napiRemoteHar.loadModule();
          this.message = 'loadModuleRemoteHar success';
        })
      Button($r('app.string.loadModuleAPI))
        .width('70%')
        .onClick(() => {
          napiAPI.loadModule();
          this.message = 'loadModuleAPI success';
        })
      Button($r('app.string.loadModuleNative))
        .width('70%')
        .onClick(() => {
          testNapi.loadModule();
          this.message = 'loadModuleNative success';
        })
      Button($r('app.string.loadModuleHarToHar))
        .width('70%')
        .onClick(() => {
          tests();
          this.message = 'loadModuleHarToHar success';
        })
    }
    .width('100%')
    .height('100%')
  }
}
