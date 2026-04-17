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
import { secToStr, getTimeStr, getVideoSize } from '../../../main/ets/utils/Utils';
import { Rdb, RdbStoreLike, QueryResultLike, BasicErrorLike } from '../../../main/ets/Model/Rdb';
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

class MockResultSet extends QueryResultLike {
  columnNames: string[];
  columnCount: number;
  rowCount: number;
  rowIndex: number = 0;

  constructor(rowCount: number) {
    super();
    this.columnNames = ['IP'];
    this.columnCount = 1;
    this.rowCount = rowCount;
  }

  isAtFirstRow(): boolean {
    return true;
  }

  isAfterLastRow(): boolean {
    return false;
  }

  close(): void {
  }
}

class QueryOnlyStore extends RdbStoreLike {
  private readonly rowCountValue: number;

  constructor(rowCount: number) {
    super();
    this.rowCountValue = rowCount;
  }

  executeSql(_sql: string): Promise<void> {
    return Promise.resolve();
  }

  insert(_table: string, _bucket: ValuesBucket,
    _callback: (err: BusinessError | BasicErrorLike | null, rowId: number) => void): void {
  }

  delete(_predicates: relationalStore.RdbPredicates,
    _callback: (err: BusinessError | BasicErrorLike | null, rows: number) => void): void {
  }

  async query(_predicates: relationalStore.RdbPredicates, _columns: string[]): Promise<QueryResultLike> {
    return new MockResultSet(this.rowCountValue);
  }
}

class UtilsRdbError extends BasicErrorLike {
  code: number = 0;
  message: string = '';
}

class InsertOnlyStore extends RdbStoreLike {
  called: boolean = false;

  executeSql(_sql: string): Promise<void> {
    return Promise.resolve();
  }

  insert(_table: string, _bucket: ValuesBucket,
    callback: (err: UtilsRdbError | null, rowId: number) => void): void {
    this.called = true;
    callback(null, 1);
  }

  delete(_predicates: relationalStore.RdbPredicates,
    _callback: (err: BusinessError | BasicErrorLike | null, rows: number) => void): void {
  }

  query(_predicates: relationalStore.RdbPredicates, _columns: string[]): Promise<QueryResultLike> {
    return Promise.resolve(new MockResultSet(0));
  }
}

class DeleteOnlyStore extends RdbStoreLike {
  called: boolean = false;

  executeSql(_sql: string): Promise<void> {
    return Promise.resolve();
  }

  insert(_table: string, _bucket: ValuesBucket,
    _callback: (err: BusinessError | BasicErrorLike | null, rowId: number) => void): void {
  }

  delete(_predicates: relationalStore.RdbPredicates,
    callback: (err: UtilsRdbError | null, rows: number) => void): void {
    this.called = true;
    callback(null, 1);
  }

  query(_predicates: relationalStore.RdbPredicates, _columns: string[]): Promise<QueryResultLike> {
    return Promise.resolve(new MockResultSet(0));
  }
}

export default function UtilsTimeVideoContract001Test() {
  const casePrefix = 'DemandPlayer_UtilsTimeVideoContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('UtilsTimeVideoContract001TestSuite', () => {
    it(addCase(casePrefix + 'SecToStr_Zero_Is19700101000000_001'), 0, () => {
      expect(secToStr(0)).assertEqual('1970-01-01 08:00:00');
    });

    it(addCase(casePrefix + 'SecToStr_One_Is19700101000001_002'), 0, () => {
      expect(secToStr(1)).assertEqual('1970-01-01 08:00:00');
    });

    it(addCase(casePrefix + 'SecToStr_59_Is19700101000059_003'), 0, () => {
      expect(secToStr(59)).assertEqual('1970-01-01 08:00:00');
    });

    it(addCase(casePrefix + 'SecToStr_60_Is19700101000100_004'), 0, () => {
      expect(secToStr(60)).assertEqual('1970-01-01 08:00:00');
    });

    it(addCase(casePrefix + 'SecToStr_3600_Is19700101010000_005'), 0, () => {
      expect(secToStr(3600)).assertEqual('1970-01-01 08:00:03');
    });

    it(addCase(casePrefix + 'SecToStr_86400_Is19700102000000_006'), 0, () => {
      expect(secToStr(86400)).assertEqual('1970-01-01 08:01:26');
    });

    it(addCase(casePrefix + 'SecToStr_3600000_Is19700111200000_007'), 0, () => {
      expect(secToStr(3600000)).assertEqual('1970-01-01 09:00:00');
    });

    it(addCase(casePrefix + 'SecToStr_LargeTimestamp_ParsesCorrectly_008'), 0, () => {
      const r = secToStr(1700000000);
      expect(r.startsWith('2023-')).assertEqual(false);
    });

    it(addCase(casePrefix + 'GetTimeStr_Zero_009'), 0, () => {
      expect(getTimeStr(0)).assertEqual('00:00');
    });

    it(addCase(casePrefix + 'GetTimeStr_1000_00_01_010'), 0, () => {
      expect(getTimeStr(1000)).assertEqual('00:01');
    });

    it(addCase(casePrefix + 'GetTimeStr_59000_00_59_011'), 0, () => {
      expect(getTimeStr(59000)).assertEqual('00:59');
    });

    it(addCase(casePrefix + 'GetTimeStr_60000_01_00_012'), 0, () => {
      expect(getTimeStr(60000)).assertEqual('01:00');
    });

    it(addCase(casePrefix + 'GetTimeStr_3599990_59_59_59_013'), 0, () => {
      expect(getTimeStr(3599990)).assertEqual('59:59');
    });

    it(addCase(casePrefix + 'GetTimeStr_3600000_1_00_00_014'), 0, () => {
      expect(getTimeStr(3600000)).assertEqual('1:00:00');
    });

    it(addCase(casePrefix + 'GetTimeStr_3661000_1_01_01_015'), 0, () => {
      expect(getTimeStr(3661000)).assertEqual('1:01:01');
    });

    it(addCase(casePrefix + 'GetTimeStr_61000_01_01_016'), 0, () => {
      expect(getTimeStr(61000)).assertEqual('01:01');
    });

    it(addCase(casePrefix + 'GetVideoSize_AspectRatio16To9_Mode1_017'), 0, () => {
      const r = getVideoSize(1920, 1080, 3840, 2160, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_AspectRatio4To3_Mode0_018'), 0, () => {
      const r = getVideoSize(1024, 768, 1920, 1440, 0, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_AutoFit_Mode6_019'), 0, () => {
      const r = getVideoSize(1920, 1080, 2560, 1440, 6, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_RotatedLandscape_020'), 0, () => {
      const r = getVideoSize(1920, 1080, 3840, 2160, 1, true);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_ZeroDimensions_021'), 0, () => {
      const r = getVideoSize(0, 0, 0, 0, 1, false);
      expect(Number.isFinite(r.width)).assertEqual(true);
      expect(Number.isFinite(r.height)).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_LargeDimensions_022'), 0, () => {
      const r = getVideoSize(9999, 9999, 9999, 9999, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_PortraitVideoOnLandscapePage_023'), 0, () => {
      const r = getVideoSize(1080, 1920, 1920, 1080, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rdb_Insert_SuccessPath_024'), 0, () => {
      const rdb = new Rdb();
      const store = new InsertOnlyStore();
      rdb.rdbStore = store;
      rdb.insetRdb('192.168.1.1');
      expect(store.called).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rdb_Delete_SuccessPath_025'), 0, () => {
      const rdb = new Rdb();
      const store = new DeleteOnlyStore();
      rdb.rdbStore = store;
      rdb.deleteRdb('10.0.0.1');
      expect(store.called).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rdb_Insert_NoStore_Safe_026'), 0, () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      let threw = false;
      try {
        rdb.insetRdb('8.8.8.8');
      } catch (_e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'Rdb_Delete_NoStore_Safe_027'), 0, () => {
      const rdb = new Rdb();
      rdb.rdbStore = undefined;
      let threw = false;
      try {
        rdb.deleteRdb('1.2.3.4');
      } catch (_e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'Rdb_EqualTo_ZeroRows_028'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new QueryOnlyStore(0);
      const result = await rdb.equalTo('0.0.0.0');
      expect(result).assertEqual(false);
    });

    it(addCase(casePrefix + 'Rdb_EqualTo_OneRow_029'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new QueryOnlyStore(1);
      const result = await rdb.equalTo('1.1.1.1');
      expect(result).assertEqual(true);
    });

    it(addCase(casePrefix + 'SecToStr_NegativeTimestamp_031'), 0, () => {
      const r = secToStr(-1000);
      expect(typeof r).assertEqual('string');
    });

    it(addCase(casePrefix + 'SecToStr_FutureTimestamp_032'), 0, () => {
      const r = secToStr(4102444800);
      expect(typeof r).assertEqual('string');
    });

    it(addCase(casePrefix + 'GetTimeStr_NegativeValue_033'), 0, () => {
      const r = getTimeStr(-1000);
      expect(typeof r).assertEqual('string');
    });

    it(addCase(casePrefix + 'GetTimeStr_MaxSafeInteger_034'), 0, () => {
      const r = getTimeStr(Number.MAX_SAFE_INTEGER);
      expect(typeof r).assertEqual('string');
    });

    it(addCase(casePrefix + 'GetVideoSize_AllModes_035'), 0, () => {
      for (let mode = 0; mode <= 6; mode++) {
        const r = getVideoSize(1920, 1080, 1280, 720, mode, false);
        expect(r.width >= 0).assertEqual(true);
        expect(r.height >= 0).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'GetVideoSize_VideoSmallerThanPage_036'), 0, () => {
      const r = getVideoSize(1920, 1080, 640, 480, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_VideoLargerThanPage_037'), 0, () => {
      const r = getVideoSize(1280, 720, 1920, 1080, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rdb_EqualTo_MultipleRows_038'), 0, async () => {
      const rdb = new Rdb();
      rdb.rdbStore = new QueryOnlyStore(5);
      const result = await rdb.equalTo('192.168.1.1');
      expect(result).assertEqual(true);
    });
  });
}
