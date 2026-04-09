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
  return /^pages\/syntheticMirage\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasMirageTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteMirage_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticMirage/node001',
    'pages/syntheticMirage/node002',
    'pages/syntheticMirage/node003',
    'pages/syntheticMirage/node004',
    'pages/syntheticMirage/node005',
    'pages/syntheticMirage/node006',
    'pages/syntheticMirage/node007',
    'pages/syntheticMirage/node008',
    'pages/syntheticMirage/node009',
    'pages/syntheticMirage/node010',
    'pages/syntheticMirage/node011',
    'pages/syntheticMirage/node012',
    'pages/syntheticMirage/node013',
    'pages/syntheticMirage/node014',
    'pages/syntheticMirage/node015',
    'pages/syntheticMirage/node016',
    'pages/syntheticMirage/node017',
    'pages/syntheticMirage/node018',
    'pages/syntheticMirage/node019',
    'pages/syntheticMirage/node020',
    'pages/syntheticMirage/node021',
    'pages/syntheticMirage/node022',
    'pages/syntheticMirage/node023',
    'pages/syntheticMirage/node024',
    'pages/syntheticMirage/node025',
    'pages/syntheticMirage/node026',
    'pages/syntheticMirage/node027',
    'pages/syntheticMirage/node028',
    'pages/syntheticMirage/node029',
    'pages/syntheticMirage/node030',
    'pages/syntheticMirage/node031',
    'pages/syntheticMirage/node032',
    'pages/syntheticMirage/node033',
    'pages/syntheticMirage/node034',
    'pages/syntheticMirage/node035',
    'pages/syntheticMirage/node036',
    'pages/syntheticMirage/node037',
    'pages/syntheticMirage/node038',
    'pages/syntheticMirage/node039',
    'pages/syntheticMirage/node040',
    'pages/syntheticMirage/node041',
    'pages/syntheticMirage/node042',
    'pages/syntheticMirage/node043',
    'pages/syntheticMirage/node044',
    'pages/syntheticMirage/node045',
    'pages/syntheticMirage/node046',
    'pages/syntheticMirage/node047',
    'pages/syntheticMirage/node048',
    'pages/syntheticMirage/node049',
    'pages/syntheticMirage/node050',
    'pages/syntheticMirage/node051',
    'pages/syntheticMirage/node052',
    'pages/syntheticMirage/node053',
    'pages/syntheticMirage/node054',
    'pages/syntheticMirage/node055',
    'pages/syntheticMirage/node056',
    'pages/syntheticMirage/node057',
    'pages/syntheticMirage/node058',
    'pages/syntheticMirage/node059',
    'pages/syntheticMirage/node060',
    'pages/syntheticMirage/node061',
    'pages/syntheticMirage/node062',
    'pages/syntheticMirage/node063',
    'pages/syntheticMirage/node064',
    'pages/syntheticMirage/node065',
    'pages/syntheticMirage/node066',
    'pages/syntheticMirage/node067',
    'pages/syntheticMirage/node068',
    'pages/syntheticMirage/node069',
    'pages/syntheticMirage/node070',
    'pages/syntheticMirage/node071',
    'pages/syntheticMirage/node072',
    'pages/syntheticMirage/node073',
    'pages/syntheticMirage/node074',
    'pages/syntheticMirage/node075',
    'pages/syntheticMirage/node076',
    'pages/syntheticMirage/node077',
    'pages/syntheticMirage/node078',
    'pages/syntheticMirage/node079',
    'pages/syntheticMirage/node080',
    'pages/syntheticMirage/node081',
    'pages/syntheticMirage/node082',
    'pages/syntheticMirage/node083',
    'pages/syntheticMirage/node084',
    'pages/syntheticMirage/node085',
    'pages/syntheticMirage/node086',
    'pages/syntheticMirage/node087',
    'pages/syntheticMirage/node088',
    'pages/syntheticMirage/node089',
    'pages/syntheticMirage/node090',
    'pages/syntheticMirage/node091',
    'pages/syntheticMirage/node092',
    'pages/syntheticMirage/node093',
    'pages/syntheticMirage/node094',
    'pages/syntheticMirage/node095',
    'pages/syntheticMirage/node096',
    'pages/syntheticMirage/node097',
    'pages/syntheticMirage/node098',
    'pages/syntheticMirage/node099',
    'pages/syntheticMirage/node100',
    'pages/syntheticMirage/node101',
    'pages/syntheticMirage/node102',
    'pages/syntheticMirage/node103',
    'pages/syntheticMirage/node104',
    'pages/syntheticMirage/node105',
    'pages/syntheticMirage/node106',
    'pages/syntheticMirage/node107',
    'pages/syntheticMirage/node108',
    'pages/syntheticMirage/node109',
    'pages/syntheticMirage/node110',
    'pages/syntheticMirage/node111',
    'pages/syntheticMirage/node112',
    'pages/syntheticMirage/node113',
    'pages/syntheticMirage/node114',
    'pages/syntheticMirage/node115',
    'pages/syntheticMirage/node116',
    'pages/syntheticMirage/node117',
    'pages/syntheticMirage/node118',
    'pages/syntheticMirage/node119',
    'pages/syntheticMirage/node120',
    'pages/syntheticMirage/node121',
    'pages/syntheticMirage/node122',
    'pages/syntheticMirage/node123',
    'pages/syntheticMirage/node124',
    'pages/syntheticMirage/node125',
    'pages/syntheticMirage/node126',
    'pages/syntheticMirage/node127',
    'pages/syntheticMirage/node128',
    'pages/syntheticMirage/node129',
    'pages/syntheticMirage/node130',
    'pages/syntheticMirage/node131',
    'pages/syntheticMirage/node132',
    'pages/syntheticMirage/node133',
    'pages/syntheticMirage/node134',
    'pages/syntheticMirage/node135',
    'pages/syntheticMirage/node136',
    'pages/syntheticMirage/node137',
    'pages/syntheticMirage/node138',
    'pages/syntheticMirage/node139',
    'pages/syntheticMirage/node140',
    'pages/syntheticMirage/node141',
    'pages/syntheticMirage/node142',
    'pages/syntheticMirage/node143',
    'pages/syntheticMirage/node144',
    'pages/syntheticMirage/node145',
    'pages/syntheticMirage/node146',
    'pages/syntheticMirage/node147',
    'pages/syntheticMirage/node148',
    'pages/syntheticMirage/node149',
    'pages/syntheticMirage/node150',
    'pages/syntheticMirage/node151',
    'pages/syntheticMirage/node152',
    'pages/syntheticMirage/node153',
    'pages/syntheticMirage/node154',
    'pages/syntheticMirage/node155',
    'pages/syntheticMirage/node156',
    'pages/syntheticMirage/node157',
    'pages/syntheticMirage/node158',
    'pages/syntheticMirage/node159',
    'pages/syntheticMirage/node160'
  ];

  describe('MegaSyntheticRouteAtlasMirageSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteMirage_[A-Za-z0-9_]+_[0-9]{3}$/;
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

