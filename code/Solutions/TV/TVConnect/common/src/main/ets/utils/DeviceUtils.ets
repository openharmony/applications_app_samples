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
import { util } from '@kit.ArkTS';
import { AssetStore } from '../database/AssetStore';

export class DeviceUtils {
  private static deviceIdCacheKey = 'device_id_cache_key';
  private static deviceId = '';

  /**
   * 获取设备id 32位随机码[卸载APP后依旧不变]
   * APP 启动是会调用一次
   * @returns string
   */
  public static async getDeviceId(): Promise<string> {
    if (DeviceUtils.deviceId && DeviceUtils.deviceId.length > 0) {
      return DeviceUtils.deviceId;
    }
    let hasStore = await AssetStore.has(DeviceUtils.deviceIdCacheKey);
    if (hasStore) {
      DeviceUtils.deviceId = await AssetStore.get(DeviceUtils.deviceIdCacheKey);
      return DeviceUtils.deviceId;
    }
    DeviceUtils.deviceId = util.generateRandomUUID(true).replaceAll('-', '');
    await AssetStore.set(DeviceUtils.deviceIdCacheKey, DeviceUtils.deviceId);
    return DeviceUtils.deviceId;
  }

  /**
   * 获取设备id 32位随机码[卸载APP后依旧不变]
   * 业务方后续直接调用此方法
   * @returns
   */
  public static getDeviceIdSync(): string {
    if (DeviceUtils.deviceId && DeviceUtils.deviceId.length > 0) {
      return DeviceUtils.deviceId;
    }
    DeviceUtils.deviceId = AssetStore.getSync(DeviceUtils.deviceIdCacheKey);
    return DeviceUtils.deviceId;
  }
}