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
  return /^pages\/syntheticOmicron\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasOmicronTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteOmicron_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticOmicron/node001',
    'pages/syntheticOmicron/node002',
    'pages/syntheticOmicron/node003',
    'pages/syntheticOmicron/node004',
    'pages/syntheticOmicron/node005',
    'pages/syntheticOmicron/node006',
    'pages/syntheticOmicron/node007',
    'pages/syntheticOmicron/node008',
    'pages/syntheticOmicron/node009',
    'pages/syntheticOmicron/node010',
    'pages/syntheticOmicron/node011',
    'pages/syntheticOmicron/node012',
    'pages/syntheticOmicron/node013',
    'pages/syntheticOmicron/node014',
    'pages/syntheticOmicron/node015',
    'pages/syntheticOmicron/node016',
    'pages/syntheticOmicron/node017',
    'pages/syntheticOmicron/node018',
    'pages/syntheticOmicron/node019',
    'pages/syntheticOmicron/node020',
    'pages/syntheticOmicron/node021',
    'pages/syntheticOmicron/node022',
    'pages/syntheticOmicron/node023',
    'pages/syntheticOmicron/node024',
    'pages/syntheticOmicron/node025',
    'pages/syntheticOmicron/node026',
    'pages/syntheticOmicron/node027',
    'pages/syntheticOmicron/node028',
    'pages/syntheticOmicron/node029',
    'pages/syntheticOmicron/node030',
    'pages/syntheticOmicron/node031',
    'pages/syntheticOmicron/node032',
    'pages/syntheticOmicron/node033',
    'pages/syntheticOmicron/node034',
    'pages/syntheticOmicron/node035',
    'pages/syntheticOmicron/node036',
    'pages/syntheticOmicron/node037',
    'pages/syntheticOmicron/node038',
    'pages/syntheticOmicron/node039',
    'pages/syntheticOmicron/node040',
    'pages/syntheticOmicron/node041',
    'pages/syntheticOmicron/node042',
    'pages/syntheticOmicron/node043',
    'pages/syntheticOmicron/node044',
    'pages/syntheticOmicron/node045',
    'pages/syntheticOmicron/node046',
    'pages/syntheticOmicron/node047',
    'pages/syntheticOmicron/node048',
    'pages/syntheticOmicron/node049',
    'pages/syntheticOmicron/node050',
    'pages/syntheticOmicron/node051',
    'pages/syntheticOmicron/node052',
    'pages/syntheticOmicron/node053',
    'pages/syntheticOmicron/node054',
    'pages/syntheticOmicron/node055',
    'pages/syntheticOmicron/node056',
    'pages/syntheticOmicron/node057',
    'pages/syntheticOmicron/node058',
    'pages/syntheticOmicron/node059',
    'pages/syntheticOmicron/node060',
    'pages/syntheticOmicron/node061',
    'pages/syntheticOmicron/node062',
    'pages/syntheticOmicron/node063',
    'pages/syntheticOmicron/node064',
    'pages/syntheticOmicron/node065',
    'pages/syntheticOmicron/node066',
    'pages/syntheticOmicron/node067',
    'pages/syntheticOmicron/node068',
    'pages/syntheticOmicron/node069',
    'pages/syntheticOmicron/node070',
    'pages/syntheticOmicron/node071',
    'pages/syntheticOmicron/node072',
    'pages/syntheticOmicron/node073',
    'pages/syntheticOmicron/node074',
    'pages/syntheticOmicron/node075',
    'pages/syntheticOmicron/node076',
    'pages/syntheticOmicron/node077',
    'pages/syntheticOmicron/node078',
    'pages/syntheticOmicron/node079',
    'pages/syntheticOmicron/node080',
    'pages/syntheticOmicron/node081',
    'pages/syntheticOmicron/node082',
    'pages/syntheticOmicron/node083',
    'pages/syntheticOmicron/node084',
    'pages/syntheticOmicron/node085',
    'pages/syntheticOmicron/node086',
    'pages/syntheticOmicron/node087',
    'pages/syntheticOmicron/node088',
    'pages/syntheticOmicron/node089',
    'pages/syntheticOmicron/node090',
    'pages/syntheticOmicron/node091',
    'pages/syntheticOmicron/node092',
    'pages/syntheticOmicron/node093',
    'pages/syntheticOmicron/node094',
    'pages/syntheticOmicron/node095',
    'pages/syntheticOmicron/node096',
    'pages/syntheticOmicron/node097',
    'pages/syntheticOmicron/node098',
    'pages/syntheticOmicron/node099',
    'pages/syntheticOmicron/node100',
    'pages/syntheticOmicron/node101',
    'pages/syntheticOmicron/node102',
    'pages/syntheticOmicron/node103',
    'pages/syntheticOmicron/node104',
    'pages/syntheticOmicron/node105',
    'pages/syntheticOmicron/node106',
    'pages/syntheticOmicron/node107',
    'pages/syntheticOmicron/node108',
    'pages/syntheticOmicron/node109',
    'pages/syntheticOmicron/node110',
    'pages/syntheticOmicron/node111',
    'pages/syntheticOmicron/node112',
    'pages/syntheticOmicron/node113',
    'pages/syntheticOmicron/node114',
    'pages/syntheticOmicron/node115',
    'pages/syntheticOmicron/node116',
    'pages/syntheticOmicron/node117',
    'pages/syntheticOmicron/node118',
    'pages/syntheticOmicron/node119',
    'pages/syntheticOmicron/node120',
    'pages/syntheticOmicron/node121',
    'pages/syntheticOmicron/node122',
    'pages/syntheticOmicron/node123',
    'pages/syntheticOmicron/node124',
    'pages/syntheticOmicron/node125',
    'pages/syntheticOmicron/node126',
    'pages/syntheticOmicron/node127',
    'pages/syntheticOmicron/node128',
    'pages/syntheticOmicron/node129',
    'pages/syntheticOmicron/node130',
    'pages/syntheticOmicron/node131',
    'pages/syntheticOmicron/node132',
    'pages/syntheticOmicron/node133',
    'pages/syntheticOmicron/node134',
    'pages/syntheticOmicron/node135',
    'pages/syntheticOmicron/node136',
    'pages/syntheticOmicron/node137',
    'pages/syntheticOmicron/node138',
    'pages/syntheticOmicron/node139',
    'pages/syntheticOmicron/node140',
    'pages/syntheticOmicron/node141',
    'pages/syntheticOmicron/node142',
    'pages/syntheticOmicron/node143',
    'pages/syntheticOmicron/node144',
    'pages/syntheticOmicron/node145',
    'pages/syntheticOmicron/node146',
    'pages/syntheticOmicron/node147',
    'pages/syntheticOmicron/node148',
    'pages/syntheticOmicron/node149',
    'pages/syntheticOmicron/node150',
    'pages/syntheticOmicron/node151',
    'pages/syntheticOmicron/node152',
    'pages/syntheticOmicron/node153',
    'pages/syntheticOmicron/node154',
    'pages/syntheticOmicron/node155',
    'pages/syntheticOmicron/node156',
    'pages/syntheticOmicron/node157',
    'pages/syntheticOmicron/node158',
    'pages/syntheticOmicron/node159',
    'pages/syntheticOmicron/node160'
  ];

  describe('MegaSyntheticRouteAtlasOmicronSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteOmicron_[A-Za-z0-9_]+_[0-9]{3}$/;
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

