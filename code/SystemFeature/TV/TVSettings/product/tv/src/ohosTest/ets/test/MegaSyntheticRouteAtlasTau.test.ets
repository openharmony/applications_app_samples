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
  return /^pages\/syntheticTau\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasTauTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteTau_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticTau/node001',
    'pages/syntheticTau/node002',
    'pages/syntheticTau/node003',
    'pages/syntheticTau/node004',
    'pages/syntheticTau/node005',
    'pages/syntheticTau/node006',
    'pages/syntheticTau/node007',
    'pages/syntheticTau/node008',
    'pages/syntheticTau/node009',
    'pages/syntheticTau/node010',
    'pages/syntheticTau/node011',
    'pages/syntheticTau/node012',
    'pages/syntheticTau/node013',
    'pages/syntheticTau/node014',
    'pages/syntheticTau/node015',
    'pages/syntheticTau/node016',
    'pages/syntheticTau/node017',
    'pages/syntheticTau/node018',
    'pages/syntheticTau/node019',
    'pages/syntheticTau/node020',
    'pages/syntheticTau/node021',
    'pages/syntheticTau/node022',
    'pages/syntheticTau/node023',
    'pages/syntheticTau/node024',
    'pages/syntheticTau/node025',
    'pages/syntheticTau/node026',
    'pages/syntheticTau/node027',
    'pages/syntheticTau/node028',
    'pages/syntheticTau/node029',
    'pages/syntheticTau/node030',
    'pages/syntheticTau/node031',
    'pages/syntheticTau/node032',
    'pages/syntheticTau/node033',
    'pages/syntheticTau/node034',
    'pages/syntheticTau/node035',
    'pages/syntheticTau/node036',
    'pages/syntheticTau/node037',
    'pages/syntheticTau/node038',
    'pages/syntheticTau/node039',
    'pages/syntheticTau/node040',
    'pages/syntheticTau/node041',
    'pages/syntheticTau/node042',
    'pages/syntheticTau/node043',
    'pages/syntheticTau/node044',
    'pages/syntheticTau/node045',
    'pages/syntheticTau/node046',
    'pages/syntheticTau/node047',
    'pages/syntheticTau/node048',
    'pages/syntheticTau/node049',
    'pages/syntheticTau/node050',
    'pages/syntheticTau/node051',
    'pages/syntheticTau/node052',
    'pages/syntheticTau/node053',
    'pages/syntheticTau/node054',
    'pages/syntheticTau/node055',
    'pages/syntheticTau/node056',
    'pages/syntheticTau/node057',
    'pages/syntheticTau/node058',
    'pages/syntheticTau/node059',
    'pages/syntheticTau/node060',
    'pages/syntheticTau/node061',
    'pages/syntheticTau/node062',
    'pages/syntheticTau/node063',
    'pages/syntheticTau/node064',
    'pages/syntheticTau/node065',
    'pages/syntheticTau/node066',
    'pages/syntheticTau/node067',
    'pages/syntheticTau/node068',
    'pages/syntheticTau/node069',
    'pages/syntheticTau/node070',
    'pages/syntheticTau/node071',
    'pages/syntheticTau/node072',
    'pages/syntheticTau/node073',
    'pages/syntheticTau/node074',
    'pages/syntheticTau/node075',
    'pages/syntheticTau/node076',
    'pages/syntheticTau/node077',
    'pages/syntheticTau/node078',
    'pages/syntheticTau/node079',
    'pages/syntheticTau/node080',
    'pages/syntheticTau/node081',
    'pages/syntheticTau/node082',
    'pages/syntheticTau/node083',
    'pages/syntheticTau/node084',
    'pages/syntheticTau/node085',
    'pages/syntheticTau/node086',
    'pages/syntheticTau/node087',
    'pages/syntheticTau/node088',
    'pages/syntheticTau/node089',
    'pages/syntheticTau/node090',
    'pages/syntheticTau/node091',
    'pages/syntheticTau/node092',
    'pages/syntheticTau/node093',
    'pages/syntheticTau/node094',
    'pages/syntheticTau/node095',
    'pages/syntheticTau/node096',
    'pages/syntheticTau/node097',
    'pages/syntheticTau/node098',
    'pages/syntheticTau/node099',
    'pages/syntheticTau/node100',
    'pages/syntheticTau/node101',
    'pages/syntheticTau/node102',
    'pages/syntheticTau/node103',
    'pages/syntheticTau/node104',
    'pages/syntheticTau/node105',
    'pages/syntheticTau/node106',
    'pages/syntheticTau/node107',
    'pages/syntheticTau/node108',
    'pages/syntheticTau/node109',
    'pages/syntheticTau/node110',
    'pages/syntheticTau/node111',
    'pages/syntheticTau/node112',
    'pages/syntheticTau/node113',
    'pages/syntheticTau/node114',
    'pages/syntheticTau/node115',
    'pages/syntheticTau/node116',
    'pages/syntheticTau/node117',
    'pages/syntheticTau/node118',
    'pages/syntheticTau/node119',
    'pages/syntheticTau/node120',
    'pages/syntheticTau/node121',
    'pages/syntheticTau/node122',
    'pages/syntheticTau/node123',
    'pages/syntheticTau/node124',
    'pages/syntheticTau/node125',
    'pages/syntheticTau/node126',
    'pages/syntheticTau/node127',
    'pages/syntheticTau/node128',
    'pages/syntheticTau/node129',
    'pages/syntheticTau/node130',
    'pages/syntheticTau/node131',
    'pages/syntheticTau/node132',
    'pages/syntheticTau/node133',
    'pages/syntheticTau/node134',
    'pages/syntheticTau/node135',
    'pages/syntheticTau/node136',
    'pages/syntheticTau/node137',
    'pages/syntheticTau/node138',
    'pages/syntheticTau/node139',
    'pages/syntheticTau/node140',
    'pages/syntheticTau/node141',
    'pages/syntheticTau/node142',
    'pages/syntheticTau/node143',
    'pages/syntheticTau/node144',
    'pages/syntheticTau/node145',
    'pages/syntheticTau/node146',
    'pages/syntheticTau/node147',
    'pages/syntheticTau/node148',
    'pages/syntheticTau/node149',
    'pages/syntheticTau/node150',
    'pages/syntheticTau/node151',
    'pages/syntheticTau/node152',
    'pages/syntheticTau/node153',
    'pages/syntheticTau/node154',
    'pages/syntheticTau/node155',
    'pages/syntheticTau/node156',
    'pages/syntheticTau/node157',
    'pages/syntheticTau/node158',
    'pages/syntheticTau/node159',
    'pages/syntheticTau/node160'
  ];

  describe('MegaSyntheticRouteAtlasTauSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteTau_[A-Za-z0-9_]+_[0-9]{3}$/;
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

