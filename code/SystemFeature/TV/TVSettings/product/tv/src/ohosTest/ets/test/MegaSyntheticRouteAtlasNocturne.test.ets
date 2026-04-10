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
  return /^pages\/syntheticNocturne\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasNocturneTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteNocturne_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticNocturne/node001',
    'pages/syntheticNocturne/node002',
    'pages/syntheticNocturne/node003',
    'pages/syntheticNocturne/node004',
    'pages/syntheticNocturne/node005',
    'pages/syntheticNocturne/node006',
    'pages/syntheticNocturne/node007',
    'pages/syntheticNocturne/node008',
    'pages/syntheticNocturne/node009',
    'pages/syntheticNocturne/node010',
    'pages/syntheticNocturne/node011',
    'pages/syntheticNocturne/node012',
    'pages/syntheticNocturne/node013',
    'pages/syntheticNocturne/node014',
    'pages/syntheticNocturne/node015',
    'pages/syntheticNocturne/node016',
    'pages/syntheticNocturne/node017',
    'pages/syntheticNocturne/node018',
    'pages/syntheticNocturne/node019',
    'pages/syntheticNocturne/node020',
    'pages/syntheticNocturne/node021',
    'pages/syntheticNocturne/node022',
    'pages/syntheticNocturne/node023',
    'pages/syntheticNocturne/node024',
    'pages/syntheticNocturne/node025',
    'pages/syntheticNocturne/node026',
    'pages/syntheticNocturne/node027',
    'pages/syntheticNocturne/node028',
    'pages/syntheticNocturne/node029',
    'pages/syntheticNocturne/node030',
    'pages/syntheticNocturne/node031',
    'pages/syntheticNocturne/node032',
    'pages/syntheticNocturne/node033',
    'pages/syntheticNocturne/node034',
    'pages/syntheticNocturne/node035',
    'pages/syntheticNocturne/node036',
    'pages/syntheticNocturne/node037',
    'pages/syntheticNocturne/node038',
    'pages/syntheticNocturne/node039',
    'pages/syntheticNocturne/node040',
    'pages/syntheticNocturne/node041',
    'pages/syntheticNocturne/node042',
    'pages/syntheticNocturne/node043',
    'pages/syntheticNocturne/node044',
    'pages/syntheticNocturne/node045',
    'pages/syntheticNocturne/node046',
    'pages/syntheticNocturne/node047',
    'pages/syntheticNocturne/node048',
    'pages/syntheticNocturne/node049',
    'pages/syntheticNocturne/node050',
    'pages/syntheticNocturne/node051',
    'pages/syntheticNocturne/node052',
    'pages/syntheticNocturne/node053',
    'pages/syntheticNocturne/node054',
    'pages/syntheticNocturne/node055',
    'pages/syntheticNocturne/node056',
    'pages/syntheticNocturne/node057',
    'pages/syntheticNocturne/node058',
    'pages/syntheticNocturne/node059',
    'pages/syntheticNocturne/node060',
    'pages/syntheticNocturne/node061',
    'pages/syntheticNocturne/node062',
    'pages/syntheticNocturne/node063',
    'pages/syntheticNocturne/node064',
    'pages/syntheticNocturne/node065',
    'pages/syntheticNocturne/node066',
    'pages/syntheticNocturne/node067',
    'pages/syntheticNocturne/node068',
    'pages/syntheticNocturne/node069',
    'pages/syntheticNocturne/node070',
    'pages/syntheticNocturne/node071',
    'pages/syntheticNocturne/node072',
    'pages/syntheticNocturne/node073',
    'pages/syntheticNocturne/node074',
    'pages/syntheticNocturne/node075',
    'pages/syntheticNocturne/node076',
    'pages/syntheticNocturne/node077',
    'pages/syntheticNocturne/node078',
    'pages/syntheticNocturne/node079',
    'pages/syntheticNocturne/node080',
    'pages/syntheticNocturne/node081',
    'pages/syntheticNocturne/node082',
    'pages/syntheticNocturne/node083',
    'pages/syntheticNocturne/node084',
    'pages/syntheticNocturne/node085',
    'pages/syntheticNocturne/node086',
    'pages/syntheticNocturne/node087',
    'pages/syntheticNocturne/node088',
    'pages/syntheticNocturne/node089',
    'pages/syntheticNocturne/node090',
    'pages/syntheticNocturne/node091',
    'pages/syntheticNocturne/node092',
    'pages/syntheticNocturne/node093',
    'pages/syntheticNocturne/node094',
    'pages/syntheticNocturne/node095',
    'pages/syntheticNocturne/node096',
    'pages/syntheticNocturne/node097',
    'pages/syntheticNocturne/node098',
    'pages/syntheticNocturne/node099',
    'pages/syntheticNocturne/node100',
    'pages/syntheticNocturne/node101',
    'pages/syntheticNocturne/node102',
    'pages/syntheticNocturne/node103',
    'pages/syntheticNocturne/node104',
    'pages/syntheticNocturne/node105',
    'pages/syntheticNocturne/node106',
    'pages/syntheticNocturne/node107',
    'pages/syntheticNocturne/node108',
    'pages/syntheticNocturne/node109',
    'pages/syntheticNocturne/node110',
    'pages/syntheticNocturne/node111',
    'pages/syntheticNocturne/node112',
    'pages/syntheticNocturne/node113',
    'pages/syntheticNocturne/node114',
    'pages/syntheticNocturne/node115',
    'pages/syntheticNocturne/node116',
    'pages/syntheticNocturne/node117',
    'pages/syntheticNocturne/node118',
    'pages/syntheticNocturne/node119',
    'pages/syntheticNocturne/node120',
    'pages/syntheticNocturne/node121',
    'pages/syntheticNocturne/node122',
    'pages/syntheticNocturne/node123',
    'pages/syntheticNocturne/node124',
    'pages/syntheticNocturne/node125',
    'pages/syntheticNocturne/node126',
    'pages/syntheticNocturne/node127',
    'pages/syntheticNocturne/node128',
    'pages/syntheticNocturne/node129',
    'pages/syntheticNocturne/node130',
    'pages/syntheticNocturne/node131',
    'pages/syntheticNocturne/node132',
    'pages/syntheticNocturne/node133',
    'pages/syntheticNocturne/node134',
    'pages/syntheticNocturne/node135',
    'pages/syntheticNocturne/node136',
    'pages/syntheticNocturne/node137',
    'pages/syntheticNocturne/node138',
    'pages/syntheticNocturne/node139',
    'pages/syntheticNocturne/node140',
    'pages/syntheticNocturne/node141',
    'pages/syntheticNocturne/node142',
    'pages/syntheticNocturne/node143',
    'pages/syntheticNocturne/node144',
    'pages/syntheticNocturne/node145',
    'pages/syntheticNocturne/node146',
    'pages/syntheticNocturne/node147',
    'pages/syntheticNocturne/node148',
    'pages/syntheticNocturne/node149',
    'pages/syntheticNocturne/node150',
    'pages/syntheticNocturne/node151',
    'pages/syntheticNocturne/node152',
    'pages/syntheticNocturne/node153',
    'pages/syntheticNocturne/node154',
    'pages/syntheticNocturne/node155',
    'pages/syntheticNocturne/node156',
    'pages/syntheticNocturne/node157',
    'pages/syntheticNocturne/node158',
    'pages/syntheticNocturne/node159',
    'pages/syntheticNocturne/node160'
  ];

  describe('MegaSyntheticRouteAtlasNocturneSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteNocturne_[A-Za-z0-9_]+_[0-9]{3}$/;
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

