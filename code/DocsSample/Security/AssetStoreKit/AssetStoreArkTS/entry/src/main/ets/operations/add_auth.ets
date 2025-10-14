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

import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

function stringToArray(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  return textEncoder.encodeInto(str);
}

export async function addUserAuthAsset(): Promise<string> {
  let result: string = '';
  let attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.SECRET, stringToArray('demo_pwd'));
  attr.set(asset.Tag.ALIAS, stringToArray('user_auth_asset'));
  attr.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_FIRST_UNLOCKED);
  attr.set(asset.Tag.DATA_LABEL_NORMAL_1, stringToArray('demo_label'));
  attr.set(asset.Tag.AUTH_TYPE, asset.AuthType.ANY);
  try {
    await asset.add(attr).then(() => {
      console.info(`Succeeded in adding Asset.`);
      result = 'Succeeded in adding user-auth Asset';
    }).catch((err: BusinessError) => {
      console.error(`Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
      result = 'Failed to add Asset';
    })
  } catch (error) {
    let err = error as BusinessError;
    console.error(`Failed to add Asset. Code is ${err.code}, message is ${err.message}`);
    result = 'Failed to add Asset';
  }
  return result;
}