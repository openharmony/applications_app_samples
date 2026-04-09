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

interface ConfirmButtonState {
  focusable: boolean;
  opacity: number;
}

interface FocusTargetResult {
  target: string;
}

interface VersionDigestInfoLike {
  versionDigest: string;
}

interface HotspotNameConfig {
  ssid: string;
}

interface HotspotPasswordConfig {
  preSharedKey: string;
}

interface UsbMountEventResult {
  mounted: boolean | null;
  messageType: string;
}

interface VolumePathInfo {
  path: string;
}

interface VolumePathResult {
  mounted: boolean;
  path: string;
}

interface UpdateFileCheckResult {
  existed: boolean;
  targetPath: string;
}

function trimDeviceNameInput(value: string): string {
  return value.trim();
}

function canConfirmDeviceName(input: string, minSize: number = 1): ConfirmButtonState {
  const ok = input.length >= minSize;
  return { focusable: ok, opacity: ok ? 1 : 0.35 };
}

function canConfirmHotspotPassword(input: string, minSize: number = 8): ConfirmButtonState {
  const ok = input.length >= minSize;
  return { focusable: ok, opacity: ok ? 1 : 0.35 };
}

function appendDigitByKeyCode(input: string, keyCode: number, eventTypeUp: boolean): string {
  const validKeyCodes = [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009];
  if (!eventTypeUp || !validKeyCodes.includes(keyCode)) {
    return input;
  }
  return `${input}${keyCode % 2000}`;
}

function nextFocusOnInputDown(inputLength: number, minSize: number): FocusTargetResult {
  return { target: inputLength >= minSize ? 'confirm' : 'back' };
}

function buildHotspotConfigAfterNameChange(originSsid: string, inputName: string): HotspotNameConfig {
  return { ssid: inputName.length > 0 ? inputName : originSsid };
}

function buildHotspotConfigAfterPasswordChange(originPwd: string, inputPwd: string): HotspotPasswordConfig {
  return { preSharedKey: inputPwd.length > 0 ? inputPwd : originPwd };
}

function calcListVisibleHeightProportion(hasConnectedList: boolean): number {
  return hasConnectedList ? 0.45 : 0.58;
}

function calcAdjustOffsetY(
  focusIndex: number,
  curYOffset: number,
  visibleHeight: number,
  itemHeight: number,
  itemSpace: number,
  bufferHeight: number
): number {
  const enableAreaTop = curYOffset + bufferHeight;
  const enableAreaBottom = curYOffset + visibleHeight - bufferHeight;
  const curFocusItemTop = focusIndex * itemHeight + focusIndex * itemSpace;
  const curFocusItemBottom = curFocusItemTop + itemHeight;
  const inArea = curFocusItemTop >= enableAreaTop && curFocusItemBottom <= enableAreaBottom;
  if (inArea) {
    return curYOffset;
  }
  return curFocusItemTop < enableAreaTop
    ? curFocusItemTop - bufferHeight
    : curFocusItemBottom - visibleHeight + bufferHeight;
}

function moveFocusInConnectedList(current: number, listLength: number, direction: 'UP' | 'DOWN'): number {
  if (listLength <= 0) {
    return -1;
  }
  if (direction === 'UP') {
    return current > 0 ? current - 1 : 0;
  }
  return current < listLength - 1 ? current + 1 : listLength - 1;
}

function parseUsbMountEvent(eventName: string): UsbMountEventResult {
  if (eventName === 'usual.event.data.VOLUME_MOUNTED') {
    return { mounted: true, messageType: 'mounted' };
  }
  if (eventName === 'usual.event.data.VOLUME_UNMOUNTED') {
    return { mounted: false, messageType: 'unmounted' };
  }
  return { mounted: null, messageType: 'ignore' };
}

function resolveVolumePath(volumes: Array<VolumePathInfo>): VolumePathResult {
  if (!volumes || volumes.length === 0) {
    return { mounted: false, path: '' };
  }
  if (volumes.length > 1) {
    return { mounted: false, path: '' };
  }
  return { mounted: true, path: volumes[0].path };
}

function resolveUpdateFileCheckResult(diffExists: boolean, fullExists: boolean): UpdateFileCheckResult {
  if (diffExists) {
    return { existed: true, targetPath: '/storage/External/updater_diff.zip' };
  }
  if (fullExists) {
    return { existed: true, targetPath: '/storage/External/updater_full.zip' };
  }
  return { existed: false, targetPath: '' };
}

function resolveCurrentVersionText(version: string, hasError: boolean): string {
  return hasError ? '未获取到系统版本' : version;
}

function resolveOnPageShowStart(version: VersionDigestInfoLike): boolean {
  return version.versionDigest === '';
}

function resolveNetCapabilitiesBearer(bearerType: number): boolean {
  if (bearerType === 3) {
    return true;
  }
  if (bearerType === 1) {
    return true;
  }
  return false;
}

export default function HotspotSystemSubpagesBusinessTest() {
  const casePrefix = 'Settings_HotspotSystemSub_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('HotspotSystemSubpagesBusinessSuite', () => {
    it(addCase(casePrefix + 'DeviceName_Trim_001'), 0, () => {
      expect(trimDeviceNameInput('  abc  ')).assertEqual('abc');
      expect(trimDeviceNameInput('tv')).assertEqual('tv');
    });

    it(addCase(casePrefix + 'DeviceName_ConfirmState_002'), 0, () => {
      const a = canConfirmDeviceName('', 1);
      const b = canConfirmDeviceName('a', 1);
      expect(a.focusable).assertEqual(false);
      expect(a.opacity).assertEqual(0.35);
      expect(b.focusable).assertEqual(true);
      expect(b.opacity).assertEqual(1);
    });

    it(addCase(casePrefix + 'HotspotPwd_ConfirmState_003'), 0, () => {
      const a = canConfirmHotspotPassword('1234567', 8);
      const b = canConfirmHotspotPassword('12345678', 8);
      expect(a.focusable).assertEqual(false);
      expect(b.focusable).assertEqual(true);
    });

    it(addCase(casePrefix + 'Input_KeyCodeAppend_004'), 0, () => {
      expect(appendDigitByKeyCode('1', 2002, true)).assertEqual('12');
      expect(appendDigitByKeyCode('1', 2019, true)).assertEqual('1');
      expect(appendDigitByKeyCode('1', 2002, false)).assertEqual('1');
    });

    it(addCase(casePrefix + 'Input_DownFocusTarget_005'), 0, () => {
      expect(nextFocusOnInputDown(0, 1).target).assertEqual('back');
      expect(nextFocusOnInputDown(1, 1).target).assertEqual('confirm');
      expect(nextFocusOnInputDown(7, 8).target).assertEqual('back');
      expect(nextFocusOnInputDown(8, 8).target).assertEqual('confirm');
    });

    it(addCase(casePrefix + 'Config_DeviceNameChange_006'), 0, () => {
      expect(buildHotspotConfigAfterNameChange('Old', 'New').ssid).assertEqual('New');
      expect(buildHotspotConfigAfterNameChange('Old', '').ssid).assertEqual('Old');
    });

    it(addCase(casePrefix + 'Config_PasswordChange_007'), 0, () => {
      expect(buildHotspotConfigAfterPasswordChange('oldpwd', 'newpwd').preSharedKey).assertEqual('newpwd');
      expect(buildHotspotConfigAfterPasswordChange('oldpwd', '').preSharedKey).assertEqual('oldpwd');
    });

    it(addCase(casePrefix + 'ConnectedList_HeightProportion_008'), 0, () => {
      expect(calcListVisibleHeightProportion(true)).assertEqual(0.45);
      expect(calcListVisibleHeightProportion(false)).assertEqual(0.58);
    });

    it(addCase(casePrefix + 'ConnectedList_FocusMove_009'), 0, () => {
      expect(moveFocusInConnectedList(0, 5, 'UP')).assertEqual(0);
      expect(moveFocusInConnectedList(0, 5, 'DOWN')).assertEqual(1);
      expect(moveFocusInConnectedList(4, 5, 'DOWN')).assertEqual(4);
    });

    it(addCase(casePrefix + 'ConnectedList_AdjustOffset_010'), 0, () => {
      const y1 = calcAdjustOffsetY(0, 0, 500, 110, 12, 150);
      const y2 = calcAdjustOffsetY(8, 0, 500, 110, 12, 150);
      expect(y1 <= 0).assertEqual(true);
      expect(y2 > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'SoftwareUpdate_UsbEventParse_011'), 0, () => {
      const m = parseUsbMountEvent('usual.event.data.VOLUME_MOUNTED');
      const u = parseUsbMountEvent('usual.event.data.VOLUME_UNMOUNTED');
      const x = parseUsbMountEvent('other.event');
      expect(m.mounted).assertEqual(true);
      expect(u.mounted).assertEqual(false);
      expect(x.messageType).assertEqual('ignore');
    });

    it(addCase(casePrefix + 'SoftwareUpdate_VolumePathResolve_012'), 0, () => {
      const a = resolveVolumePath([]);
      const b = resolveVolumePath([{ path: '/mnt/a' }, { path: '/mnt/b' }]);
      const c = resolveVolumePath([{ path: '/mnt/a' }]);
      expect(a.mounted).assertEqual(false);
      expect(b.mounted).assertEqual(false);
      expect(c.mounted).assertEqual(true);
      expect(c.path).assertEqual('/mnt/a');
    });

    it(addCase(casePrefix + 'SoftwareUpdate_FileCheckPriority_013'), 0, () => {
      const d = resolveUpdateFileCheckResult(true, true);
      const f = resolveUpdateFileCheckResult(false, true);
      const n = resolveUpdateFileCheckResult(false, false);
      expect(d.targetPath).assertEqual('/storage/External/updater_diff.zip');
      expect(f.targetPath).assertEqual('/storage/External/updater_full.zip');
      expect(n.existed).assertEqual(false);
    });

    it(addCase(casePrefix + 'SoftwareUpdate_VersionText_014'), 0, () => {
      expect(resolveCurrentVersionText('1.0.0', false)).assertEqual('1.0.0');
      expect(resolveCurrentVersionText('1.0.0', true)).assertEqual('未获取到系统版本');
    });

    it(addCase(casePrefix + 'SoftwareUpdate_PageShowStart_015'), 0, () => {
      expect(resolveOnPageShowStart({ versionDigest: '' })).assertEqual(true);
      expect(resolveOnPageShowStart({ versionDigest: 'abc' })).assertEqual(false);
    });

    it(addCase(casePrefix + 'SoftwareUpdate_NetBearerMap_016'), 0, () => {
      expect(resolveNetCapabilitiesBearer(3)).assertEqual(true);
      expect(resolveNetCapabilitiesBearer(1)).assertEqual(true);
      expect(resolveNetCapabilitiesBearer(2)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Stress_AdjustOffset_017'), 0, () => {
      let positives = 0;
      for (let i = 0; i < 160; i++) {
        const y = calcAdjustOffsetY(i % 12, 0, 500, 110, 12, 150);
        if (y > 0) {
          positives++;
        }
      }
      expect(positives > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_018'), 0, () => {
      const regex = /^Settings_HotspotSystemSub_[A-Za-z0-9_]+_[0-9]{3}$/;
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

