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
  return /^pages\/syntheticYukon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasYukonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteYukon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticYukon/node001',
    'pages/syntheticYukon/node002',
    'pages/syntheticYukon/node003',
    'pages/syntheticYukon/node004',
    'pages/syntheticYukon/node005',
    'pages/syntheticYukon/node006',
    'pages/syntheticYukon/node007',
    'pages/syntheticYukon/node008',
    'pages/syntheticYukon/node009',
    'pages/syntheticYukon/node010',
    'pages/syntheticYukon/node011',
    'pages/syntheticYukon/node012',
    'pages/syntheticYukon/node013',
    'pages/syntheticYukon/node014',
    'pages/syntheticYukon/node015',
    'pages/syntheticYukon/node016',
    'pages/syntheticYukon/node017',
    'pages/syntheticYukon/node018',
    'pages/syntheticYukon/node019',
    'pages/syntheticYukon/node020',
    'pages/syntheticYukon/node021',
    'pages/syntheticYukon/node022',
    'pages/syntheticYukon/node023',
    'pages/syntheticYukon/node024',
    'pages/syntheticYukon/node025',
    'pages/syntheticYukon/node026',
    'pages/syntheticYukon/node027',
    'pages/syntheticYukon/node028',
    'pages/syntheticYukon/node029',
    'pages/syntheticYukon/node030',
    'pages/syntheticYukon/node031',
    'pages/syntheticYukon/node032',
    'pages/syntheticYukon/node033',
    'pages/syntheticYukon/node034',
    'pages/syntheticYukon/node035',
    'pages/syntheticYukon/node036',
    'pages/syntheticYukon/node037',
    'pages/syntheticYukon/node038',
    'pages/syntheticYukon/node039',
    'pages/syntheticYukon/node040',
    'pages/syntheticYukon/node041',
    'pages/syntheticYukon/node042',
    'pages/syntheticYukon/node043',
    'pages/syntheticYukon/node044',
    'pages/syntheticYukon/node045',
    'pages/syntheticYukon/node046',
    'pages/syntheticYukon/node047',
    'pages/syntheticYukon/node048',
    'pages/syntheticYukon/node049',
    'pages/syntheticYukon/node050',
    'pages/syntheticYukon/node051',
    'pages/syntheticYukon/node052',
    'pages/syntheticYukon/node053',
    'pages/syntheticYukon/node054',
    'pages/syntheticYukon/node055',
    'pages/syntheticYukon/node056',
    'pages/syntheticYukon/node057',
    'pages/syntheticYukon/node058',
    'pages/syntheticYukon/node059',
    'pages/syntheticYukon/node060',
    'pages/syntheticYukon/node061',
    'pages/syntheticYukon/node062',
    'pages/syntheticYukon/node063',
    'pages/syntheticYukon/node064',
    'pages/syntheticYukon/node065',
    'pages/syntheticYukon/node066',
    'pages/syntheticYukon/node067',
    'pages/syntheticYukon/node068',
    'pages/syntheticYukon/node069',
    'pages/syntheticYukon/node070',
    'pages/syntheticYukon/node071',
    'pages/syntheticYukon/node072',
    'pages/syntheticYukon/node073',
    'pages/syntheticYukon/node074',
    'pages/syntheticYukon/node075',
    'pages/syntheticYukon/node076',
    'pages/syntheticYukon/node077',
    'pages/syntheticYukon/node078',
    'pages/syntheticYukon/node079',
    'pages/syntheticYukon/node080',
    'pages/syntheticYukon/node081',
    'pages/syntheticYukon/node082',
    'pages/syntheticYukon/node083',
    'pages/syntheticYukon/node084',
    'pages/syntheticYukon/node085',
    'pages/syntheticYukon/node086',
    'pages/syntheticYukon/node087',
    'pages/syntheticYukon/node088',
    'pages/syntheticYukon/node089',
    'pages/syntheticYukon/node090',
    'pages/syntheticYukon/node091',
    'pages/syntheticYukon/node092',
    'pages/syntheticYukon/node093',
    'pages/syntheticYukon/node094',
    'pages/syntheticYukon/node095',
    'pages/syntheticYukon/node096',
    'pages/syntheticYukon/node097',
    'pages/syntheticYukon/node098',
    'pages/syntheticYukon/node099',
    'pages/syntheticYukon/node100',
    'pages/syntheticYukon/node101',
    'pages/syntheticYukon/node102',
    'pages/syntheticYukon/node103',
    'pages/syntheticYukon/node104',
    'pages/syntheticYukon/node105',
    'pages/syntheticYukon/node106',
    'pages/syntheticYukon/node107',
    'pages/syntheticYukon/node108',
    'pages/syntheticYukon/node109',
    'pages/syntheticYukon/node110',
    'pages/syntheticYukon/node111',
    'pages/syntheticYukon/node112',
    'pages/syntheticYukon/node113',
    'pages/syntheticYukon/node114',
    'pages/syntheticYukon/node115',
    'pages/syntheticYukon/node116',
    'pages/syntheticYukon/node117',
    'pages/syntheticYukon/node118',
    'pages/syntheticYukon/node119',
    'pages/syntheticYukon/node120',
    'pages/syntheticYukon/node121',
    'pages/syntheticYukon/node122',
    'pages/syntheticYukon/node123',
    'pages/syntheticYukon/node124',
    'pages/syntheticYukon/node125',
    'pages/syntheticYukon/node126',
    'pages/syntheticYukon/node127',
    'pages/syntheticYukon/node128',
    'pages/syntheticYukon/node129',
    'pages/syntheticYukon/node130',
    'pages/syntheticYukon/node131',
    'pages/syntheticYukon/node132',
    'pages/syntheticYukon/node133',
    'pages/syntheticYukon/node134',
    'pages/syntheticYukon/node135',
    'pages/syntheticYukon/node136',
    'pages/syntheticYukon/node137',
    'pages/syntheticYukon/node138',
    'pages/syntheticYukon/node139',
    'pages/syntheticYukon/node140',
    'pages/syntheticYukon/node141',
    'pages/syntheticYukon/node142',
    'pages/syntheticYukon/node143',
    'pages/syntheticYukon/node144',
    'pages/syntheticYukon/node145',
    'pages/syntheticYukon/node146',
    'pages/syntheticYukon/node147',
    'pages/syntheticYukon/node148',
    'pages/syntheticYukon/node149',
    'pages/syntheticYukon/node150',
    'pages/syntheticYukon/node151',
    'pages/syntheticYukon/node152',
    'pages/syntheticYukon/node153',
    'pages/syntheticYukon/node154',
    'pages/syntheticYukon/node155',
    'pages/syntheticYukon/node156',
    'pages/syntheticYukon/node157',
    'pages/syntheticYukon/node158',
    'pages/syntheticYukon/node159',
    'pages/syntheticYukon/node160'
  ];

  describe('MegaSyntheticRouteAtlasYukonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteYukon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

