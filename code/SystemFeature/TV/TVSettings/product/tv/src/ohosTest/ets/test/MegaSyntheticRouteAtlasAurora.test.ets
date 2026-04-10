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
  return /^pages\/syntheticAurora\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasAuroraTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteAurora_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticAurora/node001',
    'pages/syntheticAurora/node002',
    'pages/syntheticAurora/node003',
    'pages/syntheticAurora/node004',
    'pages/syntheticAurora/node005',
    'pages/syntheticAurora/node006',
    'pages/syntheticAurora/node007',
    'pages/syntheticAurora/node008',
    'pages/syntheticAurora/node009',
    'pages/syntheticAurora/node010',
    'pages/syntheticAurora/node011',
    'pages/syntheticAurora/node012',
    'pages/syntheticAurora/node013',
    'pages/syntheticAurora/node014',
    'pages/syntheticAurora/node015',
    'pages/syntheticAurora/node016',
    'pages/syntheticAurora/node017',
    'pages/syntheticAurora/node018',
    'pages/syntheticAurora/node019',
    'pages/syntheticAurora/node020',
    'pages/syntheticAurora/node021',
    'pages/syntheticAurora/node022',
    'pages/syntheticAurora/node023',
    'pages/syntheticAurora/node024',
    'pages/syntheticAurora/node025',
    'pages/syntheticAurora/node026',
    'pages/syntheticAurora/node027',
    'pages/syntheticAurora/node028',
    'pages/syntheticAurora/node029',
    'pages/syntheticAurora/node030',
    'pages/syntheticAurora/node031',
    'pages/syntheticAurora/node032',
    'pages/syntheticAurora/node033',
    'pages/syntheticAurora/node034',
    'pages/syntheticAurora/node035',
    'pages/syntheticAurora/node036',
    'pages/syntheticAurora/node037',
    'pages/syntheticAurora/node038',
    'pages/syntheticAurora/node039',
    'pages/syntheticAurora/node040',
    'pages/syntheticAurora/node041',
    'pages/syntheticAurora/node042',
    'pages/syntheticAurora/node043',
    'pages/syntheticAurora/node044',
    'pages/syntheticAurora/node045',
    'pages/syntheticAurora/node046',
    'pages/syntheticAurora/node047',
    'pages/syntheticAurora/node048',
    'pages/syntheticAurora/node049',
    'pages/syntheticAurora/node050',
    'pages/syntheticAurora/node051',
    'pages/syntheticAurora/node052',
    'pages/syntheticAurora/node053',
    'pages/syntheticAurora/node054',
    'pages/syntheticAurora/node055',
    'pages/syntheticAurora/node056',
    'pages/syntheticAurora/node057',
    'pages/syntheticAurora/node058',
    'pages/syntheticAurora/node059',
    'pages/syntheticAurora/node060',
    'pages/syntheticAurora/node061',
    'pages/syntheticAurora/node062',
    'pages/syntheticAurora/node063',
    'pages/syntheticAurora/node064',
    'pages/syntheticAurora/node065',
    'pages/syntheticAurora/node066',
    'pages/syntheticAurora/node067',
    'pages/syntheticAurora/node068',
    'pages/syntheticAurora/node069',
    'pages/syntheticAurora/node070',
    'pages/syntheticAurora/node071',
    'pages/syntheticAurora/node072',
    'pages/syntheticAurora/node073',
    'pages/syntheticAurora/node074',
    'pages/syntheticAurora/node075',
    'pages/syntheticAurora/node076',
    'pages/syntheticAurora/node077',
    'pages/syntheticAurora/node078',
    'pages/syntheticAurora/node079',
    'pages/syntheticAurora/node080',
    'pages/syntheticAurora/node081',
    'pages/syntheticAurora/node082',
    'pages/syntheticAurora/node083',
    'pages/syntheticAurora/node084',
    'pages/syntheticAurora/node085',
    'pages/syntheticAurora/node086',
    'pages/syntheticAurora/node087',
    'pages/syntheticAurora/node088',
    'pages/syntheticAurora/node089',
    'pages/syntheticAurora/node090',
    'pages/syntheticAurora/node091',
    'pages/syntheticAurora/node092',
    'pages/syntheticAurora/node093',
    'pages/syntheticAurora/node094',
    'pages/syntheticAurora/node095',
    'pages/syntheticAurora/node096',
    'pages/syntheticAurora/node097',
    'pages/syntheticAurora/node098',
    'pages/syntheticAurora/node099',
    'pages/syntheticAurora/node100',
    'pages/syntheticAurora/node101',
    'pages/syntheticAurora/node102',
    'pages/syntheticAurora/node103',
    'pages/syntheticAurora/node104',
    'pages/syntheticAurora/node105',
    'pages/syntheticAurora/node106',
    'pages/syntheticAurora/node107',
    'pages/syntheticAurora/node108',
    'pages/syntheticAurora/node109',
    'pages/syntheticAurora/node110',
    'pages/syntheticAurora/node111',
    'pages/syntheticAurora/node112',
    'pages/syntheticAurora/node113',
    'pages/syntheticAurora/node114',
    'pages/syntheticAurora/node115',
    'pages/syntheticAurora/node116',
    'pages/syntheticAurora/node117',
    'pages/syntheticAurora/node118',
    'pages/syntheticAurora/node119',
    'pages/syntheticAurora/node120',
    'pages/syntheticAurora/node121',
    'pages/syntheticAurora/node122',
    'pages/syntheticAurora/node123',
    'pages/syntheticAurora/node124',
    'pages/syntheticAurora/node125',
    'pages/syntheticAurora/node126',
    'pages/syntheticAurora/node127',
    'pages/syntheticAurora/node128',
    'pages/syntheticAurora/node129',
    'pages/syntheticAurora/node130',
    'pages/syntheticAurora/node131',
    'pages/syntheticAurora/node132',
    'pages/syntheticAurora/node133',
    'pages/syntheticAurora/node134',
    'pages/syntheticAurora/node135',
    'pages/syntheticAurora/node136',
    'pages/syntheticAurora/node137',
    'pages/syntheticAurora/node138',
    'pages/syntheticAurora/node139',
    'pages/syntheticAurora/node140',
    'pages/syntheticAurora/node141',
    'pages/syntheticAurora/node142',
    'pages/syntheticAurora/node143',
    'pages/syntheticAurora/node144',
    'pages/syntheticAurora/node145',
    'pages/syntheticAurora/node146',
    'pages/syntheticAurora/node147',
    'pages/syntheticAurora/node148',
    'pages/syntheticAurora/node149',
    'pages/syntheticAurora/node150',
    'pages/syntheticAurora/node151',
    'pages/syntheticAurora/node152',
    'pages/syntheticAurora/node153',
    'pages/syntheticAurora/node154',
    'pages/syntheticAurora/node155',
    'pages/syntheticAurora/node156',
    'pages/syntheticAurora/node157',
    'pages/syntheticAurora/node158',
    'pages/syntheticAurora/node159',
    'pages/syntheticAurora/node160'
  ];

  describe('MegaSyntheticRouteAtlasAuroraSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteAurora_[A-Za-z0-9_]+_[0-9]{3}$/;
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

