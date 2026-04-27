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

interface SaveResult {
  storageKey: string;
  emitEvent: string;
  shouldBack: boolean;
}

const KEY_DPAD_UP = 2012;
const KEY_DPAD_DOWN = 2013;

function isValidIpv4Like(value: string): boolean {
  const ipv4Regex: RegExp =
    new RegExp("^((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})(\\.((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})){3}$");
  return ipv4Regex.test(value);
}

function isValidNetmask(value: string): boolean {
  const netmaskRegex: RegExp =
    new RegExp("^((128|192)|2(24|4[08]|5[245]))(\\.(0|(128|192)|2((24)|(4[08])|(5[245])))){3}$");
  return netmaskRegex.test(value);
}

function shouldMoveFocusToConfirm(inputLength: number, keyCode: number): boolean {
  return keyCode === KEY_DPAD_DOWN && inputLength >= 6;
}

function resolveEditorSaveResult(editor: 'ip' | 'gateway' | 'dns' | 'mask'): SaveResult {
  if (editor === 'ip') {
    return { storageKey: 'ipStr', emitEvent: 'updateIpRecord', shouldBack: true };
  }
  if (editor === 'gateway') {
    return { storageKey: 'gatewayStr', emitEvent: 'updateIpRecord', shouldBack: true };
  }
  if (editor === 'dns') {
    return { storageKey: 'dnsStr', emitEvent: 'updateIpRecord', shouldBack: true };
  }
  return { storageKey: 'maskStr', emitEvent: 'updateIpRecord', shouldBack: true };
}

function shouldEnableConfirm(editor: 'ip' | 'gateway' | 'dns' | 'mask', value: string): boolean {
  if (editor === 'mask') {
    return isValidNetmask(value);
  }
  return isValidIpv4Like(value);
}

function shouldConfirmByTouch(isTouchEvent: boolean, sourceAllowed: boolean, inputValid: boolean): boolean {
  return isTouchEvent && sourceAllowed && inputValid;
}

function resolveInitialInput(paramsValue: string): string {
  return paramsValue;
}

export default function InputEditorsDeepBusinessTest() {
  const casePrefix = 'Settings_InputEditorsDeep_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('InputEditorsDeepBusinessSuite', () => {
    it(addCase(casePrefix + 'IP_ValidIPv4_001'), 0, () => {
      expect(isValidIpv4Like('192.168.1.1')).assertEqual(true);
      expect(isValidIpv4Like('0.0.0.0')).assertEqual(true);
      expect(isValidIpv4Like('255.255.255.255')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IP_InvalidIPv4_002'), 0, () => {
      expect(isValidIpv4Like('256.1.1.1')).assertEqual(false);
      expect(isValidIpv4Like('1.1.1')).assertEqual(false);
      expect(isValidIpv4Like('abc.def.1.1')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Gateway_ValidIPv4_003'), 0, () => {
      expect(shouldEnableConfirm('gateway', '10.0.0.1')).assertEqual(true);
      expect(shouldEnableConfirm('gateway', '172.16.0.254')).assertEqual(true);
      expect(shouldEnableConfirm('gateway', '500.1.1.1')).assertEqual(false);
    });

    it(addCase(casePrefix + 'DNS_ValidIPv4_004'), 0, () => {
      expect(shouldEnableConfirm('dns', '8.8.8.8')).assertEqual(true);
      expect(shouldEnableConfirm('dns', '114.114.114.114')).assertEqual(true);
      expect(shouldEnableConfirm('dns', '8.8.8')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Mask_ValidSubnetMask_005'), 0, () => {
      expect(isValidNetmask('255.255.255.0')).assertEqual(true);
      expect(isValidNetmask('255.255.0.0')).assertEqual(true);
      expect(isValidNetmask('255.255.255.255')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Mask_InvalidSubnetMask_006'), 0, () => {
      expect(isValidNetmask('255.255.255.256')).assertEqual(false);
      expect(isValidNetmask('255.255.255.1')).assertEqual(false);
      expect(isValidNetmask('192.168.1.1')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Editor_SaveResultKeys_007'), 0, () => {
      expect(resolveEditorSaveResult('ip').storageKey).assertEqual('ipStr');
      expect(resolveEditorSaveResult('gateway').storageKey).assertEqual('gatewayStr');
      expect(resolveEditorSaveResult('dns').storageKey).assertEqual('dnsStr');
      expect(resolveEditorSaveResult('mask').storageKey).assertEqual('maskStr');
    });

    it(addCase(casePrefix + 'Editor_SaveResultContracts_008'), 0, () => {
      const result = resolveEditorSaveResult('ip');
      expect(result.emitEvent).assertEqual('updateIpRecord');
      expect(result.shouldBack).assertEqual(true);
    });

    it(addCase(casePrefix + 'Editor_FocusMoveThreshold_009'), 0, () => {
      expect(shouldMoveFocusToConfirm(5, KEY_DPAD_DOWN)).assertEqual(false);
      expect(shouldMoveFocusToConfirm(6, KEY_DPAD_DOWN)).assertEqual(true);
      expect(shouldMoveFocusToConfirm(15, KEY_DPAD_DOWN)).assertEqual(true);
      expect(shouldMoveFocusToConfirm(10, KEY_DPAD_UP)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Editor_TouchConfirmGate_010'), 0, () => {
      expect(shouldConfirmByTouch(true, true, true)).assertEqual(true);
      expect(shouldConfirmByTouch(false, true, true)).assertEqual(false);
      expect(shouldConfirmByTouch(true, false, true)).assertEqual(false);
      expect(shouldConfirmByTouch(true, true, false)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Editor_InitialInputRestore_011'), 0, () => {
      expect(resolveInitialInput('192.168.0.2')).assertEqual('192.168.0.2');
      expect(resolveInitialInput('255.255.255.0')).assertEqual('255.255.255.0');
      expect(resolveInitialInput('')).assertEqual('');
    });

    it(addCase(casePrefix + 'IP_ConfirmEnablement_012'), 0, () => {
      expect(shouldEnableConfirm('ip', '192.168.10.88')).assertEqual(true);
      expect(shouldEnableConfirm('ip', '999.1.1.1')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Mask_ConfirmEnablement_013'), 0, () => {
      expect(shouldEnableConfirm('mask', '255.255.252.0')).assertEqual(true);
      expect(shouldEnableConfirm('mask', '255.255.250.0')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stress_IPv4Validation_014'), 0, () => {
      const inputs = ['192.168.1.1', '8.8.8.8', '256.1.1.1', '1.1.1', '10.0.0.1'];
      let validCount = 0;
      for (let i = 0; i < 200; i++) {
        if (isValidIpv4Like(inputs[i % inputs.length])) {
          validCount++;
        }
      }
      expect(validCount > 0).assertEqual(true);
      expect(validCount < 200).assertEqual(true);
    });

    it(addCase(casePrefix + 'Stress_MaskValidation_015'), 0, () => {
      const inputs = ['255.255.255.0', '255.255.0.0', '255.255.255.256', '255.255.255.1'];
      let validCount = 0;
      for (let i = 0; i < 160; i++) {
        if (isValidNetmask(inputs[i % inputs.length])) {
          validCount++;
        }
      }
      expect(validCount > 0).assertEqual(true);
      expect(validCount < 160).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_016'), 0, () => {
      const regex = /^Settings_InputEditorsDeep_[A-Za-z0-9_]+_[0-9]{3}$/;
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

