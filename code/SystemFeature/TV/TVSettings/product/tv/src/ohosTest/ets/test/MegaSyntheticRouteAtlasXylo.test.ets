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
  return /^pages\/syntheticXylo\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasXyloTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteXylo_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticXylo/node001',
    'pages/syntheticXylo/node002',
    'pages/syntheticXylo/node003',
    'pages/syntheticXylo/node004',
    'pages/syntheticXylo/node005',
    'pages/syntheticXylo/node006',
    'pages/syntheticXylo/node007',
    'pages/syntheticXylo/node008',
    'pages/syntheticXylo/node009',
    'pages/syntheticXylo/node010',
    'pages/syntheticXylo/node011',
    'pages/syntheticXylo/node012',
    'pages/syntheticXylo/node013',
    'pages/syntheticXylo/node014',
    'pages/syntheticXylo/node015',
    'pages/syntheticXylo/node016',
    'pages/syntheticXylo/node017',
    'pages/syntheticXylo/node018',
    'pages/syntheticXylo/node019',
    'pages/syntheticXylo/node020',
    'pages/syntheticXylo/node021',
    'pages/syntheticXylo/node022',
    'pages/syntheticXylo/node023',
    'pages/syntheticXylo/node024',
    'pages/syntheticXylo/node025',
    'pages/syntheticXylo/node026',
    'pages/syntheticXylo/node027',
    'pages/syntheticXylo/node028',
    'pages/syntheticXylo/node029',
    'pages/syntheticXylo/node030',
    'pages/syntheticXylo/node031',
    'pages/syntheticXylo/node032',
    'pages/syntheticXylo/node033',
    'pages/syntheticXylo/node034',
    'pages/syntheticXylo/node035',
    'pages/syntheticXylo/node036',
    'pages/syntheticXylo/node037',
    'pages/syntheticXylo/node038',
    'pages/syntheticXylo/node039',
    'pages/syntheticXylo/node040',
    'pages/syntheticXylo/node041',
    'pages/syntheticXylo/node042',
    'pages/syntheticXylo/node043',
    'pages/syntheticXylo/node044',
    'pages/syntheticXylo/node045',
    'pages/syntheticXylo/node046',
    'pages/syntheticXylo/node047',
    'pages/syntheticXylo/node048',
    'pages/syntheticXylo/node049',
    'pages/syntheticXylo/node050',
    'pages/syntheticXylo/node051',
    'pages/syntheticXylo/node052',
    'pages/syntheticXylo/node053',
    'pages/syntheticXylo/node054',
    'pages/syntheticXylo/node055',
    'pages/syntheticXylo/node056',
    'pages/syntheticXylo/node057',
    'pages/syntheticXylo/node058',
    'pages/syntheticXylo/node059',
    'pages/syntheticXylo/node060',
    'pages/syntheticXylo/node061',
    'pages/syntheticXylo/node062',
    'pages/syntheticXylo/node063',
    'pages/syntheticXylo/node064',
    'pages/syntheticXylo/node065',
    'pages/syntheticXylo/node066',
    'pages/syntheticXylo/node067',
    'pages/syntheticXylo/node068',
    'pages/syntheticXylo/node069',
    'pages/syntheticXylo/node070',
    'pages/syntheticXylo/node071',
    'pages/syntheticXylo/node072',
    'pages/syntheticXylo/node073',
    'pages/syntheticXylo/node074',
    'pages/syntheticXylo/node075',
    'pages/syntheticXylo/node076',
    'pages/syntheticXylo/node077',
    'pages/syntheticXylo/node078',
    'pages/syntheticXylo/node079',
    'pages/syntheticXylo/node080',
    'pages/syntheticXylo/node081',
    'pages/syntheticXylo/node082',
    'pages/syntheticXylo/node083',
    'pages/syntheticXylo/node084',
    'pages/syntheticXylo/node085',
    'pages/syntheticXylo/node086',
    'pages/syntheticXylo/node087',
    'pages/syntheticXylo/node088',
    'pages/syntheticXylo/node089',
    'pages/syntheticXylo/node090',
    'pages/syntheticXylo/node091',
    'pages/syntheticXylo/node092',
    'pages/syntheticXylo/node093',
    'pages/syntheticXylo/node094',
    'pages/syntheticXylo/node095',
    'pages/syntheticXylo/node096',
    'pages/syntheticXylo/node097',
    'pages/syntheticXylo/node098',
    'pages/syntheticXylo/node099',
    'pages/syntheticXylo/node100',
    'pages/syntheticXylo/node101',
    'pages/syntheticXylo/node102',
    'pages/syntheticXylo/node103',
    'pages/syntheticXylo/node104',
    'pages/syntheticXylo/node105',
    'pages/syntheticXylo/node106',
    'pages/syntheticXylo/node107',
    'pages/syntheticXylo/node108',
    'pages/syntheticXylo/node109',
    'pages/syntheticXylo/node110',
    'pages/syntheticXylo/node111',
    'pages/syntheticXylo/node112',
    'pages/syntheticXylo/node113',
    'pages/syntheticXylo/node114',
    'pages/syntheticXylo/node115',
    'pages/syntheticXylo/node116',
    'pages/syntheticXylo/node117',
    'pages/syntheticXylo/node118',
    'pages/syntheticXylo/node119',
    'pages/syntheticXylo/node120',
    'pages/syntheticXylo/node121',
    'pages/syntheticXylo/node122',
    'pages/syntheticXylo/node123',
    'pages/syntheticXylo/node124',
    'pages/syntheticXylo/node125',
    'pages/syntheticXylo/node126',
    'pages/syntheticXylo/node127',
    'pages/syntheticXylo/node128',
    'pages/syntheticXylo/node129',
    'pages/syntheticXylo/node130',
    'pages/syntheticXylo/node131',
    'pages/syntheticXylo/node132',
    'pages/syntheticXylo/node133',
    'pages/syntheticXylo/node134',
    'pages/syntheticXylo/node135',
    'pages/syntheticXylo/node136',
    'pages/syntheticXylo/node137',
    'pages/syntheticXylo/node138',
    'pages/syntheticXylo/node139',
    'pages/syntheticXylo/node140',
    'pages/syntheticXylo/node141',
    'pages/syntheticXylo/node142',
    'pages/syntheticXylo/node143',
    'pages/syntheticXylo/node144',
    'pages/syntheticXylo/node145',
    'pages/syntheticXylo/node146',
    'pages/syntheticXylo/node147',
    'pages/syntheticXylo/node148',
    'pages/syntheticXylo/node149',
    'pages/syntheticXylo/node150',
    'pages/syntheticXylo/node151',
    'pages/syntheticXylo/node152',
    'pages/syntheticXylo/node153',
    'pages/syntheticXylo/node154',
    'pages/syntheticXylo/node155',
    'pages/syntheticXylo/node156',
    'pages/syntheticXylo/node157',
    'pages/syntheticXylo/node158',
    'pages/syntheticXylo/node159',
    'pages/syntheticXylo/node160'
  ];

  describe('MegaSyntheticRouteAtlasXyloSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteXylo_[A-Za-z0-9_]+_[0-9]{3}$/;
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

