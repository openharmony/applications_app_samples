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
  return /^pages\/syntheticOrbit\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasOrbitTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteOrbit_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticOrbit/node001',
    'pages/syntheticOrbit/node002',
    'pages/syntheticOrbit/node003',
    'pages/syntheticOrbit/node004',
    'pages/syntheticOrbit/node005',
    'pages/syntheticOrbit/node006',
    'pages/syntheticOrbit/node007',
    'pages/syntheticOrbit/node008',
    'pages/syntheticOrbit/node009',
    'pages/syntheticOrbit/node010',
    'pages/syntheticOrbit/node011',
    'pages/syntheticOrbit/node012',
    'pages/syntheticOrbit/node013',
    'pages/syntheticOrbit/node014',
    'pages/syntheticOrbit/node015',
    'pages/syntheticOrbit/node016',
    'pages/syntheticOrbit/node017',
    'pages/syntheticOrbit/node018',
    'pages/syntheticOrbit/node019',
    'pages/syntheticOrbit/node020',
    'pages/syntheticOrbit/node021',
    'pages/syntheticOrbit/node022',
    'pages/syntheticOrbit/node023',
    'pages/syntheticOrbit/node024',
    'pages/syntheticOrbit/node025',
    'pages/syntheticOrbit/node026',
    'pages/syntheticOrbit/node027',
    'pages/syntheticOrbit/node028',
    'pages/syntheticOrbit/node029',
    'pages/syntheticOrbit/node030',
    'pages/syntheticOrbit/node031',
    'pages/syntheticOrbit/node032',
    'pages/syntheticOrbit/node033',
    'pages/syntheticOrbit/node034',
    'pages/syntheticOrbit/node035',
    'pages/syntheticOrbit/node036',
    'pages/syntheticOrbit/node037',
    'pages/syntheticOrbit/node038',
    'pages/syntheticOrbit/node039',
    'pages/syntheticOrbit/node040',
    'pages/syntheticOrbit/node041',
    'pages/syntheticOrbit/node042',
    'pages/syntheticOrbit/node043',
    'pages/syntheticOrbit/node044',
    'pages/syntheticOrbit/node045',
    'pages/syntheticOrbit/node046',
    'pages/syntheticOrbit/node047',
    'pages/syntheticOrbit/node048',
    'pages/syntheticOrbit/node049',
    'pages/syntheticOrbit/node050',
    'pages/syntheticOrbit/node051',
    'pages/syntheticOrbit/node052',
    'pages/syntheticOrbit/node053',
    'pages/syntheticOrbit/node054',
    'pages/syntheticOrbit/node055',
    'pages/syntheticOrbit/node056',
    'pages/syntheticOrbit/node057',
    'pages/syntheticOrbit/node058',
    'pages/syntheticOrbit/node059',
    'pages/syntheticOrbit/node060',
    'pages/syntheticOrbit/node061',
    'pages/syntheticOrbit/node062',
    'pages/syntheticOrbit/node063',
    'pages/syntheticOrbit/node064',
    'pages/syntheticOrbit/node065',
    'pages/syntheticOrbit/node066',
    'pages/syntheticOrbit/node067',
    'pages/syntheticOrbit/node068',
    'pages/syntheticOrbit/node069',
    'pages/syntheticOrbit/node070',
    'pages/syntheticOrbit/node071',
    'pages/syntheticOrbit/node072',
    'pages/syntheticOrbit/node073',
    'pages/syntheticOrbit/node074',
    'pages/syntheticOrbit/node075',
    'pages/syntheticOrbit/node076',
    'pages/syntheticOrbit/node077',
    'pages/syntheticOrbit/node078',
    'pages/syntheticOrbit/node079',
    'pages/syntheticOrbit/node080',
    'pages/syntheticOrbit/node081',
    'pages/syntheticOrbit/node082',
    'pages/syntheticOrbit/node083',
    'pages/syntheticOrbit/node084',
    'pages/syntheticOrbit/node085',
    'pages/syntheticOrbit/node086',
    'pages/syntheticOrbit/node087',
    'pages/syntheticOrbit/node088',
    'pages/syntheticOrbit/node089',
    'pages/syntheticOrbit/node090',
    'pages/syntheticOrbit/node091',
    'pages/syntheticOrbit/node092',
    'pages/syntheticOrbit/node093',
    'pages/syntheticOrbit/node094',
    'pages/syntheticOrbit/node095',
    'pages/syntheticOrbit/node096',
    'pages/syntheticOrbit/node097',
    'pages/syntheticOrbit/node098',
    'pages/syntheticOrbit/node099',
    'pages/syntheticOrbit/node100',
    'pages/syntheticOrbit/node101',
    'pages/syntheticOrbit/node102',
    'pages/syntheticOrbit/node103',
    'pages/syntheticOrbit/node104',
    'pages/syntheticOrbit/node105',
    'pages/syntheticOrbit/node106',
    'pages/syntheticOrbit/node107',
    'pages/syntheticOrbit/node108',
    'pages/syntheticOrbit/node109',
    'pages/syntheticOrbit/node110',
    'pages/syntheticOrbit/node111',
    'pages/syntheticOrbit/node112',
    'pages/syntheticOrbit/node113',
    'pages/syntheticOrbit/node114',
    'pages/syntheticOrbit/node115',
    'pages/syntheticOrbit/node116',
    'pages/syntheticOrbit/node117',
    'pages/syntheticOrbit/node118',
    'pages/syntheticOrbit/node119',
    'pages/syntheticOrbit/node120',
    'pages/syntheticOrbit/node121',
    'pages/syntheticOrbit/node122',
    'pages/syntheticOrbit/node123',
    'pages/syntheticOrbit/node124',
    'pages/syntheticOrbit/node125',
    'pages/syntheticOrbit/node126',
    'pages/syntheticOrbit/node127',
    'pages/syntheticOrbit/node128',
    'pages/syntheticOrbit/node129',
    'pages/syntheticOrbit/node130',
    'pages/syntheticOrbit/node131',
    'pages/syntheticOrbit/node132',
    'pages/syntheticOrbit/node133',
    'pages/syntheticOrbit/node134',
    'pages/syntheticOrbit/node135',
    'pages/syntheticOrbit/node136',
    'pages/syntheticOrbit/node137',
    'pages/syntheticOrbit/node138',
    'pages/syntheticOrbit/node139',
    'pages/syntheticOrbit/node140',
    'pages/syntheticOrbit/node141',
    'pages/syntheticOrbit/node142',
    'pages/syntheticOrbit/node143',
    'pages/syntheticOrbit/node144',
    'pages/syntheticOrbit/node145',
    'pages/syntheticOrbit/node146',
    'pages/syntheticOrbit/node147',
    'pages/syntheticOrbit/node148',
    'pages/syntheticOrbit/node149',
    'pages/syntheticOrbit/node150',
    'pages/syntheticOrbit/node151',
    'pages/syntheticOrbit/node152',
    'pages/syntheticOrbit/node153',
    'pages/syntheticOrbit/node154',
    'pages/syntheticOrbit/node155',
    'pages/syntheticOrbit/node156',
    'pages/syntheticOrbit/node157',
    'pages/syntheticOrbit/node158',
    'pages/syntheticOrbit/node159',
    'pages/syntheticOrbit/node160'
  ];

  describe('MegaSyntheticRouteAtlasOrbitSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteOrbit_[A-Za-z0-9_]+_[0-9]{3}$/;
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

