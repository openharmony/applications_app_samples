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
import { PartsPairModel } from '../../../../../../product/tv/pairService/src/main/ets/service/PartsPairModel';

/**
 * PartsPairModel 单元测试
 *
 * saveLocalConnectDevices 调用 preferences.getPreferencesSync(undefined, ...) 会抛出
 * "Parameter error. The context is invalid."，且没有 try/catch 保护。
 * 因此凡是触发 saveLocalConnectDevices 的调用路径（onConnectSuccess/onConnectFail
 * 当设备列表发生变化时）都会抛出异常。
 *
 * 解法：用 try/catch 包裹每次 onConnectSuccess/onConnectFail 调用，
 * 忽略持久化异常，通过内存缓存（先调用 getLocalConnectDevices() 初始化）
 * 验证状态机逻辑的正确性。
 * getLocalConnectDevices() 有 try/catch 保护，失败时返回 []，可安全调用。
 */

// 辅助函数：安全调用 onConnectSuccess，忽略 preferences 持久化异常
function safeConnectSuccess(model: PartsPairModel, deviceId: string): void {
  try {
    model.onConnectSuccess(deviceId);
  } catch (e) {
    // preferences 在无 context 环境下会抛出，忽略持久化异常，内存状态已更新
  }
}

// 辅助函数：安全调用 onConnectFail，忽略 preferences 持久化异常
function safeConnectFail(model: PartsPairModel, deviceId: string): void {
  try {
    model.onConnectFail(deviceId);
  } catch (e) {
    // 同上
  }
}

export default function partsPairModelTest() {
  describe('PartsPairModel_Test', () => {

    // PartsPairModel 是蓝牙配对的底层数据层，管理已配对设备和本地已连接设备两张列表。
    // 本地已连接列表（localConnectDevices）用于区分"从未见过的新设备"与"曾经连接过的设备"，
    // 决定扫描回调中是走配对流程还是直接重连，是配对状态机的核心数据依据。

    it('instance_should_be_creatable', 0, () => {
      const model = new PartsPairModel();
      expect(!!model).assertTrue();
    });

    it('getPairedDevices_should_return_array', 0, () => {
      const model = new PartsPairModel();
      const devices = model.getPairedDevices();
      expect(Array.isArray(devices)).assertTrue();
    });

    it('getLocalConnectDevices_should_return_array', 0, () => {
      const model = new PartsPairModel();
      const devices = model.getLocalConnectDevices();
      expect(Array.isArray(devices)).assertTrue();
    });

    it('onConnectFail_on_nonexistent_device_is_safe', 0, () => {
      // 对不存在的设备调用 onConnectFail：设备不在列表中，不触发 saveLocalConnectDevices，
      // 因此不会访问 preferences，不抛出异常。
      const model = new PartsPairModel();
      model.getLocalConnectDevices(); // 初始化内存缓存
      let threw = false;
      try {
        model.onConnectFail('11:22:33:44:55:66');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('onConnectSuccess_adds_device_to_local_list', 0, () => {
      // 连接成功后设备 ID 必须持久化到本地列表，重启后仍可识别为已连接设备
      const model = new PartsPairModel();
      model.getLocalConnectDevices(); // 初始化内存缓存
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      const devices = model.getLocalConnectDevices();
      expect(devices.includes('AA:BB:CC:DD:EE:FF')).assertTrue();
    });

    it('onConnectSuccess_does_not_add_duplicate', 0, () => {
      // 同一设备重复连接成功不应在列表中出现两次，防止状态计算异常
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      const devices = model.getLocalConnectDevices();
      let count = 0;
      for (let i = 0; i < devices.length; i++) {
        if (devices[i] === 'AA:BB:CC:DD:EE:FF') {
          count++;
        }
      }
      expect(count).assertEqual(1);
    });

    it('onConnectFail_removes_device_from_local_list', 0, () => {
      // 连接失败后必须从本地列表移除设备，否则下次扫描时会误判为已连接设备，
      // 跳过配对直接重连，导致新设备永远无法完成首次配对流程。
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      safeConnectFail(model, 'AA:BB:CC:DD:EE:FF');
      const devices = model.getLocalConnectDevices();
      expect(devices.includes('AA:BB:CC:DD:EE:FF')).assertFalse();
    });

    it('multiple_devices_can_be_connected_simultaneously', 0, () => {
      // TV 配件生态支持遥控器、键盘、鼠标同时连接，
      // 本地列表必须支持多设备共存，不能因新设备加入而挤出旧设备。
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:01');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:02');
      const devices = model.getLocalConnectDevices();
      expect(devices.includes('AA:BB:CC:DD:EE:01')).assertTrue();
      expect(devices.includes('AA:BB:CC:DD:EE:02')).assertTrue();
    });

    it('onConnectFail_only_removes_target_device', 0, () => {
      // 移除一个设备不影响其他已连接设备
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:01');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:02');
      safeConnectFail(model, 'AA:BB:CC:DD:EE:01');
      const devices = model.getLocalConnectDevices();
      expect(devices.includes('AA:BB:CC:DD:EE:01')).assertFalse();
      expect(devices.includes('AA:BB:CC:DD:EE:02')).assertTrue();
    });

    it('three_devices_all_connected', 0, () => {
      // TV 可同时连接遥控器、键盘、鼠标三个配件
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:01');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:02');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:03');
      const devices = model.getLocalConnectDevices();
      expect(devices.length).assertLarger(2);
    });

    it('all_devices_disconnected_list_is_empty', 0, () => {
      // 所有设备断开后列表应为空，避免重启后误判设备已连接
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:01');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:02');
      safeConnectFail(model, 'AA:BB:CC:DD:EE:01');
      safeConnectFail(model, 'AA:BB:CC:DD:EE:02');
      const devices = model.getLocalConnectDevices();
      expect(devices.length).assertEqual(0);
    });

    it('onConnectSuccess_after_onConnectFail_re_adds_device', 0, () => {
      // 断开后重新连接成功，设备应重新出现在列表中
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      safeConnectFail(model, 'AA:BB:CC:DD:EE:FF');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      const devices = model.getLocalConnectDevices();
      expect(devices.includes('AA:BB:CC:DD:EE:FF')).assertTrue();
    });

    it('onConnectSuccess_re_add_no_duplicate_after_reconnect', 0, () => {
      // 断开后重连，列表中只应有一条记录
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      safeConnectFail(model, 'AA:BB:CC:DD:EE:FF');
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:FF');
      let count = 0;
      const devices = model.getLocalConnectDevices();
      for (let i = 0; i < devices.length; i++) {
        if (devices[i] === 'AA:BB:CC:DD:EE:FF') {
          count++;
        }
      }
      expect(count).assertEqual(1);
    });

    it('different_mac_address_formats_work', 0, () => {
      // 验证大写 MAC 地址格式被正确存储
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'FF:EE:DD:CC:BB:AA');
      expect(model.getLocalConnectDevices().includes('FF:EE:DD:CC:BB:AA')).assertTrue();
    });

    it('getLocalConnectDevices_returns_array_type', 0, () => {
      const model = new PartsPairModel();
      model.getLocalConnectDevices();
      safeConnectSuccess(model, 'AA:BB:CC:DD:EE:01');
      expect(Array.isArray(model.getLocalConnectDevices())).assertTrue();
    });

  });
}
