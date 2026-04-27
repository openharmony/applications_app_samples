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
 

import { describe, it, expect } from '@ohos/hypium';
import ArrayBufferUtil from '../../../../../../product/tv/navigationBar/src/main/ets/util/ArrayBufferUtil';

/**
 * ArrayBufferUtil 单元测试
 * 覆盖蓝牙配对协议帧的 hex 编解码链路：
 * isValidHexString → formatHex → getIntFromHex → getHexStrArr/getHexArr
 * → getArrayBufferFromHexStr ↔ getHexStringFromArrayBuffer（双向往返）
 *
 * 蓝牙 HID 协议帧以十六进制字节序列传输，任何编解码错误
 * 都会导致配对指令静默损坏，设备无法识别而拒绝连接。
 * 因此该链路的每一步都必须有独立用例守护，形成端到端的编解码质量基线。
 */
export default function arrayBufferUtilTest() {
  describe('ArrayBufferUtil_Test', () => {

    // ---- isValidHexString ----
    // 入口校验是整个编解码链路的第一道防线，
    // 非法字符若不在此拦截，会在 getIntFromHex 中产生 NaN，
    // NaN 写入 Uint8Array 会静默变为 0，导致协议帧字节损坏且无报错。

    it('isValidHexString_valid_lowercase', 0, () => {
      expect(ArrayBufferUtil.isValidHexString('aabbcc')).assertTrue();
    });

    it('isValidHexString_valid_uppercase', 0, () => {
      expect(ArrayBufferUtil.isValidHexString('AABBCC')).assertTrue();
    });

    it('isValidHexString_valid_with_0x_prefix', 0, () => {
      // 蓝牙协议帧字节常量通常带 0x 前缀，必须支持
      expect(ArrayBufferUtil.isValidHexString('0xCA1B')).assertTrue();
    });

    it('isValidHexString_single_digit', 0, () => {
      expect(ArrayBufferUtil.isValidHexString('f')).assertTrue();
    });

    it('isValidHexString_invalid_with_non_hex_char', 0, () => {
      expect(ArrayBufferUtil.isValidHexString('xyz')).assertFalse();
    });

    it('isValidHexString_invalid_empty_string', 0, () => {
      expect(ArrayBufferUtil.isValidHexString('')).assertFalse();
    });

    it('isValidHexString_invalid_space_in_string', 0, () => {
      expect(ArrayBufferUtil.isValidHexString('aa bb')).assertFalse();
    });

    // ---- formatHex ----
    // formatHex 是编解码链路的标准化预处理步骤，统一为小写偶数位格式，
    // 保证后续按每两个字符切分一个字节的逻辑不会因奇偶性问题产生越界或错位。

    it('formatHex_removes_0x_prefix', 0, () => {
      // 统一去掉前缀，保证后续按字节分割逻辑正确
      expect(ArrayBufferUtil.formatHex('0xAB')).assertEqual('ab');
    });

    it('formatHex_pads_odd_length_with_leading_zero', 0, () => {
      // 奇数位补零使每两个字符对应一个字节，保证字节边界对齐
      expect(ArrayBufferUtil.formatHex('f')).assertEqual('0f');
    });

    it('formatHex_converts_to_lowercase', 0, () => {
      expect(ArrayBufferUtil.formatHex('AB')).assertEqual('ab');
    });

    it('formatHex_even_length_no_padding', 0, () => {
      expect(ArrayBufferUtil.formatHex('ab')).assertEqual('ab');
    });

    it('formatHex_0x_odd_length_pads', 0, () => {
      expect(ArrayBufferUtil.formatHex('0x1')).assertEqual('01');
    });

    // ---- getIntFromHex ----
    // getIntFromHex 将单字节 hex 字符串转为整数，是写入 Uint8Array 的直接来源，
    // 必须对非法输入抛出异常而非返回 NaN，因为 Uint8Array 会将 NaN 静默截断为 0。

    it('getIntFromHex_ff_equals_255', 0, () => {
      expect(ArrayBufferUtil.getIntFromHex('ff')).assertEqual(255);
    });

    it('getIntFromHex_00_equals_0', 0, () => {
      expect(ArrayBufferUtil.getIntFromHex('00')).assertEqual(0);
    });

    it('getIntFromHex_with_0x_prefix', 0, () => {
      expect(ArrayBufferUtil.getIntFromHex('0x0a')).assertEqual(10);
    });

    it('getIntFromHex_throws_on_invalid', 0, () => {
      // 非法 hex 字符串必须抛出，防止协议帧解析静默产生错误数值
      let threw = false;
      try {
        ArrayBufferUtil.getIntFromHex('zz');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    // ---- getHexStrArr ----
    // getHexStrArr 将连续 hex 串按字节边界拆分并加 0x 前缀，
    // 输出格式与蓝牙 API 期望的字节数组格式完全匹配，避免调用层再做转换。

    it('getHexStrArr_two_byte_string', 0, () => {
      // 'aabb' 应分割为 ['0xaa', '0xbb']
      const arr = ArrayBufferUtil.getHexStrArr('aabb');
      expect(arr.length).assertEqual(2);
      expect(arr[0]).assertEqual('0xaa');
      expect(arr[1]).assertEqual('0xbb');
    });

    it('getHexStrArr_odd_length_auto_pads', 0, () => {
      // 奇数位输入补零后应正确分割
      const arr = ArrayBufferUtil.getHexStrArr('f');
      expect(arr.length).assertEqual(1);
      expect(arr[0]).assertEqual('0x0f');
    });

    it('getHexStrArr_throws_on_invalid', 0, () => {
      let threw = false;
      try {
        ArrayBufferUtil.getHexStrArr('xyz');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    // ---- getHexArr ----

    it('getHexArr_returns_correct_decimal_values', 0, () => {
      const arr = ArrayBufferUtil.getHexArr('ff00');
      expect(arr.length).assertEqual(2);
      expect(arr[0]).assertEqual(255);
      expect(arr[1]).assertEqual(0);
    });

    it('getHexArr_single_byte', 0, () => {
      const arr = ArrayBufferUtil.getHexArr('0a');
      expect(arr.length).assertEqual(1);
      expect(arr[0]).assertEqual(10);
    });

    // ---- getArrayBufferFromHexStr / getHexStringFromArrayBuffer 双向往返 ----
    // 往返测试是保证编解码链路完整性的最强断言：
    // 若两个方向分别测试通过但往返失败，说明存在信息损失（如大小写不一致或前缀丢失），
    // 这类隐患在单向测试中无法被发现，在协议帧实际传输时才会暴露。

    it('roundtrip_hex_to_buffer_to_hex', 0, () => {
      // 蓝牙协议帧编解码必须幂等：hex → ArrayBuffer → hex 结果一致
      const original = 'aabbccff';
      const buf = ArrayBufferUtil.getArrayBufferFromHexStr(original);
      const result = ArrayBufferUtil.getHexStringFromArrayBuffer(buf);
      expect(result).assertEqual('0x' + original);
    });

    it('roundtrip_single_byte', 0, () => {
      const buf = ArrayBufferUtil.getArrayBufferFromHexStr('0xff');
      const result = ArrayBufferUtil.getHexStringFromArrayBuffer(buf);
      expect(result).assertEqual('0xff');
    });

    it('roundtrip_all_zeros', 0, () => {
      const buf = ArrayBufferUtil.getArrayBufferFromHexStr('0000');
      const result = ArrayBufferUtil.getHexStringFromArrayBuffer(buf);
      expect(result).assertEqual('0x0000');
    });

    it('getArrayBufferFromHexStr_correct_byteLength', 0, () => {
      const buf = ArrayBufferUtil.getArrayBufferFromHexStr('aabbccdd');
      expect(buf.byteLength).assertEqual(4);
    });

    it('getArrayBufferFromHexStr_throws_on_invalid', 0, () => {
      let threw = false;
      try {
        ArrayBufferUtil.getArrayBufferFromHexStr('xyz');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertTrue();
    });

    it('getHexStringFromArrayBuffer_pads_single_digit_bytes', 0, () => {
      // 单字节值 < 16 时必须补零，否则 '0a' 会变成 'a'，导致协议帧解析错位
      const buf = ArrayBufferUtil.getArrayBufferFromHexStr('0a0b');
      const result = ArrayBufferUtil.getHexStringFromArrayBuffer(buf);
      expect(result).assertEqual('0x0a0b');
    });

    // ---- 额外边界场景 ----

    it('roundtrip_4_byte_protocol_frame', 0, () => {
      // 4字节协议帧往返，覆盖蓝牙指令帧的典型长度
      const hex = 'deadbeef';
      const buf = ArrayBufferUtil.getArrayBufferFromHexStr(hex);
      expect(buf.byteLength).assertEqual(4);
      expect(ArrayBufferUtil.getHexStringFromArrayBuffer(buf)).assertEqual('0x' + hex);
    });

    it('getHexArr_four_bytes', 0, () => {
      const arr = ArrayBufferUtil.getHexArr('01020304');
      expect(arr.length).assertEqual(4);
      expect(arr[0]).assertEqual(1);
      expect(arr[1]).assertEqual(2);
      expect(arr[2]).assertEqual(3);
      expect(arr[3]).assertEqual(4);
    });

    it('getHexArr_max_byte_value', 0, () => {
      const arr = ArrayBufferUtil.getHexArr('ff');
      expect(arr[0]).assertEqual(255);
    });

    it('getHexStrArr_four_bytes_correct_prefixes', 0, () => {
      const arr = ArrayBufferUtil.getHexStrArr('aabbccdd');
      expect(arr.length).assertEqual(4);
      for (let i = 0; i < arr.length; i++) {
        expect(arr[i].startsWith('0x')).assertTrue();
      }
    });

    it('isValidHexString_all_valid_hex_chars', 0, () => {
      expect(ArrayBufferUtil.isValidHexString('0123456789abcdefABCDEF')).assertTrue();
    });

    it('isValidHexString_only_0x_prefix_is_invalid', 0, () => {
      // '0x' 本身无数据部分，应判定为非法
      expect(ArrayBufferUtil.isValidHexString('0x')).assertFalse();
    });

    it('formatHex_uppercase_multichar_with_0x', 0, () => {
      expect(ArrayBufferUtil.formatHex('0xDEAD')).assertEqual('dead');
    });

    it('getIntFromHex_0a_equals_10', 0, () => {
      expect(ArrayBufferUtil.getIntFromHex('0a')).assertEqual(10);
    });

    it('roundtrip_8_byte_long_frame', 0, () => {
      const hex = '0102030405060708';
      const buf = ArrayBufferUtil.getArrayBufferFromHexStr(hex);
      expect(buf.byteLength).assertEqual(8);
      expect(ArrayBufferUtil.getHexStringFromArrayBuffer(buf)).assertEqual('0x' + hex);
    });

  });
}
