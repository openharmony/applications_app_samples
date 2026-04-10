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
  return /^pages\/syntheticSierra\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasSierraTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteSierra_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticSierra/node001',
    'pages/syntheticSierra/node002',
    'pages/syntheticSierra/node003',
    'pages/syntheticSierra/node004',
    'pages/syntheticSierra/node005',
    'pages/syntheticSierra/node006',
    'pages/syntheticSierra/node007',
    'pages/syntheticSierra/node008',
    'pages/syntheticSierra/node009',
    'pages/syntheticSierra/node010',
    'pages/syntheticSierra/node011',
    'pages/syntheticSierra/node012',
    'pages/syntheticSierra/node013',
    'pages/syntheticSierra/node014',
    'pages/syntheticSierra/node015',
    'pages/syntheticSierra/node016',
    'pages/syntheticSierra/node017',
    'pages/syntheticSierra/node018',
    'pages/syntheticSierra/node019',
    'pages/syntheticSierra/node020',
    'pages/syntheticSierra/node021',
    'pages/syntheticSierra/node022',
    'pages/syntheticSierra/node023',
    'pages/syntheticSierra/node024',
    'pages/syntheticSierra/node025',
    'pages/syntheticSierra/node026',
    'pages/syntheticSierra/node027',
    'pages/syntheticSierra/node028',
    'pages/syntheticSierra/node029',
    'pages/syntheticSierra/node030',
    'pages/syntheticSierra/node031',
    'pages/syntheticSierra/node032',
    'pages/syntheticSierra/node033',
    'pages/syntheticSierra/node034',
    'pages/syntheticSierra/node035',
    'pages/syntheticSierra/node036',
    'pages/syntheticSierra/node037',
    'pages/syntheticSierra/node038',
    'pages/syntheticSierra/node039',
    'pages/syntheticSierra/node040',
    'pages/syntheticSierra/node041',
    'pages/syntheticSierra/node042',
    'pages/syntheticSierra/node043',
    'pages/syntheticSierra/node044',
    'pages/syntheticSierra/node045',
    'pages/syntheticSierra/node046',
    'pages/syntheticSierra/node047',
    'pages/syntheticSierra/node048',
    'pages/syntheticSierra/node049',
    'pages/syntheticSierra/node050',
    'pages/syntheticSierra/node051',
    'pages/syntheticSierra/node052',
    'pages/syntheticSierra/node053',
    'pages/syntheticSierra/node054',
    'pages/syntheticSierra/node055',
    'pages/syntheticSierra/node056',
    'pages/syntheticSierra/node057',
    'pages/syntheticSierra/node058',
    'pages/syntheticSierra/node059',
    'pages/syntheticSierra/node060',
    'pages/syntheticSierra/node061',
    'pages/syntheticSierra/node062',
    'pages/syntheticSierra/node063',
    'pages/syntheticSierra/node064',
    'pages/syntheticSierra/node065',
    'pages/syntheticSierra/node066',
    'pages/syntheticSierra/node067',
    'pages/syntheticSierra/node068',
    'pages/syntheticSierra/node069',
    'pages/syntheticSierra/node070',
    'pages/syntheticSierra/node071',
    'pages/syntheticSierra/node072',
    'pages/syntheticSierra/node073',
    'pages/syntheticSierra/node074',
    'pages/syntheticSierra/node075',
    'pages/syntheticSierra/node076',
    'pages/syntheticSierra/node077',
    'pages/syntheticSierra/node078',
    'pages/syntheticSierra/node079',
    'pages/syntheticSierra/node080',
    'pages/syntheticSierra/node081',
    'pages/syntheticSierra/node082',
    'pages/syntheticSierra/node083',
    'pages/syntheticSierra/node084',
    'pages/syntheticSierra/node085',
    'pages/syntheticSierra/node086',
    'pages/syntheticSierra/node087',
    'pages/syntheticSierra/node088',
    'pages/syntheticSierra/node089',
    'pages/syntheticSierra/node090',
    'pages/syntheticSierra/node091',
    'pages/syntheticSierra/node092',
    'pages/syntheticSierra/node093',
    'pages/syntheticSierra/node094',
    'pages/syntheticSierra/node095',
    'pages/syntheticSierra/node096',
    'pages/syntheticSierra/node097',
    'pages/syntheticSierra/node098',
    'pages/syntheticSierra/node099',
    'pages/syntheticSierra/node100',
    'pages/syntheticSierra/node101',
    'pages/syntheticSierra/node102',
    'pages/syntheticSierra/node103',
    'pages/syntheticSierra/node104',
    'pages/syntheticSierra/node105',
    'pages/syntheticSierra/node106',
    'pages/syntheticSierra/node107',
    'pages/syntheticSierra/node108',
    'pages/syntheticSierra/node109',
    'pages/syntheticSierra/node110',
    'pages/syntheticSierra/node111',
    'pages/syntheticSierra/node112',
    'pages/syntheticSierra/node113',
    'pages/syntheticSierra/node114',
    'pages/syntheticSierra/node115',
    'pages/syntheticSierra/node116',
    'pages/syntheticSierra/node117',
    'pages/syntheticSierra/node118',
    'pages/syntheticSierra/node119',
    'pages/syntheticSierra/node120',
    'pages/syntheticSierra/node121',
    'pages/syntheticSierra/node122',
    'pages/syntheticSierra/node123',
    'pages/syntheticSierra/node124',
    'pages/syntheticSierra/node125',
    'pages/syntheticSierra/node126',
    'pages/syntheticSierra/node127',
    'pages/syntheticSierra/node128',
    'pages/syntheticSierra/node129',
    'pages/syntheticSierra/node130',
    'pages/syntheticSierra/node131',
    'pages/syntheticSierra/node132',
    'pages/syntheticSierra/node133',
    'pages/syntheticSierra/node134',
    'pages/syntheticSierra/node135',
    'pages/syntheticSierra/node136',
    'pages/syntheticSierra/node137',
    'pages/syntheticSierra/node138',
    'pages/syntheticSierra/node139',
    'pages/syntheticSierra/node140',
    'pages/syntheticSierra/node141',
    'pages/syntheticSierra/node142',
    'pages/syntheticSierra/node143',
    'pages/syntheticSierra/node144',
    'pages/syntheticSierra/node145',
    'pages/syntheticSierra/node146',
    'pages/syntheticSierra/node147',
    'pages/syntheticSierra/node148',
    'pages/syntheticSierra/node149',
    'pages/syntheticSierra/node150',
    'pages/syntheticSierra/node151',
    'pages/syntheticSierra/node152',
    'pages/syntheticSierra/node153',
    'pages/syntheticSierra/node154',
    'pages/syntheticSierra/node155',
    'pages/syntheticSierra/node156',
    'pages/syntheticSierra/node157',
    'pages/syntheticSierra/node158',
    'pages/syntheticSierra/node159',
    'pages/syntheticSierra/node160'
  ];

  describe('MegaSyntheticRouteAtlasSierraSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteSierra_[A-Za-z0-9_]+_[0-9]{3}$/;
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