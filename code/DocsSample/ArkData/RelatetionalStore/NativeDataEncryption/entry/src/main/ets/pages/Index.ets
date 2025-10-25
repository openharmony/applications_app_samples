import testNapi from 'libentry.so';

import { defaultConfigRdbStoreTs } from './encryption/Encryption';
import { customizedConfigRdbStoreTs } from './encryption/Encryption';
import { backupManually } from './backuprestore/BackupAndRestore';
import { rebuildingRelationalDatabaseAbnormally } from './backuprestore/BackupAndRestore';
import { restoringManualBackupData } from './backuprestore/BackupAndRestore';

@Entry
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


@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Button() {
        Text('RdbStoreAPITest_NDK')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width("60%")
      .height("10%")
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        testNapi.defaultConfigRdbStore();
        testNapi.customizedConfigRdbStore();
        testNapi.backupRdbStore();
        testNapi.restoreRdbStore();
        testNapi.setSecurityLevelForRdbStore();
      })

      Button() {
        Text('RdbStoreAPITest_ETS')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width('60%')
      .height('10%')
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        defaultConfigRdbStoreTs()
        customizedConfigRdbStoreTs()
        backupManually()
        rebuildingRelationalDatabaseAbnormally()
        restoringManualBackupData()
      })
    }
    .height('100%')
    .width('100%')
  }
}
