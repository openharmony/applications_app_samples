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
  return /^pages\/syntheticVanguard\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasVanguardTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteVanguard_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticVanguard/node001',
    'pages/syntheticVanguard/node002',
    'pages/syntheticVanguard/node003',
    'pages/syntheticVanguard/node004',
    'pages/syntheticVanguard/node005',
    'pages/syntheticVanguard/node006',
    'pages/syntheticVanguard/node007',
    'pages/syntheticVanguard/node008',
    'pages/syntheticVanguard/node009',
    'pages/syntheticVanguard/node010',
    'pages/syntheticVanguard/node011',
    'pages/syntheticVanguard/node012',
    'pages/syntheticVanguard/node013',
    'pages/syntheticVanguard/node014',
    'pages/syntheticVanguard/node015',
    'pages/syntheticVanguard/node016',
    'pages/syntheticVanguard/node017',
    'pages/syntheticVanguard/node018',
    'pages/syntheticVanguard/node019',
    'pages/syntheticVanguard/node020',
    'pages/syntheticVanguard/node021',
    'pages/syntheticVanguard/node022',
    'pages/syntheticVanguard/node023',
    'pages/syntheticVanguard/node024',
    'pages/syntheticVanguard/node025',
    'pages/syntheticVanguard/node026',
    'pages/syntheticVanguard/node027',
    'pages/syntheticVanguard/node028',
    'pages/syntheticVanguard/node029',
    'pages/syntheticVanguard/node030',
    'pages/syntheticVanguard/node031',
    'pages/syntheticVanguard/node032',
    'pages/syntheticVanguard/node033',
    'pages/syntheticVanguard/node034',
    'pages/syntheticVanguard/node035',
    'pages/syntheticVanguard/node036',
    'pages/syntheticVanguard/node037',
    'pages/syntheticVanguard/node038',
    'pages/syntheticVanguard/node039',
    'pages/syntheticVanguard/node040',
    'pages/syntheticVanguard/node041',
    'pages/syntheticVanguard/node042',
    'pages/syntheticVanguard/node043',
    'pages/syntheticVanguard/node044',
    'pages/syntheticVanguard/node045',
    'pages/syntheticVanguard/node046',
    'pages/syntheticVanguard/node047',
    'pages/syntheticVanguard/node048',
    'pages/syntheticVanguard/node049',
    'pages/syntheticVanguard/node050',
    'pages/syntheticVanguard/node051',
    'pages/syntheticVanguard/node052',
    'pages/syntheticVanguard/node053',
    'pages/syntheticVanguard/node054',
    'pages/syntheticVanguard/node055',
    'pages/syntheticVanguard/node056',
    'pages/syntheticVanguard/node057',
    'pages/syntheticVanguard/node058',
    'pages/syntheticVanguard/node059',
    'pages/syntheticVanguard/node060',
    'pages/syntheticVanguard/node061',
    'pages/syntheticVanguard/node062',
    'pages/syntheticVanguard/node063',
    'pages/syntheticVanguard/node064',
    'pages/syntheticVanguard/node065',
    'pages/syntheticVanguard/node066',
    'pages/syntheticVanguard/node067',
    'pages/syntheticVanguard/node068',
    'pages/syntheticVanguard/node069',
    'pages/syntheticVanguard/node070',
    'pages/syntheticVanguard/node071',
    'pages/syntheticVanguard/node072',
    'pages/syntheticVanguard/node073',
    'pages/syntheticVanguard/node074',
    'pages/syntheticVanguard/node075',
    'pages/syntheticVanguard/node076',
    'pages/syntheticVanguard/node077',
    'pages/syntheticVanguard/node078',
    'pages/syntheticVanguard/node079',
    'pages/syntheticVanguard/node080',
    'pages/syntheticVanguard/node081',
    'pages/syntheticVanguard/node082',
    'pages/syntheticVanguard/node083',
    'pages/syntheticVanguard/node084',
    'pages/syntheticVanguard/node085',
    'pages/syntheticVanguard/node086',
    'pages/syntheticVanguard/node087',
    'pages/syntheticVanguard/node088',
    'pages/syntheticVanguard/node089',
    'pages/syntheticVanguard/node090',
    'pages/syntheticVanguard/node091',
    'pages/syntheticVanguard/node092',
    'pages/syntheticVanguard/node093',
    'pages/syntheticVanguard/node094',
    'pages/syntheticVanguard/node095',
    'pages/syntheticVanguard/node096',
    'pages/syntheticVanguard/node097',
    'pages/syntheticVanguard/node098',
    'pages/syntheticVanguard/node099',
    'pages/syntheticVanguard/node100',
    'pages/syntheticVanguard/node101',
    'pages/syntheticVanguard/node102',
    'pages/syntheticVanguard/node103',
    'pages/syntheticVanguard/node104',
    'pages/syntheticVanguard/node105',
    'pages/syntheticVanguard/node106',
    'pages/syntheticVanguard/node107',
    'pages/syntheticVanguard/node108',
    'pages/syntheticVanguard/node109',
    'pages/syntheticVanguard/node110',
    'pages/syntheticVanguard/node111',
    'pages/syntheticVanguard/node112',
    'pages/syntheticVanguard/node113',
    'pages/syntheticVanguard/node114',
    'pages/syntheticVanguard/node115',
    'pages/syntheticVanguard/node116',
    'pages/syntheticVanguard/node117',
    'pages/syntheticVanguard/node118',
    'pages/syntheticVanguard/node119',
    'pages/syntheticVanguard/node120',
    'pages/syntheticVanguard/node121',
    'pages/syntheticVanguard/node122',
    'pages/syntheticVanguard/node123',
    'pages/syntheticVanguard/node124',
    'pages/syntheticVanguard/node125',
    'pages/syntheticVanguard/node126',
    'pages/syntheticVanguard/node127',
    'pages/syntheticVanguard/node128',
    'pages/syntheticVanguard/node129',
    'pages/syntheticVanguard/node130',
    'pages/syntheticVanguard/node131',
    'pages/syntheticVanguard/node132',
    'pages/syntheticVanguard/node133',
    'pages/syntheticVanguard/node134',
    'pages/syntheticVanguard/node135',
    'pages/syntheticVanguard/node136',
    'pages/syntheticVanguard/node137',
    'pages/syntheticVanguard/node138',
    'pages/syntheticVanguard/node139',
    'pages/syntheticVanguard/node140',
    'pages/syntheticVanguard/node141',
    'pages/syntheticVanguard/node142',
    'pages/syntheticVanguard/node143',
    'pages/syntheticVanguard/node144',
    'pages/syntheticVanguard/node145',
    'pages/syntheticVanguard/node146',
    'pages/syntheticVanguard/node147',
    'pages/syntheticVanguard/node148',
    'pages/syntheticVanguard/node149',
    'pages/syntheticVanguard/node150',
    'pages/syntheticVanguard/node151',
    'pages/syntheticVanguard/node152',
    'pages/syntheticVanguard/node153',
    'pages/syntheticVanguard/node154',
    'pages/syntheticVanguard/node155',
    'pages/syntheticVanguard/node156',
    'pages/syntheticVanguard/node157',
    'pages/syntheticVanguard/node158',
    'pages/syntheticVanguard/node159',
    'pages/syntheticVanguard/node160'
  ];

  describe('MegaSyntheticRouteAtlasVanguardSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteVanguard_[A-Za-z0-9_]+_[0-9]{3}$/;
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

