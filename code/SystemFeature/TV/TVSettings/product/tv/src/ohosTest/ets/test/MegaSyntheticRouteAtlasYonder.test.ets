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
  return /^pages\/syntheticYonder\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasYonderTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteYonder_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticYonder/node001',
    'pages/syntheticYonder/node002',
    'pages/syntheticYonder/node003',
    'pages/syntheticYonder/node004',
    'pages/syntheticYonder/node005',
    'pages/syntheticYonder/node006',
    'pages/syntheticYonder/node007',
    'pages/syntheticYonder/node008',
    'pages/syntheticYonder/node009',
    'pages/syntheticYonder/node010',
    'pages/syntheticYonder/node011',
    'pages/syntheticYonder/node012',
    'pages/syntheticYonder/node013',
    'pages/syntheticYonder/node014',
    'pages/syntheticYonder/node015',
    'pages/syntheticYonder/node016',
    'pages/syntheticYonder/node017',
    'pages/syntheticYonder/node018',
    'pages/syntheticYonder/node019',
    'pages/syntheticYonder/node020',
    'pages/syntheticYonder/node021',
    'pages/syntheticYonder/node022',
    'pages/syntheticYonder/node023',
    'pages/syntheticYonder/node024',
    'pages/syntheticYonder/node025',
    'pages/syntheticYonder/node026',
    'pages/syntheticYonder/node027',
    'pages/syntheticYonder/node028',
    'pages/syntheticYonder/node029',
    'pages/syntheticYonder/node030',
    'pages/syntheticYonder/node031',
    'pages/syntheticYonder/node032',
    'pages/syntheticYonder/node033',
    'pages/syntheticYonder/node034',
    'pages/syntheticYonder/node035',
    'pages/syntheticYonder/node036',
    'pages/syntheticYonder/node037',
    'pages/syntheticYonder/node038',
    'pages/syntheticYonder/node039',
    'pages/syntheticYonder/node040',
    'pages/syntheticYonder/node041',
    'pages/syntheticYonder/node042',
    'pages/syntheticYonder/node043',
    'pages/syntheticYonder/node044',
    'pages/syntheticYonder/node045',
    'pages/syntheticYonder/node046',
    'pages/syntheticYonder/node047',
    'pages/syntheticYonder/node048',
    'pages/syntheticYonder/node049',
    'pages/syntheticYonder/node050',
    'pages/syntheticYonder/node051',
    'pages/syntheticYonder/node052',
    'pages/syntheticYonder/node053',
    'pages/syntheticYonder/node054',
    'pages/syntheticYonder/node055',
    'pages/syntheticYonder/node056',
    'pages/syntheticYonder/node057',
    'pages/syntheticYonder/node058',
    'pages/syntheticYonder/node059',
    'pages/syntheticYonder/node060',
    'pages/syntheticYonder/node061',
    'pages/syntheticYonder/node062',
    'pages/syntheticYonder/node063',
    'pages/syntheticYonder/node064',
    'pages/syntheticYonder/node065',
    'pages/syntheticYonder/node066',
    'pages/syntheticYonder/node067',
    'pages/syntheticYonder/node068',
    'pages/syntheticYonder/node069',
    'pages/syntheticYonder/node070',
    'pages/syntheticYonder/node071',
    'pages/syntheticYonder/node072',
    'pages/syntheticYonder/node073',
    'pages/syntheticYonder/node074',
    'pages/syntheticYonder/node075',
    'pages/syntheticYonder/node076',
    'pages/syntheticYonder/node077',
    'pages/syntheticYonder/node078',
    'pages/syntheticYonder/node079',
    'pages/syntheticYonder/node080',
    'pages/syntheticYonder/node081',
    'pages/syntheticYonder/node082',
    'pages/syntheticYonder/node083',
    'pages/syntheticYonder/node084',
    'pages/syntheticYonder/node085',
    'pages/syntheticYonder/node086',
    'pages/syntheticYonder/node087',
    'pages/syntheticYonder/node088',
    'pages/syntheticYonder/node089',
    'pages/syntheticYonder/node090',
    'pages/syntheticYonder/node091',
    'pages/syntheticYonder/node092',
    'pages/syntheticYonder/node093',
    'pages/syntheticYonder/node094',
    'pages/syntheticYonder/node095',
    'pages/syntheticYonder/node096',
    'pages/syntheticYonder/node097',
    'pages/syntheticYonder/node098',
    'pages/syntheticYonder/node099',
    'pages/syntheticYonder/node100',
    'pages/syntheticYonder/node101',
    'pages/syntheticYonder/node102',
    'pages/syntheticYonder/node103',
    'pages/syntheticYonder/node104',
    'pages/syntheticYonder/node105',
    'pages/syntheticYonder/node106',
    'pages/syntheticYonder/node107',
    'pages/syntheticYonder/node108',
    'pages/syntheticYonder/node109',
    'pages/syntheticYonder/node110',
    'pages/syntheticYonder/node111',
    'pages/syntheticYonder/node112',
    'pages/syntheticYonder/node113',
    'pages/syntheticYonder/node114',
    'pages/syntheticYonder/node115',
    'pages/syntheticYonder/node116',
    'pages/syntheticYonder/node117',
    'pages/syntheticYonder/node118',
    'pages/syntheticYonder/node119',
    'pages/syntheticYonder/node120',
    'pages/syntheticYonder/node121',
    'pages/syntheticYonder/node122',
    'pages/syntheticYonder/node123',
    'pages/syntheticYonder/node124',
    'pages/syntheticYonder/node125',
    'pages/syntheticYonder/node126',
    'pages/syntheticYonder/node127',
    'pages/syntheticYonder/node128',
    'pages/syntheticYonder/node129',
    'pages/syntheticYonder/node130',
    'pages/syntheticYonder/node131',
    'pages/syntheticYonder/node132',
    'pages/syntheticYonder/node133',
    'pages/syntheticYonder/node134',
    'pages/syntheticYonder/node135',
    'pages/syntheticYonder/node136',
    'pages/syntheticYonder/node137',
    'pages/syntheticYonder/node138',
    'pages/syntheticYonder/node139',
    'pages/syntheticYonder/node140',
    'pages/syntheticYonder/node141',
    'pages/syntheticYonder/node142',
    'pages/syntheticYonder/node143',
    'pages/syntheticYonder/node144',
    'pages/syntheticYonder/node145',
    'pages/syntheticYonder/node146',
    'pages/syntheticYonder/node147',
    'pages/syntheticYonder/node148',
    'pages/syntheticYonder/node149',
    'pages/syntheticYonder/node150',
    'pages/syntheticYonder/node151',
    'pages/syntheticYonder/node152',
    'pages/syntheticYonder/node153',
    'pages/syntheticYonder/node154',
    'pages/syntheticYonder/node155',
    'pages/syntheticYonder/node156',
    'pages/syntheticYonder/node157',
    'pages/syntheticYonder/node158',
    'pages/syntheticYonder/node159',
    'pages/syntheticYonder/node160'
  ];

  describe('MegaSyntheticRouteAtlasYonderSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteYonder_[A-Za-z0-9_]+_[0-9]{3}$/;
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

