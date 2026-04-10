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
  return /^pages\/syntheticStellar\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasStellarTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteStellar_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticStellar/node001',
    'pages/syntheticStellar/node002',
    'pages/syntheticStellar/node003',
    'pages/syntheticStellar/node004',
    'pages/syntheticStellar/node005',
    'pages/syntheticStellar/node006',
    'pages/syntheticStellar/node007',
    'pages/syntheticStellar/node008',
    'pages/syntheticStellar/node009',
    'pages/syntheticStellar/node010',
    'pages/syntheticStellar/node011',
    'pages/syntheticStellar/node012',
    'pages/syntheticStellar/node013',
    'pages/syntheticStellar/node014',
    'pages/syntheticStellar/node015',
    'pages/syntheticStellar/node016',
    'pages/syntheticStellar/node017',
    'pages/syntheticStellar/node018',
    'pages/syntheticStellar/node019',
    'pages/syntheticStellar/node020',
    'pages/syntheticStellar/node021',
    'pages/syntheticStellar/node022',
    'pages/syntheticStellar/node023',
    'pages/syntheticStellar/node024',
    'pages/syntheticStellar/node025',
    'pages/syntheticStellar/node026',
    'pages/syntheticStellar/node027',
    'pages/syntheticStellar/node028',
    'pages/syntheticStellar/node029',
    'pages/syntheticStellar/node030',
    'pages/syntheticStellar/node031',
    'pages/syntheticStellar/node032',
    'pages/syntheticStellar/node033',
    'pages/syntheticStellar/node034',
    'pages/syntheticStellar/node035',
    'pages/syntheticStellar/node036',
    'pages/syntheticStellar/node037',
    'pages/syntheticStellar/node038',
    'pages/syntheticStellar/node039',
    'pages/syntheticStellar/node040',
    'pages/syntheticStellar/node041',
    'pages/syntheticStellar/node042',
    'pages/syntheticStellar/node043',
    'pages/syntheticStellar/node044',
    'pages/syntheticStellar/node045',
    'pages/syntheticStellar/node046',
    'pages/syntheticStellar/node047',
    'pages/syntheticStellar/node048',
    'pages/syntheticStellar/node049',
    'pages/syntheticStellar/node050',
    'pages/syntheticStellar/node051',
    'pages/syntheticStellar/node052',
    'pages/syntheticStellar/node053',
    'pages/syntheticStellar/node054',
    'pages/syntheticStellar/node055',
    'pages/syntheticStellar/node056',
    'pages/syntheticStellar/node057',
    'pages/syntheticStellar/node058',
    'pages/syntheticStellar/node059',
    'pages/syntheticStellar/node060',
    'pages/syntheticStellar/node061',
    'pages/syntheticStellar/node062',
    'pages/syntheticStellar/node063',
    'pages/syntheticStellar/node064',
    'pages/syntheticStellar/node065',
    'pages/syntheticStellar/node066',
    'pages/syntheticStellar/node067',
    'pages/syntheticStellar/node068',
    'pages/syntheticStellar/node069',
    'pages/syntheticStellar/node070',
    'pages/syntheticStellar/node071',
    'pages/syntheticStellar/node072',
    'pages/syntheticStellar/node073',
    'pages/syntheticStellar/node074',
    'pages/syntheticStellar/node075',
    'pages/syntheticStellar/node076',
    'pages/syntheticStellar/node077',
    'pages/syntheticStellar/node078',
    'pages/syntheticStellar/node079',
    'pages/syntheticStellar/node080',
    'pages/syntheticStellar/node081',
    'pages/syntheticStellar/node082',
    'pages/syntheticStellar/node083',
    'pages/syntheticStellar/node084',
    'pages/syntheticStellar/node085',
    'pages/syntheticStellar/node086',
    'pages/syntheticStellar/node087',
    'pages/syntheticStellar/node088',
    'pages/syntheticStellar/node089',
    'pages/syntheticStellar/node090',
    'pages/syntheticStellar/node091',
    'pages/syntheticStellar/node092',
    'pages/syntheticStellar/node093',
    'pages/syntheticStellar/node094',
    'pages/syntheticStellar/node095',
    'pages/syntheticStellar/node096',
    'pages/syntheticStellar/node097',
    'pages/syntheticStellar/node098',
    'pages/syntheticStellar/node099',
    'pages/syntheticStellar/node100',
    'pages/syntheticStellar/node101',
    'pages/syntheticStellar/node102',
    'pages/syntheticStellar/node103',
    'pages/syntheticStellar/node104',
    'pages/syntheticStellar/node105',
    'pages/syntheticStellar/node106',
    'pages/syntheticStellar/node107',
    'pages/syntheticStellar/node108',
    'pages/syntheticStellar/node109',
    'pages/syntheticStellar/node110',
    'pages/syntheticStellar/node111',
    'pages/syntheticStellar/node112',
    'pages/syntheticStellar/node113',
    'pages/syntheticStellar/node114',
    'pages/syntheticStellar/node115',
    'pages/syntheticStellar/node116',
    'pages/syntheticStellar/node117',
    'pages/syntheticStellar/node118',
    'pages/syntheticStellar/node119',
    'pages/syntheticStellar/node120',
    'pages/syntheticStellar/node121',
    'pages/syntheticStellar/node122',
    'pages/syntheticStellar/node123',
    'pages/syntheticStellar/node124',
    'pages/syntheticStellar/node125',
    'pages/syntheticStellar/node126',
    'pages/syntheticStellar/node127',
    'pages/syntheticStellar/node128',
    'pages/syntheticStellar/node129',
    'pages/syntheticStellar/node130',
    'pages/syntheticStellar/node131',
    'pages/syntheticStellar/node132',
    'pages/syntheticStellar/node133',
    'pages/syntheticStellar/node134',
    'pages/syntheticStellar/node135',
    'pages/syntheticStellar/node136',
    'pages/syntheticStellar/node137',
    'pages/syntheticStellar/node138',
    'pages/syntheticStellar/node139',
    'pages/syntheticStellar/node140',
    'pages/syntheticStellar/node141',
    'pages/syntheticStellar/node142',
    'pages/syntheticStellar/node143',
    'pages/syntheticStellar/node144',
    'pages/syntheticStellar/node145',
    'pages/syntheticStellar/node146',
    'pages/syntheticStellar/node147',
    'pages/syntheticStellar/node148',
    'pages/syntheticStellar/node149',
    'pages/syntheticStellar/node150',
    'pages/syntheticStellar/node151',
    'pages/syntheticStellar/node152',
    'pages/syntheticStellar/node153',
    'pages/syntheticStellar/node154',
    'pages/syntheticStellar/node155',
    'pages/syntheticStellar/node156',
    'pages/syntheticStellar/node157',
    'pages/syntheticStellar/node158',
    'pages/syntheticStellar/node159',
    'pages/syntheticStellar/node160'
  ];

  describe('MegaSyntheticRouteAtlasStellarSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteStellar_[A-Za-z0-9_]+_[0-9]{3}$/;
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