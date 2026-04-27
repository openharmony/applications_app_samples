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
  return /^pages\/syntheticForge\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasForgeTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteForge_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticForge/node001',
    'pages/syntheticForge/node002',
    'pages/syntheticForge/node003',
    'pages/syntheticForge/node004',
    'pages/syntheticForge/node005',
    'pages/syntheticForge/node006',
    'pages/syntheticForge/node007',
    'pages/syntheticForge/node008',
    'pages/syntheticForge/node009',
    'pages/syntheticForge/node010',
    'pages/syntheticForge/node011',
    'pages/syntheticForge/node012',
    'pages/syntheticForge/node013',
    'pages/syntheticForge/node014',
    'pages/syntheticForge/node015',
    'pages/syntheticForge/node016',
    'pages/syntheticForge/node017',
    'pages/syntheticForge/node018',
    'pages/syntheticForge/node019',
    'pages/syntheticForge/node020',
    'pages/syntheticForge/node021',
    'pages/syntheticForge/node022',
    'pages/syntheticForge/node023',
    'pages/syntheticForge/node024',
    'pages/syntheticForge/node025',
    'pages/syntheticForge/node026',
    'pages/syntheticForge/node027',
    'pages/syntheticForge/node028',
    'pages/syntheticForge/node029',
    'pages/syntheticForge/node030',
    'pages/syntheticForge/node031',
    'pages/syntheticForge/node032',
    'pages/syntheticForge/node033',
    'pages/syntheticForge/node034',
    'pages/syntheticForge/node035',
    'pages/syntheticForge/node036',
    'pages/syntheticForge/node037',
    'pages/syntheticForge/node038',
    'pages/syntheticForge/node039',
    'pages/syntheticForge/node040',
    'pages/syntheticForge/node041',
    'pages/syntheticForge/node042',
    'pages/syntheticForge/node043',
    'pages/syntheticForge/node044',
    'pages/syntheticForge/node045',
    'pages/syntheticForge/node046',
    'pages/syntheticForge/node047',
    'pages/syntheticForge/node048',
    'pages/syntheticForge/node049',
    'pages/syntheticForge/node050',
    'pages/syntheticForge/node051',
    'pages/syntheticForge/node052',
    'pages/syntheticForge/node053',
    'pages/syntheticForge/node054',
    'pages/syntheticForge/node055',
    'pages/syntheticForge/node056',
    'pages/syntheticForge/node057',
    'pages/syntheticForge/node058',
    'pages/syntheticForge/node059',
    'pages/syntheticForge/node060',
    'pages/syntheticForge/node061',
    'pages/syntheticForge/node062',
    'pages/syntheticForge/node063',
    'pages/syntheticForge/node064',
    'pages/syntheticForge/node065',
    'pages/syntheticForge/node066',
    'pages/syntheticForge/node067',
    'pages/syntheticForge/node068',
    'pages/syntheticForge/node069',
    'pages/syntheticForge/node070',
    'pages/syntheticForge/node071',
    'pages/syntheticForge/node072',
    'pages/syntheticForge/node073',
    'pages/syntheticForge/node074',
    'pages/syntheticForge/node075',
    'pages/syntheticForge/node076',
    'pages/syntheticForge/node077',
    'pages/syntheticForge/node078',
    'pages/syntheticForge/node079',
    'pages/syntheticForge/node080',
    'pages/syntheticForge/node081',
    'pages/syntheticForge/node082',
    'pages/syntheticForge/node083',
    'pages/syntheticForge/node084',
    'pages/syntheticForge/node085',
    'pages/syntheticForge/node086',
    'pages/syntheticForge/node087',
    'pages/syntheticForge/node088',
    'pages/syntheticForge/node089',
    'pages/syntheticForge/node090',
    'pages/syntheticForge/node091',
    'pages/syntheticForge/node092',
    'pages/syntheticForge/node093',
    'pages/syntheticForge/node094',
    'pages/syntheticForge/node095',
    'pages/syntheticForge/node096',
    'pages/syntheticForge/node097',
    'pages/syntheticForge/node098',
    'pages/syntheticForge/node099',
    'pages/syntheticForge/node100',
    'pages/syntheticForge/node101',
    'pages/syntheticForge/node102',
    'pages/syntheticForge/node103',
    'pages/syntheticForge/node104',
    'pages/syntheticForge/node105',
    'pages/syntheticForge/node106',
    'pages/syntheticForge/node107',
    'pages/syntheticForge/node108',
    'pages/syntheticForge/node109',
    'pages/syntheticForge/node110',
    'pages/syntheticForge/node111',
    'pages/syntheticForge/node112',
    'pages/syntheticForge/node113',
    'pages/syntheticForge/node114',
    'pages/syntheticForge/node115',
    'pages/syntheticForge/node116',
    'pages/syntheticForge/node117',
    'pages/syntheticForge/node118',
    'pages/syntheticForge/node119',
    'pages/syntheticForge/node120',
    'pages/syntheticForge/node121',
    'pages/syntheticForge/node122',
    'pages/syntheticForge/node123',
    'pages/syntheticForge/node124',
    'pages/syntheticForge/node125',
    'pages/syntheticForge/node126',
    'pages/syntheticForge/node127',
    'pages/syntheticForge/node128',
    'pages/syntheticForge/node129',
    'pages/syntheticForge/node130',
    'pages/syntheticForge/node131',
    'pages/syntheticForge/node132',
    'pages/syntheticForge/node133',
    'pages/syntheticForge/node134',
    'pages/syntheticForge/node135',
    'pages/syntheticForge/node136',
    'pages/syntheticForge/node137',
    'pages/syntheticForge/node138',
    'pages/syntheticForge/node139',
    'pages/syntheticForge/node140',
    'pages/syntheticForge/node141',
    'pages/syntheticForge/node142',
    'pages/syntheticForge/node143',
    'pages/syntheticForge/node144',
    'pages/syntheticForge/node145',
    'pages/syntheticForge/node146',
    'pages/syntheticForge/node147',
    'pages/syntheticForge/node148',
    'pages/syntheticForge/node149',
    'pages/syntheticForge/node150',
    'pages/syntheticForge/node151',
    'pages/syntheticForge/node152',
    'pages/syntheticForge/node153',
    'pages/syntheticForge/node154',
    'pages/syntheticForge/node155',
    'pages/syntheticForge/node156',
    'pages/syntheticForge/node157',
    'pages/syntheticForge/node158',
    'pages/syntheticForge/node159',
    'pages/syntheticForge/node160'
  ];

  describe('MegaSyntheticRouteAtlasForgeSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteForge_[A-Za-z0-9_]+_[0-9]{3}$/;
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

