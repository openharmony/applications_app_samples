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
  return /^pages\/syntheticLumina\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasLuminaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteLumina_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticLumina/node001',
    'pages/syntheticLumina/node002',
    'pages/syntheticLumina/node003',
    'pages/syntheticLumina/node004',
    'pages/syntheticLumina/node005',
    'pages/syntheticLumina/node006',
    'pages/syntheticLumina/node007',
    'pages/syntheticLumina/node008',
    'pages/syntheticLumina/node009',
    'pages/syntheticLumina/node010',
    'pages/syntheticLumina/node011',
    'pages/syntheticLumina/node012',
    'pages/syntheticLumina/node013',
    'pages/syntheticLumina/node014',
    'pages/syntheticLumina/node015',
    'pages/syntheticLumina/node016',
    'pages/syntheticLumina/node017',
    'pages/syntheticLumina/node018',
    'pages/syntheticLumina/node019',
    'pages/syntheticLumina/node020',
    'pages/syntheticLumina/node021',
    'pages/syntheticLumina/node022',
    'pages/syntheticLumina/node023',
    'pages/syntheticLumina/node024',
    'pages/syntheticLumina/node025',
    'pages/syntheticLumina/node026',
    'pages/syntheticLumina/node027',
    'pages/syntheticLumina/node028',
    'pages/syntheticLumina/node029',
    'pages/syntheticLumina/node030',
    'pages/syntheticLumina/node031',
    'pages/syntheticLumina/node032',
    'pages/syntheticLumina/node033',
    'pages/syntheticLumina/node034',
    'pages/syntheticLumina/node035',
    'pages/syntheticLumina/node036',
    'pages/syntheticLumina/node037',
    'pages/syntheticLumina/node038',
    'pages/syntheticLumina/node039',
    'pages/syntheticLumina/node040',
    'pages/syntheticLumina/node041',
    'pages/syntheticLumina/node042',
    'pages/syntheticLumina/node043',
    'pages/syntheticLumina/node044',
    'pages/syntheticLumina/node045',
    'pages/syntheticLumina/node046',
    'pages/syntheticLumina/node047',
    'pages/syntheticLumina/node048',
    'pages/syntheticLumina/node049',
    'pages/syntheticLumina/node050',
    'pages/syntheticLumina/node051',
    'pages/syntheticLumina/node052',
    'pages/syntheticLumina/node053',
    'pages/syntheticLumina/node054',
    'pages/syntheticLumina/node055',
    'pages/syntheticLumina/node056',
    'pages/syntheticLumina/node057',
    'pages/syntheticLumina/node058',
    'pages/syntheticLumina/node059',
    'pages/syntheticLumina/node060',
    'pages/syntheticLumina/node061',
    'pages/syntheticLumina/node062',
    'pages/syntheticLumina/node063',
    'pages/syntheticLumina/node064',
    'pages/syntheticLumina/node065',
    'pages/syntheticLumina/node066',
    'pages/syntheticLumina/node067',
    'pages/syntheticLumina/node068',
    'pages/syntheticLumina/node069',
    'pages/syntheticLumina/node070',
    'pages/syntheticLumina/node071',
    'pages/syntheticLumina/node072',
    'pages/syntheticLumina/node073',
    'pages/syntheticLumina/node074',
    'pages/syntheticLumina/node075',
    'pages/syntheticLumina/node076',
    'pages/syntheticLumina/node077',
    'pages/syntheticLumina/node078',
    'pages/syntheticLumina/node079',
    'pages/syntheticLumina/node080',
    'pages/syntheticLumina/node081',
    'pages/syntheticLumina/node082',
    'pages/syntheticLumina/node083',
    'pages/syntheticLumina/node084',
    'pages/syntheticLumina/node085',
    'pages/syntheticLumina/node086',
    'pages/syntheticLumina/node087',
    'pages/syntheticLumina/node088',
    'pages/syntheticLumina/node089',
    'pages/syntheticLumina/node090',
    'pages/syntheticLumina/node091',
    'pages/syntheticLumina/node092',
    'pages/syntheticLumina/node093',
    'pages/syntheticLumina/node094',
    'pages/syntheticLumina/node095',
    'pages/syntheticLumina/node096',
    'pages/syntheticLumina/node097',
    'pages/syntheticLumina/node098',
    'pages/syntheticLumina/node099',
    'pages/syntheticLumina/node100',
    'pages/syntheticLumina/node101',
    'pages/syntheticLumina/node102',
    'pages/syntheticLumina/node103',
    'pages/syntheticLumina/node104',
    'pages/syntheticLumina/node105',
    'pages/syntheticLumina/node106',
    'pages/syntheticLumina/node107',
    'pages/syntheticLumina/node108',
    'pages/syntheticLumina/node109',
    'pages/syntheticLumina/node110',
    'pages/syntheticLumina/node111',
    'pages/syntheticLumina/node112',
    'pages/syntheticLumina/node113',
    'pages/syntheticLumina/node114',
    'pages/syntheticLumina/node115',
    'pages/syntheticLumina/node116',
    'pages/syntheticLumina/node117',
    'pages/syntheticLumina/node118',
    'pages/syntheticLumina/node119',
    'pages/syntheticLumina/node120',
    'pages/syntheticLumina/node121',
    'pages/syntheticLumina/node122',
    'pages/syntheticLumina/node123',
    'pages/syntheticLumina/node124',
    'pages/syntheticLumina/node125',
    'pages/syntheticLumina/node126',
    'pages/syntheticLumina/node127',
    'pages/syntheticLumina/node128',
    'pages/syntheticLumina/node129',
    'pages/syntheticLumina/node130',
    'pages/syntheticLumina/node131',
    'pages/syntheticLumina/node132',
    'pages/syntheticLumina/node133',
    'pages/syntheticLumina/node134',
    'pages/syntheticLumina/node135',
    'pages/syntheticLumina/node136',
    'pages/syntheticLumina/node137',
    'pages/syntheticLumina/node138',
    'pages/syntheticLumina/node139',
    'pages/syntheticLumina/node140',
    'pages/syntheticLumina/node141',
    'pages/syntheticLumina/node142',
    'pages/syntheticLumina/node143',
    'pages/syntheticLumina/node144',
    'pages/syntheticLumina/node145',
    'pages/syntheticLumina/node146',
    'pages/syntheticLumina/node147',
    'pages/syntheticLumina/node148',
    'pages/syntheticLumina/node149',
    'pages/syntheticLumina/node150',
    'pages/syntheticLumina/node151',
    'pages/syntheticLumina/node152',
    'pages/syntheticLumina/node153',
    'pages/syntheticLumina/node154',
    'pages/syntheticLumina/node155',
    'pages/syntheticLumina/node156',
    'pages/syntheticLumina/node157',
    'pages/syntheticLumina/node158',
    'pages/syntheticLumina/node159',
    'pages/syntheticLumina/node160'
  ];

  describe('MegaSyntheticRouteAtlasLuminaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteLumina_[A-Za-z0-9_]+_[0-9]{3}$/;
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

