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
  return /^pages\/syntheticMariner\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasMarinerTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteMariner_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticMariner/node001',
    'pages/syntheticMariner/node002',
    'pages/syntheticMariner/node003',
    'pages/syntheticMariner/node004',
    'pages/syntheticMariner/node005',
    'pages/syntheticMariner/node006',
    'pages/syntheticMariner/node007',
    'pages/syntheticMariner/node008',
    'pages/syntheticMariner/node009',
    'pages/syntheticMariner/node010',
    'pages/syntheticMariner/node011',
    'pages/syntheticMariner/node012',
    'pages/syntheticMariner/node013',
    'pages/syntheticMariner/node014',
    'pages/syntheticMariner/node015',
    'pages/syntheticMariner/node016',
    'pages/syntheticMariner/node017',
    'pages/syntheticMariner/node018',
    'pages/syntheticMariner/node019',
    'pages/syntheticMariner/node020',
    'pages/syntheticMariner/node021',
    'pages/syntheticMariner/node022',
    'pages/syntheticMariner/node023',
    'pages/syntheticMariner/node024',
    'pages/syntheticMariner/node025',
    'pages/syntheticMariner/node026',
    'pages/syntheticMariner/node027',
    'pages/syntheticMariner/node028',
    'pages/syntheticMariner/node029',
    'pages/syntheticMariner/node030',
    'pages/syntheticMariner/node031',
    'pages/syntheticMariner/node032',
    'pages/syntheticMariner/node033',
    'pages/syntheticMariner/node034',
    'pages/syntheticMariner/node035',
    'pages/syntheticMariner/node036',
    'pages/syntheticMariner/node037',
    'pages/syntheticMariner/node038',
    'pages/syntheticMariner/node039',
    'pages/syntheticMariner/node040',
    'pages/syntheticMariner/node041',
    'pages/syntheticMariner/node042',
    'pages/syntheticMariner/node043',
    'pages/syntheticMariner/node044',
    'pages/syntheticMariner/node045',
    'pages/syntheticMariner/node046',
    'pages/syntheticMariner/node047',
    'pages/syntheticMariner/node048',
    'pages/syntheticMariner/node049',
    'pages/syntheticMariner/node050',
    'pages/syntheticMariner/node051',
    'pages/syntheticMariner/node052',
    'pages/syntheticMariner/node053',
    'pages/syntheticMariner/node054',
    'pages/syntheticMariner/node055',
    'pages/syntheticMariner/node056',
    'pages/syntheticMariner/node057',
    'pages/syntheticMariner/node058',
    'pages/syntheticMariner/node059',
    'pages/syntheticMariner/node060',
    'pages/syntheticMariner/node061',
    'pages/syntheticMariner/node062',
    'pages/syntheticMariner/node063',
    'pages/syntheticMariner/node064',
    'pages/syntheticMariner/node065',
    'pages/syntheticMariner/node066',
    'pages/syntheticMariner/node067',
    'pages/syntheticMariner/node068',
    'pages/syntheticMariner/node069',
    'pages/syntheticMariner/node070',
    'pages/syntheticMariner/node071',
    'pages/syntheticMariner/node072',
    'pages/syntheticMariner/node073',
    'pages/syntheticMariner/node074',
    'pages/syntheticMariner/node075',
    'pages/syntheticMariner/node076',
    'pages/syntheticMariner/node077',
    'pages/syntheticMariner/node078',
    'pages/syntheticMariner/node079',
    'pages/syntheticMariner/node080',
    'pages/syntheticMariner/node081',
    'pages/syntheticMariner/node082',
    'pages/syntheticMariner/node083',
    'pages/syntheticMariner/node084',
    'pages/syntheticMariner/node085',
    'pages/syntheticMariner/node086',
    'pages/syntheticMariner/node087',
    'pages/syntheticMariner/node088',
    'pages/syntheticMariner/node089',
    'pages/syntheticMariner/node090',
    'pages/syntheticMariner/node091',
    'pages/syntheticMariner/node092',
    'pages/syntheticMariner/node093',
    'pages/syntheticMariner/node094',
    'pages/syntheticMariner/node095',
    'pages/syntheticMariner/node096',
    'pages/syntheticMariner/node097',
    'pages/syntheticMariner/node098',
    'pages/syntheticMariner/node099',
    'pages/syntheticMariner/node100',
    'pages/syntheticMariner/node101',
    'pages/syntheticMariner/node102',
    'pages/syntheticMariner/node103',
    'pages/syntheticMariner/node104',
    'pages/syntheticMariner/node105',
    'pages/syntheticMariner/node106',
    'pages/syntheticMariner/node107',
    'pages/syntheticMariner/node108',
    'pages/syntheticMariner/node109',
    'pages/syntheticMariner/node110',
    'pages/syntheticMariner/node111',
    'pages/syntheticMariner/node112',
    'pages/syntheticMariner/node113',
    'pages/syntheticMariner/node114',
    'pages/syntheticMariner/node115',
    'pages/syntheticMariner/node116',
    'pages/syntheticMariner/node117',
    'pages/syntheticMariner/node118',
    'pages/syntheticMariner/node119',
    'pages/syntheticMariner/node120',
    'pages/syntheticMariner/node121',
    'pages/syntheticMariner/node122',
    'pages/syntheticMariner/node123',
    'pages/syntheticMariner/node124',
    'pages/syntheticMariner/node125',
    'pages/syntheticMariner/node126',
    'pages/syntheticMariner/node127',
    'pages/syntheticMariner/node128',
    'pages/syntheticMariner/node129',
    'pages/syntheticMariner/node130',
    'pages/syntheticMariner/node131',
    'pages/syntheticMariner/node132',
    'pages/syntheticMariner/node133',
    'pages/syntheticMariner/node134',
    'pages/syntheticMariner/node135',
    'pages/syntheticMariner/node136',
    'pages/syntheticMariner/node137',
    'pages/syntheticMariner/node138',
    'pages/syntheticMariner/node139',
    'pages/syntheticMariner/node140',
    'pages/syntheticMariner/node141',
    'pages/syntheticMariner/node142',
    'pages/syntheticMariner/node143',
    'pages/syntheticMariner/node144',
    'pages/syntheticMariner/node145',
    'pages/syntheticMariner/node146',
    'pages/syntheticMariner/node147',
    'pages/syntheticMariner/node148',
    'pages/syntheticMariner/node149',
    'pages/syntheticMariner/node150',
    'pages/syntheticMariner/node151',
    'pages/syntheticMariner/node152',
    'pages/syntheticMariner/node153',
    'pages/syntheticMariner/node154',
    'pages/syntheticMariner/node155',
    'pages/syntheticMariner/node156',
    'pages/syntheticMariner/node157',
    'pages/syntheticMariner/node158',
    'pages/syntheticMariner/node159',
    'pages/syntheticMariner/node160'
  ];

  describe('MegaSyntheticRouteAtlasMarinerSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteMariner_[A-Za-z0-9_]+_[0-9]{3}$/;
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

