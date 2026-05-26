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
import { BleConstants } from '@ohos/connect_ble';
import ArrayBufferUtil from '../../util/ArrayBufferUtil';

export class VirtualBleBroadcast {
  public static dataArr: string[] = [
  //AdvA，广播mac地址'A1:A1:A1:A1:A1:A1'
    '0xA1A1A1A1A1A1',
    //AdvData
    //AD Structure1，固定值
    '0x020106',
    //AD Structure2
    //length
    '0x18',
    //ad type,0x16代表蓝牙服务数据
    '0x16',
    //ad data -uuid，通用标识符，length 2 ，这里随意定一个
    '0xFDAA',
    //ad data - spec data
    // version，广播协议版本
    '0x01',
    //business-basic, 设备发现和连接模式
    '0x06',
    //business-extension, 拉起FA
    '0x00',
    //typelist，蓝牙碰一碰穿0x0017
    '0x0017',
    //bit0 length
    '0x08',
    //bit0
    //SN type sn后两位
    '0x14',
    //SN length
    '0x02',
    //SN value,ascii值
    '0x1111',
    //protocolD type
    '0x17',
    //protocolD length
    '0x01',
    //protocolD value
    '0x00',
    //bit 0 自定义数据，无
    //bit 1,productID value，产品id，长度5，ascii
    '0x6162636465',
    //bit 2，sub productID value,产品子型号
    '0x00',
    //bit 3，设备广播实际发射频率
    '0xF0'
  ];

  static getVirtualData(): ArrayBuffer {
    const buffer: ArrayBuffer = new ArrayBuffer(BleConstants.BROADCAST_DATA_SIZE);
    const view = new DataView(buffer);
    ArrayBufferUtil.setUnit8FromHexArray(view, 0, VirtualBleBroadcast.dataArr);
    return buffer;
  }
}