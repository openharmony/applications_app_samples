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

// [Start add_sync_asset]
// [Start query_sync_result]
import { asset } from '@kit.AssetStoreKit';
// [StartExclude query_sync_result]
import { util } from '@kit.ArkTS';
// [EndExclude query_sync_result]
import { BusinessError } from '@kit.BasicServicesKit';

// [StartExclude query_sync_result]
function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

export async function addSyncAsset(): Promise<string> {
  let result: string = '';
  let attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.SECRET, stringToArray('demo_pwd'));
  attr.set(asset.Tag.ALIAS, stringToArray('demo_alias'));
  attr.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label'));
  attr.set(asset.Tag.SYNC_TYPE, asset.SyncType.TRUSTED_DEVICE); // 需指定在可信设备间同步（如新旧设备间克隆）。

  try {
    await asset.add(attr).then(() => {
      console.info(`Succeeded in adding Asset with sync.`);
      result = 'Succeeded in adding Asset with sync';
    }).catch((err: BusinessError) => {
      console.error(`Failed to add Asset with sync. Code is ${err.code}, message is ${err.message}`);
      result = 'Failed to add Asset with sync';
    })
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to add Asset with sync. Code is ${err?.code}, message is ${err?.message}`);
    result = 'Failed to add Asset with sync';
  }
  return result;
}
// [EndExclude query_sync_result]
// [End add_sync_asset]

export async function querySyncResult(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  await asset.querySyncResult(query).then((res: asset.SyncResult) => {
    console.info(`Succeeded in querying sync result: ${JSON.stringify(res)}`);
    result = 'Succeeded in querying sync result';
  }).catch((err: BusinessError) => {
    console.error(`Failed to query sync result of Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Failed to query sync result of Asset';
  });
  return result;
}
// [End query_sync_result]