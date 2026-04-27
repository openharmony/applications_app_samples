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
  return /^pages\/syntheticHelm\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasHelmTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteHelm_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticHelm/node001',
    'pages/syntheticHelm/node002',
    'pages/syntheticHelm/node003',
    'pages/syntheticHelm/node004',
    'pages/syntheticHelm/node005',
    'pages/syntheticHelm/node006',
    'pages/syntheticHelm/node007',
    'pages/syntheticHelm/node008',
    'pages/syntheticHelm/node009',
    'pages/syntheticHelm/node010',
    'pages/syntheticHelm/node011',
    'pages/syntheticHelm/node012',
    'pages/syntheticHelm/node013',
    'pages/syntheticHelm/node014',
    'pages/syntheticHelm/node015',
    'pages/syntheticHelm/node016',
    'pages/syntheticHelm/node017',
    'pages/syntheticHelm/node018',
    'pages/syntheticHelm/node019',
    'pages/syntheticHelm/node020',
    'pages/syntheticHelm/node021',
    'pages/syntheticHelm/node022',
    'pages/syntheticHelm/node023',
    'pages/syntheticHelm/node024',
    'pages/syntheticHelm/node025',
    'pages/syntheticHelm/node026',
    'pages/syntheticHelm/node027',
    'pages/syntheticHelm/node028',
    'pages/syntheticHelm/node029',
    'pages/syntheticHelm/node030',
    'pages/syntheticHelm/node031',
    'pages/syntheticHelm/node032',
    'pages/syntheticHelm/node033',
    'pages/syntheticHelm/node034',
    'pages/syntheticHelm/node035',
    'pages/syntheticHelm/node036',
    'pages/syntheticHelm/node037',
    'pages/syntheticHelm/node038',
    'pages/syntheticHelm/node039',
    'pages/syntheticHelm/node040',
    'pages/syntheticHelm/node041',
    'pages/syntheticHelm/node042',
    'pages/syntheticHelm/node043',
    'pages/syntheticHelm/node044',
    'pages/syntheticHelm/node045',
    'pages/syntheticHelm/node046',
    'pages/syntheticHelm/node047',
    'pages/syntheticHelm/node048',
    'pages/syntheticHelm/node049',
    'pages/syntheticHelm/node050',
    'pages/syntheticHelm/node051',
    'pages/syntheticHelm/node052',
    'pages/syntheticHelm/node053',
    'pages/syntheticHelm/node054',
    'pages/syntheticHelm/node055',
    'pages/syntheticHelm/node056',
    'pages/syntheticHelm/node057',
    'pages/syntheticHelm/node058',
    'pages/syntheticHelm/node059',
    'pages/syntheticHelm/node060',
    'pages/syntheticHelm/node061',
    'pages/syntheticHelm/node062',
    'pages/syntheticHelm/node063',
    'pages/syntheticHelm/node064',
    'pages/syntheticHelm/node065',
    'pages/syntheticHelm/node066',
    'pages/syntheticHelm/node067',
    'pages/syntheticHelm/node068',
    'pages/syntheticHelm/node069',
    'pages/syntheticHelm/node070',
    'pages/syntheticHelm/node071',
    'pages/syntheticHelm/node072',
    'pages/syntheticHelm/node073',
    'pages/syntheticHelm/node074',
    'pages/syntheticHelm/node075',
    'pages/syntheticHelm/node076',
    'pages/syntheticHelm/node077',
    'pages/syntheticHelm/node078',
    'pages/syntheticHelm/node079',
    'pages/syntheticHelm/node080',
    'pages/syntheticHelm/node081',
    'pages/syntheticHelm/node082',
    'pages/syntheticHelm/node083',
    'pages/syntheticHelm/node084',
    'pages/syntheticHelm/node085',
    'pages/syntheticHelm/node086',
    'pages/syntheticHelm/node087',
    'pages/syntheticHelm/node088',
    'pages/syntheticHelm/node089',
    'pages/syntheticHelm/node090',
    'pages/syntheticHelm/node091',
    'pages/syntheticHelm/node092',
    'pages/syntheticHelm/node093',
    'pages/syntheticHelm/node094',
    'pages/syntheticHelm/node095',
    'pages/syntheticHelm/node096',
    'pages/syntheticHelm/node097',
    'pages/syntheticHelm/node098',
    'pages/syntheticHelm/node099',
    'pages/syntheticHelm/node100',
    'pages/syntheticHelm/node101',
    'pages/syntheticHelm/node102',
    'pages/syntheticHelm/node103',
    'pages/syntheticHelm/node104',
    'pages/syntheticHelm/node105',
    'pages/syntheticHelm/node106',
    'pages/syntheticHelm/node107',
    'pages/syntheticHelm/node108',
    'pages/syntheticHelm/node109',
    'pages/syntheticHelm/node110',
    'pages/syntheticHelm/node111',
    'pages/syntheticHelm/node112',
    'pages/syntheticHelm/node113',
    'pages/syntheticHelm/node114',
    'pages/syntheticHelm/node115',
    'pages/syntheticHelm/node116',
    'pages/syntheticHelm/node117',
    'pages/syntheticHelm/node118',
    'pages/syntheticHelm/node119',
    'pages/syntheticHelm/node120',
    'pages/syntheticHelm/node121',
    'pages/syntheticHelm/node122',
    'pages/syntheticHelm/node123',
    'pages/syntheticHelm/node124',
    'pages/syntheticHelm/node125',
    'pages/syntheticHelm/node126',
    'pages/syntheticHelm/node127',
    'pages/syntheticHelm/node128',
    'pages/syntheticHelm/node129',
    'pages/syntheticHelm/node130',
    'pages/syntheticHelm/node131',
    'pages/syntheticHelm/node132',
    'pages/syntheticHelm/node133',
    'pages/syntheticHelm/node134',
    'pages/syntheticHelm/node135',
    'pages/syntheticHelm/node136',
    'pages/syntheticHelm/node137',
    'pages/syntheticHelm/node138',
    'pages/syntheticHelm/node139',
    'pages/syntheticHelm/node140',
    'pages/syntheticHelm/node141',
    'pages/syntheticHelm/node142',
    'pages/syntheticHelm/node143',
    'pages/syntheticHelm/node144',
    'pages/syntheticHelm/node145',
    'pages/syntheticHelm/node146',
    'pages/syntheticHelm/node147',
    'pages/syntheticHelm/node148',
    'pages/syntheticHelm/node149',
    'pages/syntheticHelm/node150',
    'pages/syntheticHelm/node151',
    'pages/syntheticHelm/node152',
    'pages/syntheticHelm/node153',
    'pages/syntheticHelm/node154',
    'pages/syntheticHelm/node155',
    'pages/syntheticHelm/node156',
    'pages/syntheticHelm/node157',
    'pages/syntheticHelm/node158',
    'pages/syntheticHelm/node159',
    'pages/syntheticHelm/node160'
  ];

  describe('MegaSyntheticRouteAtlasHelmSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteHelm_[A-Za-z0-9_]+_[0-9]{3}$/;
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

