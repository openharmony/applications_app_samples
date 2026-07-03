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
import { InfBroadcastData } from '@ohos/common/index';
import BleConstants from '../constants/BleConstants';

/**
 * 蓝牙数据广播， 非关键信息，暂不解析，主要解析关键信息
 */
export default class BleBroadcastData implements InfBroadcastData {
  /**
   * 从广播数据中，解析出蓝牙广播数据包
   * @param ab
   * @returns
   */
  public static parse(ab: ArrayBuffer): BleBroadcastData | null {
    //广播包为固定长度
    if (ab.byteLength != BleConstants.BROADCAST_DATA_SIZE) {
      return null;
    }

    return null;
  }

  //sn号后两位取值
  public sn: string;
  //productId，5位
  public productId: string;
  //产品子型号，用于区分不同外形特征的同款设备，默认0x00
  public subProductId: string;
  //mac地址
  public mac: string | undefined;

  constructor(sn: string, productId: string, subProductId: string) {
    this.sn = sn;
    this.productId = productId;
    this.subProductId = subProductId;
  }

  getMac(): string {
    return this.mac ? this.mac : '00:00:00:00:00:00';
  }

  getProductId(): string {
    return this.productId;
  }

  getSubProductId(): string {
    return this.subProductId;
  }

  getSN(): string {
    return this.sn;
  }
};