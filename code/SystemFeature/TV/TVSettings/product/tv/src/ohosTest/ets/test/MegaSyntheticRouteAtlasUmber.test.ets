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
  return /^pages\/syntheticUmber\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasUmberTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteUmber_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticUmber/node001',
    'pages/syntheticUmber/node002',
    'pages/syntheticUmber/node003',
    'pages/syntheticUmber/node004',
    'pages/syntheticUmber/node005',
    'pages/syntheticUmber/node006',
    'pages/syntheticUmber/node007',
    'pages/syntheticUmber/node008',
    'pages/syntheticUmber/node009',
    'pages/syntheticUmber/node010',
    'pages/syntheticUmber/node011',
    'pages/syntheticUmber/node012',
    'pages/syntheticUmber/node013',
    'pages/syntheticUmber/node014',
    'pages/syntheticUmber/node015',
    'pages/syntheticUmber/node016',
    'pages/syntheticUmber/node017',
    'pages/syntheticUmber/node018',
    'pages/syntheticUmber/node019',
    'pages/syntheticUmber/node020',
    'pages/syntheticUmber/node021',
    'pages/syntheticUmber/node022',
    'pages/syntheticUmber/node023',
    'pages/syntheticUmber/node024',
    'pages/syntheticUmber/node025',
    'pages/syntheticUmber/node026',
    'pages/syntheticUmber/node027',
    'pages/syntheticUmber/node028',
    'pages/syntheticUmber/node029',
    'pages/syntheticUmber/node030',
    'pages/syntheticUmber/node031',
    'pages/syntheticUmber/node032',
    'pages/syntheticUmber/node033',
    'pages/syntheticUmber/node034',
    'pages/syntheticUmber/node035',
    'pages/syntheticUmber/node036',
    'pages/syntheticUmber/node037',
    'pages/syntheticUmber/node038',
    'pages/syntheticUmber/node039',
    'pages/syntheticUmber/node040',
    'pages/syntheticUmber/node041',
    'pages/syntheticUmber/node042',
    'pages/syntheticUmber/node043',
    'pages/syntheticUmber/node044',
    'pages/syntheticUmber/node045',
    'pages/syntheticUmber/node046',
    'pages/syntheticUmber/node047',
    'pages/syntheticUmber/node048',
    'pages/syntheticUmber/node049',
    'pages/syntheticUmber/node050',
    'pages/syntheticUmber/node051',
    'pages/syntheticUmber/node052',
    'pages/syntheticUmber/node053',
    'pages/syntheticUmber/node054',
    'pages/syntheticUmber/node055',
    'pages/syntheticUmber/node056',
    'pages/syntheticUmber/node057',
    'pages/syntheticUmber/node058',
    'pages/syntheticUmber/node059',
    'pages/syntheticUmber/node060',
    'pages/syntheticUmber/node061',
    'pages/syntheticUmber/node062',
    'pages/syntheticUmber/node063',
    'pages/syntheticUmber/node064',
    'pages/syntheticUmber/node065',
    'pages/syntheticUmber/node066',
    'pages/syntheticUmber/node067',
    'pages/syntheticUmber/node068',
    'pages/syntheticUmber/node069',
    'pages/syntheticUmber/node070',
    'pages/syntheticUmber/node071',
    'pages/syntheticUmber/node072',
    'pages/syntheticUmber/node073',
    'pages/syntheticUmber/node074',
    'pages/syntheticUmber/node075',
    'pages/syntheticUmber/node076',
    'pages/syntheticUmber/node077',
    'pages/syntheticUmber/node078',
    'pages/syntheticUmber/node079',
    'pages/syntheticUmber/node080',
    'pages/syntheticUmber/node081',
    'pages/syntheticUmber/node082',
    'pages/syntheticUmber/node083',
    'pages/syntheticUmber/node084',
    'pages/syntheticUmber/node085',
    'pages/syntheticUmber/node086',
    'pages/syntheticUmber/node087',
    'pages/syntheticUmber/node088',
    'pages/syntheticUmber/node089',
    'pages/syntheticUmber/node090',
    'pages/syntheticUmber/node091',
    'pages/syntheticUmber/node092',
    'pages/syntheticUmber/node093',
    'pages/syntheticUmber/node094',
    'pages/syntheticUmber/node095',
    'pages/syntheticUmber/node096',
    'pages/syntheticUmber/node097',
    'pages/syntheticUmber/node098',
    'pages/syntheticUmber/node099',
    'pages/syntheticUmber/node100',
    'pages/syntheticUmber/node101',
    'pages/syntheticUmber/node102',
    'pages/syntheticUmber/node103',
    'pages/syntheticUmber/node104',
    'pages/syntheticUmber/node105',
    'pages/syntheticUmber/node106',
    'pages/syntheticUmber/node107',
    'pages/syntheticUmber/node108',
    'pages/syntheticUmber/node109',
    'pages/syntheticUmber/node110',
    'pages/syntheticUmber/node111',
    'pages/syntheticUmber/node112',
    'pages/syntheticUmber/node113',
    'pages/syntheticUmber/node114',
    'pages/syntheticUmber/node115',
    'pages/syntheticUmber/node116',
    'pages/syntheticUmber/node117',
    'pages/syntheticUmber/node118',
    'pages/syntheticUmber/node119',
    'pages/syntheticUmber/node120',
    'pages/syntheticUmber/node121',
    'pages/syntheticUmber/node122',
    'pages/syntheticUmber/node123',
    'pages/syntheticUmber/node124',
    'pages/syntheticUmber/node125',
    'pages/syntheticUmber/node126',
    'pages/syntheticUmber/node127',
    'pages/syntheticUmber/node128',
    'pages/syntheticUmber/node129',
    'pages/syntheticUmber/node130',
    'pages/syntheticUmber/node131',
    'pages/syntheticUmber/node132',
    'pages/syntheticUmber/node133',
    'pages/syntheticUmber/node134',
    'pages/syntheticUmber/node135',
    'pages/syntheticUmber/node136',
    'pages/syntheticUmber/node137',
    'pages/syntheticUmber/node138',
    'pages/syntheticUmber/node139',
    'pages/syntheticUmber/node140',
    'pages/syntheticUmber/node141',
    'pages/syntheticUmber/node142',
    'pages/syntheticUmber/node143',
    'pages/syntheticUmber/node144',
    'pages/syntheticUmber/node145',
    'pages/syntheticUmber/node146',
    'pages/syntheticUmber/node147',
    'pages/syntheticUmber/node148',
    'pages/syntheticUmber/node149',
    'pages/syntheticUmber/node150',
    'pages/syntheticUmber/node151',
    'pages/syntheticUmber/node152',
    'pages/syntheticUmber/node153',
    'pages/syntheticUmber/node154',
    'pages/syntheticUmber/node155',
    'pages/syntheticUmber/node156',
    'pages/syntheticUmber/node157',
    'pages/syntheticUmber/node158',
    'pages/syntheticUmber/node159',
    'pages/syntheticUmber/node160'
  ];

  describe('MegaSyntheticRouteAtlasUmberSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteUmber_[A-Za-z0-9_]+_[0-9]{3}$/;
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

