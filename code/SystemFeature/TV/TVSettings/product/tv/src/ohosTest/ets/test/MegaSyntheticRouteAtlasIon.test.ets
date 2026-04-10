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
  return /^pages\/syntheticIon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasIonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteIon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticIon/node001',
    'pages/syntheticIon/node002',
    'pages/syntheticIon/node003',
    'pages/syntheticIon/node004',
    'pages/syntheticIon/node005',
    'pages/syntheticIon/node006',
    'pages/syntheticIon/node007',
    'pages/syntheticIon/node008',
    'pages/syntheticIon/node009',
    'pages/syntheticIon/node010',
    'pages/syntheticIon/node011',
    'pages/syntheticIon/node012',
    'pages/syntheticIon/node013',
    'pages/syntheticIon/node014',
    'pages/syntheticIon/node015',
    'pages/syntheticIon/node016',
    'pages/syntheticIon/node017',
    'pages/syntheticIon/node018',
    'pages/syntheticIon/node019',
    'pages/syntheticIon/node020',
    'pages/syntheticIon/node021',
    'pages/syntheticIon/node022',
    'pages/syntheticIon/node023',
    'pages/syntheticIon/node024',
    'pages/syntheticIon/node025',
    'pages/syntheticIon/node026',
    'pages/syntheticIon/node027',
    'pages/syntheticIon/node028',
    'pages/syntheticIon/node029',
    'pages/syntheticIon/node030',
    'pages/syntheticIon/node031',
    'pages/syntheticIon/node032',
    'pages/syntheticIon/node033',
    'pages/syntheticIon/node034',
    'pages/syntheticIon/node035',
    'pages/syntheticIon/node036',
    'pages/syntheticIon/node037',
    'pages/syntheticIon/node038',
    'pages/syntheticIon/node039',
    'pages/syntheticIon/node040',
    'pages/syntheticIon/node041',
    'pages/syntheticIon/node042',
    'pages/syntheticIon/node043',
    'pages/syntheticIon/node044',
    'pages/syntheticIon/node045',
    'pages/syntheticIon/node046',
    'pages/syntheticIon/node047',
    'pages/syntheticIon/node048',
    'pages/syntheticIon/node049',
    'pages/syntheticIon/node050',
    'pages/syntheticIon/node051',
    'pages/syntheticIon/node052',
    'pages/syntheticIon/node053',
    'pages/syntheticIon/node054',
    'pages/syntheticIon/node055',
    'pages/syntheticIon/node056',
    'pages/syntheticIon/node057',
    'pages/syntheticIon/node058',
    'pages/syntheticIon/node059',
    'pages/syntheticIon/node060',
    'pages/syntheticIon/node061',
    'pages/syntheticIon/node062',
    'pages/syntheticIon/node063',
    'pages/syntheticIon/node064',
    'pages/syntheticIon/node065',
    'pages/syntheticIon/node066',
    'pages/syntheticIon/node067',
    'pages/syntheticIon/node068',
    'pages/syntheticIon/node069',
    'pages/syntheticIon/node070',
    'pages/syntheticIon/node071',
    'pages/syntheticIon/node072',
    'pages/syntheticIon/node073',
    'pages/syntheticIon/node074',
    'pages/syntheticIon/node075',
    'pages/syntheticIon/node076',
    'pages/syntheticIon/node077',
    'pages/syntheticIon/node078',
    'pages/syntheticIon/node079',
    'pages/syntheticIon/node080',
    'pages/syntheticIon/node081',
    'pages/syntheticIon/node082',
    'pages/syntheticIon/node083',
    'pages/syntheticIon/node084',
    'pages/syntheticIon/node085',
    'pages/syntheticIon/node086',
    'pages/syntheticIon/node087',
    'pages/syntheticIon/node088',
    'pages/syntheticIon/node089',
    'pages/syntheticIon/node090',
    'pages/syntheticIon/node091',
    'pages/syntheticIon/node092',
    'pages/syntheticIon/node093',
    'pages/syntheticIon/node094',
    'pages/syntheticIon/node095',
    'pages/syntheticIon/node096',
    'pages/syntheticIon/node097',
    'pages/syntheticIon/node098',
    'pages/syntheticIon/node099',
    'pages/syntheticIon/node100',
    'pages/syntheticIon/node101',
    'pages/syntheticIon/node102',
    'pages/syntheticIon/node103',
    'pages/syntheticIon/node104',
    'pages/syntheticIon/node105',
    'pages/syntheticIon/node106',
    'pages/syntheticIon/node107',
    'pages/syntheticIon/node108',
    'pages/syntheticIon/node109',
    'pages/syntheticIon/node110',
    'pages/syntheticIon/node111',
    'pages/syntheticIon/node112',
    'pages/syntheticIon/node113',
    'pages/syntheticIon/node114',
    'pages/syntheticIon/node115',
    'pages/syntheticIon/node116',
    'pages/syntheticIon/node117',
    'pages/syntheticIon/node118',
    'pages/syntheticIon/node119',
    'pages/syntheticIon/node120',
    'pages/syntheticIon/node121',
    'pages/syntheticIon/node122',
    'pages/syntheticIon/node123',
    'pages/syntheticIon/node124',
    'pages/syntheticIon/node125',
    'pages/syntheticIon/node126',
    'pages/syntheticIon/node127',
    'pages/syntheticIon/node128',
    'pages/syntheticIon/node129',
    'pages/syntheticIon/node130',
    'pages/syntheticIon/node131',
    'pages/syntheticIon/node132',
    'pages/syntheticIon/node133',
    'pages/syntheticIon/node134',
    'pages/syntheticIon/node135',
    'pages/syntheticIon/node136',
    'pages/syntheticIon/node137',
    'pages/syntheticIon/node138',
    'pages/syntheticIon/node139',
    'pages/syntheticIon/node140',
    'pages/syntheticIon/node141',
    'pages/syntheticIon/node142',
    'pages/syntheticIon/node143',
    'pages/syntheticIon/node144',
    'pages/syntheticIon/node145',
    'pages/syntheticIon/node146',
    'pages/syntheticIon/node147',
    'pages/syntheticIon/node148',
    'pages/syntheticIon/node149',
    'pages/syntheticIon/node150',
    'pages/syntheticIon/node151',
    'pages/syntheticIon/node152',
    'pages/syntheticIon/node153',
    'pages/syntheticIon/node154',
    'pages/syntheticIon/node155',
    'pages/syntheticIon/node156',
    'pages/syntheticIon/node157',
    'pages/syntheticIon/node158',
    'pages/syntheticIon/node159',
    'pages/syntheticIon/node160'
  ];

  describe('MegaSyntheticRouteAtlasIonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteIon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

