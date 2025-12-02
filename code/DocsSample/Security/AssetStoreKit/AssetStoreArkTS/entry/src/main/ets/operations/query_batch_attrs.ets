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

export async function queryBatchAssetAttributes(): Promise<string> {
  let result: string = '';
  // [Start query_batch_attributes]
  let query: asset.AssetMap = new Map();
  query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ATTRIBUTES); // 此处表示仅返回关键资产属性，不包含关键资产明文。
  query.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label'));
  query.set(asset.Tag.RETURN_LIMIT, 10); // 此处表示查询10条满足条件的关键资产。
  query.set(asset.Tag.RETURN_ORDERED_BY, asset.Tag.DATA_LABEL_NORMAL_1); // 此处查询结果以DATA_LABEL_NORMAL_1属性内容排序。
  try {
    asset.query(query).then((res: Array<asset.AssetMap>) => {
      for (let i = 0; i < res.length; i++) {
        // 解析属性。
        let accessibility: number = res[i].get(asset.Tag.ACCESSIBILITY) as number;
        console.info(`Succeeded in getting accessibility, which is: ${accessibility}.`);
      }
      // [StartExclude query_batch_attributes]
      result = 'Succeeded in querying batch Asset attributes';
      // [EndExclude query_batch_attributes]
    }).catch((err: BusinessError) => {
      console.error(`Failed to query batch Asset attributes. Code is ${err.code}, message is ${err.message}`);
      // [StartExclude query_batch_attributes]
      result = 'Failed to query batch Asset attributes';
      // [EndExclude query_batch_attributes]
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to query batch Asset attributes. Code is ${err.code}, message is ${err.message}`);
    // [StartExclude query_batch_attributes]
    result = 'Failed to query batch Asset attributes';
    // [EndExclude query_batch_attributes]
  }
  // [End query_batch_attributes]
  await sleep(500);
  return result;
}