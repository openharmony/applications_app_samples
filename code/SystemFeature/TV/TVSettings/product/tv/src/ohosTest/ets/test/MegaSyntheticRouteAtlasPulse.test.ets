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
  return /^pages\/syntheticPulse\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasPulseTest() {
  const casePrefix = 'Settings_MegaSyntheticRoutePulse_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticPulse/node001',
    'pages/syntheticPulse/node002',
    'pages/syntheticPulse/node003',
    'pages/syntheticPulse/node004',
    'pages/syntheticPulse/node005',
    'pages/syntheticPulse/node006',
    'pages/syntheticPulse/node007',
    'pages/syntheticPulse/node008',
    'pages/syntheticPulse/node009',
    'pages/syntheticPulse/node010',
    'pages/syntheticPulse/node011',
    'pages/syntheticPulse/node012',
    'pages/syntheticPulse/node013',
    'pages/syntheticPulse/node014',
    'pages/syntheticPulse/node015',
    'pages/syntheticPulse/node016',
    'pages/syntheticPulse/node017',
    'pages/syntheticPulse/node018',
    'pages/syntheticPulse/node019',
    'pages/syntheticPulse/node020',
    'pages/syntheticPulse/node021',
    'pages/syntheticPulse/node022',
    'pages/syntheticPulse/node023',
    'pages/syntheticPulse/node024',
    'pages/syntheticPulse/node025',
    'pages/syntheticPulse/node026',
    'pages/syntheticPulse/node027',
    'pages/syntheticPulse/node028',
    'pages/syntheticPulse/node029',
    'pages/syntheticPulse/node030',
    'pages/syntheticPulse/node031',
    'pages/syntheticPulse/node032',
    'pages/syntheticPulse/node033',
    'pages/syntheticPulse/node034',
    'pages/syntheticPulse/node035',
    'pages/syntheticPulse/node036',
    'pages/syntheticPulse/node037',
    'pages/syntheticPulse/node038',
    'pages/syntheticPulse/node039',
    'pages/syntheticPulse/node040',
    'pages/syntheticPulse/node041',
    'pages/syntheticPulse/node042',
    'pages/syntheticPulse/node043',
    'pages/syntheticPulse/node044',
    'pages/syntheticPulse/node045',
    'pages/syntheticPulse/node046',
    'pages/syntheticPulse/node047',
    'pages/syntheticPulse/node048',
    'pages/syntheticPulse/node049',
    'pages/syntheticPulse/node050',
    'pages/syntheticPulse/node051',
    'pages/syntheticPulse/node052',
    'pages/syntheticPulse/node053',
    'pages/syntheticPulse/node054',
    'pages/syntheticPulse/node055',
    'pages/syntheticPulse/node056',
    'pages/syntheticPulse/node057',
    'pages/syntheticPulse/node058',
    'pages/syntheticPulse/node059',
    'pages/syntheticPulse/node060',
    'pages/syntheticPulse/node061',
    'pages/syntheticPulse/node062',
    'pages/syntheticPulse/node063',
    'pages/syntheticPulse/node064',
    'pages/syntheticPulse/node065',
    'pages/syntheticPulse/node066',
    'pages/syntheticPulse/node067',
    'pages/syntheticPulse/node068',
    'pages/syntheticPulse/node069',
    'pages/syntheticPulse/node070',
    'pages/syntheticPulse/node071',
    'pages/syntheticPulse/node072',
    'pages/syntheticPulse/node073',
    'pages/syntheticPulse/node074',
    'pages/syntheticPulse/node075',
    'pages/syntheticPulse/node076',
    'pages/syntheticPulse/node077',
    'pages/syntheticPulse/node078',
    'pages/syntheticPulse/node079',
    'pages/syntheticPulse/node080',
    'pages/syntheticPulse/node081',
    'pages/syntheticPulse/node082',
    'pages/syntheticPulse/node083',
    'pages/syntheticPulse/node084',
    'pages/syntheticPulse/node085',
    'pages/syntheticPulse/node086',
    'pages/syntheticPulse/node087',
    'pages/syntheticPulse/node088',
    'pages/syntheticPulse/node089',
    'pages/syntheticPulse/node090',
    'pages/syntheticPulse/node091',
    'pages/syntheticPulse/node092',
    'pages/syntheticPulse/node093',
    'pages/syntheticPulse/node094',
    'pages/syntheticPulse/node095',
    'pages/syntheticPulse/node096',
    'pages/syntheticPulse/node097',
    'pages/syntheticPulse/node098',
    'pages/syntheticPulse/node099',
    'pages/syntheticPulse/node100',
    'pages/syntheticPulse/node101',
    'pages/syntheticPulse/node102',
    'pages/syntheticPulse/node103',
    'pages/syntheticPulse/node104',
    'pages/syntheticPulse/node105',
    'pages/syntheticPulse/node106',
    'pages/syntheticPulse/node107',
    'pages/syntheticPulse/node108',
    'pages/syntheticPulse/node109',
    'pages/syntheticPulse/node110',
    'pages/syntheticPulse/node111',
    'pages/syntheticPulse/node112',
    'pages/syntheticPulse/node113',
    'pages/syntheticPulse/node114',
    'pages/syntheticPulse/node115',
    'pages/syntheticPulse/node116',
    'pages/syntheticPulse/node117',
    'pages/syntheticPulse/node118',
    'pages/syntheticPulse/node119',
    'pages/syntheticPulse/node120',
    'pages/syntheticPulse/node121',
    'pages/syntheticPulse/node122',
    'pages/syntheticPulse/node123',
    'pages/syntheticPulse/node124',
    'pages/syntheticPulse/node125',
    'pages/syntheticPulse/node126',
    'pages/syntheticPulse/node127',
    'pages/syntheticPulse/node128',
    'pages/syntheticPulse/node129',
    'pages/syntheticPulse/node130',
    'pages/syntheticPulse/node131',
    'pages/syntheticPulse/node132',
    'pages/syntheticPulse/node133',
    'pages/syntheticPulse/node134',
    'pages/syntheticPulse/node135',
    'pages/syntheticPulse/node136',
    'pages/syntheticPulse/node137',
    'pages/syntheticPulse/node138',
    'pages/syntheticPulse/node139',
    'pages/syntheticPulse/node140',
    'pages/syntheticPulse/node141',
    'pages/syntheticPulse/node142',
    'pages/syntheticPulse/node143',
    'pages/syntheticPulse/node144',
    'pages/syntheticPulse/node145',
    'pages/syntheticPulse/node146',
    'pages/syntheticPulse/node147',
    'pages/syntheticPulse/node148',
    'pages/syntheticPulse/node149',
    'pages/syntheticPulse/node150',
    'pages/syntheticPulse/node151',
    'pages/syntheticPulse/node152',
    'pages/syntheticPulse/node153',
    'pages/syntheticPulse/node154',
    'pages/syntheticPulse/node155',
    'pages/syntheticPulse/node156',
    'pages/syntheticPulse/node157',
    'pages/syntheticPulse/node158',
    'pages/syntheticPulse/node159',
    'pages/syntheticPulse/node160'
  ];

  describe('MegaSyntheticRouteAtlasPulseSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRoutePulse_[A-Za-z0-9_]+_[0-9]{3}$/;
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

