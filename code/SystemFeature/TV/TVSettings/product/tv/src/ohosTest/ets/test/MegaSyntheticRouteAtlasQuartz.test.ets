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
  return /^pages\/syntheticQuartz\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasQuartzTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteQuartz_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticQuartz/node001',
    'pages/syntheticQuartz/node002',
    'pages/syntheticQuartz/node003',
    'pages/syntheticQuartz/node004',
    'pages/syntheticQuartz/node005',
    'pages/syntheticQuartz/node006',
    'pages/syntheticQuartz/node007',
    'pages/syntheticQuartz/node008',
    'pages/syntheticQuartz/node009',
    'pages/syntheticQuartz/node010',
    'pages/syntheticQuartz/node011',
    'pages/syntheticQuartz/node012',
    'pages/syntheticQuartz/node013',
    'pages/syntheticQuartz/node014',
    'pages/syntheticQuartz/node015',
    'pages/syntheticQuartz/node016',
    'pages/syntheticQuartz/node017',
    'pages/syntheticQuartz/node018',
    'pages/syntheticQuartz/node019',
    'pages/syntheticQuartz/node020',
    'pages/syntheticQuartz/node021',
    'pages/syntheticQuartz/node022',
    'pages/syntheticQuartz/node023',
    'pages/syntheticQuartz/node024',
    'pages/syntheticQuartz/node025',
    'pages/syntheticQuartz/node026',
    'pages/syntheticQuartz/node027',
    'pages/syntheticQuartz/node028',
    'pages/syntheticQuartz/node029',
    'pages/syntheticQuartz/node030',
    'pages/syntheticQuartz/node031',
    'pages/syntheticQuartz/node032',
    'pages/syntheticQuartz/node033',
    'pages/syntheticQuartz/node034',
    'pages/syntheticQuartz/node035',
    'pages/syntheticQuartz/node036',
    'pages/syntheticQuartz/node037',
    'pages/syntheticQuartz/node038',
    'pages/syntheticQuartz/node039',
    'pages/syntheticQuartz/node040',
    'pages/syntheticQuartz/node041',
    'pages/syntheticQuartz/node042',
    'pages/syntheticQuartz/node043',
    'pages/syntheticQuartz/node044',
    'pages/syntheticQuartz/node045',
    'pages/syntheticQuartz/node046',
    'pages/syntheticQuartz/node047',
    'pages/syntheticQuartz/node048',
    'pages/syntheticQuartz/node049',
    'pages/syntheticQuartz/node050',
    'pages/syntheticQuartz/node051',
    'pages/syntheticQuartz/node052',
    'pages/syntheticQuartz/node053',
    'pages/syntheticQuartz/node054',
    'pages/syntheticQuartz/node055',
    'pages/syntheticQuartz/node056',
    'pages/syntheticQuartz/node057',
    'pages/syntheticQuartz/node058',
    'pages/syntheticQuartz/node059',
    'pages/syntheticQuartz/node060',
    'pages/syntheticQuartz/node061',
    'pages/syntheticQuartz/node062',
    'pages/syntheticQuartz/node063',
    'pages/syntheticQuartz/node064',
    'pages/syntheticQuartz/node065',
    'pages/syntheticQuartz/node066',
    'pages/syntheticQuartz/node067',
    'pages/syntheticQuartz/node068',
    'pages/syntheticQuartz/node069',
    'pages/syntheticQuartz/node070',
    'pages/syntheticQuartz/node071',
    'pages/syntheticQuartz/node072',
    'pages/syntheticQuartz/node073',
    'pages/syntheticQuartz/node074',
    'pages/syntheticQuartz/node075',
    'pages/syntheticQuartz/node076',
    'pages/syntheticQuartz/node077',
    'pages/syntheticQuartz/node078',
    'pages/syntheticQuartz/node079',
    'pages/syntheticQuartz/node080',
    'pages/syntheticQuartz/node081',
    'pages/syntheticQuartz/node082',
    'pages/syntheticQuartz/node083',
    'pages/syntheticQuartz/node084',
    'pages/syntheticQuartz/node085',
    'pages/syntheticQuartz/node086',
    'pages/syntheticQuartz/node087',
    'pages/syntheticQuartz/node088',
    'pages/syntheticQuartz/node089',
    'pages/syntheticQuartz/node090',
    'pages/syntheticQuartz/node091',
    'pages/syntheticQuartz/node092',
    'pages/syntheticQuartz/node093',
    'pages/syntheticQuartz/node094',
    'pages/syntheticQuartz/node095',
    'pages/syntheticQuartz/node096',
    'pages/syntheticQuartz/node097',
    'pages/syntheticQuartz/node098',
    'pages/syntheticQuartz/node099',
    'pages/syntheticQuartz/node100',
    'pages/syntheticQuartz/node101',
    'pages/syntheticQuartz/node102',
    'pages/syntheticQuartz/node103',
    'pages/syntheticQuartz/node104',
    'pages/syntheticQuartz/node105',
    'pages/syntheticQuartz/node106',
    'pages/syntheticQuartz/node107',
    'pages/syntheticQuartz/node108',
    'pages/syntheticQuartz/node109',
    'pages/syntheticQuartz/node110',
    'pages/syntheticQuartz/node111',
    'pages/syntheticQuartz/node112',
    'pages/syntheticQuartz/node113',
    'pages/syntheticQuartz/node114',
    'pages/syntheticQuartz/node115',
    'pages/syntheticQuartz/node116',
    'pages/syntheticQuartz/node117',
    'pages/syntheticQuartz/node118',
    'pages/syntheticQuartz/node119',
    'pages/syntheticQuartz/node120',
    'pages/syntheticQuartz/node121',
    'pages/syntheticQuartz/node122',
    'pages/syntheticQuartz/node123',
    'pages/syntheticQuartz/node124',
    'pages/syntheticQuartz/node125',
    'pages/syntheticQuartz/node126',
    'pages/syntheticQuartz/node127',
    'pages/syntheticQuartz/node128',
    'pages/syntheticQuartz/node129',
    'pages/syntheticQuartz/node130',
    'pages/syntheticQuartz/node131',
    'pages/syntheticQuartz/node132',
    'pages/syntheticQuartz/node133',
    'pages/syntheticQuartz/node134',
    'pages/syntheticQuartz/node135',
    'pages/syntheticQuartz/node136',
    'pages/syntheticQuartz/node137',
    'pages/syntheticQuartz/node138',
    'pages/syntheticQuartz/node139',
    'pages/syntheticQuartz/node140',
    'pages/syntheticQuartz/node141',
    'pages/syntheticQuartz/node142',
    'pages/syntheticQuartz/node143',
    'pages/syntheticQuartz/node144',
    'pages/syntheticQuartz/node145',
    'pages/syntheticQuartz/node146',
    'pages/syntheticQuartz/node147',
    'pages/syntheticQuartz/node148',
    'pages/syntheticQuartz/node149',
    'pages/syntheticQuartz/node150',
    'pages/syntheticQuartz/node151',
    'pages/syntheticQuartz/node152',
    'pages/syntheticQuartz/node153',
    'pages/syntheticQuartz/node154',
    'pages/syntheticQuartz/node155',
    'pages/syntheticQuartz/node156',
    'pages/syntheticQuartz/node157',
    'pages/syntheticQuartz/node158',
    'pages/syntheticQuartz/node159',
    'pages/syntheticQuartz/node160'
  ];

  describe('MegaSyntheticRouteAtlasQuartzSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteQuartz_[A-Za-z0-9_]+_[0-9]{3}$/;
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

