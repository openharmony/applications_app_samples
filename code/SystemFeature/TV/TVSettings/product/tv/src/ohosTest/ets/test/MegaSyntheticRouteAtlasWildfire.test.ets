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
  return /^pages\/syntheticWildfire\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasWildfireTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteWildfire_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticWildfire/node001',
    'pages/syntheticWildfire/node002',
    'pages/syntheticWildfire/node003',
    'pages/syntheticWildfire/node004',
    'pages/syntheticWildfire/node005',
    'pages/syntheticWildfire/node006',
    'pages/syntheticWildfire/node007',
    'pages/syntheticWildfire/node008',
    'pages/syntheticWildfire/node009',
    'pages/syntheticWildfire/node010',
    'pages/syntheticWildfire/node011',
    'pages/syntheticWildfire/node012',
    'pages/syntheticWildfire/node013',
    'pages/syntheticWildfire/node014',
    'pages/syntheticWildfire/node015',
    'pages/syntheticWildfire/node016',
    'pages/syntheticWildfire/node017',
    'pages/syntheticWildfire/node018',
    'pages/syntheticWildfire/node019',
    'pages/syntheticWildfire/node020',
    'pages/syntheticWildfire/node021',
    'pages/syntheticWildfire/node022',
    'pages/syntheticWildfire/node023',
    'pages/syntheticWildfire/node024',
    'pages/syntheticWildfire/node025',
    'pages/syntheticWildfire/node026',
    'pages/syntheticWildfire/node027',
    'pages/syntheticWildfire/node028',
    'pages/syntheticWildfire/node029',
    'pages/syntheticWildfire/node030',
    'pages/syntheticWildfire/node031',
    'pages/syntheticWildfire/node032',
    'pages/syntheticWildfire/node033',
    'pages/syntheticWildfire/node034',
    'pages/syntheticWildfire/node035',
    'pages/syntheticWildfire/node036',
    'pages/syntheticWildfire/node037',
    'pages/syntheticWildfire/node038',
    'pages/syntheticWildfire/node039',
    'pages/syntheticWildfire/node040',
    'pages/syntheticWildfire/node041',
    'pages/syntheticWildfire/node042',
    'pages/syntheticWildfire/node043',
    'pages/syntheticWildfire/node044',
    'pages/syntheticWildfire/node045',
    'pages/syntheticWildfire/node046',
    'pages/syntheticWildfire/node047',
    'pages/syntheticWildfire/node048',
    'pages/syntheticWildfire/node049',
    'pages/syntheticWildfire/node050',
    'pages/syntheticWildfire/node051',
    'pages/syntheticWildfire/node052',
    'pages/syntheticWildfire/node053',
    'pages/syntheticWildfire/node054',
    'pages/syntheticWildfire/node055',
    'pages/syntheticWildfire/node056',
    'pages/syntheticWildfire/node057',
    'pages/syntheticWildfire/node058',
    'pages/syntheticWildfire/node059',
    'pages/syntheticWildfire/node060',
    'pages/syntheticWildfire/node061',
    'pages/syntheticWildfire/node062',
    'pages/syntheticWildfire/node063',
    'pages/syntheticWildfire/node064',
    'pages/syntheticWildfire/node065',
    'pages/syntheticWildfire/node066',
    'pages/syntheticWildfire/node067',
    'pages/syntheticWildfire/node068',
    'pages/syntheticWildfire/node069',
    'pages/syntheticWildfire/node070',
    'pages/syntheticWildfire/node071',
    'pages/syntheticWildfire/node072',
    'pages/syntheticWildfire/node073',
    'pages/syntheticWildfire/node074',
    'pages/syntheticWildfire/node075',
    'pages/syntheticWildfire/node076',
    'pages/syntheticWildfire/node077',
    'pages/syntheticWildfire/node078',
    'pages/syntheticWildfire/node079',
    'pages/syntheticWildfire/node080',
    'pages/syntheticWildfire/node081',
    'pages/syntheticWildfire/node082',
    'pages/syntheticWildfire/node083',
    'pages/syntheticWildfire/node084',
    'pages/syntheticWildfire/node085',
    'pages/syntheticWildfire/node086',
    'pages/syntheticWildfire/node087',
    'pages/syntheticWildfire/node088',
    'pages/syntheticWildfire/node089',
    'pages/syntheticWildfire/node090',
    'pages/syntheticWildfire/node091',
    'pages/syntheticWildfire/node092',
    'pages/syntheticWildfire/node093',
    'pages/syntheticWildfire/node094',
    'pages/syntheticWildfire/node095',
    'pages/syntheticWildfire/node096',
    'pages/syntheticWildfire/node097',
    'pages/syntheticWildfire/node098',
    'pages/syntheticWildfire/node099',
    'pages/syntheticWildfire/node100',
    'pages/syntheticWildfire/node101',
    'pages/syntheticWildfire/node102',
    'pages/syntheticWildfire/node103',
    'pages/syntheticWildfire/node104',
    'pages/syntheticWildfire/node105',
    'pages/syntheticWildfire/node106',
    'pages/syntheticWildfire/node107',
    'pages/syntheticWildfire/node108',
    'pages/syntheticWildfire/node109',
    'pages/syntheticWildfire/node110',
    'pages/syntheticWildfire/node111',
    'pages/syntheticWildfire/node112',
    'pages/syntheticWildfire/node113',
    'pages/syntheticWildfire/node114',
    'pages/syntheticWildfire/node115',
    'pages/syntheticWildfire/node116',
    'pages/syntheticWildfire/node117',
    'pages/syntheticWildfire/node118',
    'pages/syntheticWildfire/node119',
    'pages/syntheticWildfire/node120',
    'pages/syntheticWildfire/node121',
    'pages/syntheticWildfire/node122',
    'pages/syntheticWildfire/node123',
    'pages/syntheticWildfire/node124',
    'pages/syntheticWildfire/node125',
    'pages/syntheticWildfire/node126',
    'pages/syntheticWildfire/node127',
    'pages/syntheticWildfire/node128',
    'pages/syntheticWildfire/node129',
    'pages/syntheticWildfire/node130',
    'pages/syntheticWildfire/node131',
    'pages/syntheticWildfire/node132',
    'pages/syntheticWildfire/node133',
    'pages/syntheticWildfire/node134',
    'pages/syntheticWildfire/node135',
    'pages/syntheticWildfire/node136',
    'pages/syntheticWildfire/node137',
    'pages/syntheticWildfire/node138',
    'pages/syntheticWildfire/node139',
    'pages/syntheticWildfire/node140',
    'pages/syntheticWildfire/node141',
    'pages/syntheticWildfire/node142',
    'pages/syntheticWildfire/node143',
    'pages/syntheticWildfire/node144',
    'pages/syntheticWildfire/node145',
    'pages/syntheticWildfire/node146',
    'pages/syntheticWildfire/node147',
    'pages/syntheticWildfire/node148',
    'pages/syntheticWildfire/node149',
    'pages/syntheticWildfire/node150',
    'pages/syntheticWildfire/node151',
    'pages/syntheticWildfire/node152',
    'pages/syntheticWildfire/node153',
    'pages/syntheticWildfire/node154',
    'pages/syntheticWildfire/node155',
    'pages/syntheticWildfire/node156',
    'pages/syntheticWildfire/node157',
    'pages/syntheticWildfire/node158',
    'pages/syntheticWildfire/node159',
    'pages/syntheticWildfire/node160'
  ];

  describe('MegaSyntheticRouteAtlasWildfireSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteWildfire_[A-Za-z0-9_]+_[0-9]{3}$/;
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

