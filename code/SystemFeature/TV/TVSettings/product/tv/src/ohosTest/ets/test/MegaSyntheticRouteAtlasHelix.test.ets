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
  return /^pages\/syntheticHelix\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasHelixTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteHelix_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticHelix/node001',
    'pages/syntheticHelix/node002',
    'pages/syntheticHelix/node003',
    'pages/syntheticHelix/node004',
    'pages/syntheticHelix/node005',
    'pages/syntheticHelix/node006',
    'pages/syntheticHelix/node007',
    'pages/syntheticHelix/node008',
    'pages/syntheticHelix/node009',
    'pages/syntheticHelix/node010',
    'pages/syntheticHelix/node011',
    'pages/syntheticHelix/node012',
    'pages/syntheticHelix/node013',
    'pages/syntheticHelix/node014',
    'pages/syntheticHelix/node015',
    'pages/syntheticHelix/node016',
    'pages/syntheticHelix/node017',
    'pages/syntheticHelix/node018',
    'pages/syntheticHelix/node019',
    'pages/syntheticHelix/node020',
    'pages/syntheticHelix/node021',
    'pages/syntheticHelix/node022',
    'pages/syntheticHelix/node023',
    'pages/syntheticHelix/node024',
    'pages/syntheticHelix/node025',
    'pages/syntheticHelix/node026',
    'pages/syntheticHelix/node027',
    'pages/syntheticHelix/node028',
    'pages/syntheticHelix/node029',
    'pages/syntheticHelix/node030',
    'pages/syntheticHelix/node031',
    'pages/syntheticHelix/node032',
    'pages/syntheticHelix/node033',
    'pages/syntheticHelix/node034',
    'pages/syntheticHelix/node035',
    'pages/syntheticHelix/node036',
    'pages/syntheticHelix/node037',
    'pages/syntheticHelix/node038',
    'pages/syntheticHelix/node039',
    'pages/syntheticHelix/node040',
    'pages/syntheticHelix/node041',
    'pages/syntheticHelix/node042',
    'pages/syntheticHelix/node043',
    'pages/syntheticHelix/node044',
    'pages/syntheticHelix/node045',
    'pages/syntheticHelix/node046',
    'pages/syntheticHelix/node047',
    'pages/syntheticHelix/node048',
    'pages/syntheticHelix/node049',
    'pages/syntheticHelix/node050',
    'pages/syntheticHelix/node051',
    'pages/syntheticHelix/node052',
    'pages/syntheticHelix/node053',
    'pages/syntheticHelix/node054',
    'pages/syntheticHelix/node055',
    'pages/syntheticHelix/node056',
    'pages/syntheticHelix/node057',
    'pages/syntheticHelix/node058',
    'pages/syntheticHelix/node059',
    'pages/syntheticHelix/node060',
    'pages/syntheticHelix/node061',
    'pages/syntheticHelix/node062',
    'pages/syntheticHelix/node063',
    'pages/syntheticHelix/node064',
    'pages/syntheticHelix/node065',
    'pages/syntheticHelix/node066',
    'pages/syntheticHelix/node067',
    'pages/syntheticHelix/node068',
    'pages/syntheticHelix/node069',
    'pages/syntheticHelix/node070',
    'pages/syntheticHelix/node071',
    'pages/syntheticHelix/node072',
    'pages/syntheticHelix/node073',
    'pages/syntheticHelix/node074',
    'pages/syntheticHelix/node075',
    'pages/syntheticHelix/node076',
    'pages/syntheticHelix/node077',
    'pages/syntheticHelix/node078',
    'pages/syntheticHelix/node079',
    'pages/syntheticHelix/node080',
    'pages/syntheticHelix/node081',
    'pages/syntheticHelix/node082',
    'pages/syntheticHelix/node083',
    'pages/syntheticHelix/node084',
    'pages/syntheticHelix/node085',
    'pages/syntheticHelix/node086',
    'pages/syntheticHelix/node087',
    'pages/syntheticHelix/node088',
    'pages/syntheticHelix/node089',
    'pages/syntheticHelix/node090',
    'pages/syntheticHelix/node091',
    'pages/syntheticHelix/node092',
    'pages/syntheticHelix/node093',
    'pages/syntheticHelix/node094',
    'pages/syntheticHelix/node095',
    'pages/syntheticHelix/node096',
    'pages/syntheticHelix/node097',
    'pages/syntheticHelix/node098',
    'pages/syntheticHelix/node099',
    'pages/syntheticHelix/node100',
    'pages/syntheticHelix/node101',
    'pages/syntheticHelix/node102',
    'pages/syntheticHelix/node103',
    'pages/syntheticHelix/node104',
    'pages/syntheticHelix/node105',
    'pages/syntheticHelix/node106',
    'pages/syntheticHelix/node107',
    'pages/syntheticHelix/node108',
    'pages/syntheticHelix/node109',
    'pages/syntheticHelix/node110',
    'pages/syntheticHelix/node111',
    'pages/syntheticHelix/node112',
    'pages/syntheticHelix/node113',
    'pages/syntheticHelix/node114',
    'pages/syntheticHelix/node115',
    'pages/syntheticHelix/node116',
    'pages/syntheticHelix/node117',
    'pages/syntheticHelix/node118',
    'pages/syntheticHelix/node119',
    'pages/syntheticHelix/node120',
    'pages/syntheticHelix/node121',
    'pages/syntheticHelix/node122',
    'pages/syntheticHelix/node123',
    'pages/syntheticHelix/node124',
    'pages/syntheticHelix/node125',
    'pages/syntheticHelix/node126',
    'pages/syntheticHelix/node127',
    'pages/syntheticHelix/node128',
    'pages/syntheticHelix/node129',
    'pages/syntheticHelix/node130',
    'pages/syntheticHelix/node131',
    'pages/syntheticHelix/node132',
    'pages/syntheticHelix/node133',
    'pages/syntheticHelix/node134',
    'pages/syntheticHelix/node135',
    'pages/syntheticHelix/node136',
    'pages/syntheticHelix/node137',
    'pages/syntheticHelix/node138',
    'pages/syntheticHelix/node139',
    'pages/syntheticHelix/node140',
    'pages/syntheticHelix/node141',
    'pages/syntheticHelix/node142',
    'pages/syntheticHelix/node143',
    'pages/syntheticHelix/node144',
    'pages/syntheticHelix/node145',
    'pages/syntheticHelix/node146',
    'pages/syntheticHelix/node147',
    'pages/syntheticHelix/node148',
    'pages/syntheticHelix/node149',
    'pages/syntheticHelix/node150',
    'pages/syntheticHelix/node151',
    'pages/syntheticHelix/node152',
    'pages/syntheticHelix/node153',
    'pages/syntheticHelix/node154',
    'pages/syntheticHelix/node155',
    'pages/syntheticHelix/node156',
    'pages/syntheticHelix/node157',
    'pages/syntheticHelix/node158',
    'pages/syntheticHelix/node159',
    'pages/syntheticHelix/node160'
  ];

  describe('MegaSyntheticRouteAtlasHelixSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteHelix_[A-Za-z0-9_]+_[0-9]{3}$/;
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

