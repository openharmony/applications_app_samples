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
  return /^pages\/syntheticChi\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasChiTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteChi_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticChi/node001',
    'pages/syntheticChi/node002',
    'pages/syntheticChi/node003',
    'pages/syntheticChi/node004',
    'pages/syntheticChi/node005',
    'pages/syntheticChi/node006',
    'pages/syntheticChi/node007',
    'pages/syntheticChi/node008',
    'pages/syntheticChi/node009',
    'pages/syntheticChi/node010',
    'pages/syntheticChi/node011',
    'pages/syntheticChi/node012',
    'pages/syntheticChi/node013',
    'pages/syntheticChi/node014',
    'pages/syntheticChi/node015',
    'pages/syntheticChi/node016',
    'pages/syntheticChi/node017',
    'pages/syntheticChi/node018',
    'pages/syntheticChi/node019',
    'pages/syntheticChi/node020',
    'pages/syntheticChi/node021',
    'pages/syntheticChi/node022',
    'pages/syntheticChi/node023',
    'pages/syntheticChi/node024',
    'pages/syntheticChi/node025',
    'pages/syntheticChi/node026',
    'pages/syntheticChi/node027',
    'pages/syntheticChi/node028',
    'pages/syntheticChi/node029',
    'pages/syntheticChi/node030',
    'pages/syntheticChi/node031',
    'pages/syntheticChi/node032',
    'pages/syntheticChi/node033',
    'pages/syntheticChi/node034',
    'pages/syntheticChi/node035',
    'pages/syntheticChi/node036',
    'pages/syntheticChi/node037',
    'pages/syntheticChi/node038',
    'pages/syntheticChi/node039',
    'pages/syntheticChi/node040',
    'pages/syntheticChi/node041',
    'pages/syntheticChi/node042',
    'pages/syntheticChi/node043',
    'pages/syntheticChi/node044',
    'pages/syntheticChi/node045',
    'pages/syntheticChi/node046',
    'pages/syntheticChi/node047',
    'pages/syntheticChi/node048',
    'pages/syntheticChi/node049',
    'pages/syntheticChi/node050',
    'pages/syntheticChi/node051',
    'pages/syntheticChi/node052',
    'pages/syntheticChi/node053',
    'pages/syntheticChi/node054',
    'pages/syntheticChi/node055',
    'pages/syntheticChi/node056',
    'pages/syntheticChi/node057',
    'pages/syntheticChi/node058',
    'pages/syntheticChi/node059',
    'pages/syntheticChi/node060',
    'pages/syntheticChi/node061',
    'pages/syntheticChi/node062',
    'pages/syntheticChi/node063',
    'pages/syntheticChi/node064',
    'pages/syntheticChi/node065',
    'pages/syntheticChi/node066',
    'pages/syntheticChi/node067',
    'pages/syntheticChi/node068',
    'pages/syntheticChi/node069',
    'pages/syntheticChi/node070',
    'pages/syntheticChi/node071',
    'pages/syntheticChi/node072',
    'pages/syntheticChi/node073',
    'pages/syntheticChi/node074',
    'pages/syntheticChi/node075',
    'pages/syntheticChi/node076',
    'pages/syntheticChi/node077',
    'pages/syntheticChi/node078',
    'pages/syntheticChi/node079',
    'pages/syntheticChi/node080',
    'pages/syntheticChi/node081',
    'pages/syntheticChi/node082',
    'pages/syntheticChi/node083',
    'pages/syntheticChi/node084',
    'pages/syntheticChi/node085',
    'pages/syntheticChi/node086',
    'pages/syntheticChi/node087',
    'pages/syntheticChi/node088',
    'pages/syntheticChi/node089',
    'pages/syntheticChi/node090',
    'pages/syntheticChi/node091',
    'pages/syntheticChi/node092',
    'pages/syntheticChi/node093',
    'pages/syntheticChi/node094',
    'pages/syntheticChi/node095',
    'pages/syntheticChi/node096',
    'pages/syntheticChi/node097',
    'pages/syntheticChi/node098',
    'pages/syntheticChi/node099',
    'pages/syntheticChi/node100',
    'pages/syntheticChi/node101',
    'pages/syntheticChi/node102',
    'pages/syntheticChi/node103',
    'pages/syntheticChi/node104',
    'pages/syntheticChi/node105',
    'pages/syntheticChi/node106',
    'pages/syntheticChi/node107',
    'pages/syntheticChi/node108',
    'pages/syntheticChi/node109',
    'pages/syntheticChi/node110',
    'pages/syntheticChi/node111',
    'pages/syntheticChi/node112',
    'pages/syntheticChi/node113',
    'pages/syntheticChi/node114',
    'pages/syntheticChi/node115',
    'pages/syntheticChi/node116',
    'pages/syntheticChi/node117',
    'pages/syntheticChi/node118',
    'pages/syntheticChi/node119',
    'pages/syntheticChi/node120',
    'pages/syntheticChi/node121',
    'pages/syntheticChi/node122',
    'pages/syntheticChi/node123',
    'pages/syntheticChi/node124',
    'pages/syntheticChi/node125',
    'pages/syntheticChi/node126',
    'pages/syntheticChi/node127',
    'pages/syntheticChi/node128',
    'pages/syntheticChi/node129',
    'pages/syntheticChi/node130',
    'pages/syntheticChi/node131',
    'pages/syntheticChi/node132',
    'pages/syntheticChi/node133',
    'pages/syntheticChi/node134',
    'pages/syntheticChi/node135',
    'pages/syntheticChi/node136',
    'pages/syntheticChi/node137',
    'pages/syntheticChi/node138',
    'pages/syntheticChi/node139',
    'pages/syntheticChi/node140',
    'pages/syntheticChi/node141',
    'pages/syntheticChi/node142',
    'pages/syntheticChi/node143',
    'pages/syntheticChi/node144',
    'pages/syntheticChi/node145',
    'pages/syntheticChi/node146',
    'pages/syntheticChi/node147',
    'pages/syntheticChi/node148',
    'pages/syntheticChi/node149',
    'pages/syntheticChi/node150',
    'pages/syntheticChi/node151',
    'pages/syntheticChi/node152',
    'pages/syntheticChi/node153',
    'pages/syntheticChi/node154',
    'pages/syntheticChi/node155',
    'pages/syntheticChi/node156',
    'pages/syntheticChi/node157',
    'pages/syntheticChi/node158',
    'pages/syntheticChi/node159',
    'pages/syntheticChi/node160'
  ];

  describe('MegaSyntheticRouteAtlasChiSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteChi_[A-Za-z0-9_]+_[0-9]{3}$/;
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

