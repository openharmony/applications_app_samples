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

export async function removeAsset(): Promise<string> {
  let result: string = '';
  // [Start remove_asset]
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 此处指定别名删除单条关键资产，也可不指定别名删除多条关键资产。
  try {
    asset.remove(query).then(() => {
      console.info(`Succeeded in removing Asset.`);
      // [StartExclude remove_asset]
      result = 'Succeeded in removing Asset';
      // [EndExclude remove_asset]
    }).catch((err: BusinessError) => {
      console.error(`Failed to remove Asset. Code is ${err.code}, message is ${err.message}`);
      // [StartExclude remove_asset]
      result = 'Failed to remove Asset';
      // [EndExclude remove_asset]
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to remove Asset. Code is ${err.code}, message is ${err.message}`);
    // [StartExclude remove_asset]
    result = 'Failed to remove Asset';
    // [EndExclude remove_asset]
  }
  // [End remove_asset]
  await sleep(500);
  return result;
}