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
  return /^pages\/syntheticKestrel\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasKestrelTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteKestrel_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticKestrel/node001',
    'pages/syntheticKestrel/node002',
    'pages/syntheticKestrel/node003',
    'pages/syntheticKestrel/node004',
    'pages/syntheticKestrel/node005',
    'pages/syntheticKestrel/node006',
    'pages/syntheticKestrel/node007',
    'pages/syntheticKestrel/node008',
    'pages/syntheticKestrel/node009',
    'pages/syntheticKestrel/node010',
    'pages/syntheticKestrel/node011',
    'pages/syntheticKestrel/node012',
    'pages/syntheticKestrel/node013',
    'pages/syntheticKestrel/node014',
    'pages/syntheticKestrel/node015',
    'pages/syntheticKestrel/node016',
    'pages/syntheticKestrel/node017',
    'pages/syntheticKestrel/node018',
    'pages/syntheticKestrel/node019',
    'pages/syntheticKestrel/node020',
    'pages/syntheticKestrel/node021',
    'pages/syntheticKestrel/node022',
    'pages/syntheticKestrel/node023',
    'pages/syntheticKestrel/node024',
    'pages/syntheticKestrel/node025',
    'pages/syntheticKestrel/node026',
    'pages/syntheticKestrel/node027',
    'pages/syntheticKestrel/node028',
    'pages/syntheticKestrel/node029',
    'pages/syntheticKestrel/node030',
    'pages/syntheticKestrel/node031',
    'pages/syntheticKestrel/node032',
    'pages/syntheticKestrel/node033',
    'pages/syntheticKestrel/node034',
    'pages/syntheticKestrel/node035',
    'pages/syntheticKestrel/node036',
    'pages/syntheticKestrel/node037',
    'pages/syntheticKestrel/node038',
    'pages/syntheticKestrel/node039',
    'pages/syntheticKestrel/node040',
    'pages/syntheticKestrel/node041',
    'pages/syntheticKestrel/node042',
    'pages/syntheticKestrel/node043',
    'pages/syntheticKestrel/node044',
    'pages/syntheticKestrel/node045',
    'pages/syntheticKestrel/node046',
    'pages/syntheticKestrel/node047',
    'pages/syntheticKestrel/node048',
    'pages/syntheticKestrel/node049',
    'pages/syntheticKestrel/node050',
    'pages/syntheticKestrel/node051',
    'pages/syntheticKestrel/node052',
    'pages/syntheticKestrel/node053',
    'pages/syntheticKestrel/node054',
    'pages/syntheticKestrel/node055',
    'pages/syntheticKestrel/node056',
    'pages/syntheticKestrel/node057',
    'pages/syntheticKestrel/node058',
    'pages/syntheticKestrel/node059',
    'pages/syntheticKestrel/node060',
    'pages/syntheticKestrel/node061',
    'pages/syntheticKestrel/node062',
    'pages/syntheticKestrel/node063',
    'pages/syntheticKestrel/node064',
    'pages/syntheticKestrel/node065',
    'pages/syntheticKestrel/node066',
    'pages/syntheticKestrel/node067',
    'pages/syntheticKestrel/node068',
    'pages/syntheticKestrel/node069',
    'pages/syntheticKestrel/node070',
    'pages/syntheticKestrel/node071',
    'pages/syntheticKestrel/node072',
    'pages/syntheticKestrel/node073',
    'pages/syntheticKestrel/node074',
    'pages/syntheticKestrel/node075',
    'pages/syntheticKestrel/node076',
    'pages/syntheticKestrel/node077',
    'pages/syntheticKestrel/node078',
    'pages/syntheticKestrel/node079',
    'pages/syntheticKestrel/node080',
    'pages/syntheticKestrel/node081',
    'pages/syntheticKestrel/node082',
    'pages/syntheticKestrel/node083',
    'pages/syntheticKestrel/node084',
    'pages/syntheticKestrel/node085',
    'pages/syntheticKestrel/node086',
    'pages/syntheticKestrel/node087',
    'pages/syntheticKestrel/node088',
    'pages/syntheticKestrel/node089',
    'pages/syntheticKestrel/node090',
    'pages/syntheticKestrel/node091',
    'pages/syntheticKestrel/node092',
    'pages/syntheticKestrel/node093',
    'pages/syntheticKestrel/node094',
    'pages/syntheticKestrel/node095',
    'pages/syntheticKestrel/node096',
    'pages/syntheticKestrel/node097',
    'pages/syntheticKestrel/node098',
    'pages/syntheticKestrel/node099',
    'pages/syntheticKestrel/node100',
    'pages/syntheticKestrel/node101',
    'pages/syntheticKestrel/node102',
    'pages/syntheticKestrel/node103',
    'pages/syntheticKestrel/node104',
    'pages/syntheticKestrel/node105',
    'pages/syntheticKestrel/node106',
    'pages/syntheticKestrel/node107',
    'pages/syntheticKestrel/node108',
    'pages/syntheticKestrel/node109',
    'pages/syntheticKestrel/node110',
    'pages/syntheticKestrel/node111',
    'pages/syntheticKestrel/node112',
    'pages/syntheticKestrel/node113',
    'pages/syntheticKestrel/node114',
    'pages/syntheticKestrel/node115',
    'pages/syntheticKestrel/node116',
    'pages/syntheticKestrel/node117',
    'pages/syntheticKestrel/node118',
    'pages/syntheticKestrel/node119',
    'pages/syntheticKestrel/node120',
    'pages/syntheticKestrel/node121',
    'pages/syntheticKestrel/node122',
    'pages/syntheticKestrel/node123',
    'pages/syntheticKestrel/node124',
    'pages/syntheticKestrel/node125',
    'pages/syntheticKestrel/node126',
    'pages/syntheticKestrel/node127',
    'pages/syntheticKestrel/node128',
    'pages/syntheticKestrel/node129',
    'pages/syntheticKestrel/node130',
    'pages/syntheticKestrel/node131',
    'pages/syntheticKestrel/node132',
    'pages/syntheticKestrel/node133',
    'pages/syntheticKestrel/node134',
    'pages/syntheticKestrel/node135',
    'pages/syntheticKestrel/node136',
    'pages/syntheticKestrel/node137',
    'pages/syntheticKestrel/node138',
    'pages/syntheticKestrel/node139',
    'pages/syntheticKestrel/node140',
    'pages/syntheticKestrel/node141',
    'pages/syntheticKestrel/node142',
    'pages/syntheticKestrel/node143',
    'pages/syntheticKestrel/node144',
    'pages/syntheticKestrel/node145',
    'pages/syntheticKestrel/node146',
    'pages/syntheticKestrel/node147',
    'pages/syntheticKestrel/node148',
    'pages/syntheticKestrel/node149',
    'pages/syntheticKestrel/node150',
    'pages/syntheticKestrel/node151',
    'pages/syntheticKestrel/node152',
    'pages/syntheticKestrel/node153',
    'pages/syntheticKestrel/node154',
    'pages/syntheticKestrel/node155',
    'pages/syntheticKestrel/node156',
    'pages/syntheticKestrel/node157',
    'pages/syntheticKestrel/node158',
    'pages/syntheticKestrel/node159',
    'pages/syntheticKestrel/node160'
  ];

  describe('MegaSyntheticRouteAtlasKestrelSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteKestrel_[A-Za-z0-9_]+_[0-9]{3}$/;
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

