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
import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';
import { Logger } from '../utils/Logger';

export class AssetStore {
  public static async set(key: string, value: string): Promise<boolean> {
    if (!canIUse('SystemCapability.Security.Asset')) {
      Logger.error('AssetStore', 'not support SystemCapability.Security.Asset');
      return Promise.reject('not support SystemCapability.Security.Asset');
    }
    let attr: asset.AssetMap = new Map();
    // 关键资产别名，每条关键资产的唯一索引
    attr.set(asset.Tag.ALIAS, AssetStore.stringToArray(key));
    // 关键资产明文
    attr.set(asset.Tag.SECRET, AssetStore.stringToArray(value));
    // 关键资产同步类型 THIS_DEVICE只在本设备进行同步
    attr.set(asset.Tag.SYNC_TYPE, asset.SyncType.THIS_DEVICE);
    // 同属性覆盖
    attr.set(asset.Tag.CONFLICT_RESOLUTION, asset.ConflictResolution.OVERWRITE);
    // 在应用卸载时是否需要保留关键资产。需要权限：ohos.permission.STORE_PERSISTENT_DA
    attr.set(asset.Tag.IS_PERSISTENT, true);
    try {
      await asset.add(attr);
      Logger.debug('AssetStore', 'AssetStore add success');
      return true;
    } catch (e) {
      Logger.error('AssetStore', `AssetStore has error ${e?.message}`);
      if (e?.code == 24000002) {
        return false;
      }
      return Promise.reject(e);
    }
  }

  public static async has(key: string): Promise<boolean> {
    if (!canIUse('SystemCapability.Security.Asset')) {
      Logger.error('AssetStore', 'not support SystemCapability.Security.Asset');
      return Promise.reject('not support SystemCapability.Security.Asset');
    }
    let query: asset.AssetMap = new Map();
    query.set(asset.Tag.ALIAS, AssetStore.stringToArray(key));
    query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
    try {
      const res: asset.AssetMap[] = await asset.query(query);
      return res != undefined && res.length > 0;
    } catch (e) {
      Logger.error('AssetStore', `AssetStore has error ${e?.message}`);
      if (e?.code == 24000002) {
        return false;
      }
      return Promise.reject(e);
    }
  }

  public static async get(key: string): Promise<string> {
    if (!canIUse('SystemCapability.Security.Asset')) {
      Logger.error('AssetStore', 'not support SystemCapability.Security.Asset');
      return Promise.reject('not support SystemCapability.Security.Asset');
    }
    let query: asset.AssetMap = new Map();
    query.set(asset.Tag.ALIAS, AssetStore.stringToArray(key));
    query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
    try {
      const res: asset.AssetMap[] = await asset.query(query);
      if (res == undefined || res.length == 0) {
        return '';
      }
      let secret: Uint8Array = res[0].get(asset.Tag.SECRET) as Uint8Array;
      let secretStr: string = AssetStore.arrayToString(secret);
      return secretStr;
    } catch (e) {
      Logger.error('AssetStore', `AssetStore get error ${e?.message}`);
      if (e?.code == 24000002) {
        return '';
      }
      return Promise.reject(e);
    }
  }

  public static getSync(key: string): string {
    if (!canIUse('SystemCapability.Security.Asset')) {
      Logger.error('AssetStore', 'not support SystemCapability.Security.Asset');
      return '';
    }
    let query: asset.AssetMap = new Map();
    query.set(asset.Tag.ALIAS, AssetStore.stringToArray(key));
    query.set(asset.Tag.RETURN_TYPE, asset.ReturnType.ALL);
    try {
      const res: asset.AssetMap[] = asset.querySync(query);
      if (res == undefined || res.length == 0) {
        return '';
      }
      let secret: Uint8Array = res[0].get(asset.Tag.SECRET) as Uint8Array;
      let secretStr: string = AssetStore.arrayToString(secret);
      return secretStr;
    } catch (e) {
      Logger.error('AssetStore', `AssetStore get error ${e?.message}`);
      return '';
    }
  }

  public static async remove(key: string): Promise<boolean> {
    if (!canIUse('SystemCapability.Security.Asset')) {
      Logger.error('AssetStore', 'not support SystemCapability.Security.Asset');
      return true;
    }
    let query: asset.AssetMap = new Map();
    query.set(asset.Tag.ALIAS, AssetStore.stringToArray(key));
    try {
      await asset.remove(query);
      return true;
    } catch (e) {
      Logger.error('AssetStore', `AssetStore remove error ${e?.message}`);
      return Promise.reject(e);
    }
  }

  private static stringToArray(str: string): Uint8Array {
    let textEncoder = new util.TextEncoder();
    return textEncoder.encodeInto(str);
  }

  private static arrayToString(arr: Uint8Array): string {
    let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    let str = textDecoder.decodeWithStream(arr, { stream: false });
    return str;
  }
}