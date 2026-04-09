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
  return /^pages\/syntheticNova\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasNovaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteNova_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticNova/node001',
    'pages/syntheticNova/node002',
    'pages/syntheticNova/node003',
    'pages/syntheticNova/node004',
    'pages/syntheticNova/node005',
    'pages/syntheticNova/node006',
    'pages/syntheticNova/node007',
    'pages/syntheticNova/node008',
    'pages/syntheticNova/node009',
    'pages/syntheticNova/node010',
    'pages/syntheticNova/node011',
    'pages/syntheticNova/node012',
    'pages/syntheticNova/node013',
    'pages/syntheticNova/node014',
    'pages/syntheticNova/node015',
    'pages/syntheticNova/node016',
    'pages/syntheticNova/node017',
    'pages/syntheticNova/node018',
    'pages/syntheticNova/node019',
    'pages/syntheticNova/node020',
    'pages/syntheticNova/node021',
    'pages/syntheticNova/node022',
    'pages/syntheticNova/node023',
    'pages/syntheticNova/node024',
    'pages/syntheticNova/node025',
    'pages/syntheticNova/node026',
    'pages/syntheticNova/node027',
    'pages/syntheticNova/node028',
    'pages/syntheticNova/node029',
    'pages/syntheticNova/node030',
    'pages/syntheticNova/node031',
    'pages/syntheticNova/node032',
    'pages/syntheticNova/node033',
    'pages/syntheticNova/node034',
    'pages/syntheticNova/node035',
    'pages/syntheticNova/node036',
    'pages/syntheticNova/node037',
    'pages/syntheticNova/node038',
    'pages/syntheticNova/node039',
    'pages/syntheticNova/node040',
    'pages/syntheticNova/node041',
    'pages/syntheticNova/node042',
    'pages/syntheticNova/node043',
    'pages/syntheticNova/node044',
    'pages/syntheticNova/node045',
    'pages/syntheticNova/node046',
    'pages/syntheticNova/node047',
    'pages/syntheticNova/node048',
    'pages/syntheticNova/node049',
    'pages/syntheticNova/node050',
    'pages/syntheticNova/node051',
    'pages/syntheticNova/node052',
    'pages/syntheticNova/node053',
    'pages/syntheticNova/node054',
    'pages/syntheticNova/node055',
    'pages/syntheticNova/node056',
    'pages/syntheticNova/node057',
    'pages/syntheticNova/node058',
    'pages/syntheticNova/node059',
    'pages/syntheticNova/node060',
    'pages/syntheticNova/node061',
    'pages/syntheticNova/node062',
    'pages/syntheticNova/node063',
    'pages/syntheticNova/node064',
    'pages/syntheticNova/node065',
    'pages/syntheticNova/node066',
    'pages/syntheticNova/node067',
    'pages/syntheticNova/node068',
    'pages/syntheticNova/node069',
    'pages/syntheticNova/node070',
    'pages/syntheticNova/node071',
    'pages/syntheticNova/node072',
    'pages/syntheticNova/node073',
    'pages/syntheticNova/node074',
    'pages/syntheticNova/node075',
    'pages/syntheticNova/node076',
    'pages/syntheticNova/node077',
    'pages/syntheticNova/node078',
    'pages/syntheticNova/node079',
    'pages/syntheticNova/node080',
    'pages/syntheticNova/node081',
    'pages/syntheticNova/node082',
    'pages/syntheticNova/node083',
    'pages/syntheticNova/node084',
    'pages/syntheticNova/node085',
    'pages/syntheticNova/node086',
    'pages/syntheticNova/node087',
    'pages/syntheticNova/node088',
    'pages/syntheticNova/node089',
    'pages/syntheticNova/node090',
    'pages/syntheticNova/node091',
    'pages/syntheticNova/node092',
    'pages/syntheticNova/node093',
    'pages/syntheticNova/node094',
    'pages/syntheticNova/node095',
    'pages/syntheticNova/node096',
    'pages/syntheticNova/node097',
    'pages/syntheticNova/node098',
    'pages/syntheticNova/node099',
    'pages/syntheticNova/node100',
    'pages/syntheticNova/node101',
    'pages/syntheticNova/node102',
    'pages/syntheticNova/node103',
    'pages/syntheticNova/node104',
    'pages/syntheticNova/node105',
    'pages/syntheticNova/node106',
    'pages/syntheticNova/node107',
    'pages/syntheticNova/node108',
    'pages/syntheticNova/node109',
    'pages/syntheticNova/node110',
    'pages/syntheticNova/node111',
    'pages/syntheticNova/node112',
    'pages/syntheticNova/node113',
    'pages/syntheticNova/node114',
    'pages/syntheticNova/node115',
    'pages/syntheticNova/node116',
    'pages/syntheticNova/node117',
    'pages/syntheticNova/node118',
    'pages/syntheticNova/node119',
    'pages/syntheticNova/node120',
    'pages/syntheticNova/node121',
    'pages/syntheticNova/node122',
    'pages/syntheticNova/node123',
    'pages/syntheticNova/node124',
    'pages/syntheticNova/node125',
    'pages/syntheticNova/node126',
    'pages/syntheticNova/node127',
    'pages/syntheticNova/node128',
    'pages/syntheticNova/node129',
    'pages/syntheticNova/node130',
    'pages/syntheticNova/node131',
    'pages/syntheticNova/node132',
    'pages/syntheticNova/node133',
    'pages/syntheticNova/node134',
    'pages/syntheticNova/node135',
    'pages/syntheticNova/node136',
    'pages/syntheticNova/node137',
    'pages/syntheticNova/node138',
    'pages/syntheticNova/node139',
    'pages/syntheticNova/node140',
    'pages/syntheticNova/node141',
    'pages/syntheticNova/node142',
    'pages/syntheticNova/node143',
    'pages/syntheticNova/node144',
    'pages/syntheticNova/node145',
    'pages/syntheticNova/node146',
    'pages/syntheticNova/node147',
    'pages/syntheticNova/node148',
    'pages/syntheticNova/node149',
    'pages/syntheticNova/node150',
    'pages/syntheticNova/node151',
    'pages/syntheticNova/node152',
    'pages/syntheticNova/node153',
    'pages/syntheticNova/node154',
    'pages/syntheticNova/node155',
    'pages/syntheticNova/node156',
    'pages/syntheticNova/node157',
    'pages/syntheticNova/node158',
    'pages/syntheticNova/node159',
    'pages/syntheticNova/node160'
  ];

  describe('MegaSyntheticRouteAtlasNovaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteNova_[A-Za-z0-9_]+_[0-9]{3}$/;
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

