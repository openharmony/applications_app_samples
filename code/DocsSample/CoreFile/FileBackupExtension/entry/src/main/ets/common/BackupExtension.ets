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

import BackupExtensionAbility, { BundleVersion } from '@ohos.application.BackupExtensionAbility';
import Logger from '../common/Logger';

interface ErrorInfo {
  type: string,
  errorCode: number,
  errorInfo: string
}

export default class BackupExtension extends BackupExtensionAbility {
  async onBackup() {
    Logger.info(`onBackup ok`);
  }

  async onRestore(bundleVersion: BundleVersion) {
    Logger.info(`onRestore ok ${JSON.stringify(bundleVersion)}`);
    Logger.info(`onRestore end`);
  }
}

class BackupExt extends BackupExtensionAbility {
  //onBackupEx
  async onBackupEx(backupInfo: string): Promise<string> {
    console.log(`onBackupEx ok`);
    let errorInfo: ErrorInfo = {
      type: 'ErrorInfo',
      errorCode: 0,
      errorInfo: 'app diy error info'
    }
    return JSON.stringify(errorInfo);
  }

  // onRestoreEx
  async onRestoreEx(bundleVersion: BundleVersion, restoreInfo: string): Promise<string> {
    console.log(`onRestoreEx ok ${JSON.stringify(bundleVersion)}`);
    let errorInfo: ErrorInfo = {
      type: 'ErrorInfo',
      errorCode: 0,
      errorInfo: 'app diy error info'
    }
    return JSON.stringify(errorInfo);
  }
}

