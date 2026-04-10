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
  return /^pages\/syntheticNu\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasNuTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteNu_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticNu/node001',
    'pages/syntheticNu/node002',
    'pages/syntheticNu/node003',
    'pages/syntheticNu/node004',
    'pages/syntheticNu/node005',
    'pages/syntheticNu/node006',
    'pages/syntheticNu/node007',
    'pages/syntheticNu/node008',
    'pages/syntheticNu/node009',
    'pages/syntheticNu/node010',
    'pages/syntheticNu/node011',
    'pages/syntheticNu/node012',
    'pages/syntheticNu/node013',
    'pages/syntheticNu/node014',
    'pages/syntheticNu/node015',
    'pages/syntheticNu/node016',
    'pages/syntheticNu/node017',
    'pages/syntheticNu/node018',
    'pages/syntheticNu/node019',
    'pages/syntheticNu/node020',
    'pages/syntheticNu/node021',
    'pages/syntheticNu/node022',
    'pages/syntheticNu/node023',
    'pages/syntheticNu/node024',
    'pages/syntheticNu/node025',
    'pages/syntheticNu/node026',
    'pages/syntheticNu/node027',
    'pages/syntheticNu/node028',
    'pages/syntheticNu/node029',
    'pages/syntheticNu/node030',
    'pages/syntheticNu/node031',
    'pages/syntheticNu/node032',
    'pages/syntheticNu/node033',
    'pages/syntheticNu/node034',
    'pages/syntheticNu/node035',
    'pages/syntheticNu/node036',
    'pages/syntheticNu/node037',
    'pages/syntheticNu/node038',
    'pages/syntheticNu/node039',
    'pages/syntheticNu/node040',
    'pages/syntheticNu/node041',
    'pages/syntheticNu/node042',
    'pages/syntheticNu/node043',
    'pages/syntheticNu/node044',
    'pages/syntheticNu/node045',
    'pages/syntheticNu/node046',
    'pages/syntheticNu/node047',
    'pages/syntheticNu/node048',
    'pages/syntheticNu/node049',
    'pages/syntheticNu/node050',
    'pages/syntheticNu/node051',
    'pages/syntheticNu/node052',
    'pages/syntheticNu/node053',
    'pages/syntheticNu/node054',
    'pages/syntheticNu/node055',
    'pages/syntheticNu/node056',
    'pages/syntheticNu/node057',
    'pages/syntheticNu/node058',
    'pages/syntheticNu/node059',
    'pages/syntheticNu/node060',
    'pages/syntheticNu/node061',
    'pages/syntheticNu/node062',
    'pages/syntheticNu/node063',
    'pages/syntheticNu/node064',
    'pages/syntheticNu/node065',
    'pages/syntheticNu/node066',
    'pages/syntheticNu/node067',
    'pages/syntheticNu/node068',
    'pages/syntheticNu/node069',
    'pages/syntheticNu/node070',
    'pages/syntheticNu/node071',
    'pages/syntheticNu/node072',
    'pages/syntheticNu/node073',
    'pages/syntheticNu/node074',
    'pages/syntheticNu/node075',
    'pages/syntheticNu/node076',
    'pages/syntheticNu/node077',
    'pages/syntheticNu/node078',
    'pages/syntheticNu/node079',
    'pages/syntheticNu/node080',
    'pages/syntheticNu/node081',
    'pages/syntheticNu/node082',
    'pages/syntheticNu/node083',
    'pages/syntheticNu/node084',
    'pages/syntheticNu/node085',
    'pages/syntheticNu/node086',
    'pages/syntheticNu/node087',
    'pages/syntheticNu/node088',
    'pages/syntheticNu/node089',
    'pages/syntheticNu/node090',
    'pages/syntheticNu/node091',
    'pages/syntheticNu/node092',
    'pages/syntheticNu/node093',
    'pages/syntheticNu/node094',
    'pages/syntheticNu/node095',
    'pages/syntheticNu/node096',
    'pages/syntheticNu/node097',
    'pages/syntheticNu/node098',
    'pages/syntheticNu/node099',
    'pages/syntheticNu/node100',
    'pages/syntheticNu/node101',
    'pages/syntheticNu/node102',
    'pages/syntheticNu/node103',
    'pages/syntheticNu/node104',
    'pages/syntheticNu/node105',
    'pages/syntheticNu/node106',
    'pages/syntheticNu/node107',
    'pages/syntheticNu/node108',
    'pages/syntheticNu/node109',
    'pages/syntheticNu/node110',
    'pages/syntheticNu/node111',
    'pages/syntheticNu/node112',
    'pages/syntheticNu/node113',
    'pages/syntheticNu/node114',
    'pages/syntheticNu/node115',
    'pages/syntheticNu/node116',
    'pages/syntheticNu/node117',
    'pages/syntheticNu/node118',
    'pages/syntheticNu/node119',
    'pages/syntheticNu/node120',
    'pages/syntheticNu/node121',
    'pages/syntheticNu/node122',
    'pages/syntheticNu/node123',
    'pages/syntheticNu/node124',
    'pages/syntheticNu/node125',
    'pages/syntheticNu/node126',
    'pages/syntheticNu/node127',
    'pages/syntheticNu/node128',
    'pages/syntheticNu/node129',
    'pages/syntheticNu/node130',
    'pages/syntheticNu/node131',
    'pages/syntheticNu/node132',
    'pages/syntheticNu/node133',
    'pages/syntheticNu/node134',
    'pages/syntheticNu/node135',
    'pages/syntheticNu/node136',
    'pages/syntheticNu/node137',
    'pages/syntheticNu/node138',
    'pages/syntheticNu/node139',
    'pages/syntheticNu/node140',
    'pages/syntheticNu/node141',
    'pages/syntheticNu/node142',
    'pages/syntheticNu/node143',
    'pages/syntheticNu/node144',
    'pages/syntheticNu/node145',
    'pages/syntheticNu/node146',
    'pages/syntheticNu/node147',
    'pages/syntheticNu/node148',
    'pages/syntheticNu/node149',
    'pages/syntheticNu/node150',
    'pages/syntheticNu/node151',
    'pages/syntheticNu/node152',
    'pages/syntheticNu/node153',
    'pages/syntheticNu/node154',
    'pages/syntheticNu/node155',
    'pages/syntheticNu/node156',
    'pages/syntheticNu/node157',
    'pages/syntheticNu/node158',
    'pages/syntheticNu/node159',
    'pages/syntheticNu/node160'
  ];

  describe('MegaSyntheticRouteAtlasNuSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteNu_[A-Za-z0-9_]+_[0-9]{3}$/;
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

