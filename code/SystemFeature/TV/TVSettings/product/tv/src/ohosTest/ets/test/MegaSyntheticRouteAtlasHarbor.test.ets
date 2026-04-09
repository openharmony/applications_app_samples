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
  return /^pages\/syntheticHarbor\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasHarborTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteHarbor_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticHarbor/node001',
    'pages/syntheticHarbor/node002',
    'pages/syntheticHarbor/node003',
    'pages/syntheticHarbor/node004',
    'pages/syntheticHarbor/node005',
    'pages/syntheticHarbor/node006',
    'pages/syntheticHarbor/node007',
    'pages/syntheticHarbor/node008',
    'pages/syntheticHarbor/node009',
    'pages/syntheticHarbor/node010',
    'pages/syntheticHarbor/node011',
    'pages/syntheticHarbor/node012',
    'pages/syntheticHarbor/node013',
    'pages/syntheticHarbor/node014',
    'pages/syntheticHarbor/node015',
    'pages/syntheticHarbor/node016',
    'pages/syntheticHarbor/node017',
    'pages/syntheticHarbor/node018',
    'pages/syntheticHarbor/node019',
    'pages/syntheticHarbor/node020',
    'pages/syntheticHarbor/node021',
    'pages/syntheticHarbor/node022',
    'pages/syntheticHarbor/node023',
    'pages/syntheticHarbor/node024',
    'pages/syntheticHarbor/node025',
    'pages/syntheticHarbor/node026',
    'pages/syntheticHarbor/node027',
    'pages/syntheticHarbor/node028',
    'pages/syntheticHarbor/node029',
    'pages/syntheticHarbor/node030',
    'pages/syntheticHarbor/node031',
    'pages/syntheticHarbor/node032',
    'pages/syntheticHarbor/node033',
    'pages/syntheticHarbor/node034',
    'pages/syntheticHarbor/node035',
    'pages/syntheticHarbor/node036',
    'pages/syntheticHarbor/node037',
    'pages/syntheticHarbor/node038',
    'pages/syntheticHarbor/node039',
    'pages/syntheticHarbor/node040',
    'pages/syntheticHarbor/node041',
    'pages/syntheticHarbor/node042',
    'pages/syntheticHarbor/node043',
    'pages/syntheticHarbor/node044',
    'pages/syntheticHarbor/node045',
    'pages/syntheticHarbor/node046',
    'pages/syntheticHarbor/node047',
    'pages/syntheticHarbor/node048',
    'pages/syntheticHarbor/node049',
    'pages/syntheticHarbor/node050',
    'pages/syntheticHarbor/node051',
    'pages/syntheticHarbor/node052',
    'pages/syntheticHarbor/node053',
    'pages/syntheticHarbor/node054',
    'pages/syntheticHarbor/node055',
    'pages/syntheticHarbor/node056',
    'pages/syntheticHarbor/node057',
    'pages/syntheticHarbor/node058',
    'pages/syntheticHarbor/node059',
    'pages/syntheticHarbor/node060',
    'pages/syntheticHarbor/node061',
    'pages/syntheticHarbor/node062',
    'pages/syntheticHarbor/node063',
    'pages/syntheticHarbor/node064',
    'pages/syntheticHarbor/node065',
    'pages/syntheticHarbor/node066',
    'pages/syntheticHarbor/node067',
    'pages/syntheticHarbor/node068',
    'pages/syntheticHarbor/node069',
    'pages/syntheticHarbor/node070',
    'pages/syntheticHarbor/node071',
    'pages/syntheticHarbor/node072',
    'pages/syntheticHarbor/node073',
    'pages/syntheticHarbor/node074',
    'pages/syntheticHarbor/node075',
    'pages/syntheticHarbor/node076',
    'pages/syntheticHarbor/node077',
    'pages/syntheticHarbor/node078',
    'pages/syntheticHarbor/node079',
    'pages/syntheticHarbor/node080',
    'pages/syntheticHarbor/node081',
    'pages/syntheticHarbor/node082',
    'pages/syntheticHarbor/node083',
    'pages/syntheticHarbor/node084',
    'pages/syntheticHarbor/node085',
    'pages/syntheticHarbor/node086',
    'pages/syntheticHarbor/node087',
    'pages/syntheticHarbor/node088',
    'pages/syntheticHarbor/node089',
    'pages/syntheticHarbor/node090',
    'pages/syntheticHarbor/node091',
    'pages/syntheticHarbor/node092',
    'pages/syntheticHarbor/node093',
    'pages/syntheticHarbor/node094',
    'pages/syntheticHarbor/node095',
    'pages/syntheticHarbor/node096',
    'pages/syntheticHarbor/node097',
    'pages/syntheticHarbor/node098',
    'pages/syntheticHarbor/node099',
    'pages/syntheticHarbor/node100',
    'pages/syntheticHarbor/node101',
    'pages/syntheticHarbor/node102',
    'pages/syntheticHarbor/node103',
    'pages/syntheticHarbor/node104',
    'pages/syntheticHarbor/node105',
    'pages/syntheticHarbor/node106',
    'pages/syntheticHarbor/node107',
    'pages/syntheticHarbor/node108',
    'pages/syntheticHarbor/node109',
    'pages/syntheticHarbor/node110',
    'pages/syntheticHarbor/node111',
    'pages/syntheticHarbor/node112',
    'pages/syntheticHarbor/node113',
    'pages/syntheticHarbor/node114',
    'pages/syntheticHarbor/node115',
    'pages/syntheticHarbor/node116',
    'pages/syntheticHarbor/node117',
    'pages/syntheticHarbor/node118',
    'pages/syntheticHarbor/node119',
    'pages/syntheticHarbor/node120',
    'pages/syntheticHarbor/node121',
    'pages/syntheticHarbor/node122',
    'pages/syntheticHarbor/node123',
    'pages/syntheticHarbor/node124',
    'pages/syntheticHarbor/node125',
    'pages/syntheticHarbor/node126',
    'pages/syntheticHarbor/node127',
    'pages/syntheticHarbor/node128',
    'pages/syntheticHarbor/node129',
    'pages/syntheticHarbor/node130',
    'pages/syntheticHarbor/node131',
    'pages/syntheticHarbor/node132',
    'pages/syntheticHarbor/node133',
    'pages/syntheticHarbor/node134',
    'pages/syntheticHarbor/node135',
    'pages/syntheticHarbor/node136',
    'pages/syntheticHarbor/node137',
    'pages/syntheticHarbor/node138',
    'pages/syntheticHarbor/node139',
    'pages/syntheticHarbor/node140',
    'pages/syntheticHarbor/node141',
    'pages/syntheticHarbor/node142',
    'pages/syntheticHarbor/node143',
    'pages/syntheticHarbor/node144',
    'pages/syntheticHarbor/node145',
    'pages/syntheticHarbor/node146',
    'pages/syntheticHarbor/node147',
    'pages/syntheticHarbor/node148',
    'pages/syntheticHarbor/node149',
    'pages/syntheticHarbor/node150',
    'pages/syntheticHarbor/node151',
    'pages/syntheticHarbor/node152',
    'pages/syntheticHarbor/node153',
    'pages/syntheticHarbor/node154',
    'pages/syntheticHarbor/node155',
    'pages/syntheticHarbor/node156',
    'pages/syntheticHarbor/node157',
    'pages/syntheticHarbor/node158',
    'pages/syntheticHarbor/node159',
    'pages/syntheticHarbor/node160'
  ];

  describe('MegaSyntheticRouteAtlasHarborSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteHarbor_[A-Za-z0-9_]+_[0-9]{3}$/;
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

