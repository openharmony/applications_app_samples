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

/**
 * OpenValley协议的常量值
 */
export default class OpenValleyConstants {
  /**
   * 控制器命名前缀
   */
  public static readonly NAME_PREFIX = 'ccBle-';
  /**
   * 蓝牙连接超时时长
   */
  public static readonly BLE_CONNECT_TIMEOUT = 10 * 1000;
  /**
   * 蓝牙MTU大小
   */
  public static readonly DEFAULT_MTU = 244;
  /**
   * 每次发送数据的大小
   */
  public static readonly DEFAULT_WRITE_DATA_SPLIT_COUNT = OpenValleyConstants.DEFAULT_MTU - 4;
  /**
   * 蓝牙Service UUID
   */
  public static readonly UUID_SERVICE = '00001888-0000-1000-8000-00805f9b34fb'.toUpperCase();
  /**
   * 蓝牙Indicate Characteristic UUID
   */
  public static readonly UUID_CHARACTERISTIC_INDICATE = '00002bed-0000-1000-8000-00805f9b34fb'.toUpperCase();
  /**
   * 蓝牙Indicate Characteristic descriptor UUID
   */
  public static readonly UUID_CHARACTERISTIC_INDICATE_DESCRIPTOR = '00002902-0000-1000-8000-00805f9b34fb'.toUpperCase();
  /**
   * 蓝牙Write Characteristic UUID
   */
  public static readonly UUID_CHARACTERISTIC_WRITE = '00002bee-0000-1000-8000-00805f9b34fb'.toUpperCase();
};

