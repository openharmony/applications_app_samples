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

// [Start remove_group_asset]
import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

export async function removeGroupAsset(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 此处指定别名删除单条群组关键资产，也可不指定别名删除多条群组关键资产。
  query.set(asset.Tag.GROUP_ID, stringToArray('demo_group_id'));
  try {
    await asset.remove(query).then(() => {
      console.info(`Succeeded in removing Asset from the group.`);
      result = 'Succeeded in removing Asset from the group';
    }).catch((err: BusinessError) => {
      console.error(`Failed to remove Asset from the group. Code is ${err.code}, message is ${err.message}`);
      result = 'Failed to remove Asset from the group';
    });
  } catch (err) {
    console.error(`Failed to remove Asset from the group. Code is ${err?.code}, message is ${err?.message}`);
    result = 'Failed to remove Asset from the group';
  }
  return result;
}
// [End remove_group_asset]