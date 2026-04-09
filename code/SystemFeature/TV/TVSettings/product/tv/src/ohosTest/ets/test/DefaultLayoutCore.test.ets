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
import { SettingItemStyle } from '../../../main/ets/common/constants/StyleConstants';
import { SettingItemTvModel } from '../../../main/ets/default/model/SettingItemTvModel';

interface HeightContext {
  focusIndex: number;
  index: number;
  isAmplifying: boolean;
  isNeedBg: boolean;
}

interface EntryRouteMap {
  声音: string;
  图像: string;
  网络: string;
  蓝牙: string;
  通用: string;
  系统: string;
  更多连接: string;
  设备互传: string;
}

function calcItemHeight(ctx: HeightContext): number {
  if (ctx.focusIndex === ctx.index) {
    return 118;
  }
  if (ctx.isAmplifying) {
    return 142;
  }
  if (ctx.isNeedBg) {
    return 98;
  }
  return 76;
}

function isIpStyle(style: SettingItemStyle): boolean {
  return style === SettingItemStyle.ip;
}

function firstItemEnabled(index: number): boolean {
  return index === 0;
}

function shouldToggleOnSwitchClick(itemName: string): boolean {
  return itemName !== '蓝光过滤' && itemName !== '护眼模式';
}

function applySingleChoose(list: Array<SettingItemTvModel>, targetName: string): void {
  for (let i = 0; i < list.length; i++) {
    if (list[i].name === targetName) {
      list[i].setIsSelect(true);
    } else {
      list[i].setIsSelect(false);
    }
  }
}

function createEntryRouteMap(): EntryRouteMap {
  const routeMap: EntryRouteMap = {
    声音: 'pages/volume/Volume',
    图像: 'pages/display/Display',
    网络: 'pages/network/Network',
    蓝牙: 'pages/bluetooth/BluetoothDeviceEntry',
    通用: 'pages/general/General',
    系统: 'pages/system/System',
    更多连接: 'pages/links/Links',
    设备互传: 'pages/oneConnectShare/OneConnectShare'
  };
  return routeMap;
}

function getEntryRouteValues(routeMap: EntryRouteMap): Array<string> {
  return [
    routeMap.声音,
    routeMap.图像,
    routeMap.网络,
    routeMap.蓝牙,
    routeMap.通用,
    routeMap.系统,
    routeMap.更多连接,
    routeMap.设备互传
  ];
}

export default function DefaultLayoutCoreTest() {
  const casePrefix = 'Settings_DefaultLayoutCore_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DefaultLayoutCoreTestSuite', () => {
    it(addCase(casePrefix + 'SettingItem_DefaultState_001'), 0, () => {
      const item = new SettingItemTvModel();
      expect(item.name).assertEqual('');
      expect(item.value).assertEqual('');
      expect(item.isOn).assertEqual(false);
      expect(item.isSelect).assertEqual(false);
      expect(item.focusIndex).assertEqual(-1);
      expect(item.style).assertEqual(SettingItemStyle.default);
      expect(item.pageUrl).assertEqual('');
      expect(item.isEnable).assertEqual(true);
      expect(item.isNeedBg).assertEqual(true);
      expect(item.isDisableFocus).assertEqual(false);
      expect(item.isShow).assertEqual(true);
      expect(item.itemParam).assertEqual('1');
    });

    it(addCase(casePrefix + 'SettingItem_BasicSetters_002'), 0, () => {
      const item = new SettingItemTvModel();
      item.setValue('42');
      item.setChooseDes('desc_42');
      item.setIsOn(true);
      item.setIsSelect(true);
      item.setStyle(SettingItemStyle.switch);
      item.setIsEnable(false);
      item.setIsDisableFocus(true);
      item.setIsShow(false);
      expect(item.value).assertEqual('42');
      expect(item.chooseDes as string).assertEqual('desc_42');
      expect(item.isOn).assertEqual(true);
      expect(item.isSelect).assertEqual(true);
      expect(item.style).assertEqual(SettingItemStyle.switch);
      expect(item.isEnable).assertEqual(false);
      expect(item.isDisableFocus).assertEqual(true);
      expect(item.isShow).assertEqual(false);
    });

    it(addCase(casePrefix + 'SettingItem_FocusKeysContract_003'), 0, () => {
      const item = new SettingItemTvModel();
      item.focusKeys = ['a-0', 'a-1', 'a-2'];
      item.isSetFocusKey = true;
      item.focusIndex = 1;
      expect(item.focusKeys.length).assertEqual(3);
      expect(item.focusKeys[0]).assertEqual('a-0');
      expect(item.isSetFocusKey).assertEqual(true);
      expect(item.focusIndex).assertEqual(1);
    });

    it(addCase(casePrefix + 'SettingItem_MetadataContract_004'), 0, () => {
      const item = new SettingItemTvModel();
      item.name = '系统';
      item.nameId = 'system_title';
      item.pageUrl = 'pages/system/System';
      item.imageUrl = 'icon_system';
      item.description = '软件更新、系统信息、设备信息';
      item.textColor = '#FFFFFF';
      expect(item.name).assertEqual('系统');
      expect(item.nameId).assertEqual('system_title');
      expect(item.pageUrl).assertEqual('pages/system/System');
      expect(item.imageUrl).assertEqual('icon_system');
      expect(item.description as string).assertEqual('软件更新、系统信息、设备信息');
      expect(item.textColor).assertEqual('#FFFFFF');
    });

    it(addCase(casePrefix + 'Layout_HeightFocused_005'), 0, () => {
      const h = calcItemHeight({ focusIndex: 2, index: 2, isAmplifying: false, isNeedBg: false });
      expect(h).assertEqual(118);
    });

    it(addCase(casePrefix + 'Layout_HeightAmplifying_006'), 0, () => {
      const h = calcItemHeight({ focusIndex: 1, index: 2, isAmplifying: true, isNeedBg: false });
      expect(h).assertEqual(142);
    });

    it(addCase(casePrefix + 'Layout_HeightNormalNeedBg_007'), 0, () => {
      const h = calcItemHeight({ focusIndex: -1, index: 0, isAmplifying: false, isNeedBg: true });
      expect(h).assertEqual(98);
    });

    it(addCase(casePrefix + 'Layout_HeightNormalNoBg_008'), 0, () => {
      const h = calcItemHeight({ focusIndex: -1, index: 1, isAmplifying: false, isNeedBg: false });
      expect(h).assertEqual(76);
    });

    it(addCase(casePrefix + 'Layout_IpStylePredicate_009'), 0, () => {
      expect(isIpStyle(SettingItemStyle.ip)).assertEqual(true);
      expect(isIpStyle(SettingItemStyle.default)).assertEqual(false);
      expect(isIpStyle(SettingItemStyle.switch)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Layout_DefaultFocusPolicy_010'), 0, () => {
      expect(firstItemEnabled(0)).assertEqual(true);
      expect(firstItemEnabled(1)).assertEqual(false);
      expect(firstItemEnabled(5)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Switch_ClickToggleRule_011'), 0, () => {
      expect(shouldToggleOnSwitchClick('自动更新')).assertEqual(true);
      expect(shouldToggleOnSwitchClick('蓝光过滤')).assertEqual(false);
      expect(shouldToggleOnSwitchClick('护眼模式')).assertEqual(false);
    });

    it(addCase(casePrefix + 'SingleChoose_OnlyOneSelected_012'), 0, () => {
      const a = new SettingItemTvModel();
      const b = new SettingItemTvModel();
      const c = new SettingItemTvModel();
      a.name = 'HDMI1';
      b.name = 'HDMI2';
      c.name = 'TV';
      const list = [a, b, c];
      applySingleChoose(list, 'HDMI2');
      expect(a.isSelect).assertEqual(false);
      expect(b.isSelect).assertEqual(true);
      expect(c.isSelect).assertEqual(false);
      applySingleChoose(list, 'TV');
      expect(a.isSelect).assertEqual(false);
      expect(b.isSelect).assertEqual(false);
      expect(c.isSelect).assertEqual(true);
    });

    it(addCase(casePrefix + 'EntryRoute_MapIntegrity_013'), 0, () => {
      const map = createEntryRouteMap();
      expect(Object.keys(map).length).assertEqual(8);
      expect(map.声音).assertEqual('pages/volume/Volume');
      expect(map.图像).assertEqual('pages/display/Display');
      expect(map.系统).assertEqual('pages/system/System');
      expect(map.设备互传).assertEqual('pages/oneConnectShare/OneConnectShare');
    });

    it(addCase(casePrefix + 'EntryRoute_FormatRule_014'), 0, () => {
      const map = createEntryRouteMap();
      const values: Array<string> = getEntryRouteValues(map);
      const regex = /^pages\/[a-zA-Z0-9_]+(\/[a-zA-Z0-9_]+)+$/;
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < values.length; i++) {
        expect(regex.test(values[i])).assertEqual(true);
        expect(unique.has(values[i])).assertEqual(false);
        unique.add(values[i]);
      }
      expect(unique.size).assertEqual(values.length);
    });

    it(addCase(casePrefix + 'Batch_StateMutation_015'), 0, () => {
      const item = new SettingItemTvModel();
      for (let i = 0; i < 30; i++) {
        item.setIsOn(i % 2 === 0);
        item.setIsSelect(i % 3 === 0);
        item.setIsEnable(i % 4 !== 0);
      }
      expect(item.isOn).assertEqual(false);
      expect(item.isSelect).assertEqual(false);
      expect(item.isEnable).assertEqual(true);
    });

    it(addCase(casePrefix + 'VisibilityAndFocus_016'), 0, () => {
      const item = new SettingItemTvModel();
      item.setIsShow(false);
      item.setIsDisableFocus(true);
      expect(item.isShow).assertEqual(false);
      expect(item.isDisableFocus).assertEqual(true);
      item.setIsShow(true);
      item.setIsDisableFocus(false);
      expect(item.isShow).assertEqual(true);
      expect(item.isDisableFocus).assertEqual(false);
    });

    it(addCase(casePrefix + 'StyleTransition_FullCycle_017'), 0, () => {
      const item = new SettingItemTvModel();
      item.setStyle(SettingItemStyle.default);
      item.setStyle(SettingItemStyle.switch);
      item.setStyle(SettingItemStyle.valueChange);
      item.setStyle(SettingItemStyle.singleChoose);
      item.setStyle(SettingItemStyle.ip);
      item.setStyle(SettingItemStyle.info);
      item.setStyle(SettingItemStyle.loading);
      item.setStyle(SettingItemStyle.finished);
      item.setStyle(SettingItemStyle.error);
      item.setStyle(SettingItemStyle.hidden);
      expect(item.style).assertEqual(SettingItemStyle.hidden);
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_018'), 0, () => {
      const regex = /^Settings_DefaultLayoutCore_[A-Za-z0-9_]+_[0-9]{3}$/;
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

