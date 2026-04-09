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
  return /^pages\/syntheticVertex\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasVertexTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteVertex_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticVertex/node001',
    'pages/syntheticVertex/node002',
    'pages/syntheticVertex/node003',
    'pages/syntheticVertex/node004',
    'pages/syntheticVertex/node005',
    'pages/syntheticVertex/node006',
    'pages/syntheticVertex/node007',
    'pages/syntheticVertex/node008',
    'pages/syntheticVertex/node009',
    'pages/syntheticVertex/node010',
    'pages/syntheticVertex/node011',
    'pages/syntheticVertex/node012',
    'pages/syntheticVertex/node013',
    'pages/syntheticVertex/node014',
    'pages/syntheticVertex/node015',
    'pages/syntheticVertex/node016',
    'pages/syntheticVertex/node017',
    'pages/syntheticVertex/node018',
    'pages/syntheticVertex/node019',
    'pages/syntheticVertex/node020',
    'pages/syntheticVertex/node021',
    'pages/syntheticVertex/node022',
    'pages/syntheticVertex/node023',
    'pages/syntheticVertex/node024',
    'pages/syntheticVertex/node025',
    'pages/syntheticVertex/node026',
    'pages/syntheticVertex/node027',
    'pages/syntheticVertex/node028',
    'pages/syntheticVertex/node029',
    'pages/syntheticVertex/node030',
    'pages/syntheticVertex/node031',
    'pages/syntheticVertex/node032',
    'pages/syntheticVertex/node033',
    'pages/syntheticVertex/node034',
    'pages/syntheticVertex/node035',
    'pages/syntheticVertex/node036',
    'pages/syntheticVertex/node037',
    'pages/syntheticVertex/node038',
    'pages/syntheticVertex/node039',
    'pages/syntheticVertex/node040',
    'pages/syntheticVertex/node041',
    'pages/syntheticVertex/node042',
    'pages/syntheticVertex/node043',
    'pages/syntheticVertex/node044',
    'pages/syntheticVertex/node045',
    'pages/syntheticVertex/node046',
    'pages/syntheticVertex/node047',
    'pages/syntheticVertex/node048',
    'pages/syntheticVertex/node049',
    'pages/syntheticVertex/node050',
    'pages/syntheticVertex/node051',
    'pages/syntheticVertex/node052',
    'pages/syntheticVertex/node053',
    'pages/syntheticVertex/node054',
    'pages/syntheticVertex/node055',
    'pages/syntheticVertex/node056',
    'pages/syntheticVertex/node057',
    'pages/syntheticVertex/node058',
    'pages/syntheticVertex/node059',
    'pages/syntheticVertex/node060',
    'pages/syntheticVertex/node061',
    'pages/syntheticVertex/node062',
    'pages/syntheticVertex/node063',
    'pages/syntheticVertex/node064',
    'pages/syntheticVertex/node065',
    'pages/syntheticVertex/node066',
    'pages/syntheticVertex/node067',
    'pages/syntheticVertex/node068',
    'pages/syntheticVertex/node069',
    'pages/syntheticVertex/node070',
    'pages/syntheticVertex/node071',
    'pages/syntheticVertex/node072',
    'pages/syntheticVertex/node073',
    'pages/syntheticVertex/node074',
    'pages/syntheticVertex/node075',
    'pages/syntheticVertex/node076',
    'pages/syntheticVertex/node077',
    'pages/syntheticVertex/node078',
    'pages/syntheticVertex/node079',
    'pages/syntheticVertex/node080',
    'pages/syntheticVertex/node081',
    'pages/syntheticVertex/node082',
    'pages/syntheticVertex/node083',
    'pages/syntheticVertex/node084',
    'pages/syntheticVertex/node085',
    'pages/syntheticVertex/node086',
    'pages/syntheticVertex/node087',
    'pages/syntheticVertex/node088',
    'pages/syntheticVertex/node089',
    'pages/syntheticVertex/node090',
    'pages/syntheticVertex/node091',
    'pages/syntheticVertex/node092',
    'pages/syntheticVertex/node093',
    'pages/syntheticVertex/node094',
    'pages/syntheticVertex/node095',
    'pages/syntheticVertex/node096',
    'pages/syntheticVertex/node097',
    'pages/syntheticVertex/node098',
    'pages/syntheticVertex/node099',
    'pages/syntheticVertex/node100',
    'pages/syntheticVertex/node101',
    'pages/syntheticVertex/node102',
    'pages/syntheticVertex/node103',
    'pages/syntheticVertex/node104',
    'pages/syntheticVertex/node105',
    'pages/syntheticVertex/node106',
    'pages/syntheticVertex/node107',
    'pages/syntheticVertex/node108',
    'pages/syntheticVertex/node109',
    'pages/syntheticVertex/node110',
    'pages/syntheticVertex/node111',
    'pages/syntheticVertex/node112',
    'pages/syntheticVertex/node113',
    'pages/syntheticVertex/node114',
    'pages/syntheticVertex/node115',
    'pages/syntheticVertex/node116',
    'pages/syntheticVertex/node117',
    'pages/syntheticVertex/node118',
    'pages/syntheticVertex/node119',
    'pages/syntheticVertex/node120',
    'pages/syntheticVertex/node121',
    'pages/syntheticVertex/node122',
    'pages/syntheticVertex/node123',
    'pages/syntheticVertex/node124',
    'pages/syntheticVertex/node125',
    'pages/syntheticVertex/node126',
    'pages/syntheticVertex/node127',
    'pages/syntheticVertex/node128',
    'pages/syntheticVertex/node129',
    'pages/syntheticVertex/node130',
    'pages/syntheticVertex/node131',
    'pages/syntheticVertex/node132',
    'pages/syntheticVertex/node133',
    'pages/syntheticVertex/node134',
    'pages/syntheticVertex/node135',
    'pages/syntheticVertex/node136',
    'pages/syntheticVertex/node137',
    'pages/syntheticVertex/node138',
    'pages/syntheticVertex/node139',
    'pages/syntheticVertex/node140',
    'pages/syntheticVertex/node141',
    'pages/syntheticVertex/node142',
    'pages/syntheticVertex/node143',
    'pages/syntheticVertex/node144',
    'pages/syntheticVertex/node145',
    'pages/syntheticVertex/node146',
    'pages/syntheticVertex/node147',
    'pages/syntheticVertex/node148',
    'pages/syntheticVertex/node149',
    'pages/syntheticVertex/node150',
    'pages/syntheticVertex/node151',
    'pages/syntheticVertex/node152',
    'pages/syntheticVertex/node153',
    'pages/syntheticVertex/node154',
    'pages/syntheticVertex/node155',
    'pages/syntheticVertex/node156',
    'pages/syntheticVertex/node157',
    'pages/syntheticVertex/node158',
    'pages/syntheticVertex/node159',
    'pages/syntheticVertex/node160'
  ];

  describe('MegaSyntheticRouteAtlasVertexSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteVertex_[A-Za-z0-9_]+_[0-9]{3}$/;
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

