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

function arrayToString(arr: Uint8Array): string {
  let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
  let str = textDecoder.decodeToString(arr, { stream: false });
  return str;
}
// [End import]

export async function queryAssetPlaintext(): Promise<string> {
  let result: string = '';
  // [Start query_single_plaintext]
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.ALIAS, stringToArray('demo_alias')); // 指定了关键资产别名，最多查询到一条满足条件的关键资产。
  query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL); // 此处表示需要返回关键资产的所有信息，即属性+明文。返回明文需要解密，查询时间较长。
  try {
    asset.query(query).then((res: Array<asset.AssetMap>) => {
      for (let i = 0; i < res.length; i++) {
        // 解析secret。
        let secret: Uint8Array = res[i].get(asset.Tag.SECRET) as Uint8Array;
        // 将Uint8Array转为string类型。
        let secretStr: string = arrayToString(secret);
      }
      // [StartExclude query_single_plaintext]
      result = 'Succeeded in querying Asset plaintext';
      // [EndExclude query_single_plaintext]
    }).catch((err: BusinessError) => {
      console.error(`Failed to query Asset plaintext. Code is ${err.code}, message is ${err.message}`);
      // [StartExclude query_single_plaintext]
      result = 'Failed to query Asset plaintext';
      // [EndExclude query_single_plaintext]
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to query Asset plaintext. Code is ${err.code}, message is ${err.message}`);
    // [StartExclude query_single_plaintext]
    result = 'Failed to query Asset plaintext';
    // [EndExclude query_single_plaintext]
  }
  // [End query_single_plaintext]
  await sleep(500);
  return result;
}