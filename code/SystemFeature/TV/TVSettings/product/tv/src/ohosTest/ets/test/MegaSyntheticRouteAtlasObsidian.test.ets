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
  return /^pages\/syntheticObsidian\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasObsidianTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteObsidian_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticObsidian/node001',
    'pages/syntheticObsidian/node002',
    'pages/syntheticObsidian/node003',
    'pages/syntheticObsidian/node004',
    'pages/syntheticObsidian/node005',
    'pages/syntheticObsidian/node006',
    'pages/syntheticObsidian/node007',
    'pages/syntheticObsidian/node008',
    'pages/syntheticObsidian/node009',
    'pages/syntheticObsidian/node010',
    'pages/syntheticObsidian/node011',
    'pages/syntheticObsidian/node012',
    'pages/syntheticObsidian/node013',
    'pages/syntheticObsidian/node014',
    'pages/syntheticObsidian/node015',
    'pages/syntheticObsidian/node016',
    'pages/syntheticObsidian/node017',
    'pages/syntheticObsidian/node018',
    'pages/syntheticObsidian/node019',
    'pages/syntheticObsidian/node020',
    'pages/syntheticObsidian/node021',
    'pages/syntheticObsidian/node022',
    'pages/syntheticObsidian/node023',
    'pages/syntheticObsidian/node024',
    'pages/syntheticObsidian/node025',
    'pages/syntheticObsidian/node026',
    'pages/syntheticObsidian/node027',
    'pages/syntheticObsidian/node028',
    'pages/syntheticObsidian/node029',
    'pages/syntheticObsidian/node030',
    'pages/syntheticObsidian/node031',
    'pages/syntheticObsidian/node032',
    'pages/syntheticObsidian/node033',
    'pages/syntheticObsidian/node034',
    'pages/syntheticObsidian/node035',
    'pages/syntheticObsidian/node036',
    'pages/syntheticObsidian/node037',
    'pages/syntheticObsidian/node038',
    'pages/syntheticObsidian/node039',
    'pages/syntheticObsidian/node040',
    'pages/syntheticObsidian/node041',
    'pages/syntheticObsidian/node042',
    'pages/syntheticObsidian/node043',
    'pages/syntheticObsidian/node044',
    'pages/syntheticObsidian/node045',
    'pages/syntheticObsidian/node046',
    'pages/syntheticObsidian/node047',
    'pages/syntheticObsidian/node048',
    'pages/syntheticObsidian/node049',
    'pages/syntheticObsidian/node050',
    'pages/syntheticObsidian/node051',
    'pages/syntheticObsidian/node052',
    'pages/syntheticObsidian/node053',
    'pages/syntheticObsidian/node054',
    'pages/syntheticObsidian/node055',
    'pages/syntheticObsidian/node056',
    'pages/syntheticObsidian/node057',
    'pages/syntheticObsidian/node058',
    'pages/syntheticObsidian/node059',
    'pages/syntheticObsidian/node060',
    'pages/syntheticObsidian/node061',
    'pages/syntheticObsidian/node062',
    'pages/syntheticObsidian/node063',
    'pages/syntheticObsidian/node064',
    'pages/syntheticObsidian/node065',
    'pages/syntheticObsidian/node066',
    'pages/syntheticObsidian/node067',
    'pages/syntheticObsidian/node068',
    'pages/syntheticObsidian/node069',
    'pages/syntheticObsidian/node070',
    'pages/syntheticObsidian/node071',
    'pages/syntheticObsidian/node072',
    'pages/syntheticObsidian/node073',
    'pages/syntheticObsidian/node074',
    'pages/syntheticObsidian/node075',
    'pages/syntheticObsidian/node076',
    'pages/syntheticObsidian/node077',
    'pages/syntheticObsidian/node078',
    'pages/syntheticObsidian/node079',
    'pages/syntheticObsidian/node080',
    'pages/syntheticObsidian/node081',
    'pages/syntheticObsidian/node082',
    'pages/syntheticObsidian/node083',
    'pages/syntheticObsidian/node084',
    'pages/syntheticObsidian/node085',
    'pages/syntheticObsidian/node086',
    'pages/syntheticObsidian/node087',
    'pages/syntheticObsidian/node088',
    'pages/syntheticObsidian/node089',
    'pages/syntheticObsidian/node090',
    'pages/syntheticObsidian/node091',
    'pages/syntheticObsidian/node092',
    'pages/syntheticObsidian/node093',
    'pages/syntheticObsidian/node094',
    'pages/syntheticObsidian/node095',
    'pages/syntheticObsidian/node096',
    'pages/syntheticObsidian/node097',
    'pages/syntheticObsidian/node098',
    'pages/syntheticObsidian/node099',
    'pages/syntheticObsidian/node100',
    'pages/syntheticObsidian/node101',
    'pages/syntheticObsidian/node102',
    'pages/syntheticObsidian/node103',
    'pages/syntheticObsidian/node104',
    'pages/syntheticObsidian/node105',
    'pages/syntheticObsidian/node106',
    'pages/syntheticObsidian/node107',
    'pages/syntheticObsidian/node108',
    'pages/syntheticObsidian/node109',
    'pages/syntheticObsidian/node110',
    'pages/syntheticObsidian/node111',
    'pages/syntheticObsidian/node112',
    'pages/syntheticObsidian/node113',
    'pages/syntheticObsidian/node114',
    'pages/syntheticObsidian/node115',
    'pages/syntheticObsidian/node116',
    'pages/syntheticObsidian/node117',
    'pages/syntheticObsidian/node118',
    'pages/syntheticObsidian/node119',
    'pages/syntheticObsidian/node120',
    'pages/syntheticObsidian/node121',
    'pages/syntheticObsidian/node122',
    'pages/syntheticObsidian/node123',
    'pages/syntheticObsidian/node124',
    'pages/syntheticObsidian/node125',
    'pages/syntheticObsidian/node126',
    'pages/syntheticObsidian/node127',
    'pages/syntheticObsidian/node128',
    'pages/syntheticObsidian/node129',
    'pages/syntheticObsidian/node130',
    'pages/syntheticObsidian/node131',
    'pages/syntheticObsidian/node132',
    'pages/syntheticObsidian/node133',
    'pages/syntheticObsidian/node134',
    'pages/syntheticObsidian/node135',
    'pages/syntheticObsidian/node136',
    'pages/syntheticObsidian/node137',
    'pages/syntheticObsidian/node138',
    'pages/syntheticObsidian/node139',
    'pages/syntheticObsidian/node140',
    'pages/syntheticObsidian/node141',
    'pages/syntheticObsidian/node142',
    'pages/syntheticObsidian/node143',
    'pages/syntheticObsidian/node144',
    'pages/syntheticObsidian/node145',
    'pages/syntheticObsidian/node146',
    'pages/syntheticObsidian/node147',
    'pages/syntheticObsidian/node148',
    'pages/syntheticObsidian/node149',
    'pages/syntheticObsidian/node150',
    'pages/syntheticObsidian/node151',
    'pages/syntheticObsidian/node152',
    'pages/syntheticObsidian/node153',
    'pages/syntheticObsidian/node154',
    'pages/syntheticObsidian/node155',
    'pages/syntheticObsidian/node156',
    'pages/syntheticObsidian/node157',
    'pages/syntheticObsidian/node158',
    'pages/syntheticObsidian/node159',
    'pages/syntheticObsidian/node160'
  ];

  describe('MegaSyntheticRouteAtlasObsidianSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteObsidian_[A-Za-z0-9_]+_[0-9]{3}$/;
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

