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
  return /^pages\/syntheticRho\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasRhoTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteRho_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticRho/node001',
    'pages/syntheticRho/node002',
    'pages/syntheticRho/node003',
    'pages/syntheticRho/node004',
    'pages/syntheticRho/node005',
    'pages/syntheticRho/node006',
    'pages/syntheticRho/node007',
    'pages/syntheticRho/node008',
    'pages/syntheticRho/node009',
    'pages/syntheticRho/node010',
    'pages/syntheticRho/node011',
    'pages/syntheticRho/node012',
    'pages/syntheticRho/node013',
    'pages/syntheticRho/node014',
    'pages/syntheticRho/node015',
    'pages/syntheticRho/node016',
    'pages/syntheticRho/node017',
    'pages/syntheticRho/node018',
    'pages/syntheticRho/node019',
    'pages/syntheticRho/node020',
    'pages/syntheticRho/node021',
    'pages/syntheticRho/node022',
    'pages/syntheticRho/node023',
    'pages/syntheticRho/node024',
    'pages/syntheticRho/node025',
    'pages/syntheticRho/node026',
    'pages/syntheticRho/node027',
    'pages/syntheticRho/node028',
    'pages/syntheticRho/node029',
    'pages/syntheticRho/node030',
    'pages/syntheticRho/node031',
    'pages/syntheticRho/node032',
    'pages/syntheticRho/node033',
    'pages/syntheticRho/node034',
    'pages/syntheticRho/node035',
    'pages/syntheticRho/node036',
    'pages/syntheticRho/node037',
    'pages/syntheticRho/node038',
    'pages/syntheticRho/node039',
    'pages/syntheticRho/node040',
    'pages/syntheticRho/node041',
    'pages/syntheticRho/node042',
    'pages/syntheticRho/node043',
    'pages/syntheticRho/node044',
    'pages/syntheticRho/node045',
    'pages/syntheticRho/node046',
    'pages/syntheticRho/node047',
    'pages/syntheticRho/node048',
    'pages/syntheticRho/node049',
    'pages/syntheticRho/node050',
    'pages/syntheticRho/node051',
    'pages/syntheticRho/node052',
    'pages/syntheticRho/node053',
    'pages/syntheticRho/node054',
    'pages/syntheticRho/node055',
    'pages/syntheticRho/node056',
    'pages/syntheticRho/node057',
    'pages/syntheticRho/node058',
    'pages/syntheticRho/node059',
    'pages/syntheticRho/node060',
    'pages/syntheticRho/node061',
    'pages/syntheticRho/node062',
    'pages/syntheticRho/node063',
    'pages/syntheticRho/node064',
    'pages/syntheticRho/node065',
    'pages/syntheticRho/node066',
    'pages/syntheticRho/node067',
    'pages/syntheticRho/node068',
    'pages/syntheticRho/node069',
    'pages/syntheticRho/node070',
    'pages/syntheticRho/node071',
    'pages/syntheticRho/node072',
    'pages/syntheticRho/node073',
    'pages/syntheticRho/node074',
    'pages/syntheticRho/node075',
    'pages/syntheticRho/node076',
    'pages/syntheticRho/node077',
    'pages/syntheticRho/node078',
    'pages/syntheticRho/node079',
    'pages/syntheticRho/node080',
    'pages/syntheticRho/node081',
    'pages/syntheticRho/node082',
    'pages/syntheticRho/node083',
    'pages/syntheticRho/node084',
    'pages/syntheticRho/node085',
    'pages/syntheticRho/node086',
    'pages/syntheticRho/node087',
    'pages/syntheticRho/node088',
    'pages/syntheticRho/node089',
    'pages/syntheticRho/node090',
    'pages/syntheticRho/node091',
    'pages/syntheticRho/node092',
    'pages/syntheticRho/node093',
    'pages/syntheticRho/node094',
    'pages/syntheticRho/node095',
    'pages/syntheticRho/node096',
    'pages/syntheticRho/node097',
    'pages/syntheticRho/node098',
    'pages/syntheticRho/node099',
    'pages/syntheticRho/node100',
    'pages/syntheticRho/node101',
    'pages/syntheticRho/node102',
    'pages/syntheticRho/node103',
    'pages/syntheticRho/node104',
    'pages/syntheticRho/node105',
    'pages/syntheticRho/node106',
    'pages/syntheticRho/node107',
    'pages/syntheticRho/node108',
    'pages/syntheticRho/node109',
    'pages/syntheticRho/node110',
    'pages/syntheticRho/node111',
    'pages/syntheticRho/node112',
    'pages/syntheticRho/node113',
    'pages/syntheticRho/node114',
    'pages/syntheticRho/node115',
    'pages/syntheticRho/node116',
    'pages/syntheticRho/node117',
    'pages/syntheticRho/node118',
    'pages/syntheticRho/node119',
    'pages/syntheticRho/node120',
    'pages/syntheticRho/node121',
    'pages/syntheticRho/node122',
    'pages/syntheticRho/node123',
    'pages/syntheticRho/node124',
    'pages/syntheticRho/node125',
    'pages/syntheticRho/node126',
    'pages/syntheticRho/node127',
    'pages/syntheticRho/node128',
    'pages/syntheticRho/node129',
    'pages/syntheticRho/node130',
    'pages/syntheticRho/node131',
    'pages/syntheticRho/node132',
    'pages/syntheticRho/node133',
    'pages/syntheticRho/node134',
    'pages/syntheticRho/node135',
    'pages/syntheticRho/node136',
    'pages/syntheticRho/node137',
    'pages/syntheticRho/node138',
    'pages/syntheticRho/node139',
    'pages/syntheticRho/node140',
    'pages/syntheticRho/node141',
    'pages/syntheticRho/node142',
    'pages/syntheticRho/node143',
    'pages/syntheticRho/node144',
    'pages/syntheticRho/node145',
    'pages/syntheticRho/node146',
    'pages/syntheticRho/node147',
    'pages/syntheticRho/node148',
    'pages/syntheticRho/node149',
    'pages/syntheticRho/node150',
    'pages/syntheticRho/node151',
    'pages/syntheticRho/node152',
    'pages/syntheticRho/node153',
    'pages/syntheticRho/node154',
    'pages/syntheticRho/node155',
    'pages/syntheticRho/node156',
    'pages/syntheticRho/node157',
    'pages/syntheticRho/node158',
    'pages/syntheticRho/node159',
    'pages/syntheticRho/node160'
  ];

  describe('MegaSyntheticRouteAtlasRhoSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteRho_[A-Za-z0-9_]+_[0-9]{3}$/;
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