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
  return /^pages\/syntheticOnyx\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasOnyxTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteOnyx_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticOnyx/node001',
    'pages/syntheticOnyx/node002',
    'pages/syntheticOnyx/node003',
    'pages/syntheticOnyx/node004',
    'pages/syntheticOnyx/node005',
    'pages/syntheticOnyx/node006',
    'pages/syntheticOnyx/node007',
    'pages/syntheticOnyx/node008',
    'pages/syntheticOnyx/node009',
    'pages/syntheticOnyx/node010',
    'pages/syntheticOnyx/node011',
    'pages/syntheticOnyx/node012',
    'pages/syntheticOnyx/node013',
    'pages/syntheticOnyx/node014',
    'pages/syntheticOnyx/node015',
    'pages/syntheticOnyx/node016',
    'pages/syntheticOnyx/node017',
    'pages/syntheticOnyx/node018',
    'pages/syntheticOnyx/node019',
    'pages/syntheticOnyx/node020',
    'pages/syntheticOnyx/node021',
    'pages/syntheticOnyx/node022',
    'pages/syntheticOnyx/node023',
    'pages/syntheticOnyx/node024',
    'pages/syntheticOnyx/node025',
    'pages/syntheticOnyx/node026',
    'pages/syntheticOnyx/node027',
    'pages/syntheticOnyx/node028',
    'pages/syntheticOnyx/node029',
    'pages/syntheticOnyx/node030',
    'pages/syntheticOnyx/node031',
    'pages/syntheticOnyx/node032',
    'pages/syntheticOnyx/node033',
    'pages/syntheticOnyx/node034',
    'pages/syntheticOnyx/node035',
    'pages/syntheticOnyx/node036',
    'pages/syntheticOnyx/node037',
    'pages/syntheticOnyx/node038',
    'pages/syntheticOnyx/node039',
    'pages/syntheticOnyx/node040',
    'pages/syntheticOnyx/node041',
    'pages/syntheticOnyx/node042',
    'pages/syntheticOnyx/node043',
    'pages/syntheticOnyx/node044',
    'pages/syntheticOnyx/node045',
    'pages/syntheticOnyx/node046',
    'pages/syntheticOnyx/node047',
    'pages/syntheticOnyx/node048',
    'pages/syntheticOnyx/node049',
    'pages/syntheticOnyx/node050',
    'pages/syntheticOnyx/node051',
    'pages/syntheticOnyx/node052',
    'pages/syntheticOnyx/node053',
    'pages/syntheticOnyx/node054',
    'pages/syntheticOnyx/node055',
    'pages/syntheticOnyx/node056',
    'pages/syntheticOnyx/node057',
    'pages/syntheticOnyx/node058',
    'pages/syntheticOnyx/node059',
    'pages/syntheticOnyx/node060',
    'pages/syntheticOnyx/node061',
    'pages/syntheticOnyx/node062',
    'pages/syntheticOnyx/node063',
    'pages/syntheticOnyx/node064',
    'pages/syntheticOnyx/node065',
    'pages/syntheticOnyx/node066',
    'pages/syntheticOnyx/node067',
    'pages/syntheticOnyx/node068',
    'pages/syntheticOnyx/node069',
    'pages/syntheticOnyx/node070',
    'pages/syntheticOnyx/node071',
    'pages/syntheticOnyx/node072',
    'pages/syntheticOnyx/node073',
    'pages/syntheticOnyx/node074',
    'pages/syntheticOnyx/node075',
    'pages/syntheticOnyx/node076',
    'pages/syntheticOnyx/node077',
    'pages/syntheticOnyx/node078',
    'pages/syntheticOnyx/node079',
    'pages/syntheticOnyx/node080',
    'pages/syntheticOnyx/node081',
    'pages/syntheticOnyx/node082',
    'pages/syntheticOnyx/node083',
    'pages/syntheticOnyx/node084',
    'pages/syntheticOnyx/node085',
    'pages/syntheticOnyx/node086',
    'pages/syntheticOnyx/node087',
    'pages/syntheticOnyx/node088',
    'pages/syntheticOnyx/node089',
    'pages/syntheticOnyx/node090',
    'pages/syntheticOnyx/node091',
    'pages/syntheticOnyx/node092',
    'pages/syntheticOnyx/node093',
    'pages/syntheticOnyx/node094',
    'pages/syntheticOnyx/node095',
    'pages/syntheticOnyx/node096',
    'pages/syntheticOnyx/node097',
    'pages/syntheticOnyx/node098',
    'pages/syntheticOnyx/node099',
    'pages/syntheticOnyx/node100',
    'pages/syntheticOnyx/node101',
    'pages/syntheticOnyx/node102',
    'pages/syntheticOnyx/node103',
    'pages/syntheticOnyx/node104',
    'pages/syntheticOnyx/node105',
    'pages/syntheticOnyx/node106',
    'pages/syntheticOnyx/node107',
    'pages/syntheticOnyx/node108',
    'pages/syntheticOnyx/node109',
    'pages/syntheticOnyx/node110',
    'pages/syntheticOnyx/node111',
    'pages/syntheticOnyx/node112',
    'pages/syntheticOnyx/node113',
    'pages/syntheticOnyx/node114',
    'pages/syntheticOnyx/node115',
    'pages/syntheticOnyx/node116',
    'pages/syntheticOnyx/node117',
    'pages/syntheticOnyx/node118',
    'pages/syntheticOnyx/node119',
    'pages/syntheticOnyx/node120',
    'pages/syntheticOnyx/node121',
    'pages/syntheticOnyx/node122',
    'pages/syntheticOnyx/node123',
    'pages/syntheticOnyx/node124',
    'pages/syntheticOnyx/node125',
    'pages/syntheticOnyx/node126',
    'pages/syntheticOnyx/node127',
    'pages/syntheticOnyx/node128',
    'pages/syntheticOnyx/node129',
    'pages/syntheticOnyx/node130',
    'pages/syntheticOnyx/node131',
    'pages/syntheticOnyx/node132',
    'pages/syntheticOnyx/node133',
    'pages/syntheticOnyx/node134',
    'pages/syntheticOnyx/node135',
    'pages/syntheticOnyx/node136',
    'pages/syntheticOnyx/node137',
    'pages/syntheticOnyx/node138',
    'pages/syntheticOnyx/node139',
    'pages/syntheticOnyx/node140',
    'pages/syntheticOnyx/node141',
    'pages/syntheticOnyx/node142',
    'pages/syntheticOnyx/node143',
    'pages/syntheticOnyx/node144',
    'pages/syntheticOnyx/node145',
    'pages/syntheticOnyx/node146',
    'pages/syntheticOnyx/node147',
    'pages/syntheticOnyx/node148',
    'pages/syntheticOnyx/node149',
    'pages/syntheticOnyx/node150',
    'pages/syntheticOnyx/node151',
    'pages/syntheticOnyx/node152',
    'pages/syntheticOnyx/node153',
    'pages/syntheticOnyx/node154',
    'pages/syntheticOnyx/node155',
    'pages/syntheticOnyx/node156',
    'pages/syntheticOnyx/node157',
    'pages/syntheticOnyx/node158',
    'pages/syntheticOnyx/node159',
    'pages/syntheticOnyx/node160'
  ];

  describe('MegaSyntheticRouteAtlasOnyxSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteOnyx_[A-Za-z0-9_]+_[0-9]{3}$/;
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

