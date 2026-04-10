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
  return /^pages\/syntheticJuniper\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasJuniperTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteJuniper_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticJuniper/node001',
    'pages/syntheticJuniper/node002',
    'pages/syntheticJuniper/node003',
    'pages/syntheticJuniper/node004',
    'pages/syntheticJuniper/node005',
    'pages/syntheticJuniper/node006',
    'pages/syntheticJuniper/node007',
    'pages/syntheticJuniper/node008',
    'pages/syntheticJuniper/node009',
    'pages/syntheticJuniper/node010',
    'pages/syntheticJuniper/node011',
    'pages/syntheticJuniper/node012',
    'pages/syntheticJuniper/node013',
    'pages/syntheticJuniper/node014',
    'pages/syntheticJuniper/node015',
    'pages/syntheticJuniper/node016',
    'pages/syntheticJuniper/node017',
    'pages/syntheticJuniper/node018',
    'pages/syntheticJuniper/node019',
    'pages/syntheticJuniper/node020',
    'pages/syntheticJuniper/node021',
    'pages/syntheticJuniper/node022',
    'pages/syntheticJuniper/node023',
    'pages/syntheticJuniper/node024',
    'pages/syntheticJuniper/node025',
    'pages/syntheticJuniper/node026',
    'pages/syntheticJuniper/node027',
    'pages/syntheticJuniper/node028',
    'pages/syntheticJuniper/node029',
    'pages/syntheticJuniper/node030',
    'pages/syntheticJuniper/node031',
    'pages/syntheticJuniper/node032',
    'pages/syntheticJuniper/node033',
    'pages/syntheticJuniper/node034',
    'pages/syntheticJuniper/node035',
    'pages/syntheticJuniper/node036',
    'pages/syntheticJuniper/node037',
    'pages/syntheticJuniper/node038',
    'pages/syntheticJuniper/node039',
    'pages/syntheticJuniper/node040',
    'pages/syntheticJuniper/node041',
    'pages/syntheticJuniper/node042',
    'pages/syntheticJuniper/node043',
    'pages/syntheticJuniper/node044',
    'pages/syntheticJuniper/node045',
    'pages/syntheticJuniper/node046',
    'pages/syntheticJuniper/node047',
    'pages/syntheticJuniper/node048',
    'pages/syntheticJuniper/node049',
    'pages/syntheticJuniper/node050',
    'pages/syntheticJuniper/node051',
    'pages/syntheticJuniper/node052',
    'pages/syntheticJuniper/node053',
    'pages/syntheticJuniper/node054',
    'pages/syntheticJuniper/node055',
    'pages/syntheticJuniper/node056',
    'pages/syntheticJuniper/node057',
    'pages/syntheticJuniper/node058',
    'pages/syntheticJuniper/node059',
    'pages/syntheticJuniper/node060',
    'pages/syntheticJuniper/node061',
    'pages/syntheticJuniper/node062',
    'pages/syntheticJuniper/node063',
    'pages/syntheticJuniper/node064',
    'pages/syntheticJuniper/node065',
    'pages/syntheticJuniper/node066',
    'pages/syntheticJuniper/node067',
    'pages/syntheticJuniper/node068',
    'pages/syntheticJuniper/node069',
    'pages/syntheticJuniper/node070',
    'pages/syntheticJuniper/node071',
    'pages/syntheticJuniper/node072',
    'pages/syntheticJuniper/node073',
    'pages/syntheticJuniper/node074',
    'pages/syntheticJuniper/node075',
    'pages/syntheticJuniper/node076',
    'pages/syntheticJuniper/node077',
    'pages/syntheticJuniper/node078',
    'pages/syntheticJuniper/node079',
    'pages/syntheticJuniper/node080',
    'pages/syntheticJuniper/node081',
    'pages/syntheticJuniper/node082',
    'pages/syntheticJuniper/node083',
    'pages/syntheticJuniper/node084',
    'pages/syntheticJuniper/node085',
    'pages/syntheticJuniper/node086',
    'pages/syntheticJuniper/node087',
    'pages/syntheticJuniper/node088',
    'pages/syntheticJuniper/node089',
    'pages/syntheticJuniper/node090',
    'pages/syntheticJuniper/node091',
    'pages/syntheticJuniper/node092',
    'pages/syntheticJuniper/node093',
    'pages/syntheticJuniper/node094',
    'pages/syntheticJuniper/node095',
    'pages/syntheticJuniper/node096',
    'pages/syntheticJuniper/node097',
    'pages/syntheticJuniper/node098',
    'pages/syntheticJuniper/node099',
    'pages/syntheticJuniper/node100',
    'pages/syntheticJuniper/node101',
    'pages/syntheticJuniper/node102',
    'pages/syntheticJuniper/node103',
    'pages/syntheticJuniper/node104',
    'pages/syntheticJuniper/node105',
    'pages/syntheticJuniper/node106',
    'pages/syntheticJuniper/node107',
    'pages/syntheticJuniper/node108',
    'pages/syntheticJuniper/node109',
    'pages/syntheticJuniper/node110',
    'pages/syntheticJuniper/node111',
    'pages/syntheticJuniper/node112',
    'pages/syntheticJuniper/node113',
    'pages/syntheticJuniper/node114',
    'pages/syntheticJuniper/node115',
    'pages/syntheticJuniper/node116',
    'pages/syntheticJuniper/node117',
    'pages/syntheticJuniper/node118',
    'pages/syntheticJuniper/node119',
    'pages/syntheticJuniper/node120',
    'pages/syntheticJuniper/node121',
    'pages/syntheticJuniper/node122',
    'pages/syntheticJuniper/node123',
    'pages/syntheticJuniper/node124',
    'pages/syntheticJuniper/node125',
    'pages/syntheticJuniper/node126',
    'pages/syntheticJuniper/node127',
    'pages/syntheticJuniper/node128',
    'pages/syntheticJuniper/node129',
    'pages/syntheticJuniper/node130',
    'pages/syntheticJuniper/node131',
    'pages/syntheticJuniper/node132',
    'pages/syntheticJuniper/node133',
    'pages/syntheticJuniper/node134',
    'pages/syntheticJuniper/node135',
    'pages/syntheticJuniper/node136',
    'pages/syntheticJuniper/node137',
    'pages/syntheticJuniper/node138',
    'pages/syntheticJuniper/node139',
    'pages/syntheticJuniper/node140',
    'pages/syntheticJuniper/node141',
    'pages/syntheticJuniper/node142',
    'pages/syntheticJuniper/node143',
    'pages/syntheticJuniper/node144',
    'pages/syntheticJuniper/node145',
    'pages/syntheticJuniper/node146',
    'pages/syntheticJuniper/node147',
    'pages/syntheticJuniper/node148',
    'pages/syntheticJuniper/node149',
    'pages/syntheticJuniper/node150',
    'pages/syntheticJuniper/node151',
    'pages/syntheticJuniper/node152',
    'pages/syntheticJuniper/node153',
    'pages/syntheticJuniper/node154',
    'pages/syntheticJuniper/node155',
    'pages/syntheticJuniper/node156',
    'pages/syntheticJuniper/node157',
    'pages/syntheticJuniper/node158',
    'pages/syntheticJuniper/node159',
    'pages/syntheticJuniper/node160'
  ];

  describe('MegaSyntheticRouteAtlasJuniperSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteJuniper_[A-Za-z0-9_]+_[0-9]{3}$/;
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

