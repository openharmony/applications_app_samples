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
import { PairingState } from '../../../../../../product/tv/pairService/src/main/ets/model/PairingState';
import { PairErrorCode, createError } from '../../../../../../product/tv/pairService/src/main/ets/model/PairError';
import { PartsDeviceState } from '../../../../../../product/tv/pairService/src/main/ets/model/DeviceState';

/**
 * 蓝牙配对模型单元测试
 * 覆盖三个纯模型文件中与系统API完全解耦的逻辑：
 * - PairingState：配对状态机的枚举值契约
 * - PairErrorCode + createError：错误码工厂函数
 * - PartsDeviceState：设备状态枚举值契约
 */
export default function pairModelsTest() {
  describe('PairModels_Test', () => {

    // ---- PairingState 枚举值契约 ----
    // 枚举值是状态机的外部契约，IDL 接口和日志分析工具都依赖这些具体数值，
    // 一旦改变会导致历史日志无法解析、跨进程通信状态错位，必须严格锁定。

    it('STATE_PREPARE_should_be_1', 0, () => {
      // 初始状态值为1，是状态机的起点，所有流程从此开始
      expect(PairingState.STATE_PREPARE).assertEqual(1);
    });

    it('STATE_PAIRING_should_be_2', 0, () => {
      expect(PairingState.STATE_PAIRING).assertEqual(2);
    });

    it('STATE_PAIRED_should_be_3', 0, () => {
      expect(PairingState.STATE_PAIRED).assertEqual(3);
    });

    it('STATE_CONNECT_SUCCESS_should_be_10', 0, () => {
      // 值为10，与配对失败(21)之间有足够间距，便于后续扩展中间状态
      expect(PairingState.STATE_CONNECT_SUCCESS).assertEqual(10);
    });

    it('STATE_PAIR_FAIL_should_be_21', 0, () => {
      expect(PairingState.STATE_PAIR_FAIL).assertEqual(21);
    });

    it('STATE_CONNECT_FAIL_should_be_22', 0, () => {
      expect(PairingState.STATE_CONNECT_FAIL).assertEqual(22);
    });

    it('STATE_TIMEOUT_should_be_23', 0, () => {
      expect(PairingState.STATE_TIMEOUT).assertEqual(23);
    });

    it('STATE_UNKNOWN_ERROR_should_be_24', 0, () => {
      expect(PairingState.STATE_UNKNOWN_ERROR).assertEqual(24);
    });

    it('all_pairing_states_are_unique', 0, () => {
      // 枚举值全部唯一，防止状态机判断时出现歧义
      const values: number[] = [
        PairingState.STATE_PREPARE,
        PairingState.STATE_PAIRING,
        PairingState.STATE_PAIRED,
        PairingState.STATE_CONNECT_SUCCESS,
        PairingState.STATE_PAIR_FAIL,
        PairingState.STATE_CONNECT_FAIL,
        PairingState.STATE_TIMEOUT,
        PairingState.STATE_UNKNOWN_ERROR,
      ];
      expect(new Set(values).size).assertEqual(values.length);
    });

    it('success_states_are_less_than_fail_states', 0, () => {
      // 成功状态值 < 失败状态值，PartsPairController 用 >= STATE_CONNECT_SUCCESS 判断终态
      expect(PairingState.STATE_CONNECT_SUCCESS).assertLarger(PairingState.STATE_PREPARE - 1);
      expect(PairingState.STATE_PAIR_FAIL).assertLarger(PairingState.STATE_CONNECT_SUCCESS);
    });

    it('terminal_states_are_all_gte_connect_success', 0, () => {
      // PartsPairController 中 >= STATE_CONNECT_SUCCESS 触发重置定时器，所有终态必须满足此条件
      const terminalStates = [
        PairingState.STATE_CONNECT_SUCCESS,
        PairingState.STATE_PAIR_FAIL,
        PairingState.STATE_CONNECT_FAIL,
        PairingState.STATE_TIMEOUT,
        PairingState.STATE_UNKNOWN_ERROR,
      ];
      for (let i = 0; i < terminalStates.length; i++) {
        expect(terminalStates[i] >= PairingState.STATE_CONNECT_SUCCESS).assertTrue();
      }
    });

    it('non_terminal_states_are_less_than_connect_success', 0, () => {
      // 非终态不应触发重置定时器
      const nonTerminal = [
        PairingState.STATE_PREPARE,
        PairingState.STATE_PAIRING,
        PairingState.STATE_PAIRED,
      ];
      for (let i = 0; i < nonTerminal.length; i++) {
        expect(nonTerminal[i] < PairingState.STATE_CONNECT_SUCCESS).assertTrue();
      }
    });

    // ---- PairErrorCode 枚举值契约 ----
    // 错误码采用 0x1xx 段是为了与系统 BusinessError 的其他错误段隔离，
    // 便于调用方通过 code >> 8 === 1 快速判断是否为配对域错误，无需逐一比对。

    it('PAIR_FAIL_code_should_be_0x101', 0, () => {
      expect(PairErrorCode.PAIR_FAIL).assertEqual(0x101);
    });

    it('CONNECT_FAIL_code_should_be_0x102', 0, () => {
      expect(PairErrorCode.CONNECT_FAIL).assertEqual(0x102);
    });

    it('TIMEOUT_code_should_be_0x103', 0, () => {
      expect(PairErrorCode.TIMEOUT).assertEqual(0x103);
    });

    it('all_pair_error_codes_are_unique', 0, () => {
      const codes = [PairErrorCode.PAIR_FAIL, PairErrorCode.CONNECT_FAIL, PairErrorCode.TIMEOUT];
      expect(new Set(codes).size).assertEqual(3);
    });

    it('error_codes_are_in_ascending_order', 0, () => {
      // 错误码递增便于日志分类和问题排查
      expect(PairErrorCode.CONNECT_FAIL).assertLarger(PairErrorCode.PAIR_FAIL);
      expect(PairErrorCode.TIMEOUT).assertLarger(PairErrorCode.CONNECT_FAIL);
    });

    // ---- createError 工厂函数 ----
    // 统一通过工厂函数创建 BusinessError，而非各处手动构造对象，
    // 保证 code 和 message 字段始终存在且类型正确，避免调用方因字段缺失而崩溃。

    it('createError_sets_correct_code', 0, () => {
      const err = createError(PairErrorCode.TIMEOUT);
      expect(err.code).assertEqual(PairErrorCode.TIMEOUT);
    });

    it('createError_default_message_is_empty_string', 0, () => {
      // 未提供 message 时默认为空字符串，避免日志中出现 undefined
      const err = createError(PairErrorCode.PAIR_FAIL);
      expect(err.message).assertEqual('');
    });

    it('createError_custom_message_preserved', 0, () => {
      const err = createError(PairErrorCode.CONNECT_FAIL, 'device unreachable');
      expect(err.message).assertEqual('device unreachable');
    });

    it('createError_pair_fail_has_correct_code', 0, () => {
      const err = createError(PairErrorCode.PAIR_FAIL, 'pairing failed');
      expect(err.code).assertEqual(0x101);
    });

    it('createError_timeout_has_correct_code', 0, () => {
      const err = createError(PairErrorCode.TIMEOUT, 'operation timed out');
      expect(err.code).assertEqual(0x103);
    });

    it('createError_returns_object_with_code_and_message', 0, () => {
      const err = createError(PairErrorCode.CONNECT_FAIL, 'test');
      // 验证 code 和 message 字段值均存在且正确，替代 hasOwnProperty
      expect(err.code === PairErrorCode.CONNECT_FAIL).assertTrue();
      expect(err.message === 'test').assertTrue();
    });

    // ---- PartsDeviceState 枚举值契约 ----
    // STATE_NEW=0 是刻意设计的 falsy 值，允许调用方用 if (deviceState) 区分"从未见过"
    // 与"曾经连接过"的设备，简化扫描回调中的状态判断分支，减少不必要的条件嵌套。

    it('STATE_NEW_should_be_0', 0, () => {
      // 新设备值为0，是默认初始状态
      expect(PartsDeviceState.STATE_NEW).assertEqual(0);
    });

    it('STATE_CONNECTED_should_be_1', 0, () => {
      expect(PartsDeviceState.STATE_CONNECTED).assertEqual(1);
    });

    it('STATE_CONNECTING_should_be_2', 0, () => {
      expect(PartsDeviceState.STATE_CONNECTING).assertEqual(2);
    });

    it('STATE_NOT_SUPPORT_should_be_3', 0, () => {
      expect(PartsDeviceState.STATE_NOT_SUPPORT).assertEqual(3);
    });

    it('all_device_states_are_unique', 0, () => {
      const states = [
        PartsDeviceState.STATE_NEW,
        PartsDeviceState.STATE_CONNECTED,
        PartsDeviceState.STATE_CONNECTING,
        PartsDeviceState.STATE_NOT_SUPPORT,
      ];
      expect(new Set(states).size).assertEqual(4);
    });

    it('device_states_are_in_ascending_order', 0, () => {
      // 枚举值递增，便于通过数值比较过滤设备状态
      expect(PartsDeviceState.STATE_CONNECTED).assertLarger(PartsDeviceState.STATE_NEW);
      expect(PartsDeviceState.STATE_CONNECTING).assertLarger(PartsDeviceState.STATE_CONNECTED);
      expect(PartsDeviceState.STATE_NOT_SUPPORT).assertLarger(PartsDeviceState.STATE_CONNECTING);
    });

    it('STATE_NEW_is_falsy_zero', 0, () => {
      // STATE_NEW 为 0（falsy），调用方可用 if (deviceState) 区分新设备与已知设备
      expect(PartsDeviceState.STATE_NEW).assertEqual(0);
      expect(!!PartsDeviceState.STATE_NEW).assertFalse();
    });

    it('non_new_states_are_truthy', 0, () => {
      // 非新设备的状态值均非零（truthy），确保 if (deviceState) 判断正确
      expect(!!PartsDeviceState.STATE_CONNECTED).assertTrue();
      expect(!!PartsDeviceState.STATE_CONNECTING).assertTrue();
      expect(!!PartsDeviceState.STATE_NOT_SUPPORT).assertTrue();
    });

  });
}
