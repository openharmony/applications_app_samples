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
  return /^pages\/syntheticJubilee\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasJubileeTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteJubilee_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticJubilee/node001',
    'pages/syntheticJubilee/node002',
    'pages/syntheticJubilee/node003',
    'pages/syntheticJubilee/node004',
    'pages/syntheticJubilee/node005',
    'pages/syntheticJubilee/node006',
    'pages/syntheticJubilee/node007',
    'pages/syntheticJubilee/node008',
    'pages/syntheticJubilee/node009',
    'pages/syntheticJubilee/node010',
    'pages/syntheticJubilee/node011',
    'pages/syntheticJubilee/node012',
    'pages/syntheticJubilee/node013',
    'pages/syntheticJubilee/node014',
    'pages/syntheticJubilee/node015',
    'pages/syntheticJubilee/node016',
    'pages/syntheticJubilee/node017',
    'pages/syntheticJubilee/node018',
    'pages/syntheticJubilee/node019',
    'pages/syntheticJubilee/node020',
    'pages/syntheticJubilee/node021',
    'pages/syntheticJubilee/node022',
    'pages/syntheticJubilee/node023',
    'pages/syntheticJubilee/node024',
    'pages/syntheticJubilee/node025',
    'pages/syntheticJubilee/node026',
    'pages/syntheticJubilee/node027',
    'pages/syntheticJubilee/node028',
    'pages/syntheticJubilee/node029',
    'pages/syntheticJubilee/node030',
    'pages/syntheticJubilee/node031',
    'pages/syntheticJubilee/node032',
    'pages/syntheticJubilee/node033',
    'pages/syntheticJubilee/node034',
    'pages/syntheticJubilee/node035',
    'pages/syntheticJubilee/node036',
    'pages/syntheticJubilee/node037',
    'pages/syntheticJubilee/node038',
    'pages/syntheticJubilee/node039',
    'pages/syntheticJubilee/node040',
    'pages/syntheticJubilee/node041',
    'pages/syntheticJubilee/node042',
    'pages/syntheticJubilee/node043',
    'pages/syntheticJubilee/node044',
    'pages/syntheticJubilee/node045',
    'pages/syntheticJubilee/node046',
    'pages/syntheticJubilee/node047',
    'pages/syntheticJubilee/node048',
    'pages/syntheticJubilee/node049',
    'pages/syntheticJubilee/node050',
    'pages/syntheticJubilee/node051',
    'pages/syntheticJubilee/node052',
    'pages/syntheticJubilee/node053',
    'pages/syntheticJubilee/node054',
    'pages/syntheticJubilee/node055',
    'pages/syntheticJubilee/node056',
    'pages/syntheticJubilee/node057',
    'pages/syntheticJubilee/node058',
    'pages/syntheticJubilee/node059',
    'pages/syntheticJubilee/node060',
    'pages/syntheticJubilee/node061',
    'pages/syntheticJubilee/node062',
    'pages/syntheticJubilee/node063',
    'pages/syntheticJubilee/node064',
    'pages/syntheticJubilee/node065',
    'pages/syntheticJubilee/node066',
    'pages/syntheticJubilee/node067',
    'pages/syntheticJubilee/node068',
    'pages/syntheticJubilee/node069',
    'pages/syntheticJubilee/node070',
    'pages/syntheticJubilee/node071',
    'pages/syntheticJubilee/node072',
    'pages/syntheticJubilee/node073',
    'pages/syntheticJubilee/node074',
    'pages/syntheticJubilee/node075',
    'pages/syntheticJubilee/node076',
    'pages/syntheticJubilee/node077',
    'pages/syntheticJubilee/node078',
    'pages/syntheticJubilee/node079',
    'pages/syntheticJubilee/node080',
    'pages/syntheticJubilee/node081',
    'pages/syntheticJubilee/node082',
    'pages/syntheticJubilee/node083',
    'pages/syntheticJubilee/node084',
    'pages/syntheticJubilee/node085',
    'pages/syntheticJubilee/node086',
    'pages/syntheticJubilee/node087',
    'pages/syntheticJubilee/node088',
    'pages/syntheticJubilee/node089',
    'pages/syntheticJubilee/node090',
    'pages/syntheticJubilee/node091',
    'pages/syntheticJubilee/node092',
    'pages/syntheticJubilee/node093',
    'pages/syntheticJubilee/node094',
    'pages/syntheticJubilee/node095',
    'pages/syntheticJubilee/node096',
    'pages/syntheticJubilee/node097',
    'pages/syntheticJubilee/node098',
    'pages/syntheticJubilee/node099',
    'pages/syntheticJubilee/node100',
    'pages/syntheticJubilee/node101',
    'pages/syntheticJubilee/node102',
    'pages/syntheticJubilee/node103',
    'pages/syntheticJubilee/node104',
    'pages/syntheticJubilee/node105',
    'pages/syntheticJubilee/node106',
    'pages/syntheticJubilee/node107',
    'pages/syntheticJubilee/node108',
    'pages/syntheticJubilee/node109',
    'pages/syntheticJubilee/node110',
    'pages/syntheticJubilee/node111',
    'pages/syntheticJubilee/node112',
    'pages/syntheticJubilee/node113',
    'pages/syntheticJubilee/node114',
    'pages/syntheticJubilee/node115',
    'pages/syntheticJubilee/node116',
    'pages/syntheticJubilee/node117',
    'pages/syntheticJubilee/node118',
    'pages/syntheticJubilee/node119',
    'pages/syntheticJubilee/node120',
    'pages/syntheticJubilee/node121',
    'pages/syntheticJubilee/node122',
    'pages/syntheticJubilee/node123',
    'pages/syntheticJubilee/node124',
    'pages/syntheticJubilee/node125',
    'pages/syntheticJubilee/node126',
    'pages/syntheticJubilee/node127',
    'pages/syntheticJubilee/node128',
    'pages/syntheticJubilee/node129',
    'pages/syntheticJubilee/node130',
    'pages/syntheticJubilee/node131',
    'pages/syntheticJubilee/node132',
    'pages/syntheticJubilee/node133',
    'pages/syntheticJubilee/node134',
    'pages/syntheticJubilee/node135',
    'pages/syntheticJubilee/node136',
    'pages/syntheticJubilee/node137',
    'pages/syntheticJubilee/node138',
    'pages/syntheticJubilee/node139',
    'pages/syntheticJubilee/node140',
    'pages/syntheticJubilee/node141',
    'pages/syntheticJubilee/node142',
    'pages/syntheticJubilee/node143',
    'pages/syntheticJubilee/node144',
    'pages/syntheticJubilee/node145',
    'pages/syntheticJubilee/node146',
    'pages/syntheticJubilee/node147',
    'pages/syntheticJubilee/node148',
    'pages/syntheticJubilee/node149',
    'pages/syntheticJubilee/node150',
    'pages/syntheticJubilee/node151',
    'pages/syntheticJubilee/node152',
    'pages/syntheticJubilee/node153',
    'pages/syntheticJubilee/node154',
    'pages/syntheticJubilee/node155',
    'pages/syntheticJubilee/node156',
    'pages/syntheticJubilee/node157',
    'pages/syntheticJubilee/node158',
    'pages/syntheticJubilee/node159',
    'pages/syntheticJubilee/node160'
  ];

  describe('MegaSyntheticRouteAtlasJubileeSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteJubilee_[A-Za-z0-9_]+_[0-9]{3}$/;
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

