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
import { ConnectDatabaseHelperImpl } from './ConnectDatabaseHelperImpl';
import { DeviceLibraryDao } from './dao/DeviceLibraryDao';
import { Device } from './entity/Device';

/**
 * 设备库接口
 */
export class DeviceLibraryAccess {
  /**
   * 根据产品id查询设备
   * @returns
   */
  public static async queryDevice(productId?: string): Promise<Device | null> {
    let device: Device | null = null;
    if (productId) {
      let connectDatabaseHelper = await ConnectDatabaseHelperImpl.getInstance();
      let deviceLibrary = new DeviceLibraryDao(connectDatabaseHelper);
      device = await deviceLibrary.queryDeviceByPid(productId);
    }
    return device;
  }
}