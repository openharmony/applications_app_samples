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
  return /^pages\/syntheticXi\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasXiTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteXi_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticXi/node001',
    'pages/syntheticXi/node002',
    'pages/syntheticXi/node003',
    'pages/syntheticXi/node004',
    'pages/syntheticXi/node005',
    'pages/syntheticXi/node006',
    'pages/syntheticXi/node007',
    'pages/syntheticXi/node008',
    'pages/syntheticXi/node009',
    'pages/syntheticXi/node010',
    'pages/syntheticXi/node011',
    'pages/syntheticXi/node012',
    'pages/syntheticXi/node013',
    'pages/syntheticXi/node014',
    'pages/syntheticXi/node015',
    'pages/syntheticXi/node016',
    'pages/syntheticXi/node017',
    'pages/syntheticXi/node018',
    'pages/syntheticXi/node019',
    'pages/syntheticXi/node020',
    'pages/syntheticXi/node021',
    'pages/syntheticXi/node022',
    'pages/syntheticXi/node023',
    'pages/syntheticXi/node024',
    'pages/syntheticXi/node025',
    'pages/syntheticXi/node026',
    'pages/syntheticXi/node027',
    'pages/syntheticXi/node028',
    'pages/syntheticXi/node029',
    'pages/syntheticXi/node030',
    'pages/syntheticXi/node031',
    'pages/syntheticXi/node032',
    'pages/syntheticXi/node033',
    'pages/syntheticXi/node034',
    'pages/syntheticXi/node035',
    'pages/syntheticXi/node036',
    'pages/syntheticXi/node037',
    'pages/syntheticXi/node038',
    'pages/syntheticXi/node039',
    'pages/syntheticXi/node040',
    'pages/syntheticXi/node041',
    'pages/syntheticXi/node042',
    'pages/syntheticXi/node043',
    'pages/syntheticXi/node044',
    'pages/syntheticXi/node045',
    'pages/syntheticXi/node046',
    'pages/syntheticXi/node047',
    'pages/syntheticXi/node048',
    'pages/syntheticXi/node049',
    'pages/syntheticXi/node050',
    'pages/syntheticXi/node051',
    'pages/syntheticXi/node052',
    'pages/syntheticXi/node053',
    'pages/syntheticXi/node054',
    'pages/syntheticXi/node055',
    'pages/syntheticXi/node056',
    'pages/syntheticXi/node057',
    'pages/syntheticXi/node058',
    'pages/syntheticXi/node059',
    'pages/syntheticXi/node060',
    'pages/syntheticXi/node061',
    'pages/syntheticXi/node062',
    'pages/syntheticXi/node063',
    'pages/syntheticXi/node064',
    'pages/syntheticXi/node065',
    'pages/syntheticXi/node066',
    'pages/syntheticXi/node067',
    'pages/syntheticXi/node068',
    'pages/syntheticXi/node069',
    'pages/syntheticXi/node070',
    'pages/syntheticXi/node071',
    'pages/syntheticXi/node072',
    'pages/syntheticXi/node073',
    'pages/syntheticXi/node074',
    'pages/syntheticXi/node075',
    'pages/syntheticXi/node076',
    'pages/syntheticXi/node077',
    'pages/syntheticXi/node078',
    'pages/syntheticXi/node079',
    'pages/syntheticXi/node080',
    'pages/syntheticXi/node081',
    'pages/syntheticXi/node082',
    'pages/syntheticXi/node083',
    'pages/syntheticXi/node084',
    'pages/syntheticXi/node085',
    'pages/syntheticXi/node086',
    'pages/syntheticXi/node087',
    'pages/syntheticXi/node088',
    'pages/syntheticXi/node089',
    'pages/syntheticXi/node090',
    'pages/syntheticXi/node091',
    'pages/syntheticXi/node092',
    'pages/syntheticXi/node093',
    'pages/syntheticXi/node094',
    'pages/syntheticXi/node095',
    'pages/syntheticXi/node096',
    'pages/syntheticXi/node097',
    'pages/syntheticXi/node098',
    'pages/syntheticXi/node099',
    'pages/syntheticXi/node100',
    'pages/syntheticXi/node101',
    'pages/syntheticXi/node102',
    'pages/syntheticXi/node103',
    'pages/syntheticXi/node104',
    'pages/syntheticXi/node105',
    'pages/syntheticXi/node106',
    'pages/syntheticXi/node107',
    'pages/syntheticXi/node108',
    'pages/syntheticXi/node109',
    'pages/syntheticXi/node110',
    'pages/syntheticXi/node111',
    'pages/syntheticXi/node112',
    'pages/syntheticXi/node113',
    'pages/syntheticXi/node114',
    'pages/syntheticXi/node115',
    'pages/syntheticXi/node116',
    'pages/syntheticXi/node117',
    'pages/syntheticXi/node118',
    'pages/syntheticXi/node119',
    'pages/syntheticXi/node120',
    'pages/syntheticXi/node121',
    'pages/syntheticXi/node122',
    'pages/syntheticXi/node123',
    'pages/syntheticXi/node124',
    'pages/syntheticXi/node125',
    'pages/syntheticXi/node126',
    'pages/syntheticXi/node127',
    'pages/syntheticXi/node128',
    'pages/syntheticXi/node129',
    'pages/syntheticXi/node130',
    'pages/syntheticXi/node131',
    'pages/syntheticXi/node132',
    'pages/syntheticXi/node133',
    'pages/syntheticXi/node134',
    'pages/syntheticXi/node135',
    'pages/syntheticXi/node136',
    'pages/syntheticXi/node137',
    'pages/syntheticXi/node138',
    'pages/syntheticXi/node139',
    'pages/syntheticXi/node140',
    'pages/syntheticXi/node141',
    'pages/syntheticXi/node142',
    'pages/syntheticXi/node143',
    'pages/syntheticXi/node144',
    'pages/syntheticXi/node145',
    'pages/syntheticXi/node146',
    'pages/syntheticXi/node147',
    'pages/syntheticXi/node148',
    'pages/syntheticXi/node149',
    'pages/syntheticXi/node150',
    'pages/syntheticXi/node151',
    'pages/syntheticXi/node152',
    'pages/syntheticXi/node153',
    'pages/syntheticXi/node154',
    'pages/syntheticXi/node155',
    'pages/syntheticXi/node156',
    'pages/syntheticXi/node157',
    'pages/syntheticXi/node158',
    'pages/syntheticXi/node159',
    'pages/syntheticXi/node160'
  ];

  describe('MegaSyntheticRouteAtlasXiSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteXi_[A-Za-z0-9_]+_[0-9]{3}$/;
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

