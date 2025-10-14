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

// [Start query_group_asset_plaintext]
// [Start query_group_asset_attribute]
import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

// [StartExclude query_group_asset_attribute]
function arrayToString(arr: Uint8Array): string {
  let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
  let str = textDecoder.decodeToString(arr, { stream: false });
  return str;
}

export async function queryGroupAssetPlaintext(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 指定了群组关键资产别名，最多查询到一条满足条件的群组关键资产。
  query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL); // 此处表示需要返回群组关键资产的所有信息，即属性+明文。
  query.set(asset.Tag.GROUP_ID, stringToArray('demo_group_id'));
  try {
    await asset.query(query).then((res: Array<asset.AssetMap>) => {
      for (let i = 0; i < res.length; i++) {
        // 解析secret。
        let secret: Uint8Array = res[i].get(asset.Tag.SECRET) as Uint8Array;
        // 将Uint8Array转换为string类型。
        let secretStr: string = arrayToString(secret);
      }
      result = 'Succeeded in querying group Asset plaintext';
    }).catch((err: BusinessError) => {
      console.error(`Failed to query Asset plaintext from the group. Code is ${err.code}, message is ${err.message}`);
      result = 'Failed to query Asset plaintext from the group';
    });
  } catch (err) {
    console.error(`Failed to query Asset plaintext from the group. Code is ${err?.code}, message is ${err?.message}`);
    result = 'Failed to query Asset plaintext from the group';
  }
  return result;
}
// [EndExclude query_group_asset_attribute]
// [End query_group_asset_plaintext]

export async function queryGroupAssetAttribute(): Promise<string> {
  let result: string = '';
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 指定了群组关键资产别名，最多查询到一条满足条件的群组关键资产。
  query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ATTRIBUTES); // 此处表示仅返回群组关键资产属性，不包含群组关键资产明文。
  query.set(asset.Tag.GROUP_ID, stringToArray('demo_group_id'));
  try {
    await asset.query(query).then((res: Array<asset.AssetMap>) => {
      for (let i = 0; i < res.length; i++) {
        // 解析属性。
        let accessibility: number = res[i].get(asset.Tag.ACCESSIBILITY) as number;
        console.info(`Succeeded in getting accessibility, which is: ${accessibility}.`);
      }
      result = 'Succeeded in querying group Asset attribute';
    }).catch((err: BusinessError) => {
      console.error(`Failed to query Asset attribute from the group. Code is ${err.code}, message is ${err.message}`);
      result = 'Failed to query Asset attribute from the group';
    });
  } catch (err) {
    console.error(`Failed to query Asset attribute from the group. Code is ${err?.code}, message is ${err?.message}`);
    result = 'Failed to query Asset attribute from the group';
  }
  return result;
}
// [End query_group_asset_attribute]