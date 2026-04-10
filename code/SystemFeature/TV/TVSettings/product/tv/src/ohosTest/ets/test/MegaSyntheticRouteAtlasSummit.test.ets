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
  return /^pages\/syntheticSummit\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasSummitTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteSummit_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticSummit/node001',
    'pages/syntheticSummit/node002',
    'pages/syntheticSummit/node003',
    'pages/syntheticSummit/node004',
    'pages/syntheticSummit/node005',
    'pages/syntheticSummit/node006',
    'pages/syntheticSummit/node007',
    'pages/syntheticSummit/node008',
    'pages/syntheticSummit/node009',
    'pages/syntheticSummit/node010',
    'pages/syntheticSummit/node011',
    'pages/syntheticSummit/node012',
    'pages/syntheticSummit/node013',
    'pages/syntheticSummit/node014',
    'pages/syntheticSummit/node015',
    'pages/syntheticSummit/node016',
    'pages/syntheticSummit/node017',
    'pages/syntheticSummit/node018',
    'pages/syntheticSummit/node019',
    'pages/syntheticSummit/node020',
    'pages/syntheticSummit/node021',
    'pages/syntheticSummit/node022',
    'pages/syntheticSummit/node023',
    'pages/syntheticSummit/node024',
    'pages/syntheticSummit/node025',
    'pages/syntheticSummit/node026',
    'pages/syntheticSummit/node027',
    'pages/syntheticSummit/node028',
    'pages/syntheticSummit/node029',
    'pages/syntheticSummit/node030',
    'pages/syntheticSummit/node031',
    'pages/syntheticSummit/node032',
    'pages/syntheticSummit/node033',
    'pages/syntheticSummit/node034',
    'pages/syntheticSummit/node035',
    'pages/syntheticSummit/node036',
    'pages/syntheticSummit/node037',
    'pages/syntheticSummit/node038',
    'pages/syntheticSummit/node039',
    'pages/syntheticSummit/node040',
    'pages/syntheticSummit/node041',
    'pages/syntheticSummit/node042',
    'pages/syntheticSummit/node043',
    'pages/syntheticSummit/node044',
    'pages/syntheticSummit/node045',
    'pages/syntheticSummit/node046',
    'pages/syntheticSummit/node047',
    'pages/syntheticSummit/node048',
    'pages/syntheticSummit/node049',
    'pages/syntheticSummit/node050',
    'pages/syntheticSummit/node051',
    'pages/syntheticSummit/node052',
    'pages/syntheticSummit/node053',
    'pages/syntheticSummit/node054',
    'pages/syntheticSummit/node055',
    'pages/syntheticSummit/node056',
    'pages/syntheticSummit/node057',
    'pages/syntheticSummit/node058',
    'pages/syntheticSummit/node059',
    'pages/syntheticSummit/node060',
    'pages/syntheticSummit/node061',
    'pages/syntheticSummit/node062',
    'pages/syntheticSummit/node063',
    'pages/syntheticSummit/node064',
    'pages/syntheticSummit/node065',
    'pages/syntheticSummit/node066',
    'pages/syntheticSummit/node067',
    'pages/syntheticSummit/node068',
    'pages/syntheticSummit/node069',
    'pages/syntheticSummit/node070',
    'pages/syntheticSummit/node071',
    'pages/syntheticSummit/node072',
    'pages/syntheticSummit/node073',
    'pages/syntheticSummit/node074',
    'pages/syntheticSummit/node075',
    'pages/syntheticSummit/node076',
    'pages/syntheticSummit/node077',
    'pages/syntheticSummit/node078',
    'pages/syntheticSummit/node079',
    'pages/syntheticSummit/node080',
    'pages/syntheticSummit/node081',
    'pages/syntheticSummit/node082',
    'pages/syntheticSummit/node083',
    'pages/syntheticSummit/node084',
    'pages/syntheticSummit/node085',
    'pages/syntheticSummit/node086',
    'pages/syntheticSummit/node087',
    'pages/syntheticSummit/node088',
    'pages/syntheticSummit/node089',
    'pages/syntheticSummit/node090',
    'pages/syntheticSummit/node091',
    'pages/syntheticSummit/node092',
    'pages/syntheticSummit/node093',
    'pages/syntheticSummit/node094',
    'pages/syntheticSummit/node095',
    'pages/syntheticSummit/node096',
    'pages/syntheticSummit/node097',
    'pages/syntheticSummit/node098',
    'pages/syntheticSummit/node099',
    'pages/syntheticSummit/node100',
    'pages/syntheticSummit/node101',
    'pages/syntheticSummit/node102',
    'pages/syntheticSummit/node103',
    'pages/syntheticSummit/node104',
    'pages/syntheticSummit/node105',
    'pages/syntheticSummit/node106',
    'pages/syntheticSummit/node107',
    'pages/syntheticSummit/node108',
    'pages/syntheticSummit/node109',
    'pages/syntheticSummit/node110',
    'pages/syntheticSummit/node111',
    'pages/syntheticSummit/node112',
    'pages/syntheticSummit/node113',
    'pages/syntheticSummit/node114',
    'pages/syntheticSummit/node115',
    'pages/syntheticSummit/node116',
    'pages/syntheticSummit/node117',
    'pages/syntheticSummit/node118',
    'pages/syntheticSummit/node119',
    'pages/syntheticSummit/node120',
    'pages/syntheticSummit/node121',
    'pages/syntheticSummit/node122',
    'pages/syntheticSummit/node123',
    'pages/syntheticSummit/node124',
    'pages/syntheticSummit/node125',
    'pages/syntheticSummit/node126',
    'pages/syntheticSummit/node127',
    'pages/syntheticSummit/node128',
    'pages/syntheticSummit/node129',
    'pages/syntheticSummit/node130',
    'pages/syntheticSummit/node131',
    'pages/syntheticSummit/node132',
    'pages/syntheticSummit/node133',
    'pages/syntheticSummit/node134',
    'pages/syntheticSummit/node135',
    'pages/syntheticSummit/node136',
    'pages/syntheticSummit/node137',
    'pages/syntheticSummit/node138',
    'pages/syntheticSummit/node139',
    'pages/syntheticSummit/node140',
    'pages/syntheticSummit/node141',
    'pages/syntheticSummit/node142',
    'pages/syntheticSummit/node143',
    'pages/syntheticSummit/node144',
    'pages/syntheticSummit/node145',
    'pages/syntheticSummit/node146',
    'pages/syntheticSummit/node147',
    'pages/syntheticSummit/node148',
    'pages/syntheticSummit/node149',
    'pages/syntheticSummit/node150',
    'pages/syntheticSummit/node151',
    'pages/syntheticSummit/node152',
    'pages/syntheticSummit/node153',
    'pages/syntheticSummit/node154',
    'pages/syntheticSummit/node155',
    'pages/syntheticSummit/node156',
    'pages/syntheticSummit/node157',
    'pages/syntheticSummit/node158',
    'pages/syntheticSummit/node159',
    'pages/syntheticSummit/node160'
  ];

  describe('MegaSyntheticRouteAtlasSummitSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteSummit_[A-Za-z0-9_]+_[0-9]{3}$/;
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

