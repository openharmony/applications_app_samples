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
  return /^pages\/syntheticZeta\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasZetaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteZeta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticZeta/node001',
    'pages/syntheticZeta/node002',
    'pages/syntheticZeta/node003',
    'pages/syntheticZeta/node004',
    'pages/syntheticZeta/node005',
    'pages/syntheticZeta/node006',
    'pages/syntheticZeta/node007',
    'pages/syntheticZeta/node008',
    'pages/syntheticZeta/node009',
    'pages/syntheticZeta/node010',
    'pages/syntheticZeta/node011',
    'pages/syntheticZeta/node012',
    'pages/syntheticZeta/node013',
    'pages/syntheticZeta/node014',
    'pages/syntheticZeta/node015',
    'pages/syntheticZeta/node016',
    'pages/syntheticZeta/node017',
    'pages/syntheticZeta/node018',
    'pages/syntheticZeta/node019',
    'pages/syntheticZeta/node020',
    'pages/syntheticZeta/node021',
    'pages/syntheticZeta/node022',
    'pages/syntheticZeta/node023',
    'pages/syntheticZeta/node024',
    'pages/syntheticZeta/node025',
    'pages/syntheticZeta/node026',
    'pages/syntheticZeta/node027',
    'pages/syntheticZeta/node028',
    'pages/syntheticZeta/node029',
    'pages/syntheticZeta/node030',
    'pages/syntheticZeta/node031',
    'pages/syntheticZeta/node032',
    'pages/syntheticZeta/node033',
    'pages/syntheticZeta/node034',
    'pages/syntheticZeta/node035',
    'pages/syntheticZeta/node036',
    'pages/syntheticZeta/node037',
    'pages/syntheticZeta/node038',
    'pages/syntheticZeta/node039',
    'pages/syntheticZeta/node040',
    'pages/syntheticZeta/node041',
    'pages/syntheticZeta/node042',
    'pages/syntheticZeta/node043',
    'pages/syntheticZeta/node044',
    'pages/syntheticZeta/node045',
    'pages/syntheticZeta/node046',
    'pages/syntheticZeta/node047',
    'pages/syntheticZeta/node048',
    'pages/syntheticZeta/node049',
    'pages/syntheticZeta/node050',
    'pages/syntheticZeta/node051',
    'pages/syntheticZeta/node052',
    'pages/syntheticZeta/node053',
    'pages/syntheticZeta/node054',
    'pages/syntheticZeta/node055',
    'pages/syntheticZeta/node056',
    'pages/syntheticZeta/node057',
    'pages/syntheticZeta/node058',
    'pages/syntheticZeta/node059',
    'pages/syntheticZeta/node060',
    'pages/syntheticZeta/node061',
    'pages/syntheticZeta/node062',
    'pages/syntheticZeta/node063',
    'pages/syntheticZeta/node064',
    'pages/syntheticZeta/node065',
    'pages/syntheticZeta/node066',
    'pages/syntheticZeta/node067',
    'pages/syntheticZeta/node068',
    'pages/syntheticZeta/node069',
    'pages/syntheticZeta/node070',
    'pages/syntheticZeta/node071',
    'pages/syntheticZeta/node072',
    'pages/syntheticZeta/node073',
    'pages/syntheticZeta/node074',
    'pages/syntheticZeta/node075',
    'pages/syntheticZeta/node076',
    'pages/syntheticZeta/node077',
    'pages/syntheticZeta/node078',
    'pages/syntheticZeta/node079',
    'pages/syntheticZeta/node080',
    'pages/syntheticZeta/node081',
    'pages/syntheticZeta/node082',
    'pages/syntheticZeta/node083',
    'pages/syntheticZeta/node084',
    'pages/syntheticZeta/node085',
    'pages/syntheticZeta/node086',
    'pages/syntheticZeta/node087',
    'pages/syntheticZeta/node088',
    'pages/syntheticZeta/node089',
    'pages/syntheticZeta/node090',
    'pages/syntheticZeta/node091',
    'pages/syntheticZeta/node092',
    'pages/syntheticZeta/node093',
    'pages/syntheticZeta/node094',
    'pages/syntheticZeta/node095',
    'pages/syntheticZeta/node096',
    'pages/syntheticZeta/node097',
    'pages/syntheticZeta/node098',
    'pages/syntheticZeta/node099',
    'pages/syntheticZeta/node100',
    'pages/syntheticZeta/node101',
    'pages/syntheticZeta/node102',
    'pages/syntheticZeta/node103',
    'pages/syntheticZeta/node104',
    'pages/syntheticZeta/node105',
    'pages/syntheticZeta/node106',
    'pages/syntheticZeta/node107',
    'pages/syntheticZeta/node108',
    'pages/syntheticZeta/node109',
    'pages/syntheticZeta/node110',
    'pages/syntheticZeta/node111',
    'pages/syntheticZeta/node112',
    'pages/syntheticZeta/node113',
    'pages/syntheticZeta/node114',
    'pages/syntheticZeta/node115',
    'pages/syntheticZeta/node116',
    'pages/syntheticZeta/node117',
    'pages/syntheticZeta/node118',
    'pages/syntheticZeta/node119',
    'pages/syntheticZeta/node120',
    'pages/syntheticZeta/node121',
    'pages/syntheticZeta/node122',
    'pages/syntheticZeta/node123',
    'pages/syntheticZeta/node124',
    'pages/syntheticZeta/node125',
    'pages/syntheticZeta/node126',
    'pages/syntheticZeta/node127',
    'pages/syntheticZeta/node128',
    'pages/syntheticZeta/node129',
    'pages/syntheticZeta/node130',
    'pages/syntheticZeta/node131',
    'pages/syntheticZeta/node132',
    'pages/syntheticZeta/node133',
    'pages/syntheticZeta/node134',
    'pages/syntheticZeta/node135',
    'pages/syntheticZeta/node136',
    'pages/syntheticZeta/node137',
    'pages/syntheticZeta/node138',
    'pages/syntheticZeta/node139',
    'pages/syntheticZeta/node140',
    'pages/syntheticZeta/node141',
    'pages/syntheticZeta/node142',
    'pages/syntheticZeta/node143',
    'pages/syntheticZeta/node144',
    'pages/syntheticZeta/node145',
    'pages/syntheticZeta/node146',
    'pages/syntheticZeta/node147',
    'pages/syntheticZeta/node148',
    'pages/syntheticZeta/node149',
    'pages/syntheticZeta/node150',
    'pages/syntheticZeta/node151',
    'pages/syntheticZeta/node152',
    'pages/syntheticZeta/node153',
    'pages/syntheticZeta/node154',
    'pages/syntheticZeta/node155',
    'pages/syntheticZeta/node156',
    'pages/syntheticZeta/node157',
    'pages/syntheticZeta/node158',
    'pages/syntheticZeta/node159',
    'pages/syntheticZeta/node160'
  ];

  describe('MegaSyntheticRouteAtlasZetaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteZeta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

