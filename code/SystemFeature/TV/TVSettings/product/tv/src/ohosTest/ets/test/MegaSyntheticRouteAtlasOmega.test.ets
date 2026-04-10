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
  return /^pages\/syntheticOmega\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasOmegaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteOmega_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticOmega/node001',
    'pages/syntheticOmega/node002',
    'pages/syntheticOmega/node003',
    'pages/syntheticOmega/node004',
    'pages/syntheticOmega/node005',
    'pages/syntheticOmega/node006',
    'pages/syntheticOmega/node007',
    'pages/syntheticOmega/node008',
    'pages/syntheticOmega/node009',
    'pages/syntheticOmega/node010',
    'pages/syntheticOmega/node011',
    'pages/syntheticOmega/node012',
    'pages/syntheticOmega/node013',
    'pages/syntheticOmega/node014',
    'pages/syntheticOmega/node015',
    'pages/syntheticOmega/node016',
    'pages/syntheticOmega/node017',
    'pages/syntheticOmega/node018',
    'pages/syntheticOmega/node019',
    'pages/syntheticOmega/node020',
    'pages/syntheticOmega/node021',
    'pages/syntheticOmega/node022',
    'pages/syntheticOmega/node023',
    'pages/syntheticOmega/node024',
    'pages/syntheticOmega/node025',
    'pages/syntheticOmega/node026',
    'pages/syntheticOmega/node027',
    'pages/syntheticOmega/node028',
    'pages/syntheticOmega/node029',
    'pages/syntheticOmega/node030',
    'pages/syntheticOmega/node031',
    'pages/syntheticOmega/node032',
    'pages/syntheticOmega/node033',
    'pages/syntheticOmega/node034',
    'pages/syntheticOmega/node035',
    'pages/syntheticOmega/node036',
    'pages/syntheticOmega/node037',
    'pages/syntheticOmega/node038',
    'pages/syntheticOmega/node039',
    'pages/syntheticOmega/node040',
    'pages/syntheticOmega/node041',
    'pages/syntheticOmega/node042',
    'pages/syntheticOmega/node043',
    'pages/syntheticOmega/node044',
    'pages/syntheticOmega/node045',
    'pages/syntheticOmega/node046',
    'pages/syntheticOmega/node047',
    'pages/syntheticOmega/node048',
    'pages/syntheticOmega/node049',
    'pages/syntheticOmega/node050',
    'pages/syntheticOmega/node051',
    'pages/syntheticOmega/node052',
    'pages/syntheticOmega/node053',
    'pages/syntheticOmega/node054',
    'pages/syntheticOmega/node055',
    'pages/syntheticOmega/node056',
    'pages/syntheticOmega/node057',
    'pages/syntheticOmega/node058',
    'pages/syntheticOmega/node059',
    'pages/syntheticOmega/node060',
    'pages/syntheticOmega/node061',
    'pages/syntheticOmega/node062',
    'pages/syntheticOmega/node063',
    'pages/syntheticOmega/node064',
    'pages/syntheticOmega/node065',
    'pages/syntheticOmega/node066',
    'pages/syntheticOmega/node067',
    'pages/syntheticOmega/node068',
    'pages/syntheticOmega/node069',
    'pages/syntheticOmega/node070',
    'pages/syntheticOmega/node071',
    'pages/syntheticOmega/node072',
    'pages/syntheticOmega/node073',
    'pages/syntheticOmega/node074',
    'pages/syntheticOmega/node075',
    'pages/syntheticOmega/node076',
    'pages/syntheticOmega/node077',
    'pages/syntheticOmega/node078',
    'pages/syntheticOmega/node079',
    'pages/syntheticOmega/node080',
    'pages/syntheticOmega/node081',
    'pages/syntheticOmega/node082',
    'pages/syntheticOmega/node083',
    'pages/syntheticOmega/node084',
    'pages/syntheticOmega/node085',
    'pages/syntheticOmega/node086',
    'pages/syntheticOmega/node087',
    'pages/syntheticOmega/node088',
    'pages/syntheticOmega/node089',
    'pages/syntheticOmega/node090',
    'pages/syntheticOmega/node091',
    'pages/syntheticOmega/node092',
    'pages/syntheticOmega/node093',
    'pages/syntheticOmega/node094',
    'pages/syntheticOmega/node095',
    'pages/syntheticOmega/node096',
    'pages/syntheticOmega/node097',
    'pages/syntheticOmega/node098',
    'pages/syntheticOmega/node099',
    'pages/syntheticOmega/node100',
    'pages/syntheticOmega/node101',
    'pages/syntheticOmega/node102',
    'pages/syntheticOmega/node103',
    'pages/syntheticOmega/node104',
    'pages/syntheticOmega/node105',
    'pages/syntheticOmega/node106',
    'pages/syntheticOmega/node107',
    'pages/syntheticOmega/node108',
    'pages/syntheticOmega/node109',
    'pages/syntheticOmega/node110',
    'pages/syntheticOmega/node111',
    'pages/syntheticOmega/node112',
    'pages/syntheticOmega/node113',
    'pages/syntheticOmega/node114',
    'pages/syntheticOmega/node115',
    'pages/syntheticOmega/node116',
    'pages/syntheticOmega/node117',
    'pages/syntheticOmega/node118',
    'pages/syntheticOmega/node119',
    'pages/syntheticOmega/node120',
    'pages/syntheticOmega/node121',
    'pages/syntheticOmega/node122',
    'pages/syntheticOmega/node123',
    'pages/syntheticOmega/node124',
    'pages/syntheticOmega/node125',
    'pages/syntheticOmega/node126',
    'pages/syntheticOmega/node127',
    'pages/syntheticOmega/node128',
    'pages/syntheticOmega/node129',
    'pages/syntheticOmega/node130',
    'pages/syntheticOmega/node131',
    'pages/syntheticOmega/node132',
    'pages/syntheticOmega/node133',
    'pages/syntheticOmega/node134',
    'pages/syntheticOmega/node135',
    'pages/syntheticOmega/node136',
    'pages/syntheticOmega/node137',
    'pages/syntheticOmega/node138',
    'pages/syntheticOmega/node139',
    'pages/syntheticOmega/node140',
    'pages/syntheticOmega/node141',
    'pages/syntheticOmega/node142',
    'pages/syntheticOmega/node143',
    'pages/syntheticOmega/node144',
    'pages/syntheticOmega/node145',
    'pages/syntheticOmega/node146',
    'pages/syntheticOmega/node147',
    'pages/syntheticOmega/node148',
    'pages/syntheticOmega/node149',
    'pages/syntheticOmega/node150',
    'pages/syntheticOmega/node151',
    'pages/syntheticOmega/node152',
    'pages/syntheticOmega/node153',
    'pages/syntheticOmega/node154',
    'pages/syntheticOmega/node155',
    'pages/syntheticOmega/node156',
    'pages/syntheticOmega/node157',
    'pages/syntheticOmega/node158',
    'pages/syntheticOmega/node159',
    'pages/syntheticOmega/node160'
  ];

  describe('MegaSyntheticRouteAtlasOmegaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteOmega_[A-Za-z0-9_]+_[0-9]{3}$/;
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

