/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import BackupExtensionAbility, {BundleVersion} from '@ohos.application.BackupExtensionAbility';
import osAccount from '@ohos.account.osAccount';
import Logger from '../common/Logger'

const TAG = `FileBackupExtensionAbility`;
export default class BackupExtension extends  BackupExtensionAbility {
  async onBackup ()   {
    Logger.info(TAG, `onBackup ok`);
  }

  async onRestore (bundleVersion : BundleVersion) {
    Logger.info(TAG, `onRestore ok ${JSON.stringify(bundleVersion)}`);
    await GetUserid();
    Logger.info(TAG, `onRestore end`);
  }
}

async function GetUserid ()
{
  var osAccountManager = osAccount.getAccountManager();
  await osAccountManager.getActivatedOsAccountLocalIds().then((dataArray)=>{
    Logger.info(TAG, "now userid is :" + JSON.stringify(dataArray[0]))
  }).catch((err)=>{
    Logger.info(TAG, "err " + JSON.stringify(err));
  });
}
