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
  return /^pages\/syntheticInferno\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasInfernoTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteInferno_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticInferno/node001',
    'pages/syntheticInferno/node002',
    'pages/syntheticInferno/node003',
    'pages/syntheticInferno/node004',
    'pages/syntheticInferno/node005',
    'pages/syntheticInferno/node006',
    'pages/syntheticInferno/node007',
    'pages/syntheticInferno/node008',
    'pages/syntheticInferno/node009',
    'pages/syntheticInferno/node010',
    'pages/syntheticInferno/node011',
    'pages/syntheticInferno/node012',
    'pages/syntheticInferno/node013',
    'pages/syntheticInferno/node014',
    'pages/syntheticInferno/node015',
    'pages/syntheticInferno/node016',
    'pages/syntheticInferno/node017',
    'pages/syntheticInferno/node018',
    'pages/syntheticInferno/node019',
    'pages/syntheticInferno/node020',
    'pages/syntheticInferno/node021',
    'pages/syntheticInferno/node022',
    'pages/syntheticInferno/node023',
    'pages/syntheticInferno/node024',
    'pages/syntheticInferno/node025',
    'pages/syntheticInferno/node026',
    'pages/syntheticInferno/node027',
    'pages/syntheticInferno/node028',
    'pages/syntheticInferno/node029',
    'pages/syntheticInferno/node030',
    'pages/syntheticInferno/node031',
    'pages/syntheticInferno/node032',
    'pages/syntheticInferno/node033',
    'pages/syntheticInferno/node034',
    'pages/syntheticInferno/node035',
    'pages/syntheticInferno/node036',
    'pages/syntheticInferno/node037',
    'pages/syntheticInferno/node038',
    'pages/syntheticInferno/node039',
    'pages/syntheticInferno/node040',
    'pages/syntheticInferno/node041',
    'pages/syntheticInferno/node042',
    'pages/syntheticInferno/node043',
    'pages/syntheticInferno/node044',
    'pages/syntheticInferno/node045',
    'pages/syntheticInferno/node046',
    'pages/syntheticInferno/node047',
    'pages/syntheticInferno/node048',
    'pages/syntheticInferno/node049',
    'pages/syntheticInferno/node050',
    'pages/syntheticInferno/node051',
    'pages/syntheticInferno/node052',
    'pages/syntheticInferno/node053',
    'pages/syntheticInferno/node054',
    'pages/syntheticInferno/node055',
    'pages/syntheticInferno/node056',
    'pages/syntheticInferno/node057',
    'pages/syntheticInferno/node058',
    'pages/syntheticInferno/node059',
    'pages/syntheticInferno/node060',
    'pages/syntheticInferno/node061',
    'pages/syntheticInferno/node062',
    'pages/syntheticInferno/node063',
    'pages/syntheticInferno/node064',
    'pages/syntheticInferno/node065',
    'pages/syntheticInferno/node066',
    'pages/syntheticInferno/node067',
    'pages/syntheticInferno/node068',
    'pages/syntheticInferno/node069',
    'pages/syntheticInferno/node070',
    'pages/syntheticInferno/node071',
    'pages/syntheticInferno/node072',
    'pages/syntheticInferno/node073',
    'pages/syntheticInferno/node074',
    'pages/syntheticInferno/node075',
    'pages/syntheticInferno/node076',
    'pages/syntheticInferno/node077',
    'pages/syntheticInferno/node078',
    'pages/syntheticInferno/node079',
    'pages/syntheticInferno/node080',
    'pages/syntheticInferno/node081',
    'pages/syntheticInferno/node082',
    'pages/syntheticInferno/node083',
    'pages/syntheticInferno/node084',
    'pages/syntheticInferno/node085',
    'pages/syntheticInferno/node086',
    'pages/syntheticInferno/node087',
    'pages/syntheticInferno/node088',
    'pages/syntheticInferno/node089',
    'pages/syntheticInferno/node090',
    'pages/syntheticInferno/node091',
    'pages/syntheticInferno/node092',
    'pages/syntheticInferno/node093',
    'pages/syntheticInferno/node094',
    'pages/syntheticInferno/node095',
    'pages/syntheticInferno/node096',
    'pages/syntheticInferno/node097',
    'pages/syntheticInferno/node098',
    'pages/syntheticInferno/node099',
    'pages/syntheticInferno/node100',
    'pages/syntheticInferno/node101',
    'pages/syntheticInferno/node102',
    'pages/syntheticInferno/node103',
    'pages/syntheticInferno/node104',
    'pages/syntheticInferno/node105',
    'pages/syntheticInferno/node106',
    'pages/syntheticInferno/node107',
    'pages/syntheticInferno/node108',
    'pages/syntheticInferno/node109',
    'pages/syntheticInferno/node110',
    'pages/syntheticInferno/node111',
    'pages/syntheticInferno/node112',
    'pages/syntheticInferno/node113',
    'pages/syntheticInferno/node114',
    'pages/syntheticInferno/node115',
    'pages/syntheticInferno/node116',
    'pages/syntheticInferno/node117',
    'pages/syntheticInferno/node118',
    'pages/syntheticInferno/node119',
    'pages/syntheticInferno/node120',
    'pages/syntheticInferno/node121',
    'pages/syntheticInferno/node122',
    'pages/syntheticInferno/node123',
    'pages/syntheticInferno/node124',
    'pages/syntheticInferno/node125',
    'pages/syntheticInferno/node126',
    'pages/syntheticInferno/node127',
    'pages/syntheticInferno/node128',
    'pages/syntheticInferno/node129',
    'pages/syntheticInferno/node130',
    'pages/syntheticInferno/node131',
    'pages/syntheticInferno/node132',
    'pages/syntheticInferno/node133',
    'pages/syntheticInferno/node134',
    'pages/syntheticInferno/node135',
    'pages/syntheticInferno/node136',
    'pages/syntheticInferno/node137',
    'pages/syntheticInferno/node138',
    'pages/syntheticInferno/node139',
    'pages/syntheticInferno/node140',
    'pages/syntheticInferno/node141',
    'pages/syntheticInferno/node142',
    'pages/syntheticInferno/node143',
    'pages/syntheticInferno/node144',
    'pages/syntheticInferno/node145',
    'pages/syntheticInferno/node146',
    'pages/syntheticInferno/node147',
    'pages/syntheticInferno/node148',
    'pages/syntheticInferno/node149',
    'pages/syntheticInferno/node150',
    'pages/syntheticInferno/node151',
    'pages/syntheticInferno/node152',
    'pages/syntheticInferno/node153',
    'pages/syntheticInferno/node154',
    'pages/syntheticInferno/node155',
    'pages/syntheticInferno/node156',
    'pages/syntheticInferno/node157',
    'pages/syntheticInferno/node158',
    'pages/syntheticInferno/node159',
    'pages/syntheticInferno/node160'
  ];

  describe('MegaSyntheticRouteAtlasInfernoSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteInferno_[A-Za-z0-9_]+_[0-9]{3}$/;
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

