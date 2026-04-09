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
  return /^pages\/syntheticTheta\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasThetaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteTheta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticTheta/node001',
    'pages/syntheticTheta/node002',
    'pages/syntheticTheta/node003',
    'pages/syntheticTheta/node004',
    'pages/syntheticTheta/node005',
    'pages/syntheticTheta/node006',
    'pages/syntheticTheta/node007',
    'pages/syntheticTheta/node008',
    'pages/syntheticTheta/node009',
    'pages/syntheticTheta/node010',
    'pages/syntheticTheta/node011',
    'pages/syntheticTheta/node012',
    'pages/syntheticTheta/node013',
    'pages/syntheticTheta/node014',
    'pages/syntheticTheta/node015',
    'pages/syntheticTheta/node016',
    'pages/syntheticTheta/node017',
    'pages/syntheticTheta/node018',
    'pages/syntheticTheta/node019',
    'pages/syntheticTheta/node020',
    'pages/syntheticTheta/node021',
    'pages/syntheticTheta/node022',
    'pages/syntheticTheta/node023',
    'pages/syntheticTheta/node024',
    'pages/syntheticTheta/node025',
    'pages/syntheticTheta/node026',
    'pages/syntheticTheta/node027',
    'pages/syntheticTheta/node028',
    'pages/syntheticTheta/node029',
    'pages/syntheticTheta/node030',
    'pages/syntheticTheta/node031',
    'pages/syntheticTheta/node032',
    'pages/syntheticTheta/node033',
    'pages/syntheticTheta/node034',
    'pages/syntheticTheta/node035',
    'pages/syntheticTheta/node036',
    'pages/syntheticTheta/node037',
    'pages/syntheticTheta/node038',
    'pages/syntheticTheta/node039',
    'pages/syntheticTheta/node040',
    'pages/syntheticTheta/node041',
    'pages/syntheticTheta/node042',
    'pages/syntheticTheta/node043',
    'pages/syntheticTheta/node044',
    'pages/syntheticTheta/node045',
    'pages/syntheticTheta/node046',
    'pages/syntheticTheta/node047',
    'pages/syntheticTheta/node048',
    'pages/syntheticTheta/node049',
    'pages/syntheticTheta/node050',
    'pages/syntheticTheta/node051',
    'pages/syntheticTheta/node052',
    'pages/syntheticTheta/node053',
    'pages/syntheticTheta/node054',
    'pages/syntheticTheta/node055',
    'pages/syntheticTheta/node056',
    'pages/syntheticTheta/node057',
    'pages/syntheticTheta/node058',
    'pages/syntheticTheta/node059',
    'pages/syntheticTheta/node060',
    'pages/syntheticTheta/node061',
    'pages/syntheticTheta/node062',
    'pages/syntheticTheta/node063',
    'pages/syntheticTheta/node064',
    'pages/syntheticTheta/node065',
    'pages/syntheticTheta/node066',
    'pages/syntheticTheta/node067',
    'pages/syntheticTheta/node068',
    'pages/syntheticTheta/node069',
    'pages/syntheticTheta/node070',
    'pages/syntheticTheta/node071',
    'pages/syntheticTheta/node072',
    'pages/syntheticTheta/node073',
    'pages/syntheticTheta/node074',
    'pages/syntheticTheta/node075',
    'pages/syntheticTheta/node076',
    'pages/syntheticTheta/node077',
    'pages/syntheticTheta/node078',
    'pages/syntheticTheta/node079',
    'pages/syntheticTheta/node080',
    'pages/syntheticTheta/node081',
    'pages/syntheticTheta/node082',
    'pages/syntheticTheta/node083',
    'pages/syntheticTheta/node084',
    'pages/syntheticTheta/node085',
    'pages/syntheticTheta/node086',
    'pages/syntheticTheta/node087',
    'pages/syntheticTheta/node088',
    'pages/syntheticTheta/node089',
    'pages/syntheticTheta/node090',
    'pages/syntheticTheta/node091',
    'pages/syntheticTheta/node092',
    'pages/syntheticTheta/node093',
    'pages/syntheticTheta/node094',
    'pages/syntheticTheta/node095',
    'pages/syntheticTheta/node096',
    'pages/syntheticTheta/node097',
    'pages/syntheticTheta/node098',
    'pages/syntheticTheta/node099',
    'pages/syntheticTheta/node100',
    'pages/syntheticTheta/node101',
    'pages/syntheticTheta/node102',
    'pages/syntheticTheta/node103',
    'pages/syntheticTheta/node104',
    'pages/syntheticTheta/node105',
    'pages/syntheticTheta/node106',
    'pages/syntheticTheta/node107',
    'pages/syntheticTheta/node108',
    'pages/syntheticTheta/node109',
    'pages/syntheticTheta/node110',
    'pages/syntheticTheta/node111',
    'pages/syntheticTheta/node112',
    'pages/syntheticTheta/node113',
    'pages/syntheticTheta/node114',
    'pages/syntheticTheta/node115',
    'pages/syntheticTheta/node116',
    'pages/syntheticTheta/node117',
    'pages/syntheticTheta/node118',
    'pages/syntheticTheta/node119',
    'pages/syntheticTheta/node120',
    'pages/syntheticTheta/node121',
    'pages/syntheticTheta/node122',
    'pages/syntheticTheta/node123',
    'pages/syntheticTheta/node124',
    'pages/syntheticTheta/node125',
    'pages/syntheticTheta/node126',
    'pages/syntheticTheta/node127',
    'pages/syntheticTheta/node128',
    'pages/syntheticTheta/node129',
    'pages/syntheticTheta/node130',
    'pages/syntheticTheta/node131',
    'pages/syntheticTheta/node132',
    'pages/syntheticTheta/node133',
    'pages/syntheticTheta/node134',
    'pages/syntheticTheta/node135',
    'pages/syntheticTheta/node136',
    'pages/syntheticTheta/node137',
    'pages/syntheticTheta/node138',
    'pages/syntheticTheta/node139',
    'pages/syntheticTheta/node140',
    'pages/syntheticTheta/node141',
    'pages/syntheticTheta/node142',
    'pages/syntheticTheta/node143',
    'pages/syntheticTheta/node144',
    'pages/syntheticTheta/node145',
    'pages/syntheticTheta/node146',
    'pages/syntheticTheta/node147',
    'pages/syntheticTheta/node148',
    'pages/syntheticTheta/node149',
    'pages/syntheticTheta/node150',
    'pages/syntheticTheta/node151',
    'pages/syntheticTheta/node152',
    'pages/syntheticTheta/node153',
    'pages/syntheticTheta/node154',
    'pages/syntheticTheta/node155',
    'pages/syntheticTheta/node156',
    'pages/syntheticTheta/node157',
    'pages/syntheticTheta/node158',
    'pages/syntheticTheta/node159',
    'pages/syntheticTheta/node160'
  ];

  describe('MegaSyntheticRouteAtlasThetaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteTheta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

