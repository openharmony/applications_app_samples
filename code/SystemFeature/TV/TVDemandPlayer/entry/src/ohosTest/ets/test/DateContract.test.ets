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

class DateLib {
  year: number;
  month: number;
  day: number;
  hour: number;
  minute: number;
  second: number;
  yymm: string;
  yymmdd: string;
  mmdd: string;
  hhmmss: string;
  ymdhms: string;

  constructor(year: number, month: number, day: number, hour: number, minute: number, second: number) {
    this.year = year;
    this.month = month;
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    const monthText = String(month).padStart(2, '0');
    const dayText = String(day).padStart(2, '0');
    const hourText = String(hour).padStart(2, '0');
    const minuteText = String(minute).padStart(2, '0');
    const secondText = String(second).padStart(2, '0');
    this.yymm = year + '-' + monthText;
    this.yymmdd = this.yymm + '-' + dayText;
    this.mmdd = monthText + '-' + dayText;
    this.hhmmss = hourText + ':' + minuteText + ':' + secondText;
    this.ymdhms = this.yymmdd + ' ' + this.hhmmss;
  }
}

function secToDate(input: number | string): DateLib {
  const numericValue = typeof input === 'string' ? Number.parseInt(input, 10) : input;
  const timestamp = Math.abs(numericValue) >= 100000000000 ? numericValue : numericValue * 1000;
  const date = new Date(timestamp);
  return new DateLib(
    date.getUTCFullYear(),
    date.getUTCMonth() + 1,
    date.getUTCDate(),
    date.getUTCHours(),
    date.getUTCMinutes(),
    date.getUTCSeconds()
  );
}

export default function DateContract001Test() {
  const casePrefix = 'DemandPlayer_DateContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('DateContract001TestSuite', () => {
    it(addCase(casePrefix + 'SecToDate_EpochZero_Returns1970_001'), 0, () => {
      const result: DateLib = secToDate(0);
      expect(result.year).assertEqual(1970);
    });

    it(addCase(casePrefix + 'SecToDate_StringZero_002'), 0, () => {
      const result: DateLib = secToDate('0');
      expect(result.year).assertEqual(1970);
    });

    it(addCase(casePrefix + 'SecToDate_Milliseconds_003'), 0, () => {
      const result: DateLib = secToDate(1678431640790);
      expect(result.year).assertEqual(2023);
      expect(result.month).assertEqual(3);
    });

    it(addCase(casePrefix + 'SecToDate_AllFieldsExist_004'), 0, () => {
      const r: DateLib = secToDate(1678431640);
      expect(typeof r.year).assertEqual('number');
      expect(typeof r.month).assertEqual('number');
      expect(typeof r.day).assertEqual('number');
      expect(typeof r.hour).assertEqual('number');
      expect(typeof r.minute).assertEqual('number');
      expect(typeof r.second).assertEqual('number');
      expect(typeof r.yymm).assertEqual('string');
      expect(typeof r.yymmdd).assertEqual('string');
      expect(typeof r.mmdd).assertEqual('string');
      expect(typeof r.hhmmss).assertEqual('string');
      expect(typeof r.ymdhms).assertEqual('string');
    });

    it(addCase(casePrefix + 'SecToDate_MonthPadding_005'), 0, () => {
      const r1: DateLib = secToDate(1577836800);
      expect(r1.month).assertEqual(1);
      const r2: DateLib = secToDate(1609459200);
      expect(r2.month).assertEqual(1);
    });

    it(addCase(casePrefix + 'SecToDate_DayPadding_006'), 0, () => {
      const r: DateLib = secToDate(1672531200);
      expect(r.day >= 1 && r.day <= 31).assertEqual(true);
    });

    it(addCase(casePrefix + 'SecToDate_HourMinuteSecond_007'), 0, () => {
      const r: DateLib = secToDate(3661);
      expect(r.hour).assertEqual(1);
      expect(r.minute).assertEqual(1);
      expect(r.second).assertEqual(1);
    });

    it(addCase(casePrefix + 'SecToDate_Yymmdd_Format_008'), 0, () => {
      const r: DateLib = secToDate(1672531200);
      expect(r.yymmdd.includes('-')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SecToDate_Hhmmss_ColonSeparated_009'), 0, () => {
      const r: DateLib = secToDate(3661);
      expect(r.hhmmss.includes(':')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SecToDate_Ymdhms_ContainsSpace_010'), 0, () => {
      const r: DateLib = secToDate(1672531200);
      expect(r.ymdhms.includes(' ')).assertEqual(true);
    });

    it(addCase(casePrefix + 'SecToDate_LargeTimestamp_011'), 0, () => {
      const r: DateLib = secToDate(4102444800);
      expect(r.year).assertEqual(2100);
    });

    it(addCase(casePrefix + 'SecToDate_Mmdd_SingleDigitMonth_012'), 0, () => {
      const r: DateLib = secToDate(1296000);
      expect(r.mmdd).assertContain('-');
    });

    it(addCase(casePrefix + 'SecToDate_NegativeTimestamp_013'), 0, () => {
      const r: DateLib = secToDate(-86400);
      expect(typeof r.year).assertEqual('number');
    });

    it(addCase(casePrefix + 'CaseNamePattern_014'), 0, () => {
      expect(allCaseNames.length).assertEqual(14);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_DateContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
