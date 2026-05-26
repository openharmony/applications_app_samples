/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, expect, it } from '@ohos/hypium';
import { VirtualBleBroadcast } from '../main/ets/model/virtual/VirtualBleBroadcast';
import ArrayBufferUtil from '../main/ets/util/ArrayBufferUtil';
import StringUtil from '../main/ets/util/StringUtil';
import { BleConstants, BleDevicesController, BleDevicesParser } from '@ohos/connect_ble/Index';
import { InfBroadcastData } from '@ohos/common';

export default function BroadcastParserUnitTest() {
  describe('BroadcastParserUnitTest', () => {
    it('getVirtualData', 0, () => {
      const ab: ArrayBuffer = VirtualBleBroadcast.getVirtualData();
      const hexStr: string = ArrayBufferUtil.getHexStringFromArrayBuffer(ab);
      const str: string = '0xa1a1a1a1a1a1020106';
      expect(ab.byteLength).assertEqual(BleConstants.BROADCAST_DATA_SIZE);
      expect(hexStr.startsWith(str)).assertTrue();
    });

    it('parser', 0, () => {
      const ab: ArrayBuffer = VirtualBleBroadcast.getVirtualData();
      const data: InfBroadcastData | null = new BleDevicesParser(new BleDevicesController()).parserFromBroadcast(ab);
      expect(data != null).assertTrue();
    });
  });

  describe('ArrayBufferUtil', () => {
    it('hexToInt', 0, () => {
      const n = ArrayBufferUtil.getIntFromHex('0x0010');
      expect(n).assertEqual(16);
    });

    it('isValidHexString', 0, () => {
      const hex: string = '0xa1b1c1d1';
      const hex2: string = 'xa1b1c1d1';
      const b = ArrayBufferUtil.isValidHexString(hex);
      const b2 = ArrayBufferUtil.isValidHexString(hex2);
      expect(b).assertTrue();
      expect(b2).assertFalse();
    });

    it('getHexArr', 0, () => {
      const hex: string = '0xa1b1c1d1';
      const arr = ArrayBufferUtil.getHexArr(hex);
      expect(arr.length).assertEqual(4);
    });

    it('getHexStringFromArrayBuffer_setUint8FromHex', 0, () => {
      const ab: ArrayBuffer = new ArrayBuffer(4);
      const hex: string = '0xa1b1c1d1';
      const view: DataView = new DataView(ab);
      ArrayBufferUtil.setUint8FromHex(view, 0, hex);
      const hexStr = ArrayBufferUtil.getHexStringFromArrayBuffer(ab);
      expect(hexStr).assertEqual(hex);
    });

    it('getHexStrArr', 0, () => {
      const hex: string = '0xa1b1c1d1';
      const arr = ArrayBufferUtil.getHexStrArr(hex);
      expect(arr.length).assertEqual(4);
    });

    it('setUnit8FromHexArray', 0, () => {
      const ab: ArrayBuffer = new ArrayBuffer(7);
      const view: DataView = new DataView(ab);
      const hexArr: string[] = [
        'aa',
        'bbdd',
        'cc',
        'dd',
        'ee',
        'ff',
      ];
      ArrayBufferUtil.setUnit8FromHexArray(view, 0, hexArr);
      const result: string = ArrayBufferUtil.getHexStringFromArrayBuffer(ab);
      expect(result).assertEqual('0x' + hexArr.join(''));
    });

    it('getArrayBufferFromHexStr', 0, () => {
      const uuid: string = StringUtil.replaceAll(BleConstants.GATT_CHARACTERISTIC_READ_UUID, '-', '');
      const af: ArrayBuffer = ArrayBufferUtil.getArrayBufferFromHexStr(uuid);
      const result: string = ArrayBufferUtil.getHexStringFromArrayBuffer(af);
      expect('0x' + uuid).assertEqual(result);
    });

    it('VirtualBleBroadcast', 0, () => {
      const result: string = ArrayBufferUtil.getHexStringFromArrayBuffer(VirtualBleBroadcast.getVirtualData());
      const hexStr = '0x' + VirtualBleBroadcast.dataArr.map((str) => ArrayBufferUtil.formatHex(str)).join('');
      expect(result.startsWith(hexStr)).assertTrue();
    });
  });
}