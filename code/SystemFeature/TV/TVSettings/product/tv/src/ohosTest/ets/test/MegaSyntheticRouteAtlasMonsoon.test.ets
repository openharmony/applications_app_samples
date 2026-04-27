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
  return /^pages\/syntheticMonsoon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasMonsoonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteMonsoon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticMonsoon/node001',
    'pages/syntheticMonsoon/node002',
    'pages/syntheticMonsoon/node003',
    'pages/syntheticMonsoon/node004',
    'pages/syntheticMonsoon/node005',
    'pages/syntheticMonsoon/node006',
    'pages/syntheticMonsoon/node007',
    'pages/syntheticMonsoon/node008',
    'pages/syntheticMonsoon/node009',
    'pages/syntheticMonsoon/node010',
    'pages/syntheticMonsoon/node011',
    'pages/syntheticMonsoon/node012',
    'pages/syntheticMonsoon/node013',
    'pages/syntheticMonsoon/node014',
    'pages/syntheticMonsoon/node015',
    'pages/syntheticMonsoon/node016',
    'pages/syntheticMonsoon/node017',
    'pages/syntheticMonsoon/node018',
    'pages/syntheticMonsoon/node019',
    'pages/syntheticMonsoon/node020',
    'pages/syntheticMonsoon/node021',
    'pages/syntheticMonsoon/node022',
    'pages/syntheticMonsoon/node023',
    'pages/syntheticMonsoon/node024',
    'pages/syntheticMonsoon/node025',
    'pages/syntheticMonsoon/node026',
    'pages/syntheticMonsoon/node027',
    'pages/syntheticMonsoon/node028',
    'pages/syntheticMonsoon/node029',
    'pages/syntheticMonsoon/node030',
    'pages/syntheticMonsoon/node031',
    'pages/syntheticMonsoon/node032',
    'pages/syntheticMonsoon/node033',
    'pages/syntheticMonsoon/node034',
    'pages/syntheticMonsoon/node035',
    'pages/syntheticMonsoon/node036',
    'pages/syntheticMonsoon/node037',
    'pages/syntheticMonsoon/node038',
    'pages/syntheticMonsoon/node039',
    'pages/syntheticMonsoon/node040',
    'pages/syntheticMonsoon/node041',
    'pages/syntheticMonsoon/node042',
    'pages/syntheticMonsoon/node043',
    'pages/syntheticMonsoon/node044',
    'pages/syntheticMonsoon/node045',
    'pages/syntheticMonsoon/node046',
    'pages/syntheticMonsoon/node047',
    'pages/syntheticMonsoon/node048',
    'pages/syntheticMonsoon/node049',
    'pages/syntheticMonsoon/node050',
    'pages/syntheticMonsoon/node051',
    'pages/syntheticMonsoon/node052',
    'pages/syntheticMonsoon/node053',
    'pages/syntheticMonsoon/node054',
    'pages/syntheticMonsoon/node055',
    'pages/syntheticMonsoon/node056',
    'pages/syntheticMonsoon/node057',
    'pages/syntheticMonsoon/node058',
    'pages/syntheticMonsoon/node059',
    'pages/syntheticMonsoon/node060',
    'pages/syntheticMonsoon/node061',
    'pages/syntheticMonsoon/node062',
    'pages/syntheticMonsoon/node063',
    'pages/syntheticMonsoon/node064',
    'pages/syntheticMonsoon/node065',
    'pages/syntheticMonsoon/node066',
    'pages/syntheticMonsoon/node067',
    'pages/syntheticMonsoon/node068',
    'pages/syntheticMonsoon/node069',
    'pages/syntheticMonsoon/node070',
    'pages/syntheticMonsoon/node071',
    'pages/syntheticMonsoon/node072',
    'pages/syntheticMonsoon/node073',
    'pages/syntheticMonsoon/node074',
    'pages/syntheticMonsoon/node075',
    'pages/syntheticMonsoon/node076',
    'pages/syntheticMonsoon/node077',
    'pages/syntheticMonsoon/node078',
    'pages/syntheticMonsoon/node079',
    'pages/syntheticMonsoon/node080',
    'pages/syntheticMonsoon/node081',
    'pages/syntheticMonsoon/node082',
    'pages/syntheticMonsoon/node083',
    'pages/syntheticMonsoon/node084',
    'pages/syntheticMonsoon/node085',
    'pages/syntheticMonsoon/node086',
    'pages/syntheticMonsoon/node087',
    'pages/syntheticMonsoon/node088',
    'pages/syntheticMonsoon/node089',
    'pages/syntheticMonsoon/node090',
    'pages/syntheticMonsoon/node091',
    'pages/syntheticMonsoon/node092',
    'pages/syntheticMonsoon/node093',
    'pages/syntheticMonsoon/node094',
    'pages/syntheticMonsoon/node095',
    'pages/syntheticMonsoon/node096',
    'pages/syntheticMonsoon/node097',
    'pages/syntheticMonsoon/node098',
    'pages/syntheticMonsoon/node099',
    'pages/syntheticMonsoon/node100',
    'pages/syntheticMonsoon/node101',
    'pages/syntheticMonsoon/node102',
    'pages/syntheticMonsoon/node103',
    'pages/syntheticMonsoon/node104',
    'pages/syntheticMonsoon/node105',
    'pages/syntheticMonsoon/node106',
    'pages/syntheticMonsoon/node107',
    'pages/syntheticMonsoon/node108',
    'pages/syntheticMonsoon/node109',
    'pages/syntheticMonsoon/node110',
    'pages/syntheticMonsoon/node111',
    'pages/syntheticMonsoon/node112',
    'pages/syntheticMonsoon/node113',
    'pages/syntheticMonsoon/node114',
    'pages/syntheticMonsoon/node115',
    'pages/syntheticMonsoon/node116',
    'pages/syntheticMonsoon/node117',
    'pages/syntheticMonsoon/node118',
    'pages/syntheticMonsoon/node119',
    'pages/syntheticMonsoon/node120',
    'pages/syntheticMonsoon/node121',
    'pages/syntheticMonsoon/node122',
    'pages/syntheticMonsoon/node123',
    'pages/syntheticMonsoon/node124',
    'pages/syntheticMonsoon/node125',
    'pages/syntheticMonsoon/node126',
    'pages/syntheticMonsoon/node127',
    'pages/syntheticMonsoon/node128',
    'pages/syntheticMonsoon/node129',
    'pages/syntheticMonsoon/node130',
    'pages/syntheticMonsoon/node131',
    'pages/syntheticMonsoon/node132',
    'pages/syntheticMonsoon/node133',
    'pages/syntheticMonsoon/node134',
    'pages/syntheticMonsoon/node135',
    'pages/syntheticMonsoon/node136',
    'pages/syntheticMonsoon/node137',
    'pages/syntheticMonsoon/node138',
    'pages/syntheticMonsoon/node139',
    'pages/syntheticMonsoon/node140',
    'pages/syntheticMonsoon/node141',
    'pages/syntheticMonsoon/node142',
    'pages/syntheticMonsoon/node143',
    'pages/syntheticMonsoon/node144',
    'pages/syntheticMonsoon/node145',
    'pages/syntheticMonsoon/node146',
    'pages/syntheticMonsoon/node147',
    'pages/syntheticMonsoon/node148',
    'pages/syntheticMonsoon/node149',
    'pages/syntheticMonsoon/node150',
    'pages/syntheticMonsoon/node151',
    'pages/syntheticMonsoon/node152',
    'pages/syntheticMonsoon/node153',
    'pages/syntheticMonsoon/node154',
    'pages/syntheticMonsoon/node155',
    'pages/syntheticMonsoon/node156',
    'pages/syntheticMonsoon/node157',
    'pages/syntheticMonsoon/node158',
    'pages/syntheticMonsoon/node159',
    'pages/syntheticMonsoon/node160'
  ];

  describe('MegaSyntheticRouteAtlasMonsoonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteMonsoon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

