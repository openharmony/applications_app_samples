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
  return /^pages\/syntheticFrontier\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasFrontierTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteFrontier_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticFrontier/node001',
    'pages/syntheticFrontier/node002',
    'pages/syntheticFrontier/node003',
    'pages/syntheticFrontier/node004',
    'pages/syntheticFrontier/node005',
    'pages/syntheticFrontier/node006',
    'pages/syntheticFrontier/node007',
    'pages/syntheticFrontier/node008',
    'pages/syntheticFrontier/node009',
    'pages/syntheticFrontier/node010',
    'pages/syntheticFrontier/node011',
    'pages/syntheticFrontier/node012',
    'pages/syntheticFrontier/node013',
    'pages/syntheticFrontier/node014',
    'pages/syntheticFrontier/node015',
    'pages/syntheticFrontier/node016',
    'pages/syntheticFrontier/node017',
    'pages/syntheticFrontier/node018',
    'pages/syntheticFrontier/node019',
    'pages/syntheticFrontier/node020',
    'pages/syntheticFrontier/node021',
    'pages/syntheticFrontier/node022',
    'pages/syntheticFrontier/node023',
    'pages/syntheticFrontier/node024',
    'pages/syntheticFrontier/node025',
    'pages/syntheticFrontier/node026',
    'pages/syntheticFrontier/node027',
    'pages/syntheticFrontier/node028',
    'pages/syntheticFrontier/node029',
    'pages/syntheticFrontier/node030',
    'pages/syntheticFrontier/node031',
    'pages/syntheticFrontier/node032',
    'pages/syntheticFrontier/node033',
    'pages/syntheticFrontier/node034',
    'pages/syntheticFrontier/node035',
    'pages/syntheticFrontier/node036',
    'pages/syntheticFrontier/node037',
    'pages/syntheticFrontier/node038',
    'pages/syntheticFrontier/node039',
    'pages/syntheticFrontier/node040',
    'pages/syntheticFrontier/node041',
    'pages/syntheticFrontier/node042',
    'pages/syntheticFrontier/node043',
    'pages/syntheticFrontier/node044',
    'pages/syntheticFrontier/node045',
    'pages/syntheticFrontier/node046',
    'pages/syntheticFrontier/node047',
    'pages/syntheticFrontier/node048',
    'pages/syntheticFrontier/node049',
    'pages/syntheticFrontier/node050',
    'pages/syntheticFrontier/node051',
    'pages/syntheticFrontier/node052',
    'pages/syntheticFrontier/node053',
    'pages/syntheticFrontier/node054',
    'pages/syntheticFrontier/node055',
    'pages/syntheticFrontier/node056',
    'pages/syntheticFrontier/node057',
    'pages/syntheticFrontier/node058',
    'pages/syntheticFrontier/node059',
    'pages/syntheticFrontier/node060',
    'pages/syntheticFrontier/node061',
    'pages/syntheticFrontier/node062',
    'pages/syntheticFrontier/node063',
    'pages/syntheticFrontier/node064',
    'pages/syntheticFrontier/node065',
    'pages/syntheticFrontier/node066',
    'pages/syntheticFrontier/node067',
    'pages/syntheticFrontier/node068',
    'pages/syntheticFrontier/node069',
    'pages/syntheticFrontier/node070',
    'pages/syntheticFrontier/node071',
    'pages/syntheticFrontier/node072',
    'pages/syntheticFrontier/node073',
    'pages/syntheticFrontier/node074',
    'pages/syntheticFrontier/node075',
    'pages/syntheticFrontier/node076',
    'pages/syntheticFrontier/node077',
    'pages/syntheticFrontier/node078',
    'pages/syntheticFrontier/node079',
    'pages/syntheticFrontier/node080',
    'pages/syntheticFrontier/node081',
    'pages/syntheticFrontier/node082',
    'pages/syntheticFrontier/node083',
    'pages/syntheticFrontier/node084',
    'pages/syntheticFrontier/node085',
    'pages/syntheticFrontier/node086',
    'pages/syntheticFrontier/node087',
    'pages/syntheticFrontier/node088',
    'pages/syntheticFrontier/node089',
    'pages/syntheticFrontier/node090',
    'pages/syntheticFrontier/node091',
    'pages/syntheticFrontier/node092',
    'pages/syntheticFrontier/node093',
    'pages/syntheticFrontier/node094',
    'pages/syntheticFrontier/node095',
    'pages/syntheticFrontier/node096',
    'pages/syntheticFrontier/node097',
    'pages/syntheticFrontier/node098',
    'pages/syntheticFrontier/node099',
    'pages/syntheticFrontier/node100',
    'pages/syntheticFrontier/node101',
    'pages/syntheticFrontier/node102',
    'pages/syntheticFrontier/node103',
    'pages/syntheticFrontier/node104',
    'pages/syntheticFrontier/node105',
    'pages/syntheticFrontier/node106',
    'pages/syntheticFrontier/node107',
    'pages/syntheticFrontier/node108',
    'pages/syntheticFrontier/node109',
    'pages/syntheticFrontier/node110',
    'pages/syntheticFrontier/node111',
    'pages/syntheticFrontier/node112',
    'pages/syntheticFrontier/node113',
    'pages/syntheticFrontier/node114',
    'pages/syntheticFrontier/node115',
    'pages/syntheticFrontier/node116',
    'pages/syntheticFrontier/node117',
    'pages/syntheticFrontier/node118',
    'pages/syntheticFrontier/node119',
    'pages/syntheticFrontier/node120',
    'pages/syntheticFrontier/node121',
    'pages/syntheticFrontier/node122',
    'pages/syntheticFrontier/node123',
    'pages/syntheticFrontier/node124',
    'pages/syntheticFrontier/node125',
    'pages/syntheticFrontier/node126',
    'pages/syntheticFrontier/node127',
    'pages/syntheticFrontier/node128',
    'pages/syntheticFrontier/node129',
    'pages/syntheticFrontier/node130',
    'pages/syntheticFrontier/node131',
    'pages/syntheticFrontier/node132',
    'pages/syntheticFrontier/node133',
    'pages/syntheticFrontier/node134',
    'pages/syntheticFrontier/node135',
    'pages/syntheticFrontier/node136',
    'pages/syntheticFrontier/node137',
    'pages/syntheticFrontier/node138',
    'pages/syntheticFrontier/node139',
    'pages/syntheticFrontier/node140',
    'pages/syntheticFrontier/node141',
    'pages/syntheticFrontier/node142',
    'pages/syntheticFrontier/node143',
    'pages/syntheticFrontier/node144',
    'pages/syntheticFrontier/node145',
    'pages/syntheticFrontier/node146',
    'pages/syntheticFrontier/node147',
    'pages/syntheticFrontier/node148',
    'pages/syntheticFrontier/node149',
    'pages/syntheticFrontier/node150',
    'pages/syntheticFrontier/node151',
    'pages/syntheticFrontier/node152',
    'pages/syntheticFrontier/node153',
    'pages/syntheticFrontier/node154',
    'pages/syntheticFrontier/node155',
    'pages/syntheticFrontier/node156',
    'pages/syntheticFrontier/node157',
    'pages/syntheticFrontier/node158',
    'pages/syntheticFrontier/node159',
    'pages/syntheticFrontier/node160'
  ];

  describe('MegaSyntheticRouteAtlasFrontierSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteFrontier_[A-Za-z0-9_]+_[0-9]{3}$/;
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

