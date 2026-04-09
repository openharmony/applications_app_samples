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
  return /^pages\/syntheticLagoon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasLagoonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteLagoon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticLagoon/node001',
    'pages/syntheticLagoon/node002',
    'pages/syntheticLagoon/node003',
    'pages/syntheticLagoon/node004',
    'pages/syntheticLagoon/node005',
    'pages/syntheticLagoon/node006',
    'pages/syntheticLagoon/node007',
    'pages/syntheticLagoon/node008',
    'pages/syntheticLagoon/node009',
    'pages/syntheticLagoon/node010',
    'pages/syntheticLagoon/node011',
    'pages/syntheticLagoon/node012',
    'pages/syntheticLagoon/node013',
    'pages/syntheticLagoon/node014',
    'pages/syntheticLagoon/node015',
    'pages/syntheticLagoon/node016',
    'pages/syntheticLagoon/node017',
    'pages/syntheticLagoon/node018',
    'pages/syntheticLagoon/node019',
    'pages/syntheticLagoon/node020',
    'pages/syntheticLagoon/node021',
    'pages/syntheticLagoon/node022',
    'pages/syntheticLagoon/node023',
    'pages/syntheticLagoon/node024',
    'pages/syntheticLagoon/node025',
    'pages/syntheticLagoon/node026',
    'pages/syntheticLagoon/node027',
    'pages/syntheticLagoon/node028',
    'pages/syntheticLagoon/node029',
    'pages/syntheticLagoon/node030',
    'pages/syntheticLagoon/node031',
    'pages/syntheticLagoon/node032',
    'pages/syntheticLagoon/node033',
    'pages/syntheticLagoon/node034',
    'pages/syntheticLagoon/node035',
    'pages/syntheticLagoon/node036',
    'pages/syntheticLagoon/node037',
    'pages/syntheticLagoon/node038',
    'pages/syntheticLagoon/node039',
    'pages/syntheticLagoon/node040',
    'pages/syntheticLagoon/node041',
    'pages/syntheticLagoon/node042',
    'pages/syntheticLagoon/node043',
    'pages/syntheticLagoon/node044',
    'pages/syntheticLagoon/node045',
    'pages/syntheticLagoon/node046',
    'pages/syntheticLagoon/node047',
    'pages/syntheticLagoon/node048',
    'pages/syntheticLagoon/node049',
    'pages/syntheticLagoon/node050',
    'pages/syntheticLagoon/node051',
    'pages/syntheticLagoon/node052',
    'pages/syntheticLagoon/node053',
    'pages/syntheticLagoon/node054',
    'pages/syntheticLagoon/node055',
    'pages/syntheticLagoon/node056',
    'pages/syntheticLagoon/node057',
    'pages/syntheticLagoon/node058',
    'pages/syntheticLagoon/node059',
    'pages/syntheticLagoon/node060',
    'pages/syntheticLagoon/node061',
    'pages/syntheticLagoon/node062',
    'pages/syntheticLagoon/node063',
    'pages/syntheticLagoon/node064',
    'pages/syntheticLagoon/node065',
    'pages/syntheticLagoon/node066',
    'pages/syntheticLagoon/node067',
    'pages/syntheticLagoon/node068',
    'pages/syntheticLagoon/node069',
    'pages/syntheticLagoon/node070',
    'pages/syntheticLagoon/node071',
    'pages/syntheticLagoon/node072',
    'pages/syntheticLagoon/node073',
    'pages/syntheticLagoon/node074',
    'pages/syntheticLagoon/node075',
    'pages/syntheticLagoon/node076',
    'pages/syntheticLagoon/node077',
    'pages/syntheticLagoon/node078',
    'pages/syntheticLagoon/node079',
    'pages/syntheticLagoon/node080',
    'pages/syntheticLagoon/node081',
    'pages/syntheticLagoon/node082',
    'pages/syntheticLagoon/node083',
    'pages/syntheticLagoon/node084',
    'pages/syntheticLagoon/node085',
    'pages/syntheticLagoon/node086',
    'pages/syntheticLagoon/node087',
    'pages/syntheticLagoon/node088',
    'pages/syntheticLagoon/node089',
    'pages/syntheticLagoon/node090',
    'pages/syntheticLagoon/node091',
    'pages/syntheticLagoon/node092',
    'pages/syntheticLagoon/node093',
    'pages/syntheticLagoon/node094',
    'pages/syntheticLagoon/node095',
    'pages/syntheticLagoon/node096',
    'pages/syntheticLagoon/node097',
    'pages/syntheticLagoon/node098',
    'pages/syntheticLagoon/node099',
    'pages/syntheticLagoon/node100',
    'pages/syntheticLagoon/node101',
    'pages/syntheticLagoon/node102',
    'pages/syntheticLagoon/node103',
    'pages/syntheticLagoon/node104',
    'pages/syntheticLagoon/node105',
    'pages/syntheticLagoon/node106',
    'pages/syntheticLagoon/node107',
    'pages/syntheticLagoon/node108',
    'pages/syntheticLagoon/node109',
    'pages/syntheticLagoon/node110',
    'pages/syntheticLagoon/node111',
    'pages/syntheticLagoon/node112',
    'pages/syntheticLagoon/node113',
    'pages/syntheticLagoon/node114',
    'pages/syntheticLagoon/node115',
    'pages/syntheticLagoon/node116',
    'pages/syntheticLagoon/node117',
    'pages/syntheticLagoon/node118',
    'pages/syntheticLagoon/node119',
    'pages/syntheticLagoon/node120',
    'pages/syntheticLagoon/node121',
    'pages/syntheticLagoon/node122',
    'pages/syntheticLagoon/node123',
    'pages/syntheticLagoon/node124',
    'pages/syntheticLagoon/node125',
    'pages/syntheticLagoon/node126',
    'pages/syntheticLagoon/node127',
    'pages/syntheticLagoon/node128',
    'pages/syntheticLagoon/node129',
    'pages/syntheticLagoon/node130',
    'pages/syntheticLagoon/node131',
    'pages/syntheticLagoon/node132',
    'pages/syntheticLagoon/node133',
    'pages/syntheticLagoon/node134',
    'pages/syntheticLagoon/node135',
    'pages/syntheticLagoon/node136',
    'pages/syntheticLagoon/node137',
    'pages/syntheticLagoon/node138',
    'pages/syntheticLagoon/node139',
    'pages/syntheticLagoon/node140',
    'pages/syntheticLagoon/node141',
    'pages/syntheticLagoon/node142',
    'pages/syntheticLagoon/node143',
    'pages/syntheticLagoon/node144',
    'pages/syntheticLagoon/node145',
    'pages/syntheticLagoon/node146',
    'pages/syntheticLagoon/node147',
    'pages/syntheticLagoon/node148',
    'pages/syntheticLagoon/node149',
    'pages/syntheticLagoon/node150',
    'pages/syntheticLagoon/node151',
    'pages/syntheticLagoon/node152',
    'pages/syntheticLagoon/node153',
    'pages/syntheticLagoon/node154',
    'pages/syntheticLagoon/node155',
    'pages/syntheticLagoon/node156',
    'pages/syntheticLagoon/node157',
    'pages/syntheticLagoon/node158',
    'pages/syntheticLagoon/node159',
    'pages/syntheticLagoon/node160'
  ];

  describe('MegaSyntheticRouteAtlasLagoonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteLagoon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

