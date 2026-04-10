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
  return /^pages\/syntheticEpsilon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasEpsilonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteEpsilon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticEpsilon/node001',
    'pages/syntheticEpsilon/node002',
    'pages/syntheticEpsilon/node003',
    'pages/syntheticEpsilon/node004',
    'pages/syntheticEpsilon/node005',
    'pages/syntheticEpsilon/node006',
    'pages/syntheticEpsilon/node007',
    'pages/syntheticEpsilon/node008',
    'pages/syntheticEpsilon/node009',
    'pages/syntheticEpsilon/node010',
    'pages/syntheticEpsilon/node011',
    'pages/syntheticEpsilon/node012',
    'pages/syntheticEpsilon/node013',
    'pages/syntheticEpsilon/node014',
    'pages/syntheticEpsilon/node015',
    'pages/syntheticEpsilon/node016',
    'pages/syntheticEpsilon/node017',
    'pages/syntheticEpsilon/node018',
    'pages/syntheticEpsilon/node019',
    'pages/syntheticEpsilon/node020',
    'pages/syntheticEpsilon/node021',
    'pages/syntheticEpsilon/node022',
    'pages/syntheticEpsilon/node023',
    'pages/syntheticEpsilon/node024',
    'pages/syntheticEpsilon/node025',
    'pages/syntheticEpsilon/node026',
    'pages/syntheticEpsilon/node027',
    'pages/syntheticEpsilon/node028',
    'pages/syntheticEpsilon/node029',
    'pages/syntheticEpsilon/node030',
    'pages/syntheticEpsilon/node031',
    'pages/syntheticEpsilon/node032',
    'pages/syntheticEpsilon/node033',
    'pages/syntheticEpsilon/node034',
    'pages/syntheticEpsilon/node035',
    'pages/syntheticEpsilon/node036',
    'pages/syntheticEpsilon/node037',
    'pages/syntheticEpsilon/node038',
    'pages/syntheticEpsilon/node039',
    'pages/syntheticEpsilon/node040',
    'pages/syntheticEpsilon/node041',
    'pages/syntheticEpsilon/node042',
    'pages/syntheticEpsilon/node043',
    'pages/syntheticEpsilon/node044',
    'pages/syntheticEpsilon/node045',
    'pages/syntheticEpsilon/node046',
    'pages/syntheticEpsilon/node047',
    'pages/syntheticEpsilon/node048',
    'pages/syntheticEpsilon/node049',
    'pages/syntheticEpsilon/node050',
    'pages/syntheticEpsilon/node051',
    'pages/syntheticEpsilon/node052',
    'pages/syntheticEpsilon/node053',
    'pages/syntheticEpsilon/node054',
    'pages/syntheticEpsilon/node055',
    'pages/syntheticEpsilon/node056',
    'pages/syntheticEpsilon/node057',
    'pages/syntheticEpsilon/node058',
    'pages/syntheticEpsilon/node059',
    'pages/syntheticEpsilon/node060',
    'pages/syntheticEpsilon/node061',
    'pages/syntheticEpsilon/node062',
    'pages/syntheticEpsilon/node063',
    'pages/syntheticEpsilon/node064',
    'pages/syntheticEpsilon/node065',
    'pages/syntheticEpsilon/node066',
    'pages/syntheticEpsilon/node067',
    'pages/syntheticEpsilon/node068',
    'pages/syntheticEpsilon/node069',
    'pages/syntheticEpsilon/node070',
    'pages/syntheticEpsilon/node071',
    'pages/syntheticEpsilon/node072',
    'pages/syntheticEpsilon/node073',
    'pages/syntheticEpsilon/node074',
    'pages/syntheticEpsilon/node075',
    'pages/syntheticEpsilon/node076',
    'pages/syntheticEpsilon/node077',
    'pages/syntheticEpsilon/node078',
    'pages/syntheticEpsilon/node079',
    'pages/syntheticEpsilon/node080',
    'pages/syntheticEpsilon/node081',
    'pages/syntheticEpsilon/node082',
    'pages/syntheticEpsilon/node083',
    'pages/syntheticEpsilon/node084',
    'pages/syntheticEpsilon/node085',
    'pages/syntheticEpsilon/node086',
    'pages/syntheticEpsilon/node087',
    'pages/syntheticEpsilon/node088',
    'pages/syntheticEpsilon/node089',
    'pages/syntheticEpsilon/node090',
    'pages/syntheticEpsilon/node091',
    'pages/syntheticEpsilon/node092',
    'pages/syntheticEpsilon/node093',
    'pages/syntheticEpsilon/node094',
    'pages/syntheticEpsilon/node095',
    'pages/syntheticEpsilon/node096',
    'pages/syntheticEpsilon/node097',
    'pages/syntheticEpsilon/node098',
    'pages/syntheticEpsilon/node099',
    'pages/syntheticEpsilon/node100',
    'pages/syntheticEpsilon/node101',
    'pages/syntheticEpsilon/node102',
    'pages/syntheticEpsilon/node103',
    'pages/syntheticEpsilon/node104',
    'pages/syntheticEpsilon/node105',
    'pages/syntheticEpsilon/node106',
    'pages/syntheticEpsilon/node107',
    'pages/syntheticEpsilon/node108',
    'pages/syntheticEpsilon/node109',
    'pages/syntheticEpsilon/node110',
    'pages/syntheticEpsilon/node111',
    'pages/syntheticEpsilon/node112',
    'pages/syntheticEpsilon/node113',
    'pages/syntheticEpsilon/node114',
    'pages/syntheticEpsilon/node115',
    'pages/syntheticEpsilon/node116',
    'pages/syntheticEpsilon/node117',
    'pages/syntheticEpsilon/node118',
    'pages/syntheticEpsilon/node119',
    'pages/syntheticEpsilon/node120',
    'pages/syntheticEpsilon/node121',
    'pages/syntheticEpsilon/node122',
    'pages/syntheticEpsilon/node123',
    'pages/syntheticEpsilon/node124',
    'pages/syntheticEpsilon/node125',
    'pages/syntheticEpsilon/node126',
    'pages/syntheticEpsilon/node127',
    'pages/syntheticEpsilon/node128',
    'pages/syntheticEpsilon/node129',
    'pages/syntheticEpsilon/node130',
    'pages/syntheticEpsilon/node131',
    'pages/syntheticEpsilon/node132',
    'pages/syntheticEpsilon/node133',
    'pages/syntheticEpsilon/node134',
    'pages/syntheticEpsilon/node135',
    'pages/syntheticEpsilon/node136',
    'pages/syntheticEpsilon/node137',
    'pages/syntheticEpsilon/node138',
    'pages/syntheticEpsilon/node139',
    'pages/syntheticEpsilon/node140',
    'pages/syntheticEpsilon/node141',
    'pages/syntheticEpsilon/node142',
    'pages/syntheticEpsilon/node143',
    'pages/syntheticEpsilon/node144',
    'pages/syntheticEpsilon/node145',
    'pages/syntheticEpsilon/node146',
    'pages/syntheticEpsilon/node147',
    'pages/syntheticEpsilon/node148',
    'pages/syntheticEpsilon/node149',
    'pages/syntheticEpsilon/node150',
    'pages/syntheticEpsilon/node151',
    'pages/syntheticEpsilon/node152',
    'pages/syntheticEpsilon/node153',
    'pages/syntheticEpsilon/node154',
    'pages/syntheticEpsilon/node155',
    'pages/syntheticEpsilon/node156',
    'pages/syntheticEpsilon/node157',
    'pages/syntheticEpsilon/node158',
    'pages/syntheticEpsilon/node159',
    'pages/syntheticEpsilon/node160'
  ];

  describe('MegaSyntheticRouteAtlasEpsilonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteEpsilon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

