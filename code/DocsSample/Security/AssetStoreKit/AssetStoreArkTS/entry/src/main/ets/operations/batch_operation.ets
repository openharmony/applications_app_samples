/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start import]
import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}
// [End import]

export function batchAddAssets(): void {
  // [Start batch_add]
  let attributesArray: asset.AssetMap[] = [];
  let attr1: asset.AssetMap = new Map();
  attr1.set(asset.Tag.SECRET, stringToArray('demo_pwd1'));
  attr1.set(asset.Tag.ALIAS, stringToArray('demo_alias1'));
  attributesArray.push(attr1);

  let attr2: asset.AssetMap = new Map();
  attr2.set(asset.Tag.SECRET, stringToArray('demo_pwd2'));
  attr2.set(asset.Tag.ALIAS, stringToArray('demo_alias2'));
  attributesArray.push(attr2);

  try {
    asset.batchAdd(attributesArray).then((res: asset.BatchResult) => {
      console.info(`Succeeded in batch adding Asset, failedCount: ${res.failedCount}`);
      if (res.failedCount > 0) {
        for (let i = 0; i < res.failedErrorInfos.length; i++) {
          console.error(`Failed to add Asset at index ${res.failedErrorInfos[i].index},
            errCode: ${res.failedErrorInfos[i].errCode}, message: ${res.failedErrorInfos[i].message}`);
        }
      }
    }).catch((err: BusinessError) => {
      console.error(`Failed to batch add Asset. Code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to batch add Asset. Code is ${err.code}, message is ${err.message}`);
  }
  // [End batch_add]
}

export function batchUpdateAssets(): void {
  // [Start batch_update]
  let srcAttrs: asset.AssetMap[] = [];
  let srcAttr1: asset.AssetMap = new Map();
  srcAttr1.set(asset.Tag.ALIAS, stringToArray('demo_alias1'));
  srcAttrs.push(srcAttr1);
  let srcAttr2: asset.AssetMap = new Map();
  srcAttr2.set(asset.Tag.ALIAS, stringToArray('demo_alias2'));
  srcAttrs.push(srcAttr2);

  let destAttrs: asset.AssetMap[] = [];
  let destAttr1: asset.AssetMap = new Map();
  destAttr1.set(asset.Tag.SECRET, stringToArray('demo_pwd_new1'));
  destAttrs.push(destAttr1);
  let destAttr2: asset.AssetMap = new Map();
  destAttr2.set(asset.Tag.SECRET, stringToArray('demo_pwd_new2'));
  destAttrs.push(destAttr2);

  try {
    asset.batchUpdate(srcAttrs, destAttrs).then((res: asset.BatchResult) => {
      console.info(`Succeeded in batch updating Asset, failedCount: ${res.failedCount}`);
      if (res.failedCount > 0) {
        for (let i = 0; i < res.failedErrorInfos.length; i++) {
          console.error(`Failed to update Asset at index ${res.failedErrorInfos[i].index},
            errCode: ${res.failedErrorInfos[i].errCode}, message: ${res.failedErrorInfos[i].message}`);
        }
      }
    }).catch((err: BusinessError) => {
      console.error(`Failed to batch update Asset. Code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to batch update Asset. Code is ${err.code}, message is ${err.message}`);
  }
  // [End batch_update]
}

export function batchRemoveAssets(): void {
  // [Start batch_remove]
  let assetsToBeRemoved: asset.AssetMap[] = [];
  let query1: asset.AssetMap = new Map();
  query1.set(asset.Tag.ALIAS, stringToArray('demo_alias1'));
  assetsToBeRemoved.push(query1);
  let query2: asset.AssetMap = new Map();
  query2.set(asset.Tag.ALIAS, stringToArray('demo_alias2'));
  assetsToBeRemoved.push(query2);

  try {
    asset.batchRemove(assetsToBeRemoved).then(() => {
      console.info(`Succeeded in batch removing Asset.`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to batch remove Asset. Code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to batch remove Asset. Code is ${err.code}, message is ${err.message}`);
  }
  // [End batch_remove]
}