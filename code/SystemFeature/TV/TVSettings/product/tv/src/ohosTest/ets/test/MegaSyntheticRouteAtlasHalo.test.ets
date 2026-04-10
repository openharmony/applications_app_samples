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
  return /^pages\/syntheticHalo\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasHaloTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteHalo_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticHalo/node001',
    'pages/syntheticHalo/node002',
    'pages/syntheticHalo/node003',
    'pages/syntheticHalo/node004',
    'pages/syntheticHalo/node005',
    'pages/syntheticHalo/node006',
    'pages/syntheticHalo/node007',
    'pages/syntheticHalo/node008',
    'pages/syntheticHalo/node009',
    'pages/syntheticHalo/node010',
    'pages/syntheticHalo/node011',
    'pages/syntheticHalo/node012',
    'pages/syntheticHalo/node013',
    'pages/syntheticHalo/node014',
    'pages/syntheticHalo/node015',
    'pages/syntheticHalo/node016',
    'pages/syntheticHalo/node017',
    'pages/syntheticHalo/node018',
    'pages/syntheticHalo/node019',
    'pages/syntheticHalo/node020',
    'pages/syntheticHalo/node021',
    'pages/syntheticHalo/node022',
    'pages/syntheticHalo/node023',
    'pages/syntheticHalo/node024',
    'pages/syntheticHalo/node025',
    'pages/syntheticHalo/node026',
    'pages/syntheticHalo/node027',
    'pages/syntheticHalo/node028',
    'pages/syntheticHalo/node029',
    'pages/syntheticHalo/node030',
    'pages/syntheticHalo/node031',
    'pages/syntheticHalo/node032',
    'pages/syntheticHalo/node033',
    'pages/syntheticHalo/node034',
    'pages/syntheticHalo/node035',
    'pages/syntheticHalo/node036',
    'pages/syntheticHalo/node037',
    'pages/syntheticHalo/node038',
    'pages/syntheticHalo/node039',
    'pages/syntheticHalo/node040',
    'pages/syntheticHalo/node041',
    'pages/syntheticHalo/node042',
    'pages/syntheticHalo/node043',
    'pages/syntheticHalo/node044',
    'pages/syntheticHalo/node045',
    'pages/syntheticHalo/node046',
    'pages/syntheticHalo/node047',
    'pages/syntheticHalo/node048',
    'pages/syntheticHalo/node049',
    'pages/syntheticHalo/node050',
    'pages/syntheticHalo/node051',
    'pages/syntheticHalo/node052',
    'pages/syntheticHalo/node053',
    'pages/syntheticHalo/node054',
    'pages/syntheticHalo/node055',
    'pages/syntheticHalo/node056',
    'pages/syntheticHalo/node057',
    'pages/syntheticHalo/node058',
    'pages/syntheticHalo/node059',
    'pages/syntheticHalo/node060',
    'pages/syntheticHalo/node061',
    'pages/syntheticHalo/node062',
    'pages/syntheticHalo/node063',
    'pages/syntheticHalo/node064',
    'pages/syntheticHalo/node065',
    'pages/syntheticHalo/node066',
    'pages/syntheticHalo/node067',
    'pages/syntheticHalo/node068',
    'pages/syntheticHalo/node069',
    'pages/syntheticHalo/node070',
    'pages/syntheticHalo/node071',
    'pages/syntheticHalo/node072',
    'pages/syntheticHalo/node073',
    'pages/syntheticHalo/node074',
    'pages/syntheticHalo/node075',
    'pages/syntheticHalo/node076',
    'pages/syntheticHalo/node077',
    'pages/syntheticHalo/node078',
    'pages/syntheticHalo/node079',
    'pages/syntheticHalo/node080',
    'pages/syntheticHalo/node081',
    'pages/syntheticHalo/node082',
    'pages/syntheticHalo/node083',
    'pages/syntheticHalo/node084',
    'pages/syntheticHalo/node085',
    'pages/syntheticHalo/node086',
    'pages/syntheticHalo/node087',
    'pages/syntheticHalo/node088',
    'pages/syntheticHalo/node089',
    'pages/syntheticHalo/node090',
    'pages/syntheticHalo/node091',
    'pages/syntheticHalo/node092',
    'pages/syntheticHalo/node093',
    'pages/syntheticHalo/node094',
    'pages/syntheticHalo/node095',
    'pages/syntheticHalo/node096',
    'pages/syntheticHalo/node097',
    'pages/syntheticHalo/node098',
    'pages/syntheticHalo/node099',
    'pages/syntheticHalo/node100',
    'pages/syntheticHalo/node101',
    'pages/syntheticHalo/node102',
    'pages/syntheticHalo/node103',
    'pages/syntheticHalo/node104',
    'pages/syntheticHalo/node105',
    'pages/syntheticHalo/node106',
    'pages/syntheticHalo/node107',
    'pages/syntheticHalo/node108',
    'pages/syntheticHalo/node109',
    'pages/syntheticHalo/node110',
    'pages/syntheticHalo/node111',
    'pages/syntheticHalo/node112',
    'pages/syntheticHalo/node113',
    'pages/syntheticHalo/node114',
    'pages/syntheticHalo/node115',
    'pages/syntheticHalo/node116',
    'pages/syntheticHalo/node117',
    'pages/syntheticHalo/node118',
    'pages/syntheticHalo/node119',
    'pages/syntheticHalo/node120',
    'pages/syntheticHalo/node121',
    'pages/syntheticHalo/node122',
    'pages/syntheticHalo/node123',
    'pages/syntheticHalo/node124',
    'pages/syntheticHalo/node125',
    'pages/syntheticHalo/node126',
    'pages/syntheticHalo/node127',
    'pages/syntheticHalo/node128',
    'pages/syntheticHalo/node129',
    'pages/syntheticHalo/node130',
    'pages/syntheticHalo/node131',
    'pages/syntheticHalo/node132',
    'pages/syntheticHalo/node133',
    'pages/syntheticHalo/node134',
    'pages/syntheticHalo/node135',
    'pages/syntheticHalo/node136',
    'pages/syntheticHalo/node137',
    'pages/syntheticHalo/node138',
    'pages/syntheticHalo/node139',
    'pages/syntheticHalo/node140',
    'pages/syntheticHalo/node141',
    'pages/syntheticHalo/node142',
    'pages/syntheticHalo/node143',
    'pages/syntheticHalo/node144',
    'pages/syntheticHalo/node145',
    'pages/syntheticHalo/node146',
    'pages/syntheticHalo/node147',
    'pages/syntheticHalo/node148',
    'pages/syntheticHalo/node149',
    'pages/syntheticHalo/node150',
    'pages/syntheticHalo/node151',
    'pages/syntheticHalo/node152',
    'pages/syntheticHalo/node153',
    'pages/syntheticHalo/node154',
    'pages/syntheticHalo/node155',
    'pages/syntheticHalo/node156',
    'pages/syntheticHalo/node157',
    'pages/syntheticHalo/node158',
    'pages/syntheticHalo/node159',
    'pages/syntheticHalo/node160'
  ];

  describe('MegaSyntheticRouteAtlasHaloSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteHalo_[A-Za-z0-9_]+_[0-9]{3}$/;
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

