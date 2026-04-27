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
  return /^pages\/syntheticJade\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasJadeTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteJade_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticJade/node001',
    'pages/syntheticJade/node002',
    'pages/syntheticJade/node003',
    'pages/syntheticJade/node004',
    'pages/syntheticJade/node005',
    'pages/syntheticJade/node006',
    'pages/syntheticJade/node007',
    'pages/syntheticJade/node008',
    'pages/syntheticJade/node009',
    'pages/syntheticJade/node010',
    'pages/syntheticJade/node011',
    'pages/syntheticJade/node012',
    'pages/syntheticJade/node013',
    'pages/syntheticJade/node014',
    'pages/syntheticJade/node015',
    'pages/syntheticJade/node016',
    'pages/syntheticJade/node017',
    'pages/syntheticJade/node018',
    'pages/syntheticJade/node019',
    'pages/syntheticJade/node020',
    'pages/syntheticJade/node021',
    'pages/syntheticJade/node022',
    'pages/syntheticJade/node023',
    'pages/syntheticJade/node024',
    'pages/syntheticJade/node025',
    'pages/syntheticJade/node026',
    'pages/syntheticJade/node027',
    'pages/syntheticJade/node028',
    'pages/syntheticJade/node029',
    'pages/syntheticJade/node030',
    'pages/syntheticJade/node031',
    'pages/syntheticJade/node032',
    'pages/syntheticJade/node033',
    'pages/syntheticJade/node034',
    'pages/syntheticJade/node035',
    'pages/syntheticJade/node036',
    'pages/syntheticJade/node037',
    'pages/syntheticJade/node038',
    'pages/syntheticJade/node039',
    'pages/syntheticJade/node040',
    'pages/syntheticJade/node041',
    'pages/syntheticJade/node042',
    'pages/syntheticJade/node043',
    'pages/syntheticJade/node044',
    'pages/syntheticJade/node045',
    'pages/syntheticJade/node046',
    'pages/syntheticJade/node047',
    'pages/syntheticJade/node048',
    'pages/syntheticJade/node049',
    'pages/syntheticJade/node050',
    'pages/syntheticJade/node051',
    'pages/syntheticJade/node052',
    'pages/syntheticJade/node053',
    'pages/syntheticJade/node054',
    'pages/syntheticJade/node055',
    'pages/syntheticJade/node056',
    'pages/syntheticJade/node057',
    'pages/syntheticJade/node058',
    'pages/syntheticJade/node059',
    'pages/syntheticJade/node060',
    'pages/syntheticJade/node061',
    'pages/syntheticJade/node062',
    'pages/syntheticJade/node063',
    'pages/syntheticJade/node064',
    'pages/syntheticJade/node065',
    'pages/syntheticJade/node066',
    'pages/syntheticJade/node067',
    'pages/syntheticJade/node068',
    'pages/syntheticJade/node069',
    'pages/syntheticJade/node070',
    'pages/syntheticJade/node071',
    'pages/syntheticJade/node072',
    'pages/syntheticJade/node073',
    'pages/syntheticJade/node074',
    'pages/syntheticJade/node075',
    'pages/syntheticJade/node076',
    'pages/syntheticJade/node077',
    'pages/syntheticJade/node078',
    'pages/syntheticJade/node079',
    'pages/syntheticJade/node080',
    'pages/syntheticJade/node081',
    'pages/syntheticJade/node082',
    'pages/syntheticJade/node083',
    'pages/syntheticJade/node084',
    'pages/syntheticJade/node085',
    'pages/syntheticJade/node086',
    'pages/syntheticJade/node087',
    'pages/syntheticJade/node088',
    'pages/syntheticJade/node089',
    'pages/syntheticJade/node090',
    'pages/syntheticJade/node091',
    'pages/syntheticJade/node092',
    'pages/syntheticJade/node093',
    'pages/syntheticJade/node094',
    'pages/syntheticJade/node095',
    'pages/syntheticJade/node096',
    'pages/syntheticJade/node097',
    'pages/syntheticJade/node098',
    'pages/syntheticJade/node099',
    'pages/syntheticJade/node100',
    'pages/syntheticJade/node101',
    'pages/syntheticJade/node102',
    'pages/syntheticJade/node103',
    'pages/syntheticJade/node104',
    'pages/syntheticJade/node105',
    'pages/syntheticJade/node106',
    'pages/syntheticJade/node107',
    'pages/syntheticJade/node108',
    'pages/syntheticJade/node109',
    'pages/syntheticJade/node110',
    'pages/syntheticJade/node111',
    'pages/syntheticJade/node112',
    'pages/syntheticJade/node113',
    'pages/syntheticJade/node114',
    'pages/syntheticJade/node115',
    'pages/syntheticJade/node116',
    'pages/syntheticJade/node117',
    'pages/syntheticJade/node118',
    'pages/syntheticJade/node119',
    'pages/syntheticJade/node120',
    'pages/syntheticJade/node121',
    'pages/syntheticJade/node122',
    'pages/syntheticJade/node123',
    'pages/syntheticJade/node124',
    'pages/syntheticJade/node125',
    'pages/syntheticJade/node126',
    'pages/syntheticJade/node127',
    'pages/syntheticJade/node128',
    'pages/syntheticJade/node129',
    'pages/syntheticJade/node130',
    'pages/syntheticJade/node131',
    'pages/syntheticJade/node132',
    'pages/syntheticJade/node133',
    'pages/syntheticJade/node134',
    'pages/syntheticJade/node135',
    'pages/syntheticJade/node136',
    'pages/syntheticJade/node137',
    'pages/syntheticJade/node138',
    'pages/syntheticJade/node139',
    'pages/syntheticJade/node140',
    'pages/syntheticJade/node141',
    'pages/syntheticJade/node142',
    'pages/syntheticJade/node143',
    'pages/syntheticJade/node144',
    'pages/syntheticJade/node145',
    'pages/syntheticJade/node146',
    'pages/syntheticJade/node147',
    'pages/syntheticJade/node148',
    'pages/syntheticJade/node149',
    'pages/syntheticJade/node150',
    'pages/syntheticJade/node151',
    'pages/syntheticJade/node152',
    'pages/syntheticJade/node153',
    'pages/syntheticJade/node154',
    'pages/syntheticJade/node155',
    'pages/syntheticJade/node156',
    'pages/syntheticJade/node157',
    'pages/syntheticJade/node158',
    'pages/syntheticJade/node159',
    'pages/syntheticJade/node160'
  ];

  describe('MegaSyntheticRouteAtlasJadeSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteJade_[A-Za-z0-9_]+_[0-9]{3}$/;
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

