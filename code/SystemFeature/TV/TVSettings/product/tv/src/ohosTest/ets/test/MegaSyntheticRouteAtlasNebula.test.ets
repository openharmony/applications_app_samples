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
  return /^pages\/syntheticNebula\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasNebulaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteNebula_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticNebula/node001',
    'pages/syntheticNebula/node002',
    'pages/syntheticNebula/node003',
    'pages/syntheticNebula/node004',
    'pages/syntheticNebula/node005',
    'pages/syntheticNebula/node006',
    'pages/syntheticNebula/node007',
    'pages/syntheticNebula/node008',
    'pages/syntheticNebula/node009',
    'pages/syntheticNebula/node010',
    'pages/syntheticNebula/node011',
    'pages/syntheticNebula/node012',
    'pages/syntheticNebula/node013',
    'pages/syntheticNebula/node014',
    'pages/syntheticNebula/node015',
    'pages/syntheticNebula/node016',
    'pages/syntheticNebula/node017',
    'pages/syntheticNebula/node018',
    'pages/syntheticNebula/node019',
    'pages/syntheticNebula/node020',
    'pages/syntheticNebula/node021',
    'pages/syntheticNebula/node022',
    'pages/syntheticNebula/node023',
    'pages/syntheticNebula/node024',
    'pages/syntheticNebula/node025',
    'pages/syntheticNebula/node026',
    'pages/syntheticNebula/node027',
    'pages/syntheticNebula/node028',
    'pages/syntheticNebula/node029',
    'pages/syntheticNebula/node030',
    'pages/syntheticNebula/node031',
    'pages/syntheticNebula/node032',
    'pages/syntheticNebula/node033',
    'pages/syntheticNebula/node034',
    'pages/syntheticNebula/node035',
    'pages/syntheticNebula/node036',
    'pages/syntheticNebula/node037',
    'pages/syntheticNebula/node038',
    'pages/syntheticNebula/node039',
    'pages/syntheticNebula/node040',
    'pages/syntheticNebula/node041',
    'pages/syntheticNebula/node042',
    'pages/syntheticNebula/node043',
    'pages/syntheticNebula/node044',
    'pages/syntheticNebula/node045',
    'pages/syntheticNebula/node046',
    'pages/syntheticNebula/node047',
    'pages/syntheticNebula/node048',
    'pages/syntheticNebula/node049',
    'pages/syntheticNebula/node050',
    'pages/syntheticNebula/node051',
    'pages/syntheticNebula/node052',
    'pages/syntheticNebula/node053',
    'pages/syntheticNebula/node054',
    'pages/syntheticNebula/node055',
    'pages/syntheticNebula/node056',
    'pages/syntheticNebula/node057',
    'pages/syntheticNebula/node058',
    'pages/syntheticNebula/node059',
    'pages/syntheticNebula/node060',
    'pages/syntheticNebula/node061',
    'pages/syntheticNebula/node062',
    'pages/syntheticNebula/node063',
    'pages/syntheticNebula/node064',
    'pages/syntheticNebula/node065',
    'pages/syntheticNebula/node066',
    'pages/syntheticNebula/node067',
    'pages/syntheticNebula/node068',
    'pages/syntheticNebula/node069',
    'pages/syntheticNebula/node070',
    'pages/syntheticNebula/node071',
    'pages/syntheticNebula/node072',
    'pages/syntheticNebula/node073',
    'pages/syntheticNebula/node074',
    'pages/syntheticNebula/node075',
    'pages/syntheticNebula/node076',
    'pages/syntheticNebula/node077',
    'pages/syntheticNebula/node078',
    'pages/syntheticNebula/node079',
    'pages/syntheticNebula/node080',
    'pages/syntheticNebula/node081',
    'pages/syntheticNebula/node082',
    'pages/syntheticNebula/node083',
    'pages/syntheticNebula/node084',
    'pages/syntheticNebula/node085',
    'pages/syntheticNebula/node086',
    'pages/syntheticNebula/node087',
    'pages/syntheticNebula/node088',
    'pages/syntheticNebula/node089',
    'pages/syntheticNebula/node090',
    'pages/syntheticNebula/node091',
    'pages/syntheticNebula/node092',
    'pages/syntheticNebula/node093',
    'pages/syntheticNebula/node094',
    'pages/syntheticNebula/node095',
    'pages/syntheticNebula/node096',
    'pages/syntheticNebula/node097',
    'pages/syntheticNebula/node098',
    'pages/syntheticNebula/node099',
    'pages/syntheticNebula/node100',
    'pages/syntheticNebula/node101',
    'pages/syntheticNebula/node102',
    'pages/syntheticNebula/node103',
    'pages/syntheticNebula/node104',
    'pages/syntheticNebula/node105',
    'pages/syntheticNebula/node106',
    'pages/syntheticNebula/node107',
    'pages/syntheticNebula/node108',
    'pages/syntheticNebula/node109',
    'pages/syntheticNebula/node110',
    'pages/syntheticNebula/node111',
    'pages/syntheticNebula/node112',
    'pages/syntheticNebula/node113',
    'pages/syntheticNebula/node114',
    'pages/syntheticNebula/node115',
    'pages/syntheticNebula/node116',
    'pages/syntheticNebula/node117',
    'pages/syntheticNebula/node118',
    'pages/syntheticNebula/node119',
    'pages/syntheticNebula/node120',
    'pages/syntheticNebula/node121',
    'pages/syntheticNebula/node122',
    'pages/syntheticNebula/node123',
    'pages/syntheticNebula/node124',
    'pages/syntheticNebula/node125',
    'pages/syntheticNebula/node126',
    'pages/syntheticNebula/node127',
    'pages/syntheticNebula/node128',
    'pages/syntheticNebula/node129',
    'pages/syntheticNebula/node130',
    'pages/syntheticNebula/node131',
    'pages/syntheticNebula/node132',
    'pages/syntheticNebula/node133',
    'pages/syntheticNebula/node134',
    'pages/syntheticNebula/node135',
    'pages/syntheticNebula/node136',
    'pages/syntheticNebula/node137',
    'pages/syntheticNebula/node138',
    'pages/syntheticNebula/node139',
    'pages/syntheticNebula/node140',
    'pages/syntheticNebula/node141',
    'pages/syntheticNebula/node142',
    'pages/syntheticNebula/node143',
    'pages/syntheticNebula/node144',
    'pages/syntheticNebula/node145',
    'pages/syntheticNebula/node146',
    'pages/syntheticNebula/node147',
    'pages/syntheticNebula/node148',
    'pages/syntheticNebula/node149',
    'pages/syntheticNebula/node150',
    'pages/syntheticNebula/node151',
    'pages/syntheticNebula/node152',
    'pages/syntheticNebula/node153',
    'pages/syntheticNebula/node154',
    'pages/syntheticNebula/node155',
    'pages/syntheticNebula/node156',
    'pages/syntheticNebula/node157',
    'pages/syntheticNebula/node158',
    'pages/syntheticNebula/node159',
    'pages/syntheticNebula/node160'
  ];

  describe('MegaSyntheticRouteAtlasNebulaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteNebula_[A-Za-z0-9_]+_[0-9]{3}$/;
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

