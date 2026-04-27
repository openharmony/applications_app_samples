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
  return /^pages\/syntheticGlacier\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasGlacierTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteGlacier_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticGlacier/node001',
    'pages/syntheticGlacier/node002',
    'pages/syntheticGlacier/node003',
    'pages/syntheticGlacier/node004',
    'pages/syntheticGlacier/node005',
    'pages/syntheticGlacier/node006',
    'pages/syntheticGlacier/node007',
    'pages/syntheticGlacier/node008',
    'pages/syntheticGlacier/node009',
    'pages/syntheticGlacier/node010',
    'pages/syntheticGlacier/node011',
    'pages/syntheticGlacier/node012',
    'pages/syntheticGlacier/node013',
    'pages/syntheticGlacier/node014',
    'pages/syntheticGlacier/node015',
    'pages/syntheticGlacier/node016',
    'pages/syntheticGlacier/node017',
    'pages/syntheticGlacier/node018',
    'pages/syntheticGlacier/node019',
    'pages/syntheticGlacier/node020',
    'pages/syntheticGlacier/node021',
    'pages/syntheticGlacier/node022',
    'pages/syntheticGlacier/node023',
    'pages/syntheticGlacier/node024',
    'pages/syntheticGlacier/node025',
    'pages/syntheticGlacier/node026',
    'pages/syntheticGlacier/node027',
    'pages/syntheticGlacier/node028',
    'pages/syntheticGlacier/node029',
    'pages/syntheticGlacier/node030',
    'pages/syntheticGlacier/node031',
    'pages/syntheticGlacier/node032',
    'pages/syntheticGlacier/node033',
    'pages/syntheticGlacier/node034',
    'pages/syntheticGlacier/node035',
    'pages/syntheticGlacier/node036',
    'pages/syntheticGlacier/node037',
    'pages/syntheticGlacier/node038',
    'pages/syntheticGlacier/node039',
    'pages/syntheticGlacier/node040',
    'pages/syntheticGlacier/node041',
    'pages/syntheticGlacier/node042',
    'pages/syntheticGlacier/node043',
    'pages/syntheticGlacier/node044',
    'pages/syntheticGlacier/node045',
    'pages/syntheticGlacier/node046',
    'pages/syntheticGlacier/node047',
    'pages/syntheticGlacier/node048',
    'pages/syntheticGlacier/node049',
    'pages/syntheticGlacier/node050',
    'pages/syntheticGlacier/node051',
    'pages/syntheticGlacier/node052',
    'pages/syntheticGlacier/node053',
    'pages/syntheticGlacier/node054',
    'pages/syntheticGlacier/node055',
    'pages/syntheticGlacier/node056',
    'pages/syntheticGlacier/node057',
    'pages/syntheticGlacier/node058',
    'pages/syntheticGlacier/node059',
    'pages/syntheticGlacier/node060',
    'pages/syntheticGlacier/node061',
    'pages/syntheticGlacier/node062',
    'pages/syntheticGlacier/node063',
    'pages/syntheticGlacier/node064',
    'pages/syntheticGlacier/node065',
    'pages/syntheticGlacier/node066',
    'pages/syntheticGlacier/node067',
    'pages/syntheticGlacier/node068',
    'pages/syntheticGlacier/node069',
    'pages/syntheticGlacier/node070',
    'pages/syntheticGlacier/node071',
    'pages/syntheticGlacier/node072',
    'pages/syntheticGlacier/node073',
    'pages/syntheticGlacier/node074',
    'pages/syntheticGlacier/node075',
    'pages/syntheticGlacier/node076',
    'pages/syntheticGlacier/node077',
    'pages/syntheticGlacier/node078',
    'pages/syntheticGlacier/node079',
    'pages/syntheticGlacier/node080',
    'pages/syntheticGlacier/node081',
    'pages/syntheticGlacier/node082',
    'pages/syntheticGlacier/node083',
    'pages/syntheticGlacier/node084',
    'pages/syntheticGlacier/node085',
    'pages/syntheticGlacier/node086',
    'pages/syntheticGlacier/node087',
    'pages/syntheticGlacier/node088',
    'pages/syntheticGlacier/node089',
    'pages/syntheticGlacier/node090',
    'pages/syntheticGlacier/node091',
    'pages/syntheticGlacier/node092',
    'pages/syntheticGlacier/node093',
    'pages/syntheticGlacier/node094',
    'pages/syntheticGlacier/node095',
    'pages/syntheticGlacier/node096',
    'pages/syntheticGlacier/node097',
    'pages/syntheticGlacier/node098',
    'pages/syntheticGlacier/node099',
    'pages/syntheticGlacier/node100',
    'pages/syntheticGlacier/node101',
    'pages/syntheticGlacier/node102',
    'pages/syntheticGlacier/node103',
    'pages/syntheticGlacier/node104',
    'pages/syntheticGlacier/node105',
    'pages/syntheticGlacier/node106',
    'pages/syntheticGlacier/node107',
    'pages/syntheticGlacier/node108',
    'pages/syntheticGlacier/node109',
    'pages/syntheticGlacier/node110',
    'pages/syntheticGlacier/node111',
    'pages/syntheticGlacier/node112',
    'pages/syntheticGlacier/node113',
    'pages/syntheticGlacier/node114',
    'pages/syntheticGlacier/node115',
    'pages/syntheticGlacier/node116',
    'pages/syntheticGlacier/node117',
    'pages/syntheticGlacier/node118',
    'pages/syntheticGlacier/node119',
    'pages/syntheticGlacier/node120',
    'pages/syntheticGlacier/node121',
    'pages/syntheticGlacier/node122',
    'pages/syntheticGlacier/node123',
    'pages/syntheticGlacier/node124',
    'pages/syntheticGlacier/node125',
    'pages/syntheticGlacier/node126',
    'pages/syntheticGlacier/node127',
    'pages/syntheticGlacier/node128',
    'pages/syntheticGlacier/node129',
    'pages/syntheticGlacier/node130',
    'pages/syntheticGlacier/node131',
    'pages/syntheticGlacier/node132',
    'pages/syntheticGlacier/node133',
    'pages/syntheticGlacier/node134',
    'pages/syntheticGlacier/node135',
    'pages/syntheticGlacier/node136',
    'pages/syntheticGlacier/node137',
    'pages/syntheticGlacier/node138',
    'pages/syntheticGlacier/node139',
    'pages/syntheticGlacier/node140',
    'pages/syntheticGlacier/node141',
    'pages/syntheticGlacier/node142',
    'pages/syntheticGlacier/node143',
    'pages/syntheticGlacier/node144',
    'pages/syntheticGlacier/node145',
    'pages/syntheticGlacier/node146',
    'pages/syntheticGlacier/node147',
    'pages/syntheticGlacier/node148',
    'pages/syntheticGlacier/node149',
    'pages/syntheticGlacier/node150',
    'pages/syntheticGlacier/node151',
    'pages/syntheticGlacier/node152',
    'pages/syntheticGlacier/node153',
    'pages/syntheticGlacier/node154',
    'pages/syntheticGlacier/node155',
    'pages/syntheticGlacier/node156',
    'pages/syntheticGlacier/node157',
    'pages/syntheticGlacier/node158',
    'pages/syntheticGlacier/node159',
    'pages/syntheticGlacier/node160'
  ];

  describe('MegaSyntheticRouteAtlasGlacierSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteGlacier_[A-Za-z0-9_]+_[0-9]{3}$/;
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

