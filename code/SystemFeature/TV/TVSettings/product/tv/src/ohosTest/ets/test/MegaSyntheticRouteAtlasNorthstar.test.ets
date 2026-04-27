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
  return /^pages\/syntheticNorthstar\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasNorthstarTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteNorthstar_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticNorthstar/node001',
    'pages/syntheticNorthstar/node002',
    'pages/syntheticNorthstar/node003',
    'pages/syntheticNorthstar/node004',
    'pages/syntheticNorthstar/node005',
    'pages/syntheticNorthstar/node006',
    'pages/syntheticNorthstar/node007',
    'pages/syntheticNorthstar/node008',
    'pages/syntheticNorthstar/node009',
    'pages/syntheticNorthstar/node010',
    'pages/syntheticNorthstar/node011',
    'pages/syntheticNorthstar/node012',
    'pages/syntheticNorthstar/node013',
    'pages/syntheticNorthstar/node014',
    'pages/syntheticNorthstar/node015',
    'pages/syntheticNorthstar/node016',
    'pages/syntheticNorthstar/node017',
    'pages/syntheticNorthstar/node018',
    'pages/syntheticNorthstar/node019',
    'pages/syntheticNorthstar/node020',
    'pages/syntheticNorthstar/node021',
    'pages/syntheticNorthstar/node022',
    'pages/syntheticNorthstar/node023',
    'pages/syntheticNorthstar/node024',
    'pages/syntheticNorthstar/node025',
    'pages/syntheticNorthstar/node026',
    'pages/syntheticNorthstar/node027',
    'pages/syntheticNorthstar/node028',
    'pages/syntheticNorthstar/node029',
    'pages/syntheticNorthstar/node030',
    'pages/syntheticNorthstar/node031',
    'pages/syntheticNorthstar/node032',
    'pages/syntheticNorthstar/node033',
    'pages/syntheticNorthstar/node034',
    'pages/syntheticNorthstar/node035',
    'pages/syntheticNorthstar/node036',
    'pages/syntheticNorthstar/node037',
    'pages/syntheticNorthstar/node038',
    'pages/syntheticNorthstar/node039',
    'pages/syntheticNorthstar/node040',
    'pages/syntheticNorthstar/node041',
    'pages/syntheticNorthstar/node042',
    'pages/syntheticNorthstar/node043',
    'pages/syntheticNorthstar/node044',
    'pages/syntheticNorthstar/node045',
    'pages/syntheticNorthstar/node046',
    'pages/syntheticNorthstar/node047',
    'pages/syntheticNorthstar/node048',
    'pages/syntheticNorthstar/node049',
    'pages/syntheticNorthstar/node050',
    'pages/syntheticNorthstar/node051',
    'pages/syntheticNorthstar/node052',
    'pages/syntheticNorthstar/node053',
    'pages/syntheticNorthstar/node054',
    'pages/syntheticNorthstar/node055',
    'pages/syntheticNorthstar/node056',
    'pages/syntheticNorthstar/node057',
    'pages/syntheticNorthstar/node058',
    'pages/syntheticNorthstar/node059',
    'pages/syntheticNorthstar/node060',
    'pages/syntheticNorthstar/node061',
    'pages/syntheticNorthstar/node062',
    'pages/syntheticNorthstar/node063',
    'pages/syntheticNorthstar/node064',
    'pages/syntheticNorthstar/node065',
    'pages/syntheticNorthstar/node066',
    'pages/syntheticNorthstar/node067',
    'pages/syntheticNorthstar/node068',
    'pages/syntheticNorthstar/node069',
    'pages/syntheticNorthstar/node070',
    'pages/syntheticNorthstar/node071',
    'pages/syntheticNorthstar/node072',
    'pages/syntheticNorthstar/node073',
    'pages/syntheticNorthstar/node074',
    'pages/syntheticNorthstar/node075',
    'pages/syntheticNorthstar/node076',
    'pages/syntheticNorthstar/node077',
    'pages/syntheticNorthstar/node078',
    'pages/syntheticNorthstar/node079',
    'pages/syntheticNorthstar/node080',
    'pages/syntheticNorthstar/node081',
    'pages/syntheticNorthstar/node082',
    'pages/syntheticNorthstar/node083',
    'pages/syntheticNorthstar/node084',
    'pages/syntheticNorthstar/node085',
    'pages/syntheticNorthstar/node086',
    'pages/syntheticNorthstar/node087',
    'pages/syntheticNorthstar/node088',
    'pages/syntheticNorthstar/node089',
    'pages/syntheticNorthstar/node090',
    'pages/syntheticNorthstar/node091',
    'pages/syntheticNorthstar/node092',
    'pages/syntheticNorthstar/node093',
    'pages/syntheticNorthstar/node094',
    'pages/syntheticNorthstar/node095',
    'pages/syntheticNorthstar/node096',
    'pages/syntheticNorthstar/node097',
    'pages/syntheticNorthstar/node098',
    'pages/syntheticNorthstar/node099',
    'pages/syntheticNorthstar/node100',
    'pages/syntheticNorthstar/node101',
    'pages/syntheticNorthstar/node102',
    'pages/syntheticNorthstar/node103',
    'pages/syntheticNorthstar/node104',
    'pages/syntheticNorthstar/node105',
    'pages/syntheticNorthstar/node106',
    'pages/syntheticNorthstar/node107',
    'pages/syntheticNorthstar/node108',
    'pages/syntheticNorthstar/node109',
    'pages/syntheticNorthstar/node110',
    'pages/syntheticNorthstar/node111',
    'pages/syntheticNorthstar/node112',
    'pages/syntheticNorthstar/node113',
    'pages/syntheticNorthstar/node114',
    'pages/syntheticNorthstar/node115',
    'pages/syntheticNorthstar/node116',
    'pages/syntheticNorthstar/node117',
    'pages/syntheticNorthstar/node118',
    'pages/syntheticNorthstar/node119',
    'pages/syntheticNorthstar/node120',
    'pages/syntheticNorthstar/node121',
    'pages/syntheticNorthstar/node122',
    'pages/syntheticNorthstar/node123',
    'pages/syntheticNorthstar/node124',
    'pages/syntheticNorthstar/node125',
    'pages/syntheticNorthstar/node126',
    'pages/syntheticNorthstar/node127',
    'pages/syntheticNorthstar/node128',
    'pages/syntheticNorthstar/node129',
    'pages/syntheticNorthstar/node130',
    'pages/syntheticNorthstar/node131',
    'pages/syntheticNorthstar/node132',
    'pages/syntheticNorthstar/node133',
    'pages/syntheticNorthstar/node134',
    'pages/syntheticNorthstar/node135',
    'pages/syntheticNorthstar/node136',
    'pages/syntheticNorthstar/node137',
    'pages/syntheticNorthstar/node138',
    'pages/syntheticNorthstar/node139',
    'pages/syntheticNorthstar/node140',
    'pages/syntheticNorthstar/node141',
    'pages/syntheticNorthstar/node142',
    'pages/syntheticNorthstar/node143',
    'pages/syntheticNorthstar/node144',
    'pages/syntheticNorthstar/node145',
    'pages/syntheticNorthstar/node146',
    'pages/syntheticNorthstar/node147',
    'pages/syntheticNorthstar/node148',
    'pages/syntheticNorthstar/node149',
    'pages/syntheticNorthstar/node150',
    'pages/syntheticNorthstar/node151',
    'pages/syntheticNorthstar/node152',
    'pages/syntheticNorthstar/node153',
    'pages/syntheticNorthstar/node154',
    'pages/syntheticNorthstar/node155',
    'pages/syntheticNorthstar/node156',
    'pages/syntheticNorthstar/node157',
    'pages/syntheticNorthstar/node158',
    'pages/syntheticNorthstar/node159',
    'pages/syntheticNorthstar/node160'
  ];

  describe('MegaSyntheticRouteAtlasNorthstarSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteNorthstar_[A-Za-z0-9_]+_[0-9]{3}$/;
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

