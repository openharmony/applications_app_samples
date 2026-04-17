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
import { timeConvert } from '../../../main/ets/utils/TimeUtils';
import { getLanguageName } from '../../../main/ets/utils/LanguageCodeUtil';
import { getTimeStr, getVideoSize, isVideoFile, MediaType, objType, secToStr } from '../../../main/ets/utils/Utils';

interface TimeConvertCase {
  value: number;
  expected: string;
}

interface VideoSizeCase {
  pageW: number;
  pageH: number;
  videoW: number;
  videoH: number;
  type: string | number;
  isRotated?: boolean;
  expectedWidth: number;
  expectedHeight: number;
}

class ObjectIdHolder {
  id: string;

  constructor(id: string) {
    this.id = id;
  }
}

export default function UtilsCoreTest() {
  const casePrefix = 'DemandPlayer_UtilsCore_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('UtilsCoreTestSuite', () => {
    it(addCase(casePrefix + 'TimeConvert_Boundary_001'), 0, () => {
      const cases: Array<TimeConvertCase> = [
        { value: 0, expected: '0:00' },
        { value: 9 * 1000, expected: '0:09' },
        { value: 59 * 1000, expected: '0:59' },
        { value: 60 * 1000, expected: '1:00' },
        { value: 61 * 1000, expected: '1:01' },
        { value: 125 * 1000, expected: '2:05' }
      ];
      for (let i = 0; i < cases.length; i++) {
        expect(timeConvert(cases[i].value)).assertEqual(cases[i].expected);
      }
    });

    it(addCase(casePrefix + 'LanguageCode_KnownAndFallback_002'), 0, () => {
      expect(getLanguageName('chi')).assertEqual('汉语');
      expect(getLanguageName('en-us')).assertEqual('英语(美国)');
      expect(getLanguageName('zh-Hant')).assertEqual('汉语(繁体)');
      expect(getLanguageName('und')).assertEqual('未知');
      expect(getLanguageName('custom-lang')).assertEqual('custom-lang');
    });

    it(addCase(casePrefix + 'ObjType_CommonValues_003'), 0, () => {
      expect(objType(null)).assertEqual('null');
      expect(objType(undefined)).assertEqual('undefined');
      expect(objType([1, 2, 3])).assertEqual('array');
      expect(objType(new Set<number>())).assertEqual('set');
      expect(objType(new Map<string, number>())).assertEqual('map');
      expect(objType(new Date())).assertEqual('date');
      expect(objType(true)).assertEqual('boolean');
      expect(objType(8)).assertEqual('number');
      expect(objType('video')).assertEqual('string');
      expect(objType(() => 1)).assertEqual('function');
      expect(objType(new ObjectIdHolder('1'))).assertEqual('object');
    });

    it(addCase(casePrefix + 'GetTimeStr_Format_004'), 0, () => {
      expect(getTimeStr(0)).assertEqual('00:00');
      expect(getTimeStr(61 * 1000)).assertEqual('01:01');
      expect(getTimeStr((60 * 60 + 5 * 60 + 9) * 1000)).assertEqual('1:05:09');
    });

    it(addCase(casePrefix + 'GetVideoSize_CommonModes_005'), 0, () => {
      const cases: Array<VideoSizeCase> = [
        {
          pageW: 1920,
          pageH: 1080,
          videoW: 1280,
          videoH: 720,
          type: 0,
          expectedWidth: 1440,
          expectedHeight: 1080
        },
        {
          pageW: 1280,
          pageH: 720,
          videoW: 1920,
          videoH: 1080,
          type: 1,
          expectedWidth: 1280,
          expectedHeight: 720
        },
        {
          pageW: 1280,
          pageH: 720,
          videoW: 640,
          videoH: 480,
          type: 6,
          expectedWidth: 960,
          expectedHeight: 720
        },
        {
          pageW: 1920,
          pageH: 1080,
          videoW: 1280,
          videoH: 720,
          type: 1,
          isRotated: true,
          expectedWidth: 1080,
          expectedHeight: 608
        }
      ];
      for (let i = 0; i < cases.length; i++) {
        const actual = getVideoSize(
          cases[i].pageW,
          cases[i].pageH,
          cases[i].videoW,
          cases[i].videoH,
          cases[i].type,
          cases[i].isRotated === true
        );
        expect(actual.width).assertEqual(cases[i].expectedWidth);
        expect(actual.height).assertEqual(cases[i].expectedHeight);
      }
    });

    it(addCase(casePrefix + 'SecToStr_Format_006'), 0, () => {
      expect(secToStr(new Date(2026, 0, 2, 3, 4, 5).getTime())).assertEqual('2026-01-02 03:04:05');
      expect(secToStr(new Date(2026, 10, 12, 13, 14, 15).getTime())).assertEqual('2026-11-12 13:14:15');
    });

    it(addCase(casePrefix + 'IsVideoFile_ExtensionRule_007'), 0, () => {
      expect(isVideoFile('movie.mp4')).assertEqual(true);
      expect(isVideoFile('demo.MKV')).assertEqual(true);
      expect(isVideoFile('poster.jpg')).assertEqual(false);
      expect(isVideoFile('README')).assertEqual(false);
    });

    it(addCase(casePrefix + 'MediaType_EnumSequence_008'), 0, () => {
      expect(MediaType.AUDIO).assertEqual(1);
      expect(MediaType.VIDEO).assertEqual(2);
      expect(MediaType.IMAGE).assertEqual(3);
      expect(MediaType.TXT).assertEqual(4);
      expect(MediaType.DIR).assertEqual(5);
      expect(MediaType.OTHER).assertEqual(6);
    });

    it(addCase(casePrefix + 'TimeConvert_Minutes_011'), 0, () => {
      expect(timeConvert(5 * 60 * 1000)).assertEqual('5:00');
      expect(timeConvert(10 * 60 * 1000)).assertEqual('10:00');
      expect(timeConvert(59 * 60 * 1000)).assertEqual('59:00');
    });

    it(addCase(casePrefix + 'TimeConvert_Seconds_012'), 0, () => {
      expect(timeConvert(1000)).assertEqual('0:01');
      expect(timeConvert(30000)).assertEqual('0:30');
      expect(timeConvert(45000)).assertEqual('0:45');
    });

    it(addCase(casePrefix + 'GetLanguageName_ChineseVariants_014'), 0, () => {
      expect(getLanguageName('zh')).assertEqual('汉语');
      expect(getLanguageName('zh-CN')).assertEqual('汉语(简体)');
      expect(getLanguageName('zh-TW')).assertEqual('汉语(繁体)');
      expect(getLanguageName('zh-HK')).assertEqual('汉语(香港)');
    });

    it(addCase(casePrefix + 'GetLanguageName_EnglishVariants_015'), 0, () => {
      expect(getLanguageName('en')).assertEqual('英语');
      expect(getLanguageName('en-GB')).assertEqual('英语(英国)');
      expect(getLanguageName('en-AU')).assertEqual('英语(澳大利亚)');
    });

    it(addCase(casePrefix + 'GetLanguageName_JapaneseKorean_016'), 0, () => {
      expect(getLanguageName('jpn')).assertEqual('日语');
      expect(getLanguageName('kor')).assertEqual('韩语');
    });

    it(addCase(casePrefix + 'GetLanguageName_EmptyAndUnknown_017'), 0, () => {
      expect(getLanguageName('')).assertEqual('未知');
      expect(getLanguageName('xyz')).assertEqual('xyz');
      expect(getLanguageName('zzz')).assertEqual('zzz');
    });

    it(addCase(casePrefix + 'ObjType_BigInt_ReturnsNumber_018'), 0, () => {
      const value = new ObjectIdHolder('123');
      expect(objType(value)).assertEqual('object');
      expect(objType(value)).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_Promise_ReturnsObject_019'), 0, () => {
      expect(objType(new Promise<void>(() => {
      }))).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_WeakMap_ReturnsObject_020'), 0, () => {
      expect(objType(new WeakMap())).assertEqual('object');
      expect(objType(new WeakSet())).assertEqual('object');
    });

    it(addCase(casePrefix + 'GetTimeStr_Zero_021'), 0, () => {
      expect(getTimeStr(0)).assertEqual('00:00');
    });

    it(addCase(casePrefix + 'GetTimeStr_MaxValues_022'), 0, () => {
      expect(getTimeStr(59 * 1000)).assertEqual('00:59');
      expect(getTimeStr(59 * 60 * 1000)).assertEqual('59:00');
    });

    it(addCase(casePrefix + 'SecToStr_DateConstruction_024'), 0, () => {
      const d = new Date(2026, 3, 15, 8, 20, 35);
      expect(secToStr(d.getTime())).assertEqual('2026-04-15 08:20:35');
    });

    it(addCase(casePrefix + 'SecToStr_LeapYear_025'), 0, () => {
      const d = new Date(2024, 1, 29, 23, 59, 59);
      expect(secToStr(d.getTime())).assertEqual('2024-02-29 23:59:59');
    });

    it(addCase(casePrefix + 'IsVideoFile_AllTypes_026'), 0, () => {
      expect(isVideoFile('test.mp4')).assertEqual(true);
      expect(isVideoFile('test.mpeg-ts')).assertEqual(false);
      expect(isVideoFile('test.webm')).assertEqual(true);
      expect(isVideoFile('test.mkv')).assertEqual(true);
      expect(isVideoFile('test.avi')).assertEqual(true);
      expect(isVideoFile('test.mov')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_NegativeCases_027'), 0, () => {
      expect(isVideoFile('audio.mp3')).assertEqual(false);
      expect(isVideoFile('image.png')).assertEqual(false);
      expect(isVideoFile('document.pdf')).assertEqual(false);
      expect(isVideoFile('archive.zip')).assertEqual(false);
    });

    it(addCase(casePrefix + 'IsVideoFile_UpperCaseExtension_028'), 0, () => {
      expect(isVideoFile('video.MP4')).assertEqual(true);
      expect(isVideoFile('movie.MKV')).assertEqual(true);
      expect(isVideoFile('clip.WEBM')).assertEqual(true);
    });

    it(addCase(casePrefix + 'MediaType_AllValues_029'), 0, () => {
      expect(MediaType.AUDIO).assertEqual(1);
      expect(MediaType.VIDEO).assertEqual(2);
      expect(MediaType.IMAGE).assertEqual(3);
      expect(MediaType.TXT).assertEqual(4);
      expect(MediaType.DIR).assertEqual(5);
      expect(MediaType.OTHER).assertEqual(6);
    });

    it(addCase(casePrefix + 'GetVideoSize_Type2_030'), 0, () => {
      const r = getVideoSize(1920, 1080, 1280, 720, 2, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_Type3_031'), 0, () => {
      const r = getVideoSize(1920, 1080, 1280, 720, 3, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_Type4_032'), 0, () => {
      const r = getVideoSize(1920, 1080, 1280, 720, 4, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_Type5_033'), 0, () => {
      const r = getVideoSize(1920, 1080, 1280, 720, 5, false);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_RotatedLandscape_034'), 0, () => {
      const r = getVideoSize(1080, 1920, 1920, 1080, 1, true);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_RotatedPortrait_035'), 0, () => {
      const r = getVideoSize(1920, 1080, 1080, 1920, 1, true);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetVideoSize_SameDimensions_036'), 0, () => {
      const r = getVideoSize(1920, 1080, 1920, 1080, 1, false);
      expect(r.width).assertEqual(1920);
      expect(r.height).assertEqual(1080);
    });
  });
}
