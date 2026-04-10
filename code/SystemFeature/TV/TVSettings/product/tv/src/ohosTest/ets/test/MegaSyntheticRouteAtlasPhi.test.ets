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
  return /^pages\/syntheticPhi\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasPhiTest() {
  const casePrefix = 'Settings_MegaSyntheticRoutePhi_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticPhi/node001',
    'pages/syntheticPhi/node002',
    'pages/syntheticPhi/node003',
    'pages/syntheticPhi/node004',
    'pages/syntheticPhi/node005',
    'pages/syntheticPhi/node006',
    'pages/syntheticPhi/node007',
    'pages/syntheticPhi/node008',
    'pages/syntheticPhi/node009',
    'pages/syntheticPhi/node010',
    'pages/syntheticPhi/node011',
    'pages/syntheticPhi/node012',
    'pages/syntheticPhi/node013',
    'pages/syntheticPhi/node014',
    'pages/syntheticPhi/node015',
    'pages/syntheticPhi/node016',
    'pages/syntheticPhi/node017',
    'pages/syntheticPhi/node018',
    'pages/syntheticPhi/node019',
    'pages/syntheticPhi/node020',
    'pages/syntheticPhi/node021',
    'pages/syntheticPhi/node022',
    'pages/syntheticPhi/node023',
    'pages/syntheticPhi/node024',
    'pages/syntheticPhi/node025',
    'pages/syntheticPhi/node026',
    'pages/syntheticPhi/node027',
    'pages/syntheticPhi/node028',
    'pages/syntheticPhi/node029',
    'pages/syntheticPhi/node030',
    'pages/syntheticPhi/node031',
    'pages/syntheticPhi/node032',
    'pages/syntheticPhi/node033',
    'pages/syntheticPhi/node034',
    'pages/syntheticPhi/node035',
    'pages/syntheticPhi/node036',
    'pages/syntheticPhi/node037',
    'pages/syntheticPhi/node038',
    'pages/syntheticPhi/node039',
    'pages/syntheticPhi/node040',
    'pages/syntheticPhi/node041',
    'pages/syntheticPhi/node042',
    'pages/syntheticPhi/node043',
    'pages/syntheticPhi/node044',
    'pages/syntheticPhi/node045',
    'pages/syntheticPhi/node046',
    'pages/syntheticPhi/node047',
    'pages/syntheticPhi/node048',
    'pages/syntheticPhi/node049',
    'pages/syntheticPhi/node050',
    'pages/syntheticPhi/node051',
    'pages/syntheticPhi/node052',
    'pages/syntheticPhi/node053',
    'pages/syntheticPhi/node054',
    'pages/syntheticPhi/node055',
    'pages/syntheticPhi/node056',
    'pages/syntheticPhi/node057',
    'pages/syntheticPhi/node058',
    'pages/syntheticPhi/node059',
    'pages/syntheticPhi/node060',
    'pages/syntheticPhi/node061',
    'pages/syntheticPhi/node062',
    'pages/syntheticPhi/node063',
    'pages/syntheticPhi/node064',
    'pages/syntheticPhi/node065',
    'pages/syntheticPhi/node066',
    'pages/syntheticPhi/node067',
    'pages/syntheticPhi/node068',
    'pages/syntheticPhi/node069',
    'pages/syntheticPhi/node070',
    'pages/syntheticPhi/node071',
    'pages/syntheticPhi/node072',
    'pages/syntheticPhi/node073',
    'pages/syntheticPhi/node074',
    'pages/syntheticPhi/node075',
    'pages/syntheticPhi/node076',
    'pages/syntheticPhi/node077',
    'pages/syntheticPhi/node078',
    'pages/syntheticPhi/node079',
    'pages/syntheticPhi/node080',
    'pages/syntheticPhi/node081',
    'pages/syntheticPhi/node082',
    'pages/syntheticPhi/node083',
    'pages/syntheticPhi/node084',
    'pages/syntheticPhi/node085',
    'pages/syntheticPhi/node086',
    'pages/syntheticPhi/node087',
    'pages/syntheticPhi/node088',
    'pages/syntheticPhi/node089',
    'pages/syntheticPhi/node090',
    'pages/syntheticPhi/node091',
    'pages/syntheticPhi/node092',
    'pages/syntheticPhi/node093',
    'pages/syntheticPhi/node094',
    'pages/syntheticPhi/node095',
    'pages/syntheticPhi/node096',
    'pages/syntheticPhi/node097',
    'pages/syntheticPhi/node098',
    'pages/syntheticPhi/node099',
    'pages/syntheticPhi/node100',
    'pages/syntheticPhi/node101',
    'pages/syntheticPhi/node102',
    'pages/syntheticPhi/node103',
    'pages/syntheticPhi/node104',
    'pages/syntheticPhi/node105',
    'pages/syntheticPhi/node106',
    'pages/syntheticPhi/node107',
    'pages/syntheticPhi/node108',
    'pages/syntheticPhi/node109',
    'pages/syntheticPhi/node110',
    'pages/syntheticPhi/node111',
    'pages/syntheticPhi/node112',
    'pages/syntheticPhi/node113',
    'pages/syntheticPhi/node114',
    'pages/syntheticPhi/node115',
    'pages/syntheticPhi/node116',
    'pages/syntheticPhi/node117',
    'pages/syntheticPhi/node118',
    'pages/syntheticPhi/node119',
    'pages/syntheticPhi/node120',
    'pages/syntheticPhi/node121',
    'pages/syntheticPhi/node122',
    'pages/syntheticPhi/node123',
    'pages/syntheticPhi/node124',
    'pages/syntheticPhi/node125',
    'pages/syntheticPhi/node126',
    'pages/syntheticPhi/node127',
    'pages/syntheticPhi/node128',
    'pages/syntheticPhi/node129',
    'pages/syntheticPhi/node130',
    'pages/syntheticPhi/node131',
    'pages/syntheticPhi/node132',
    'pages/syntheticPhi/node133',
    'pages/syntheticPhi/node134',
    'pages/syntheticPhi/node135',
    'pages/syntheticPhi/node136',
    'pages/syntheticPhi/node137',
    'pages/syntheticPhi/node138',
    'pages/syntheticPhi/node139',
    'pages/syntheticPhi/node140',
    'pages/syntheticPhi/node141',
    'pages/syntheticPhi/node142',
    'pages/syntheticPhi/node143',
    'pages/syntheticPhi/node144',
    'pages/syntheticPhi/node145',
    'pages/syntheticPhi/node146',
    'pages/syntheticPhi/node147',
    'pages/syntheticPhi/node148',
    'pages/syntheticPhi/node149',
    'pages/syntheticPhi/node150',
    'pages/syntheticPhi/node151',
    'pages/syntheticPhi/node152',
    'pages/syntheticPhi/node153',
    'pages/syntheticPhi/node154',
    'pages/syntheticPhi/node155',
    'pages/syntheticPhi/node156',
    'pages/syntheticPhi/node157',
    'pages/syntheticPhi/node158',
    'pages/syntheticPhi/node159',
    'pages/syntheticPhi/node160'
  ];

  describe('MegaSyntheticRouteAtlasPhiSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRoutePhi_[A-Za-z0-9_]+_[0-9]{3}$/;
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

