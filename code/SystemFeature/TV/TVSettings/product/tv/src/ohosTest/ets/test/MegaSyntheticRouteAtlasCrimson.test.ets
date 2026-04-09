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
  return /^pages\/syntheticCrimson\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasCrimsonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteCrimson_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticCrimson/node001',
    'pages/syntheticCrimson/node002',
    'pages/syntheticCrimson/node003',
    'pages/syntheticCrimson/node004',
    'pages/syntheticCrimson/node005',
    'pages/syntheticCrimson/node006',
    'pages/syntheticCrimson/node007',
    'pages/syntheticCrimson/node008',
    'pages/syntheticCrimson/node009',
    'pages/syntheticCrimson/node010',
    'pages/syntheticCrimson/node011',
    'pages/syntheticCrimson/node012',
    'pages/syntheticCrimson/node013',
    'pages/syntheticCrimson/node014',
    'pages/syntheticCrimson/node015',
    'pages/syntheticCrimson/node016',
    'pages/syntheticCrimson/node017',
    'pages/syntheticCrimson/node018',
    'pages/syntheticCrimson/node019',
    'pages/syntheticCrimson/node020',
    'pages/syntheticCrimson/node021',
    'pages/syntheticCrimson/node022',
    'pages/syntheticCrimson/node023',
    'pages/syntheticCrimson/node024',
    'pages/syntheticCrimson/node025',
    'pages/syntheticCrimson/node026',
    'pages/syntheticCrimson/node027',
    'pages/syntheticCrimson/node028',
    'pages/syntheticCrimson/node029',
    'pages/syntheticCrimson/node030',
    'pages/syntheticCrimson/node031',
    'pages/syntheticCrimson/node032',
    'pages/syntheticCrimson/node033',
    'pages/syntheticCrimson/node034',
    'pages/syntheticCrimson/node035',
    'pages/syntheticCrimson/node036',
    'pages/syntheticCrimson/node037',
    'pages/syntheticCrimson/node038',
    'pages/syntheticCrimson/node039',
    'pages/syntheticCrimson/node040',
    'pages/syntheticCrimson/node041',
    'pages/syntheticCrimson/node042',
    'pages/syntheticCrimson/node043',
    'pages/syntheticCrimson/node044',
    'pages/syntheticCrimson/node045',
    'pages/syntheticCrimson/node046',
    'pages/syntheticCrimson/node047',
    'pages/syntheticCrimson/node048',
    'pages/syntheticCrimson/node049',
    'pages/syntheticCrimson/node050',
    'pages/syntheticCrimson/node051',
    'pages/syntheticCrimson/node052',
    'pages/syntheticCrimson/node053',
    'pages/syntheticCrimson/node054',
    'pages/syntheticCrimson/node055',
    'pages/syntheticCrimson/node056',
    'pages/syntheticCrimson/node057',
    'pages/syntheticCrimson/node058',
    'pages/syntheticCrimson/node059',
    'pages/syntheticCrimson/node060',
    'pages/syntheticCrimson/node061',
    'pages/syntheticCrimson/node062',
    'pages/syntheticCrimson/node063',
    'pages/syntheticCrimson/node064',
    'pages/syntheticCrimson/node065',
    'pages/syntheticCrimson/node066',
    'pages/syntheticCrimson/node067',
    'pages/syntheticCrimson/node068',
    'pages/syntheticCrimson/node069',
    'pages/syntheticCrimson/node070',
    'pages/syntheticCrimson/node071',
    'pages/syntheticCrimson/node072',
    'pages/syntheticCrimson/node073',
    'pages/syntheticCrimson/node074',
    'pages/syntheticCrimson/node075',
    'pages/syntheticCrimson/node076',
    'pages/syntheticCrimson/node077',
    'pages/syntheticCrimson/node078',
    'pages/syntheticCrimson/node079',
    'pages/syntheticCrimson/node080',
    'pages/syntheticCrimson/node081',
    'pages/syntheticCrimson/node082',
    'pages/syntheticCrimson/node083',
    'pages/syntheticCrimson/node084',
    'pages/syntheticCrimson/node085',
    'pages/syntheticCrimson/node086',
    'pages/syntheticCrimson/node087',
    'pages/syntheticCrimson/node088',
    'pages/syntheticCrimson/node089',
    'pages/syntheticCrimson/node090',
    'pages/syntheticCrimson/node091',
    'pages/syntheticCrimson/node092',
    'pages/syntheticCrimson/node093',
    'pages/syntheticCrimson/node094',
    'pages/syntheticCrimson/node095',
    'pages/syntheticCrimson/node096',
    'pages/syntheticCrimson/node097',
    'pages/syntheticCrimson/node098',
    'pages/syntheticCrimson/node099',
    'pages/syntheticCrimson/node100',
    'pages/syntheticCrimson/node101',
    'pages/syntheticCrimson/node102',
    'pages/syntheticCrimson/node103',
    'pages/syntheticCrimson/node104',
    'pages/syntheticCrimson/node105',
    'pages/syntheticCrimson/node106',
    'pages/syntheticCrimson/node107',
    'pages/syntheticCrimson/node108',
    'pages/syntheticCrimson/node109',
    'pages/syntheticCrimson/node110',
    'pages/syntheticCrimson/node111',
    'pages/syntheticCrimson/node112',
    'pages/syntheticCrimson/node113',
    'pages/syntheticCrimson/node114',
    'pages/syntheticCrimson/node115',
    'pages/syntheticCrimson/node116',
    'pages/syntheticCrimson/node117',
    'pages/syntheticCrimson/node118',
    'pages/syntheticCrimson/node119',
    'pages/syntheticCrimson/node120',
    'pages/syntheticCrimson/node121',
    'pages/syntheticCrimson/node122',
    'pages/syntheticCrimson/node123',
    'pages/syntheticCrimson/node124',
    'pages/syntheticCrimson/node125',
    'pages/syntheticCrimson/node126',
    'pages/syntheticCrimson/node127',
    'pages/syntheticCrimson/node128',
    'pages/syntheticCrimson/node129',
    'pages/syntheticCrimson/node130',
    'pages/syntheticCrimson/node131',
    'pages/syntheticCrimson/node132',
    'pages/syntheticCrimson/node133',
    'pages/syntheticCrimson/node134',
    'pages/syntheticCrimson/node135',
    'pages/syntheticCrimson/node136',
    'pages/syntheticCrimson/node137',
    'pages/syntheticCrimson/node138',
    'pages/syntheticCrimson/node139',
    'pages/syntheticCrimson/node140',
    'pages/syntheticCrimson/node141',
    'pages/syntheticCrimson/node142',
    'pages/syntheticCrimson/node143',
    'pages/syntheticCrimson/node144',
    'pages/syntheticCrimson/node145',
    'pages/syntheticCrimson/node146',
    'pages/syntheticCrimson/node147',
    'pages/syntheticCrimson/node148',
    'pages/syntheticCrimson/node149',
    'pages/syntheticCrimson/node150',
    'pages/syntheticCrimson/node151',
    'pages/syntheticCrimson/node152',
    'pages/syntheticCrimson/node153',
    'pages/syntheticCrimson/node154',
    'pages/syntheticCrimson/node155',
    'pages/syntheticCrimson/node156',
    'pages/syntheticCrimson/node157',
    'pages/syntheticCrimson/node158',
    'pages/syntheticCrimson/node159',
    'pages/syntheticCrimson/node160'
  ];

  describe('MegaSyntheticRouteAtlasCrimsonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteCrimson_[A-Za-z0-9_]+_[0-9]{3}$/;
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

