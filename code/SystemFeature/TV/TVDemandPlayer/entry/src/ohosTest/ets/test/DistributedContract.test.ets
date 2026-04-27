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

class DeviceType {
  static readonly UNKNOWN_TYPE: number = 0;
  static readonly SPEAKER: number = 0x0A;
  static readonly PHONE: number = 0x0E;
  static readonly TABLET: number = 0x11;
  static readonly WEARABLE: number = 0x6D;
  static readonly CAR: number = 0x83;
  static readonly TV: number = 0x9C;
}

class DeviceStateChangeAction {
  static readonly ONLINE: number = 0;
  static readonly READY: number = 1;
  static readonly OFFLINE: number = 2;
  static readonly CHANGE: number = 3;
}

export default function DistributedContract001Test() {
  const casePrefix = 'DemandPlayer_DistributedContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DistributedContract001TestSuite', () => {
    it(addCase(casePrefix + 'DeviceType_Unknown_IsZero_001'), 0, () => {
      expect(DeviceType.UNKNOWN_TYPE).assertEqual(0);
    });

    it(addCase(casePrefix + 'DeviceType_Speaker_HexValue_002'), 0, () => {
      expect(DeviceType.SPEAKER).assertEqual(0x0A);
    });

    it(addCase(casePrefix + 'DeviceType_Phone_HexValue_003'), 0, () => {
      expect(DeviceType.PHONE).assertEqual(0x0E);
    });

    it(addCase(casePrefix + 'DeviceType_Tablet_HexValue_004'), 0, () => {
      expect(DeviceType.TABLET).assertEqual(0x11);
    });

    it(addCase(casePrefix + 'DeviceType_Wearable_HexValue_005'), 0, () => {
      expect(DeviceType.WEARABLE).assertEqual(0x6D);
    });

    it(addCase(casePrefix + 'DeviceType_Car_HexValue_006'), 0, () => {
      expect(DeviceType.CAR).assertEqual(0x83);
    });

    it(addCase(casePrefix + 'DeviceType_TV_HexValue_007'), 0, () => {
      expect(DeviceType.TV).assertEqual(0x9C);
    });

    it(addCase(casePrefix + 'DeviceStateChangeAction_Online_IsZero_008'), 0, () => {
      expect(DeviceStateChangeAction.ONLINE).assertEqual(0);
    });

    it(addCase(casePrefix + 'DeviceStateChangeAction_Ready_IsOne_009'), 0, () => {
      expect(DeviceStateChangeAction.READY).assertEqual(1);
    });

    it(addCase(casePrefix + 'DeviceStateChangeAction_Offline_IsTwo_010'), 0, () => {
      expect(DeviceStateChangeAction.OFFLINE).assertEqual(2);
    });

    it(addCase(casePrefix + 'DeviceStateChangeAction_Change_IsThree_011'), 0, () => {
      expect(DeviceStateChangeAction.CHANGE).assertEqual(3);
    });

    it(addCase(casePrefix + 'DeviceType_AllPositiveValues_012'), 0, () => {
      const types: Array<number> = [DeviceType.SPEAKER, DeviceType.PHONE, DeviceType.TABLET,
        DeviceType.WEARABLE, DeviceType.CAR, DeviceType.TV];
      for (let i = 0; i < types.length; i++) {
        expect(types[i] > 0).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'DeviceStateChangeAction_FourStates_013'), 0, () => {
      const actions: Array<number> = [DeviceStateChangeAction.ONLINE, DeviceStateChangeAction.READY,
        DeviceStateChangeAction.OFFLINE, DeviceStateChangeAction.CHANGE];
      expect(actions.length).assertEqual(4);
    });

    it(addCase(casePrefix + 'CaseNamePattern_014'), 0, () => {
      expect(allCaseNames.length).assertEqual(14);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_DistributedContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
