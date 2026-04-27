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
  return /^pages\/syntheticBastion\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasBastionTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteBastion_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticBastion/node001',
    'pages/syntheticBastion/node002',
    'pages/syntheticBastion/node003',
    'pages/syntheticBastion/node004',
    'pages/syntheticBastion/node005',
    'pages/syntheticBastion/node006',
    'pages/syntheticBastion/node007',
    'pages/syntheticBastion/node008',
    'pages/syntheticBastion/node009',
    'pages/syntheticBastion/node010',
    'pages/syntheticBastion/node011',
    'pages/syntheticBastion/node012',
    'pages/syntheticBastion/node013',
    'pages/syntheticBastion/node014',
    'pages/syntheticBastion/node015',
    'pages/syntheticBastion/node016',
    'pages/syntheticBastion/node017',
    'pages/syntheticBastion/node018',
    'pages/syntheticBastion/node019',
    'pages/syntheticBastion/node020',
    'pages/syntheticBastion/node021',
    'pages/syntheticBastion/node022',
    'pages/syntheticBastion/node023',
    'pages/syntheticBastion/node024',
    'pages/syntheticBastion/node025',
    'pages/syntheticBastion/node026',
    'pages/syntheticBastion/node027',
    'pages/syntheticBastion/node028',
    'pages/syntheticBastion/node029',
    'pages/syntheticBastion/node030',
    'pages/syntheticBastion/node031',
    'pages/syntheticBastion/node032',
    'pages/syntheticBastion/node033',
    'pages/syntheticBastion/node034',
    'pages/syntheticBastion/node035',
    'pages/syntheticBastion/node036',
    'pages/syntheticBastion/node037',
    'pages/syntheticBastion/node038',
    'pages/syntheticBastion/node039',
    'pages/syntheticBastion/node040',
    'pages/syntheticBastion/node041',
    'pages/syntheticBastion/node042',
    'pages/syntheticBastion/node043',
    'pages/syntheticBastion/node044',
    'pages/syntheticBastion/node045',
    'pages/syntheticBastion/node046',
    'pages/syntheticBastion/node047',
    'pages/syntheticBastion/node048',
    'pages/syntheticBastion/node049',
    'pages/syntheticBastion/node050',
    'pages/syntheticBastion/node051',
    'pages/syntheticBastion/node052',
    'pages/syntheticBastion/node053',
    'pages/syntheticBastion/node054',
    'pages/syntheticBastion/node055',
    'pages/syntheticBastion/node056',
    'pages/syntheticBastion/node057',
    'pages/syntheticBastion/node058',
    'pages/syntheticBastion/node059',
    'pages/syntheticBastion/node060',
    'pages/syntheticBastion/node061',
    'pages/syntheticBastion/node062',
    'pages/syntheticBastion/node063',
    'pages/syntheticBastion/node064',
    'pages/syntheticBastion/node065',
    'pages/syntheticBastion/node066',
    'pages/syntheticBastion/node067',
    'pages/syntheticBastion/node068',
    'pages/syntheticBastion/node069',
    'pages/syntheticBastion/node070',
    'pages/syntheticBastion/node071',
    'pages/syntheticBastion/node072',
    'pages/syntheticBastion/node073',
    'pages/syntheticBastion/node074',
    'pages/syntheticBastion/node075',
    'pages/syntheticBastion/node076',
    'pages/syntheticBastion/node077',
    'pages/syntheticBastion/node078',
    'pages/syntheticBastion/node079',
    'pages/syntheticBastion/node080',
    'pages/syntheticBastion/node081',
    'pages/syntheticBastion/node082',
    'pages/syntheticBastion/node083',
    'pages/syntheticBastion/node084',
    'pages/syntheticBastion/node085',
    'pages/syntheticBastion/node086',
    'pages/syntheticBastion/node087',
    'pages/syntheticBastion/node088',
    'pages/syntheticBastion/node089',
    'pages/syntheticBastion/node090',
    'pages/syntheticBastion/node091',
    'pages/syntheticBastion/node092',
    'pages/syntheticBastion/node093',
    'pages/syntheticBastion/node094',
    'pages/syntheticBastion/node095',
    'pages/syntheticBastion/node096',
    'pages/syntheticBastion/node097',
    'pages/syntheticBastion/node098',
    'pages/syntheticBastion/node099',
    'pages/syntheticBastion/node100',
    'pages/syntheticBastion/node101',
    'pages/syntheticBastion/node102',
    'pages/syntheticBastion/node103',
    'pages/syntheticBastion/node104',
    'pages/syntheticBastion/node105',
    'pages/syntheticBastion/node106',
    'pages/syntheticBastion/node107',
    'pages/syntheticBastion/node108',
    'pages/syntheticBastion/node109',
    'pages/syntheticBastion/node110',
    'pages/syntheticBastion/node111',
    'pages/syntheticBastion/node112',
    'pages/syntheticBastion/node113',
    'pages/syntheticBastion/node114',
    'pages/syntheticBastion/node115',
    'pages/syntheticBastion/node116',
    'pages/syntheticBastion/node117',
    'pages/syntheticBastion/node118',
    'pages/syntheticBastion/node119',
    'pages/syntheticBastion/node120',
    'pages/syntheticBastion/node121',
    'pages/syntheticBastion/node122',
    'pages/syntheticBastion/node123',
    'pages/syntheticBastion/node124',
    'pages/syntheticBastion/node125',
    'pages/syntheticBastion/node126',
    'pages/syntheticBastion/node127',
    'pages/syntheticBastion/node128',
    'pages/syntheticBastion/node129',
    'pages/syntheticBastion/node130',
    'pages/syntheticBastion/node131',
    'pages/syntheticBastion/node132',
    'pages/syntheticBastion/node133',
    'pages/syntheticBastion/node134',
    'pages/syntheticBastion/node135',
    'pages/syntheticBastion/node136',
    'pages/syntheticBastion/node137',
    'pages/syntheticBastion/node138',
    'pages/syntheticBastion/node139',
    'pages/syntheticBastion/node140',
    'pages/syntheticBastion/node141',
    'pages/syntheticBastion/node142',
    'pages/syntheticBastion/node143',
    'pages/syntheticBastion/node144',
    'pages/syntheticBastion/node145',
    'pages/syntheticBastion/node146',
    'pages/syntheticBastion/node147',
    'pages/syntheticBastion/node148',
    'pages/syntheticBastion/node149',
    'pages/syntheticBastion/node150',
    'pages/syntheticBastion/node151',
    'pages/syntheticBastion/node152',
    'pages/syntheticBastion/node153',
    'pages/syntheticBastion/node154',
    'pages/syntheticBastion/node155',
    'pages/syntheticBastion/node156',
    'pages/syntheticBastion/node157',
    'pages/syntheticBastion/node158',
    'pages/syntheticBastion/node159',
    'pages/syntheticBastion/node160'
  ];

  describe('MegaSyntheticRouteAtlasBastionSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteBastion_[A-Za-z0-9_]+_[0-9]{3}$/;
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

