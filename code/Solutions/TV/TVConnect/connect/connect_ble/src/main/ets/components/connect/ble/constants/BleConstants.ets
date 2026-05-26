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
export default class WifiConstants {
  public static readonly bleScanRegStr = '^Oh\\-([a-zA-Z0-9 -]{5,17})\\-([0-9]{1})([a-zA-Z0-9]{5})(.{4})';
  public static readonly TAG: string = 'Ble_LOG';
  /**
   * ble广播发现数据包大小为固定的
   */
  public static readonly BROADCAST_DATA_SIZE: number = 37;
  /**
   * 默认协商的MTU为251字节，ble传输最大data size
   */
  public static readonly BLE_MTU_SIZE: number = 251;
  /**
   * gatt service uuid
   */
  public static readonly GATT_SERVICE_UUID: string = '15f1e600-a277-43fc-a484-dd39ef8a9100';
  /**
   * gatt characteristic read uuid
   */
  public static readonly GATT_CHARACTERISTIC_READ_UUID: string = '15f1e601-a277-43fc-a484-dd39ef8a9100';
  /**
   * gatt characteristic write uuid
   */
  public static readonly GATT_CHARACTERISTIC_WRITE_UUID: string = '15f1e602-a277-43fc-a484-dd39ef8a9100';
};