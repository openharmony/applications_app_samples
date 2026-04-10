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
  return /^pages\/syntheticTempest\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasTempestTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteTempest_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticTempest/node001',
    'pages/syntheticTempest/node002',
    'pages/syntheticTempest/node003',
    'pages/syntheticTempest/node004',
    'pages/syntheticTempest/node005',
    'pages/syntheticTempest/node006',
    'pages/syntheticTempest/node007',
    'pages/syntheticTempest/node008',
    'pages/syntheticTempest/node009',
    'pages/syntheticTempest/node010',
    'pages/syntheticTempest/node011',
    'pages/syntheticTempest/node012',
    'pages/syntheticTempest/node013',
    'pages/syntheticTempest/node014',
    'pages/syntheticTempest/node015',
    'pages/syntheticTempest/node016',
    'pages/syntheticTempest/node017',
    'pages/syntheticTempest/node018',
    'pages/syntheticTempest/node019',
    'pages/syntheticTempest/node020',
    'pages/syntheticTempest/node021',
    'pages/syntheticTempest/node022',
    'pages/syntheticTempest/node023',
    'pages/syntheticTempest/node024',
    'pages/syntheticTempest/node025',
    'pages/syntheticTempest/node026',
    'pages/syntheticTempest/node027',
    'pages/syntheticTempest/node028',
    'pages/syntheticTempest/node029',
    'pages/syntheticTempest/node030',
    'pages/syntheticTempest/node031',
    'pages/syntheticTempest/node032',
    'pages/syntheticTempest/node033',
    'pages/syntheticTempest/node034',
    'pages/syntheticTempest/node035',
    'pages/syntheticTempest/node036',
    'pages/syntheticTempest/node037',
    'pages/syntheticTempest/node038',
    'pages/syntheticTempest/node039',
    'pages/syntheticTempest/node040',
    'pages/syntheticTempest/node041',
    'pages/syntheticTempest/node042',
    'pages/syntheticTempest/node043',
    'pages/syntheticTempest/node044',
    'pages/syntheticTempest/node045',
    'pages/syntheticTempest/node046',
    'pages/syntheticTempest/node047',
    'pages/syntheticTempest/node048',
    'pages/syntheticTempest/node049',
    'pages/syntheticTempest/node050',
    'pages/syntheticTempest/node051',
    'pages/syntheticTempest/node052',
    'pages/syntheticTempest/node053',
    'pages/syntheticTempest/node054',
    'pages/syntheticTempest/node055',
    'pages/syntheticTempest/node056',
    'pages/syntheticTempest/node057',
    'pages/syntheticTempest/node058',
    'pages/syntheticTempest/node059',
    'pages/syntheticTempest/node060',
    'pages/syntheticTempest/node061',
    'pages/syntheticTempest/node062',
    'pages/syntheticTempest/node063',
    'pages/syntheticTempest/node064',
    'pages/syntheticTempest/node065',
    'pages/syntheticTempest/node066',
    'pages/syntheticTempest/node067',
    'pages/syntheticTempest/node068',
    'pages/syntheticTempest/node069',
    'pages/syntheticTempest/node070',
    'pages/syntheticTempest/node071',
    'pages/syntheticTempest/node072',
    'pages/syntheticTempest/node073',
    'pages/syntheticTempest/node074',
    'pages/syntheticTempest/node075',
    'pages/syntheticTempest/node076',
    'pages/syntheticTempest/node077',
    'pages/syntheticTempest/node078',
    'pages/syntheticTempest/node079',
    'pages/syntheticTempest/node080',
    'pages/syntheticTempest/node081',
    'pages/syntheticTempest/node082',
    'pages/syntheticTempest/node083',
    'pages/syntheticTempest/node084',
    'pages/syntheticTempest/node085',
    'pages/syntheticTempest/node086',
    'pages/syntheticTempest/node087',
    'pages/syntheticTempest/node088',
    'pages/syntheticTempest/node089',
    'pages/syntheticTempest/node090',
    'pages/syntheticTempest/node091',
    'pages/syntheticTempest/node092',
    'pages/syntheticTempest/node093',
    'pages/syntheticTempest/node094',
    'pages/syntheticTempest/node095',
    'pages/syntheticTempest/node096',
    'pages/syntheticTempest/node097',
    'pages/syntheticTempest/node098',
    'pages/syntheticTempest/node099',
    'pages/syntheticTempest/node100',
    'pages/syntheticTempest/node101',
    'pages/syntheticTempest/node102',
    'pages/syntheticTempest/node103',
    'pages/syntheticTempest/node104',
    'pages/syntheticTempest/node105',
    'pages/syntheticTempest/node106',
    'pages/syntheticTempest/node107',
    'pages/syntheticTempest/node108',
    'pages/syntheticTempest/node109',
    'pages/syntheticTempest/node110',
    'pages/syntheticTempest/node111',
    'pages/syntheticTempest/node112',
    'pages/syntheticTempest/node113',
    'pages/syntheticTempest/node114',
    'pages/syntheticTempest/node115',
    'pages/syntheticTempest/node116',
    'pages/syntheticTempest/node117',
    'pages/syntheticTempest/node118',
    'pages/syntheticTempest/node119',
    'pages/syntheticTempest/node120',
    'pages/syntheticTempest/node121',
    'pages/syntheticTempest/node122',
    'pages/syntheticTempest/node123',
    'pages/syntheticTempest/node124',
    'pages/syntheticTempest/node125',
    'pages/syntheticTempest/node126',
    'pages/syntheticTempest/node127',
    'pages/syntheticTempest/node128',
    'pages/syntheticTempest/node129',
    'pages/syntheticTempest/node130',
    'pages/syntheticTempest/node131',
    'pages/syntheticTempest/node132',
    'pages/syntheticTempest/node133',
    'pages/syntheticTempest/node134',
    'pages/syntheticTempest/node135',
    'pages/syntheticTempest/node136',
    'pages/syntheticTempest/node137',
    'pages/syntheticTempest/node138',
    'pages/syntheticTempest/node139',
    'pages/syntheticTempest/node140',
    'pages/syntheticTempest/node141',
    'pages/syntheticTempest/node142',
    'pages/syntheticTempest/node143',
    'pages/syntheticTempest/node144',
    'pages/syntheticTempest/node145',
    'pages/syntheticTempest/node146',
    'pages/syntheticTempest/node147',
    'pages/syntheticTempest/node148',
    'pages/syntheticTempest/node149',
    'pages/syntheticTempest/node150',
    'pages/syntheticTempest/node151',
    'pages/syntheticTempest/node152',
    'pages/syntheticTempest/node153',
    'pages/syntheticTempest/node154',
    'pages/syntheticTempest/node155',
    'pages/syntheticTempest/node156',
    'pages/syntheticTempest/node157',
    'pages/syntheticTempest/node158',
    'pages/syntheticTempest/node159',
    'pages/syntheticTempest/node160'
  ];

  describe('MegaSyntheticRouteAtlasTempestSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteTempest_[A-Za-z0-9_]+_[0-9]{3}$/;
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

