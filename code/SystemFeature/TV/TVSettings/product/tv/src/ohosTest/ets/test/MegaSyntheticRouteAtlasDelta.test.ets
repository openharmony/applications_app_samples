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
  return /^pages\/syntheticDelta\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasDeltaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteDelta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticDelta/node001',
    'pages/syntheticDelta/node002',
    'pages/syntheticDelta/node003',
    'pages/syntheticDelta/node004',
    'pages/syntheticDelta/node005',
    'pages/syntheticDelta/node006',
    'pages/syntheticDelta/node007',
    'pages/syntheticDelta/node008',
    'pages/syntheticDelta/node009',
    'pages/syntheticDelta/node010',
    'pages/syntheticDelta/node011',
    'pages/syntheticDelta/node012',
    'pages/syntheticDelta/node013',
    'pages/syntheticDelta/node014',
    'pages/syntheticDelta/node015',
    'pages/syntheticDelta/node016',
    'pages/syntheticDelta/node017',
    'pages/syntheticDelta/node018',
    'pages/syntheticDelta/node019',
    'pages/syntheticDelta/node020',
    'pages/syntheticDelta/node021',
    'pages/syntheticDelta/node022',
    'pages/syntheticDelta/node023',
    'pages/syntheticDelta/node024',
    'pages/syntheticDelta/node025',
    'pages/syntheticDelta/node026',
    'pages/syntheticDelta/node027',
    'pages/syntheticDelta/node028',
    'pages/syntheticDelta/node029',
    'pages/syntheticDelta/node030',
    'pages/syntheticDelta/node031',
    'pages/syntheticDelta/node032',
    'pages/syntheticDelta/node033',
    'pages/syntheticDelta/node034',
    'pages/syntheticDelta/node035',
    'pages/syntheticDelta/node036',
    'pages/syntheticDelta/node037',
    'pages/syntheticDelta/node038',
    'pages/syntheticDelta/node039',
    'pages/syntheticDelta/node040',
    'pages/syntheticDelta/node041',
    'pages/syntheticDelta/node042',
    'pages/syntheticDelta/node043',
    'pages/syntheticDelta/node044',
    'pages/syntheticDelta/node045',
    'pages/syntheticDelta/node046',
    'pages/syntheticDelta/node047',
    'pages/syntheticDelta/node048',
    'pages/syntheticDelta/node049',
    'pages/syntheticDelta/node050',
    'pages/syntheticDelta/node051',
    'pages/syntheticDelta/node052',
    'pages/syntheticDelta/node053',
    'pages/syntheticDelta/node054',
    'pages/syntheticDelta/node055',
    'pages/syntheticDelta/node056',
    'pages/syntheticDelta/node057',
    'pages/syntheticDelta/node058',
    'pages/syntheticDelta/node059',
    'pages/syntheticDelta/node060',
    'pages/syntheticDelta/node061',
    'pages/syntheticDelta/node062',
    'pages/syntheticDelta/node063',
    'pages/syntheticDelta/node064',
    'pages/syntheticDelta/node065',
    'pages/syntheticDelta/node066',
    'pages/syntheticDelta/node067',
    'pages/syntheticDelta/node068',
    'pages/syntheticDelta/node069',
    'pages/syntheticDelta/node070',
    'pages/syntheticDelta/node071',
    'pages/syntheticDelta/node072',
    'pages/syntheticDelta/node073',
    'pages/syntheticDelta/node074',
    'pages/syntheticDelta/node075',
    'pages/syntheticDelta/node076',
    'pages/syntheticDelta/node077',
    'pages/syntheticDelta/node078',
    'pages/syntheticDelta/node079',
    'pages/syntheticDelta/node080',
    'pages/syntheticDelta/node081',
    'pages/syntheticDelta/node082',
    'pages/syntheticDelta/node083',
    'pages/syntheticDelta/node084',
    'pages/syntheticDelta/node085',
    'pages/syntheticDelta/node086',
    'pages/syntheticDelta/node087',
    'pages/syntheticDelta/node088',
    'pages/syntheticDelta/node089',
    'pages/syntheticDelta/node090',
    'pages/syntheticDelta/node091',
    'pages/syntheticDelta/node092',
    'pages/syntheticDelta/node093',
    'pages/syntheticDelta/node094',
    'pages/syntheticDelta/node095',
    'pages/syntheticDelta/node096',
    'pages/syntheticDelta/node097',
    'pages/syntheticDelta/node098',
    'pages/syntheticDelta/node099',
    'pages/syntheticDelta/node100',
    'pages/syntheticDelta/node101',
    'pages/syntheticDelta/node102',
    'pages/syntheticDelta/node103',
    'pages/syntheticDelta/node104',
    'pages/syntheticDelta/node105',
    'pages/syntheticDelta/node106',
    'pages/syntheticDelta/node107',
    'pages/syntheticDelta/node108',
    'pages/syntheticDelta/node109',
    'pages/syntheticDelta/node110',
    'pages/syntheticDelta/node111',
    'pages/syntheticDelta/node112',
    'pages/syntheticDelta/node113',
    'pages/syntheticDelta/node114',
    'pages/syntheticDelta/node115',
    'pages/syntheticDelta/node116',
    'pages/syntheticDelta/node117',
    'pages/syntheticDelta/node118',
    'pages/syntheticDelta/node119',
    'pages/syntheticDelta/node120',
    'pages/syntheticDelta/node121',
    'pages/syntheticDelta/node122',
    'pages/syntheticDelta/node123',
    'pages/syntheticDelta/node124',
    'pages/syntheticDelta/node125',
    'pages/syntheticDelta/node126',
    'pages/syntheticDelta/node127',
    'pages/syntheticDelta/node128',
    'pages/syntheticDelta/node129',
    'pages/syntheticDelta/node130',
    'pages/syntheticDelta/node131',
    'pages/syntheticDelta/node132',
    'pages/syntheticDelta/node133',
    'pages/syntheticDelta/node134',
    'pages/syntheticDelta/node135',
    'pages/syntheticDelta/node136',
    'pages/syntheticDelta/node137',
    'pages/syntheticDelta/node138',
    'pages/syntheticDelta/node139',
    'pages/syntheticDelta/node140',
    'pages/syntheticDelta/node141',
    'pages/syntheticDelta/node142',
    'pages/syntheticDelta/node143',
    'pages/syntheticDelta/node144',
    'pages/syntheticDelta/node145',
    'pages/syntheticDelta/node146',
    'pages/syntheticDelta/node147',
    'pages/syntheticDelta/node148',
    'pages/syntheticDelta/node149',
    'pages/syntheticDelta/node150',
    'pages/syntheticDelta/node151',
    'pages/syntheticDelta/node152',
    'pages/syntheticDelta/node153',
    'pages/syntheticDelta/node154',
    'pages/syntheticDelta/node155',
    'pages/syntheticDelta/node156',
    'pages/syntheticDelta/node157',
    'pages/syntheticDelta/node158',
    'pages/syntheticDelta/node159',
    'pages/syntheticDelta/node160'
  ];

  describe('MegaSyntheticRouteAtlasDeltaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteDelta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

