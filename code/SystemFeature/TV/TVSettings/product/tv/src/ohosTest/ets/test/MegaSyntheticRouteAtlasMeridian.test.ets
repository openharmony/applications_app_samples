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
  return /^pages\/syntheticMeridian\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasMeridianTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteMeridian_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticMeridian/node001',
    'pages/syntheticMeridian/node002',
    'pages/syntheticMeridian/node003',
    'pages/syntheticMeridian/node004',
    'pages/syntheticMeridian/node005',
    'pages/syntheticMeridian/node006',
    'pages/syntheticMeridian/node007',
    'pages/syntheticMeridian/node008',
    'pages/syntheticMeridian/node009',
    'pages/syntheticMeridian/node010',
    'pages/syntheticMeridian/node011',
    'pages/syntheticMeridian/node012',
    'pages/syntheticMeridian/node013',
    'pages/syntheticMeridian/node014',
    'pages/syntheticMeridian/node015',
    'pages/syntheticMeridian/node016',
    'pages/syntheticMeridian/node017',
    'pages/syntheticMeridian/node018',
    'pages/syntheticMeridian/node019',
    'pages/syntheticMeridian/node020',
    'pages/syntheticMeridian/node021',
    'pages/syntheticMeridian/node022',
    'pages/syntheticMeridian/node023',
    'pages/syntheticMeridian/node024',
    'pages/syntheticMeridian/node025',
    'pages/syntheticMeridian/node026',
    'pages/syntheticMeridian/node027',
    'pages/syntheticMeridian/node028',
    'pages/syntheticMeridian/node029',
    'pages/syntheticMeridian/node030',
    'pages/syntheticMeridian/node031',
    'pages/syntheticMeridian/node032',
    'pages/syntheticMeridian/node033',
    'pages/syntheticMeridian/node034',
    'pages/syntheticMeridian/node035',
    'pages/syntheticMeridian/node036',
    'pages/syntheticMeridian/node037',
    'pages/syntheticMeridian/node038',
    'pages/syntheticMeridian/node039',
    'pages/syntheticMeridian/node040',
    'pages/syntheticMeridian/node041',
    'pages/syntheticMeridian/node042',
    'pages/syntheticMeridian/node043',
    'pages/syntheticMeridian/node044',
    'pages/syntheticMeridian/node045',
    'pages/syntheticMeridian/node046',
    'pages/syntheticMeridian/node047',
    'pages/syntheticMeridian/node048',
    'pages/syntheticMeridian/node049',
    'pages/syntheticMeridian/node050',
    'pages/syntheticMeridian/node051',
    'pages/syntheticMeridian/node052',
    'pages/syntheticMeridian/node053',
    'pages/syntheticMeridian/node054',
    'pages/syntheticMeridian/node055',
    'pages/syntheticMeridian/node056',
    'pages/syntheticMeridian/node057',
    'pages/syntheticMeridian/node058',
    'pages/syntheticMeridian/node059',
    'pages/syntheticMeridian/node060',
    'pages/syntheticMeridian/node061',
    'pages/syntheticMeridian/node062',
    'pages/syntheticMeridian/node063',
    'pages/syntheticMeridian/node064',
    'pages/syntheticMeridian/node065',
    'pages/syntheticMeridian/node066',
    'pages/syntheticMeridian/node067',
    'pages/syntheticMeridian/node068',
    'pages/syntheticMeridian/node069',
    'pages/syntheticMeridian/node070',
    'pages/syntheticMeridian/node071',
    'pages/syntheticMeridian/node072',
    'pages/syntheticMeridian/node073',
    'pages/syntheticMeridian/node074',
    'pages/syntheticMeridian/node075',
    'pages/syntheticMeridian/node076',
    'pages/syntheticMeridian/node077',
    'pages/syntheticMeridian/node078',
    'pages/syntheticMeridian/node079',
    'pages/syntheticMeridian/node080',
    'pages/syntheticMeridian/node081',
    'pages/syntheticMeridian/node082',
    'pages/syntheticMeridian/node083',
    'pages/syntheticMeridian/node084',
    'pages/syntheticMeridian/node085',
    'pages/syntheticMeridian/node086',
    'pages/syntheticMeridian/node087',
    'pages/syntheticMeridian/node088',
    'pages/syntheticMeridian/node089',
    'pages/syntheticMeridian/node090',
    'pages/syntheticMeridian/node091',
    'pages/syntheticMeridian/node092',
    'pages/syntheticMeridian/node093',
    'pages/syntheticMeridian/node094',
    'pages/syntheticMeridian/node095',
    'pages/syntheticMeridian/node096',
    'pages/syntheticMeridian/node097',
    'pages/syntheticMeridian/node098',
    'pages/syntheticMeridian/node099',
    'pages/syntheticMeridian/node100',
    'pages/syntheticMeridian/node101',
    'pages/syntheticMeridian/node102',
    'pages/syntheticMeridian/node103',
    'pages/syntheticMeridian/node104',
    'pages/syntheticMeridian/node105',
    'pages/syntheticMeridian/node106',
    'pages/syntheticMeridian/node107',
    'pages/syntheticMeridian/node108',
    'pages/syntheticMeridian/node109',
    'pages/syntheticMeridian/node110',
    'pages/syntheticMeridian/node111',
    'pages/syntheticMeridian/node112',
    'pages/syntheticMeridian/node113',
    'pages/syntheticMeridian/node114',
    'pages/syntheticMeridian/node115',
    'pages/syntheticMeridian/node116',
    'pages/syntheticMeridian/node117',
    'pages/syntheticMeridian/node118',
    'pages/syntheticMeridian/node119',
    'pages/syntheticMeridian/node120',
    'pages/syntheticMeridian/node121',
    'pages/syntheticMeridian/node122',
    'pages/syntheticMeridian/node123',
    'pages/syntheticMeridian/node124',
    'pages/syntheticMeridian/node125',
    'pages/syntheticMeridian/node126',
    'pages/syntheticMeridian/node127',
    'pages/syntheticMeridian/node128',
    'pages/syntheticMeridian/node129',
    'pages/syntheticMeridian/node130',
    'pages/syntheticMeridian/node131',
    'pages/syntheticMeridian/node132',
    'pages/syntheticMeridian/node133',
    'pages/syntheticMeridian/node134',
    'pages/syntheticMeridian/node135',
    'pages/syntheticMeridian/node136',
    'pages/syntheticMeridian/node137',
    'pages/syntheticMeridian/node138',
    'pages/syntheticMeridian/node139',
    'pages/syntheticMeridian/node140',
    'pages/syntheticMeridian/node141',
    'pages/syntheticMeridian/node142',
    'pages/syntheticMeridian/node143',
    'pages/syntheticMeridian/node144',
    'pages/syntheticMeridian/node145',
    'pages/syntheticMeridian/node146',
    'pages/syntheticMeridian/node147',
    'pages/syntheticMeridian/node148',
    'pages/syntheticMeridian/node149',
    'pages/syntheticMeridian/node150',
    'pages/syntheticMeridian/node151',
    'pages/syntheticMeridian/node152',
    'pages/syntheticMeridian/node153',
    'pages/syntheticMeridian/node154',
    'pages/syntheticMeridian/node155',
    'pages/syntheticMeridian/node156',
    'pages/syntheticMeridian/node157',
    'pages/syntheticMeridian/node158',
    'pages/syntheticMeridian/node159',
    'pages/syntheticMeridian/node160'
  ];

  describe('MegaSyntheticRouteAtlasMeridianSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteMeridian_[A-Za-z0-9_]+_[0-9]{3}$/;
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

