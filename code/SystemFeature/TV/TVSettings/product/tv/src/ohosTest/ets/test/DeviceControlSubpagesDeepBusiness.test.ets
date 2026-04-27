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

interface PortActionResult {
  portIndex: number;
  shouldInvoke: boolean;
}

interface ToastResult {
  message: string;
}

function resolveHdmiInPortAction(name: string): PortActionResult {
  if (name === 'HDMI1') {
    return { portIndex: 1, shouldInvoke: true };
  }
  if (name === 'HDMI2') {
    return { portIndex: 2, shouldInvoke: true };
  }
  if (name === 'HDMI3') {
    return { portIndex: 3, shouldInvoke: true };
  }
  if (name === 'HDMI4') {
    return { portIndex: 4, shouldInvoke: true };
  }
  return { portIndex: -1, shouldInvoke: false };
}

function resolveHdmiOutPortAction(name: string): PortActionResult {
  if (name === 'HDMI1') {
    return { portIndex: 0, shouldInvoke: true };
  }
  if (name === 'HDMI2') {
    return { portIndex: 1, shouldInvoke: true };
  }
  if (name === 'HDMI3') {
    return { portIndex: 2, shouldInvoke: true };
  }
  if (name === 'HDMI4') {
    return { portIndex: 3, shouldInvoke: true };
  }
  return { portIndex: -1, shouldInvoke: false };
}

function resolveUsbPortAction(name: string): PortActionResult {
  if (name === 'USB1') {
    return { portIndex: 0, shouldInvoke: true };
  }
  if (name === 'USB2') {
    return { portIndex: 1, shouldInvoke: true };
  }
  if (name === 'USB3') {
    return { portIndex: 2, shouldInvoke: true };
  }
  if (name === 'USB4') {
    return { portIndex: 3, shouldInvoke: true };
  }
  return { portIndex: -1, shouldInvoke: false };
}

function resolveEnableFailureToast(deviceType: string, index: number, apiSuccess: boolean, isException: boolean): ToastResult {
  if (apiSuccess) {
    return { message: '' };
  }
  if (deviceType === 'HDMIIN') {
    return { message: isException ? `设置HDMI${index}输入接口报错` : `设置HDMI${index}输入开关失败` };
  }
  if (deviceType === 'HDMIOUT') {
    return { message: isException ? `设置HDMI${index + 1}输出接口报错` : `设置HDMI${index + 1}输出开关失败` };
  }
  return { message: isException ? `设置USB${index + 1}接口报错` : `设置USB${index + 1}开关失败` };
}

function resolveReceiverBtSwitchStatus(status: number): boolean {
  return status !== 0;
}

function resolveDeleteRemoteControlPairState(result: number): boolean {
  return result === 0;
}

function resolveReceiverInsertState(vendor: number, product: number): boolean {
  return vendor === 0x000d && product === 0x3840;
}

function resolveDeletePairToast(isPoint: boolean, isReport: boolean, isDeleted: boolean): string {
  if (!isReport) {
    return '请先插入指向遥控器接收器';
  }
  if (isPoint) {
    return '';
  }
  if (isDeleted) {
    return '已删除配对信息';
  }
  return '正在删除配对信息';
}

function resolveOpenScanToast(isPoint: boolean, isReport: boolean, isDeleted: boolean, receiverBtSwitchStatus: boolean): string {
  if (!isReport) {
    return '请先插入指向遥控器接收器';
  }
  if (isPoint) {
    return '';
  }
  if (receiverBtSwitchStatus) {
    return '蓝牙扫描开关已打开';
  }
  if (!isDeleted) {
    return '请先删除配对信息';
  }
  return '打开蓝牙扫描开关中';
}

export default function DeviceControlSubpagesDeepBusinessTest() {
  const casePrefix = 'Settings_DeviceControlSubDeep_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DeviceControlSubpagesDeepBusinessSuite', () => {
    it(addCase(casePrefix + 'HDMIIN_PortMap_001'), 0, () => {
      expect(resolveHdmiInPortAction('HDMI1').portIndex).assertEqual(1);
      expect(resolveHdmiInPortAction('HDMI4').portIndex).assertEqual(4);
      expect(resolveHdmiInPortAction('AV1').shouldInvoke).assertEqual(false);
    });

    it(addCase(casePrefix + 'HDMIOUT_PortMap_002'), 0, () => {
      expect(resolveHdmiOutPortAction('HDMI1').portIndex).assertEqual(0);
      expect(resolveHdmiOutPortAction('HDMI4').portIndex).assertEqual(3);
      expect(resolveHdmiOutPortAction('DP1').shouldInvoke).assertEqual(false);
    });

    it(addCase(casePrefix + 'USB_PortMap_003'), 0, () => {
      expect(resolveUsbPortAction('USB1').portIndex).assertEqual(0);
      expect(resolveUsbPortAction('USB4').portIndex).assertEqual(3);
      expect(resolveUsbPortAction('TYPEC').shouldInvoke).assertEqual(false);
    });

    it(addCase(casePrefix + 'Device_EnableFailureToast_004'), 0, () => {
      expect(resolveEnableFailureToast('HDMIIN', 2, false, false).message).assertEqual('设置HDMI2输入开关失败');
      expect(resolveEnableFailureToast('HDMIOUT', 1, false, true).message).assertEqual('设置HDMI2输出接口报错');
      expect(resolveEnableFailureToast('USB', 0, false, false).message).assertEqual('设置USB1开关失败');
      expect(resolveEnableFailureToast('USB', 0, true, false).message).assertEqual('');
    });

    it(addCase(casePrefix + 'Controller_ReceiverBtState_005'), 0, () => {
      expect(resolveReceiverBtSwitchStatus(0)).assertEqual(false);
      expect(resolveReceiverBtSwitchStatus(1)).assertEqual(true);
      expect(resolveReceiverBtSwitchStatus(2)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Controller_DeletePairState_006'), 0, () => {
      expect(resolveDeleteRemoteControlPairState(0)).assertEqual(true);
      expect(resolveDeleteRemoteControlPairState(-1)).assertEqual(false);
      expect(resolveDeleteRemoteControlPairState(1)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Controller_ReceiverInsert_007'), 0, () => {
      expect(resolveReceiverInsertState(0x000d, 0x3840)).assertEqual(true);
      expect(resolveReceiverInsertState(0xbda, 0x8773)).assertEqual(false);
      expect(resolveReceiverInsertState(0x000d, 0x0001)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Controller_DeletePairToast_008'), 0, () => {
      expect(resolveDeletePairToast(false, false, false)).assertEqual('请先插入指向遥控器接收器');
      expect(resolveDeletePairToast(false, true, false)).assertEqual('正在删除配对信息');
      expect(resolveDeletePairToast(false, true, true)).assertEqual('已删除配对信息');
      expect(resolveDeletePairToast(true, true, true)).assertEqual('');
    });

    it(addCase(casePrefix + 'Controller_OpenScanToast_009'), 0, () => {
      expect(resolveOpenScanToast(false, false, false, false)).assertEqual('请先插入指向遥控器接收器');
      expect(resolveOpenScanToast(false, true, false, false)).assertEqual('请先删除配对信息');
      expect(resolveOpenScanToast(false, true, true, false)).assertEqual('打开蓝牙扫描开关中');
      expect(resolveOpenScanToast(false, true, true, true)).assertEqual('蓝牙扫描开关已打开');
    });

    it(addCase(casePrefix + 'Contract_HdmiInUniqueRouting_010'), 0, () => {
      const ports = ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4'];
      const values: Set<number> = new Set<number>();
      for (let i = 0; i < ports.length; i++) {
        values.add(resolveHdmiInPortAction(ports[i]).portIndex);
      }
      expect(values.size).assertEqual(4);
    });

    it(addCase(casePrefix + 'Contract_HdmiOutUniqueRouting_011'), 0, () => {
      const ports = ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4'];
      const values: Set<number> = new Set<number>();
      for (let i = 0; i < ports.length; i++) {
        values.add(resolveHdmiOutPortAction(ports[i]).portIndex);
      }
      expect(values.size).assertEqual(4);
    });

    it(addCase(casePrefix + 'Contract_UsbUniqueRouting_012'), 0, () => {
      const ports = ['USB1', 'USB2', 'USB3', 'USB4'];
      const values: Set<number> = new Set<number>();
      for (let i = 0; i < ports.length; i++) {
        values.add(resolveUsbPortAction(ports[i]).portIndex);
      }
      expect(values.size).assertEqual(4);
    });

    it(addCase(casePrefix + 'Stress_DeviceRouting_013'), 0, () => {
      let valid = true;
      const names = ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4', 'USB1', 'USB2', 'USB3', 'USB4'];
      for (let i = 0; i < 200; i++) {
        const name = names[i % names.length];
        const result = name.indexOf('USB') === 0 ? resolveUsbPortAction(name) : resolveHdmiOutPortAction(name);
        if (!result.shouldInvoke || result.portIndex < 0 || result.portIndex > 4) {
          valid = false;
        }
      }
      expect(valid).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_ControllerToastFlow_014'), 0, () => {
      const matrix = [
        resolveDeletePairToast(false, false, false),
        resolveDeletePairToast(false, true, false),
        resolveOpenScanToast(false, true, false, false),
        resolveOpenScanToast(false, true, true, true)
      ];
      expect(matrix[0]).assertEqual('请先插入指向遥控器接收器');
      expect(matrix[1]).assertEqual('正在删除配对信息');
      expect(matrix[2]).assertEqual('请先删除配对信息');
      expect(matrix[3]).assertEqual('蓝牙扫描开关已打开');
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_015'), 0, () => {
      const regex = /^Settings_DeviceControlSubDeep_[A-Za-z0-9_]+_[0-9]{3}$/;
      const names: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(names.has(allCaseNames[i])).assertEqual(false);
        names.add(allCaseNames[i]);
      }
      expect(names.size).assertEqual(allCaseNames.length);
    });
  });
}

