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
  return /^pages\/syntheticParagon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasParagonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteParagon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticParagon/node001',
    'pages/syntheticParagon/node002',
    'pages/syntheticParagon/node003',
    'pages/syntheticParagon/node004',
    'pages/syntheticParagon/node005',
    'pages/syntheticParagon/node006',
    'pages/syntheticParagon/node007',
    'pages/syntheticParagon/node008',
    'pages/syntheticParagon/node009',
    'pages/syntheticParagon/node010',
    'pages/syntheticParagon/node011',
    'pages/syntheticParagon/node012',
    'pages/syntheticParagon/node013',
    'pages/syntheticParagon/node014',
    'pages/syntheticParagon/node015',
    'pages/syntheticParagon/node016',
    'pages/syntheticParagon/node017',
    'pages/syntheticParagon/node018',
    'pages/syntheticParagon/node019',
    'pages/syntheticParagon/node020',
    'pages/syntheticParagon/node021',
    'pages/syntheticParagon/node022',
    'pages/syntheticParagon/node023',
    'pages/syntheticParagon/node024',
    'pages/syntheticParagon/node025',
    'pages/syntheticParagon/node026',
    'pages/syntheticParagon/node027',
    'pages/syntheticParagon/node028',
    'pages/syntheticParagon/node029',
    'pages/syntheticParagon/node030',
    'pages/syntheticParagon/node031',
    'pages/syntheticParagon/node032',
    'pages/syntheticParagon/node033',
    'pages/syntheticParagon/node034',
    'pages/syntheticParagon/node035',
    'pages/syntheticParagon/node036',
    'pages/syntheticParagon/node037',
    'pages/syntheticParagon/node038',
    'pages/syntheticParagon/node039',
    'pages/syntheticParagon/node040',
    'pages/syntheticParagon/node041',
    'pages/syntheticParagon/node042',
    'pages/syntheticParagon/node043',
    'pages/syntheticParagon/node044',
    'pages/syntheticParagon/node045',
    'pages/syntheticParagon/node046',
    'pages/syntheticParagon/node047',
    'pages/syntheticParagon/node048',
    'pages/syntheticParagon/node049',
    'pages/syntheticParagon/node050',
    'pages/syntheticParagon/node051',
    'pages/syntheticParagon/node052',
    'pages/syntheticParagon/node053',
    'pages/syntheticParagon/node054',
    'pages/syntheticParagon/node055',
    'pages/syntheticParagon/node056',
    'pages/syntheticParagon/node057',
    'pages/syntheticParagon/node058',
    'pages/syntheticParagon/node059',
    'pages/syntheticParagon/node060',
    'pages/syntheticParagon/node061',
    'pages/syntheticParagon/node062',
    'pages/syntheticParagon/node063',
    'pages/syntheticParagon/node064',
    'pages/syntheticParagon/node065',
    'pages/syntheticParagon/node066',
    'pages/syntheticParagon/node067',
    'pages/syntheticParagon/node068',
    'pages/syntheticParagon/node069',
    'pages/syntheticParagon/node070',
    'pages/syntheticParagon/node071',
    'pages/syntheticParagon/node072',
    'pages/syntheticParagon/node073',
    'pages/syntheticParagon/node074',
    'pages/syntheticParagon/node075',
    'pages/syntheticParagon/node076',
    'pages/syntheticParagon/node077',
    'pages/syntheticParagon/node078',
    'pages/syntheticParagon/node079',
    'pages/syntheticParagon/node080',
    'pages/syntheticParagon/node081',
    'pages/syntheticParagon/node082',
    'pages/syntheticParagon/node083',
    'pages/syntheticParagon/node084',
    'pages/syntheticParagon/node085',
    'pages/syntheticParagon/node086',
    'pages/syntheticParagon/node087',
    'pages/syntheticParagon/node088',
    'pages/syntheticParagon/node089',
    'pages/syntheticParagon/node090',
    'pages/syntheticParagon/node091',
    'pages/syntheticParagon/node092',
    'pages/syntheticParagon/node093',
    'pages/syntheticParagon/node094',
    'pages/syntheticParagon/node095',
    'pages/syntheticParagon/node096',
    'pages/syntheticParagon/node097',
    'pages/syntheticParagon/node098',
    'pages/syntheticParagon/node099',
    'pages/syntheticParagon/node100',
    'pages/syntheticParagon/node101',
    'pages/syntheticParagon/node102',
    'pages/syntheticParagon/node103',
    'pages/syntheticParagon/node104',
    'pages/syntheticParagon/node105',
    'pages/syntheticParagon/node106',
    'pages/syntheticParagon/node107',
    'pages/syntheticParagon/node108',
    'pages/syntheticParagon/node109',
    'pages/syntheticParagon/node110',
    'pages/syntheticParagon/node111',
    'pages/syntheticParagon/node112',
    'pages/syntheticParagon/node113',
    'pages/syntheticParagon/node114',
    'pages/syntheticParagon/node115',
    'pages/syntheticParagon/node116',
    'pages/syntheticParagon/node117',
    'pages/syntheticParagon/node118',
    'pages/syntheticParagon/node119',
    'pages/syntheticParagon/node120',
    'pages/syntheticParagon/node121',
    'pages/syntheticParagon/node122',
    'pages/syntheticParagon/node123',
    'pages/syntheticParagon/node124',
    'pages/syntheticParagon/node125',
    'pages/syntheticParagon/node126',
    'pages/syntheticParagon/node127',
    'pages/syntheticParagon/node128',
    'pages/syntheticParagon/node129',
    'pages/syntheticParagon/node130',
    'pages/syntheticParagon/node131',
    'pages/syntheticParagon/node132',
    'pages/syntheticParagon/node133',
    'pages/syntheticParagon/node134',
    'pages/syntheticParagon/node135',
    'pages/syntheticParagon/node136',
    'pages/syntheticParagon/node137',
    'pages/syntheticParagon/node138',
    'pages/syntheticParagon/node139',
    'pages/syntheticParagon/node140',
    'pages/syntheticParagon/node141',
    'pages/syntheticParagon/node142',
    'pages/syntheticParagon/node143',
    'pages/syntheticParagon/node144',
    'pages/syntheticParagon/node145',
    'pages/syntheticParagon/node146',
    'pages/syntheticParagon/node147',
    'pages/syntheticParagon/node148',
    'pages/syntheticParagon/node149',
    'pages/syntheticParagon/node150',
    'pages/syntheticParagon/node151',
    'pages/syntheticParagon/node152',
    'pages/syntheticParagon/node153',
    'pages/syntheticParagon/node154',
    'pages/syntheticParagon/node155',
    'pages/syntheticParagon/node156',
    'pages/syntheticParagon/node157',
    'pages/syntheticParagon/node158',
    'pages/syntheticParagon/node159',
    'pages/syntheticParagon/node160'
  ];

  describe('MegaSyntheticRouteAtlasParagonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteParagon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

