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
  return /^pages\/syntheticPrism\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasPrismTest() {
  const casePrefix = 'Settings_MegaSyntheticRoutePrism_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticPrism/node001',
    'pages/syntheticPrism/node002',
    'pages/syntheticPrism/node003',
    'pages/syntheticPrism/node004',
    'pages/syntheticPrism/node005',
    'pages/syntheticPrism/node006',
    'pages/syntheticPrism/node007',
    'pages/syntheticPrism/node008',
    'pages/syntheticPrism/node009',
    'pages/syntheticPrism/node010',
    'pages/syntheticPrism/node011',
    'pages/syntheticPrism/node012',
    'pages/syntheticPrism/node013',
    'pages/syntheticPrism/node014',
    'pages/syntheticPrism/node015',
    'pages/syntheticPrism/node016',
    'pages/syntheticPrism/node017',
    'pages/syntheticPrism/node018',
    'pages/syntheticPrism/node019',
    'pages/syntheticPrism/node020',
    'pages/syntheticPrism/node021',
    'pages/syntheticPrism/node022',
    'pages/syntheticPrism/node023',
    'pages/syntheticPrism/node024',
    'pages/syntheticPrism/node025',
    'pages/syntheticPrism/node026',
    'pages/syntheticPrism/node027',
    'pages/syntheticPrism/node028',
    'pages/syntheticPrism/node029',
    'pages/syntheticPrism/node030',
    'pages/syntheticPrism/node031',
    'pages/syntheticPrism/node032',
    'pages/syntheticPrism/node033',
    'pages/syntheticPrism/node034',
    'pages/syntheticPrism/node035',
    'pages/syntheticPrism/node036',
    'pages/syntheticPrism/node037',
    'pages/syntheticPrism/node038',
    'pages/syntheticPrism/node039',
    'pages/syntheticPrism/node040',
    'pages/syntheticPrism/node041',
    'pages/syntheticPrism/node042',
    'pages/syntheticPrism/node043',
    'pages/syntheticPrism/node044',
    'pages/syntheticPrism/node045',
    'pages/syntheticPrism/node046',
    'pages/syntheticPrism/node047',
    'pages/syntheticPrism/node048',
    'pages/syntheticPrism/node049',
    'pages/syntheticPrism/node050',
    'pages/syntheticPrism/node051',
    'pages/syntheticPrism/node052',
    'pages/syntheticPrism/node053',
    'pages/syntheticPrism/node054',
    'pages/syntheticPrism/node055',
    'pages/syntheticPrism/node056',
    'pages/syntheticPrism/node057',
    'pages/syntheticPrism/node058',
    'pages/syntheticPrism/node059',
    'pages/syntheticPrism/node060',
    'pages/syntheticPrism/node061',
    'pages/syntheticPrism/node062',
    'pages/syntheticPrism/node063',
    'pages/syntheticPrism/node064',
    'pages/syntheticPrism/node065',
    'pages/syntheticPrism/node066',
    'pages/syntheticPrism/node067',
    'pages/syntheticPrism/node068',
    'pages/syntheticPrism/node069',
    'pages/syntheticPrism/node070',
    'pages/syntheticPrism/node071',
    'pages/syntheticPrism/node072',
    'pages/syntheticPrism/node073',
    'pages/syntheticPrism/node074',
    'pages/syntheticPrism/node075',
    'pages/syntheticPrism/node076',
    'pages/syntheticPrism/node077',
    'pages/syntheticPrism/node078',
    'pages/syntheticPrism/node079',
    'pages/syntheticPrism/node080',
    'pages/syntheticPrism/node081',
    'pages/syntheticPrism/node082',
    'pages/syntheticPrism/node083',
    'pages/syntheticPrism/node084',
    'pages/syntheticPrism/node085',
    'pages/syntheticPrism/node086',
    'pages/syntheticPrism/node087',
    'pages/syntheticPrism/node088',
    'pages/syntheticPrism/node089',
    'pages/syntheticPrism/node090',
    'pages/syntheticPrism/node091',
    'pages/syntheticPrism/node092',
    'pages/syntheticPrism/node093',
    'pages/syntheticPrism/node094',
    'pages/syntheticPrism/node095',
    'pages/syntheticPrism/node096',
    'pages/syntheticPrism/node097',
    'pages/syntheticPrism/node098',
    'pages/syntheticPrism/node099',
    'pages/syntheticPrism/node100',
    'pages/syntheticPrism/node101',
    'pages/syntheticPrism/node102',
    'pages/syntheticPrism/node103',
    'pages/syntheticPrism/node104',
    'pages/syntheticPrism/node105',
    'pages/syntheticPrism/node106',
    'pages/syntheticPrism/node107',
    'pages/syntheticPrism/node108',
    'pages/syntheticPrism/node109',
    'pages/syntheticPrism/node110',
    'pages/syntheticPrism/node111',
    'pages/syntheticPrism/node112',
    'pages/syntheticPrism/node113',
    'pages/syntheticPrism/node114',
    'pages/syntheticPrism/node115',
    'pages/syntheticPrism/node116',
    'pages/syntheticPrism/node117',
    'pages/syntheticPrism/node118',
    'pages/syntheticPrism/node119',
    'pages/syntheticPrism/node120',
    'pages/syntheticPrism/node121',
    'pages/syntheticPrism/node122',
    'pages/syntheticPrism/node123',
    'pages/syntheticPrism/node124',
    'pages/syntheticPrism/node125',
    'pages/syntheticPrism/node126',
    'pages/syntheticPrism/node127',
    'pages/syntheticPrism/node128',
    'pages/syntheticPrism/node129',
    'pages/syntheticPrism/node130',
    'pages/syntheticPrism/node131',
    'pages/syntheticPrism/node132',
    'pages/syntheticPrism/node133',
    'pages/syntheticPrism/node134',
    'pages/syntheticPrism/node135',
    'pages/syntheticPrism/node136',
    'pages/syntheticPrism/node137',
    'pages/syntheticPrism/node138',
    'pages/syntheticPrism/node139',
    'pages/syntheticPrism/node140',
    'pages/syntheticPrism/node141',
    'pages/syntheticPrism/node142',
    'pages/syntheticPrism/node143',
    'pages/syntheticPrism/node144',
    'pages/syntheticPrism/node145',
    'pages/syntheticPrism/node146',
    'pages/syntheticPrism/node147',
    'pages/syntheticPrism/node148',
    'pages/syntheticPrism/node149',
    'pages/syntheticPrism/node150',
    'pages/syntheticPrism/node151',
    'pages/syntheticPrism/node152',
    'pages/syntheticPrism/node153',
    'pages/syntheticPrism/node154',
    'pages/syntheticPrism/node155',
    'pages/syntheticPrism/node156',
    'pages/syntheticPrism/node157',
    'pages/syntheticPrism/node158',
    'pages/syntheticPrism/node159',
    'pages/syntheticPrism/node160'
  ];

  describe('MegaSyntheticRouteAtlasPrismSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRoutePrism_[A-Za-z0-9_]+_[0-9]{3}$/;
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

