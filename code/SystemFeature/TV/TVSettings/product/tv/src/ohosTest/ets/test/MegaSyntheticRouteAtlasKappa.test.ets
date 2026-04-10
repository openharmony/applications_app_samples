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
  return /^pages\/syntheticKappa\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasKappaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteKappa_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticKappa/node001',
    'pages/syntheticKappa/node002',
    'pages/syntheticKappa/node003',
    'pages/syntheticKappa/node004',
    'pages/syntheticKappa/node005',
    'pages/syntheticKappa/node006',
    'pages/syntheticKappa/node007',
    'pages/syntheticKappa/node008',
    'pages/syntheticKappa/node009',
    'pages/syntheticKappa/node010',
    'pages/syntheticKappa/node011',
    'pages/syntheticKappa/node012',
    'pages/syntheticKappa/node013',
    'pages/syntheticKappa/node014',
    'pages/syntheticKappa/node015',
    'pages/syntheticKappa/node016',
    'pages/syntheticKappa/node017',
    'pages/syntheticKappa/node018',
    'pages/syntheticKappa/node019',
    'pages/syntheticKappa/node020',
    'pages/syntheticKappa/node021',
    'pages/syntheticKappa/node022',
    'pages/syntheticKappa/node023',
    'pages/syntheticKappa/node024',
    'pages/syntheticKappa/node025',
    'pages/syntheticKappa/node026',
    'pages/syntheticKappa/node027',
    'pages/syntheticKappa/node028',
    'pages/syntheticKappa/node029',
    'pages/syntheticKappa/node030',
    'pages/syntheticKappa/node031',
    'pages/syntheticKappa/node032',
    'pages/syntheticKappa/node033',
    'pages/syntheticKappa/node034',
    'pages/syntheticKappa/node035',
    'pages/syntheticKappa/node036',
    'pages/syntheticKappa/node037',
    'pages/syntheticKappa/node038',
    'pages/syntheticKappa/node039',
    'pages/syntheticKappa/node040',
    'pages/syntheticKappa/node041',
    'pages/syntheticKappa/node042',
    'pages/syntheticKappa/node043',
    'pages/syntheticKappa/node044',
    'pages/syntheticKappa/node045',
    'pages/syntheticKappa/node046',
    'pages/syntheticKappa/node047',
    'pages/syntheticKappa/node048',
    'pages/syntheticKappa/node049',
    'pages/syntheticKappa/node050',
    'pages/syntheticKappa/node051',
    'pages/syntheticKappa/node052',
    'pages/syntheticKappa/node053',
    'pages/syntheticKappa/node054',
    'pages/syntheticKappa/node055',
    'pages/syntheticKappa/node056',
    'pages/syntheticKappa/node057',
    'pages/syntheticKappa/node058',
    'pages/syntheticKappa/node059',
    'pages/syntheticKappa/node060',
    'pages/syntheticKappa/node061',
    'pages/syntheticKappa/node062',
    'pages/syntheticKappa/node063',
    'pages/syntheticKappa/node064',
    'pages/syntheticKappa/node065',
    'pages/syntheticKappa/node066',
    'pages/syntheticKappa/node067',
    'pages/syntheticKappa/node068',
    'pages/syntheticKappa/node069',
    'pages/syntheticKappa/node070',
    'pages/syntheticKappa/node071',
    'pages/syntheticKappa/node072',
    'pages/syntheticKappa/node073',
    'pages/syntheticKappa/node074',
    'pages/syntheticKappa/node075',
    'pages/syntheticKappa/node076',
    'pages/syntheticKappa/node077',
    'pages/syntheticKappa/node078',
    'pages/syntheticKappa/node079',
    'pages/syntheticKappa/node080',
    'pages/syntheticKappa/node081',
    'pages/syntheticKappa/node082',
    'pages/syntheticKappa/node083',
    'pages/syntheticKappa/node084',
    'pages/syntheticKappa/node085',
    'pages/syntheticKappa/node086',
    'pages/syntheticKappa/node087',
    'pages/syntheticKappa/node088',
    'pages/syntheticKappa/node089',
    'pages/syntheticKappa/node090',
    'pages/syntheticKappa/node091',
    'pages/syntheticKappa/node092',
    'pages/syntheticKappa/node093',
    'pages/syntheticKappa/node094',
    'pages/syntheticKappa/node095',
    'pages/syntheticKappa/node096',
    'pages/syntheticKappa/node097',
    'pages/syntheticKappa/node098',
    'pages/syntheticKappa/node099',
    'pages/syntheticKappa/node100',
    'pages/syntheticKappa/node101',
    'pages/syntheticKappa/node102',
    'pages/syntheticKappa/node103',
    'pages/syntheticKappa/node104',
    'pages/syntheticKappa/node105',
    'pages/syntheticKappa/node106',
    'pages/syntheticKappa/node107',
    'pages/syntheticKappa/node108',
    'pages/syntheticKappa/node109',
    'pages/syntheticKappa/node110',
    'pages/syntheticKappa/node111',
    'pages/syntheticKappa/node112',
    'pages/syntheticKappa/node113',
    'pages/syntheticKappa/node114',
    'pages/syntheticKappa/node115',
    'pages/syntheticKappa/node116',
    'pages/syntheticKappa/node117',
    'pages/syntheticKappa/node118',
    'pages/syntheticKappa/node119',
    'pages/syntheticKappa/node120',
    'pages/syntheticKappa/node121',
    'pages/syntheticKappa/node122',
    'pages/syntheticKappa/node123',
    'pages/syntheticKappa/node124',
    'pages/syntheticKappa/node125',
    'pages/syntheticKappa/node126',
    'pages/syntheticKappa/node127',
    'pages/syntheticKappa/node128',
    'pages/syntheticKappa/node129',
    'pages/syntheticKappa/node130',
    'pages/syntheticKappa/node131',
    'pages/syntheticKappa/node132',
    'pages/syntheticKappa/node133',
    'pages/syntheticKappa/node134',
    'pages/syntheticKappa/node135',
    'pages/syntheticKappa/node136',
    'pages/syntheticKappa/node137',
    'pages/syntheticKappa/node138',
    'pages/syntheticKappa/node139',
    'pages/syntheticKappa/node140',
    'pages/syntheticKappa/node141',
    'pages/syntheticKappa/node142',
    'pages/syntheticKappa/node143',
    'pages/syntheticKappa/node144',
    'pages/syntheticKappa/node145',
    'pages/syntheticKappa/node146',
    'pages/syntheticKappa/node147',
    'pages/syntheticKappa/node148',
    'pages/syntheticKappa/node149',
    'pages/syntheticKappa/node150',
    'pages/syntheticKappa/node151',
    'pages/syntheticKappa/node152',
    'pages/syntheticKappa/node153',
    'pages/syntheticKappa/node154',
    'pages/syntheticKappa/node155',
    'pages/syntheticKappa/node156',
    'pages/syntheticKappa/node157',
    'pages/syntheticKappa/node158',
    'pages/syntheticKappa/node159',
    'pages/syntheticKappa/node160'
  ];

  describe('MegaSyntheticRouteAtlasKappaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteKappa_[A-Za-z0-9_]+_[0-9]{3}$/;
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

