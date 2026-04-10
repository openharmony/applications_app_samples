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
  return /^pages\/syntheticKeystone\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasKeystoneTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteKeystone_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticKeystone/node001',
    'pages/syntheticKeystone/node002',
    'pages/syntheticKeystone/node003',
    'pages/syntheticKeystone/node004',
    'pages/syntheticKeystone/node005',
    'pages/syntheticKeystone/node006',
    'pages/syntheticKeystone/node007',
    'pages/syntheticKeystone/node008',
    'pages/syntheticKeystone/node009',
    'pages/syntheticKeystone/node010',
    'pages/syntheticKeystone/node011',
    'pages/syntheticKeystone/node012',
    'pages/syntheticKeystone/node013',
    'pages/syntheticKeystone/node014',
    'pages/syntheticKeystone/node015',
    'pages/syntheticKeystone/node016',
    'pages/syntheticKeystone/node017',
    'pages/syntheticKeystone/node018',
    'pages/syntheticKeystone/node019',
    'pages/syntheticKeystone/node020',
    'pages/syntheticKeystone/node021',
    'pages/syntheticKeystone/node022',
    'pages/syntheticKeystone/node023',
    'pages/syntheticKeystone/node024',
    'pages/syntheticKeystone/node025',
    'pages/syntheticKeystone/node026',
    'pages/syntheticKeystone/node027',
    'pages/syntheticKeystone/node028',
    'pages/syntheticKeystone/node029',
    'pages/syntheticKeystone/node030',
    'pages/syntheticKeystone/node031',
    'pages/syntheticKeystone/node032',
    'pages/syntheticKeystone/node033',
    'pages/syntheticKeystone/node034',
    'pages/syntheticKeystone/node035',
    'pages/syntheticKeystone/node036',
    'pages/syntheticKeystone/node037',
    'pages/syntheticKeystone/node038',
    'pages/syntheticKeystone/node039',
    'pages/syntheticKeystone/node040',
    'pages/syntheticKeystone/node041',
    'pages/syntheticKeystone/node042',
    'pages/syntheticKeystone/node043',
    'pages/syntheticKeystone/node044',
    'pages/syntheticKeystone/node045',
    'pages/syntheticKeystone/node046',
    'pages/syntheticKeystone/node047',
    'pages/syntheticKeystone/node048',
    'pages/syntheticKeystone/node049',
    'pages/syntheticKeystone/node050',
    'pages/syntheticKeystone/node051',
    'pages/syntheticKeystone/node052',
    'pages/syntheticKeystone/node053',
    'pages/syntheticKeystone/node054',
    'pages/syntheticKeystone/node055',
    'pages/syntheticKeystone/node056',
    'pages/syntheticKeystone/node057',
    'pages/syntheticKeystone/node058',
    'pages/syntheticKeystone/node059',
    'pages/syntheticKeystone/node060',
    'pages/syntheticKeystone/node061',
    'pages/syntheticKeystone/node062',
    'pages/syntheticKeystone/node063',
    'pages/syntheticKeystone/node064',
    'pages/syntheticKeystone/node065',
    'pages/syntheticKeystone/node066',
    'pages/syntheticKeystone/node067',
    'pages/syntheticKeystone/node068',
    'pages/syntheticKeystone/node069',
    'pages/syntheticKeystone/node070',
    'pages/syntheticKeystone/node071',
    'pages/syntheticKeystone/node072',
    'pages/syntheticKeystone/node073',
    'pages/syntheticKeystone/node074',
    'pages/syntheticKeystone/node075',
    'pages/syntheticKeystone/node076',
    'pages/syntheticKeystone/node077',
    'pages/syntheticKeystone/node078',
    'pages/syntheticKeystone/node079',
    'pages/syntheticKeystone/node080',
    'pages/syntheticKeystone/node081',
    'pages/syntheticKeystone/node082',
    'pages/syntheticKeystone/node083',
    'pages/syntheticKeystone/node084',
    'pages/syntheticKeystone/node085',
    'pages/syntheticKeystone/node086',
    'pages/syntheticKeystone/node087',
    'pages/syntheticKeystone/node088',
    'pages/syntheticKeystone/node089',
    'pages/syntheticKeystone/node090',
    'pages/syntheticKeystone/node091',
    'pages/syntheticKeystone/node092',
    'pages/syntheticKeystone/node093',
    'pages/syntheticKeystone/node094',
    'pages/syntheticKeystone/node095',
    'pages/syntheticKeystone/node096',
    'pages/syntheticKeystone/node097',
    'pages/syntheticKeystone/node098',
    'pages/syntheticKeystone/node099',
    'pages/syntheticKeystone/node100',
    'pages/syntheticKeystone/node101',
    'pages/syntheticKeystone/node102',
    'pages/syntheticKeystone/node103',
    'pages/syntheticKeystone/node104',
    'pages/syntheticKeystone/node105',
    'pages/syntheticKeystone/node106',
    'pages/syntheticKeystone/node107',
    'pages/syntheticKeystone/node108',
    'pages/syntheticKeystone/node109',
    'pages/syntheticKeystone/node110',
    'pages/syntheticKeystone/node111',
    'pages/syntheticKeystone/node112',
    'pages/syntheticKeystone/node113',
    'pages/syntheticKeystone/node114',
    'pages/syntheticKeystone/node115',
    'pages/syntheticKeystone/node116',
    'pages/syntheticKeystone/node117',
    'pages/syntheticKeystone/node118',
    'pages/syntheticKeystone/node119',
    'pages/syntheticKeystone/node120',
    'pages/syntheticKeystone/node121',
    'pages/syntheticKeystone/node122',
    'pages/syntheticKeystone/node123',
    'pages/syntheticKeystone/node124',
    'pages/syntheticKeystone/node125',
    'pages/syntheticKeystone/node126',
    'pages/syntheticKeystone/node127',
    'pages/syntheticKeystone/node128',
    'pages/syntheticKeystone/node129',
    'pages/syntheticKeystone/node130',
    'pages/syntheticKeystone/node131',
    'pages/syntheticKeystone/node132',
    'pages/syntheticKeystone/node133',
    'pages/syntheticKeystone/node134',
    'pages/syntheticKeystone/node135',
    'pages/syntheticKeystone/node136',
    'pages/syntheticKeystone/node137',
    'pages/syntheticKeystone/node138',
    'pages/syntheticKeystone/node139',
    'pages/syntheticKeystone/node140',
    'pages/syntheticKeystone/node141',
    'pages/syntheticKeystone/node142',
    'pages/syntheticKeystone/node143',
    'pages/syntheticKeystone/node144',
    'pages/syntheticKeystone/node145',
    'pages/syntheticKeystone/node146',
    'pages/syntheticKeystone/node147',
    'pages/syntheticKeystone/node148',
    'pages/syntheticKeystone/node149',
    'pages/syntheticKeystone/node150',
    'pages/syntheticKeystone/node151',
    'pages/syntheticKeystone/node152',
    'pages/syntheticKeystone/node153',
    'pages/syntheticKeystone/node154',
    'pages/syntheticKeystone/node155',
    'pages/syntheticKeystone/node156',
    'pages/syntheticKeystone/node157',
    'pages/syntheticKeystone/node158',
    'pages/syntheticKeystone/node159',
    'pages/syntheticKeystone/node160'
  ];

  describe('MegaSyntheticRouteAtlasKeystoneSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteKeystone_[A-Za-z0-9_]+_[0-9]{3}$/;
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

