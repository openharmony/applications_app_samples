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
  return /^pages\/syntheticVortex\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasVortexTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteVortex_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticVortex/node001',
    'pages/syntheticVortex/node002',
    'pages/syntheticVortex/node003',
    'pages/syntheticVortex/node004',
    'pages/syntheticVortex/node005',
    'pages/syntheticVortex/node006',
    'pages/syntheticVortex/node007',
    'pages/syntheticVortex/node008',
    'pages/syntheticVortex/node009',
    'pages/syntheticVortex/node010',
    'pages/syntheticVortex/node011',
    'pages/syntheticVortex/node012',
    'pages/syntheticVortex/node013',
    'pages/syntheticVortex/node014',
    'pages/syntheticVortex/node015',
    'pages/syntheticVortex/node016',
    'pages/syntheticVortex/node017',
    'pages/syntheticVortex/node018',
    'pages/syntheticVortex/node019',
    'pages/syntheticVortex/node020',
    'pages/syntheticVortex/node021',
    'pages/syntheticVortex/node022',
    'pages/syntheticVortex/node023',
    'pages/syntheticVortex/node024',
    'pages/syntheticVortex/node025',
    'pages/syntheticVortex/node026',
    'pages/syntheticVortex/node027',
    'pages/syntheticVortex/node028',
    'pages/syntheticVortex/node029',
    'pages/syntheticVortex/node030',
    'pages/syntheticVortex/node031',
    'pages/syntheticVortex/node032',
    'pages/syntheticVortex/node033',
    'pages/syntheticVortex/node034',
    'pages/syntheticVortex/node035',
    'pages/syntheticVortex/node036',
    'pages/syntheticVortex/node037',
    'pages/syntheticVortex/node038',
    'pages/syntheticVortex/node039',
    'pages/syntheticVortex/node040',
    'pages/syntheticVortex/node041',
    'pages/syntheticVortex/node042',
    'pages/syntheticVortex/node043',
    'pages/syntheticVortex/node044',
    'pages/syntheticVortex/node045',
    'pages/syntheticVortex/node046',
    'pages/syntheticVortex/node047',
    'pages/syntheticVortex/node048',
    'pages/syntheticVortex/node049',
    'pages/syntheticVortex/node050',
    'pages/syntheticVortex/node051',
    'pages/syntheticVortex/node052',
    'pages/syntheticVortex/node053',
    'pages/syntheticVortex/node054',
    'pages/syntheticVortex/node055',
    'pages/syntheticVortex/node056',
    'pages/syntheticVortex/node057',
    'pages/syntheticVortex/node058',
    'pages/syntheticVortex/node059',
    'pages/syntheticVortex/node060',
    'pages/syntheticVortex/node061',
    'pages/syntheticVortex/node062',
    'pages/syntheticVortex/node063',
    'pages/syntheticVortex/node064',
    'pages/syntheticVortex/node065',
    'pages/syntheticVortex/node066',
    'pages/syntheticVortex/node067',
    'pages/syntheticVortex/node068',
    'pages/syntheticVortex/node069',
    'pages/syntheticVortex/node070',
    'pages/syntheticVortex/node071',
    'pages/syntheticVortex/node072',
    'pages/syntheticVortex/node073',
    'pages/syntheticVortex/node074',
    'pages/syntheticVortex/node075',
    'pages/syntheticVortex/node076',
    'pages/syntheticVortex/node077',
    'pages/syntheticVortex/node078',
    'pages/syntheticVortex/node079',
    'pages/syntheticVortex/node080',
    'pages/syntheticVortex/node081',
    'pages/syntheticVortex/node082',
    'pages/syntheticVortex/node083',
    'pages/syntheticVortex/node084',
    'pages/syntheticVortex/node085',
    'pages/syntheticVortex/node086',
    'pages/syntheticVortex/node087',
    'pages/syntheticVortex/node088',
    'pages/syntheticVortex/node089',
    'pages/syntheticVortex/node090',
    'pages/syntheticVortex/node091',
    'pages/syntheticVortex/node092',
    'pages/syntheticVortex/node093',
    'pages/syntheticVortex/node094',
    'pages/syntheticVortex/node095',
    'pages/syntheticVortex/node096',
    'pages/syntheticVortex/node097',
    'pages/syntheticVortex/node098',
    'pages/syntheticVortex/node099',
    'pages/syntheticVortex/node100',
    'pages/syntheticVortex/node101',
    'pages/syntheticVortex/node102',
    'pages/syntheticVortex/node103',
    'pages/syntheticVortex/node104',
    'pages/syntheticVortex/node105',
    'pages/syntheticVortex/node106',
    'pages/syntheticVortex/node107',
    'pages/syntheticVortex/node108',
    'pages/syntheticVortex/node109',
    'pages/syntheticVortex/node110',
    'pages/syntheticVortex/node111',
    'pages/syntheticVortex/node112',
    'pages/syntheticVortex/node113',
    'pages/syntheticVortex/node114',
    'pages/syntheticVortex/node115',
    'pages/syntheticVortex/node116',
    'pages/syntheticVortex/node117',
    'pages/syntheticVortex/node118',
    'pages/syntheticVortex/node119',
    'pages/syntheticVortex/node120',
    'pages/syntheticVortex/node121',
    'pages/syntheticVortex/node122',
    'pages/syntheticVortex/node123',
    'pages/syntheticVortex/node124',
    'pages/syntheticVortex/node125',
    'pages/syntheticVortex/node126',
    'pages/syntheticVortex/node127',
    'pages/syntheticVortex/node128',
    'pages/syntheticVortex/node129',
    'pages/syntheticVortex/node130',
    'pages/syntheticVortex/node131',
    'pages/syntheticVortex/node132',
    'pages/syntheticVortex/node133',
    'pages/syntheticVortex/node134',
    'pages/syntheticVortex/node135',
    'pages/syntheticVortex/node136',
    'pages/syntheticVortex/node137',
    'pages/syntheticVortex/node138',
    'pages/syntheticVortex/node139',
    'pages/syntheticVortex/node140',
    'pages/syntheticVortex/node141',
    'pages/syntheticVortex/node142',
    'pages/syntheticVortex/node143',
    'pages/syntheticVortex/node144',
    'pages/syntheticVortex/node145',
    'pages/syntheticVortex/node146',
    'pages/syntheticVortex/node147',
    'pages/syntheticVortex/node148',
    'pages/syntheticVortex/node149',
    'pages/syntheticVortex/node150',
    'pages/syntheticVortex/node151',
    'pages/syntheticVortex/node152',
    'pages/syntheticVortex/node153',
    'pages/syntheticVortex/node154',
    'pages/syntheticVortex/node155',
    'pages/syntheticVortex/node156',
    'pages/syntheticVortex/node157',
    'pages/syntheticVortex/node158',
    'pages/syntheticVortex/node159',
    'pages/syntheticVortex/node160'
  ];

  describe('MegaSyntheticRouteAtlasVortexSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteVortex_[A-Za-z0-9_]+_[0-9]{3}$/;
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

