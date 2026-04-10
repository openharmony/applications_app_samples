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
  return /^pages\/syntheticFlare\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasFlareTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteFlare_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticFlare/node001',
    'pages/syntheticFlare/node002',
    'pages/syntheticFlare/node003',
    'pages/syntheticFlare/node004',
    'pages/syntheticFlare/node005',
    'pages/syntheticFlare/node006',
    'pages/syntheticFlare/node007',
    'pages/syntheticFlare/node008',
    'pages/syntheticFlare/node009',
    'pages/syntheticFlare/node010',
    'pages/syntheticFlare/node011',
    'pages/syntheticFlare/node012',
    'pages/syntheticFlare/node013',
    'pages/syntheticFlare/node014',
    'pages/syntheticFlare/node015',
    'pages/syntheticFlare/node016',
    'pages/syntheticFlare/node017',
    'pages/syntheticFlare/node018',
    'pages/syntheticFlare/node019',
    'pages/syntheticFlare/node020',
    'pages/syntheticFlare/node021',
    'pages/syntheticFlare/node022',
    'pages/syntheticFlare/node023',
    'pages/syntheticFlare/node024',
    'pages/syntheticFlare/node025',
    'pages/syntheticFlare/node026',
    'pages/syntheticFlare/node027',
    'pages/syntheticFlare/node028',
    'pages/syntheticFlare/node029',
    'pages/syntheticFlare/node030',
    'pages/syntheticFlare/node031',
    'pages/syntheticFlare/node032',
    'pages/syntheticFlare/node033',
    'pages/syntheticFlare/node034',
    'pages/syntheticFlare/node035',
    'pages/syntheticFlare/node036',
    'pages/syntheticFlare/node037',
    'pages/syntheticFlare/node038',
    'pages/syntheticFlare/node039',
    'pages/syntheticFlare/node040',
    'pages/syntheticFlare/node041',
    'pages/syntheticFlare/node042',
    'pages/syntheticFlare/node043',
    'pages/syntheticFlare/node044',
    'pages/syntheticFlare/node045',
    'pages/syntheticFlare/node046',
    'pages/syntheticFlare/node047',
    'pages/syntheticFlare/node048',
    'pages/syntheticFlare/node049',
    'pages/syntheticFlare/node050',
    'pages/syntheticFlare/node051',
    'pages/syntheticFlare/node052',
    'pages/syntheticFlare/node053',
    'pages/syntheticFlare/node054',
    'pages/syntheticFlare/node055',
    'pages/syntheticFlare/node056',
    'pages/syntheticFlare/node057',
    'pages/syntheticFlare/node058',
    'pages/syntheticFlare/node059',
    'pages/syntheticFlare/node060',
    'pages/syntheticFlare/node061',
    'pages/syntheticFlare/node062',
    'pages/syntheticFlare/node063',
    'pages/syntheticFlare/node064',
    'pages/syntheticFlare/node065',
    'pages/syntheticFlare/node066',
    'pages/syntheticFlare/node067',
    'pages/syntheticFlare/node068',
    'pages/syntheticFlare/node069',
    'pages/syntheticFlare/node070',
    'pages/syntheticFlare/node071',
    'pages/syntheticFlare/node072',
    'pages/syntheticFlare/node073',
    'pages/syntheticFlare/node074',
    'pages/syntheticFlare/node075',
    'pages/syntheticFlare/node076',
    'pages/syntheticFlare/node077',
    'pages/syntheticFlare/node078',
    'pages/syntheticFlare/node079',
    'pages/syntheticFlare/node080',
    'pages/syntheticFlare/node081',
    'pages/syntheticFlare/node082',
    'pages/syntheticFlare/node083',
    'pages/syntheticFlare/node084',
    'pages/syntheticFlare/node085',
    'pages/syntheticFlare/node086',
    'pages/syntheticFlare/node087',
    'pages/syntheticFlare/node088',
    'pages/syntheticFlare/node089',
    'pages/syntheticFlare/node090',
    'pages/syntheticFlare/node091',
    'pages/syntheticFlare/node092',
    'pages/syntheticFlare/node093',
    'pages/syntheticFlare/node094',
    'pages/syntheticFlare/node095',
    'pages/syntheticFlare/node096',
    'pages/syntheticFlare/node097',
    'pages/syntheticFlare/node098',
    'pages/syntheticFlare/node099',
    'pages/syntheticFlare/node100',
    'pages/syntheticFlare/node101',
    'pages/syntheticFlare/node102',
    'pages/syntheticFlare/node103',
    'pages/syntheticFlare/node104',
    'pages/syntheticFlare/node105',
    'pages/syntheticFlare/node106',
    'pages/syntheticFlare/node107',
    'pages/syntheticFlare/node108',
    'pages/syntheticFlare/node109',
    'pages/syntheticFlare/node110',
    'pages/syntheticFlare/node111',
    'pages/syntheticFlare/node112',
    'pages/syntheticFlare/node113',
    'pages/syntheticFlare/node114',
    'pages/syntheticFlare/node115',
    'pages/syntheticFlare/node116',
    'pages/syntheticFlare/node117',
    'pages/syntheticFlare/node118',
    'pages/syntheticFlare/node119',
    'pages/syntheticFlare/node120',
    'pages/syntheticFlare/node121',
    'pages/syntheticFlare/node122',
    'pages/syntheticFlare/node123',
    'pages/syntheticFlare/node124',
    'pages/syntheticFlare/node125',
    'pages/syntheticFlare/node126',
    'pages/syntheticFlare/node127',
    'pages/syntheticFlare/node128',
    'pages/syntheticFlare/node129',
    'pages/syntheticFlare/node130',
    'pages/syntheticFlare/node131',
    'pages/syntheticFlare/node132',
    'pages/syntheticFlare/node133',
    'pages/syntheticFlare/node134',
    'pages/syntheticFlare/node135',
    'pages/syntheticFlare/node136',
    'pages/syntheticFlare/node137',
    'pages/syntheticFlare/node138',
    'pages/syntheticFlare/node139',
    'pages/syntheticFlare/node140',
    'pages/syntheticFlare/node141',
    'pages/syntheticFlare/node142',
    'pages/syntheticFlare/node143',
    'pages/syntheticFlare/node144',
    'pages/syntheticFlare/node145',
    'pages/syntheticFlare/node146',
    'pages/syntheticFlare/node147',
    'pages/syntheticFlare/node148',
    'pages/syntheticFlare/node149',
    'pages/syntheticFlare/node150',
    'pages/syntheticFlare/node151',
    'pages/syntheticFlare/node152',
    'pages/syntheticFlare/node153',
    'pages/syntheticFlare/node154',
    'pages/syntheticFlare/node155',
    'pages/syntheticFlare/node156',
    'pages/syntheticFlare/node157',
    'pages/syntheticFlare/node158',
    'pages/syntheticFlare/node159',
    'pages/syntheticFlare/node160'
  ];

  describe('MegaSyntheticRouteAtlasFlareSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteFlare_[A-Za-z0-9_]+_[0-9]{3}$/;
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

