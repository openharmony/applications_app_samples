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
import { isVideoFile, secToStr, objType, getTimeStr, getVideoSize } from '../../../main/ets/utils/Utils';

type NamedObjectValue = NamedObjectHolder | Array<number> | Date | Map<string, string> | Set<string>;

class NamedObjectHolder {
  readonly label: string;
  readonly value: number;

  constructor(label: string, value: number) {
    this.label = label;
    this.value = value;
  }
}

export default function WorkerDataFlowContract001Test() {
  const casePrefix = 'DemandPlayer_WorkerDataFlowContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('WorkerDataFlowContract001TestSuite', () => {
    it(addCase(casePrefix + 'IsVideoFile_Mp4Extension_True_001'), 0, () => {
      expect(isVideoFile('movie.mp4')).assertEqual(true);
      expect(isVideoFile('video.MP4')).assertEqual(true);
      expect(isVideoFile('clip.m4v')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_NonVideoExtensions_False_002'), 0, () => {
      expect(isVideoFile('image.jpg')).assertEqual(false);
      expect(isVideoFile('audio.mp3')).assertEqual(false);
      expect(isVideoFile('document.pdf')).assertEqual(false);
      expect(isVideoFile('text.txt')).assertEqual(false);
    });

    it(addCase(casePrefix + 'IsVideoFile_CaseInsensitive_004'), 0, () => {
      expect(isVideoFile('VIDEO.AVI')).assertEqual(true);
      expect(isVideoFile('Movie.MKV')).assertEqual(true);
      expect(isVideoFile('Clip.MOV')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_NoExtension_False_005'), 0, () => {
      expect(isVideoFile('noextension')).assertEqual(false);
      expect(isVideoFile('')).assertEqual(false);
    });

    it(addCase(casePrefix + 'SecToStr_BasicConversion_006'), 0, () => {
      expect(secToStr(0)).assertEqual('1970-01-01 08:00:00');
      expect(secToStr(1)).assertEqual('1970-01-01 08:00:00');
      expect(secToStr(59)).assertEqual('1970-01-01 08:00:00');
    });

    it(addCase(casePrefix + 'SecToStr_MinuteBoundary_007'), 0, () => {
      expect(secToStr(60)).assertEqual('1970-01-01 08:00:00');
      expect(secToStr(3600)).assertEqual('1970-01-01 08:00:03');
    });

    it(addCase(casePrefix + 'SecToStr_DayBoundary_008'), 0, () => {
      expect(secToStr(86400)).assertEqual('1970-01-01 08:01:26');
    });

    it(addCase(casePrefix + 'SecToStr_SingleDigitPadding_009'), 0, () => {
      const result = secToStr(3723);
      expect(result).assertEqual('1970-01-01 08:00:03');
    });

    it(addCase(casePrefix + 'SecToStr_LargeTimestamp_010'), 0, () => {
      const largeSec = 100000000;
      const result = secToStr(largeSec);
      expect(result.startsWith('1970-01-01')).assertEqual(false);
    });

    it(addCase(casePrefix + 'GetTimeStr_ZeroMilliseconds_011'), 0, () => {
      expect(getTimeStr(0)).assertEqual('00:00');
    });

    it(addCase(casePrefix + 'GetTimeStr_SecondsOnly_012'), 0, () => {
      expect(getTimeStr(1000)).assertEqual('00:01');
      expect(getTimeStr(59000)).assertEqual('00:59');
    });

    it(addCase(casePrefix + 'GetTimeStr_OneMinute_013'), 0, () => {
      expect(getTimeStr(60000)).assertEqual('01:00');
    });

    it(addCase(casePrefix + 'GetTimeStr_HoursFormat_014'), 0, () => {
      expect(getTimeStr(3600000)).assertEqual('1:00:00');
      expect(getTimeStr(3661000)).assertEqual('1:01:01');
    });

    it(addCase(casePrefix + 'GetTimeStr_SecondsPadding_015'), 0, () => {
      expect(getTimeStr(61000)).assertEqual('01:01');
    });

    it(addCase(casePrefix + 'ObjType_NullAndUndefined_016'), 0, () => {
      expect(objType(null)).assertEqual('null');
      expect(objType(undefined)).assertEqual('undefined');
    });

    it(addCase(casePrefix + 'ObjType_Primitives_017'), 0, () => {
      expect(objType(42)).assertEqual('number');
      expect(objType('hello')).assertEqual('string');
      expect(objType(true)).assertEqual('boolean');
    });

    it(addCase(casePrefix + 'ObjType_Collections_018'), 0, () => {
      expect(objType([])).assertEqual('array');
      expect(objType(new Set<string>())).assertEqual('set');
      expect(objType(new Map<string, string>())).assertEqual('map');
      expect(objType(new Date())).assertEqual('date');
    });

    it(addCase(casePrefix + 'ObjType_Object_019'), 0, () => {
      expect(objType(new NamedObjectHolder('', 0) as NamedObjectValue)).assertEqual('object');
      expect(objType(new NamedObjectHolder('a', 1) as NamedObjectValue)).assertEqual('object');
    });

    it(addCase(casePrefix + 'GetVideoSize_16To9_FitVertical_020'), 0, () => {
      const r = getVideoSize(1920, 1080, 3840, 2160, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_4To3_FitVertical_021'), 0, () => {
      const r = getVideoSize(1024, 768, 1920, 1440, 0, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_AutoFit_022'), 0, () => {
      const r = getVideoSize(1920, 1080, 2560, 1440, 6, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_RotatedFlag_023'), 0, () => {
      const r1 = getVideoSize(1920, 1080, 3840, 2160, 1, true);
      const r2 = getVideoSize(1920, 1080, 3840, 2160, 1, false);
      expect(r1.width > 0).assertEqual(true);
      expect(r1.height > 0).assertEqual(true);
      expect(r2.width > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_ZeroDimensions_024'), 0, () => {
      const r = getVideoSize(0, 0, 0, 0, 1, false);
      expect(Number.isFinite(r.width)).assertEqual(true);
      expect(Number.isFinite(r.height)).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_LargeDimensions_025'), 0, () => {
      const r = getVideoSize(9999, 9999, 9999, 9999, 1, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_026'), 0, () => {
      expect(allCaseNames.length).assertEqual(25);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_WorkerDataFlowContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });
  });
}
