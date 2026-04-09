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
  return /^pages\/syntheticMu\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasMuTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteMu_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticMu/node001',
    'pages/syntheticMu/node002',
    'pages/syntheticMu/node003',
    'pages/syntheticMu/node004',
    'pages/syntheticMu/node005',
    'pages/syntheticMu/node006',
    'pages/syntheticMu/node007',
    'pages/syntheticMu/node008',
    'pages/syntheticMu/node009',
    'pages/syntheticMu/node010',
    'pages/syntheticMu/node011',
    'pages/syntheticMu/node012',
    'pages/syntheticMu/node013',
    'pages/syntheticMu/node014',
    'pages/syntheticMu/node015',
    'pages/syntheticMu/node016',
    'pages/syntheticMu/node017',
    'pages/syntheticMu/node018',
    'pages/syntheticMu/node019',
    'pages/syntheticMu/node020',
    'pages/syntheticMu/node021',
    'pages/syntheticMu/node022',
    'pages/syntheticMu/node023',
    'pages/syntheticMu/node024',
    'pages/syntheticMu/node025',
    'pages/syntheticMu/node026',
    'pages/syntheticMu/node027',
    'pages/syntheticMu/node028',
    'pages/syntheticMu/node029',
    'pages/syntheticMu/node030',
    'pages/syntheticMu/node031',
    'pages/syntheticMu/node032',
    'pages/syntheticMu/node033',
    'pages/syntheticMu/node034',
    'pages/syntheticMu/node035',
    'pages/syntheticMu/node036',
    'pages/syntheticMu/node037',
    'pages/syntheticMu/node038',
    'pages/syntheticMu/node039',
    'pages/syntheticMu/node040',
    'pages/syntheticMu/node041',
    'pages/syntheticMu/node042',
    'pages/syntheticMu/node043',
    'pages/syntheticMu/node044',
    'pages/syntheticMu/node045',
    'pages/syntheticMu/node046',
    'pages/syntheticMu/node047',
    'pages/syntheticMu/node048',
    'pages/syntheticMu/node049',
    'pages/syntheticMu/node050',
    'pages/syntheticMu/node051',
    'pages/syntheticMu/node052',
    'pages/syntheticMu/node053',
    'pages/syntheticMu/node054',
    'pages/syntheticMu/node055',
    'pages/syntheticMu/node056',
    'pages/syntheticMu/node057',
    'pages/syntheticMu/node058',
    'pages/syntheticMu/node059',
    'pages/syntheticMu/node060',
    'pages/syntheticMu/node061',
    'pages/syntheticMu/node062',
    'pages/syntheticMu/node063',
    'pages/syntheticMu/node064',
    'pages/syntheticMu/node065',
    'pages/syntheticMu/node066',
    'pages/syntheticMu/node067',
    'pages/syntheticMu/node068',
    'pages/syntheticMu/node069',
    'pages/syntheticMu/node070',
    'pages/syntheticMu/node071',
    'pages/syntheticMu/node072',
    'pages/syntheticMu/node073',
    'pages/syntheticMu/node074',
    'pages/syntheticMu/node075',
    'pages/syntheticMu/node076',
    'pages/syntheticMu/node077',
    'pages/syntheticMu/node078',
    'pages/syntheticMu/node079',
    'pages/syntheticMu/node080',
    'pages/syntheticMu/node081',
    'pages/syntheticMu/node082',
    'pages/syntheticMu/node083',
    'pages/syntheticMu/node084',
    'pages/syntheticMu/node085',
    'pages/syntheticMu/node086',
    'pages/syntheticMu/node087',
    'pages/syntheticMu/node088',
    'pages/syntheticMu/node089',
    'pages/syntheticMu/node090',
    'pages/syntheticMu/node091',
    'pages/syntheticMu/node092',
    'pages/syntheticMu/node093',
    'pages/syntheticMu/node094',
    'pages/syntheticMu/node095',
    'pages/syntheticMu/node096',
    'pages/syntheticMu/node097',
    'pages/syntheticMu/node098',
    'pages/syntheticMu/node099',
    'pages/syntheticMu/node100',
    'pages/syntheticMu/node101',
    'pages/syntheticMu/node102',
    'pages/syntheticMu/node103',
    'pages/syntheticMu/node104',
    'pages/syntheticMu/node105',
    'pages/syntheticMu/node106',
    'pages/syntheticMu/node107',
    'pages/syntheticMu/node108',
    'pages/syntheticMu/node109',
    'pages/syntheticMu/node110',
    'pages/syntheticMu/node111',
    'pages/syntheticMu/node112',
    'pages/syntheticMu/node113',
    'pages/syntheticMu/node114',
    'pages/syntheticMu/node115',
    'pages/syntheticMu/node116',
    'pages/syntheticMu/node117',
    'pages/syntheticMu/node118',
    'pages/syntheticMu/node119',
    'pages/syntheticMu/node120',
    'pages/syntheticMu/node121',
    'pages/syntheticMu/node122',
    'pages/syntheticMu/node123',
    'pages/syntheticMu/node124',
    'pages/syntheticMu/node125',
    'pages/syntheticMu/node126',
    'pages/syntheticMu/node127',
    'pages/syntheticMu/node128',
    'pages/syntheticMu/node129',
    'pages/syntheticMu/node130',
    'pages/syntheticMu/node131',
    'pages/syntheticMu/node132',
    'pages/syntheticMu/node133',
    'pages/syntheticMu/node134',
    'pages/syntheticMu/node135',
    'pages/syntheticMu/node136',
    'pages/syntheticMu/node137',
    'pages/syntheticMu/node138',
    'pages/syntheticMu/node139',
    'pages/syntheticMu/node140',
    'pages/syntheticMu/node141',
    'pages/syntheticMu/node142',
    'pages/syntheticMu/node143',
    'pages/syntheticMu/node144',
    'pages/syntheticMu/node145',
    'pages/syntheticMu/node146',
    'pages/syntheticMu/node147',
    'pages/syntheticMu/node148',
    'pages/syntheticMu/node149',
    'pages/syntheticMu/node150',
    'pages/syntheticMu/node151',
    'pages/syntheticMu/node152',
    'pages/syntheticMu/node153',
    'pages/syntheticMu/node154',
    'pages/syntheticMu/node155',
    'pages/syntheticMu/node156',
    'pages/syntheticMu/node157',
    'pages/syntheticMu/node158',
    'pages/syntheticMu/node159',
    'pages/syntheticMu/node160'
  ];

  describe('MegaSyntheticRouteAtlasMuSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteMu_[A-Za-z0-9_]+_[0-9]{3}$/;
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

