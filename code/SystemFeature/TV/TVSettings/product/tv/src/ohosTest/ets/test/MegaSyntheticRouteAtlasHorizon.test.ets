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
  return /^pages\/syntheticHorizon\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasHorizonTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteHorizon_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticHorizon/node001',
    'pages/syntheticHorizon/node002',
    'pages/syntheticHorizon/node003',
    'pages/syntheticHorizon/node004',
    'pages/syntheticHorizon/node005',
    'pages/syntheticHorizon/node006',
    'pages/syntheticHorizon/node007',
    'pages/syntheticHorizon/node008',
    'pages/syntheticHorizon/node009',
    'pages/syntheticHorizon/node010',
    'pages/syntheticHorizon/node011',
    'pages/syntheticHorizon/node012',
    'pages/syntheticHorizon/node013',
    'pages/syntheticHorizon/node014',
    'pages/syntheticHorizon/node015',
    'pages/syntheticHorizon/node016',
    'pages/syntheticHorizon/node017',
    'pages/syntheticHorizon/node018',
    'pages/syntheticHorizon/node019',
    'pages/syntheticHorizon/node020',
    'pages/syntheticHorizon/node021',
    'pages/syntheticHorizon/node022',
    'pages/syntheticHorizon/node023',
    'pages/syntheticHorizon/node024',
    'pages/syntheticHorizon/node025',
    'pages/syntheticHorizon/node026',
    'pages/syntheticHorizon/node027',
    'pages/syntheticHorizon/node028',
    'pages/syntheticHorizon/node029',
    'pages/syntheticHorizon/node030',
    'pages/syntheticHorizon/node031',
    'pages/syntheticHorizon/node032',
    'pages/syntheticHorizon/node033',
    'pages/syntheticHorizon/node034',
    'pages/syntheticHorizon/node035',
    'pages/syntheticHorizon/node036',
    'pages/syntheticHorizon/node037',
    'pages/syntheticHorizon/node038',
    'pages/syntheticHorizon/node039',
    'pages/syntheticHorizon/node040',
    'pages/syntheticHorizon/node041',
    'pages/syntheticHorizon/node042',
    'pages/syntheticHorizon/node043',
    'pages/syntheticHorizon/node044',
    'pages/syntheticHorizon/node045',
    'pages/syntheticHorizon/node046',
    'pages/syntheticHorizon/node047',
    'pages/syntheticHorizon/node048',
    'pages/syntheticHorizon/node049',
    'pages/syntheticHorizon/node050',
    'pages/syntheticHorizon/node051',
    'pages/syntheticHorizon/node052',
    'pages/syntheticHorizon/node053',
    'pages/syntheticHorizon/node054',
    'pages/syntheticHorizon/node055',
    'pages/syntheticHorizon/node056',
    'pages/syntheticHorizon/node057',
    'pages/syntheticHorizon/node058',
    'pages/syntheticHorizon/node059',
    'pages/syntheticHorizon/node060',
    'pages/syntheticHorizon/node061',
    'pages/syntheticHorizon/node062',
    'pages/syntheticHorizon/node063',
    'pages/syntheticHorizon/node064',
    'pages/syntheticHorizon/node065',
    'pages/syntheticHorizon/node066',
    'pages/syntheticHorizon/node067',
    'pages/syntheticHorizon/node068',
    'pages/syntheticHorizon/node069',
    'pages/syntheticHorizon/node070',
    'pages/syntheticHorizon/node071',
    'pages/syntheticHorizon/node072',
    'pages/syntheticHorizon/node073',
    'pages/syntheticHorizon/node074',
    'pages/syntheticHorizon/node075',
    'pages/syntheticHorizon/node076',
    'pages/syntheticHorizon/node077',
    'pages/syntheticHorizon/node078',
    'pages/syntheticHorizon/node079',
    'pages/syntheticHorizon/node080',
    'pages/syntheticHorizon/node081',
    'pages/syntheticHorizon/node082',
    'pages/syntheticHorizon/node083',
    'pages/syntheticHorizon/node084',
    'pages/syntheticHorizon/node085',
    'pages/syntheticHorizon/node086',
    'pages/syntheticHorizon/node087',
    'pages/syntheticHorizon/node088',
    'pages/syntheticHorizon/node089',
    'pages/syntheticHorizon/node090',
    'pages/syntheticHorizon/node091',
    'pages/syntheticHorizon/node092',
    'pages/syntheticHorizon/node093',
    'pages/syntheticHorizon/node094',
    'pages/syntheticHorizon/node095',
    'pages/syntheticHorizon/node096',
    'pages/syntheticHorizon/node097',
    'pages/syntheticHorizon/node098',
    'pages/syntheticHorizon/node099',
    'pages/syntheticHorizon/node100',
    'pages/syntheticHorizon/node101',
    'pages/syntheticHorizon/node102',
    'pages/syntheticHorizon/node103',
    'pages/syntheticHorizon/node104',
    'pages/syntheticHorizon/node105',
    'pages/syntheticHorizon/node106',
    'pages/syntheticHorizon/node107',
    'pages/syntheticHorizon/node108',
    'pages/syntheticHorizon/node109',
    'pages/syntheticHorizon/node110',
    'pages/syntheticHorizon/node111',
    'pages/syntheticHorizon/node112',
    'pages/syntheticHorizon/node113',
    'pages/syntheticHorizon/node114',
    'pages/syntheticHorizon/node115',
    'pages/syntheticHorizon/node116',
    'pages/syntheticHorizon/node117',
    'pages/syntheticHorizon/node118',
    'pages/syntheticHorizon/node119',
    'pages/syntheticHorizon/node120',
    'pages/syntheticHorizon/node121',
    'pages/syntheticHorizon/node122',
    'pages/syntheticHorizon/node123',
    'pages/syntheticHorizon/node124',
    'pages/syntheticHorizon/node125',
    'pages/syntheticHorizon/node126',
    'pages/syntheticHorizon/node127',
    'pages/syntheticHorizon/node128',
    'pages/syntheticHorizon/node129',
    'pages/syntheticHorizon/node130',
    'pages/syntheticHorizon/node131',
    'pages/syntheticHorizon/node132',
    'pages/syntheticHorizon/node133',
    'pages/syntheticHorizon/node134',
    'pages/syntheticHorizon/node135',
    'pages/syntheticHorizon/node136',
    'pages/syntheticHorizon/node137',
    'pages/syntheticHorizon/node138',
    'pages/syntheticHorizon/node139',
    'pages/syntheticHorizon/node140',
    'pages/syntheticHorizon/node141',
    'pages/syntheticHorizon/node142',
    'pages/syntheticHorizon/node143',
    'pages/syntheticHorizon/node144',
    'pages/syntheticHorizon/node145',
    'pages/syntheticHorizon/node146',
    'pages/syntheticHorizon/node147',
    'pages/syntheticHorizon/node148',
    'pages/syntheticHorizon/node149',
    'pages/syntheticHorizon/node150',
    'pages/syntheticHorizon/node151',
    'pages/syntheticHorizon/node152',
    'pages/syntheticHorizon/node153',
    'pages/syntheticHorizon/node154',
    'pages/syntheticHorizon/node155',
    'pages/syntheticHorizon/node156',
    'pages/syntheticHorizon/node157',
    'pages/syntheticHorizon/node158',
    'pages/syntheticHorizon/node159',
    'pages/syntheticHorizon/node160'
  ];

  describe('MegaSyntheticRouteAtlasHorizonSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteHorizon_[A-Za-z0-9_]+_[0-9]{3}$/;
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

