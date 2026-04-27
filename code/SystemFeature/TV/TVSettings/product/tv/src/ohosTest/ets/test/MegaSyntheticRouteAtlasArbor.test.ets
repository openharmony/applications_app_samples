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
  return /^pages\/syntheticArbor\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasArborTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteArbor_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticArbor/node001',
    'pages/syntheticArbor/node002',
    'pages/syntheticArbor/node003',
    'pages/syntheticArbor/node004',
    'pages/syntheticArbor/node005',
    'pages/syntheticArbor/node006',
    'pages/syntheticArbor/node007',
    'pages/syntheticArbor/node008',
    'pages/syntheticArbor/node009',
    'pages/syntheticArbor/node010',
    'pages/syntheticArbor/node011',
    'pages/syntheticArbor/node012',
    'pages/syntheticArbor/node013',
    'pages/syntheticArbor/node014',
    'pages/syntheticArbor/node015',
    'pages/syntheticArbor/node016',
    'pages/syntheticArbor/node017',
    'pages/syntheticArbor/node018',
    'pages/syntheticArbor/node019',
    'pages/syntheticArbor/node020',
    'pages/syntheticArbor/node021',
    'pages/syntheticArbor/node022',
    'pages/syntheticArbor/node023',
    'pages/syntheticArbor/node024',
    'pages/syntheticArbor/node025',
    'pages/syntheticArbor/node026',
    'pages/syntheticArbor/node027',
    'pages/syntheticArbor/node028',
    'pages/syntheticArbor/node029',
    'pages/syntheticArbor/node030',
    'pages/syntheticArbor/node031',
    'pages/syntheticArbor/node032',
    'pages/syntheticArbor/node033',
    'pages/syntheticArbor/node034',
    'pages/syntheticArbor/node035',
    'pages/syntheticArbor/node036',
    'pages/syntheticArbor/node037',
    'pages/syntheticArbor/node038',
    'pages/syntheticArbor/node039',
    'pages/syntheticArbor/node040',
    'pages/syntheticArbor/node041',
    'pages/syntheticArbor/node042',
    'pages/syntheticArbor/node043',
    'pages/syntheticArbor/node044',
    'pages/syntheticArbor/node045',
    'pages/syntheticArbor/node046',
    'pages/syntheticArbor/node047',
    'pages/syntheticArbor/node048',
    'pages/syntheticArbor/node049',
    'pages/syntheticArbor/node050',
    'pages/syntheticArbor/node051',
    'pages/syntheticArbor/node052',
    'pages/syntheticArbor/node053',
    'pages/syntheticArbor/node054',
    'pages/syntheticArbor/node055',
    'pages/syntheticArbor/node056',
    'pages/syntheticArbor/node057',
    'pages/syntheticArbor/node058',
    'pages/syntheticArbor/node059',
    'pages/syntheticArbor/node060',
    'pages/syntheticArbor/node061',
    'pages/syntheticArbor/node062',
    'pages/syntheticArbor/node063',
    'pages/syntheticArbor/node064',
    'pages/syntheticArbor/node065',
    'pages/syntheticArbor/node066',
    'pages/syntheticArbor/node067',
    'pages/syntheticArbor/node068',
    'pages/syntheticArbor/node069',
    'pages/syntheticArbor/node070',
    'pages/syntheticArbor/node071',
    'pages/syntheticArbor/node072',
    'pages/syntheticArbor/node073',
    'pages/syntheticArbor/node074',
    'pages/syntheticArbor/node075',
    'pages/syntheticArbor/node076',
    'pages/syntheticArbor/node077',
    'pages/syntheticArbor/node078',
    'pages/syntheticArbor/node079',
    'pages/syntheticArbor/node080',
    'pages/syntheticArbor/node081',
    'pages/syntheticArbor/node082',
    'pages/syntheticArbor/node083',
    'pages/syntheticArbor/node084',
    'pages/syntheticArbor/node085',
    'pages/syntheticArbor/node086',
    'pages/syntheticArbor/node087',
    'pages/syntheticArbor/node088',
    'pages/syntheticArbor/node089',
    'pages/syntheticArbor/node090',
    'pages/syntheticArbor/node091',
    'pages/syntheticArbor/node092',
    'pages/syntheticArbor/node093',
    'pages/syntheticArbor/node094',
    'pages/syntheticArbor/node095',
    'pages/syntheticArbor/node096',
    'pages/syntheticArbor/node097',
    'pages/syntheticArbor/node098',
    'pages/syntheticArbor/node099',
    'pages/syntheticArbor/node100',
    'pages/syntheticArbor/node101',
    'pages/syntheticArbor/node102',
    'pages/syntheticArbor/node103',
    'pages/syntheticArbor/node104',
    'pages/syntheticArbor/node105',
    'pages/syntheticArbor/node106',
    'pages/syntheticArbor/node107',
    'pages/syntheticArbor/node108',
    'pages/syntheticArbor/node109',
    'pages/syntheticArbor/node110',
    'pages/syntheticArbor/node111',
    'pages/syntheticArbor/node112',
    'pages/syntheticArbor/node113',
    'pages/syntheticArbor/node114',
    'pages/syntheticArbor/node115',
    'pages/syntheticArbor/node116',
    'pages/syntheticArbor/node117',
    'pages/syntheticArbor/node118',
    'pages/syntheticArbor/node119',
    'pages/syntheticArbor/node120',
    'pages/syntheticArbor/node121',
    'pages/syntheticArbor/node122',
    'pages/syntheticArbor/node123',
    'pages/syntheticArbor/node124',
    'pages/syntheticArbor/node125',
    'pages/syntheticArbor/node126',
    'pages/syntheticArbor/node127',
    'pages/syntheticArbor/node128',
    'pages/syntheticArbor/node129',
    'pages/syntheticArbor/node130',
    'pages/syntheticArbor/node131',
    'pages/syntheticArbor/node132',
    'pages/syntheticArbor/node133',
    'pages/syntheticArbor/node134',
    'pages/syntheticArbor/node135',
    'pages/syntheticArbor/node136',
    'pages/syntheticArbor/node137',
    'pages/syntheticArbor/node138',
    'pages/syntheticArbor/node139',
    'pages/syntheticArbor/node140',
    'pages/syntheticArbor/node141',
    'pages/syntheticArbor/node142',
    'pages/syntheticArbor/node143',
    'pages/syntheticArbor/node144',
    'pages/syntheticArbor/node145',
    'pages/syntheticArbor/node146',
    'pages/syntheticArbor/node147',
    'pages/syntheticArbor/node148',
    'pages/syntheticArbor/node149',
    'pages/syntheticArbor/node150',
    'pages/syntheticArbor/node151',
    'pages/syntheticArbor/node152',
    'pages/syntheticArbor/node153',
    'pages/syntheticArbor/node154',
    'pages/syntheticArbor/node155',
    'pages/syntheticArbor/node156',
    'pages/syntheticArbor/node157',
    'pages/syntheticArbor/node158',
    'pages/syntheticArbor/node159',
    'pages/syntheticArbor/node160'
  ];

  describe('MegaSyntheticRouteAtlasArborSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteArbor_[A-Za-z0-9_]+_[0-9]{3}$/;
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

