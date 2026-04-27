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
  return /^pages\/syntheticEta\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasEtaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteEta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticEta/node001',
    'pages/syntheticEta/node002',
    'pages/syntheticEta/node003',
    'pages/syntheticEta/node004',
    'pages/syntheticEta/node005',
    'pages/syntheticEta/node006',
    'pages/syntheticEta/node007',
    'pages/syntheticEta/node008',
    'pages/syntheticEta/node009',
    'pages/syntheticEta/node010',
    'pages/syntheticEta/node011',
    'pages/syntheticEta/node012',
    'pages/syntheticEta/node013',
    'pages/syntheticEta/node014',
    'pages/syntheticEta/node015',
    'pages/syntheticEta/node016',
    'pages/syntheticEta/node017',
    'pages/syntheticEta/node018',
    'pages/syntheticEta/node019',
    'pages/syntheticEta/node020',
    'pages/syntheticEta/node021',
    'pages/syntheticEta/node022',
    'pages/syntheticEta/node023',
    'pages/syntheticEta/node024',
    'pages/syntheticEta/node025',
    'pages/syntheticEta/node026',
    'pages/syntheticEta/node027',
    'pages/syntheticEta/node028',
    'pages/syntheticEta/node029',
    'pages/syntheticEta/node030',
    'pages/syntheticEta/node031',
    'pages/syntheticEta/node032',
    'pages/syntheticEta/node033',
    'pages/syntheticEta/node034',
    'pages/syntheticEta/node035',
    'pages/syntheticEta/node036',
    'pages/syntheticEta/node037',
    'pages/syntheticEta/node038',
    'pages/syntheticEta/node039',
    'pages/syntheticEta/node040',
    'pages/syntheticEta/node041',
    'pages/syntheticEta/node042',
    'pages/syntheticEta/node043',
    'pages/syntheticEta/node044',
    'pages/syntheticEta/node045',
    'pages/syntheticEta/node046',
    'pages/syntheticEta/node047',
    'pages/syntheticEta/node048',
    'pages/syntheticEta/node049',
    'pages/syntheticEta/node050',
    'pages/syntheticEta/node051',
    'pages/syntheticEta/node052',
    'pages/syntheticEta/node053',
    'pages/syntheticEta/node054',
    'pages/syntheticEta/node055',
    'pages/syntheticEta/node056',
    'pages/syntheticEta/node057',
    'pages/syntheticEta/node058',
    'pages/syntheticEta/node059',
    'pages/syntheticEta/node060',
    'pages/syntheticEta/node061',
    'pages/syntheticEta/node062',
    'pages/syntheticEta/node063',
    'pages/syntheticEta/node064',
    'pages/syntheticEta/node065',
    'pages/syntheticEta/node066',
    'pages/syntheticEta/node067',
    'pages/syntheticEta/node068',
    'pages/syntheticEta/node069',
    'pages/syntheticEta/node070',
    'pages/syntheticEta/node071',
    'pages/syntheticEta/node072',
    'pages/syntheticEta/node073',
    'pages/syntheticEta/node074',
    'pages/syntheticEta/node075',
    'pages/syntheticEta/node076',
    'pages/syntheticEta/node077',
    'pages/syntheticEta/node078',
    'pages/syntheticEta/node079',
    'pages/syntheticEta/node080',
    'pages/syntheticEta/node081',
    'pages/syntheticEta/node082',
    'pages/syntheticEta/node083',
    'pages/syntheticEta/node084',
    'pages/syntheticEta/node085',
    'pages/syntheticEta/node086',
    'pages/syntheticEta/node087',
    'pages/syntheticEta/node088',
    'pages/syntheticEta/node089',
    'pages/syntheticEta/node090',
    'pages/syntheticEta/node091',
    'pages/syntheticEta/node092',
    'pages/syntheticEta/node093',
    'pages/syntheticEta/node094',
    'pages/syntheticEta/node095',
    'pages/syntheticEta/node096',
    'pages/syntheticEta/node097',
    'pages/syntheticEta/node098',
    'pages/syntheticEta/node099',
    'pages/syntheticEta/node100',
    'pages/syntheticEta/node101',
    'pages/syntheticEta/node102',
    'pages/syntheticEta/node103',
    'pages/syntheticEta/node104',
    'pages/syntheticEta/node105',
    'pages/syntheticEta/node106',
    'pages/syntheticEta/node107',
    'pages/syntheticEta/node108',
    'pages/syntheticEta/node109',
    'pages/syntheticEta/node110',
    'pages/syntheticEta/node111',
    'pages/syntheticEta/node112',
    'pages/syntheticEta/node113',
    'pages/syntheticEta/node114',
    'pages/syntheticEta/node115',
    'pages/syntheticEta/node116',
    'pages/syntheticEta/node117',
    'pages/syntheticEta/node118',
    'pages/syntheticEta/node119',
    'pages/syntheticEta/node120',
    'pages/syntheticEta/node121',
    'pages/syntheticEta/node122',
    'pages/syntheticEta/node123',
    'pages/syntheticEta/node124',
    'pages/syntheticEta/node125',
    'pages/syntheticEta/node126',
    'pages/syntheticEta/node127',
    'pages/syntheticEta/node128',
    'pages/syntheticEta/node129',
    'pages/syntheticEta/node130',
    'pages/syntheticEta/node131',
    'pages/syntheticEta/node132',
    'pages/syntheticEta/node133',
    'pages/syntheticEta/node134',
    'pages/syntheticEta/node135',
    'pages/syntheticEta/node136',
    'pages/syntheticEta/node137',
    'pages/syntheticEta/node138',
    'pages/syntheticEta/node139',
    'pages/syntheticEta/node140',
    'pages/syntheticEta/node141',
    'pages/syntheticEta/node142',
    'pages/syntheticEta/node143',
    'pages/syntheticEta/node144',
    'pages/syntheticEta/node145',
    'pages/syntheticEta/node146',
    'pages/syntheticEta/node147',
    'pages/syntheticEta/node148',
    'pages/syntheticEta/node149',
    'pages/syntheticEta/node150',
    'pages/syntheticEta/node151',
    'pages/syntheticEta/node152',
    'pages/syntheticEta/node153',
    'pages/syntheticEta/node154',
    'pages/syntheticEta/node155',
    'pages/syntheticEta/node156',
    'pages/syntheticEta/node157',
    'pages/syntheticEta/node158',
    'pages/syntheticEta/node159',
    'pages/syntheticEta/node160'
  ];

  describe('MegaSyntheticRouteAtlasEtaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteEta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

