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
  return /^pages\/syntheticValor\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasValorTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteValor_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticValor/node001',
    'pages/syntheticValor/node002',
    'pages/syntheticValor/node003',
    'pages/syntheticValor/node004',
    'pages/syntheticValor/node005',
    'pages/syntheticValor/node006',
    'pages/syntheticValor/node007',
    'pages/syntheticValor/node008',
    'pages/syntheticValor/node009',
    'pages/syntheticValor/node010',
    'pages/syntheticValor/node011',
    'pages/syntheticValor/node012',
    'pages/syntheticValor/node013',
    'pages/syntheticValor/node014',
    'pages/syntheticValor/node015',
    'pages/syntheticValor/node016',
    'pages/syntheticValor/node017',
    'pages/syntheticValor/node018',
    'pages/syntheticValor/node019',
    'pages/syntheticValor/node020',
    'pages/syntheticValor/node021',
    'pages/syntheticValor/node022',
    'pages/syntheticValor/node023',
    'pages/syntheticValor/node024',
    'pages/syntheticValor/node025',
    'pages/syntheticValor/node026',
    'pages/syntheticValor/node027',
    'pages/syntheticValor/node028',
    'pages/syntheticValor/node029',
    'pages/syntheticValor/node030',
    'pages/syntheticValor/node031',
    'pages/syntheticValor/node032',
    'pages/syntheticValor/node033',
    'pages/syntheticValor/node034',
    'pages/syntheticValor/node035',
    'pages/syntheticValor/node036',
    'pages/syntheticValor/node037',
    'pages/syntheticValor/node038',
    'pages/syntheticValor/node039',
    'pages/syntheticValor/node040',
    'pages/syntheticValor/node041',
    'pages/syntheticValor/node042',
    'pages/syntheticValor/node043',
    'pages/syntheticValor/node044',
    'pages/syntheticValor/node045',
    'pages/syntheticValor/node046',
    'pages/syntheticValor/node047',
    'pages/syntheticValor/node048',
    'pages/syntheticValor/node049',
    'pages/syntheticValor/node050',
    'pages/syntheticValor/node051',
    'pages/syntheticValor/node052',
    'pages/syntheticValor/node053',
    'pages/syntheticValor/node054',
    'pages/syntheticValor/node055',
    'pages/syntheticValor/node056',
    'pages/syntheticValor/node057',
    'pages/syntheticValor/node058',
    'pages/syntheticValor/node059',
    'pages/syntheticValor/node060',
    'pages/syntheticValor/node061',
    'pages/syntheticValor/node062',
    'pages/syntheticValor/node063',
    'pages/syntheticValor/node064',
    'pages/syntheticValor/node065',
    'pages/syntheticValor/node066',
    'pages/syntheticValor/node067',
    'pages/syntheticValor/node068',
    'pages/syntheticValor/node069',
    'pages/syntheticValor/node070',
    'pages/syntheticValor/node071',
    'pages/syntheticValor/node072',
    'pages/syntheticValor/node073',
    'pages/syntheticValor/node074',
    'pages/syntheticValor/node075',
    'pages/syntheticValor/node076',
    'pages/syntheticValor/node077',
    'pages/syntheticValor/node078',
    'pages/syntheticValor/node079',
    'pages/syntheticValor/node080',
    'pages/syntheticValor/node081',
    'pages/syntheticValor/node082',
    'pages/syntheticValor/node083',
    'pages/syntheticValor/node084',
    'pages/syntheticValor/node085',
    'pages/syntheticValor/node086',
    'pages/syntheticValor/node087',
    'pages/syntheticValor/node088',
    'pages/syntheticValor/node089',
    'pages/syntheticValor/node090',
    'pages/syntheticValor/node091',
    'pages/syntheticValor/node092',
    'pages/syntheticValor/node093',
    'pages/syntheticValor/node094',
    'pages/syntheticValor/node095',
    'pages/syntheticValor/node096',
    'pages/syntheticValor/node097',
    'pages/syntheticValor/node098',
    'pages/syntheticValor/node099',
    'pages/syntheticValor/node100',
    'pages/syntheticValor/node101',
    'pages/syntheticValor/node102',
    'pages/syntheticValor/node103',
    'pages/syntheticValor/node104',
    'pages/syntheticValor/node105',
    'pages/syntheticValor/node106',
    'pages/syntheticValor/node107',
    'pages/syntheticValor/node108',
    'pages/syntheticValor/node109',
    'pages/syntheticValor/node110',
    'pages/syntheticValor/node111',
    'pages/syntheticValor/node112',
    'pages/syntheticValor/node113',
    'pages/syntheticValor/node114',
    'pages/syntheticValor/node115',
    'pages/syntheticValor/node116',
    'pages/syntheticValor/node117',
    'pages/syntheticValor/node118',
    'pages/syntheticValor/node119',
    'pages/syntheticValor/node120',
    'pages/syntheticValor/node121',
    'pages/syntheticValor/node122',
    'pages/syntheticValor/node123',
    'pages/syntheticValor/node124',
    'pages/syntheticValor/node125',
    'pages/syntheticValor/node126',
    'pages/syntheticValor/node127',
    'pages/syntheticValor/node128',
    'pages/syntheticValor/node129',
    'pages/syntheticValor/node130',
    'pages/syntheticValor/node131',
    'pages/syntheticValor/node132',
    'pages/syntheticValor/node133',
    'pages/syntheticValor/node134',
    'pages/syntheticValor/node135',
    'pages/syntheticValor/node136',
    'pages/syntheticValor/node137',
    'pages/syntheticValor/node138',
    'pages/syntheticValor/node139',
    'pages/syntheticValor/node140',
    'pages/syntheticValor/node141',
    'pages/syntheticValor/node142',
    'pages/syntheticValor/node143',
    'pages/syntheticValor/node144',
    'pages/syntheticValor/node145',
    'pages/syntheticValor/node146',
    'pages/syntheticValor/node147',
    'pages/syntheticValor/node148',
    'pages/syntheticValor/node149',
    'pages/syntheticValor/node150',
    'pages/syntheticValor/node151',
    'pages/syntheticValor/node152',
    'pages/syntheticValor/node153',
    'pages/syntheticValor/node154',
    'pages/syntheticValor/node155',
    'pages/syntheticValor/node156',
    'pages/syntheticValor/node157',
    'pages/syntheticValor/node158',
    'pages/syntheticValor/node159',
    'pages/syntheticValor/node160'
  ];

  describe('MegaSyntheticRouteAtlasValorSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteValor_[A-Za-z0-9_]+_[0-9]{3}$/;
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

