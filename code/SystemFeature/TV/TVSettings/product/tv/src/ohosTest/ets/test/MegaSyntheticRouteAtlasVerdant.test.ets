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
  return /^pages\/syntheticVerdant\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasVerdantTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteVerdant_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticVerdant/node001',
    'pages/syntheticVerdant/node002',
    'pages/syntheticVerdant/node003',
    'pages/syntheticVerdant/node004',
    'pages/syntheticVerdant/node005',
    'pages/syntheticVerdant/node006',
    'pages/syntheticVerdant/node007',
    'pages/syntheticVerdant/node008',
    'pages/syntheticVerdant/node009',
    'pages/syntheticVerdant/node010',
    'pages/syntheticVerdant/node011',
    'pages/syntheticVerdant/node012',
    'pages/syntheticVerdant/node013',
    'pages/syntheticVerdant/node014',
    'pages/syntheticVerdant/node015',
    'pages/syntheticVerdant/node016',
    'pages/syntheticVerdant/node017',
    'pages/syntheticVerdant/node018',
    'pages/syntheticVerdant/node019',
    'pages/syntheticVerdant/node020',
    'pages/syntheticVerdant/node021',
    'pages/syntheticVerdant/node022',
    'pages/syntheticVerdant/node023',
    'pages/syntheticVerdant/node024',
    'pages/syntheticVerdant/node025',
    'pages/syntheticVerdant/node026',
    'pages/syntheticVerdant/node027',
    'pages/syntheticVerdant/node028',
    'pages/syntheticVerdant/node029',
    'pages/syntheticVerdant/node030',
    'pages/syntheticVerdant/node031',
    'pages/syntheticVerdant/node032',
    'pages/syntheticVerdant/node033',
    'pages/syntheticVerdant/node034',
    'pages/syntheticVerdant/node035',
    'pages/syntheticVerdant/node036',
    'pages/syntheticVerdant/node037',
    'pages/syntheticVerdant/node038',
    'pages/syntheticVerdant/node039',
    'pages/syntheticVerdant/node040',
    'pages/syntheticVerdant/node041',
    'pages/syntheticVerdant/node042',
    'pages/syntheticVerdant/node043',
    'pages/syntheticVerdant/node044',
    'pages/syntheticVerdant/node045',
    'pages/syntheticVerdant/node046',
    'pages/syntheticVerdant/node047',
    'pages/syntheticVerdant/node048',
    'pages/syntheticVerdant/node049',
    'pages/syntheticVerdant/node050',
    'pages/syntheticVerdant/node051',
    'pages/syntheticVerdant/node052',
    'pages/syntheticVerdant/node053',
    'pages/syntheticVerdant/node054',
    'pages/syntheticVerdant/node055',
    'pages/syntheticVerdant/node056',
    'pages/syntheticVerdant/node057',
    'pages/syntheticVerdant/node058',
    'pages/syntheticVerdant/node059',
    'pages/syntheticVerdant/node060',
    'pages/syntheticVerdant/node061',
    'pages/syntheticVerdant/node062',
    'pages/syntheticVerdant/node063',
    'pages/syntheticVerdant/node064',
    'pages/syntheticVerdant/node065',
    'pages/syntheticVerdant/node066',
    'pages/syntheticVerdant/node067',
    'pages/syntheticVerdant/node068',
    'pages/syntheticVerdant/node069',
    'pages/syntheticVerdant/node070',
    'pages/syntheticVerdant/node071',
    'pages/syntheticVerdant/node072',
    'pages/syntheticVerdant/node073',
    'pages/syntheticVerdant/node074',
    'pages/syntheticVerdant/node075',
    'pages/syntheticVerdant/node076',
    'pages/syntheticVerdant/node077',
    'pages/syntheticVerdant/node078',
    'pages/syntheticVerdant/node079',
    'pages/syntheticVerdant/node080',
    'pages/syntheticVerdant/node081',
    'pages/syntheticVerdant/node082',
    'pages/syntheticVerdant/node083',
    'pages/syntheticVerdant/node084',
    'pages/syntheticVerdant/node085',
    'pages/syntheticVerdant/node086',
    'pages/syntheticVerdant/node087',
    'pages/syntheticVerdant/node088',
    'pages/syntheticVerdant/node089',
    'pages/syntheticVerdant/node090',
    'pages/syntheticVerdant/node091',
    'pages/syntheticVerdant/node092',
    'pages/syntheticVerdant/node093',
    'pages/syntheticVerdant/node094',
    'pages/syntheticVerdant/node095',
    'pages/syntheticVerdant/node096',
    'pages/syntheticVerdant/node097',
    'pages/syntheticVerdant/node098',
    'pages/syntheticVerdant/node099',
    'pages/syntheticVerdant/node100',
    'pages/syntheticVerdant/node101',
    'pages/syntheticVerdant/node102',
    'pages/syntheticVerdant/node103',
    'pages/syntheticVerdant/node104',
    'pages/syntheticVerdant/node105',
    'pages/syntheticVerdant/node106',
    'pages/syntheticVerdant/node107',
    'pages/syntheticVerdant/node108',
    'pages/syntheticVerdant/node109',
    'pages/syntheticVerdant/node110',
    'pages/syntheticVerdant/node111',
    'pages/syntheticVerdant/node112',
    'pages/syntheticVerdant/node113',
    'pages/syntheticVerdant/node114',
    'pages/syntheticVerdant/node115',
    'pages/syntheticVerdant/node116',
    'pages/syntheticVerdant/node117',
    'pages/syntheticVerdant/node118',
    'pages/syntheticVerdant/node119',
    'pages/syntheticVerdant/node120',
    'pages/syntheticVerdant/node121',
    'pages/syntheticVerdant/node122',
    'pages/syntheticVerdant/node123',
    'pages/syntheticVerdant/node124',
    'pages/syntheticVerdant/node125',
    'pages/syntheticVerdant/node126',
    'pages/syntheticVerdant/node127',
    'pages/syntheticVerdant/node128',
    'pages/syntheticVerdant/node129',
    'pages/syntheticVerdant/node130',
    'pages/syntheticVerdant/node131',
    'pages/syntheticVerdant/node132',
    'pages/syntheticVerdant/node133',
    'pages/syntheticVerdant/node134',
    'pages/syntheticVerdant/node135',
    'pages/syntheticVerdant/node136',
    'pages/syntheticVerdant/node137',
    'pages/syntheticVerdant/node138',
    'pages/syntheticVerdant/node139',
    'pages/syntheticVerdant/node140',
    'pages/syntheticVerdant/node141',
    'pages/syntheticVerdant/node142',
    'pages/syntheticVerdant/node143',
    'pages/syntheticVerdant/node144',
    'pages/syntheticVerdant/node145',
    'pages/syntheticVerdant/node146',
    'pages/syntheticVerdant/node147',
    'pages/syntheticVerdant/node148',
    'pages/syntheticVerdant/node149',
    'pages/syntheticVerdant/node150',
    'pages/syntheticVerdant/node151',
    'pages/syntheticVerdant/node152',
    'pages/syntheticVerdant/node153',
    'pages/syntheticVerdant/node154',
    'pages/syntheticVerdant/node155',
    'pages/syntheticVerdant/node156',
    'pages/syntheticVerdant/node157',
    'pages/syntheticVerdant/node158',
    'pages/syntheticVerdant/node159',
    'pages/syntheticVerdant/node160'
  ];

  describe('MegaSyntheticRouteAtlasVerdantSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteVerdant_[A-Za-z0-9_]+_[0-9]{3}$/;
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

