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
import DeviceInfo, { Rdb } from '../../../main/ets/Model/Rdb';
import { SubWindow } from '../../../main/ets/Model/Window';

export default function RdbWindowContractTest() {
  const casePrefix = 'DemandPlayer_RdbWindowContract_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('RdbWindowContract_CoreShape', () => {
    it(addCase(casePrefix + 'DeviceInfo_DefaultValues_001'), 0, () => {
      const info = new DeviceInfo();
      expect(info.ID).assertEqual(0);
      expect(info.NAME).assertEqual('');
      expect(info.INFO).assertEqual('');
    });

    it(addCase(casePrefix + 'Rdb_DefaultFields_002'), 0, () => {
      const rdb = new Rdb();
      expect(rdb.deviceInfo !== undefined).assertEqual(true);
      expect(rdb.rdbStore === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rdb_StaticSingletonExists_003'), 0, () => {
      expect(Rdb.rdb !== undefined).assertEqual(true);
      expect(Rdb.rdb instanceof Rdb).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rdb_EqualTo_NoStoreReturnsFalse_004'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      const result = await rdb.equalTo('192.168.1.2');
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'Rdb_InsertDelete_NoStoreSafe_005'), 0, () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      rdb.insetRdb('10.0.0.1');
      rdb.deleteRdb('10.0.0.1');
      expect(rdb.rdbStore === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'SubWindow_StaticSingletonExists_006'), 0, () => {
      expect(SubWindow.subWindow !== undefined).assertEqual(true);
      expect(SubWindow.subWindow instanceof SubWindow).assertEqual(true);
    });

    it(addCase(casePrefix + 'SubWindow_InstanceCanCreate_007'), 0, () => {
      const subWindow = new SubWindow();
      expect(subWindow !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_008'), 0, () => {
      expect(allCaseNames.length).assertEqual(8);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_RdbWindowContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
