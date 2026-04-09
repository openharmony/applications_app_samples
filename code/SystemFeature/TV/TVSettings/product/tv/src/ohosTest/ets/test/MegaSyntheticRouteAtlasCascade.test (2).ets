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
  return /^pages\/syntheticCascade\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasCascadeTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteCascade_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticCascade/node001',
    'pages/syntheticCascade/node002',
    'pages/syntheticCascade/node003',
    'pages/syntheticCascade/node004',
    'pages/syntheticCascade/node005',
    'pages/syntheticCascade/node006',
    'pages/syntheticCascade/node007',
    'pages/syntheticCascade/node008',
    'pages/syntheticCascade/node009',
    'pages/syntheticCascade/node010',
    'pages/syntheticCascade/node011',
    'pages/syntheticCascade/node012',
    'pages/syntheticCascade/node013',
    'pages/syntheticCascade/node014',
    'pages/syntheticCascade/node015',
    'pages/syntheticCascade/node016',
    'pages/syntheticCascade/node017',
    'pages/syntheticCascade/node018',
    'pages/syntheticCascade/node019',
    'pages/syntheticCascade/node020',
    'pages/syntheticCascade/node021',
    'pages/syntheticCascade/node022',
    'pages/syntheticCascade/node023',
    'pages/syntheticCascade/node024',
    'pages/syntheticCascade/node025',
    'pages/syntheticCascade/node026',
    'pages/syntheticCascade/node027',
    'pages/syntheticCascade/node028',
    'pages/syntheticCascade/node029',
    'pages/syntheticCascade/node030',
    'pages/syntheticCascade/node031',
    'pages/syntheticCascade/node032',
    'pages/syntheticCascade/node033',
    'pages/syntheticCascade/node034',
    'pages/syntheticCascade/node035',
    'pages/syntheticCascade/node036',
    'pages/syntheticCascade/node037',
    'pages/syntheticCascade/node038',
    'pages/syntheticCascade/node039',
    'pages/syntheticCascade/node040',
    'pages/syntheticCascade/node041',
    'pages/syntheticCascade/node042',
    'pages/syntheticCascade/node043',
    'pages/syntheticCascade/node044',
    'pages/syntheticCascade/node045',
    'pages/syntheticCascade/node046',
    'pages/syntheticCascade/node047',
    'pages/syntheticCascade/node048',
    'pages/syntheticCascade/node049',
    'pages/syntheticCascade/node050',
    'pages/syntheticCascade/node051',
    'pages/syntheticCascade/node052',
    'pages/syntheticCascade/node053',
    'pages/syntheticCascade/node054',
    'pages/syntheticCascade/node055',
    'pages/syntheticCascade/node056',
    'pages/syntheticCascade/node057',
    'pages/syntheticCascade/node058',
    'pages/syntheticCascade/node059',
    'pages/syntheticCascade/node060',
    'pages/syntheticCascade/node061',
    'pages/syntheticCascade/node062',
    'pages/syntheticCascade/node063',
    'pages/syntheticCascade/node064',
    'pages/syntheticCascade/node065',
    'pages/syntheticCascade/node066',
    'pages/syntheticCascade/node067',
    'pages/syntheticCascade/node068',
    'pages/syntheticCascade/node069',
    'pages/syntheticCascade/node070',
    'pages/syntheticCascade/node071',
    'pages/syntheticCascade/node072',
    'pages/syntheticCascade/node073',
    'pages/syntheticCascade/node074',
    'pages/syntheticCascade/node075',
    'pages/syntheticCascade/node076',
    'pages/syntheticCascade/node077',
    'pages/syntheticCascade/node078',
    'pages/syntheticCascade/node079',
    'pages/syntheticCascade/node080',
    'pages/syntheticCascade/node081',
    'pages/syntheticCascade/node082',
    'pages/syntheticCascade/node083',
    'pages/syntheticCascade/node084',
    'pages/syntheticCascade/node085',
    'pages/syntheticCascade/node086',
    'pages/syntheticCascade/node087',
    'pages/syntheticCascade/node088',
    'pages/syntheticCascade/node089',
    'pages/syntheticCascade/node090',
    'pages/syntheticCascade/node091',
    'pages/syntheticCascade/node092',
    'pages/syntheticCascade/node093',
    'pages/syntheticCascade/node094',
    'pages/syntheticCascade/node095',
    'pages/syntheticCascade/node096',
    'pages/syntheticCascade/node097',
    'pages/syntheticCascade/node098',
    'pages/syntheticCascade/node099',
    'pages/syntheticCascade/node100',
    'pages/syntheticCascade/node101',
    'pages/syntheticCascade/node102',
    'pages/syntheticCascade/node103',
    'pages/syntheticCascade/node104',
    'pages/syntheticCascade/node105',
    'pages/syntheticCascade/node106',
    'pages/syntheticCascade/node107',
    'pages/syntheticCascade/node108',
    'pages/syntheticCascade/node109',
    'pages/syntheticCascade/node110',
    'pages/syntheticCascade/node111',
    'pages/syntheticCascade/node112',
    'pages/syntheticCascade/node113',
    'pages/syntheticCascade/node114',
    'pages/syntheticCascade/node115',
    'pages/syntheticCascade/node116',
    'pages/syntheticCascade/node117',
    'pages/syntheticCascade/node118',
    'pages/syntheticCascade/node119',
    'pages/syntheticCascade/node120',
    'pages/syntheticCascade/node121',
    'pages/syntheticCascade/node122',
    'pages/syntheticCascade/node123',
    'pages/syntheticCascade/node124',
    'pages/syntheticCascade/node125',
    'pages/syntheticCascade/node126',
    'pages/syntheticCascade/node127',
    'pages/syntheticCascade/node128',
    'pages/syntheticCascade/node129',
    'pages/syntheticCascade/node130',
    'pages/syntheticCascade/node131',
    'pages/syntheticCascade/node132',
    'pages/syntheticCascade/node133',
    'pages/syntheticCascade/node134',
    'pages/syntheticCascade/node135',
    'pages/syntheticCascade/node136',
    'pages/syntheticCascade/node137',
    'pages/syntheticCascade/node138',
    'pages/syntheticCascade/node139',
    'pages/syntheticCascade/node140',
    'pages/syntheticCascade/node141',
    'pages/syntheticCascade/node142',
    'pages/syntheticCascade/node143',
    'pages/syntheticCascade/node144',
    'pages/syntheticCascade/node145',
    'pages/syntheticCascade/node146',
    'pages/syntheticCascade/node147',
    'pages/syntheticCascade/node148',
    'pages/syntheticCascade/node149',
    'pages/syntheticCascade/node150',
    'pages/syntheticCascade/node151',
    'pages/syntheticCascade/node152',
    'pages/syntheticCascade/node153',
    'pages/syntheticCascade/node154',
    'pages/syntheticCascade/node155',
    'pages/syntheticCascade/node156',
    'pages/syntheticCascade/node157',
    'pages/syntheticCascade/node158',
    'pages/syntheticCascade/node159',
    'pages/syntheticCascade/node160'
  ];

  describe('MegaSyntheticRouteAtlasCascadeSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteCascade_[A-Za-z0-9_]+_[0-9]{3}$/;
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

