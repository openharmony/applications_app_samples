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

// [Start rdb_accessControlByDeviceAndDataLevel]
import { relationalStore } from '@kit.ArkData';
import { UIContext } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

let store: relationalStore.RdbStore | undefined = undefined;

export async function accessControlByDeviceAndDataLevel() {
  /* context为应用的上下文信息，由调用方自行获取，此处仅为示例。 */
  const context = new UIContext().getHostContext() as common.UIAbilityContext;
  try {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'RdbTest.db',
      // 设置数据库安全级别为S3
      securityLevel: relationalStore.SecurityLevel.S3
    };
    store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    console.info('Succeeded in getting RdbStore.')
  } catch (err) {
    console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
  }
}
// [End rdb_accessControlByDeviceAndDataLevel]