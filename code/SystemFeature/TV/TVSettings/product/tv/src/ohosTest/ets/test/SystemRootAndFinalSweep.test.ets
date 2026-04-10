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

interface SystemEntry {
  name: string;
  pageUrl: string;
  description: string;
}

interface ClickActionResult {
  action: 'open_dialog' | 'route';
  pageTranState: boolean;
  pageUrl: string;
}

interface ResetResult {
  shouldToastFail: boolean;
  shouldCloseDialog: boolean;
}

interface ProgressFocusResult {
  focusIndex: number;
  disableUsbFocus: boolean;
}

function buildSystemEntries(currentVersionInfo: string): SystemEntry[] {
  return [
    { name: '软件更新', pageUrl: 'pages/system/SoftwareUpdate', description: currentVersionInfo },
    { name: '时间和日期', pageUrl: 'pages/system/TimeAndDate', description: '设置系统时间和日期' },
    { name: '恢复出厂设置', pageUrl: '', description: '恢复出厂设置并清除数据' },
    { name: '系统信息', pageUrl: 'pages/system/SystemInfo', description: '查看系统信息' },
    { name: '设备信息', pageUrl: 'pages/system/DeviceInfo', description: '查看设备信息' },
    { name: '状态信息', pageUrl: 'pages/system/StateInfo', description: '查看状态信息' }
  ];
}

function resolveSystemClickAction(itemName: string, pageUrl: string): ClickActionResult {
  if (itemName === '恢复出厂设置') {
    return { action: 'open_dialog', pageTranState: false, pageUrl: '' };
  }
  return { action: 'route', pageTranState: true, pageUrl };
}

function resolvePageTransitionDirection(pageTranState: boolean): string {
  return pageTranState ? 'left' : 'right';
}

function resolveResetResult(throwError: boolean): ResetResult {
  if (throwError) {
    return { shouldToastFail: true, shouldCloseDialog: true };
  }
  return { shouldToastFail: false, shouldCloseDialog: true };
}

function resolveCurrentVersionInfo(version: string, hasError: boolean): string {
  if (hasError) {
    return '软件更新';
  }
  return `当前版本${version}`;
}

function resolveResumeState(versionDigest: string): boolean {
  return versionDigest === '';
}

function resolveProgressLabel(curProgress: number, updateState: string): string {
  return curProgress === 100 ? '下载完成' : updateState;
}

function resolveProgressFocus(onFocus: boolean): ProgressFocusResult {
  if (onFocus) {
    return { focusIndex: 0, disableUsbFocus: true };
  }
  return { focusIndex: -1, disableUsbFocus: false };
}

function buildApplyUpgradePaths(upgradePackagesPath: string): string[] {
  return [upgradePackagesPath];
}

function resolveDescriptionByFocus(entries: SystemEntry[], itemName: string): string {
  for (let i = 0; i < entries.length; i++) {
    if (entries[i].name === itemName) {
      return entries[i].description;
    }
  }
  return '';
}

export default function SystemRootAndFinalSweepTest() {
  const casePrefix = 'Settings_SystemRootFinal_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('SystemRootAndFinalSweepSuite', () => {
    it(addCase(casePrefix + 'System_MenuBuild_001'), 0, () => {
      const entries = buildSystemEntries('当前版本6.0.1');
      expect(entries.length).assertEqual(6);
      expect(entries[0].name).assertEqual('软件更新');
      expect(entries[0].pageUrl).assertEqual('pages/system/SoftwareUpdate');
      expect(entries[2].name).assertEqual('恢复出厂设置');
      expect(entries[2].pageUrl).assertEqual('');
      expect(entries[5].pageUrl).assertEqual('pages/system/StateInfo');
    });

    it(addCase(casePrefix + 'System_ClickAction_002'), 0, () => {
      const reset = resolveSystemClickAction('恢复出厂设置', '');
      const route = resolveSystemClickAction('设备信息', 'pages/system/DeviceInfo');
      expect(reset.action).assertEqual('open_dialog');
      expect(reset.pageTranState).assertEqual(false);
      expect(route.action).assertEqual('route');
      expect(route.pageTranState).assertEqual(true);
      expect(route.pageUrl).assertEqual('pages/system/DeviceInfo');
    });

    it(addCase(casePrefix + 'System_PageTransition_003'), 0, () => {
      expect(resolvePageTransitionDirection(true)).assertEqual('left');
      expect(resolvePageTransitionDirection(false)).assertEqual('right');
    });

    it(addCase(casePrefix + 'System_ResetResult_004'), 0, () => {
      const ok = resolveResetResult(false);
      const fail = resolveResetResult(true);
      expect(ok.shouldCloseDialog).assertEqual(true);
      expect(ok.shouldToastFail).assertEqual(false);
      expect(fail.shouldCloseDialog).assertEqual(true);
      expect(fail.shouldToastFail).assertEqual(true);
    });

    it(addCase(casePrefix + 'System_CurrentVersionFallback_005'), 0, () => {
      expect(resolveCurrentVersionInfo('5.1.2', false)).assertEqual('当前版本5.1.2');
      expect(resolveCurrentVersionInfo('5.1.2', true)).assertEqual('软件更新');
    });

    it(addCase(casePrefix + 'SoftwareUpdate_ResumeState_006'), 0, () => {
      expect(resolveResumeState('')).assertEqual(true);
      expect(resolveResumeState('digest_value')).assertEqual(false);
    });

    it(addCase(casePrefix + 'SoftwareUpdate_ProgressLabel_007'), 0, () => {
      expect(resolveProgressLabel(100, '正在检测...')).assertEqual('下载完成');
      expect(resolveProgressLabel(56, '正在检测...')).assertEqual('正在检测...');
    });

    it(addCase(casePrefix + 'SoftwareUpdate_ProgressFocus_008'), 0, () => {
      const focus = resolveProgressFocus(true);
      const blur = resolveProgressFocus(false);
      expect(focus.focusIndex).assertEqual(0);
      expect(focus.disableUsbFocus).assertEqual(true);
      expect(blur.focusIndex).assertEqual(-1);
      expect(blur.disableUsbFocus).assertEqual(false);
    });

    it(addCase(casePrefix + 'SoftwareUpdate_ApplyPath_009'), 0, () => {
      const paths = buildApplyUpgradePaths('/storage/External/usb1/updater_full.zip');
      expect(paths.length).assertEqual(1);
      expect(paths[0].endsWith('updater_full.zip')).assertEqual(true);
    });

    it(addCase(casePrefix + 'System_FocusDescription_010'), 0, () => {
      const entries = buildSystemEntries('当前版本6.0.1');
      expect(resolveDescriptionByFocus(entries, '软件更新')).assertEqual('当前版本6.0.1');
      expect(resolveDescriptionByFocus(entries, '状态信息')).assertEqual('查看状态信息');
      expect(resolveDescriptionByFocus(entries, '未知')).assertEqual('');
    });

    it(addCase(casePrefix + 'Stress_SystemRouteSweep_011'), 0, () => {
      const entries = buildSystemEntries('当前版本6.0.1');
      let routeCount = 0;
      let dialogCount = 0;
      for (let i = 0; i < 120; i++) {
        const item = entries[i % entries.length];
        const result = resolveSystemClickAction(item.name, item.pageUrl);
        if (result.action === 'route') {
          routeCount++;
        } else {
          dialogCount++;
        }
      }
      expect(routeCount > 0).assertEqual(true);
      expect(dialogCount > 0).assertEqual(true);
      expect(routeCount + dialogCount).assertEqual(120);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_012'), 0, () => {
      const regex = /^Settings_SystemRootFinal_[A-Za-z0-9_]+_[0-9]{3}$/;
      const seen: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(seen.has(allCaseNames[i])).assertEqual(false);
        seen.add(allCaseNames[i]);
      }
      expect(seen.size).assertEqual(allCaseNames.length);
    });
  });
}

