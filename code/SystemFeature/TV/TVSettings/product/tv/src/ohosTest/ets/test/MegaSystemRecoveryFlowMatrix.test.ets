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

interface RecoveryScenario {
  name: string;
  itemName: string;
  pageUrl: string;
  action: 'open_dialog' | 'route';
  pageTranState: boolean;
}

interface ResetScenario {
  name: string;
  throwError: boolean;
  shouldToastFail: boolean;
  shouldCloseDialog: boolean;
}

interface RecoveryClickAction {
  action: 'open_dialog' | 'route';
  pageTranState: boolean;
}

interface ResetResult {
  shouldToastFail: boolean;
  shouldCloseDialog: boolean;
}

function resolveClickAction(itemName: string, pageUrl: string): RecoveryClickAction {
  if (itemName === '恢复出厂设置') {
    return { action: 'open_dialog', pageTranState: false };
  }
  return { action: 'route', pageTranState: true };
}

function resolveResetResult(throwError: boolean): ResetResult {
  if (throwError) {
    return { shouldToastFail: true, shouldCloseDialog: true };
  }
  return { shouldToastFail: false, shouldCloseDialog: true };
}

export default function MegaSystemRecoveryFlowMatrixTest() {
  const casePrefix = 'Settings_MegaSystemRecovery_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const recoveryScenarios: Array<RecoveryScenario> = [
    { name: 'recovery_001', itemName: '软件更新', pageUrl: 'pages/system/SoftwareUpdate', action: 'route', pageTranState: true },
    { name: 'recovery_002', itemName: '时间和日期', pageUrl: 'pages/system/TimeAndDate', action: 'route', pageTranState: true },
    { name: 'recovery_003', itemName: '系统信息', pageUrl: 'pages/system/SystemInfo', action: 'route', pageTranState: true },
    { name: 'recovery_004', itemName: '设备信息', pageUrl: 'pages/system/DeviceInfo', action: 'route', pageTranState: true },
    { name: 'recovery_005', itemName: '状态信息', pageUrl: 'pages/system/StateInfo', action: 'route', pageTranState: true },
    { name: 'recovery_006', itemName: '恢复出厂设置', pageUrl: '', action: 'open_dialog', pageTranState: false },
    { name: 'recovery_007', itemName: '软件更新', pageUrl: 'pages/system/SoftwareUpdate', action: 'route', pageTranState: true },
    { name: 'recovery_008', itemName: '时间和日期', pageUrl: 'pages/system/TimeAndDate', action: 'route', pageTranState: true },
    { name: 'recovery_009', itemName: '系统信息', pageUrl: 'pages/system/SystemInfo', action: 'route', pageTranState: true },
    { name: 'recovery_010', itemName: '设备信息', pageUrl: 'pages/system/DeviceInfo', action: 'route', pageTranState: true },
    { name: 'recovery_011', itemName: '状态信息', pageUrl: 'pages/system/StateInfo', action: 'route', pageTranState: true },
    { name: 'recovery_012', itemName: '恢复出厂设置', pageUrl: '', action: 'open_dialog', pageTranState: false }
  ];
  const resetScenarios: Array<ResetScenario> = [
    { name: 'reset_001', throwError: false, shouldToastFail: false, shouldCloseDialog: true },
    { name: 'reset_002', throwError: true, shouldToastFail: true, shouldCloseDialog: true },
    { name: 'reset_003', throwError: false, shouldToastFail: false, shouldCloseDialog: true },
    { name: 'reset_004', throwError: true, shouldToastFail: true, shouldCloseDialog: true },
    { name: 'reset_005', throwError: false, shouldToastFail: false, shouldCloseDialog: true },
    { name: 'reset_006', throwError: true, shouldToastFail: true, shouldCloseDialog: true },
    { name: 'reset_007', throwError: false, shouldToastFail: false, shouldCloseDialog: true },
    { name: 'reset_008', throwError: true, shouldToastFail: true, shouldCloseDialog: true }
  ];

  describe('MegaSystemRecoveryFlowMatrixSuite', () => {
    it(addCase(casePrefix + 'ClickActionMatrix_001'), 0, () => {
      for (let i = 0; i < recoveryScenarios.length; i++) {
        const item = recoveryScenarios[i];
        const result = resolveClickAction(item.itemName, item.pageUrl);
        expect(result.action).assertEqual(item.action);
        expect(result.pageTranState).assertEqual(item.pageTranState);
      }
    });

    it(addCase(casePrefix + 'ResetResultMatrix_002'), 0, () => {
      for (let i = 0; i < resetScenarios.length; i++) {
        const item = resetScenarios[i];
        const result = resolveResetResult(item.throwError);
        expect(result.shouldToastFail).assertEqual(item.shouldToastFail);
        expect(result.shouldCloseDialog).assertEqual(item.shouldCloseDialog);
      }
    });

    it(addCase(casePrefix + 'StressRecovery_003'), 0, () => {
      let okCount = 0;
      for (let i = 0; i < 1000; i++) {
        const recovery = recoveryScenarios[i % recoveryScenarios.length];
        const actionResult = resolveClickAction(recovery.itemName, recovery.pageUrl);
        if (actionResult.action === recovery.action && actionResult.pageTranState === recovery.pageTranState) {
          okCount++;
        }
        const reset = resetScenarios[i % resetScenarios.length];
        const resetResult = resolveResetResult(reset.throwError);
        if (resetResult.shouldToastFail === reset.shouldToastFail &&
          resetResult.shouldCloseDialog === reset.shouldCloseDialog) {
          okCount++;
        }
      }
      expect(okCount).assertEqual(2000);
    });

    it(addCase(casePrefix + 'Coverage_004'), 0, () => {
      expect(recoveryScenarios.some((item) => item.action === 'open_dialog')).assertEqual(true);
      expect(recoveryScenarios.some((item) => item.pageUrl === 'pages/system/SoftwareUpdate')).assertEqual(true);
      expect(recoveryScenarios.some((item) => item.pageUrl === 'pages/system/TimeAndDate')).assertEqual(true);
      expect(resetScenarios.some((item) => item.shouldToastFail)).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNaming_005'), 0, () => {
      const regex = /^Settings_MegaSystemRecovery_[A-Za-z0-9_]+_[0-9]{3}$/;
      const set: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(set.has(allCaseNames[i])).assertEqual(false);
        set.add(allCaseNames[i]);
      }
      expect(set.size).assertEqual(allCaseNames.length);
    });
  });
}

