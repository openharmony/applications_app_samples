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

import { sleep } from './common';
// [Start import]
import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}
// [End import]

export async function updateAsset(): Promise<string> {
  let result: string = '';
  // [Start update_asset]
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias'));
  let attrsToUpdate: asset.AssetMap = new Map();
  attrsToUpdate.set(asset.Tag.SECRET, stringToArray('demo_pwd_new'));
  attrsToUpdate.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label_new'));
  try {
    asset.update(query, attrsToUpdate).then(() => {
      console.info(`Succeeded in updating Asset.`);
      // [StartExclude update_asset]
      result = 'Succeeded in updating Asset';
      // [EndExclude update_asset]
    }).catch((err: BusinessError) => {
      console.error(`Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
      // [StartExclude update_asset]
      result = 'Failed to update Asset';
      // [EndExclude update_asset]
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to update Asset. Code is ${err.code}, message is ${err.message}`);
    // [StartExclude update_asset]
    result = 'Failed to update Asset';
    // [EndExclude update_asset]
  }
  // [End update_asset]
  await sleep(500);
  return result;
}