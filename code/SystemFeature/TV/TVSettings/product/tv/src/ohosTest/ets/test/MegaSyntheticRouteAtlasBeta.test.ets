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
  return /^pages\/syntheticBeta\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasBetaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteBeta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticBeta/node001',
    'pages/syntheticBeta/node002',
    'pages/syntheticBeta/node003',
    'pages/syntheticBeta/node004',
    'pages/syntheticBeta/node005',
    'pages/syntheticBeta/node006',
    'pages/syntheticBeta/node007',
    'pages/syntheticBeta/node008',
    'pages/syntheticBeta/node009',
    'pages/syntheticBeta/node010',
    'pages/syntheticBeta/node011',
    'pages/syntheticBeta/node012',
    'pages/syntheticBeta/node013',
    'pages/syntheticBeta/node014',
    'pages/syntheticBeta/node015',
    'pages/syntheticBeta/node016',
    'pages/syntheticBeta/node017',
    'pages/syntheticBeta/node018',
    'pages/syntheticBeta/node019',
    'pages/syntheticBeta/node020',
    'pages/syntheticBeta/node021',
    'pages/syntheticBeta/node022',
    'pages/syntheticBeta/node023',
    'pages/syntheticBeta/node024',
    'pages/syntheticBeta/node025',
    'pages/syntheticBeta/node026',
    'pages/syntheticBeta/node027',
    'pages/syntheticBeta/node028',
    'pages/syntheticBeta/node029',
    'pages/syntheticBeta/node030',
    'pages/syntheticBeta/node031',
    'pages/syntheticBeta/node032',
    'pages/syntheticBeta/node033',
    'pages/syntheticBeta/node034',
    'pages/syntheticBeta/node035',
    'pages/syntheticBeta/node036',
    'pages/syntheticBeta/node037',
    'pages/syntheticBeta/node038',
    'pages/syntheticBeta/node039',
    'pages/syntheticBeta/node040',
    'pages/syntheticBeta/node041',
    'pages/syntheticBeta/node042',
    'pages/syntheticBeta/node043',
    'pages/syntheticBeta/node044',
    'pages/syntheticBeta/node045',
    'pages/syntheticBeta/node046',
    'pages/syntheticBeta/node047',
    'pages/syntheticBeta/node048',
    'pages/syntheticBeta/node049',
    'pages/syntheticBeta/node050',
    'pages/syntheticBeta/node051',
    'pages/syntheticBeta/node052',
    'pages/syntheticBeta/node053',
    'pages/syntheticBeta/node054',
    'pages/syntheticBeta/node055',
    'pages/syntheticBeta/node056',
    'pages/syntheticBeta/node057',
    'pages/syntheticBeta/node058',
    'pages/syntheticBeta/node059',
    'pages/syntheticBeta/node060',
    'pages/syntheticBeta/node061',
    'pages/syntheticBeta/node062',
    'pages/syntheticBeta/node063',
    'pages/syntheticBeta/node064',
    'pages/syntheticBeta/node065',
    'pages/syntheticBeta/node066',
    'pages/syntheticBeta/node067',
    'pages/syntheticBeta/node068',
    'pages/syntheticBeta/node069',
    'pages/syntheticBeta/node070',
    'pages/syntheticBeta/node071',
    'pages/syntheticBeta/node072',
    'pages/syntheticBeta/node073',
    'pages/syntheticBeta/node074',
    'pages/syntheticBeta/node075',
    'pages/syntheticBeta/node076',
    'pages/syntheticBeta/node077',
    'pages/syntheticBeta/node078',
    'pages/syntheticBeta/node079',
    'pages/syntheticBeta/node080',
    'pages/syntheticBeta/node081',
    'pages/syntheticBeta/node082',
    'pages/syntheticBeta/node083',
    'pages/syntheticBeta/node084',
    'pages/syntheticBeta/node085',
    'pages/syntheticBeta/node086',
    'pages/syntheticBeta/node087',
    'pages/syntheticBeta/node088',
    'pages/syntheticBeta/node089',
    'pages/syntheticBeta/node090',
    'pages/syntheticBeta/node091',
    'pages/syntheticBeta/node092',
    'pages/syntheticBeta/node093',
    'pages/syntheticBeta/node094',
    'pages/syntheticBeta/node095',
    'pages/syntheticBeta/node096',
    'pages/syntheticBeta/node097',
    'pages/syntheticBeta/node098',
    'pages/syntheticBeta/node099',
    'pages/syntheticBeta/node100',
    'pages/syntheticBeta/node101',
    'pages/syntheticBeta/node102',
    'pages/syntheticBeta/node103',
    'pages/syntheticBeta/node104',
    'pages/syntheticBeta/node105',
    'pages/syntheticBeta/node106',
    'pages/syntheticBeta/node107',
    'pages/syntheticBeta/node108',
    'pages/syntheticBeta/node109',
    'pages/syntheticBeta/node110',
    'pages/syntheticBeta/node111',
    'pages/syntheticBeta/node112',
    'pages/syntheticBeta/node113',
    'pages/syntheticBeta/node114',
    'pages/syntheticBeta/node115',
    'pages/syntheticBeta/node116',
    'pages/syntheticBeta/node117',
    'pages/syntheticBeta/node118',
    'pages/syntheticBeta/node119',
    'pages/syntheticBeta/node120',
    'pages/syntheticBeta/node121',
    'pages/syntheticBeta/node122',
    'pages/syntheticBeta/node123',
    'pages/syntheticBeta/node124',
    'pages/syntheticBeta/node125',
    'pages/syntheticBeta/node126',
    'pages/syntheticBeta/node127',
    'pages/syntheticBeta/node128',
    'pages/syntheticBeta/node129',
    'pages/syntheticBeta/node130',
    'pages/syntheticBeta/node131',
    'pages/syntheticBeta/node132',
    'pages/syntheticBeta/node133',
    'pages/syntheticBeta/node134',
    'pages/syntheticBeta/node135',
    'pages/syntheticBeta/node136',
    'pages/syntheticBeta/node137',
    'pages/syntheticBeta/node138',
    'pages/syntheticBeta/node139',
    'pages/syntheticBeta/node140',
    'pages/syntheticBeta/node141',
    'pages/syntheticBeta/node142',
    'pages/syntheticBeta/node143',
    'pages/syntheticBeta/node144',
    'pages/syntheticBeta/node145',
    'pages/syntheticBeta/node146',
    'pages/syntheticBeta/node147',
    'pages/syntheticBeta/node148',
    'pages/syntheticBeta/node149',
    'pages/syntheticBeta/node150',
    'pages/syntheticBeta/node151',
    'pages/syntheticBeta/node152',
    'pages/syntheticBeta/node153',
    'pages/syntheticBeta/node154',
    'pages/syntheticBeta/node155',
    'pages/syntheticBeta/node156',
    'pages/syntheticBeta/node157',
    'pages/syntheticBeta/node158',
    'pages/syntheticBeta/node159',
    'pages/syntheticBeta/node160'
  ];

  describe('MegaSyntheticRouteAtlasBetaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteBeta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

