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
  return /^pages\/syntheticComet\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasCometTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteComet_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticComet/node001',
    'pages/syntheticComet/node002',
    'pages/syntheticComet/node003',
    'pages/syntheticComet/node004',
    'pages/syntheticComet/node005',
    'pages/syntheticComet/node006',
    'pages/syntheticComet/node007',
    'pages/syntheticComet/node008',
    'pages/syntheticComet/node009',
    'pages/syntheticComet/node010',
    'pages/syntheticComet/node011',
    'pages/syntheticComet/node012',
    'pages/syntheticComet/node013',
    'pages/syntheticComet/node014',
    'pages/syntheticComet/node015',
    'pages/syntheticComet/node016',
    'pages/syntheticComet/node017',
    'pages/syntheticComet/node018',
    'pages/syntheticComet/node019',
    'pages/syntheticComet/node020',
    'pages/syntheticComet/node021',
    'pages/syntheticComet/node022',
    'pages/syntheticComet/node023',
    'pages/syntheticComet/node024',
    'pages/syntheticComet/node025',
    'pages/syntheticComet/node026',
    'pages/syntheticComet/node027',
    'pages/syntheticComet/node028',
    'pages/syntheticComet/node029',
    'pages/syntheticComet/node030',
    'pages/syntheticComet/node031',
    'pages/syntheticComet/node032',
    'pages/syntheticComet/node033',
    'pages/syntheticComet/node034',
    'pages/syntheticComet/node035',
    'pages/syntheticComet/node036',
    'pages/syntheticComet/node037',
    'pages/syntheticComet/node038',
    'pages/syntheticComet/node039',
    'pages/syntheticComet/node040',
    'pages/syntheticComet/node041',
    'pages/syntheticComet/node042',
    'pages/syntheticComet/node043',
    'pages/syntheticComet/node044',
    'pages/syntheticComet/node045',
    'pages/syntheticComet/node046',
    'pages/syntheticComet/node047',
    'pages/syntheticComet/node048',
    'pages/syntheticComet/node049',
    'pages/syntheticComet/node050',
    'pages/syntheticComet/node051',
    'pages/syntheticComet/node052',
    'pages/syntheticComet/node053',
    'pages/syntheticComet/node054',
    'pages/syntheticComet/node055',
    'pages/syntheticComet/node056',
    'pages/syntheticComet/node057',
    'pages/syntheticComet/node058',
    'pages/syntheticComet/node059',
    'pages/syntheticComet/node060',
    'pages/syntheticComet/node061',
    'pages/syntheticComet/node062',
    'pages/syntheticComet/node063',
    'pages/syntheticComet/node064',
    'pages/syntheticComet/node065',
    'pages/syntheticComet/node066',
    'pages/syntheticComet/node067',
    'pages/syntheticComet/node068',
    'pages/syntheticComet/node069',
    'pages/syntheticComet/node070',
    'pages/syntheticComet/node071',
    'pages/syntheticComet/node072',
    'pages/syntheticComet/node073',
    'pages/syntheticComet/node074',
    'pages/syntheticComet/node075',
    'pages/syntheticComet/node076',
    'pages/syntheticComet/node077',
    'pages/syntheticComet/node078',
    'pages/syntheticComet/node079',
    'pages/syntheticComet/node080',
    'pages/syntheticComet/node081',
    'pages/syntheticComet/node082',
    'pages/syntheticComet/node083',
    'pages/syntheticComet/node084',
    'pages/syntheticComet/node085',
    'pages/syntheticComet/node086',
    'pages/syntheticComet/node087',
    'pages/syntheticComet/node088',
    'pages/syntheticComet/node089',
    'pages/syntheticComet/node090',
    'pages/syntheticComet/node091',
    'pages/syntheticComet/node092',
    'pages/syntheticComet/node093',
    'pages/syntheticComet/node094',
    'pages/syntheticComet/node095',
    'pages/syntheticComet/node096',
    'pages/syntheticComet/node097',
    'pages/syntheticComet/node098',
    'pages/syntheticComet/node099',
    'pages/syntheticComet/node100',
    'pages/syntheticComet/node101',
    'pages/syntheticComet/node102',
    'pages/syntheticComet/node103',
    'pages/syntheticComet/node104',
    'pages/syntheticComet/node105',
    'pages/syntheticComet/node106',
    'pages/syntheticComet/node107',
    'pages/syntheticComet/node108',
    'pages/syntheticComet/node109',
    'pages/syntheticComet/node110',
    'pages/syntheticComet/node111',
    'pages/syntheticComet/node112',
    'pages/syntheticComet/node113',
    'pages/syntheticComet/node114',
    'pages/syntheticComet/node115',
    'pages/syntheticComet/node116',
    'pages/syntheticComet/node117',
    'pages/syntheticComet/node118',
    'pages/syntheticComet/node119',
    'pages/syntheticComet/node120',
    'pages/syntheticComet/node121',
    'pages/syntheticComet/node122',
    'pages/syntheticComet/node123',
    'pages/syntheticComet/node124',
    'pages/syntheticComet/node125',
    'pages/syntheticComet/node126',
    'pages/syntheticComet/node127',
    'pages/syntheticComet/node128',
    'pages/syntheticComet/node129',
    'pages/syntheticComet/node130',
    'pages/syntheticComet/node131',
    'pages/syntheticComet/node132',
    'pages/syntheticComet/node133',
    'pages/syntheticComet/node134',
    'pages/syntheticComet/node135',
    'pages/syntheticComet/node136',
    'pages/syntheticComet/node137',
    'pages/syntheticComet/node138',
    'pages/syntheticComet/node139',
    'pages/syntheticComet/node140',
    'pages/syntheticComet/node141',
    'pages/syntheticComet/node142',
    'pages/syntheticComet/node143',
    'pages/syntheticComet/node144',
    'pages/syntheticComet/node145',
    'pages/syntheticComet/node146',
    'pages/syntheticComet/node147',
    'pages/syntheticComet/node148',
    'pages/syntheticComet/node149',
    'pages/syntheticComet/node150',
    'pages/syntheticComet/node151',
    'pages/syntheticComet/node152',
    'pages/syntheticComet/node153',
    'pages/syntheticComet/node154',
    'pages/syntheticComet/node155',
    'pages/syntheticComet/node156',
    'pages/syntheticComet/node157',
    'pages/syntheticComet/node158',
    'pages/syntheticComet/node159',
    'pages/syntheticComet/node160'
  ];

  describe('MegaSyntheticRouteAtlasCometSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteComet_[A-Za-z0-9_]+_[0-9]{3}$/;
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

