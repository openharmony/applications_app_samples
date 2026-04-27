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
  return /^pages\/syntheticAuric\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasAuricTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteAuric_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticAuric/node001',
    'pages/syntheticAuric/node002',
    'pages/syntheticAuric/node003',
    'pages/syntheticAuric/node004',
    'pages/syntheticAuric/node005',
    'pages/syntheticAuric/node006',
    'pages/syntheticAuric/node007',
    'pages/syntheticAuric/node008',
    'pages/syntheticAuric/node009',
    'pages/syntheticAuric/node010',
    'pages/syntheticAuric/node011',
    'pages/syntheticAuric/node012',
    'pages/syntheticAuric/node013',
    'pages/syntheticAuric/node014',
    'pages/syntheticAuric/node015',
    'pages/syntheticAuric/node016',
    'pages/syntheticAuric/node017',
    'pages/syntheticAuric/node018',
    'pages/syntheticAuric/node019',
    'pages/syntheticAuric/node020',
    'pages/syntheticAuric/node021',
    'pages/syntheticAuric/node022',
    'pages/syntheticAuric/node023',
    'pages/syntheticAuric/node024',
    'pages/syntheticAuric/node025',
    'pages/syntheticAuric/node026',
    'pages/syntheticAuric/node027',
    'pages/syntheticAuric/node028',
    'pages/syntheticAuric/node029',
    'pages/syntheticAuric/node030',
    'pages/syntheticAuric/node031',
    'pages/syntheticAuric/node032',
    'pages/syntheticAuric/node033',
    'pages/syntheticAuric/node034',
    'pages/syntheticAuric/node035',
    'pages/syntheticAuric/node036',
    'pages/syntheticAuric/node037',
    'pages/syntheticAuric/node038',
    'pages/syntheticAuric/node039',
    'pages/syntheticAuric/node040',
    'pages/syntheticAuric/node041',
    'pages/syntheticAuric/node042',
    'pages/syntheticAuric/node043',
    'pages/syntheticAuric/node044',
    'pages/syntheticAuric/node045',
    'pages/syntheticAuric/node046',
    'pages/syntheticAuric/node047',
    'pages/syntheticAuric/node048',
    'pages/syntheticAuric/node049',
    'pages/syntheticAuric/node050',
    'pages/syntheticAuric/node051',
    'pages/syntheticAuric/node052',
    'pages/syntheticAuric/node053',
    'pages/syntheticAuric/node054',
    'pages/syntheticAuric/node055',
    'pages/syntheticAuric/node056',
    'pages/syntheticAuric/node057',
    'pages/syntheticAuric/node058',
    'pages/syntheticAuric/node059',
    'pages/syntheticAuric/node060',
    'pages/syntheticAuric/node061',
    'pages/syntheticAuric/node062',
    'pages/syntheticAuric/node063',
    'pages/syntheticAuric/node064',
    'pages/syntheticAuric/node065',
    'pages/syntheticAuric/node066',
    'pages/syntheticAuric/node067',
    'pages/syntheticAuric/node068',
    'pages/syntheticAuric/node069',
    'pages/syntheticAuric/node070',
    'pages/syntheticAuric/node071',
    'pages/syntheticAuric/node072',
    'pages/syntheticAuric/node073',
    'pages/syntheticAuric/node074',
    'pages/syntheticAuric/node075',
    'pages/syntheticAuric/node076',
    'pages/syntheticAuric/node077',
    'pages/syntheticAuric/node078',
    'pages/syntheticAuric/node079',
    'pages/syntheticAuric/node080',
    'pages/syntheticAuric/node081',
    'pages/syntheticAuric/node082',
    'pages/syntheticAuric/node083',
    'pages/syntheticAuric/node084',
    'pages/syntheticAuric/node085',
    'pages/syntheticAuric/node086',
    'pages/syntheticAuric/node087',
    'pages/syntheticAuric/node088',
    'pages/syntheticAuric/node089',
    'pages/syntheticAuric/node090',
    'pages/syntheticAuric/node091',
    'pages/syntheticAuric/node092',
    'pages/syntheticAuric/node093',
    'pages/syntheticAuric/node094',
    'pages/syntheticAuric/node095',
    'pages/syntheticAuric/node096',
    'pages/syntheticAuric/node097',
    'pages/syntheticAuric/node098',
    'pages/syntheticAuric/node099',
    'pages/syntheticAuric/node100',
    'pages/syntheticAuric/node101',
    'pages/syntheticAuric/node102',
    'pages/syntheticAuric/node103',
    'pages/syntheticAuric/node104',
    'pages/syntheticAuric/node105',
    'pages/syntheticAuric/node106',
    'pages/syntheticAuric/node107',
    'pages/syntheticAuric/node108',
    'pages/syntheticAuric/node109',
    'pages/syntheticAuric/node110',
    'pages/syntheticAuric/node111',
    'pages/syntheticAuric/node112',
    'pages/syntheticAuric/node113',
    'pages/syntheticAuric/node114',
    'pages/syntheticAuric/node115',
    'pages/syntheticAuric/node116',
    'pages/syntheticAuric/node117',
    'pages/syntheticAuric/node118',
    'pages/syntheticAuric/node119',
    'pages/syntheticAuric/node120',
    'pages/syntheticAuric/node121',
    'pages/syntheticAuric/node122',
    'pages/syntheticAuric/node123',
    'pages/syntheticAuric/node124',
    'pages/syntheticAuric/node125',
    'pages/syntheticAuric/node126',
    'pages/syntheticAuric/node127',
    'pages/syntheticAuric/node128',
    'pages/syntheticAuric/node129',
    'pages/syntheticAuric/node130',
    'pages/syntheticAuric/node131',
    'pages/syntheticAuric/node132',
    'pages/syntheticAuric/node133',
    'pages/syntheticAuric/node134',
    'pages/syntheticAuric/node135',
    'pages/syntheticAuric/node136',
    'pages/syntheticAuric/node137',
    'pages/syntheticAuric/node138',
    'pages/syntheticAuric/node139',
    'pages/syntheticAuric/node140',
    'pages/syntheticAuric/node141',
    'pages/syntheticAuric/node142',
    'pages/syntheticAuric/node143',
    'pages/syntheticAuric/node144',
    'pages/syntheticAuric/node145',
    'pages/syntheticAuric/node146',
    'pages/syntheticAuric/node147',
    'pages/syntheticAuric/node148',
    'pages/syntheticAuric/node149',
    'pages/syntheticAuric/node150',
    'pages/syntheticAuric/node151',
    'pages/syntheticAuric/node152',
    'pages/syntheticAuric/node153',
    'pages/syntheticAuric/node154',
    'pages/syntheticAuric/node155',
    'pages/syntheticAuric/node156',
    'pages/syntheticAuric/node157',
    'pages/syntheticAuric/node158',
    'pages/syntheticAuric/node159',
    'pages/syntheticAuric/node160'
  ];

  describe('MegaSyntheticRouteAtlasAuricSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteAuric_[A-Za-z0-9_]+_[0-9]{3}$/;
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

