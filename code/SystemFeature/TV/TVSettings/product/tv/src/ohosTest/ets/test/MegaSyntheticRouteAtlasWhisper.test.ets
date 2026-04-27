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

function isSyntheticRouteValid(path: string): boolean {
  return /^pages\/syntheticWhisper\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasWhisperTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteWhisper_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticWhisper/node001',
    'pages/syntheticWhisper/node002',
    'pages/syntheticWhisper/node003',
    'pages/syntheticWhisper/node004',
    'pages/syntheticWhisper/node005',
    'pages/syntheticWhisper/node006',
    'pages/syntheticWhisper/node007',
    'pages/syntheticWhisper/node008',
    'pages/syntheticWhisper/node009',
    'pages/syntheticWhisper/node010',
    'pages/syntheticWhisper/node011',
    'pages/syntheticWhisper/node012',
    'pages/syntheticWhisper/node013',
    'pages/syntheticWhisper/node014',
    'pages/syntheticWhisper/node015',
    'pages/syntheticWhisper/node016',
    'pages/syntheticWhisper/node017',
    'pages/syntheticWhisper/node018',
    'pages/syntheticWhisper/node019',
    'pages/syntheticWhisper/node020',
    'pages/syntheticWhisper/node021',
    'pages/syntheticWhisper/node022',
    'pages/syntheticWhisper/node023',
    'pages/syntheticWhisper/node024',
    'pages/syntheticWhisper/node025',
    'pages/syntheticWhisper/node026',
    'pages/syntheticWhisper/node027',
    'pages/syntheticWhisper/node028',
    'pages/syntheticWhisper/node029',
    'pages/syntheticWhisper/node030',
    'pages/syntheticWhisper/node031',
    'pages/syntheticWhisper/node032',
    'pages/syntheticWhisper/node033',
    'pages/syntheticWhisper/node034',
    'pages/syntheticWhisper/node035',
    'pages/syntheticWhisper/node036',
    'pages/syntheticWhisper/node037',
    'pages/syntheticWhisper/node038',
    'pages/syntheticWhisper/node039',
    'pages/syntheticWhisper/node040',
    'pages/syntheticWhisper/node041',
    'pages/syntheticWhisper/node042',
    'pages/syntheticWhisper/node043',
    'pages/syntheticWhisper/node044',
    'pages/syntheticWhisper/node045',
    'pages/syntheticWhisper/node046',
    'pages/syntheticWhisper/node047',
    'pages/syntheticWhisper/node048',
    'pages/syntheticWhisper/node049',
    'pages/syntheticWhisper/node050',
    'pages/syntheticWhisper/node051',
    'pages/syntheticWhisper/node052',
    'pages/syntheticWhisper/node053',
    'pages/syntheticWhisper/node054',
    'pages/syntheticWhisper/node055',
    'pages/syntheticWhisper/node056',
    'pages/syntheticWhisper/node057',
    'pages/syntheticWhisper/node058',
    'pages/syntheticWhisper/node059',
    'pages/syntheticWhisper/node060',
    'pages/syntheticWhisper/node061',
    'pages/syntheticWhisper/node062',
    'pages/syntheticWhisper/node063',
    'pages/syntheticWhisper/node064',
    'pages/syntheticWhisper/node065',
    'pages/syntheticWhisper/node066',
    'pages/syntheticWhisper/node067',
    'pages/syntheticWhisper/node068',
    'pages/syntheticWhisper/node069',
    'pages/syntheticWhisper/node070',
    'pages/syntheticWhisper/node071',
    'pages/syntheticWhisper/node072',
    'pages/syntheticWhisper/node073',
    'pages/syntheticWhisper/node074',
    'pages/syntheticWhisper/node075',
    'pages/syntheticWhisper/node076',
    'pages/syntheticWhisper/node077',
    'pages/syntheticWhisper/node078',
    'pages/syntheticWhisper/node079',
    'pages/syntheticWhisper/node080',
    'pages/syntheticWhisper/node081',
    'pages/syntheticWhisper/node082',
    'pages/syntheticWhisper/node083',
    'pages/syntheticWhisper/node084',
    'pages/syntheticWhisper/node085',
    'pages/syntheticWhisper/node086',
    'pages/syntheticWhisper/node087',
    'pages/syntheticWhisper/node088',
    'pages/syntheticWhisper/node089',
    'pages/syntheticWhisper/node090',
    'pages/syntheticWhisper/node091',
    'pages/syntheticWhisper/node092',
    'pages/syntheticWhisper/node093',
    'pages/syntheticWhisper/node094',
    'pages/syntheticWhisper/node095',
    'pages/syntheticWhisper/node096',
    'pages/syntheticWhisper/node097',
    'pages/syntheticWhisper/node098',
    'pages/syntheticWhisper/node099',
    'pages/syntheticWhisper/node100',
    'pages/syntheticWhisper/node101',
    'pages/syntheticWhisper/node102',
    'pages/syntheticWhisper/node103',
    'pages/syntheticWhisper/node104',
    'pages/syntheticWhisper/node105',
    'pages/syntheticWhisper/node106',
    'pages/syntheticWhisper/node107',
    'pages/syntheticWhisper/node108',
    'pages/syntheticWhisper/node109',
    'pages/syntheticWhisper/node110',
    'pages/syntheticWhisper/node111',
    'pages/syntheticWhisper/node112',
    'pages/syntheticWhisper/node113',
    'pages/syntheticWhisper/node114',
    'pages/syntheticWhisper/node115',
    'pages/syntheticWhisper/node116',
    'pages/syntheticWhisper/node117',
    'pages/syntheticWhisper/node118',
    'pages/syntheticWhisper/node119',
    'pages/syntheticWhisper/node120',
    'pages/syntheticWhisper/node121',
    'pages/syntheticWhisper/node122',
    'pages/syntheticWhisper/node123',
    'pages/syntheticWhisper/node124',
    'pages/syntheticWhisper/node125',
    'pages/syntheticWhisper/node126',
    'pages/syntheticWhisper/node127',
    'pages/syntheticWhisper/node128',
    'pages/syntheticWhisper/node129',
    'pages/syntheticWhisper/node130',
    'pages/syntheticWhisper/node131',
    'pages/syntheticWhisper/node132',
    'pages/syntheticWhisper/node133',
    'pages/syntheticWhisper/node134',
    'pages/syntheticWhisper/node135',
    'pages/syntheticWhisper/node136',
    'pages/syntheticWhisper/node137',
    'pages/syntheticWhisper/node138',
    'pages/syntheticWhisper/node139',
    'pages/syntheticWhisper/node140',
    'pages/syntheticWhisper/node141',
    'pages/syntheticWhisper/node142',
    'pages/syntheticWhisper/node143',
    'pages/syntheticWhisper/node144',
    'pages/syntheticWhisper/node145',
    'pages/syntheticWhisper/node146',
    'pages/syntheticWhisper/node147',
    'pages/syntheticWhisper/node148',
    'pages/syntheticWhisper/node149',
    'pages/syntheticWhisper/node150',
    'pages/syntheticWhisper/node151',
    'pages/syntheticWhisper/node152',
    'pages/syntheticWhisper/node153',
    'pages/syntheticWhisper/node154',
    'pages/syntheticWhisper/node155',
    'pages/syntheticWhisper/node156',
    'pages/syntheticWhisper/node157',
    'pages/syntheticWhisper/node158',
    'pages/syntheticWhisper/node159',
    'pages/syntheticWhisper/node160'
  ];

  describe('MegaSyntheticRouteAtlasWhisperSuite', () => {
    it(addCase(casePrefix + 'RouteRegex_001'), 0, () => {
      for (let i = 0; i < routes.length; i++) {
        expect(isSyntheticRouteValid(routes[i])).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'RouteUnique_002'), 0, () => {
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < routes.length; i++) {
        expect(unique.has(routes[i])).assertEqual(false);
        unique.add(routes[i]);
      }
      expect(unique.size).assertEqual(routes.length);
    });

    it(addCase(casePrefix + 'RouteStress_003'), 0, () => {
      let validCount = 0;
      for (let i = 0; i < 2000; i++) {
        if (isSyntheticRouteValid(routes[i % routes.length])) {
          validCount++;
        }
      }
      expect(validCount).assertEqual(2000);
    });

    it(addCase(casePrefix + 'CaseNaming_004'), 0, () => {
      const regex = /^Settings_MegaSyntheticRouteWhisper_[A-Za-z0-9_]+_[0-9]{3}$/;
      const unique: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(unique.has(allCaseNames[i])).assertEqual(false);
        unique.add(allCaseNames[i]);
      }
      expect(unique.size).assertEqual(allCaseNames.length);
    });
  });
}

