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
  return /^pages\/syntheticTitan\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasTitanTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteTitan_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticTitan/node001',
    'pages/syntheticTitan/node002',
    'pages/syntheticTitan/node003',
    'pages/syntheticTitan/node004',
    'pages/syntheticTitan/node005',
    'pages/syntheticTitan/node006',
    'pages/syntheticTitan/node007',
    'pages/syntheticTitan/node008',
    'pages/syntheticTitan/node009',
    'pages/syntheticTitan/node010',
    'pages/syntheticTitan/node011',
    'pages/syntheticTitan/node012',
    'pages/syntheticTitan/node013',
    'pages/syntheticTitan/node014',
    'pages/syntheticTitan/node015',
    'pages/syntheticTitan/node016',
    'pages/syntheticTitan/node017',
    'pages/syntheticTitan/node018',
    'pages/syntheticTitan/node019',
    'pages/syntheticTitan/node020',
    'pages/syntheticTitan/node021',
    'pages/syntheticTitan/node022',
    'pages/syntheticTitan/node023',
    'pages/syntheticTitan/node024',
    'pages/syntheticTitan/node025',
    'pages/syntheticTitan/node026',
    'pages/syntheticTitan/node027',
    'pages/syntheticTitan/node028',
    'pages/syntheticTitan/node029',
    'pages/syntheticTitan/node030',
    'pages/syntheticTitan/node031',
    'pages/syntheticTitan/node032',
    'pages/syntheticTitan/node033',
    'pages/syntheticTitan/node034',
    'pages/syntheticTitan/node035',
    'pages/syntheticTitan/node036',
    'pages/syntheticTitan/node037',
    'pages/syntheticTitan/node038',
    'pages/syntheticTitan/node039',
    'pages/syntheticTitan/node040',
    'pages/syntheticTitan/node041',
    'pages/syntheticTitan/node042',
    'pages/syntheticTitan/node043',
    'pages/syntheticTitan/node044',
    'pages/syntheticTitan/node045',
    'pages/syntheticTitan/node046',
    'pages/syntheticTitan/node047',
    'pages/syntheticTitan/node048',
    'pages/syntheticTitan/node049',
    'pages/syntheticTitan/node050',
    'pages/syntheticTitan/node051',
    'pages/syntheticTitan/node052',
    'pages/syntheticTitan/node053',
    'pages/syntheticTitan/node054',
    'pages/syntheticTitan/node055',
    'pages/syntheticTitan/node056',
    'pages/syntheticTitan/node057',
    'pages/syntheticTitan/node058',
    'pages/syntheticTitan/node059',
    'pages/syntheticTitan/node060',
    'pages/syntheticTitan/node061',
    'pages/syntheticTitan/node062',
    'pages/syntheticTitan/node063',
    'pages/syntheticTitan/node064',
    'pages/syntheticTitan/node065',
    'pages/syntheticTitan/node066',
    'pages/syntheticTitan/node067',
    'pages/syntheticTitan/node068',
    'pages/syntheticTitan/node069',
    'pages/syntheticTitan/node070',
    'pages/syntheticTitan/node071',
    'pages/syntheticTitan/node072',
    'pages/syntheticTitan/node073',
    'pages/syntheticTitan/node074',
    'pages/syntheticTitan/node075',
    'pages/syntheticTitan/node076',
    'pages/syntheticTitan/node077',
    'pages/syntheticTitan/node078',
    'pages/syntheticTitan/node079',
    'pages/syntheticTitan/node080',
    'pages/syntheticTitan/node081',
    'pages/syntheticTitan/node082',
    'pages/syntheticTitan/node083',
    'pages/syntheticTitan/node084',
    'pages/syntheticTitan/node085',
    'pages/syntheticTitan/node086',
    'pages/syntheticTitan/node087',
    'pages/syntheticTitan/node088',
    'pages/syntheticTitan/node089',
    'pages/syntheticTitan/node090',
    'pages/syntheticTitan/node091',
    'pages/syntheticTitan/node092',
    'pages/syntheticTitan/node093',
    'pages/syntheticTitan/node094',
    'pages/syntheticTitan/node095',
    'pages/syntheticTitan/node096',
    'pages/syntheticTitan/node097',
    'pages/syntheticTitan/node098',
    'pages/syntheticTitan/node099',
    'pages/syntheticTitan/node100',
    'pages/syntheticTitan/node101',
    'pages/syntheticTitan/node102',
    'pages/syntheticTitan/node103',
    'pages/syntheticTitan/node104',
    'pages/syntheticTitan/node105',
    'pages/syntheticTitan/node106',
    'pages/syntheticTitan/node107',
    'pages/syntheticTitan/node108',
    'pages/syntheticTitan/node109',
    'pages/syntheticTitan/node110',
    'pages/syntheticTitan/node111',
    'pages/syntheticTitan/node112',
    'pages/syntheticTitan/node113',
    'pages/syntheticTitan/node114',
    'pages/syntheticTitan/node115',
    'pages/syntheticTitan/node116',
    'pages/syntheticTitan/node117',
    'pages/syntheticTitan/node118',
    'pages/syntheticTitan/node119',
    'pages/syntheticTitan/node120',
    'pages/syntheticTitan/node121',
    'pages/syntheticTitan/node122',
    'pages/syntheticTitan/node123',
    'pages/syntheticTitan/node124',
    'pages/syntheticTitan/node125',
    'pages/syntheticTitan/node126',
    'pages/syntheticTitan/node127',
    'pages/syntheticTitan/node128',
    'pages/syntheticTitan/node129',
    'pages/syntheticTitan/node130',
    'pages/syntheticTitan/node131',
    'pages/syntheticTitan/node132',
    'pages/syntheticTitan/node133',
    'pages/syntheticTitan/node134',
    'pages/syntheticTitan/node135',
    'pages/syntheticTitan/node136',
    'pages/syntheticTitan/node137',
    'pages/syntheticTitan/node138',
    'pages/syntheticTitan/node139',
    'pages/syntheticTitan/node140',
    'pages/syntheticTitan/node141',
    'pages/syntheticTitan/node142',
    'pages/syntheticTitan/node143',
    'pages/syntheticTitan/node144',
    'pages/syntheticTitan/node145',
    'pages/syntheticTitan/node146',
    'pages/syntheticTitan/node147',
    'pages/syntheticTitan/node148',
    'pages/syntheticTitan/node149',
    'pages/syntheticTitan/node150',
    'pages/syntheticTitan/node151',
    'pages/syntheticTitan/node152',
    'pages/syntheticTitan/node153',
    'pages/syntheticTitan/node154',
    'pages/syntheticTitan/node155',
    'pages/syntheticTitan/node156',
    'pages/syntheticTitan/node157',
    'pages/syntheticTitan/node158',
    'pages/syntheticTitan/node159',
    'pages/syntheticTitan/node160'
  ];

  describe('MegaSyntheticRouteAtlasTitanSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteTitan_[A-Za-z0-9_]+_[0-9]{3}$/;
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

