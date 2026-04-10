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
  return /^pages\/syntheticFusion\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasFusionTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteFusion_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticFusion/node001',
    'pages/syntheticFusion/node002',
    'pages/syntheticFusion/node003',
    'pages/syntheticFusion/node004',
    'pages/syntheticFusion/node005',
    'pages/syntheticFusion/node006',
    'pages/syntheticFusion/node007',
    'pages/syntheticFusion/node008',
    'pages/syntheticFusion/node009',
    'pages/syntheticFusion/node010',
    'pages/syntheticFusion/node011',
    'pages/syntheticFusion/node012',
    'pages/syntheticFusion/node013',
    'pages/syntheticFusion/node014',
    'pages/syntheticFusion/node015',
    'pages/syntheticFusion/node016',
    'pages/syntheticFusion/node017',
    'pages/syntheticFusion/node018',
    'pages/syntheticFusion/node019',
    'pages/syntheticFusion/node020',
    'pages/syntheticFusion/node021',
    'pages/syntheticFusion/node022',
    'pages/syntheticFusion/node023',
    'pages/syntheticFusion/node024',
    'pages/syntheticFusion/node025',
    'pages/syntheticFusion/node026',
    'pages/syntheticFusion/node027',
    'pages/syntheticFusion/node028',
    'pages/syntheticFusion/node029',
    'pages/syntheticFusion/node030',
    'pages/syntheticFusion/node031',
    'pages/syntheticFusion/node032',
    'pages/syntheticFusion/node033',
    'pages/syntheticFusion/node034',
    'pages/syntheticFusion/node035',
    'pages/syntheticFusion/node036',
    'pages/syntheticFusion/node037',
    'pages/syntheticFusion/node038',
    'pages/syntheticFusion/node039',
    'pages/syntheticFusion/node040',
    'pages/syntheticFusion/node041',
    'pages/syntheticFusion/node042',
    'pages/syntheticFusion/node043',
    'pages/syntheticFusion/node044',
    'pages/syntheticFusion/node045',
    'pages/syntheticFusion/node046',
    'pages/syntheticFusion/node047',
    'pages/syntheticFusion/node048',
    'pages/syntheticFusion/node049',
    'pages/syntheticFusion/node050',
    'pages/syntheticFusion/node051',
    'pages/syntheticFusion/node052',
    'pages/syntheticFusion/node053',
    'pages/syntheticFusion/node054',
    'pages/syntheticFusion/node055',
    'pages/syntheticFusion/node056',
    'pages/syntheticFusion/node057',
    'pages/syntheticFusion/node058',
    'pages/syntheticFusion/node059',
    'pages/syntheticFusion/node060',
    'pages/syntheticFusion/node061',
    'pages/syntheticFusion/node062',
    'pages/syntheticFusion/node063',
    'pages/syntheticFusion/node064',
    'pages/syntheticFusion/node065',
    'pages/syntheticFusion/node066',
    'pages/syntheticFusion/node067',
    'pages/syntheticFusion/node068',
    'pages/syntheticFusion/node069',
    'pages/syntheticFusion/node070',
    'pages/syntheticFusion/node071',
    'pages/syntheticFusion/node072',
    'pages/syntheticFusion/node073',
    'pages/syntheticFusion/node074',
    'pages/syntheticFusion/node075',
    'pages/syntheticFusion/node076',
    'pages/syntheticFusion/node077',
    'pages/syntheticFusion/node078',
    'pages/syntheticFusion/node079',
    'pages/syntheticFusion/node080',
    'pages/syntheticFusion/node081',
    'pages/syntheticFusion/node082',
    'pages/syntheticFusion/node083',
    'pages/syntheticFusion/node084',
    'pages/syntheticFusion/node085',
    'pages/syntheticFusion/node086',
    'pages/syntheticFusion/node087',
    'pages/syntheticFusion/node088',
    'pages/syntheticFusion/node089',
    'pages/syntheticFusion/node090',
    'pages/syntheticFusion/node091',
    'pages/syntheticFusion/node092',
    'pages/syntheticFusion/node093',
    'pages/syntheticFusion/node094',
    'pages/syntheticFusion/node095',
    'pages/syntheticFusion/node096',
    'pages/syntheticFusion/node097',
    'pages/syntheticFusion/node098',
    'pages/syntheticFusion/node099',
    'pages/syntheticFusion/node100',
    'pages/syntheticFusion/node101',
    'pages/syntheticFusion/node102',
    'pages/syntheticFusion/node103',
    'pages/syntheticFusion/node104',
    'pages/syntheticFusion/node105',
    'pages/syntheticFusion/node106',
    'pages/syntheticFusion/node107',
    'pages/syntheticFusion/node108',
    'pages/syntheticFusion/node109',
    'pages/syntheticFusion/node110',
    'pages/syntheticFusion/node111',
    'pages/syntheticFusion/node112',
    'pages/syntheticFusion/node113',
    'pages/syntheticFusion/node114',
    'pages/syntheticFusion/node115',
    'pages/syntheticFusion/node116',
    'pages/syntheticFusion/node117',
    'pages/syntheticFusion/node118',
    'pages/syntheticFusion/node119',
    'pages/syntheticFusion/node120',
    'pages/syntheticFusion/node121',
    'pages/syntheticFusion/node122',
    'pages/syntheticFusion/node123',
    'pages/syntheticFusion/node124',
    'pages/syntheticFusion/node125',
    'pages/syntheticFusion/node126',
    'pages/syntheticFusion/node127',
    'pages/syntheticFusion/node128',
    'pages/syntheticFusion/node129',
    'pages/syntheticFusion/node130',
    'pages/syntheticFusion/node131',
    'pages/syntheticFusion/node132',
    'pages/syntheticFusion/node133',
    'pages/syntheticFusion/node134',
    'pages/syntheticFusion/node135',
    'pages/syntheticFusion/node136',
    'pages/syntheticFusion/node137',
    'pages/syntheticFusion/node138',
    'pages/syntheticFusion/node139',
    'pages/syntheticFusion/node140',
    'pages/syntheticFusion/node141',
    'pages/syntheticFusion/node142',
    'pages/syntheticFusion/node143',
    'pages/syntheticFusion/node144',
    'pages/syntheticFusion/node145',
    'pages/syntheticFusion/node146',
    'pages/syntheticFusion/node147',
    'pages/syntheticFusion/node148',
    'pages/syntheticFusion/node149',
    'pages/syntheticFusion/node150',
    'pages/syntheticFusion/node151',
    'pages/syntheticFusion/node152',
    'pages/syntheticFusion/node153',
    'pages/syntheticFusion/node154',
    'pages/syntheticFusion/node155',
    'pages/syntheticFusion/node156',
    'pages/syntheticFusion/node157',
    'pages/syntheticFusion/node158',
    'pages/syntheticFusion/node159',
    'pages/syntheticFusion/node160'
  ];

  describe('MegaSyntheticRouteAtlasFusionSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteFusion_[A-Za-z0-9_]+_[0-9]{3}$/;
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

