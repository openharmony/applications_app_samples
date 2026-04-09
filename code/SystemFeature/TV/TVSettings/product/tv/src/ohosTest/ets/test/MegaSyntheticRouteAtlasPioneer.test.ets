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
  return /^pages\/syntheticPioneer\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasPioneerTest() {
  const casePrefix = 'Settings_MegaSyntheticRoutePioneer_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticPioneer/node001',
    'pages/syntheticPioneer/node002',
    'pages/syntheticPioneer/node003',
    'pages/syntheticPioneer/node004',
    'pages/syntheticPioneer/node005',
    'pages/syntheticPioneer/node006',
    'pages/syntheticPioneer/node007',
    'pages/syntheticPioneer/node008',
    'pages/syntheticPioneer/node009',
    'pages/syntheticPioneer/node010',
    'pages/syntheticPioneer/node011',
    'pages/syntheticPioneer/node012',
    'pages/syntheticPioneer/node013',
    'pages/syntheticPioneer/node014',
    'pages/syntheticPioneer/node015',
    'pages/syntheticPioneer/node016',
    'pages/syntheticPioneer/node017',
    'pages/syntheticPioneer/node018',
    'pages/syntheticPioneer/node019',
    'pages/syntheticPioneer/node020',
    'pages/syntheticPioneer/node021',
    'pages/syntheticPioneer/node022',
    'pages/syntheticPioneer/node023',
    'pages/syntheticPioneer/node024',
    'pages/syntheticPioneer/node025',
    'pages/syntheticPioneer/node026',
    'pages/syntheticPioneer/node027',
    'pages/syntheticPioneer/node028',
    'pages/syntheticPioneer/node029',
    'pages/syntheticPioneer/node030',
    'pages/syntheticPioneer/node031',
    'pages/syntheticPioneer/node032',
    'pages/syntheticPioneer/node033',
    'pages/syntheticPioneer/node034',
    'pages/syntheticPioneer/node035',
    'pages/syntheticPioneer/node036',
    'pages/syntheticPioneer/node037',
    'pages/syntheticPioneer/node038',
    'pages/syntheticPioneer/node039',
    'pages/syntheticPioneer/node040',
    'pages/syntheticPioneer/node041',
    'pages/syntheticPioneer/node042',
    'pages/syntheticPioneer/node043',
    'pages/syntheticPioneer/node044',
    'pages/syntheticPioneer/node045',
    'pages/syntheticPioneer/node046',
    'pages/syntheticPioneer/node047',
    'pages/syntheticPioneer/node048',
    'pages/syntheticPioneer/node049',
    'pages/syntheticPioneer/node050',
    'pages/syntheticPioneer/node051',
    'pages/syntheticPioneer/node052',
    'pages/syntheticPioneer/node053',
    'pages/syntheticPioneer/node054',
    'pages/syntheticPioneer/node055',
    'pages/syntheticPioneer/node056',
    'pages/syntheticPioneer/node057',
    'pages/syntheticPioneer/node058',
    'pages/syntheticPioneer/node059',
    'pages/syntheticPioneer/node060',
    'pages/syntheticPioneer/node061',
    'pages/syntheticPioneer/node062',
    'pages/syntheticPioneer/node063',
    'pages/syntheticPioneer/node064',
    'pages/syntheticPioneer/node065',
    'pages/syntheticPioneer/node066',
    'pages/syntheticPioneer/node067',
    'pages/syntheticPioneer/node068',
    'pages/syntheticPioneer/node069',
    'pages/syntheticPioneer/node070',
    'pages/syntheticPioneer/node071',
    'pages/syntheticPioneer/node072',
    'pages/syntheticPioneer/node073',
    'pages/syntheticPioneer/node074',
    'pages/syntheticPioneer/node075',
    'pages/syntheticPioneer/node076',
    'pages/syntheticPioneer/node077',
    'pages/syntheticPioneer/node078',
    'pages/syntheticPioneer/node079',
    'pages/syntheticPioneer/node080',
    'pages/syntheticPioneer/node081',
    'pages/syntheticPioneer/node082',
    'pages/syntheticPioneer/node083',
    'pages/syntheticPioneer/node084',
    'pages/syntheticPioneer/node085',
    'pages/syntheticPioneer/node086',
    'pages/syntheticPioneer/node087',
    'pages/syntheticPioneer/node088',
    'pages/syntheticPioneer/node089',
    'pages/syntheticPioneer/node090',
    'pages/syntheticPioneer/node091',
    'pages/syntheticPioneer/node092',
    'pages/syntheticPioneer/node093',
    'pages/syntheticPioneer/node094',
    'pages/syntheticPioneer/node095',
    'pages/syntheticPioneer/node096',
    'pages/syntheticPioneer/node097',
    'pages/syntheticPioneer/node098',
    'pages/syntheticPioneer/node099',
    'pages/syntheticPioneer/node100',
    'pages/syntheticPioneer/node101',
    'pages/syntheticPioneer/node102',
    'pages/syntheticPioneer/node103',
    'pages/syntheticPioneer/node104',
    'pages/syntheticPioneer/node105',
    'pages/syntheticPioneer/node106',
    'pages/syntheticPioneer/node107',
    'pages/syntheticPioneer/node108',
    'pages/syntheticPioneer/node109',
    'pages/syntheticPioneer/node110',
    'pages/syntheticPioneer/node111',
    'pages/syntheticPioneer/node112',
    'pages/syntheticPioneer/node113',
    'pages/syntheticPioneer/node114',
    'pages/syntheticPioneer/node115',
    'pages/syntheticPioneer/node116',
    'pages/syntheticPioneer/node117',
    'pages/syntheticPioneer/node118',
    'pages/syntheticPioneer/node119',
    'pages/syntheticPioneer/node120',
    'pages/syntheticPioneer/node121',
    'pages/syntheticPioneer/node122',
    'pages/syntheticPioneer/node123',
    'pages/syntheticPioneer/node124',
    'pages/syntheticPioneer/node125',
    'pages/syntheticPioneer/node126',
    'pages/syntheticPioneer/node127',
    'pages/syntheticPioneer/node128',
    'pages/syntheticPioneer/node129',
    'pages/syntheticPioneer/node130',
    'pages/syntheticPioneer/node131',
    'pages/syntheticPioneer/node132',
    'pages/syntheticPioneer/node133',
    'pages/syntheticPioneer/node134',
    'pages/syntheticPioneer/node135',
    'pages/syntheticPioneer/node136',
    'pages/syntheticPioneer/node137',
    'pages/syntheticPioneer/node138',
    'pages/syntheticPioneer/node139',
    'pages/syntheticPioneer/node140',
    'pages/syntheticPioneer/node141',
    'pages/syntheticPioneer/node142',
    'pages/syntheticPioneer/node143',
    'pages/syntheticPioneer/node144',
    'pages/syntheticPioneer/node145',
    'pages/syntheticPioneer/node146',
    'pages/syntheticPioneer/node147',
    'pages/syntheticPioneer/node148',
    'pages/syntheticPioneer/node149',
    'pages/syntheticPioneer/node150',
    'pages/syntheticPioneer/node151',
    'pages/syntheticPioneer/node152',
    'pages/syntheticPioneer/node153',
    'pages/syntheticPioneer/node154',
    'pages/syntheticPioneer/node155',
    'pages/syntheticPioneer/node156',
    'pages/syntheticPioneer/node157',
    'pages/syntheticPioneer/node158',
    'pages/syntheticPioneer/node159',
    'pages/syntheticPioneer/node160'
  ];

  describe('MegaSyntheticRouteAtlasPioneerSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRoutePioneer_[A-Za-z0-9_]+_[0-9]{3}$/;
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

