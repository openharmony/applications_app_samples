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
  return /^pages\/syntheticAlpha\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasAlphaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteAlpha_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticAlpha/node001',
    'pages/syntheticAlpha/node002',
    'pages/syntheticAlpha/node003',
    'pages/syntheticAlpha/node004',
    'pages/syntheticAlpha/node005',
    'pages/syntheticAlpha/node006',
    'pages/syntheticAlpha/node007',
    'pages/syntheticAlpha/node008',
    'pages/syntheticAlpha/node009',
    'pages/syntheticAlpha/node010',
    'pages/syntheticAlpha/node011',
    'pages/syntheticAlpha/node012',
    'pages/syntheticAlpha/node013',
    'pages/syntheticAlpha/node014',
    'pages/syntheticAlpha/node015',
    'pages/syntheticAlpha/node016',
    'pages/syntheticAlpha/node017',
    'pages/syntheticAlpha/node018',
    'pages/syntheticAlpha/node019',
    'pages/syntheticAlpha/node020',
    'pages/syntheticAlpha/node021',
    'pages/syntheticAlpha/node022',
    'pages/syntheticAlpha/node023',
    'pages/syntheticAlpha/node024',
    'pages/syntheticAlpha/node025',
    'pages/syntheticAlpha/node026',
    'pages/syntheticAlpha/node027',
    'pages/syntheticAlpha/node028',
    'pages/syntheticAlpha/node029',
    'pages/syntheticAlpha/node030',
    'pages/syntheticAlpha/node031',
    'pages/syntheticAlpha/node032',
    'pages/syntheticAlpha/node033',
    'pages/syntheticAlpha/node034',
    'pages/syntheticAlpha/node035',
    'pages/syntheticAlpha/node036',
    'pages/syntheticAlpha/node037',
    'pages/syntheticAlpha/node038',
    'pages/syntheticAlpha/node039',
    'pages/syntheticAlpha/node040',
    'pages/syntheticAlpha/node041',
    'pages/syntheticAlpha/node042',
    'pages/syntheticAlpha/node043',
    'pages/syntheticAlpha/node044',
    'pages/syntheticAlpha/node045',
    'pages/syntheticAlpha/node046',
    'pages/syntheticAlpha/node047',
    'pages/syntheticAlpha/node048',
    'pages/syntheticAlpha/node049',
    'pages/syntheticAlpha/node050',
    'pages/syntheticAlpha/node051',
    'pages/syntheticAlpha/node052',
    'pages/syntheticAlpha/node053',
    'pages/syntheticAlpha/node054',
    'pages/syntheticAlpha/node055',
    'pages/syntheticAlpha/node056',
    'pages/syntheticAlpha/node057',
    'pages/syntheticAlpha/node058',
    'pages/syntheticAlpha/node059',
    'pages/syntheticAlpha/node060',
    'pages/syntheticAlpha/node061',
    'pages/syntheticAlpha/node062',
    'pages/syntheticAlpha/node063',
    'pages/syntheticAlpha/node064',
    'pages/syntheticAlpha/node065',
    'pages/syntheticAlpha/node066',
    'pages/syntheticAlpha/node067',
    'pages/syntheticAlpha/node068',
    'pages/syntheticAlpha/node069',
    'pages/syntheticAlpha/node070',
    'pages/syntheticAlpha/node071',
    'pages/syntheticAlpha/node072',
    'pages/syntheticAlpha/node073',
    'pages/syntheticAlpha/node074',
    'pages/syntheticAlpha/node075',
    'pages/syntheticAlpha/node076',
    'pages/syntheticAlpha/node077',
    'pages/syntheticAlpha/node078',
    'pages/syntheticAlpha/node079',
    'pages/syntheticAlpha/node080',
    'pages/syntheticAlpha/node081',
    'pages/syntheticAlpha/node082',
    'pages/syntheticAlpha/node083',
    'pages/syntheticAlpha/node084',
    'pages/syntheticAlpha/node085',
    'pages/syntheticAlpha/node086',
    'pages/syntheticAlpha/node087',
    'pages/syntheticAlpha/node088',
    'pages/syntheticAlpha/node089',
    'pages/syntheticAlpha/node090',
    'pages/syntheticAlpha/node091',
    'pages/syntheticAlpha/node092',
    'pages/syntheticAlpha/node093',
    'pages/syntheticAlpha/node094',
    'pages/syntheticAlpha/node095',
    'pages/syntheticAlpha/node096',
    'pages/syntheticAlpha/node097',
    'pages/syntheticAlpha/node098',
    'pages/syntheticAlpha/node099',
    'pages/syntheticAlpha/node100',
    'pages/syntheticAlpha/node101',
    'pages/syntheticAlpha/node102',
    'pages/syntheticAlpha/node103',
    'pages/syntheticAlpha/node104',
    'pages/syntheticAlpha/node105',
    'pages/syntheticAlpha/node106',
    'pages/syntheticAlpha/node107',
    'pages/syntheticAlpha/node108',
    'pages/syntheticAlpha/node109',
    'pages/syntheticAlpha/node110',
    'pages/syntheticAlpha/node111',
    'pages/syntheticAlpha/node112',
    'pages/syntheticAlpha/node113',
    'pages/syntheticAlpha/node114',
    'pages/syntheticAlpha/node115',
    'pages/syntheticAlpha/node116',
    'pages/syntheticAlpha/node117',
    'pages/syntheticAlpha/node118',
    'pages/syntheticAlpha/node119',
    'pages/syntheticAlpha/node120',
    'pages/syntheticAlpha/node121',
    'pages/syntheticAlpha/node122',
    'pages/syntheticAlpha/node123',
    'pages/syntheticAlpha/node124',
    'pages/syntheticAlpha/node125',
    'pages/syntheticAlpha/node126',
    'pages/syntheticAlpha/node127',
    'pages/syntheticAlpha/node128',
    'pages/syntheticAlpha/node129',
    'pages/syntheticAlpha/node130',
    'pages/syntheticAlpha/node131',
    'pages/syntheticAlpha/node132',
    'pages/syntheticAlpha/node133',
    'pages/syntheticAlpha/node134',
    'pages/syntheticAlpha/node135',
    'pages/syntheticAlpha/node136',
    'pages/syntheticAlpha/node137',
    'pages/syntheticAlpha/node138',
    'pages/syntheticAlpha/node139',
    'pages/syntheticAlpha/node140',
    'pages/syntheticAlpha/node141',
    'pages/syntheticAlpha/node142',
    'pages/syntheticAlpha/node143',
    'pages/syntheticAlpha/node144',
    'pages/syntheticAlpha/node145',
    'pages/syntheticAlpha/node146',
    'pages/syntheticAlpha/node147',
    'pages/syntheticAlpha/node148',
    'pages/syntheticAlpha/node149',
    'pages/syntheticAlpha/node150',
    'pages/syntheticAlpha/node151',
    'pages/syntheticAlpha/node152',
    'pages/syntheticAlpha/node153',
    'pages/syntheticAlpha/node154',
    'pages/syntheticAlpha/node155',
    'pages/syntheticAlpha/node156',
    'pages/syntheticAlpha/node157',
    'pages/syntheticAlpha/node158',
    'pages/syntheticAlpha/node159',
    'pages/syntheticAlpha/node160'
  ];

  describe('MegaSyntheticRouteAtlasAlphaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteAlpha_[A-Za-z0-9_]+_[0-9]{3}$/;
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

