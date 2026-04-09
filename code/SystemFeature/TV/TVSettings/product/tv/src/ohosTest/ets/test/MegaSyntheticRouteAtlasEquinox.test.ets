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
  return /^pages\/syntheticEquinox\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasEquinoxTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteEquinox_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticEquinox/node001',
    'pages/syntheticEquinox/node002',
    'pages/syntheticEquinox/node003',
    'pages/syntheticEquinox/node004',
    'pages/syntheticEquinox/node005',
    'pages/syntheticEquinox/node006',
    'pages/syntheticEquinox/node007',
    'pages/syntheticEquinox/node008',
    'pages/syntheticEquinox/node009',
    'pages/syntheticEquinox/node010',
    'pages/syntheticEquinox/node011',
    'pages/syntheticEquinox/node012',
    'pages/syntheticEquinox/node013',
    'pages/syntheticEquinox/node014',
    'pages/syntheticEquinox/node015',
    'pages/syntheticEquinox/node016',
    'pages/syntheticEquinox/node017',
    'pages/syntheticEquinox/node018',
    'pages/syntheticEquinox/node019',
    'pages/syntheticEquinox/node020',
    'pages/syntheticEquinox/node021',
    'pages/syntheticEquinox/node022',
    'pages/syntheticEquinox/node023',
    'pages/syntheticEquinox/node024',
    'pages/syntheticEquinox/node025',
    'pages/syntheticEquinox/node026',
    'pages/syntheticEquinox/node027',
    'pages/syntheticEquinox/node028',
    'pages/syntheticEquinox/node029',
    'pages/syntheticEquinox/node030',
    'pages/syntheticEquinox/node031',
    'pages/syntheticEquinox/node032',
    'pages/syntheticEquinox/node033',
    'pages/syntheticEquinox/node034',
    'pages/syntheticEquinox/node035',
    'pages/syntheticEquinox/node036',
    'pages/syntheticEquinox/node037',
    'pages/syntheticEquinox/node038',
    'pages/syntheticEquinox/node039',
    'pages/syntheticEquinox/node040',
    'pages/syntheticEquinox/node041',
    'pages/syntheticEquinox/node042',
    'pages/syntheticEquinox/node043',
    'pages/syntheticEquinox/node044',
    'pages/syntheticEquinox/node045',
    'pages/syntheticEquinox/node046',
    'pages/syntheticEquinox/node047',
    'pages/syntheticEquinox/node048',
    'pages/syntheticEquinox/node049',
    'pages/syntheticEquinox/node050',
    'pages/syntheticEquinox/node051',
    'pages/syntheticEquinox/node052',
    'pages/syntheticEquinox/node053',
    'pages/syntheticEquinox/node054',
    'pages/syntheticEquinox/node055',
    'pages/syntheticEquinox/node056',
    'pages/syntheticEquinox/node057',
    'pages/syntheticEquinox/node058',
    'pages/syntheticEquinox/node059',
    'pages/syntheticEquinox/node060',
    'pages/syntheticEquinox/node061',
    'pages/syntheticEquinox/node062',
    'pages/syntheticEquinox/node063',
    'pages/syntheticEquinox/node064',
    'pages/syntheticEquinox/node065',
    'pages/syntheticEquinox/node066',
    'pages/syntheticEquinox/node067',
    'pages/syntheticEquinox/node068',
    'pages/syntheticEquinox/node069',
    'pages/syntheticEquinox/node070',
    'pages/syntheticEquinox/node071',
    'pages/syntheticEquinox/node072',
    'pages/syntheticEquinox/node073',
    'pages/syntheticEquinox/node074',
    'pages/syntheticEquinox/node075',
    'pages/syntheticEquinox/node076',
    'pages/syntheticEquinox/node077',
    'pages/syntheticEquinox/node078',
    'pages/syntheticEquinox/node079',
    'pages/syntheticEquinox/node080',
    'pages/syntheticEquinox/node081',
    'pages/syntheticEquinox/node082',
    'pages/syntheticEquinox/node083',
    'pages/syntheticEquinox/node084',
    'pages/syntheticEquinox/node085',
    'pages/syntheticEquinox/node086',
    'pages/syntheticEquinox/node087',
    'pages/syntheticEquinox/node088',
    'pages/syntheticEquinox/node089',
    'pages/syntheticEquinox/node090',
    'pages/syntheticEquinox/node091',
    'pages/syntheticEquinox/node092',
    'pages/syntheticEquinox/node093',
    'pages/syntheticEquinox/node094',
    'pages/syntheticEquinox/node095',
    'pages/syntheticEquinox/node096',
    'pages/syntheticEquinox/node097',
    'pages/syntheticEquinox/node098',
    'pages/syntheticEquinox/node099',
    'pages/syntheticEquinox/node100',
    'pages/syntheticEquinox/node101',
    'pages/syntheticEquinox/node102',
    'pages/syntheticEquinox/node103',
    'pages/syntheticEquinox/node104',
    'pages/syntheticEquinox/node105',
    'pages/syntheticEquinox/node106',
    'pages/syntheticEquinox/node107',
    'pages/syntheticEquinox/node108',
    'pages/syntheticEquinox/node109',
    'pages/syntheticEquinox/node110',
    'pages/syntheticEquinox/node111',
    'pages/syntheticEquinox/node112',
    'pages/syntheticEquinox/node113',
    'pages/syntheticEquinox/node114',
    'pages/syntheticEquinox/node115',
    'pages/syntheticEquinox/node116',
    'pages/syntheticEquinox/node117',
    'pages/syntheticEquinox/node118',
    'pages/syntheticEquinox/node119',
    'pages/syntheticEquinox/node120',
    'pages/syntheticEquinox/node121',
    'pages/syntheticEquinox/node122',
    'pages/syntheticEquinox/node123',
    'pages/syntheticEquinox/node124',
    'pages/syntheticEquinox/node125',
    'pages/syntheticEquinox/node126',
    'pages/syntheticEquinox/node127',
    'pages/syntheticEquinox/node128',
    'pages/syntheticEquinox/node129',
    'pages/syntheticEquinox/node130',
    'pages/syntheticEquinox/node131',
    'pages/syntheticEquinox/node132',
    'pages/syntheticEquinox/node133',
    'pages/syntheticEquinox/node134',
    'pages/syntheticEquinox/node135',
    'pages/syntheticEquinox/node136',
    'pages/syntheticEquinox/node137',
    'pages/syntheticEquinox/node138',
    'pages/syntheticEquinox/node139',
    'pages/syntheticEquinox/node140',
    'pages/syntheticEquinox/node141',
    'pages/syntheticEquinox/node142',
    'pages/syntheticEquinox/node143',
    'pages/syntheticEquinox/node144',
    'pages/syntheticEquinox/node145',
    'pages/syntheticEquinox/node146',
    'pages/syntheticEquinox/node147',
    'pages/syntheticEquinox/node148',
    'pages/syntheticEquinox/node149',
    'pages/syntheticEquinox/node150',
    'pages/syntheticEquinox/node151',
    'pages/syntheticEquinox/node152',
    'pages/syntheticEquinox/node153',
    'pages/syntheticEquinox/node154',
    'pages/syntheticEquinox/node155',
    'pages/syntheticEquinox/node156',
    'pages/syntheticEquinox/node157',
    'pages/syntheticEquinox/node158',
    'pages/syntheticEquinox/node159',
    'pages/syntheticEquinox/node160'
  ];

  describe('MegaSyntheticRouteAtlasEquinoxSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteEquinox_[A-Za-z0-9_]+_[0-9]{3}$/;
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

