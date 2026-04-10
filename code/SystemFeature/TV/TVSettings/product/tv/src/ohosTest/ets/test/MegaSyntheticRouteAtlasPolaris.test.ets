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
  return /^pages\/syntheticPolaris\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasPolarisTest() {
  const casePrefix = 'Settings_MegaSyntheticRoutePolaris_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticPolaris/node001',
    'pages/syntheticPolaris/node002',
    'pages/syntheticPolaris/node003',
    'pages/syntheticPolaris/node004',
    'pages/syntheticPolaris/node005',
    'pages/syntheticPolaris/node006',
    'pages/syntheticPolaris/node007',
    'pages/syntheticPolaris/node008',
    'pages/syntheticPolaris/node009',
    'pages/syntheticPolaris/node010',
    'pages/syntheticPolaris/node011',
    'pages/syntheticPolaris/node012',
    'pages/syntheticPolaris/node013',
    'pages/syntheticPolaris/node014',
    'pages/syntheticPolaris/node015',
    'pages/syntheticPolaris/node016',
    'pages/syntheticPolaris/node017',
    'pages/syntheticPolaris/node018',
    'pages/syntheticPolaris/node019',
    'pages/syntheticPolaris/node020',
    'pages/syntheticPolaris/node021',
    'pages/syntheticPolaris/node022',
    'pages/syntheticPolaris/node023',
    'pages/syntheticPolaris/node024',
    'pages/syntheticPolaris/node025',
    'pages/syntheticPolaris/node026',
    'pages/syntheticPolaris/node027',
    'pages/syntheticPolaris/node028',
    'pages/syntheticPolaris/node029',
    'pages/syntheticPolaris/node030',
    'pages/syntheticPolaris/node031',
    'pages/syntheticPolaris/node032',
    'pages/syntheticPolaris/node033',
    'pages/syntheticPolaris/node034',
    'pages/syntheticPolaris/node035',
    'pages/syntheticPolaris/node036',
    'pages/syntheticPolaris/node037',
    'pages/syntheticPolaris/node038',
    'pages/syntheticPolaris/node039',
    'pages/syntheticPolaris/node040',
    'pages/syntheticPolaris/node041',
    'pages/syntheticPolaris/node042',
    'pages/syntheticPolaris/node043',
    'pages/syntheticPolaris/node044',
    'pages/syntheticPolaris/node045',
    'pages/syntheticPolaris/node046',
    'pages/syntheticPolaris/node047',
    'pages/syntheticPolaris/node048',
    'pages/syntheticPolaris/node049',
    'pages/syntheticPolaris/node050',
    'pages/syntheticPolaris/node051',
    'pages/syntheticPolaris/node052',
    'pages/syntheticPolaris/node053',
    'pages/syntheticPolaris/node054',
    'pages/syntheticPolaris/node055',
    'pages/syntheticPolaris/node056',
    'pages/syntheticPolaris/node057',
    'pages/syntheticPolaris/node058',
    'pages/syntheticPolaris/node059',
    'pages/syntheticPolaris/node060',
    'pages/syntheticPolaris/node061',
    'pages/syntheticPolaris/node062',
    'pages/syntheticPolaris/node063',
    'pages/syntheticPolaris/node064',
    'pages/syntheticPolaris/node065',
    'pages/syntheticPolaris/node066',
    'pages/syntheticPolaris/node067',
    'pages/syntheticPolaris/node068',
    'pages/syntheticPolaris/node069',
    'pages/syntheticPolaris/node070',
    'pages/syntheticPolaris/node071',
    'pages/syntheticPolaris/node072',
    'pages/syntheticPolaris/node073',
    'pages/syntheticPolaris/node074',
    'pages/syntheticPolaris/node075',
    'pages/syntheticPolaris/node076',
    'pages/syntheticPolaris/node077',
    'pages/syntheticPolaris/node078',
    'pages/syntheticPolaris/node079',
    'pages/syntheticPolaris/node080',
    'pages/syntheticPolaris/node081',
    'pages/syntheticPolaris/node082',
    'pages/syntheticPolaris/node083',
    'pages/syntheticPolaris/node084',
    'pages/syntheticPolaris/node085',
    'pages/syntheticPolaris/node086',
    'pages/syntheticPolaris/node087',
    'pages/syntheticPolaris/node088',
    'pages/syntheticPolaris/node089',
    'pages/syntheticPolaris/node090',
    'pages/syntheticPolaris/node091',
    'pages/syntheticPolaris/node092',
    'pages/syntheticPolaris/node093',
    'pages/syntheticPolaris/node094',
    'pages/syntheticPolaris/node095',
    'pages/syntheticPolaris/node096',
    'pages/syntheticPolaris/node097',
    'pages/syntheticPolaris/node098',
    'pages/syntheticPolaris/node099',
    'pages/syntheticPolaris/node100',
    'pages/syntheticPolaris/node101',
    'pages/syntheticPolaris/node102',
    'pages/syntheticPolaris/node103',
    'pages/syntheticPolaris/node104',
    'pages/syntheticPolaris/node105',
    'pages/syntheticPolaris/node106',
    'pages/syntheticPolaris/node107',
    'pages/syntheticPolaris/node108',
    'pages/syntheticPolaris/node109',
    'pages/syntheticPolaris/node110',
    'pages/syntheticPolaris/node111',
    'pages/syntheticPolaris/node112',
    'pages/syntheticPolaris/node113',
    'pages/syntheticPolaris/node114',
    'pages/syntheticPolaris/node115',
    'pages/syntheticPolaris/node116',
    'pages/syntheticPolaris/node117',
    'pages/syntheticPolaris/node118',
    'pages/syntheticPolaris/node119',
    'pages/syntheticPolaris/node120',
    'pages/syntheticPolaris/node121',
    'pages/syntheticPolaris/node122',
    'pages/syntheticPolaris/node123',
    'pages/syntheticPolaris/node124',
    'pages/syntheticPolaris/node125',
    'pages/syntheticPolaris/node126',
    'pages/syntheticPolaris/node127',
    'pages/syntheticPolaris/node128',
    'pages/syntheticPolaris/node129',
    'pages/syntheticPolaris/node130',
    'pages/syntheticPolaris/node131',
    'pages/syntheticPolaris/node132',
    'pages/syntheticPolaris/node133',
    'pages/syntheticPolaris/node134',
    'pages/syntheticPolaris/node135',
    'pages/syntheticPolaris/node136',
    'pages/syntheticPolaris/node137',
    'pages/syntheticPolaris/node138',
    'pages/syntheticPolaris/node139',
    'pages/syntheticPolaris/node140',
    'pages/syntheticPolaris/node141',
    'pages/syntheticPolaris/node142',
    'pages/syntheticPolaris/node143',
    'pages/syntheticPolaris/node144',
    'pages/syntheticPolaris/node145',
    'pages/syntheticPolaris/node146',
    'pages/syntheticPolaris/node147',
    'pages/syntheticPolaris/node148',
    'pages/syntheticPolaris/node149',
    'pages/syntheticPolaris/node150',
    'pages/syntheticPolaris/node151',
    'pages/syntheticPolaris/node152',
    'pages/syntheticPolaris/node153',
    'pages/syntheticPolaris/node154',
    'pages/syntheticPolaris/node155',
    'pages/syntheticPolaris/node156',
    'pages/syntheticPolaris/node157',
    'pages/syntheticPolaris/node158',
    'pages/syntheticPolaris/node159',
    'pages/syntheticPolaris/node160'
  ];

  describe('MegaSyntheticRouteAtlasPolarisSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRoutePolaris_[A-Za-z0-9_]+_[0-9]{3}$/;
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

