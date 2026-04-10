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
  return /^pages\/syntheticKingfisher\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasKingfisherTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteKingfisher_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticKingfisher/node001',
    'pages/syntheticKingfisher/node002',
    'pages/syntheticKingfisher/node003',
    'pages/syntheticKingfisher/node004',
    'pages/syntheticKingfisher/node005',
    'pages/syntheticKingfisher/node006',
    'pages/syntheticKingfisher/node007',
    'pages/syntheticKingfisher/node008',
    'pages/syntheticKingfisher/node009',
    'pages/syntheticKingfisher/node010',
    'pages/syntheticKingfisher/node011',
    'pages/syntheticKingfisher/node012',
    'pages/syntheticKingfisher/node013',
    'pages/syntheticKingfisher/node014',
    'pages/syntheticKingfisher/node015',
    'pages/syntheticKingfisher/node016',
    'pages/syntheticKingfisher/node017',
    'pages/syntheticKingfisher/node018',
    'pages/syntheticKingfisher/node019',
    'pages/syntheticKingfisher/node020',
    'pages/syntheticKingfisher/node021',
    'pages/syntheticKingfisher/node022',
    'pages/syntheticKingfisher/node023',
    'pages/syntheticKingfisher/node024',
    'pages/syntheticKingfisher/node025',
    'pages/syntheticKingfisher/node026',
    'pages/syntheticKingfisher/node027',
    'pages/syntheticKingfisher/node028',
    'pages/syntheticKingfisher/node029',
    'pages/syntheticKingfisher/node030',
    'pages/syntheticKingfisher/node031',
    'pages/syntheticKingfisher/node032',
    'pages/syntheticKingfisher/node033',
    'pages/syntheticKingfisher/node034',
    'pages/syntheticKingfisher/node035',
    'pages/syntheticKingfisher/node036',
    'pages/syntheticKingfisher/node037',
    'pages/syntheticKingfisher/node038',
    'pages/syntheticKingfisher/node039',
    'pages/syntheticKingfisher/node040',
    'pages/syntheticKingfisher/node041',
    'pages/syntheticKingfisher/node042',
    'pages/syntheticKingfisher/node043',
    'pages/syntheticKingfisher/node044',
    'pages/syntheticKingfisher/node045',
    'pages/syntheticKingfisher/node046',
    'pages/syntheticKingfisher/node047',
    'pages/syntheticKingfisher/node048',
    'pages/syntheticKingfisher/node049',
    'pages/syntheticKingfisher/node050',
    'pages/syntheticKingfisher/node051',
    'pages/syntheticKingfisher/node052',
    'pages/syntheticKingfisher/node053',
    'pages/syntheticKingfisher/node054',
    'pages/syntheticKingfisher/node055',
    'pages/syntheticKingfisher/node056',
    'pages/syntheticKingfisher/node057',
    'pages/syntheticKingfisher/node058',
    'pages/syntheticKingfisher/node059',
    'pages/syntheticKingfisher/node060',
    'pages/syntheticKingfisher/node061',
    'pages/syntheticKingfisher/node062',
    'pages/syntheticKingfisher/node063',
    'pages/syntheticKingfisher/node064',
    'pages/syntheticKingfisher/node065',
    'pages/syntheticKingfisher/node066',
    'pages/syntheticKingfisher/node067',
    'pages/syntheticKingfisher/node068',
    'pages/syntheticKingfisher/node069',
    'pages/syntheticKingfisher/node070',
    'pages/syntheticKingfisher/node071',
    'pages/syntheticKingfisher/node072',
    'pages/syntheticKingfisher/node073',
    'pages/syntheticKingfisher/node074',
    'pages/syntheticKingfisher/node075',
    'pages/syntheticKingfisher/node076',
    'pages/syntheticKingfisher/node077',
    'pages/syntheticKingfisher/node078',
    'pages/syntheticKingfisher/node079',
    'pages/syntheticKingfisher/node080',
    'pages/syntheticKingfisher/node081',
    'pages/syntheticKingfisher/node082',
    'pages/syntheticKingfisher/node083',
    'pages/syntheticKingfisher/node084',
    'pages/syntheticKingfisher/node085',
    'pages/syntheticKingfisher/node086',
    'pages/syntheticKingfisher/node087',
    'pages/syntheticKingfisher/node088',
    'pages/syntheticKingfisher/node089',
    'pages/syntheticKingfisher/node090',
    'pages/syntheticKingfisher/node091',
    'pages/syntheticKingfisher/node092',
    'pages/syntheticKingfisher/node093',
    'pages/syntheticKingfisher/node094',
    'pages/syntheticKingfisher/node095',
    'pages/syntheticKingfisher/node096',
    'pages/syntheticKingfisher/node097',
    'pages/syntheticKingfisher/node098',
    'pages/syntheticKingfisher/node099',
    'pages/syntheticKingfisher/node100',
    'pages/syntheticKingfisher/node101',
    'pages/syntheticKingfisher/node102',
    'pages/syntheticKingfisher/node103',
    'pages/syntheticKingfisher/node104',
    'pages/syntheticKingfisher/node105',
    'pages/syntheticKingfisher/node106',
    'pages/syntheticKingfisher/node107',
    'pages/syntheticKingfisher/node108',
    'pages/syntheticKingfisher/node109',
    'pages/syntheticKingfisher/node110',
    'pages/syntheticKingfisher/node111',
    'pages/syntheticKingfisher/node112',
    'pages/syntheticKingfisher/node113',
    'pages/syntheticKingfisher/node114',
    'pages/syntheticKingfisher/node115',
    'pages/syntheticKingfisher/node116',
    'pages/syntheticKingfisher/node117',
    'pages/syntheticKingfisher/node118',
    'pages/syntheticKingfisher/node119',
    'pages/syntheticKingfisher/node120',
    'pages/syntheticKingfisher/node121',
    'pages/syntheticKingfisher/node122',
    'pages/syntheticKingfisher/node123',
    'pages/syntheticKingfisher/node124',
    'pages/syntheticKingfisher/node125',
    'pages/syntheticKingfisher/node126',
    'pages/syntheticKingfisher/node127',
    'pages/syntheticKingfisher/node128',
    'pages/syntheticKingfisher/node129',
    'pages/syntheticKingfisher/node130',
    'pages/syntheticKingfisher/node131',
    'pages/syntheticKingfisher/node132',
    'pages/syntheticKingfisher/node133',
    'pages/syntheticKingfisher/node134',
    'pages/syntheticKingfisher/node135',
    'pages/syntheticKingfisher/node136',
    'pages/syntheticKingfisher/node137',
    'pages/syntheticKingfisher/node138',
    'pages/syntheticKingfisher/node139',
    'pages/syntheticKingfisher/node140',
    'pages/syntheticKingfisher/node141',
    'pages/syntheticKingfisher/node142',
    'pages/syntheticKingfisher/node143',
    'pages/syntheticKingfisher/node144',
    'pages/syntheticKingfisher/node145',
    'pages/syntheticKingfisher/node146',
    'pages/syntheticKingfisher/node147',
    'pages/syntheticKingfisher/node148',
    'pages/syntheticKingfisher/node149',
    'pages/syntheticKingfisher/node150',
    'pages/syntheticKingfisher/node151',
    'pages/syntheticKingfisher/node152',
    'pages/syntheticKingfisher/node153',
    'pages/syntheticKingfisher/node154',
    'pages/syntheticKingfisher/node155',
    'pages/syntheticKingfisher/node156',
    'pages/syntheticKingfisher/node157',
    'pages/syntheticKingfisher/node158',
    'pages/syntheticKingfisher/node159',
    'pages/syntheticKingfisher/node160'
  ];

  describe('MegaSyntheticRouteAtlasKingfisherSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteKingfisher_[A-Za-z0-9_]+_[0-9]{3}$/;
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

