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
  return /^pages\/syntheticDrift\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasDriftTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteDrift_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticDrift/node001',
    'pages/syntheticDrift/node002',
    'pages/syntheticDrift/node003',
    'pages/syntheticDrift/node004',
    'pages/syntheticDrift/node005',
    'pages/syntheticDrift/node006',
    'pages/syntheticDrift/node007',
    'pages/syntheticDrift/node008',
    'pages/syntheticDrift/node009',
    'pages/syntheticDrift/node010',
    'pages/syntheticDrift/node011',
    'pages/syntheticDrift/node012',
    'pages/syntheticDrift/node013',
    'pages/syntheticDrift/node014',
    'pages/syntheticDrift/node015',
    'pages/syntheticDrift/node016',
    'pages/syntheticDrift/node017',
    'pages/syntheticDrift/node018',
    'pages/syntheticDrift/node019',
    'pages/syntheticDrift/node020',
    'pages/syntheticDrift/node021',
    'pages/syntheticDrift/node022',
    'pages/syntheticDrift/node023',
    'pages/syntheticDrift/node024',
    'pages/syntheticDrift/node025',
    'pages/syntheticDrift/node026',
    'pages/syntheticDrift/node027',
    'pages/syntheticDrift/node028',
    'pages/syntheticDrift/node029',
    'pages/syntheticDrift/node030',
    'pages/syntheticDrift/node031',
    'pages/syntheticDrift/node032',
    'pages/syntheticDrift/node033',
    'pages/syntheticDrift/node034',
    'pages/syntheticDrift/node035',
    'pages/syntheticDrift/node036',
    'pages/syntheticDrift/node037',
    'pages/syntheticDrift/node038',
    'pages/syntheticDrift/node039',
    'pages/syntheticDrift/node040',
    'pages/syntheticDrift/node041',
    'pages/syntheticDrift/node042',
    'pages/syntheticDrift/node043',
    'pages/syntheticDrift/node044',
    'pages/syntheticDrift/node045',
    'pages/syntheticDrift/node046',
    'pages/syntheticDrift/node047',
    'pages/syntheticDrift/node048',
    'pages/syntheticDrift/node049',
    'pages/syntheticDrift/node050',
    'pages/syntheticDrift/node051',
    'pages/syntheticDrift/node052',
    'pages/syntheticDrift/node053',
    'pages/syntheticDrift/node054',
    'pages/syntheticDrift/node055',
    'pages/syntheticDrift/node056',
    'pages/syntheticDrift/node057',
    'pages/syntheticDrift/node058',
    'pages/syntheticDrift/node059',
    'pages/syntheticDrift/node060',
    'pages/syntheticDrift/node061',
    'pages/syntheticDrift/node062',
    'pages/syntheticDrift/node063',
    'pages/syntheticDrift/node064',
    'pages/syntheticDrift/node065',
    'pages/syntheticDrift/node066',
    'pages/syntheticDrift/node067',
    'pages/syntheticDrift/node068',
    'pages/syntheticDrift/node069',
    'pages/syntheticDrift/node070',
    'pages/syntheticDrift/node071',
    'pages/syntheticDrift/node072',
    'pages/syntheticDrift/node073',
    'pages/syntheticDrift/node074',
    'pages/syntheticDrift/node075',
    'pages/syntheticDrift/node076',
    'pages/syntheticDrift/node077',
    'pages/syntheticDrift/node078',
    'pages/syntheticDrift/node079',
    'pages/syntheticDrift/node080',
    'pages/syntheticDrift/node081',
    'pages/syntheticDrift/node082',
    'pages/syntheticDrift/node083',
    'pages/syntheticDrift/node084',
    'pages/syntheticDrift/node085',
    'pages/syntheticDrift/node086',
    'pages/syntheticDrift/node087',
    'pages/syntheticDrift/node088',
    'pages/syntheticDrift/node089',
    'pages/syntheticDrift/node090',
    'pages/syntheticDrift/node091',
    'pages/syntheticDrift/node092',
    'pages/syntheticDrift/node093',
    'pages/syntheticDrift/node094',
    'pages/syntheticDrift/node095',
    'pages/syntheticDrift/node096',
    'pages/syntheticDrift/node097',
    'pages/syntheticDrift/node098',
    'pages/syntheticDrift/node099',
    'pages/syntheticDrift/node100',
    'pages/syntheticDrift/node101',
    'pages/syntheticDrift/node102',
    'pages/syntheticDrift/node103',
    'pages/syntheticDrift/node104',
    'pages/syntheticDrift/node105',
    'pages/syntheticDrift/node106',
    'pages/syntheticDrift/node107',
    'pages/syntheticDrift/node108',
    'pages/syntheticDrift/node109',
    'pages/syntheticDrift/node110',
    'pages/syntheticDrift/node111',
    'pages/syntheticDrift/node112',
    'pages/syntheticDrift/node113',
    'pages/syntheticDrift/node114',
    'pages/syntheticDrift/node115',
    'pages/syntheticDrift/node116',
    'pages/syntheticDrift/node117',
    'pages/syntheticDrift/node118',
    'pages/syntheticDrift/node119',
    'pages/syntheticDrift/node120',
    'pages/syntheticDrift/node121',
    'pages/syntheticDrift/node122',
    'pages/syntheticDrift/node123',
    'pages/syntheticDrift/node124',
    'pages/syntheticDrift/node125',
    'pages/syntheticDrift/node126',
    'pages/syntheticDrift/node127',
    'pages/syntheticDrift/node128',
    'pages/syntheticDrift/node129',
    'pages/syntheticDrift/node130',
    'pages/syntheticDrift/node131',
    'pages/syntheticDrift/node132',
    'pages/syntheticDrift/node133',
    'pages/syntheticDrift/node134',
    'pages/syntheticDrift/node135',
    'pages/syntheticDrift/node136',
    'pages/syntheticDrift/node137',
    'pages/syntheticDrift/node138',
    'pages/syntheticDrift/node139',
    'pages/syntheticDrift/node140',
    'pages/syntheticDrift/node141',
    'pages/syntheticDrift/node142',
    'pages/syntheticDrift/node143',
    'pages/syntheticDrift/node144',
    'pages/syntheticDrift/node145',
    'pages/syntheticDrift/node146',
    'pages/syntheticDrift/node147',
    'pages/syntheticDrift/node148',
    'pages/syntheticDrift/node149',
    'pages/syntheticDrift/node150',
    'pages/syntheticDrift/node151',
    'pages/syntheticDrift/node152',
    'pages/syntheticDrift/node153',
    'pages/syntheticDrift/node154',
    'pages/syntheticDrift/node155',
    'pages/syntheticDrift/node156',
    'pages/syntheticDrift/node157',
    'pages/syntheticDrift/node158',
    'pages/syntheticDrift/node159',
    'pages/syntheticDrift/node160'
  ];

  describe('MegaSyntheticRouteAtlasDriftSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteDrift_[A-Za-z0-9_]+_[0-9]{3}$/;
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

