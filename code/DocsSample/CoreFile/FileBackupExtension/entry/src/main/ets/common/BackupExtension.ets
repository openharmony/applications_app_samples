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

// [Start on_backup_restore]
// [Start on_release]
import { BackupExtensionAbility } from '@kit.CoreFileKit';
// [StartExclude on_release]
import { BundleVersion } from '@kit.CoreFileKit';
// [EndExclude on_release]
// [StartExclude on_backup_restore]
import { fileIo } from '@kit.CoreFileKit';
// [EndExclude on_backup_restore]

// [StartExclude on_release]
interface ErrorInfo {
  type: string,
  errorCode: number,
  errorInfo: string
}
// [EndExclude on_release]

// [StartExclude on_backup_restore]
const SCENARIO_BACKUP: number = 1;
const SCENARIO_RESTORE: number = 2;
// 需要清理的临时目录
let filePath: string = '/data/storage/el2/base/.temp/';
// [EndExclude on_backup_restore]

class BackupExt extends BackupExtensionAbility {
  // [StartExclude on_release]
  //onBackupEx
  async onBackupEx(backupInfo: string): Promise<string> {
    console.info('onBackupEx ok');
    let errorInfo: ErrorInfo = {
      type: 'ErrorInfo',
      errorCode: 0,
      errorInfo: 'app diy error info'       
    }
    return JSON.stringify(errorInfo);
  }

  // onRestoreEx
  async onRestoreEx(bundleVersion : BundleVersion, restoreInfo: string): Promise<string> {
    console.info(`onRestoreEx begin`);
    let errorInfo: ErrorInfo = {
      type: 'ErrorInfo',
      errorCode: 0,
      errorInfo: 'app diy error info'
    }
    return JSON.stringify(errorInfo);
  }
  // [EndExclude on_release]
  // [StartExclude on_backup_restore]
  // onRelease
  async onRelease(scenario: number): Promise<void> {
    try {
      if (scenario == SCENARIO_BACKUP) {
        // 备份场景，应用自行实现处理，以清理备份产生的临时文件为例
        console.info(`onRelease begin`);
        await fileIo.rmdir(filePath);
        console.info(`onRelease end, rmdir succeed`);
      }
      if (scenario == SCENARIO_RESTORE) {
        // 恢复场景，应用自行实现处理，以清理恢复产生的临时文件为例
        console.info(`onRelease begin`);
        await fileIo.rmdir(filePath);
        console.info(`onRelease end, rmdir succeed`);
      }
    } catch (error) {
      console.error(`onRelease failed with error. Code: ${error.code}, message: ${error.message}`);
    }
  }
  // [EndExclude on_backup_restore]
}
// [End on_backup_restore]
