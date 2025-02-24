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

import { getLocalCapabilities, sessionBackup, sessionRestore, release } from '../backuprestore/BackupRestore';

let MARGIN = 12; // 组件间的间隔

@Entry
@Component
struct FileBackup {
  @State message: string = '';

  build() {
    Column() {
      TextArea({
        text: this.message,
        placeholder: '',
      })
        .width('100%')
        .height('45%')
      Row() {
        Button($r('app.string.applicationTriggersDataBackup'))
          .width('40%')
          .height('100%')
          .margin(MARGIN)
          .onClick(() => {
            sessionBackup();
          })
        Button($r('app.string.applicationTriggersDataReStore'))
          .width('40%')
          .height('100%')
          .margin(MARGIN)
          .onClick(() => {
            sessionRestore();
          })
      }
      .width('80%')
      .height('10%')
      .margin(MARGIN)

      Row() {
        Button($r('app.string.releaseBackup'))
          .width('40%')
          .height('100%')
          .margin(MARGIN)
          .onClick(() => {
            release();
          })
        Button($r('app.string.capabilityDocumentation'))
          .width('40%')
          .height('100%')
          .margin(MARGIN)
          .onClick(() => {
            getLocalCapabilities();
          })
      }
      .width('80%')
      .height('10%')
    }
  }
}
