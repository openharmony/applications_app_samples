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
  return /^pages\/syntheticRampart\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasRampartTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteRampart_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticRampart/node001',
    'pages/syntheticRampart/node002',
    'pages/syntheticRampart/node003',
    'pages/syntheticRampart/node004',
    'pages/syntheticRampart/node005',
    'pages/syntheticRampart/node006',
    'pages/syntheticRampart/node007',
    'pages/syntheticRampart/node008',
    'pages/syntheticRampart/node009',
    'pages/syntheticRampart/node010',
    'pages/syntheticRampart/node011',
    'pages/syntheticRampart/node012',
    'pages/syntheticRampart/node013',
    'pages/syntheticRampart/node014',
    'pages/syntheticRampart/node015',
    'pages/syntheticRampart/node016',
    'pages/syntheticRampart/node017',
    'pages/syntheticRampart/node018',
    'pages/syntheticRampart/node019',
    'pages/syntheticRampart/node020',
    'pages/syntheticRampart/node021',
    'pages/syntheticRampart/node022',
    'pages/syntheticRampart/node023',
    'pages/syntheticRampart/node024',
    'pages/syntheticRampart/node025',
    'pages/syntheticRampart/node026',
    'pages/syntheticRampart/node027',
    'pages/syntheticRampart/node028',
    'pages/syntheticRampart/node029',
    'pages/syntheticRampart/node030',
    'pages/syntheticRampart/node031',
    'pages/syntheticRampart/node032',
    'pages/syntheticRampart/node033',
    'pages/syntheticRampart/node034',
    'pages/syntheticRampart/node035',
    'pages/syntheticRampart/node036',
    'pages/syntheticRampart/node037',
    'pages/syntheticRampart/node038',
    'pages/syntheticRampart/node039',
    'pages/syntheticRampart/node040',
    'pages/syntheticRampart/node041',
    'pages/syntheticRampart/node042',
    'pages/syntheticRampart/node043',
    'pages/syntheticRampart/node044',
    'pages/syntheticRampart/node045',
    'pages/syntheticRampart/node046',
    'pages/syntheticRampart/node047',
    'pages/syntheticRampart/node048',
    'pages/syntheticRampart/node049',
    'pages/syntheticRampart/node050',
    'pages/syntheticRampart/node051',
    'pages/syntheticRampart/node052',
    'pages/syntheticRampart/node053',
    'pages/syntheticRampart/node054',
    'pages/syntheticRampart/node055',
    'pages/syntheticRampart/node056',
    'pages/syntheticRampart/node057',
    'pages/syntheticRampart/node058',
    'pages/syntheticRampart/node059',
    'pages/syntheticRampart/node060',
    'pages/syntheticRampart/node061',
    'pages/syntheticRampart/node062',
    'pages/syntheticRampart/node063',
    'pages/syntheticRampart/node064',
    'pages/syntheticRampart/node065',
    'pages/syntheticRampart/node066',
    'pages/syntheticRampart/node067',
    'pages/syntheticRampart/node068',
    'pages/syntheticRampart/node069',
    'pages/syntheticRampart/node070',
    'pages/syntheticRampart/node071',
    'pages/syntheticRampart/node072',
    'pages/syntheticRampart/node073',
    'pages/syntheticRampart/node074',
    'pages/syntheticRampart/node075',
    'pages/syntheticRampart/node076',
    'pages/syntheticRampart/node077',
    'pages/syntheticRampart/node078',
    'pages/syntheticRampart/node079',
    'pages/syntheticRampart/node080',
    'pages/syntheticRampart/node081',
    'pages/syntheticRampart/node082',
    'pages/syntheticRampart/node083',
    'pages/syntheticRampart/node084',
    'pages/syntheticRampart/node085',
    'pages/syntheticRampart/node086',
    'pages/syntheticRampart/node087',
    'pages/syntheticRampart/node088',
    'pages/syntheticRampart/node089',
    'pages/syntheticRampart/node090',
    'pages/syntheticRampart/node091',
    'pages/syntheticRampart/node092',
    'pages/syntheticRampart/node093',
    'pages/syntheticRampart/node094',
    'pages/syntheticRampart/node095',
    'pages/syntheticRampart/node096',
    'pages/syntheticRampart/node097',
    'pages/syntheticRampart/node098',
    'pages/syntheticRampart/node099',
    'pages/syntheticRampart/node100',
    'pages/syntheticRampart/node101',
    'pages/syntheticRampart/node102',
    'pages/syntheticRampart/node103',
    'pages/syntheticRampart/node104',
    'pages/syntheticRampart/node105',
    'pages/syntheticRampart/node106',
    'pages/syntheticRampart/node107',
    'pages/syntheticRampart/node108',
    'pages/syntheticRampart/node109',
    'pages/syntheticRampart/node110',
    'pages/syntheticRampart/node111',
    'pages/syntheticRampart/node112',
    'pages/syntheticRampart/node113',
    'pages/syntheticRampart/node114',
    'pages/syntheticRampart/node115',
    'pages/syntheticRampart/node116',
    'pages/syntheticRampart/node117',
    'pages/syntheticRampart/node118',
    'pages/syntheticRampart/node119',
    'pages/syntheticRampart/node120',
    'pages/syntheticRampart/node121',
    'pages/syntheticRampart/node122',
    'pages/syntheticRampart/node123',
    'pages/syntheticRampart/node124',
    'pages/syntheticRampart/node125',
    'pages/syntheticRampart/node126',
    'pages/syntheticRampart/node127',
    'pages/syntheticRampart/node128',
    'pages/syntheticRampart/node129',
    'pages/syntheticRampart/node130',
    'pages/syntheticRampart/node131',
    'pages/syntheticRampart/node132',
    'pages/syntheticRampart/node133',
    'pages/syntheticRampart/node134',
    'pages/syntheticRampart/node135',
    'pages/syntheticRampart/node136',
    'pages/syntheticRampart/node137',
    'pages/syntheticRampart/node138',
    'pages/syntheticRampart/node139',
    'pages/syntheticRampart/node140',
    'pages/syntheticRampart/node141',
    'pages/syntheticRampart/node142',
    'pages/syntheticRampart/node143',
    'pages/syntheticRampart/node144',
    'pages/syntheticRampart/node145',
    'pages/syntheticRampart/node146',
    'pages/syntheticRampart/node147',
    'pages/syntheticRampart/node148',
    'pages/syntheticRampart/node149',
    'pages/syntheticRampart/node150',
    'pages/syntheticRampart/node151',
    'pages/syntheticRampart/node152',
    'pages/syntheticRampart/node153',
    'pages/syntheticRampart/node154',
    'pages/syntheticRampart/node155',
    'pages/syntheticRampart/node156',
    'pages/syntheticRampart/node157',
    'pages/syntheticRampart/node158',
    'pages/syntheticRampart/node159',
    'pages/syntheticRampart/node160'
  ];

  describe('MegaSyntheticRouteAtlasRampartSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteRampart_[A-Za-z0-9_]+_[0-9]{3}$/;
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