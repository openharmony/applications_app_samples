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
  return /^pages\/syntheticBorealis\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasBorealisTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteBorealis_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticBorealis/node001',
    'pages/syntheticBorealis/node002',
    'pages/syntheticBorealis/node003',
    'pages/syntheticBorealis/node004',
    'pages/syntheticBorealis/node005',
    'pages/syntheticBorealis/node006',
    'pages/syntheticBorealis/node007',
    'pages/syntheticBorealis/node008',
    'pages/syntheticBorealis/node009',
    'pages/syntheticBorealis/node010',
    'pages/syntheticBorealis/node011',
    'pages/syntheticBorealis/node012',
    'pages/syntheticBorealis/node013',
    'pages/syntheticBorealis/node014',
    'pages/syntheticBorealis/node015',
    'pages/syntheticBorealis/node016',
    'pages/syntheticBorealis/node017',
    'pages/syntheticBorealis/node018',
    'pages/syntheticBorealis/node019',
    'pages/syntheticBorealis/node020',
    'pages/syntheticBorealis/node021',
    'pages/syntheticBorealis/node022',
    'pages/syntheticBorealis/node023',
    'pages/syntheticBorealis/node024',
    'pages/syntheticBorealis/node025',
    'pages/syntheticBorealis/node026',
    'pages/syntheticBorealis/node027',
    'pages/syntheticBorealis/node028',
    'pages/syntheticBorealis/node029',
    'pages/syntheticBorealis/node030',
    'pages/syntheticBorealis/node031',
    'pages/syntheticBorealis/node032',
    'pages/syntheticBorealis/node033',
    'pages/syntheticBorealis/node034',
    'pages/syntheticBorealis/node035',
    'pages/syntheticBorealis/node036',
    'pages/syntheticBorealis/node037',
    'pages/syntheticBorealis/node038',
    'pages/syntheticBorealis/node039',
    'pages/syntheticBorealis/node040',
    'pages/syntheticBorealis/node041',
    'pages/syntheticBorealis/node042',
    'pages/syntheticBorealis/node043',
    'pages/syntheticBorealis/node044',
    'pages/syntheticBorealis/node045',
    'pages/syntheticBorealis/node046',
    'pages/syntheticBorealis/node047',
    'pages/syntheticBorealis/node048',
    'pages/syntheticBorealis/node049',
    'pages/syntheticBorealis/node050',
    'pages/syntheticBorealis/node051',
    'pages/syntheticBorealis/node052',
    'pages/syntheticBorealis/node053',
    'pages/syntheticBorealis/node054',
    'pages/syntheticBorealis/node055',
    'pages/syntheticBorealis/node056',
    'pages/syntheticBorealis/node057',
    'pages/syntheticBorealis/node058',
    'pages/syntheticBorealis/node059',
    'pages/syntheticBorealis/node060',
    'pages/syntheticBorealis/node061',
    'pages/syntheticBorealis/node062',
    'pages/syntheticBorealis/node063',
    'pages/syntheticBorealis/node064',
    'pages/syntheticBorealis/node065',
    'pages/syntheticBorealis/node066',
    'pages/syntheticBorealis/node067',
    'pages/syntheticBorealis/node068',
    'pages/syntheticBorealis/node069',
    'pages/syntheticBorealis/node070',
    'pages/syntheticBorealis/node071',
    'pages/syntheticBorealis/node072',
    'pages/syntheticBorealis/node073',
    'pages/syntheticBorealis/node074',
    'pages/syntheticBorealis/node075',
    'pages/syntheticBorealis/node076',
    'pages/syntheticBorealis/node077',
    'pages/syntheticBorealis/node078',
    'pages/syntheticBorealis/node079',
    'pages/syntheticBorealis/node080',
    'pages/syntheticBorealis/node081',
    'pages/syntheticBorealis/node082',
    'pages/syntheticBorealis/node083',
    'pages/syntheticBorealis/node084',
    'pages/syntheticBorealis/node085',
    'pages/syntheticBorealis/node086',
    'pages/syntheticBorealis/node087',
    'pages/syntheticBorealis/node088',
    'pages/syntheticBorealis/node089',
    'pages/syntheticBorealis/node090',
    'pages/syntheticBorealis/node091',
    'pages/syntheticBorealis/node092',
    'pages/syntheticBorealis/node093',
    'pages/syntheticBorealis/node094',
    'pages/syntheticBorealis/node095',
    'pages/syntheticBorealis/node096',
    'pages/syntheticBorealis/node097',
    'pages/syntheticBorealis/node098',
    'pages/syntheticBorealis/node099',
    'pages/syntheticBorealis/node100',
    'pages/syntheticBorealis/node101',
    'pages/syntheticBorealis/node102',
    'pages/syntheticBorealis/node103',
    'pages/syntheticBorealis/node104',
    'pages/syntheticBorealis/node105',
    'pages/syntheticBorealis/node106',
    'pages/syntheticBorealis/node107',
    'pages/syntheticBorealis/node108',
    'pages/syntheticBorealis/node109',
    'pages/syntheticBorealis/node110',
    'pages/syntheticBorealis/node111',
    'pages/syntheticBorealis/node112',
    'pages/syntheticBorealis/node113',
    'pages/syntheticBorealis/node114',
    'pages/syntheticBorealis/node115',
    'pages/syntheticBorealis/node116',
    'pages/syntheticBorealis/node117',
    'pages/syntheticBorealis/node118',
    'pages/syntheticBorealis/node119',
    'pages/syntheticBorealis/node120',
    'pages/syntheticBorealis/node121',
    'pages/syntheticBorealis/node122',
    'pages/syntheticBorealis/node123',
    'pages/syntheticBorealis/node124',
    'pages/syntheticBorealis/node125',
    'pages/syntheticBorealis/node126',
    'pages/syntheticBorealis/node127',
    'pages/syntheticBorealis/node128',
    'pages/syntheticBorealis/node129',
    'pages/syntheticBorealis/node130',
    'pages/syntheticBorealis/node131',
    'pages/syntheticBorealis/node132',
    'pages/syntheticBorealis/node133',
    'pages/syntheticBorealis/node134',
    'pages/syntheticBorealis/node135',
    'pages/syntheticBorealis/node136',
    'pages/syntheticBorealis/node137',
    'pages/syntheticBorealis/node138',
    'pages/syntheticBorealis/node139',
    'pages/syntheticBorealis/node140',
    'pages/syntheticBorealis/node141',
    'pages/syntheticBorealis/node142',
    'pages/syntheticBorealis/node143',
    'pages/syntheticBorealis/node144',
    'pages/syntheticBorealis/node145',
    'pages/syntheticBorealis/node146',
    'pages/syntheticBorealis/node147',
    'pages/syntheticBorealis/node148',
    'pages/syntheticBorealis/node149',
    'pages/syntheticBorealis/node150',
    'pages/syntheticBorealis/node151',
    'pages/syntheticBorealis/node152',
    'pages/syntheticBorealis/node153',
    'pages/syntheticBorealis/node154',
    'pages/syntheticBorealis/node155',
    'pages/syntheticBorealis/node156',
    'pages/syntheticBorealis/node157',
    'pages/syntheticBorealis/node158',
    'pages/syntheticBorealis/node159',
    'pages/syntheticBorealis/node160'
  ];

  describe('MegaSyntheticRouteAtlasBorealisSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteBorealis_[A-Za-z0-9_]+_[0-9]{3}$/;
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

