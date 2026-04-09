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
  return /^pages\/syntheticXenon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasXenonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteXenon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticXenon/node001',
    'pages/syntheticXenon/node002',
    'pages/syntheticXenon/node003',
    'pages/syntheticXenon/node004',
    'pages/syntheticXenon/node005',
    'pages/syntheticXenon/node006',
    'pages/syntheticXenon/node007',
    'pages/syntheticXenon/node008',
    'pages/syntheticXenon/node009',
    'pages/syntheticXenon/node010',
    'pages/syntheticXenon/node011',
    'pages/syntheticXenon/node012',
    'pages/syntheticXenon/node013',
    'pages/syntheticXenon/node014',
    'pages/syntheticXenon/node015',
    'pages/syntheticXenon/node016',
    'pages/syntheticXenon/node017',
    'pages/syntheticXenon/node018',
    'pages/syntheticXenon/node019',
    'pages/syntheticXenon/node020',
    'pages/syntheticXenon/node021',
    'pages/syntheticXenon/node022',
    'pages/syntheticXenon/node023',
    'pages/syntheticXenon/node024',
    'pages/syntheticXenon/node025',
    'pages/syntheticXenon/node026',
    'pages/syntheticXenon/node027',
    'pages/syntheticXenon/node028',
    'pages/syntheticXenon/node029',
    'pages/syntheticXenon/node030',
    'pages/syntheticXenon/node031',
    'pages/syntheticXenon/node032',
    'pages/syntheticXenon/node033',
    'pages/syntheticXenon/node034',
    'pages/syntheticXenon/node035',
    'pages/syntheticXenon/node036',
    'pages/syntheticXenon/node037',
    'pages/syntheticXenon/node038',
    'pages/syntheticXenon/node039',
    'pages/syntheticXenon/node040',
    'pages/syntheticXenon/node041',
    'pages/syntheticXenon/node042',
    'pages/syntheticXenon/node043',
    'pages/syntheticXenon/node044',
    'pages/syntheticXenon/node045',
    'pages/syntheticXenon/node046',
    'pages/syntheticXenon/node047',
    'pages/syntheticXenon/node048',
    'pages/syntheticXenon/node049',
    'pages/syntheticXenon/node050',
    'pages/syntheticXenon/node051',
    'pages/syntheticXenon/node052',
    'pages/syntheticXenon/node053',
    'pages/syntheticXenon/node054',
    'pages/syntheticXenon/node055',
    'pages/syntheticXenon/node056',
    'pages/syntheticXenon/node057',
    'pages/syntheticXenon/node058',
    'pages/syntheticXenon/node059',
    'pages/syntheticXenon/node060',
    'pages/syntheticXenon/node061',
    'pages/syntheticXenon/node062',
    'pages/syntheticXenon/node063',
    'pages/syntheticXenon/node064',
    'pages/syntheticXenon/node065',
    'pages/syntheticXenon/node066',
    'pages/syntheticXenon/node067',
    'pages/syntheticXenon/node068',
    'pages/syntheticXenon/node069',
    'pages/syntheticXenon/node070',
    'pages/syntheticXenon/node071',
    'pages/syntheticXenon/node072',
    'pages/syntheticXenon/node073',
    'pages/syntheticXenon/node074',
    'pages/syntheticXenon/node075',
    'pages/syntheticXenon/node076',
    'pages/syntheticXenon/node077',
    'pages/syntheticXenon/node078',
    'pages/syntheticXenon/node079',
    'pages/syntheticXenon/node080',
    'pages/syntheticXenon/node081',
    'pages/syntheticXenon/node082',
    'pages/syntheticXenon/node083',
    'pages/syntheticXenon/node084',
    'pages/syntheticXenon/node085',
    'pages/syntheticXenon/node086',
    'pages/syntheticXenon/node087',
    'pages/syntheticXenon/node088',
    'pages/syntheticXenon/node089',
    'pages/syntheticXenon/node090',
    'pages/syntheticXenon/node091',
    'pages/syntheticXenon/node092',
    'pages/syntheticXenon/node093',
    'pages/syntheticXenon/node094',
    'pages/syntheticXenon/node095',
    'pages/syntheticXenon/node096',
    'pages/syntheticXenon/node097',
    'pages/syntheticXenon/node098',
    'pages/syntheticXenon/node099',
    'pages/syntheticXenon/node100',
    'pages/syntheticXenon/node101',
    'pages/syntheticXenon/node102',
    'pages/syntheticXenon/node103',
    'pages/syntheticXenon/node104',
    'pages/syntheticXenon/node105',
    'pages/syntheticXenon/node106',
    'pages/syntheticXenon/node107',
    'pages/syntheticXenon/node108',
    'pages/syntheticXenon/node109',
    'pages/syntheticXenon/node110',
    'pages/syntheticXenon/node111',
    'pages/syntheticXenon/node112',
    'pages/syntheticXenon/node113',
    'pages/syntheticXenon/node114',
    'pages/syntheticXenon/node115',
    'pages/syntheticXenon/node116',
    'pages/syntheticXenon/node117',
    'pages/syntheticXenon/node118',
    'pages/syntheticXenon/node119',
    'pages/syntheticXenon/node120',
    'pages/syntheticXenon/node121',
    'pages/syntheticXenon/node122',
    'pages/syntheticXenon/node123',
    'pages/syntheticXenon/node124',
    'pages/syntheticXenon/node125',
    'pages/syntheticXenon/node126',
    'pages/syntheticXenon/node127',
    'pages/syntheticXenon/node128',
    'pages/syntheticXenon/node129',
    'pages/syntheticXenon/node130',
    'pages/syntheticXenon/node131',
    'pages/syntheticXenon/node132',
    'pages/syntheticXenon/node133',
    'pages/syntheticXenon/node134',
    'pages/syntheticXenon/node135',
    'pages/syntheticXenon/node136',
    'pages/syntheticXenon/node137',
    'pages/syntheticXenon/node138',
    'pages/syntheticXenon/node139',
    'pages/syntheticXenon/node140',
    'pages/syntheticXenon/node141',
    'pages/syntheticXenon/node142',
    'pages/syntheticXenon/node143',
    'pages/syntheticXenon/node144',
    'pages/syntheticXenon/node145',
    'pages/syntheticXenon/node146',
    'pages/syntheticXenon/node147',
    'pages/syntheticXenon/node148',
    'pages/syntheticXenon/node149',
    'pages/syntheticXenon/node150',
    'pages/syntheticXenon/node151',
    'pages/syntheticXenon/node152',
    'pages/syntheticXenon/node153',
    'pages/syntheticXenon/node154',
    'pages/syntheticXenon/node155',
    'pages/syntheticXenon/node156',
    'pages/syntheticXenon/node157',
    'pages/syntheticXenon/node158',
    'pages/syntheticXenon/node159',
    'pages/syntheticXenon/node160'
  ];

  describe('MegaSyntheticRouteAtlasXenonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteXenon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

