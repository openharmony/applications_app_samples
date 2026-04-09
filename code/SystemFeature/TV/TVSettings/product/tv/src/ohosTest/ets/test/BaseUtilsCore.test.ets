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
import bytesFormat from '../../../main/ets/common/BytesFormatManager';
import { DateUtil } from '../../../main/ets/common/DateUtil';
import { Ratio } from '../../../main/ets/common/ratio';
import { KeyCode } from '../../../main/ets/common/constants/KeyCode';
import { Duration } from '../../../main/ets/common/constants/Duration';

interface DateFormatCase {
  name: string;
  input: number | string | Date;
  pattern: string;
  expected: string;
}

interface TipDateCase {
  name: string;
  offsetMs: number;
  matcher: '刚刚' | '分钟前' | '小时前' | '月日' | '日期';
}

interface ByteFormatCase {
  name: string;
  value: number;
  expected: string;
}

interface MonthFlowCase {
  name: string;
  input: Date;
  nextYear: number;
  nextMonth: number;
  prevYear: number;
  prevMonth: number;
}

function pad2(n: number): string {
  return n.toString().padStart(2, '0');
}

function buildExpectedByPattern(date: Date, pattern: string): string {
  let result = pattern;
  result = result.replace('yyyy', date.getFullYear().toString());
  result = result.replace('MM', pad2(date.getMonth() + 1));
  result = result.replace('dd', pad2(date.getDate()));
  result = result.replace('HH', pad2(date.getHours()));
  result = result.replace('mm', pad2(date.getMinutes()));
  result = result.replace('ss', pad2(date.getSeconds()));
  return result;
}

export default function BaseUtilsCoreTest() {
  const casePrefix = 'Settings_BaseUtilsCore_';
  const allCaseNames: Array<string> = [];
  const pushCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('BaseUtilsCoreTestSuite', () => {
    it(pushCase(casePrefix + 'BytesFormat_Boundary_001'), 0, () => {
      const cases: Array<ByteFormatCase> = [
        { name: 'Zero', value: 0, expected: '0 B' },
        { name: 'SingleByte', value: 1, expected: '1 B' },
        { name: 'MaxBytes', value: 1023, expected: '1023 B' },
        { name: 'OneKB', value: 1024, expected: '1.00 KB' },
        { name: 'OneMB', value: 1024 * 1024, expected: '1.00 MB' },
        { name: 'OneGB', value: 1024 * 1024 * 1024, expected: '1.00 GB' }
      ];
      for (let i = 0; i < cases.length; i++) {
        const actual = bytesFormat(cases[i].value);
        expect(actual).assertEqual(cases[i].expected);
      }
    });

    it(pushCase(casePrefix + 'BytesFormat_Range_002'), 0, () => {
      const rangeCases: Array<ByteFormatCase> = [
        { name: 'HalfKB', value: 512, expected: '512 B' },
        { name: 'TwoKB', value: 2048, expected: '2.00 KB' },
        { name: 'TenKB', value: 10240, expected: '10.00 KB' },
        { name: 'TwoMB', value: 2 * 1024 * 1024, expected: '2.00 MB' },
        { name: 'ThreeGB', value: 3 * 1024 * 1024 * 1024, expected: '3.00 GB' }
      ];
      for (let i = 0; i < rangeCases.length; i++) {
        expect(bytesFormat(rangeCases[i].value)).assertEqual(rangeCases[i].expected);
      }
    });

    it(pushCase(casePrefix + 'DateUtil_GetFormatDate_003'), 0, () => {
      const nowTime = Date.now();
      const byNumber = DateUtil.getFormatDate(nowTime);
      expect(byNumber instanceof Date).assertEqual(true);
      const byEmpty = DateUtil.getFormatDate('');
      expect(byEmpty instanceof Date).assertEqual(true);
      const byUndefined = DateUtil.getFormatDate(undefined);
      expect(byUndefined instanceof Date).assertEqual(true);
      const byDate = DateUtil.getFormatDate(new Date(nowTime));
      expect(byDate instanceof Date).assertEqual(true);
    });

    it(pushCase(casePrefix + 'DateUtil_Format_StringPattern_004'), 0, () => {
      const fixture = new Date(2026, 2, 1, 9, 8, 7);
      const cases: Array<DateFormatCase> = [
        {
          name: 'DefaultPattern',
          input: fixture,
          pattern: 'yyyy-MM-dd HH:mm:ss',
          expected: buildExpectedByPattern(fixture, 'yyyy-MM-dd HH:mm:ss')
        },
        {
          name: 'DateOnly',
          input: fixture,
          pattern: 'yyyy/MM/dd',
          expected: buildExpectedByPattern(fixture, 'yyyy/MM/dd')
        },
        {
          name: 'TimeOnly',
          input: fixture,
          pattern: 'HH:mm:ss',
          expected: buildExpectedByPattern(fixture, 'HH:mm:ss')
        },
        {
          name: 'CnDate',
          input: fixture,
          pattern: 'yyyy年MM月dd日',
          expected: buildExpectedByPattern(fixture, 'yyyy年MM月dd日')
        }
      ];
      for (let i = 0; i < cases.length; i++) {
        const actual = DateUtil.getFormatDateStr(cases[i].input, cases[i].pattern);
        expect(actual).assertEqual(cases[i].expected);
      }
    });

    it(pushCase(casePrefix + 'DateUtil_Format_DefaultPattern_005'), 0, () => {
      const fixture = new Date(2026, 4, 6, 12, 1, 2);
      const actual = DateUtil.getFormatDateStr(fixture);
      const expected = buildExpectedByPattern(fixture, 'yyyy-MM-dd HH:mm:ss');
      expect(actual).assertEqual(expected);
    });

    it(pushCase(casePrefix + 'DateUtil_TipDate_006'), 0, () => {
      const now = Date.now();
      const cases: Array<TipDateCase> = [
        { name: 'JustNow', offsetMs: 30 * 1000, matcher: '刚刚' },
        { name: 'MinutesAgo', offsetMs: 5 * 60 * 1000, matcher: '分钟前' },
        { name: 'HoursAgo', offsetMs: 2 * 60 * 60 * 1000, matcher: '小时前' },
        { name: 'MonthDay', offsetMs: 5 * 24 * 60 * 60 * 1000, matcher: '月日' },
        { name: 'YearDate', offsetMs: 500 * 24 * 60 * 60 * 1000, matcher: '日期' }
      ];
      for (let i = 0; i < cases.length; i++) {
        const value = DateUtil.getTipDateStr(now - cases[i].offsetMs);
        if (cases[i].matcher === '刚刚') {
          expect(value).assertEqual('刚刚');
        } else if (cases[i].matcher === '分钟前') {
          expect(value.includes('分钟前')).assertEqual(true);
        } else if (cases[i].matcher === '小时前') {
          expect(value.includes('小时前')).assertEqual(true);
        } else if (cases[i].matcher === '月日') {
          expect(value.includes('月')).assertEqual(true);
          expect(value.includes('日')).assertEqual(true);
        } else {
          expect(/^\d{4}-\d{2}-\d{2}$/.test(value)).assertEqual(true);
        }
      }
    });

    it(pushCase(casePrefix + 'DateUtil_DateDiff_007'), 0, () => {
      const start = new Date(2026, 0, 1, 8, 0, 0);
      const end = new Date(2026, 0, 10, 8, 0, 0);
      const backward = DateUtil.getDateDiff(end, start);
      const forward = DateUtil.getDateDiff(start, end);
      expect(forward).assertEqual(9);
      expect(backward).assertEqual(-9);
    });

    it(pushCase(casePrefix + 'DateUtil_MonthFlow_008'), 0, () => {
      const cases: Array<MonthFlowCase> = [
        {
          name: 'YearBoundary',
          input: new Date(2026, 11, 15),
          nextYear: 2027,
          nextMonth: 0,
          prevYear: 2026,
          prevMonth: 10
        },
        {
          name: 'NormalMonth',
          input: new Date(2026, 5, 9),
          nextYear: 2026,
          nextMonth: 6,
          prevYear: 2026,
          prevMonth: 4
        },
        {
          name: 'January',
          input: new Date(2026, 0, 9),
          nextYear: 2026,
          nextMonth: 1,
          prevYear: 2025,
          prevMonth: 11
        }
      ];
      for (let i = 0; i < cases.length; i++) {
        const next = DateUtil.getNextMonth(cases[i].input);
        const prev = DateUtil.getPreviousMonth(cases[i].input);
        expect(next.getFullYear()).assertEqual(cases[i].nextYear);
        expect(next.getMonth()).assertEqual(cases[i].nextMonth);
        expect(next.getDate()).assertEqual(1);
        expect(prev.getFullYear()).assertEqual(cases[i].prevYear);
        expect(prev.getMonth()).assertEqual(cases[i].prevMonth);
        expect(prev.getDate()).assertEqual(1);
      }
    });

    it(pushCase(casePrefix + 'DateUtil_DateCount_009'), 0, () => {
      expect(DateUtil.getDateCount(new Date(2024, 1, 1))).assertEqual(29);
      expect(DateUtil.getDateCount(new Date(2026, 1, 1))).assertEqual(28);
      expect(DateUtil.getDateCount(new Date(2026, 0, 1))).assertEqual(31);
      expect(DateUtil.getDateCount(new Date(2026, 3, 1))).assertEqual(30);
    });

    it(pushCase(casePrefix + 'DateUtil_SameDay_010'), 0, () => {
      const a = new Date(2026, 2, 7, 10, 0, 0);
      const b = new Date(2026, 2, 7, 21, 40, 0);
      const c = new Date(2026, 2, 8, 10, 0, 0);
      expect(DateUtil.isTheSameDay(a, b)).assertEqual(true);
      expect(DateUtil.isTheSameDay(a, c)).assertEqual(false);
    });

    it(pushCase(casePrefix + 'DateUtil_PadNumber_011'), 0, () => {
      expect(DateUtil.padNumber(5, 2)).assertEqual('05');
      expect(DateUtil.padNumber(99, 2)).assertEqual('99');
      expect(DateUtil.padNumber(99, 4)).assertEqual('0099');
      expect(DateUtil.padNumber(1234, 2)).assertEqual('1234');
    });

    it(pushCase(casePrefix + 'DateUtil_GetToday_012'), 0, () => {
      const today = DateUtil.getToday();
      const todayTime = DateUtil.getTodayTime();
      const now = Date.now();
      expect(today instanceof Date).assertEqual(true);
      expect(Math.abs(todayTime - now) < 5000).assertEqual(true);
    });

    it(pushCase(casePrefix + 'Ratio_ResourceName_013'), 0, () => {
      const names: Array<string> = ['ic_wifi', 'ic_bluetooth_device', 'default_background', 'entry_icon'];
      for (let i = 0; i < names.length; i++) {
        const resName = Ratio.resName(names[i]);
        expect(resName.startsWith('app.media.')).assertEqual(true);
        expect(resName).assertEqual(`app.media.${names[i]}`);
      }
    });

    it(pushCase(casePrefix + 'KeyCode_Baseline_014'), 0, () => {
      expect(KeyCode.KEY_BACK).assertEqual(2);
      expect(KeyCode.KEY_DPAD_UP).assertEqual(2012);
      expect(KeyCode.KEY_DPAD_DOWN).assertEqual(2013);
      expect(KeyCode.KEY_DPAD_LEFT).assertEqual(2014);
      expect(KeyCode.KEY_DPAD_RIGHT).assertEqual(2015);
      expect(KeyCode.KEY_ENTER).assertEqual(2054);
    });

    it(pushCase(casePrefix + 'KeyCode_NumberContinuity_015'), 0, () => {
      const numbers: Array<number> = [
        KeyCode.KEY_0,
        KeyCode.KEY_1,
        KeyCode.KEY_2,
        KeyCode.KEY_3,
        KeyCode.KEY_4,
        KeyCode.KEY_5,
        KeyCode.KEY_6,
        KeyCode.KEY_7,
        KeyCode.KEY_8,
        KeyCode.KEY_9
      ];
      for (let i = 1; i < numbers.length; i++) {
        expect(numbers[i] - numbers[i - 1]).assertEqual(1);
      }
      expect(numbers[0]).assertEqual(2000);
      expect(numbers[9]).assertEqual(2009);
    });

    it(pushCase(casePrefix + 'Duration_Defaults_016'), 0, () => {
      expect(Duration.Image_duration).assertEqual(160);
      expect(Duration.pageTransition_duration).assertEqual(350);
      expect(Duration.pageTransition_duration > Duration.Image_duration).assertEqual(true);
    });

    it(pushCase(casePrefix + 'DateUtil_Format_MultipleInputs_017'), 0, () => {
      const source = new Date(2026, 7, 26, 16, 31, 42);
      const timeValue = source.getTime();
      const stringValue = '2026-08-26 16:31:42';
      const numberFormatted = DateUtil.getFormatDateStr(timeValue, 'yyyy-MM-dd HH:mm:ss');
      const dateFormatted = DateUtil.getFormatDateStr(source, 'yyyy-MM-dd HH:mm:ss');
      const stringFormatted = DateUtil.getFormatDateStr(stringValue, 'yyyy-MM-dd HH:mm:ss');
      expect(numberFormatted).assertEqual(dateFormatted);
      expect(stringFormatted.includes('2026-08-26')).assertEqual(true);
    });

    it(pushCase(casePrefix + 'DateUtil_Contract_018'), 0, () => {
      const currentMonth = DateUtil.getCurrentMonth();
      expect(currentMonth.getDate()).assertEqual(1);
      const monthCount = DateUtil.getDateCount(currentMonth);
      expect(monthCount >= 28 && monthCount <= 31).assertEqual(true);
      const currentMonthText = DateUtil.getFormatDateStr(currentMonth, 'yyyy-MM-dd');
      expect(/^\d{4}-\d{2}-\d{2}$/.test(currentMonthText)).assertEqual(true);
    });

    it(pushCase(casePrefix + 'CaseName_Unique_019'), 0, () => {
      const seen: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(allCaseNames[i].startsWith(casePrefix)).assertEqual(true);
        expect(seen.has(allCaseNames[i])).assertEqual(false);
        seen.add(allCaseNames[i]);
      }
      expect(seen.size).assertEqual(allCaseNames.length);
    });
  });
}

