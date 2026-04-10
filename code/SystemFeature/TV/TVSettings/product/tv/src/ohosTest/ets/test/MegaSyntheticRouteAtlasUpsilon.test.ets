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
  return /^pages\/syntheticUpsilon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasUpsilonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteUpsilon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticUpsilon/node001',
    'pages/syntheticUpsilon/node002',
    'pages/syntheticUpsilon/node003',
    'pages/syntheticUpsilon/node004',
    'pages/syntheticUpsilon/node005',
    'pages/syntheticUpsilon/node006',
    'pages/syntheticUpsilon/node007',
    'pages/syntheticUpsilon/node008',
    'pages/syntheticUpsilon/node009',
    'pages/syntheticUpsilon/node010',
    'pages/syntheticUpsilon/node011',
    'pages/syntheticUpsilon/node012',
    'pages/syntheticUpsilon/node013',
    'pages/syntheticUpsilon/node014',
    'pages/syntheticUpsilon/node015',
    'pages/syntheticUpsilon/node016',
    'pages/syntheticUpsilon/node017',
    'pages/syntheticUpsilon/node018',
    'pages/syntheticUpsilon/node019',
    'pages/syntheticUpsilon/node020',
    'pages/syntheticUpsilon/node021',
    'pages/syntheticUpsilon/node022',
    'pages/syntheticUpsilon/node023',
    'pages/syntheticUpsilon/node024',
    'pages/syntheticUpsilon/node025',
    'pages/syntheticUpsilon/node026',
    'pages/syntheticUpsilon/node027',
    'pages/syntheticUpsilon/node028',
    'pages/syntheticUpsilon/node029',
    'pages/syntheticUpsilon/node030',
    'pages/syntheticUpsilon/node031',
    'pages/syntheticUpsilon/node032',
    'pages/syntheticUpsilon/node033',
    'pages/syntheticUpsilon/node034',
    'pages/syntheticUpsilon/node035',
    'pages/syntheticUpsilon/node036',
    'pages/syntheticUpsilon/node037',
    'pages/syntheticUpsilon/node038',
    'pages/syntheticUpsilon/node039',
    'pages/syntheticUpsilon/node040',
    'pages/syntheticUpsilon/node041',
    'pages/syntheticUpsilon/node042',
    'pages/syntheticUpsilon/node043',
    'pages/syntheticUpsilon/node044',
    'pages/syntheticUpsilon/node045',
    'pages/syntheticUpsilon/node046',
    'pages/syntheticUpsilon/node047',
    'pages/syntheticUpsilon/node048',
    'pages/syntheticUpsilon/node049',
    'pages/syntheticUpsilon/node050',
    'pages/syntheticUpsilon/node051',
    'pages/syntheticUpsilon/node052',
    'pages/syntheticUpsilon/node053',
    'pages/syntheticUpsilon/node054',
    'pages/syntheticUpsilon/node055',
    'pages/syntheticUpsilon/node056',
    'pages/syntheticUpsilon/node057',
    'pages/syntheticUpsilon/node058',
    'pages/syntheticUpsilon/node059',
    'pages/syntheticUpsilon/node060',
    'pages/syntheticUpsilon/node061',
    'pages/syntheticUpsilon/node062',
    'pages/syntheticUpsilon/node063',
    'pages/syntheticUpsilon/node064',
    'pages/syntheticUpsilon/node065',
    'pages/syntheticUpsilon/node066',
    'pages/syntheticUpsilon/node067',
    'pages/syntheticUpsilon/node068',
    'pages/syntheticUpsilon/node069',
    'pages/syntheticUpsilon/node070',
    'pages/syntheticUpsilon/node071',
    'pages/syntheticUpsilon/node072',
    'pages/syntheticUpsilon/node073',
    'pages/syntheticUpsilon/node074',
    'pages/syntheticUpsilon/node075',
    'pages/syntheticUpsilon/node076',
    'pages/syntheticUpsilon/node077',
    'pages/syntheticUpsilon/node078',
    'pages/syntheticUpsilon/node079',
    'pages/syntheticUpsilon/node080',
    'pages/syntheticUpsilon/node081',
    'pages/syntheticUpsilon/node082',
    'pages/syntheticUpsilon/node083',
    'pages/syntheticUpsilon/node084',
    'pages/syntheticUpsilon/node085',
    'pages/syntheticUpsilon/node086',
    'pages/syntheticUpsilon/node087',
    'pages/syntheticUpsilon/node088',
    'pages/syntheticUpsilon/node089',
    'pages/syntheticUpsilon/node090',
    'pages/syntheticUpsilon/node091',
    'pages/syntheticUpsilon/node092',
    'pages/syntheticUpsilon/node093',
    'pages/syntheticUpsilon/node094',
    'pages/syntheticUpsilon/node095',
    'pages/syntheticUpsilon/node096',
    'pages/syntheticUpsilon/node097',
    'pages/syntheticUpsilon/node098',
    'pages/syntheticUpsilon/node099',
    'pages/syntheticUpsilon/node100',
    'pages/syntheticUpsilon/node101',
    'pages/syntheticUpsilon/node102',
    'pages/syntheticUpsilon/node103',
    'pages/syntheticUpsilon/node104',
    'pages/syntheticUpsilon/node105',
    'pages/syntheticUpsilon/node106',
    'pages/syntheticUpsilon/node107',
    'pages/syntheticUpsilon/node108',
    'pages/syntheticUpsilon/node109',
    'pages/syntheticUpsilon/node110',
    'pages/syntheticUpsilon/node111',
    'pages/syntheticUpsilon/node112',
    'pages/syntheticUpsilon/node113',
    'pages/syntheticUpsilon/node114',
    'pages/syntheticUpsilon/node115',
    'pages/syntheticUpsilon/node116',
    'pages/syntheticUpsilon/node117',
    'pages/syntheticUpsilon/node118',
    'pages/syntheticUpsilon/node119',
    'pages/syntheticUpsilon/node120',
    'pages/syntheticUpsilon/node121',
    'pages/syntheticUpsilon/node122',
    'pages/syntheticUpsilon/node123',
    'pages/syntheticUpsilon/node124',
    'pages/syntheticUpsilon/node125',
    'pages/syntheticUpsilon/node126',
    'pages/syntheticUpsilon/node127',
    'pages/syntheticUpsilon/node128',
    'pages/syntheticUpsilon/node129',
    'pages/syntheticUpsilon/node130',
    'pages/syntheticUpsilon/node131',
    'pages/syntheticUpsilon/node132',
    'pages/syntheticUpsilon/node133',
    'pages/syntheticUpsilon/node134',
    'pages/syntheticUpsilon/node135',
    'pages/syntheticUpsilon/node136',
    'pages/syntheticUpsilon/node137',
    'pages/syntheticUpsilon/node138',
    'pages/syntheticUpsilon/node139',
    'pages/syntheticUpsilon/node140',
    'pages/syntheticUpsilon/node141',
    'pages/syntheticUpsilon/node142',
    'pages/syntheticUpsilon/node143',
    'pages/syntheticUpsilon/node144',
    'pages/syntheticUpsilon/node145',
    'pages/syntheticUpsilon/node146',
    'pages/syntheticUpsilon/node147',
    'pages/syntheticUpsilon/node148',
    'pages/syntheticUpsilon/node149',
    'pages/syntheticUpsilon/node150',
    'pages/syntheticUpsilon/node151',
    'pages/syntheticUpsilon/node152',
    'pages/syntheticUpsilon/node153',
    'pages/syntheticUpsilon/node154',
    'pages/syntheticUpsilon/node155',
    'pages/syntheticUpsilon/node156',
    'pages/syntheticUpsilon/node157',
    'pages/syntheticUpsilon/node158',
    'pages/syntheticUpsilon/node159',
    'pages/syntheticUpsilon/node160'
  ];

  describe('MegaSyntheticRouteAtlasUpsilonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteUpsilon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

