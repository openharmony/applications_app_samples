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
  return /^pages\/syntheticCinder\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasCinderTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteCinder_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticCinder/node001',
    'pages/syntheticCinder/node002',
    'pages/syntheticCinder/node003',
    'pages/syntheticCinder/node004',
    'pages/syntheticCinder/node005',
    'pages/syntheticCinder/node006',
    'pages/syntheticCinder/node007',
    'pages/syntheticCinder/node008',
    'pages/syntheticCinder/node009',
    'pages/syntheticCinder/node010',
    'pages/syntheticCinder/node011',
    'pages/syntheticCinder/node012',
    'pages/syntheticCinder/node013',
    'pages/syntheticCinder/node014',
    'pages/syntheticCinder/node015',
    'pages/syntheticCinder/node016',
    'pages/syntheticCinder/node017',
    'pages/syntheticCinder/node018',
    'pages/syntheticCinder/node019',
    'pages/syntheticCinder/node020',
    'pages/syntheticCinder/node021',
    'pages/syntheticCinder/node022',
    'pages/syntheticCinder/node023',
    'pages/syntheticCinder/node024',
    'pages/syntheticCinder/node025',
    'pages/syntheticCinder/node026',
    'pages/syntheticCinder/node027',
    'pages/syntheticCinder/node028',
    'pages/syntheticCinder/node029',
    'pages/syntheticCinder/node030',
    'pages/syntheticCinder/node031',
    'pages/syntheticCinder/node032',
    'pages/syntheticCinder/node033',
    'pages/syntheticCinder/node034',
    'pages/syntheticCinder/node035',
    'pages/syntheticCinder/node036',
    'pages/syntheticCinder/node037',
    'pages/syntheticCinder/node038',
    'pages/syntheticCinder/node039',
    'pages/syntheticCinder/node040',
    'pages/syntheticCinder/node041',
    'pages/syntheticCinder/node042',
    'pages/syntheticCinder/node043',
    'pages/syntheticCinder/node044',
    'pages/syntheticCinder/node045',
    'pages/syntheticCinder/node046',
    'pages/syntheticCinder/node047',
    'pages/syntheticCinder/node048',
    'pages/syntheticCinder/node049',
    'pages/syntheticCinder/node050',
    'pages/syntheticCinder/node051',
    'pages/syntheticCinder/node052',
    'pages/syntheticCinder/node053',
    'pages/syntheticCinder/node054',
    'pages/syntheticCinder/node055',
    'pages/syntheticCinder/node056',
    'pages/syntheticCinder/node057',
    'pages/syntheticCinder/node058',
    'pages/syntheticCinder/node059',
    'pages/syntheticCinder/node060',
    'pages/syntheticCinder/node061',
    'pages/syntheticCinder/node062',
    'pages/syntheticCinder/node063',
    'pages/syntheticCinder/node064',
    'pages/syntheticCinder/node065',
    'pages/syntheticCinder/node066',
    'pages/syntheticCinder/node067',
    'pages/syntheticCinder/node068',
    'pages/syntheticCinder/node069',
    'pages/syntheticCinder/node070',
    'pages/syntheticCinder/node071',
    'pages/syntheticCinder/node072',
    'pages/syntheticCinder/node073',
    'pages/syntheticCinder/node074',
    'pages/syntheticCinder/node075',
    'pages/syntheticCinder/node076',
    'pages/syntheticCinder/node077',
    'pages/syntheticCinder/node078',
    'pages/syntheticCinder/node079',
    'pages/syntheticCinder/node080',
    'pages/syntheticCinder/node081',
    'pages/syntheticCinder/node082',
    'pages/syntheticCinder/node083',
    'pages/syntheticCinder/node084',
    'pages/syntheticCinder/node085',
    'pages/syntheticCinder/node086',
    'pages/syntheticCinder/node087',
    'pages/syntheticCinder/node088',
    'pages/syntheticCinder/node089',
    'pages/syntheticCinder/node090',
    'pages/syntheticCinder/node091',
    'pages/syntheticCinder/node092',
    'pages/syntheticCinder/node093',
    'pages/syntheticCinder/node094',
    'pages/syntheticCinder/node095',
    'pages/syntheticCinder/node096',
    'pages/syntheticCinder/node097',
    'pages/syntheticCinder/node098',
    'pages/syntheticCinder/node099',
    'pages/syntheticCinder/node100',
    'pages/syntheticCinder/node101',
    'pages/syntheticCinder/node102',
    'pages/syntheticCinder/node103',
    'pages/syntheticCinder/node104',
    'pages/syntheticCinder/node105',
    'pages/syntheticCinder/node106',
    'pages/syntheticCinder/node107',
    'pages/syntheticCinder/node108',
    'pages/syntheticCinder/node109',
    'pages/syntheticCinder/node110',
    'pages/syntheticCinder/node111',
    'pages/syntheticCinder/node112',
    'pages/syntheticCinder/node113',
    'pages/syntheticCinder/node114',
    'pages/syntheticCinder/node115',
    'pages/syntheticCinder/node116',
    'pages/syntheticCinder/node117',
    'pages/syntheticCinder/node118',
    'pages/syntheticCinder/node119',
    'pages/syntheticCinder/node120',
    'pages/syntheticCinder/node121',
    'pages/syntheticCinder/node122',
    'pages/syntheticCinder/node123',
    'pages/syntheticCinder/node124',
    'pages/syntheticCinder/node125',
    'pages/syntheticCinder/node126',
    'pages/syntheticCinder/node127',
    'pages/syntheticCinder/node128',
    'pages/syntheticCinder/node129',
    'pages/syntheticCinder/node130',
    'pages/syntheticCinder/node131',
    'pages/syntheticCinder/node132',
    'pages/syntheticCinder/node133',
    'pages/syntheticCinder/node134',
    'pages/syntheticCinder/node135',
    'pages/syntheticCinder/node136',
    'pages/syntheticCinder/node137',
    'pages/syntheticCinder/node138',
    'pages/syntheticCinder/node139',
    'pages/syntheticCinder/node140',
    'pages/syntheticCinder/node141',
    'pages/syntheticCinder/node142',
    'pages/syntheticCinder/node143',
    'pages/syntheticCinder/node144',
    'pages/syntheticCinder/node145',
    'pages/syntheticCinder/node146',
    'pages/syntheticCinder/node147',
    'pages/syntheticCinder/node148',
    'pages/syntheticCinder/node149',
    'pages/syntheticCinder/node150',
    'pages/syntheticCinder/node151',
    'pages/syntheticCinder/node152',
    'pages/syntheticCinder/node153',
    'pages/syntheticCinder/node154',
    'pages/syntheticCinder/node155',
    'pages/syntheticCinder/node156',
    'pages/syntheticCinder/node157',
    'pages/syntheticCinder/node158',
    'pages/syntheticCinder/node159',
    'pages/syntheticCinder/node160'
  ];

  describe('MegaSyntheticRouteAtlasCinderSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteCinder_[A-Za-z0-9_]+_[0-9]{3}$/;
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

