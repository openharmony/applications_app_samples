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
  return /^pages\/syntheticTalon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasTalonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteTalon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticTalon/node001',
    'pages/syntheticTalon/node002',
    'pages/syntheticTalon/node003',
    'pages/syntheticTalon/node004',
    'pages/syntheticTalon/node005',
    'pages/syntheticTalon/node006',
    'pages/syntheticTalon/node007',
    'pages/syntheticTalon/node008',
    'pages/syntheticTalon/node009',
    'pages/syntheticTalon/node010',
    'pages/syntheticTalon/node011',
    'pages/syntheticTalon/node012',
    'pages/syntheticTalon/node013',
    'pages/syntheticTalon/node014',
    'pages/syntheticTalon/node015',
    'pages/syntheticTalon/node016',
    'pages/syntheticTalon/node017',
    'pages/syntheticTalon/node018',
    'pages/syntheticTalon/node019',
    'pages/syntheticTalon/node020',
    'pages/syntheticTalon/node021',
    'pages/syntheticTalon/node022',
    'pages/syntheticTalon/node023',
    'pages/syntheticTalon/node024',
    'pages/syntheticTalon/node025',
    'pages/syntheticTalon/node026',
    'pages/syntheticTalon/node027',
    'pages/syntheticTalon/node028',
    'pages/syntheticTalon/node029',
    'pages/syntheticTalon/node030',
    'pages/syntheticTalon/node031',
    'pages/syntheticTalon/node032',
    'pages/syntheticTalon/node033',
    'pages/syntheticTalon/node034',
    'pages/syntheticTalon/node035',
    'pages/syntheticTalon/node036',
    'pages/syntheticTalon/node037',
    'pages/syntheticTalon/node038',
    'pages/syntheticTalon/node039',
    'pages/syntheticTalon/node040',
    'pages/syntheticTalon/node041',
    'pages/syntheticTalon/node042',
    'pages/syntheticTalon/node043',
    'pages/syntheticTalon/node044',
    'pages/syntheticTalon/node045',
    'pages/syntheticTalon/node046',
    'pages/syntheticTalon/node047',
    'pages/syntheticTalon/node048',
    'pages/syntheticTalon/node049',
    'pages/syntheticTalon/node050',
    'pages/syntheticTalon/node051',
    'pages/syntheticTalon/node052',
    'pages/syntheticTalon/node053',
    'pages/syntheticTalon/node054',
    'pages/syntheticTalon/node055',
    'pages/syntheticTalon/node056',
    'pages/syntheticTalon/node057',
    'pages/syntheticTalon/node058',
    'pages/syntheticTalon/node059',
    'pages/syntheticTalon/node060',
    'pages/syntheticTalon/node061',
    'pages/syntheticTalon/node062',
    'pages/syntheticTalon/node063',
    'pages/syntheticTalon/node064',
    'pages/syntheticTalon/node065',
    'pages/syntheticTalon/node066',
    'pages/syntheticTalon/node067',
    'pages/syntheticTalon/node068',
    'pages/syntheticTalon/node069',
    'pages/syntheticTalon/node070',
    'pages/syntheticTalon/node071',
    'pages/syntheticTalon/node072',
    'pages/syntheticTalon/node073',
    'pages/syntheticTalon/node074',
    'pages/syntheticTalon/node075',
    'pages/syntheticTalon/node076',
    'pages/syntheticTalon/node077',
    'pages/syntheticTalon/node078',
    'pages/syntheticTalon/node079',
    'pages/syntheticTalon/node080',
    'pages/syntheticTalon/node081',
    'pages/syntheticTalon/node082',
    'pages/syntheticTalon/node083',
    'pages/syntheticTalon/node084',
    'pages/syntheticTalon/node085',
    'pages/syntheticTalon/node086',
    'pages/syntheticTalon/node087',
    'pages/syntheticTalon/node088',
    'pages/syntheticTalon/node089',
    'pages/syntheticTalon/node090',
    'pages/syntheticTalon/node091',
    'pages/syntheticTalon/node092',
    'pages/syntheticTalon/node093',
    'pages/syntheticTalon/node094',
    'pages/syntheticTalon/node095',
    'pages/syntheticTalon/node096',
    'pages/syntheticTalon/node097',
    'pages/syntheticTalon/node098',
    'pages/syntheticTalon/node099',
    'pages/syntheticTalon/node100',
    'pages/syntheticTalon/node101',
    'pages/syntheticTalon/node102',
    'pages/syntheticTalon/node103',
    'pages/syntheticTalon/node104',
    'pages/syntheticTalon/node105',
    'pages/syntheticTalon/node106',
    'pages/syntheticTalon/node107',
    'pages/syntheticTalon/node108',
    'pages/syntheticTalon/node109',
    'pages/syntheticTalon/node110',
    'pages/syntheticTalon/node111',
    'pages/syntheticTalon/node112',
    'pages/syntheticTalon/node113',
    'pages/syntheticTalon/node114',
    'pages/syntheticTalon/node115',
    'pages/syntheticTalon/node116',
    'pages/syntheticTalon/node117',
    'pages/syntheticTalon/node118',
    'pages/syntheticTalon/node119',
    'pages/syntheticTalon/node120',
    'pages/syntheticTalon/node121',
    'pages/syntheticTalon/node122',
    'pages/syntheticTalon/node123',
    'pages/syntheticTalon/node124',
    'pages/syntheticTalon/node125',
    'pages/syntheticTalon/node126',
    'pages/syntheticTalon/node127',
    'pages/syntheticTalon/node128',
    'pages/syntheticTalon/node129',
    'pages/syntheticTalon/node130',
    'pages/syntheticTalon/node131',
    'pages/syntheticTalon/node132',
    'pages/syntheticTalon/node133',
    'pages/syntheticTalon/node134',
    'pages/syntheticTalon/node135',
    'pages/syntheticTalon/node136',
    'pages/syntheticTalon/node137',
    'pages/syntheticTalon/node138',
    'pages/syntheticTalon/node139',
    'pages/syntheticTalon/node140',
    'pages/syntheticTalon/node141',
    'pages/syntheticTalon/node142',
    'pages/syntheticTalon/node143',
    'pages/syntheticTalon/node144',
    'pages/syntheticTalon/node145',
    'pages/syntheticTalon/node146',
    'pages/syntheticTalon/node147',
    'pages/syntheticTalon/node148',
    'pages/syntheticTalon/node149',
    'pages/syntheticTalon/node150',
    'pages/syntheticTalon/node151',
    'pages/syntheticTalon/node152',
    'pages/syntheticTalon/node153',
    'pages/syntheticTalon/node154',
    'pages/syntheticTalon/node155',
    'pages/syntheticTalon/node156',
    'pages/syntheticTalon/node157',
    'pages/syntheticTalon/node158',
    'pages/syntheticTalon/node159',
    'pages/syntheticTalon/node160'
  ];

  describe('MegaSyntheticRouteAtlasTalonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteTalon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

