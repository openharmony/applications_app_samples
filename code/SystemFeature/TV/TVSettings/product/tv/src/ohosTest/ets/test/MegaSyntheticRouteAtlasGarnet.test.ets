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
  return /^pages\/syntheticGarnet\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasGarnetTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteGarnet_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticGarnet/node001',
    'pages/syntheticGarnet/node002',
    'pages/syntheticGarnet/node003',
    'pages/syntheticGarnet/node004',
    'pages/syntheticGarnet/node005',
    'pages/syntheticGarnet/node006',
    'pages/syntheticGarnet/node007',
    'pages/syntheticGarnet/node008',
    'pages/syntheticGarnet/node009',
    'pages/syntheticGarnet/node010',
    'pages/syntheticGarnet/node011',
    'pages/syntheticGarnet/node012',
    'pages/syntheticGarnet/node013',
    'pages/syntheticGarnet/node014',
    'pages/syntheticGarnet/node015',
    'pages/syntheticGarnet/node016',
    'pages/syntheticGarnet/node017',
    'pages/syntheticGarnet/node018',
    'pages/syntheticGarnet/node019',
    'pages/syntheticGarnet/node020',
    'pages/syntheticGarnet/node021',
    'pages/syntheticGarnet/node022',
    'pages/syntheticGarnet/node023',
    'pages/syntheticGarnet/node024',
    'pages/syntheticGarnet/node025',
    'pages/syntheticGarnet/node026',
    'pages/syntheticGarnet/node027',
    'pages/syntheticGarnet/node028',
    'pages/syntheticGarnet/node029',
    'pages/syntheticGarnet/node030',
    'pages/syntheticGarnet/node031',
    'pages/syntheticGarnet/node032',
    'pages/syntheticGarnet/node033',
    'pages/syntheticGarnet/node034',
    'pages/syntheticGarnet/node035',
    'pages/syntheticGarnet/node036',
    'pages/syntheticGarnet/node037',
    'pages/syntheticGarnet/node038',
    'pages/syntheticGarnet/node039',
    'pages/syntheticGarnet/node040',
    'pages/syntheticGarnet/node041',
    'pages/syntheticGarnet/node042',
    'pages/syntheticGarnet/node043',
    'pages/syntheticGarnet/node044',
    'pages/syntheticGarnet/node045',
    'pages/syntheticGarnet/node046',
    'pages/syntheticGarnet/node047',
    'pages/syntheticGarnet/node048',
    'pages/syntheticGarnet/node049',
    'pages/syntheticGarnet/node050',
    'pages/syntheticGarnet/node051',
    'pages/syntheticGarnet/node052',
    'pages/syntheticGarnet/node053',
    'pages/syntheticGarnet/node054',
    'pages/syntheticGarnet/node055',
    'pages/syntheticGarnet/node056',
    'pages/syntheticGarnet/node057',
    'pages/syntheticGarnet/node058',
    'pages/syntheticGarnet/node059',
    'pages/syntheticGarnet/node060',
    'pages/syntheticGarnet/node061',
    'pages/syntheticGarnet/node062',
    'pages/syntheticGarnet/node063',
    'pages/syntheticGarnet/node064',
    'pages/syntheticGarnet/node065',
    'pages/syntheticGarnet/node066',
    'pages/syntheticGarnet/node067',
    'pages/syntheticGarnet/node068',
    'pages/syntheticGarnet/node069',
    'pages/syntheticGarnet/node070',
    'pages/syntheticGarnet/node071',
    'pages/syntheticGarnet/node072',
    'pages/syntheticGarnet/node073',
    'pages/syntheticGarnet/node074',
    'pages/syntheticGarnet/node075',
    'pages/syntheticGarnet/node076',
    'pages/syntheticGarnet/node077',
    'pages/syntheticGarnet/node078',
    'pages/syntheticGarnet/node079',
    'pages/syntheticGarnet/node080',
    'pages/syntheticGarnet/node081',
    'pages/syntheticGarnet/node082',
    'pages/syntheticGarnet/node083',
    'pages/syntheticGarnet/node084',
    'pages/syntheticGarnet/node085',
    'pages/syntheticGarnet/node086',
    'pages/syntheticGarnet/node087',
    'pages/syntheticGarnet/node088',
    'pages/syntheticGarnet/node089',
    'pages/syntheticGarnet/node090',
    'pages/syntheticGarnet/node091',
    'pages/syntheticGarnet/node092',
    'pages/syntheticGarnet/node093',
    'pages/syntheticGarnet/node094',
    'pages/syntheticGarnet/node095',
    'pages/syntheticGarnet/node096',
    'pages/syntheticGarnet/node097',
    'pages/syntheticGarnet/node098',
    'pages/syntheticGarnet/node099',
    'pages/syntheticGarnet/node100',
    'pages/syntheticGarnet/node101',
    'pages/syntheticGarnet/node102',
    'pages/syntheticGarnet/node103',
    'pages/syntheticGarnet/node104',
    'pages/syntheticGarnet/node105',
    'pages/syntheticGarnet/node106',
    'pages/syntheticGarnet/node107',
    'pages/syntheticGarnet/node108',
    'pages/syntheticGarnet/node109',
    'pages/syntheticGarnet/node110',
    'pages/syntheticGarnet/node111',
    'pages/syntheticGarnet/node112',
    'pages/syntheticGarnet/node113',
    'pages/syntheticGarnet/node114',
    'pages/syntheticGarnet/node115',
    'pages/syntheticGarnet/node116',
    'pages/syntheticGarnet/node117',
    'pages/syntheticGarnet/node118',
    'pages/syntheticGarnet/node119',
    'pages/syntheticGarnet/node120',
    'pages/syntheticGarnet/node121',
    'pages/syntheticGarnet/node122',
    'pages/syntheticGarnet/node123',
    'pages/syntheticGarnet/node124',
    'pages/syntheticGarnet/node125',
    'pages/syntheticGarnet/node126',
    'pages/syntheticGarnet/node127',
    'pages/syntheticGarnet/node128',
    'pages/syntheticGarnet/node129',
    'pages/syntheticGarnet/node130',
    'pages/syntheticGarnet/node131',
    'pages/syntheticGarnet/node132',
    'pages/syntheticGarnet/node133',
    'pages/syntheticGarnet/node134',
    'pages/syntheticGarnet/node135',
    'pages/syntheticGarnet/node136',
    'pages/syntheticGarnet/node137',
    'pages/syntheticGarnet/node138',
    'pages/syntheticGarnet/node139',
    'pages/syntheticGarnet/node140',
    'pages/syntheticGarnet/node141',
    'pages/syntheticGarnet/node142',
    'pages/syntheticGarnet/node143',
    'pages/syntheticGarnet/node144',
    'pages/syntheticGarnet/node145',
    'pages/syntheticGarnet/node146',
    'pages/syntheticGarnet/node147',
    'pages/syntheticGarnet/node148',
    'pages/syntheticGarnet/node149',
    'pages/syntheticGarnet/node150',
    'pages/syntheticGarnet/node151',
    'pages/syntheticGarnet/node152',
    'pages/syntheticGarnet/node153',
    'pages/syntheticGarnet/node154',
    'pages/syntheticGarnet/node155',
    'pages/syntheticGarnet/node156',
    'pages/syntheticGarnet/node157',
    'pages/syntheticGarnet/node158',
    'pages/syntheticGarnet/node159',
    'pages/syntheticGarnet/node160'
  ];

  describe('MegaSyntheticRouteAtlasGarnetSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteGarnet_[A-Za-z0-9_]+_[0-9]{3}$/;
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

