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
  return /^pages\/syntheticPsi\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasPsiTest() {
  const casePrefix = 'Settings_MegaSyntheticRoutePsi_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticPsi/node001',
    'pages/syntheticPsi/node002',
    'pages/syntheticPsi/node003',
    'pages/syntheticPsi/node004',
    'pages/syntheticPsi/node005',
    'pages/syntheticPsi/node006',
    'pages/syntheticPsi/node007',
    'pages/syntheticPsi/node008',
    'pages/syntheticPsi/node009',
    'pages/syntheticPsi/node010',
    'pages/syntheticPsi/node011',
    'pages/syntheticPsi/node012',
    'pages/syntheticPsi/node013',
    'pages/syntheticPsi/node014',
    'pages/syntheticPsi/node015',
    'pages/syntheticPsi/node016',
    'pages/syntheticPsi/node017',
    'pages/syntheticPsi/node018',
    'pages/syntheticPsi/node019',
    'pages/syntheticPsi/node020',
    'pages/syntheticPsi/node021',
    'pages/syntheticPsi/node022',
    'pages/syntheticPsi/node023',
    'pages/syntheticPsi/node024',
    'pages/syntheticPsi/node025',
    'pages/syntheticPsi/node026',
    'pages/syntheticPsi/node027',
    'pages/syntheticPsi/node028',
    'pages/syntheticPsi/node029',
    'pages/syntheticPsi/node030',
    'pages/syntheticPsi/node031',
    'pages/syntheticPsi/node032',
    'pages/syntheticPsi/node033',
    'pages/syntheticPsi/node034',
    'pages/syntheticPsi/node035',
    'pages/syntheticPsi/node036',
    'pages/syntheticPsi/node037',
    'pages/syntheticPsi/node038',
    'pages/syntheticPsi/node039',
    'pages/syntheticPsi/node040',
    'pages/syntheticPsi/node041',
    'pages/syntheticPsi/node042',
    'pages/syntheticPsi/node043',
    'pages/syntheticPsi/node044',
    'pages/syntheticPsi/node045',
    'pages/syntheticPsi/node046',
    'pages/syntheticPsi/node047',
    'pages/syntheticPsi/node048',
    'pages/syntheticPsi/node049',
    'pages/syntheticPsi/node050',
    'pages/syntheticPsi/node051',
    'pages/syntheticPsi/node052',
    'pages/syntheticPsi/node053',
    'pages/syntheticPsi/node054',
    'pages/syntheticPsi/node055',
    'pages/syntheticPsi/node056',
    'pages/syntheticPsi/node057',
    'pages/syntheticPsi/node058',
    'pages/syntheticPsi/node059',
    'pages/syntheticPsi/node060',
    'pages/syntheticPsi/node061',
    'pages/syntheticPsi/node062',
    'pages/syntheticPsi/node063',
    'pages/syntheticPsi/node064',
    'pages/syntheticPsi/node065',
    'pages/syntheticPsi/node066',
    'pages/syntheticPsi/node067',
    'pages/syntheticPsi/node068',
    'pages/syntheticPsi/node069',
    'pages/syntheticPsi/node070',
    'pages/syntheticPsi/node071',
    'pages/syntheticPsi/node072',
    'pages/syntheticPsi/node073',
    'pages/syntheticPsi/node074',
    'pages/syntheticPsi/node075',
    'pages/syntheticPsi/node076',
    'pages/syntheticPsi/node077',
    'pages/syntheticPsi/node078',
    'pages/syntheticPsi/node079',
    'pages/syntheticPsi/node080',
    'pages/syntheticPsi/node081',
    'pages/syntheticPsi/node082',
    'pages/syntheticPsi/node083',
    'pages/syntheticPsi/node084',
    'pages/syntheticPsi/node085',
    'pages/syntheticPsi/node086',
    'pages/syntheticPsi/node087',
    'pages/syntheticPsi/node088',
    'pages/syntheticPsi/node089',
    'pages/syntheticPsi/node090',
    'pages/syntheticPsi/node091',
    'pages/syntheticPsi/node092',
    'pages/syntheticPsi/node093',
    'pages/syntheticPsi/node094',
    'pages/syntheticPsi/node095',
    'pages/syntheticPsi/node096',
    'pages/syntheticPsi/node097',
    'pages/syntheticPsi/node098',
    'pages/syntheticPsi/node099',
    'pages/syntheticPsi/node100',
    'pages/syntheticPsi/node101',
    'pages/syntheticPsi/node102',
    'pages/syntheticPsi/node103',
    'pages/syntheticPsi/node104',
    'pages/syntheticPsi/node105',
    'pages/syntheticPsi/node106',
    'pages/syntheticPsi/node107',
    'pages/syntheticPsi/node108',
    'pages/syntheticPsi/node109',
    'pages/syntheticPsi/node110',
    'pages/syntheticPsi/node111',
    'pages/syntheticPsi/node112',
    'pages/syntheticPsi/node113',
    'pages/syntheticPsi/node114',
    'pages/syntheticPsi/node115',
    'pages/syntheticPsi/node116',
    'pages/syntheticPsi/node117',
    'pages/syntheticPsi/node118',
    'pages/syntheticPsi/node119',
    'pages/syntheticPsi/node120',
    'pages/syntheticPsi/node121',
    'pages/syntheticPsi/node122',
    'pages/syntheticPsi/node123',
    'pages/syntheticPsi/node124',
    'pages/syntheticPsi/node125',
    'pages/syntheticPsi/node126',
    'pages/syntheticPsi/node127',
    'pages/syntheticPsi/node128',
    'pages/syntheticPsi/node129',
    'pages/syntheticPsi/node130',
    'pages/syntheticPsi/node131',
    'pages/syntheticPsi/node132',
    'pages/syntheticPsi/node133',
    'pages/syntheticPsi/node134',
    'pages/syntheticPsi/node135',
    'pages/syntheticPsi/node136',
    'pages/syntheticPsi/node137',
    'pages/syntheticPsi/node138',
    'pages/syntheticPsi/node139',
    'pages/syntheticPsi/node140',
    'pages/syntheticPsi/node141',
    'pages/syntheticPsi/node142',
    'pages/syntheticPsi/node143',
    'pages/syntheticPsi/node144',
    'pages/syntheticPsi/node145',
    'pages/syntheticPsi/node146',
    'pages/syntheticPsi/node147',
    'pages/syntheticPsi/node148',
    'pages/syntheticPsi/node149',
    'pages/syntheticPsi/node150',
    'pages/syntheticPsi/node151',
    'pages/syntheticPsi/node152',
    'pages/syntheticPsi/node153',
    'pages/syntheticPsi/node154',
    'pages/syntheticPsi/node155',
    'pages/syntheticPsi/node156',
    'pages/syntheticPsi/node157',
    'pages/syntheticPsi/node158',
    'pages/syntheticPsi/node159',
    'pages/syntheticPsi/node160'
  ];

  describe('MegaSyntheticRouteAtlasPsiSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRoutePsi_[A-Za-z0-9_]+_[0-9]{3}$/;
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

