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
  return /^pages\/syntheticPi\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasPiTest() {
  const casePrefix = 'Settings_MegaSyntheticRoutePi_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticPi/node001',
    'pages/syntheticPi/node002',
    'pages/syntheticPi/node003',
    'pages/syntheticPi/node004',
    'pages/syntheticPi/node005',
    'pages/syntheticPi/node006',
    'pages/syntheticPi/node007',
    'pages/syntheticPi/node008',
    'pages/syntheticPi/node009',
    'pages/syntheticPi/node010',
    'pages/syntheticPi/node011',
    'pages/syntheticPi/node012',
    'pages/syntheticPi/node013',
    'pages/syntheticPi/node014',
    'pages/syntheticPi/node015',
    'pages/syntheticPi/node016',
    'pages/syntheticPi/node017',
    'pages/syntheticPi/node018',
    'pages/syntheticPi/node019',
    'pages/syntheticPi/node020',
    'pages/syntheticPi/node021',
    'pages/syntheticPi/node022',
    'pages/syntheticPi/node023',
    'pages/syntheticPi/node024',
    'pages/syntheticPi/node025',
    'pages/syntheticPi/node026',
    'pages/syntheticPi/node027',
    'pages/syntheticPi/node028',
    'pages/syntheticPi/node029',
    'pages/syntheticPi/node030',
    'pages/syntheticPi/node031',
    'pages/syntheticPi/node032',
    'pages/syntheticPi/node033',
    'pages/syntheticPi/node034',
    'pages/syntheticPi/node035',
    'pages/syntheticPi/node036',
    'pages/syntheticPi/node037',
    'pages/syntheticPi/node038',
    'pages/syntheticPi/node039',
    'pages/syntheticPi/node040',
    'pages/syntheticPi/node041',
    'pages/syntheticPi/node042',
    'pages/syntheticPi/node043',
    'pages/syntheticPi/node044',
    'pages/syntheticPi/node045',
    'pages/syntheticPi/node046',
    'pages/syntheticPi/node047',
    'pages/syntheticPi/node048',
    'pages/syntheticPi/node049',
    'pages/syntheticPi/node050',
    'pages/syntheticPi/node051',
    'pages/syntheticPi/node052',
    'pages/syntheticPi/node053',
    'pages/syntheticPi/node054',
    'pages/syntheticPi/node055',
    'pages/syntheticPi/node056',
    'pages/syntheticPi/node057',
    'pages/syntheticPi/node058',
    'pages/syntheticPi/node059',
    'pages/syntheticPi/node060',
    'pages/syntheticPi/node061',
    'pages/syntheticPi/node062',
    'pages/syntheticPi/node063',
    'pages/syntheticPi/node064',
    'pages/syntheticPi/node065',
    'pages/syntheticPi/node066',
    'pages/syntheticPi/node067',
    'pages/syntheticPi/node068',
    'pages/syntheticPi/node069',
    'pages/syntheticPi/node070',
    'pages/syntheticPi/node071',
    'pages/syntheticPi/node072',
    'pages/syntheticPi/node073',
    'pages/syntheticPi/node074',
    'pages/syntheticPi/node075',
    'pages/syntheticPi/node076',
    'pages/syntheticPi/node077',
    'pages/syntheticPi/node078',
    'pages/syntheticPi/node079',
    'pages/syntheticPi/node080',
    'pages/syntheticPi/node081',
    'pages/syntheticPi/node082',
    'pages/syntheticPi/node083',
    'pages/syntheticPi/node084',
    'pages/syntheticPi/node085',
    'pages/syntheticPi/node086',
    'pages/syntheticPi/node087',
    'pages/syntheticPi/node088',
    'pages/syntheticPi/node089',
    'pages/syntheticPi/node090',
    'pages/syntheticPi/node091',
    'pages/syntheticPi/node092',
    'pages/syntheticPi/node093',
    'pages/syntheticPi/node094',
    'pages/syntheticPi/node095',
    'pages/syntheticPi/node096',
    'pages/syntheticPi/node097',
    'pages/syntheticPi/node098',
    'pages/syntheticPi/node099',
    'pages/syntheticPi/node100',
    'pages/syntheticPi/node101',
    'pages/syntheticPi/node102',
    'pages/syntheticPi/node103',
    'pages/syntheticPi/node104',
    'pages/syntheticPi/node105',
    'pages/syntheticPi/node106',
    'pages/syntheticPi/node107',
    'pages/syntheticPi/node108',
    'pages/syntheticPi/node109',
    'pages/syntheticPi/node110',
    'pages/syntheticPi/node111',
    'pages/syntheticPi/node112',
    'pages/syntheticPi/node113',
    'pages/syntheticPi/node114',
    'pages/syntheticPi/node115',
    'pages/syntheticPi/node116',
    'pages/syntheticPi/node117',
    'pages/syntheticPi/node118',
    'pages/syntheticPi/node119',
    'pages/syntheticPi/node120',
    'pages/syntheticPi/node121',
    'pages/syntheticPi/node122',
    'pages/syntheticPi/node123',
    'pages/syntheticPi/node124',
    'pages/syntheticPi/node125',
    'pages/syntheticPi/node126',
    'pages/syntheticPi/node127',
    'pages/syntheticPi/node128',
    'pages/syntheticPi/node129',
    'pages/syntheticPi/node130',
    'pages/syntheticPi/node131',
    'pages/syntheticPi/node132',
    'pages/syntheticPi/node133',
    'pages/syntheticPi/node134',
    'pages/syntheticPi/node135',
    'pages/syntheticPi/node136',
    'pages/syntheticPi/node137',
    'pages/syntheticPi/node138',
    'pages/syntheticPi/node139',
    'pages/syntheticPi/node140',
    'pages/syntheticPi/node141',
    'pages/syntheticPi/node142',
    'pages/syntheticPi/node143',
    'pages/syntheticPi/node144',
    'pages/syntheticPi/node145',
    'pages/syntheticPi/node146',
    'pages/syntheticPi/node147',
    'pages/syntheticPi/node148',
    'pages/syntheticPi/node149',
    'pages/syntheticPi/node150',
    'pages/syntheticPi/node151',
    'pages/syntheticPi/node152',
    'pages/syntheticPi/node153',
    'pages/syntheticPi/node154',
    'pages/syntheticPi/node155',
    'pages/syntheticPi/node156',
    'pages/syntheticPi/node157',
    'pages/syntheticPi/node158',
    'pages/syntheticPi/node159',
    'pages/syntheticPi/node160'
  ];

  describe('MegaSyntheticRouteAtlasPiSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRoutePi_[A-Za-z0-9_]+_[0-9]{3}$/;
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

