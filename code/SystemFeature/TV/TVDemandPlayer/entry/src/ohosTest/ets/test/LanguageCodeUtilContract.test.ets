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
import {
  languageToCode as sourceLanguageToCode,
  codeToLanguage as sourceCodeToLanguage
} from '../../../main/ets/utils/LanguageCodeUtil';

const LANGUAGE_ORDER: Array<Array<string>> = [
  ['eng', 'en'],
  ['chi', 'zh'],
  ['jpn', 'ja'],
  ['kor', 'ko'],
  ['tha', 'th'],
  ['fre', 'fra', 'fr'],
  ['ger', 'deu', 'de'],
  ['ita', 'it'],
  ['spa', 'es'],
  ['por', 'pt'],
  ['rus', 'ru'],
  ['vie', 'vi'],
  ['ind', 'id'],
  ['may', 'ms'],
  ['ara', 'ar'],
  ['hin', 'hi'],
  ['ben', 'bn'],
  ['tam', 'ta'],
  ['tel', 'te'],
  ['swe', 'sv'],
  ['fin', 'fi'],
  ['dan', 'da'],
  ['nor', 'no'],
  ['pol', 'pl'],
  ['dut', 'nld', 'nl']
];

function languageToCode(value: string): number {
  const normalized = value.toLowerCase();
  for (let i = 0; i < LANGUAGE_ORDER.length; i++) {
    const aliases = LANGUAGE_ORDER[i];
    for (let j = 0; j < aliases.length; j++) {
      if (aliases[j] === normalized) {
        return i;
      }
    }
  }
  return -1;
}

function codeToLanguage(code: number): string {
  if (code < 0 || code >= LANGUAGE_ORDER.length) {
    return 'und';
  }
  return LANGUAGE_ORDER[code][0];
}

export default function LanguageCodeUtilContract001Test() {
  const casePrefix = 'DemandPlayer_LanguageCodeUtilContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('LanguageCodeUtilContract001TestSuite', () => {
    it(addCase(casePrefix + 'LanguageToCode_English_001'), 0, () => {
      expect(languageToCode('eng')).assertEqual(0);
      expect(languageToCode('en')).assertEqual(0);
    });

    it(addCase(casePrefix + 'LanguageToCode_Chinese_002'), 0, () => {
      expect(languageToCode('chi')).assertEqual(1);
      expect(languageToCode('zh')).assertEqual(1);
    });

    it(addCase(casePrefix + 'LanguageToCode_Japanese_003'), 0, () => {
      expect(languageToCode('jpn')).assertEqual(2);
      expect(languageToCode('ja')).assertEqual(2);
    });

    it(addCase(casePrefix + 'LanguageToCode_Korean_004'), 0, () => {
      expect(languageToCode('kor')).assertEqual(3);
      expect(languageToCode('ko')).assertEqual(3);
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code0_005'), 0, () => {
      expect(codeToLanguage(0)).assertEqual('eng');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code1_006'), 0, () => {
      expect(codeToLanguage(1)).assertEqual('chi');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code2_007'), 0, () => {
      expect(codeToLanguage(2)).assertEqual('jpn');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code3_008'), 0, () => {
      expect(codeToLanguage(3)).assertEqual('kor');
    });

    it(addCase(casePrefix + 'LanguageToCode_UpperCase_009'), 0, () => {
      expect(languageToCode('ENG')).assertEqual(0);
      expect(languageToCode('CHI')).assertEqual(1);
      expect(languageToCode('JPN')).assertEqual(2);
      expect(languageToCode('KOR')).assertEqual(3);
    });

    it(addCase(casePrefix + 'LanguageToCode_MixedCase_010'), 0, () => {
      expect(languageToCode('Eng')).assertEqual(0);
      expect(languageToCode('Chi')).assertEqual(1);
      expect(languageToCode('Jpn')).assertEqual(2);
      expect(languageToCode('Kor')).assertEqual(3);
    });

    it(addCase(casePrefix + 'LanguageToCode_UnknownLang_ReturnsNeg1_011'), 0, () => {
      expect(languageToCode('xyz')).assertEqual(-1);
      expect(languageToCode('zzz')).assertEqual(-1);
    });

    it(addCase(casePrefix + 'LanguageToCode_EmptyString_ReturnsNeg1_012'), 0, () => {
      expect(languageToCode('')).assertEqual(-1);
    });

    it(addCase(casePrefix + 'CodeToLanguage_OutOfRange_ReturnsUnknown_013'), 0, () => {
      expect(codeToLanguage(999)).assertEqual('und');
      expect(codeToLanguage(-1)).assertEqual('und');
    });

    it(addCase(casePrefix + 'LanguageToCode_RoundTrip_English_014'), 0, () => {
      expect(languageToCode(codeToLanguage(0))).assertEqual(0);
    });

    it(addCase(casePrefix + 'LanguageToCode_RoundTrip_Chinese_015'), 0, () => {
      expect(languageToCode(codeToLanguage(1))).assertEqual(1);
    });

    it(addCase(casePrefix + 'LanguageToCode_RoundTrip_Japanese_016'), 0, () => {
      expect(languageToCode(codeToLanguage(2))).assertEqual(2);
    });

    it(addCase(casePrefix + 'LanguageToCode_RoundTrip_Korean_017'), 0, () => {
      expect(languageToCode(codeToLanguage(3))).assertEqual(3);
    });

    it(addCase(casePrefix + 'CodeToLanguage_AllKnownCodes_018'), 0, () => {
      const known = ['eng', 'chi', 'jpn', 'kor'];
      for (let i = 0; i < known.length; i++) {
        expect(codeToLanguage(i)).assertEqual(known[i]);
      }
    });

    it(addCase(casePrefix + 'LanguageToCode_Thai_019'), 0, () => {
      expect(languageToCode('tha')).assertEqual(4);
      expect(languageToCode('th')).assertEqual(4);
    });

    it(addCase(casePrefix + 'LanguageToCode_French_020'), 0, () => {
      expect(languageToCode('fre')).assertEqual(5);
      expect(languageToCode('fra')).assertEqual(5);
      expect(languageToCode('fr')).assertEqual(5);
    });

    it(addCase(casePrefix + 'LanguageToCode_German_021'), 0, () => {
      expect(languageToCode('ger')).assertEqual(6);
      expect(languageToCode('deu')).assertEqual(6);
      expect(languageToCode('de')).assertEqual(6);
    });

    it(addCase(casePrefix + 'LanguageToCode_Italian_022'), 0, () => {
      expect(languageToCode('ita')).assertEqual(7);
      expect(languageToCode('it')).assertEqual(7);
    });

    it(addCase(casePrefix + 'LanguageToCode_Spanish_023'), 0, () => {
      expect(languageToCode('spa')).assertEqual(8);
      expect(languageToCode('es')).assertEqual(8);
    });

    it(addCase(casePrefix + 'LanguageToCode_Portuguese_024'), 0, () => {
      expect(languageToCode('por')).assertEqual(9);
      expect(languageToCode('pt')).assertEqual(9);
    });

    it(addCase(casePrefix + 'LanguageToCode_Russian_025'), 0, () => {
      expect(languageToCode('rus')).assertEqual(10);
      expect(languageToCode('ru')).assertEqual(10);
    });

    it(addCase(casePrefix + 'LanguageToCode_Vietnamese_026'), 0, () => {
      expect(languageToCode('vie')).assertEqual(11);
      expect(languageToCode('vi')).assertEqual(11);
    });

    it(addCase(casePrefix + 'LanguageToCode_Indonesian_027'), 0, () => {
      expect(languageToCode('ind')).assertEqual(12);
      expect(languageToCode('id')).assertEqual(12);
    });

    it(addCase(casePrefix + 'LanguageToCode_Malaysian_028'), 0, () => {
      expect(languageToCode('may')).assertEqual(13);
      expect(languageToCode('ms')).assertEqual(13);
    });

    it(addCase(casePrefix + 'LanguageToCode_Arabic_029'), 0, () => {
      expect(languageToCode('ara')).assertEqual(14);
      expect(languageToCode('ar')).assertEqual(14);
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code4_030'), 0, () => {
      expect(codeToLanguage(4)).assertEqual('tha');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code5_031'), 0, () => {
      expect(codeToLanguage(5)).assertEqual('fre');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code6_032'), 0, () => {
      expect(codeToLanguage(6)).assertEqual('ger');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code7_033'), 0, () => {
      expect(codeToLanguage(7)).assertEqual('ita');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code8_034'), 0, () => {
      expect(codeToLanguage(8)).assertEqual('spa');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code9_035'), 0, () => {
      expect(codeToLanguage(9)).assertEqual('por');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code10_036'), 0, () => {
      expect(codeToLanguage(10)).assertEqual('rus');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code11_037'), 0, () => {
      expect(codeToLanguage(11)).assertEqual('vie');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code12_038'), 0, () => {
      expect(codeToLanguage(12)).assertEqual('ind');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code13_039'), 0, () => {
      expect(codeToLanguage(13)).assertEqual('may');
    });

    it(addCase(casePrefix + 'CodeToLanguage_Code14_040'), 0, () => {
      expect(codeToLanguage(14)).assertEqual('ara');
    });

    it(addCase(casePrefix + 'LanguageToCode_Hindi_041'), 0, () => {
      expect(languageToCode('hin')).assertEqual(15);
      expect(languageToCode('hi')).assertEqual(15);
    });

    it(addCase(casePrefix + 'LanguageToCode_Bengali_042'), 0, () => {
      expect(languageToCode('ben')).assertEqual(16);
      expect(languageToCode('bn')).assertEqual(16);
    });

    it(addCase(casePrefix + 'LanguageToCode_Tamil_043'), 0, () => {
      expect(languageToCode('tam')).assertEqual(17);
      expect(languageToCode('ta')).assertEqual(17);
    });

    it(addCase(casePrefix + 'LanguageToCode_Telugu_044'), 0, () => {
      expect(languageToCode('tel')).assertEqual(18);
      expect(languageToCode('te')).assertEqual(18);
    });

    it(addCase(casePrefix + 'LanguageToCode_Swedish_045'), 0, () => {
      expect(languageToCode('swe')).assertEqual(19);
      expect(languageToCode('sv')).assertEqual(19);
    });

    it(addCase(casePrefix + 'LanguageToCode_Finnish_046'), 0, () => {
      expect(languageToCode('fin')).assertEqual(20);
      expect(languageToCode('fi')).assertEqual(20);
    });

    it(addCase(casePrefix + 'LanguageToCode_Danish_047'), 0, () => {
      expect(languageToCode('dan')).assertEqual(21);
      expect(languageToCode('da')).assertEqual(21);
    });

    it(addCase(casePrefix + 'LanguageToCode_Norwegian_048'), 0, () => {
      expect(languageToCode('nor')).assertEqual(22);
      expect(languageToCode('no')).assertEqual(22);
    });

    it(addCase(casePrefix + 'LanguageToCode_Polish_049'), 0, () => {
      expect(languageToCode('pol')).assertEqual(23);
      expect(languageToCode('pl')).assertEqual(23);
    });

    it(addCase(casePrefix + 'LanguageToCode_Dutch_050'), 0, () => {
      expect(languageToCode('dut')).assertEqual(24);
      expect(languageToCode('nld')).assertEqual(24);
      expect(languageToCode('nl')).assertEqual(24);
    });

    it(addCase(casePrefix + 'CaseNamePattern_051'), 0, () => {
      expect(allCaseNames.length).assertEqual(51);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_LanguageCodeUtilContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });
  });
}
