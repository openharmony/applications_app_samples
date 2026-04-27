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
  return /^pages\/syntheticCitadel\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasCitadelTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteCitadel_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticCitadel/node001',
    'pages/syntheticCitadel/node002',
    'pages/syntheticCitadel/node003',
    'pages/syntheticCitadel/node004',
    'pages/syntheticCitadel/node005',
    'pages/syntheticCitadel/node006',
    'pages/syntheticCitadel/node007',
    'pages/syntheticCitadel/node008',
    'pages/syntheticCitadel/node009',
    'pages/syntheticCitadel/node010',
    'pages/syntheticCitadel/node011',
    'pages/syntheticCitadel/node012',
    'pages/syntheticCitadel/node013',
    'pages/syntheticCitadel/node014',
    'pages/syntheticCitadel/node015',
    'pages/syntheticCitadel/node016',
    'pages/syntheticCitadel/node017',
    'pages/syntheticCitadel/node018',
    'pages/syntheticCitadel/node019',
    'pages/syntheticCitadel/node020',
    'pages/syntheticCitadel/node021',
    'pages/syntheticCitadel/node022',
    'pages/syntheticCitadel/node023',
    'pages/syntheticCitadel/node024',
    'pages/syntheticCitadel/node025',
    'pages/syntheticCitadel/node026',
    'pages/syntheticCitadel/node027',
    'pages/syntheticCitadel/node028',
    'pages/syntheticCitadel/node029',
    'pages/syntheticCitadel/node030',
    'pages/syntheticCitadel/node031',
    'pages/syntheticCitadel/node032',
    'pages/syntheticCitadel/node033',
    'pages/syntheticCitadel/node034',
    'pages/syntheticCitadel/node035',
    'pages/syntheticCitadel/node036',
    'pages/syntheticCitadel/node037',
    'pages/syntheticCitadel/node038',
    'pages/syntheticCitadel/node039',
    'pages/syntheticCitadel/node040',
    'pages/syntheticCitadel/node041',
    'pages/syntheticCitadel/node042',
    'pages/syntheticCitadel/node043',
    'pages/syntheticCitadel/node044',
    'pages/syntheticCitadel/node045',
    'pages/syntheticCitadel/node046',
    'pages/syntheticCitadel/node047',
    'pages/syntheticCitadel/node048',
    'pages/syntheticCitadel/node049',
    'pages/syntheticCitadel/node050',
    'pages/syntheticCitadel/node051',
    'pages/syntheticCitadel/node052',
    'pages/syntheticCitadel/node053',
    'pages/syntheticCitadel/node054',
    'pages/syntheticCitadel/node055',
    'pages/syntheticCitadel/node056',
    'pages/syntheticCitadel/node057',
    'pages/syntheticCitadel/node058',
    'pages/syntheticCitadel/node059',
    'pages/syntheticCitadel/node060',
    'pages/syntheticCitadel/node061',
    'pages/syntheticCitadel/node062',
    'pages/syntheticCitadel/node063',
    'pages/syntheticCitadel/node064',
    'pages/syntheticCitadel/node065',
    'pages/syntheticCitadel/node066',
    'pages/syntheticCitadel/node067',
    'pages/syntheticCitadel/node068',
    'pages/syntheticCitadel/node069',
    'pages/syntheticCitadel/node070',
    'pages/syntheticCitadel/node071',
    'pages/syntheticCitadel/node072',
    'pages/syntheticCitadel/node073',
    'pages/syntheticCitadel/node074',
    'pages/syntheticCitadel/node075',
    'pages/syntheticCitadel/node076',
    'pages/syntheticCitadel/node077',
    'pages/syntheticCitadel/node078',
    'pages/syntheticCitadel/node079',
    'pages/syntheticCitadel/node080',
    'pages/syntheticCitadel/node081',
    'pages/syntheticCitadel/node082',
    'pages/syntheticCitadel/node083',
    'pages/syntheticCitadel/node084',
    'pages/syntheticCitadel/node085',
    'pages/syntheticCitadel/node086',
    'pages/syntheticCitadel/node087',
    'pages/syntheticCitadel/node088',
    'pages/syntheticCitadel/node089',
    'pages/syntheticCitadel/node090',
    'pages/syntheticCitadel/node091',
    'pages/syntheticCitadel/node092',
    'pages/syntheticCitadel/node093',
    'pages/syntheticCitadel/node094',
    'pages/syntheticCitadel/node095',
    'pages/syntheticCitadel/node096',
    'pages/syntheticCitadel/node097',
    'pages/syntheticCitadel/node098',
    'pages/syntheticCitadel/node099',
    'pages/syntheticCitadel/node100',
    'pages/syntheticCitadel/node101',
    'pages/syntheticCitadel/node102',
    'pages/syntheticCitadel/node103',
    'pages/syntheticCitadel/node104',
    'pages/syntheticCitadel/node105',
    'pages/syntheticCitadel/node106',
    'pages/syntheticCitadel/node107',
    'pages/syntheticCitadel/node108',
    'pages/syntheticCitadel/node109',
    'pages/syntheticCitadel/node110',
    'pages/syntheticCitadel/node111',
    'pages/syntheticCitadel/node112',
    'pages/syntheticCitadel/node113',
    'pages/syntheticCitadel/node114',
    'pages/syntheticCitadel/node115',
    'pages/syntheticCitadel/node116',
    'pages/syntheticCitadel/node117',
    'pages/syntheticCitadel/node118',
    'pages/syntheticCitadel/node119',
    'pages/syntheticCitadel/node120',
    'pages/syntheticCitadel/node121',
    'pages/syntheticCitadel/node122',
    'pages/syntheticCitadel/node123',
    'pages/syntheticCitadel/node124',
    'pages/syntheticCitadel/node125',
    'pages/syntheticCitadel/node126',
    'pages/syntheticCitadel/node127',
    'pages/syntheticCitadel/node128',
    'pages/syntheticCitadel/node129',
    'pages/syntheticCitadel/node130',
    'pages/syntheticCitadel/node131',
    'pages/syntheticCitadel/node132',
    'pages/syntheticCitadel/node133',
    'pages/syntheticCitadel/node134',
    'pages/syntheticCitadel/node135',
    'pages/syntheticCitadel/node136',
    'pages/syntheticCitadel/node137',
    'pages/syntheticCitadel/node138',
    'pages/syntheticCitadel/node139',
    'pages/syntheticCitadel/node140',
    'pages/syntheticCitadel/node141',
    'pages/syntheticCitadel/node142',
    'pages/syntheticCitadel/node143',
    'pages/syntheticCitadel/node144',
    'pages/syntheticCitadel/node145',
    'pages/syntheticCitadel/node146',
    'pages/syntheticCitadel/node147',
    'pages/syntheticCitadel/node148',
    'pages/syntheticCitadel/node149',
    'pages/syntheticCitadel/node150',
    'pages/syntheticCitadel/node151',
    'pages/syntheticCitadel/node152',
    'pages/syntheticCitadel/node153',
    'pages/syntheticCitadel/node154',
    'pages/syntheticCitadel/node155',
    'pages/syntheticCitadel/node156',
    'pages/syntheticCitadel/node157',
    'pages/syntheticCitadel/node158',
    'pages/syntheticCitadel/node159',
    'pages/syntheticCitadel/node160'
  ];

  describe('MegaSyntheticRouteAtlasCitadelSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteCitadel_[A-Za-z0-9_]+_[0-9]{3}$/;
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

