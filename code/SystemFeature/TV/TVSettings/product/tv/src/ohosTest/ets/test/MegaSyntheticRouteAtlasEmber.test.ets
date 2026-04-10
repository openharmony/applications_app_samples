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
  return /^pages\/syntheticEmber\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasEmberTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteEmber_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticEmber/node001',
    'pages/syntheticEmber/node002',
    'pages/syntheticEmber/node003',
    'pages/syntheticEmber/node004',
    'pages/syntheticEmber/node005',
    'pages/syntheticEmber/node006',
    'pages/syntheticEmber/node007',
    'pages/syntheticEmber/node008',
    'pages/syntheticEmber/node009',
    'pages/syntheticEmber/node010',
    'pages/syntheticEmber/node011',
    'pages/syntheticEmber/node012',
    'pages/syntheticEmber/node013',
    'pages/syntheticEmber/node014',
    'pages/syntheticEmber/node015',
    'pages/syntheticEmber/node016',
    'pages/syntheticEmber/node017',
    'pages/syntheticEmber/node018',
    'pages/syntheticEmber/node019',
    'pages/syntheticEmber/node020',
    'pages/syntheticEmber/node021',
    'pages/syntheticEmber/node022',
    'pages/syntheticEmber/node023',
    'pages/syntheticEmber/node024',
    'pages/syntheticEmber/node025',
    'pages/syntheticEmber/node026',
    'pages/syntheticEmber/node027',
    'pages/syntheticEmber/node028',
    'pages/syntheticEmber/node029',
    'pages/syntheticEmber/node030',
    'pages/syntheticEmber/node031',
    'pages/syntheticEmber/node032',
    'pages/syntheticEmber/node033',
    'pages/syntheticEmber/node034',
    'pages/syntheticEmber/node035',
    'pages/syntheticEmber/node036',
    'pages/syntheticEmber/node037',
    'pages/syntheticEmber/node038',
    'pages/syntheticEmber/node039',
    'pages/syntheticEmber/node040',
    'pages/syntheticEmber/node041',
    'pages/syntheticEmber/node042',
    'pages/syntheticEmber/node043',
    'pages/syntheticEmber/node044',
    'pages/syntheticEmber/node045',
    'pages/syntheticEmber/node046',
    'pages/syntheticEmber/node047',
    'pages/syntheticEmber/node048',
    'pages/syntheticEmber/node049',
    'pages/syntheticEmber/node050',
    'pages/syntheticEmber/node051',
    'pages/syntheticEmber/node052',
    'pages/syntheticEmber/node053',
    'pages/syntheticEmber/node054',
    'pages/syntheticEmber/node055',
    'pages/syntheticEmber/node056',
    'pages/syntheticEmber/node057',
    'pages/syntheticEmber/node058',
    'pages/syntheticEmber/node059',
    'pages/syntheticEmber/node060',
    'pages/syntheticEmber/node061',
    'pages/syntheticEmber/node062',
    'pages/syntheticEmber/node063',
    'pages/syntheticEmber/node064',
    'pages/syntheticEmber/node065',
    'pages/syntheticEmber/node066',
    'pages/syntheticEmber/node067',
    'pages/syntheticEmber/node068',
    'pages/syntheticEmber/node069',
    'pages/syntheticEmber/node070',
    'pages/syntheticEmber/node071',
    'pages/syntheticEmber/node072',
    'pages/syntheticEmber/node073',
    'pages/syntheticEmber/node074',
    'pages/syntheticEmber/node075',
    'pages/syntheticEmber/node076',
    'pages/syntheticEmber/node077',
    'pages/syntheticEmber/node078',
    'pages/syntheticEmber/node079',
    'pages/syntheticEmber/node080',
    'pages/syntheticEmber/node081',
    'pages/syntheticEmber/node082',
    'pages/syntheticEmber/node083',
    'pages/syntheticEmber/node084',
    'pages/syntheticEmber/node085',
    'pages/syntheticEmber/node086',
    'pages/syntheticEmber/node087',
    'pages/syntheticEmber/node088',
    'pages/syntheticEmber/node089',
    'pages/syntheticEmber/node090',
    'pages/syntheticEmber/node091',
    'pages/syntheticEmber/node092',
    'pages/syntheticEmber/node093',
    'pages/syntheticEmber/node094',
    'pages/syntheticEmber/node095',
    'pages/syntheticEmber/node096',
    'pages/syntheticEmber/node097',
    'pages/syntheticEmber/node098',
    'pages/syntheticEmber/node099',
    'pages/syntheticEmber/node100',
    'pages/syntheticEmber/node101',
    'pages/syntheticEmber/node102',
    'pages/syntheticEmber/node103',
    'pages/syntheticEmber/node104',
    'pages/syntheticEmber/node105',
    'pages/syntheticEmber/node106',
    'pages/syntheticEmber/node107',
    'pages/syntheticEmber/node108',
    'pages/syntheticEmber/node109',
    'pages/syntheticEmber/node110',
    'pages/syntheticEmber/node111',
    'pages/syntheticEmber/node112',
    'pages/syntheticEmber/node113',
    'pages/syntheticEmber/node114',
    'pages/syntheticEmber/node115',
    'pages/syntheticEmber/node116',
    'pages/syntheticEmber/node117',
    'pages/syntheticEmber/node118',
    'pages/syntheticEmber/node119',
    'pages/syntheticEmber/node120',
    'pages/syntheticEmber/node121',
    'pages/syntheticEmber/node122',
    'pages/syntheticEmber/node123',
    'pages/syntheticEmber/node124',
    'pages/syntheticEmber/node125',
    'pages/syntheticEmber/node126',
    'pages/syntheticEmber/node127',
    'pages/syntheticEmber/node128',
    'pages/syntheticEmber/node129',
    'pages/syntheticEmber/node130',
    'pages/syntheticEmber/node131',
    'pages/syntheticEmber/node132',
    'pages/syntheticEmber/node133',
    'pages/syntheticEmber/node134',
    'pages/syntheticEmber/node135',
    'pages/syntheticEmber/node136',
    'pages/syntheticEmber/node137',
    'pages/syntheticEmber/node138',
    'pages/syntheticEmber/node139',
    'pages/syntheticEmber/node140',
    'pages/syntheticEmber/node141',
    'pages/syntheticEmber/node142',
    'pages/syntheticEmber/node143',
    'pages/syntheticEmber/node144',
    'pages/syntheticEmber/node145',
    'pages/syntheticEmber/node146',
    'pages/syntheticEmber/node147',
    'pages/syntheticEmber/node148',
    'pages/syntheticEmber/node149',
    'pages/syntheticEmber/node150',
    'pages/syntheticEmber/node151',
    'pages/syntheticEmber/node152',
    'pages/syntheticEmber/node153',
    'pages/syntheticEmber/node154',
    'pages/syntheticEmber/node155',
    'pages/syntheticEmber/node156',
    'pages/syntheticEmber/node157',
    'pages/syntheticEmber/node158',
    'pages/syntheticEmber/node159',
    'pages/syntheticEmber/node160'
  ];

  describe('MegaSyntheticRouteAtlasEmberSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteEmber_[A-Za-z0-9_]+_[0-9]{3}$/;
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

