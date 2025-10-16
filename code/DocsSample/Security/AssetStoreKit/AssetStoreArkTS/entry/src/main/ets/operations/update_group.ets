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

// [Start update_group_asset]
import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

export async function updateGroupAsset(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias'));
  query.set(asset.Tag.GROUP_ID, stringToArray('demo_group_id'));
  let attrsToUpdate: asset.AssetMap = new Map();
  attrsToUpdate.set(asset.Tag.SECRET, stringToArray('demo_pwd_new'));
  attrsToUpdate.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label_new'));
  try {
    await asset.update(query, attrsToUpdate).then(() => {
      console.info(`Succeeded in updating Asset in the group.`);
      result = 'Succeeded in updating Asset in the group';
    }).catch((err: BusinessError) => {
      console.error(`Failed to update Asset in the group. Code is ${err.code}, message is ${err.message}`);
      result = 'Failed to update Asset in the group';
    });
  } catch (err) {
    console.error(`Failed to update Asset in the group. Code is ${err?.code}, message is ${err?.message}`);
    result = 'Failed to update Asset in the group';
  }
  return result;
}
// [End update_group_asset]