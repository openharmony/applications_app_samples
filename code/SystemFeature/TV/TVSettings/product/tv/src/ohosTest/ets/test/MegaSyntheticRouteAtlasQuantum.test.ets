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
  return /^pages\/syntheticQuantum\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasQuantumTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteQuantum_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticQuantum/node001',
    'pages/syntheticQuantum/node002',
    'pages/syntheticQuantum/node003',
    'pages/syntheticQuantum/node004',
    'pages/syntheticQuantum/node005',
    'pages/syntheticQuantum/node006',
    'pages/syntheticQuantum/node007',
    'pages/syntheticQuantum/node008',
    'pages/syntheticQuantum/node009',
    'pages/syntheticQuantum/node010',
    'pages/syntheticQuantum/node011',
    'pages/syntheticQuantum/node012',
    'pages/syntheticQuantum/node013',
    'pages/syntheticQuantum/node014',
    'pages/syntheticQuantum/node015',
    'pages/syntheticQuantum/node016',
    'pages/syntheticQuantum/node017',
    'pages/syntheticQuantum/node018',
    'pages/syntheticQuantum/node019',
    'pages/syntheticQuantum/node020',
    'pages/syntheticQuantum/node021',
    'pages/syntheticQuantum/node022',
    'pages/syntheticQuantum/node023',
    'pages/syntheticQuantum/node024',
    'pages/syntheticQuantum/node025',
    'pages/syntheticQuantum/node026',
    'pages/syntheticQuantum/node027',
    'pages/syntheticQuantum/node028',
    'pages/syntheticQuantum/node029',
    'pages/syntheticQuantum/node030',
    'pages/syntheticQuantum/node031',
    'pages/syntheticQuantum/node032',
    'pages/syntheticQuantum/node033',
    'pages/syntheticQuantum/node034',
    'pages/syntheticQuantum/node035',
    'pages/syntheticQuantum/node036',
    'pages/syntheticQuantum/node037',
    'pages/syntheticQuantum/node038',
    'pages/syntheticQuantum/node039',
    'pages/syntheticQuantum/node040',
    'pages/syntheticQuantum/node041',
    'pages/syntheticQuantum/node042',
    'pages/syntheticQuantum/node043',
    'pages/syntheticQuantum/node044',
    'pages/syntheticQuantum/node045',
    'pages/syntheticQuantum/node046',
    'pages/syntheticQuantum/node047',
    'pages/syntheticQuantum/node048',
    'pages/syntheticQuantum/node049',
    'pages/syntheticQuantum/node050',
    'pages/syntheticQuantum/node051',
    'pages/syntheticQuantum/node052',
    'pages/syntheticQuantum/node053',
    'pages/syntheticQuantum/node054',
    'pages/syntheticQuantum/node055',
    'pages/syntheticQuantum/node056',
    'pages/syntheticQuantum/node057',
    'pages/syntheticQuantum/node058',
    'pages/syntheticQuantum/node059',
    'pages/syntheticQuantum/node060',
    'pages/syntheticQuantum/node061',
    'pages/syntheticQuantum/node062',
    'pages/syntheticQuantum/node063',
    'pages/syntheticQuantum/node064',
    'pages/syntheticQuantum/node065',
    'pages/syntheticQuantum/node066',
    'pages/syntheticQuantum/node067',
    'pages/syntheticQuantum/node068',
    'pages/syntheticQuantum/node069',
    'pages/syntheticQuantum/node070',
    'pages/syntheticQuantum/node071',
    'pages/syntheticQuantum/node072',
    'pages/syntheticQuantum/node073',
    'pages/syntheticQuantum/node074',
    'pages/syntheticQuantum/node075',
    'pages/syntheticQuantum/node076',
    'pages/syntheticQuantum/node077',
    'pages/syntheticQuantum/node078',
    'pages/syntheticQuantum/node079',
    'pages/syntheticQuantum/node080',
    'pages/syntheticQuantum/node081',
    'pages/syntheticQuantum/node082',
    'pages/syntheticQuantum/node083',
    'pages/syntheticQuantum/node084',
    'pages/syntheticQuantum/node085',
    'pages/syntheticQuantum/node086',
    'pages/syntheticQuantum/node087',
    'pages/syntheticQuantum/node088',
    'pages/syntheticQuantum/node089',
    'pages/syntheticQuantum/node090',
    'pages/syntheticQuantum/node091',
    'pages/syntheticQuantum/node092',
    'pages/syntheticQuantum/node093',
    'pages/syntheticQuantum/node094',
    'pages/syntheticQuantum/node095',
    'pages/syntheticQuantum/node096',
    'pages/syntheticQuantum/node097',
    'pages/syntheticQuantum/node098',
    'pages/syntheticQuantum/node099',
    'pages/syntheticQuantum/node100',
    'pages/syntheticQuantum/node101',
    'pages/syntheticQuantum/node102',
    'pages/syntheticQuantum/node103',
    'pages/syntheticQuantum/node104',
    'pages/syntheticQuantum/node105',
    'pages/syntheticQuantum/node106',
    'pages/syntheticQuantum/node107',
    'pages/syntheticQuantum/node108',
    'pages/syntheticQuantum/node109',
    'pages/syntheticQuantum/node110',
    'pages/syntheticQuantum/node111',
    'pages/syntheticQuantum/node112',
    'pages/syntheticQuantum/node113',
    'pages/syntheticQuantum/node114',
    'pages/syntheticQuantum/node115',
    'pages/syntheticQuantum/node116',
    'pages/syntheticQuantum/node117',
    'pages/syntheticQuantum/node118',
    'pages/syntheticQuantum/node119',
    'pages/syntheticQuantum/node120',
    'pages/syntheticQuantum/node121',
    'pages/syntheticQuantum/node122',
    'pages/syntheticQuantum/node123',
    'pages/syntheticQuantum/node124',
    'pages/syntheticQuantum/node125',
    'pages/syntheticQuantum/node126',
    'pages/syntheticQuantum/node127',
    'pages/syntheticQuantum/node128',
    'pages/syntheticQuantum/node129',
    'pages/syntheticQuantum/node130',
    'pages/syntheticQuantum/node131',
    'pages/syntheticQuantum/node132',
    'pages/syntheticQuantum/node133',
    'pages/syntheticQuantum/node134',
    'pages/syntheticQuantum/node135',
    'pages/syntheticQuantum/node136',
    'pages/syntheticQuantum/node137',
    'pages/syntheticQuantum/node138',
    'pages/syntheticQuantum/node139',
    'pages/syntheticQuantum/node140',
    'pages/syntheticQuantum/node141',
    'pages/syntheticQuantum/node142',
    'pages/syntheticQuantum/node143',
    'pages/syntheticQuantum/node144',
    'pages/syntheticQuantum/node145',
    'pages/syntheticQuantum/node146',
    'pages/syntheticQuantum/node147',
    'pages/syntheticQuantum/node148',
    'pages/syntheticQuantum/node149',
    'pages/syntheticQuantum/node150',
    'pages/syntheticQuantum/node151',
    'pages/syntheticQuantum/node152',
    'pages/syntheticQuantum/node153',
    'pages/syntheticQuantum/node154',
    'pages/syntheticQuantum/node155',
    'pages/syntheticQuantum/node156',
    'pages/syntheticQuantum/node157',
    'pages/syntheticQuantum/node158',
    'pages/syntheticQuantum/node159',
    'pages/syntheticQuantum/node160'
  ];

  describe('MegaSyntheticRouteAtlasQuantumSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteQuantum_[A-Za-z0-9_]+_[0-9]{3}$/;
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

