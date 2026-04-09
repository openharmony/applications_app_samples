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
  return /^pages\/syntheticWarp\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasWarpTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteWarp_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticWarp/node001',
    'pages/syntheticWarp/node002',
    'pages/syntheticWarp/node003',
    'pages/syntheticWarp/node004',
    'pages/syntheticWarp/node005',
    'pages/syntheticWarp/node006',
    'pages/syntheticWarp/node007',
    'pages/syntheticWarp/node008',
    'pages/syntheticWarp/node009',
    'pages/syntheticWarp/node010',
    'pages/syntheticWarp/node011',
    'pages/syntheticWarp/node012',
    'pages/syntheticWarp/node013',
    'pages/syntheticWarp/node014',
    'pages/syntheticWarp/node015',
    'pages/syntheticWarp/node016',
    'pages/syntheticWarp/node017',
    'pages/syntheticWarp/node018',
    'pages/syntheticWarp/node019',
    'pages/syntheticWarp/node020',
    'pages/syntheticWarp/node021',
    'pages/syntheticWarp/node022',
    'pages/syntheticWarp/node023',
    'pages/syntheticWarp/node024',
    'pages/syntheticWarp/node025',
    'pages/syntheticWarp/node026',
    'pages/syntheticWarp/node027',
    'pages/syntheticWarp/node028',
    'pages/syntheticWarp/node029',
    'pages/syntheticWarp/node030',
    'pages/syntheticWarp/node031',
    'pages/syntheticWarp/node032',
    'pages/syntheticWarp/node033',
    'pages/syntheticWarp/node034',
    'pages/syntheticWarp/node035',
    'pages/syntheticWarp/node036',
    'pages/syntheticWarp/node037',
    'pages/syntheticWarp/node038',
    'pages/syntheticWarp/node039',
    'pages/syntheticWarp/node040',
    'pages/syntheticWarp/node041',
    'pages/syntheticWarp/node042',
    'pages/syntheticWarp/node043',
    'pages/syntheticWarp/node044',
    'pages/syntheticWarp/node045',
    'pages/syntheticWarp/node046',
    'pages/syntheticWarp/node047',
    'pages/syntheticWarp/node048',
    'pages/syntheticWarp/node049',
    'pages/syntheticWarp/node050',
    'pages/syntheticWarp/node051',
    'pages/syntheticWarp/node052',
    'pages/syntheticWarp/node053',
    'pages/syntheticWarp/node054',
    'pages/syntheticWarp/node055',
    'pages/syntheticWarp/node056',
    'pages/syntheticWarp/node057',
    'pages/syntheticWarp/node058',
    'pages/syntheticWarp/node059',
    'pages/syntheticWarp/node060',
    'pages/syntheticWarp/node061',
    'pages/syntheticWarp/node062',
    'pages/syntheticWarp/node063',
    'pages/syntheticWarp/node064',
    'pages/syntheticWarp/node065',
    'pages/syntheticWarp/node066',
    'pages/syntheticWarp/node067',
    'pages/syntheticWarp/node068',
    'pages/syntheticWarp/node069',
    'pages/syntheticWarp/node070',
    'pages/syntheticWarp/node071',
    'pages/syntheticWarp/node072',
    'pages/syntheticWarp/node073',
    'pages/syntheticWarp/node074',
    'pages/syntheticWarp/node075',
    'pages/syntheticWarp/node076',
    'pages/syntheticWarp/node077',
    'pages/syntheticWarp/node078',
    'pages/syntheticWarp/node079',
    'pages/syntheticWarp/node080',
    'pages/syntheticWarp/node081',
    'pages/syntheticWarp/node082',
    'pages/syntheticWarp/node083',
    'pages/syntheticWarp/node084',
    'pages/syntheticWarp/node085',
    'pages/syntheticWarp/node086',
    'pages/syntheticWarp/node087',
    'pages/syntheticWarp/node088',
    'pages/syntheticWarp/node089',
    'pages/syntheticWarp/node090',
    'pages/syntheticWarp/node091',
    'pages/syntheticWarp/node092',
    'pages/syntheticWarp/node093',
    'pages/syntheticWarp/node094',
    'pages/syntheticWarp/node095',
    'pages/syntheticWarp/node096',
    'pages/syntheticWarp/node097',
    'pages/syntheticWarp/node098',
    'pages/syntheticWarp/node099',
    'pages/syntheticWarp/node100',
    'pages/syntheticWarp/node101',
    'pages/syntheticWarp/node102',
    'pages/syntheticWarp/node103',
    'pages/syntheticWarp/node104',
    'pages/syntheticWarp/node105',
    'pages/syntheticWarp/node106',
    'pages/syntheticWarp/node107',
    'pages/syntheticWarp/node108',
    'pages/syntheticWarp/node109',
    'pages/syntheticWarp/node110',
    'pages/syntheticWarp/node111',
    'pages/syntheticWarp/node112',
    'pages/syntheticWarp/node113',
    'pages/syntheticWarp/node114',
    'pages/syntheticWarp/node115',
    'pages/syntheticWarp/node116',
    'pages/syntheticWarp/node117',
    'pages/syntheticWarp/node118',
    'pages/syntheticWarp/node119',
    'pages/syntheticWarp/node120',
    'pages/syntheticWarp/node121',
    'pages/syntheticWarp/node122',
    'pages/syntheticWarp/node123',
    'pages/syntheticWarp/node124',
    'pages/syntheticWarp/node125',
    'pages/syntheticWarp/node126',
    'pages/syntheticWarp/node127',
    'pages/syntheticWarp/node128',
    'pages/syntheticWarp/node129',
    'pages/syntheticWarp/node130',
    'pages/syntheticWarp/node131',
    'pages/syntheticWarp/node132',
    'pages/syntheticWarp/node133',
    'pages/syntheticWarp/node134',
    'pages/syntheticWarp/node135',
    'pages/syntheticWarp/node136',
    'pages/syntheticWarp/node137',
    'pages/syntheticWarp/node138',
    'pages/syntheticWarp/node139',
    'pages/syntheticWarp/node140',
    'pages/syntheticWarp/node141',
    'pages/syntheticWarp/node142',
    'pages/syntheticWarp/node143',
    'pages/syntheticWarp/node144',
    'pages/syntheticWarp/node145',
    'pages/syntheticWarp/node146',
    'pages/syntheticWarp/node147',
    'pages/syntheticWarp/node148',
    'pages/syntheticWarp/node149',
    'pages/syntheticWarp/node150',
    'pages/syntheticWarp/node151',
    'pages/syntheticWarp/node152',
    'pages/syntheticWarp/node153',
    'pages/syntheticWarp/node154',
    'pages/syntheticWarp/node155',
    'pages/syntheticWarp/node156',
    'pages/syntheticWarp/node157',
    'pages/syntheticWarp/node158',
    'pages/syntheticWarp/node159',
    'pages/syntheticWarp/node160'
  ];

  describe('MegaSyntheticRouteAtlasWarpSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteWarp_[A-Za-z0-9_]+_[0-9]{3}$/;
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

