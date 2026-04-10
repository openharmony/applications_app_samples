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
  return /^pages\/syntheticUnity\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasUnityTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteUnity_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticUnity/node001',
    'pages/syntheticUnity/node002',
    'pages/syntheticUnity/node003',
    'pages/syntheticUnity/node004',
    'pages/syntheticUnity/node005',
    'pages/syntheticUnity/node006',
    'pages/syntheticUnity/node007',
    'pages/syntheticUnity/node008',
    'pages/syntheticUnity/node009',
    'pages/syntheticUnity/node010',
    'pages/syntheticUnity/node011',
    'pages/syntheticUnity/node012',
    'pages/syntheticUnity/node013',
    'pages/syntheticUnity/node014',
    'pages/syntheticUnity/node015',
    'pages/syntheticUnity/node016',
    'pages/syntheticUnity/node017',
    'pages/syntheticUnity/node018',
    'pages/syntheticUnity/node019',
    'pages/syntheticUnity/node020',
    'pages/syntheticUnity/node021',
    'pages/syntheticUnity/node022',
    'pages/syntheticUnity/node023',
    'pages/syntheticUnity/node024',
    'pages/syntheticUnity/node025',
    'pages/syntheticUnity/node026',
    'pages/syntheticUnity/node027',
    'pages/syntheticUnity/node028',
    'pages/syntheticUnity/node029',
    'pages/syntheticUnity/node030',
    'pages/syntheticUnity/node031',
    'pages/syntheticUnity/node032',
    'pages/syntheticUnity/node033',
    'pages/syntheticUnity/node034',
    'pages/syntheticUnity/node035',
    'pages/syntheticUnity/node036',
    'pages/syntheticUnity/node037',
    'pages/syntheticUnity/node038',
    'pages/syntheticUnity/node039',
    'pages/syntheticUnity/node040',
    'pages/syntheticUnity/node041',
    'pages/syntheticUnity/node042',
    'pages/syntheticUnity/node043',
    'pages/syntheticUnity/node044',
    'pages/syntheticUnity/node045',
    'pages/syntheticUnity/node046',
    'pages/syntheticUnity/node047',
    'pages/syntheticUnity/node048',
    'pages/syntheticUnity/node049',
    'pages/syntheticUnity/node050',
    'pages/syntheticUnity/node051',
    'pages/syntheticUnity/node052',
    'pages/syntheticUnity/node053',
    'pages/syntheticUnity/node054',
    'pages/syntheticUnity/node055',
    'pages/syntheticUnity/node056',
    'pages/syntheticUnity/node057',
    'pages/syntheticUnity/node058',
    'pages/syntheticUnity/node059',
    'pages/syntheticUnity/node060',
    'pages/syntheticUnity/node061',
    'pages/syntheticUnity/node062',
    'pages/syntheticUnity/node063',
    'pages/syntheticUnity/node064',
    'pages/syntheticUnity/node065',
    'pages/syntheticUnity/node066',
    'pages/syntheticUnity/node067',
    'pages/syntheticUnity/node068',
    'pages/syntheticUnity/node069',
    'pages/syntheticUnity/node070',
    'pages/syntheticUnity/node071',
    'pages/syntheticUnity/node072',
    'pages/syntheticUnity/node073',
    'pages/syntheticUnity/node074',
    'pages/syntheticUnity/node075',
    'pages/syntheticUnity/node076',
    'pages/syntheticUnity/node077',
    'pages/syntheticUnity/node078',
    'pages/syntheticUnity/node079',
    'pages/syntheticUnity/node080',
    'pages/syntheticUnity/node081',
    'pages/syntheticUnity/node082',
    'pages/syntheticUnity/node083',
    'pages/syntheticUnity/node084',
    'pages/syntheticUnity/node085',
    'pages/syntheticUnity/node086',
    'pages/syntheticUnity/node087',
    'pages/syntheticUnity/node088',
    'pages/syntheticUnity/node089',
    'pages/syntheticUnity/node090',
    'pages/syntheticUnity/node091',
    'pages/syntheticUnity/node092',
    'pages/syntheticUnity/node093',
    'pages/syntheticUnity/node094',
    'pages/syntheticUnity/node095',
    'pages/syntheticUnity/node096',
    'pages/syntheticUnity/node097',
    'pages/syntheticUnity/node098',
    'pages/syntheticUnity/node099',
    'pages/syntheticUnity/node100',
    'pages/syntheticUnity/node101',
    'pages/syntheticUnity/node102',
    'pages/syntheticUnity/node103',
    'pages/syntheticUnity/node104',
    'pages/syntheticUnity/node105',
    'pages/syntheticUnity/node106',
    'pages/syntheticUnity/node107',
    'pages/syntheticUnity/node108',
    'pages/syntheticUnity/node109',
    'pages/syntheticUnity/node110',
    'pages/syntheticUnity/node111',
    'pages/syntheticUnity/node112',
    'pages/syntheticUnity/node113',
    'pages/syntheticUnity/node114',
    'pages/syntheticUnity/node115',
    'pages/syntheticUnity/node116',
    'pages/syntheticUnity/node117',
    'pages/syntheticUnity/node118',
    'pages/syntheticUnity/node119',
    'pages/syntheticUnity/node120',
    'pages/syntheticUnity/node121',
    'pages/syntheticUnity/node122',
    'pages/syntheticUnity/node123',
    'pages/syntheticUnity/node124',
    'pages/syntheticUnity/node125',
    'pages/syntheticUnity/node126',
    'pages/syntheticUnity/node127',
    'pages/syntheticUnity/node128',
    'pages/syntheticUnity/node129',
    'pages/syntheticUnity/node130',
    'pages/syntheticUnity/node131',
    'pages/syntheticUnity/node132',
    'pages/syntheticUnity/node133',
    'pages/syntheticUnity/node134',
    'pages/syntheticUnity/node135',
    'pages/syntheticUnity/node136',
    'pages/syntheticUnity/node137',
    'pages/syntheticUnity/node138',
    'pages/syntheticUnity/node139',
    'pages/syntheticUnity/node140',
    'pages/syntheticUnity/node141',
    'pages/syntheticUnity/node142',
    'pages/syntheticUnity/node143',
    'pages/syntheticUnity/node144',
    'pages/syntheticUnity/node145',
    'pages/syntheticUnity/node146',
    'pages/syntheticUnity/node147',
    'pages/syntheticUnity/node148',
    'pages/syntheticUnity/node149',
    'pages/syntheticUnity/node150',
    'pages/syntheticUnity/node151',
    'pages/syntheticUnity/node152',
    'pages/syntheticUnity/node153',
    'pages/syntheticUnity/node154',
    'pages/syntheticUnity/node155',
    'pages/syntheticUnity/node156',
    'pages/syntheticUnity/node157',
    'pages/syntheticUnity/node158',
    'pages/syntheticUnity/node159',
    'pages/syntheticUnity/node160'
  ];

  describe('MegaSyntheticRouteAtlasUnitySuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteUnity_[A-Za-z0-9_]+_[0-9]{3}$/;
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

