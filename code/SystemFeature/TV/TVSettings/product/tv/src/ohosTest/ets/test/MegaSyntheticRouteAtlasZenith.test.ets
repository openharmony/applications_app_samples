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
  return /^pages\/syntheticZenith\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasZenithTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteZenith_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticZenith/node001',
    'pages/syntheticZenith/node002',
    'pages/syntheticZenith/node003',
    'pages/syntheticZenith/node004',
    'pages/syntheticZenith/node005',
    'pages/syntheticZenith/node006',
    'pages/syntheticZenith/node007',
    'pages/syntheticZenith/node008',
    'pages/syntheticZenith/node009',
    'pages/syntheticZenith/node010',
    'pages/syntheticZenith/node011',
    'pages/syntheticZenith/node012',
    'pages/syntheticZenith/node013',
    'pages/syntheticZenith/node014',
    'pages/syntheticZenith/node015',
    'pages/syntheticZenith/node016',
    'pages/syntheticZenith/node017',
    'pages/syntheticZenith/node018',
    'pages/syntheticZenith/node019',
    'pages/syntheticZenith/node020',
    'pages/syntheticZenith/node021',
    'pages/syntheticZenith/node022',
    'pages/syntheticZenith/node023',
    'pages/syntheticZenith/node024',
    'pages/syntheticZenith/node025',
    'pages/syntheticZenith/node026',
    'pages/syntheticZenith/node027',
    'pages/syntheticZenith/node028',
    'pages/syntheticZenith/node029',
    'pages/syntheticZenith/node030',
    'pages/syntheticZenith/node031',
    'pages/syntheticZenith/node032',
    'pages/syntheticZenith/node033',
    'pages/syntheticZenith/node034',
    'pages/syntheticZenith/node035',
    'pages/syntheticZenith/node036',
    'pages/syntheticZenith/node037',
    'pages/syntheticZenith/node038',
    'pages/syntheticZenith/node039',
    'pages/syntheticZenith/node040',
    'pages/syntheticZenith/node041',
    'pages/syntheticZenith/node042',
    'pages/syntheticZenith/node043',
    'pages/syntheticZenith/node044',
    'pages/syntheticZenith/node045',
    'pages/syntheticZenith/node046',
    'pages/syntheticZenith/node047',
    'pages/syntheticZenith/node048',
    'pages/syntheticZenith/node049',
    'pages/syntheticZenith/node050',
    'pages/syntheticZenith/node051',
    'pages/syntheticZenith/node052',
    'pages/syntheticZenith/node053',
    'pages/syntheticZenith/node054',
    'pages/syntheticZenith/node055',
    'pages/syntheticZenith/node056',
    'pages/syntheticZenith/node057',
    'pages/syntheticZenith/node058',
    'pages/syntheticZenith/node059',
    'pages/syntheticZenith/node060',
    'pages/syntheticZenith/node061',
    'pages/syntheticZenith/node062',
    'pages/syntheticZenith/node063',
    'pages/syntheticZenith/node064',
    'pages/syntheticZenith/node065',
    'pages/syntheticZenith/node066',
    'pages/syntheticZenith/node067',
    'pages/syntheticZenith/node068',
    'pages/syntheticZenith/node069',
    'pages/syntheticZenith/node070',
    'pages/syntheticZenith/node071',
    'pages/syntheticZenith/node072',
    'pages/syntheticZenith/node073',
    'pages/syntheticZenith/node074',
    'pages/syntheticZenith/node075',
    'pages/syntheticZenith/node076',
    'pages/syntheticZenith/node077',
    'pages/syntheticZenith/node078',
    'pages/syntheticZenith/node079',
    'pages/syntheticZenith/node080',
    'pages/syntheticZenith/node081',
    'pages/syntheticZenith/node082',
    'pages/syntheticZenith/node083',
    'pages/syntheticZenith/node084',
    'pages/syntheticZenith/node085',
    'pages/syntheticZenith/node086',
    'pages/syntheticZenith/node087',
    'pages/syntheticZenith/node088',
    'pages/syntheticZenith/node089',
    'pages/syntheticZenith/node090',
    'pages/syntheticZenith/node091',
    'pages/syntheticZenith/node092',
    'pages/syntheticZenith/node093',
    'pages/syntheticZenith/node094',
    'pages/syntheticZenith/node095',
    'pages/syntheticZenith/node096',
    'pages/syntheticZenith/node097',
    'pages/syntheticZenith/node098',
    'pages/syntheticZenith/node099',
    'pages/syntheticZenith/node100',
    'pages/syntheticZenith/node101',
    'pages/syntheticZenith/node102',
    'pages/syntheticZenith/node103',
    'pages/syntheticZenith/node104',
    'pages/syntheticZenith/node105',
    'pages/syntheticZenith/node106',
    'pages/syntheticZenith/node107',
    'pages/syntheticZenith/node108',
    'pages/syntheticZenith/node109',
    'pages/syntheticZenith/node110',
    'pages/syntheticZenith/node111',
    'pages/syntheticZenith/node112',
    'pages/syntheticZenith/node113',
    'pages/syntheticZenith/node114',
    'pages/syntheticZenith/node115',
    'pages/syntheticZenith/node116',
    'pages/syntheticZenith/node117',
    'pages/syntheticZenith/node118',
    'pages/syntheticZenith/node119',
    'pages/syntheticZenith/node120',
    'pages/syntheticZenith/node121',
    'pages/syntheticZenith/node122',
    'pages/syntheticZenith/node123',
    'pages/syntheticZenith/node124',
    'pages/syntheticZenith/node125',
    'pages/syntheticZenith/node126',
    'pages/syntheticZenith/node127',
    'pages/syntheticZenith/node128',
    'pages/syntheticZenith/node129',
    'pages/syntheticZenith/node130',
    'pages/syntheticZenith/node131',
    'pages/syntheticZenith/node132',
    'pages/syntheticZenith/node133',
    'pages/syntheticZenith/node134',
    'pages/syntheticZenith/node135',
    'pages/syntheticZenith/node136',
    'pages/syntheticZenith/node137',
    'pages/syntheticZenith/node138',
    'pages/syntheticZenith/node139',
    'pages/syntheticZenith/node140',
    'pages/syntheticZenith/node141',
    'pages/syntheticZenith/node142',
    'pages/syntheticZenith/node143',
    'pages/syntheticZenith/node144',
    'pages/syntheticZenith/node145',
    'pages/syntheticZenith/node146',
    'pages/syntheticZenith/node147',
    'pages/syntheticZenith/node148',
    'pages/syntheticZenith/node149',
    'pages/syntheticZenith/node150',
    'pages/syntheticZenith/node151',
    'pages/syntheticZenith/node152',
    'pages/syntheticZenith/node153',
    'pages/syntheticZenith/node154',
    'pages/syntheticZenith/node155',
    'pages/syntheticZenith/node156',
    'pages/syntheticZenith/node157',
    'pages/syntheticZenith/node158',
    'pages/syntheticZenith/node159',
    'pages/syntheticZenith/node160'
  ];

  describe('MegaSyntheticRouteAtlasZenithSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteZenith_[A-Za-z0-9_]+_[0-9]{3}$/;
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

