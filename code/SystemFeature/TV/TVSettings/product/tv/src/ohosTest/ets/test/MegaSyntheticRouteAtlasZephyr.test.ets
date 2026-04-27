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
  return /^pages\/syntheticZephyr\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasZephyrTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteZephyr_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticZephyr/node001',
    'pages/syntheticZephyr/node002',
    'pages/syntheticZephyr/node003',
    'pages/syntheticZephyr/node004',
    'pages/syntheticZephyr/node005',
    'pages/syntheticZephyr/node006',
    'pages/syntheticZephyr/node007',
    'pages/syntheticZephyr/node008',
    'pages/syntheticZephyr/node009',
    'pages/syntheticZephyr/node010',
    'pages/syntheticZephyr/node011',
    'pages/syntheticZephyr/node012',
    'pages/syntheticZephyr/node013',
    'pages/syntheticZephyr/node014',
    'pages/syntheticZephyr/node015',
    'pages/syntheticZephyr/node016',
    'pages/syntheticZephyr/node017',
    'pages/syntheticZephyr/node018',
    'pages/syntheticZephyr/node019',
    'pages/syntheticZephyr/node020',
    'pages/syntheticZephyr/node021',
    'pages/syntheticZephyr/node022',
    'pages/syntheticZephyr/node023',
    'pages/syntheticZephyr/node024',
    'pages/syntheticZephyr/node025',
    'pages/syntheticZephyr/node026',
    'pages/syntheticZephyr/node027',
    'pages/syntheticZephyr/node028',
    'pages/syntheticZephyr/node029',
    'pages/syntheticZephyr/node030',
    'pages/syntheticZephyr/node031',
    'pages/syntheticZephyr/node032',
    'pages/syntheticZephyr/node033',
    'pages/syntheticZephyr/node034',
    'pages/syntheticZephyr/node035',
    'pages/syntheticZephyr/node036',
    'pages/syntheticZephyr/node037',
    'pages/syntheticZephyr/node038',
    'pages/syntheticZephyr/node039',
    'pages/syntheticZephyr/node040',
    'pages/syntheticZephyr/node041',
    'pages/syntheticZephyr/node042',
    'pages/syntheticZephyr/node043',
    'pages/syntheticZephyr/node044',
    'pages/syntheticZephyr/node045',
    'pages/syntheticZephyr/node046',
    'pages/syntheticZephyr/node047',
    'pages/syntheticZephyr/node048',
    'pages/syntheticZephyr/node049',
    'pages/syntheticZephyr/node050',
    'pages/syntheticZephyr/node051',
    'pages/syntheticZephyr/node052',
    'pages/syntheticZephyr/node053',
    'pages/syntheticZephyr/node054',
    'pages/syntheticZephyr/node055',
    'pages/syntheticZephyr/node056',
    'pages/syntheticZephyr/node057',
    'pages/syntheticZephyr/node058',
    'pages/syntheticZephyr/node059',
    'pages/syntheticZephyr/node060',
    'pages/syntheticZephyr/node061',
    'pages/syntheticZephyr/node062',
    'pages/syntheticZephyr/node063',
    'pages/syntheticZephyr/node064',
    'pages/syntheticZephyr/node065',
    'pages/syntheticZephyr/node066',
    'pages/syntheticZephyr/node067',
    'pages/syntheticZephyr/node068',
    'pages/syntheticZephyr/node069',
    'pages/syntheticZephyr/node070',
    'pages/syntheticZephyr/node071',
    'pages/syntheticZephyr/node072',
    'pages/syntheticZephyr/node073',
    'pages/syntheticZephyr/node074',
    'pages/syntheticZephyr/node075',
    'pages/syntheticZephyr/node076',
    'pages/syntheticZephyr/node077',
    'pages/syntheticZephyr/node078',
    'pages/syntheticZephyr/node079',
    'pages/syntheticZephyr/node080',
    'pages/syntheticZephyr/node081',
    'pages/syntheticZephyr/node082',
    'pages/syntheticZephyr/node083',
    'pages/syntheticZephyr/node084',
    'pages/syntheticZephyr/node085',
    'pages/syntheticZephyr/node086',
    'pages/syntheticZephyr/node087',
    'pages/syntheticZephyr/node088',
    'pages/syntheticZephyr/node089',
    'pages/syntheticZephyr/node090',
    'pages/syntheticZephyr/node091',
    'pages/syntheticZephyr/node092',
    'pages/syntheticZephyr/node093',
    'pages/syntheticZephyr/node094',
    'pages/syntheticZephyr/node095',
    'pages/syntheticZephyr/node096',
    'pages/syntheticZephyr/node097',
    'pages/syntheticZephyr/node098',
    'pages/syntheticZephyr/node099',
    'pages/syntheticZephyr/node100',
    'pages/syntheticZephyr/node101',
    'pages/syntheticZephyr/node102',
    'pages/syntheticZephyr/node103',
    'pages/syntheticZephyr/node104',
    'pages/syntheticZephyr/node105',
    'pages/syntheticZephyr/node106',
    'pages/syntheticZephyr/node107',
    'pages/syntheticZephyr/node108',
    'pages/syntheticZephyr/node109',
    'pages/syntheticZephyr/node110',
    'pages/syntheticZephyr/node111',
    'pages/syntheticZephyr/node112',
    'pages/syntheticZephyr/node113',
    'pages/syntheticZephyr/node114',
    'pages/syntheticZephyr/node115',
    'pages/syntheticZephyr/node116',
    'pages/syntheticZephyr/node117',
    'pages/syntheticZephyr/node118',
    'pages/syntheticZephyr/node119',
    'pages/syntheticZephyr/node120',
    'pages/syntheticZephyr/node121',
    'pages/syntheticZephyr/node122',
    'pages/syntheticZephyr/node123',
    'pages/syntheticZephyr/node124',
    'pages/syntheticZephyr/node125',
    'pages/syntheticZephyr/node126',
    'pages/syntheticZephyr/node127',
    'pages/syntheticZephyr/node128',
    'pages/syntheticZephyr/node129',
    'pages/syntheticZephyr/node130',
    'pages/syntheticZephyr/node131',
    'pages/syntheticZephyr/node132',
    'pages/syntheticZephyr/node133',
    'pages/syntheticZephyr/node134',
    'pages/syntheticZephyr/node135',
    'pages/syntheticZephyr/node136',
    'pages/syntheticZephyr/node137',
    'pages/syntheticZephyr/node138',
    'pages/syntheticZephyr/node139',
    'pages/syntheticZephyr/node140',
    'pages/syntheticZephyr/node141',
    'pages/syntheticZephyr/node142',
    'pages/syntheticZephyr/node143',
    'pages/syntheticZephyr/node144',
    'pages/syntheticZephyr/node145',
    'pages/syntheticZephyr/node146',
    'pages/syntheticZephyr/node147',
    'pages/syntheticZephyr/node148',
    'pages/syntheticZephyr/node149',
    'pages/syntheticZephyr/node150',
    'pages/syntheticZephyr/node151',
    'pages/syntheticZephyr/node152',
    'pages/syntheticZephyr/node153',
    'pages/syntheticZephyr/node154',
    'pages/syntheticZephyr/node155',
    'pages/syntheticZephyr/node156',
    'pages/syntheticZephyr/node157',
    'pages/syntheticZephyr/node158',
    'pages/syntheticZephyr/node159',
    'pages/syntheticZephyr/node160'
  ];

  describe('MegaSyntheticRouteAtlasZephyrSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteZephyr_[A-Za-z0-9_]+_[0-9]{3}$/;
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

