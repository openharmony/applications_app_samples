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
  return /^pages\/syntheticApex\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasApexTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteApex_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticApex/node001',
    'pages/syntheticApex/node002',
    'pages/syntheticApex/node003',
    'pages/syntheticApex/node004',
    'pages/syntheticApex/node005',
    'pages/syntheticApex/node006',
    'pages/syntheticApex/node007',
    'pages/syntheticApex/node008',
    'pages/syntheticApex/node009',
    'pages/syntheticApex/node010',
    'pages/syntheticApex/node011',
    'pages/syntheticApex/node012',
    'pages/syntheticApex/node013',
    'pages/syntheticApex/node014',
    'pages/syntheticApex/node015',
    'pages/syntheticApex/node016',
    'pages/syntheticApex/node017',
    'pages/syntheticApex/node018',
    'pages/syntheticApex/node019',
    'pages/syntheticApex/node020',
    'pages/syntheticApex/node021',
    'pages/syntheticApex/node022',
    'pages/syntheticApex/node023',
    'pages/syntheticApex/node024',
    'pages/syntheticApex/node025',
    'pages/syntheticApex/node026',
    'pages/syntheticApex/node027',
    'pages/syntheticApex/node028',
    'pages/syntheticApex/node029',
    'pages/syntheticApex/node030',
    'pages/syntheticApex/node031',
    'pages/syntheticApex/node032',
    'pages/syntheticApex/node033',
    'pages/syntheticApex/node034',
    'pages/syntheticApex/node035',
    'pages/syntheticApex/node036',
    'pages/syntheticApex/node037',
    'pages/syntheticApex/node038',
    'pages/syntheticApex/node039',
    'pages/syntheticApex/node040',
    'pages/syntheticApex/node041',
    'pages/syntheticApex/node042',
    'pages/syntheticApex/node043',
    'pages/syntheticApex/node044',
    'pages/syntheticApex/node045',
    'pages/syntheticApex/node046',
    'pages/syntheticApex/node047',
    'pages/syntheticApex/node048',
    'pages/syntheticApex/node049',
    'pages/syntheticApex/node050',
    'pages/syntheticApex/node051',
    'pages/syntheticApex/node052',
    'pages/syntheticApex/node053',
    'pages/syntheticApex/node054',
    'pages/syntheticApex/node055',
    'pages/syntheticApex/node056',
    'pages/syntheticApex/node057',
    'pages/syntheticApex/node058',
    'pages/syntheticApex/node059',
    'pages/syntheticApex/node060',
    'pages/syntheticApex/node061',
    'pages/syntheticApex/node062',
    'pages/syntheticApex/node063',
    'pages/syntheticApex/node064',
    'pages/syntheticApex/node065',
    'pages/syntheticApex/node066',
    'pages/syntheticApex/node067',
    'pages/syntheticApex/node068',
    'pages/syntheticApex/node069',
    'pages/syntheticApex/node070',
    'pages/syntheticApex/node071',
    'pages/syntheticApex/node072',
    'pages/syntheticApex/node073',
    'pages/syntheticApex/node074',
    'pages/syntheticApex/node075',
    'pages/syntheticApex/node076',
    'pages/syntheticApex/node077',
    'pages/syntheticApex/node078',
    'pages/syntheticApex/node079',
    'pages/syntheticApex/node080',
    'pages/syntheticApex/node081',
    'pages/syntheticApex/node082',
    'pages/syntheticApex/node083',
    'pages/syntheticApex/node084',
    'pages/syntheticApex/node085',
    'pages/syntheticApex/node086',
    'pages/syntheticApex/node087',
    'pages/syntheticApex/node088',
    'pages/syntheticApex/node089',
    'pages/syntheticApex/node090',
    'pages/syntheticApex/node091',
    'pages/syntheticApex/node092',
    'pages/syntheticApex/node093',
    'pages/syntheticApex/node094',
    'pages/syntheticApex/node095',
    'pages/syntheticApex/node096',
    'pages/syntheticApex/node097',
    'pages/syntheticApex/node098',
    'pages/syntheticApex/node099',
    'pages/syntheticApex/node100',
    'pages/syntheticApex/node101',
    'pages/syntheticApex/node102',
    'pages/syntheticApex/node103',
    'pages/syntheticApex/node104',
    'pages/syntheticApex/node105',
    'pages/syntheticApex/node106',
    'pages/syntheticApex/node107',
    'pages/syntheticApex/node108',
    'pages/syntheticApex/node109',
    'pages/syntheticApex/node110',
    'pages/syntheticApex/node111',
    'pages/syntheticApex/node112',
    'pages/syntheticApex/node113',
    'pages/syntheticApex/node114',
    'pages/syntheticApex/node115',
    'pages/syntheticApex/node116',
    'pages/syntheticApex/node117',
    'pages/syntheticApex/node118',
    'pages/syntheticApex/node119',
    'pages/syntheticApex/node120',
    'pages/syntheticApex/node121',
    'pages/syntheticApex/node122',
    'pages/syntheticApex/node123',
    'pages/syntheticApex/node124',
    'pages/syntheticApex/node125',
    'pages/syntheticApex/node126',
    'pages/syntheticApex/node127',
    'pages/syntheticApex/node128',
    'pages/syntheticApex/node129',
    'pages/syntheticApex/node130',
    'pages/syntheticApex/node131',
    'pages/syntheticApex/node132',
    'pages/syntheticApex/node133',
    'pages/syntheticApex/node134',
    'pages/syntheticApex/node135',
    'pages/syntheticApex/node136',
    'pages/syntheticApex/node137',
    'pages/syntheticApex/node138',
    'pages/syntheticApex/node139',
    'pages/syntheticApex/node140',
    'pages/syntheticApex/node141',
    'pages/syntheticApex/node142',
    'pages/syntheticApex/node143',
    'pages/syntheticApex/node144',
    'pages/syntheticApex/node145',
    'pages/syntheticApex/node146',
    'pages/syntheticApex/node147',
    'pages/syntheticApex/node148',
    'pages/syntheticApex/node149',
    'pages/syntheticApex/node150',
    'pages/syntheticApex/node151',
    'pages/syntheticApex/node152',
    'pages/syntheticApex/node153',
    'pages/syntheticApex/node154',
    'pages/syntheticApex/node155',
    'pages/syntheticApex/node156',
    'pages/syntheticApex/node157',
    'pages/syntheticApex/node158',
    'pages/syntheticApex/node159',
    'pages/syntheticApex/node160'
  ];

  describe('MegaSyntheticRouteAtlasApexSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteApex_[A-Za-z0-9_]+_[0-9]{3}$/;
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

