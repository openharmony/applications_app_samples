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
  return /^pages\/syntheticCelestial\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasCelestialTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteCelestial_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticCelestial/node001',
    'pages/syntheticCelestial/node002',
    'pages/syntheticCelestial/node003',
    'pages/syntheticCelestial/node004',
    'pages/syntheticCelestial/node005',
    'pages/syntheticCelestial/node006',
    'pages/syntheticCelestial/node007',
    'pages/syntheticCelestial/node008',
    'pages/syntheticCelestial/node009',
    'pages/syntheticCelestial/node010',
    'pages/syntheticCelestial/node011',
    'pages/syntheticCelestial/node012',
    'pages/syntheticCelestial/node013',
    'pages/syntheticCelestial/node014',
    'pages/syntheticCelestial/node015',
    'pages/syntheticCelestial/node016',
    'pages/syntheticCelestial/node017',
    'pages/syntheticCelestial/node018',
    'pages/syntheticCelestial/node019',
    'pages/syntheticCelestial/node020',
    'pages/syntheticCelestial/node021',
    'pages/syntheticCelestial/node022',
    'pages/syntheticCelestial/node023',
    'pages/syntheticCelestial/node024',
    'pages/syntheticCelestial/node025',
    'pages/syntheticCelestial/node026',
    'pages/syntheticCelestial/node027',
    'pages/syntheticCelestial/node028',
    'pages/syntheticCelestial/node029',
    'pages/syntheticCelestial/node030',
    'pages/syntheticCelestial/node031',
    'pages/syntheticCelestial/node032',
    'pages/syntheticCelestial/node033',
    'pages/syntheticCelestial/node034',
    'pages/syntheticCelestial/node035',
    'pages/syntheticCelestial/node036',
    'pages/syntheticCelestial/node037',
    'pages/syntheticCelestial/node038',
    'pages/syntheticCelestial/node039',
    'pages/syntheticCelestial/node040',
    'pages/syntheticCelestial/node041',
    'pages/syntheticCelestial/node042',
    'pages/syntheticCelestial/node043',
    'pages/syntheticCelestial/node044',
    'pages/syntheticCelestial/node045',
    'pages/syntheticCelestial/node046',
    'pages/syntheticCelestial/node047',
    'pages/syntheticCelestial/node048',
    'pages/syntheticCelestial/node049',
    'pages/syntheticCelestial/node050',
    'pages/syntheticCelestial/node051',
    'pages/syntheticCelestial/node052',
    'pages/syntheticCelestial/node053',
    'pages/syntheticCelestial/node054',
    'pages/syntheticCelestial/node055',
    'pages/syntheticCelestial/node056',
    'pages/syntheticCelestial/node057',
    'pages/syntheticCelestial/node058',
    'pages/syntheticCelestial/node059',
    'pages/syntheticCelestial/node060',
    'pages/syntheticCelestial/node061',
    'pages/syntheticCelestial/node062',
    'pages/syntheticCelestial/node063',
    'pages/syntheticCelestial/node064',
    'pages/syntheticCelestial/node065',
    'pages/syntheticCelestial/node066',
    'pages/syntheticCelestial/node067',
    'pages/syntheticCelestial/node068',
    'pages/syntheticCelestial/node069',
    'pages/syntheticCelestial/node070',
    'pages/syntheticCelestial/node071',
    'pages/syntheticCelestial/node072',
    'pages/syntheticCelestial/node073',
    'pages/syntheticCelestial/node074',
    'pages/syntheticCelestial/node075',
    'pages/syntheticCelestial/node076',
    'pages/syntheticCelestial/node077',
    'pages/syntheticCelestial/node078',
    'pages/syntheticCelestial/node079',
    'pages/syntheticCelestial/node080',
    'pages/syntheticCelestial/node081',
    'pages/syntheticCelestial/node082',
    'pages/syntheticCelestial/node083',
    'pages/syntheticCelestial/node084',
    'pages/syntheticCelestial/node085',
    'pages/syntheticCelestial/node086',
    'pages/syntheticCelestial/node087',
    'pages/syntheticCelestial/node088',
    'pages/syntheticCelestial/node089',
    'pages/syntheticCelestial/node090',
    'pages/syntheticCelestial/node091',
    'pages/syntheticCelestial/node092',
    'pages/syntheticCelestial/node093',
    'pages/syntheticCelestial/node094',
    'pages/syntheticCelestial/node095',
    'pages/syntheticCelestial/node096',
    'pages/syntheticCelestial/node097',
    'pages/syntheticCelestial/node098',
    'pages/syntheticCelestial/node099',
    'pages/syntheticCelestial/node100',
    'pages/syntheticCelestial/node101',
    'pages/syntheticCelestial/node102',
    'pages/syntheticCelestial/node103',
    'pages/syntheticCelestial/node104',
    'pages/syntheticCelestial/node105',
    'pages/syntheticCelestial/node106',
    'pages/syntheticCelestial/node107',
    'pages/syntheticCelestial/node108',
    'pages/syntheticCelestial/node109',
    'pages/syntheticCelestial/node110',
    'pages/syntheticCelestial/node111',
    'pages/syntheticCelestial/node112',
    'pages/syntheticCelestial/node113',
    'pages/syntheticCelestial/node114',
    'pages/syntheticCelestial/node115',
    'pages/syntheticCelestial/node116',
    'pages/syntheticCelestial/node117',
    'pages/syntheticCelestial/node118',
    'pages/syntheticCelestial/node119',
    'pages/syntheticCelestial/node120',
    'pages/syntheticCelestial/node121',
    'pages/syntheticCelestial/node122',
    'pages/syntheticCelestial/node123',
    'pages/syntheticCelestial/node124',
    'pages/syntheticCelestial/node125',
    'pages/syntheticCelestial/node126',
    'pages/syntheticCelestial/node127',
    'pages/syntheticCelestial/node128',
    'pages/syntheticCelestial/node129',
    'pages/syntheticCelestial/node130',
    'pages/syntheticCelestial/node131',
    'pages/syntheticCelestial/node132',
    'pages/syntheticCelestial/node133',
    'pages/syntheticCelestial/node134',
    'pages/syntheticCelestial/node135',
    'pages/syntheticCelestial/node136',
    'pages/syntheticCelestial/node137',
    'pages/syntheticCelestial/node138',
    'pages/syntheticCelestial/node139',
    'pages/syntheticCelestial/node140',
    'pages/syntheticCelestial/node141',
    'pages/syntheticCelestial/node142',
    'pages/syntheticCelestial/node143',
    'pages/syntheticCelestial/node144',
    'pages/syntheticCelestial/node145',
    'pages/syntheticCelestial/node146',
    'pages/syntheticCelestial/node147',
    'pages/syntheticCelestial/node148',
    'pages/syntheticCelestial/node149',
    'pages/syntheticCelestial/node150',
    'pages/syntheticCelestial/node151',
    'pages/syntheticCelestial/node152',
    'pages/syntheticCelestial/node153',
    'pages/syntheticCelestial/node154',
    'pages/syntheticCelestial/node155',
    'pages/syntheticCelestial/node156',
    'pages/syntheticCelestial/node157',
    'pages/syntheticCelestial/node158',
    'pages/syntheticCelestial/node159',
    'pages/syntheticCelestial/node160'
  ];

  describe('MegaSyntheticRouteAtlasCelestialSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteCelestial_[A-Za-z0-9_]+_[0-9]{3}$/;
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

