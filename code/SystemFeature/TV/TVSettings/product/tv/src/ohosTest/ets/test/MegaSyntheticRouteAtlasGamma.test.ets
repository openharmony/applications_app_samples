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
  return /^pages\/syntheticGamma\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasGammaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteGamma_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticGamma/node001',
    'pages/syntheticGamma/node002',
    'pages/syntheticGamma/node003',
    'pages/syntheticGamma/node004',
    'pages/syntheticGamma/node005',
    'pages/syntheticGamma/node006',
    'pages/syntheticGamma/node007',
    'pages/syntheticGamma/node008',
    'pages/syntheticGamma/node009',
    'pages/syntheticGamma/node010',
    'pages/syntheticGamma/node011',
    'pages/syntheticGamma/node012',
    'pages/syntheticGamma/node013',
    'pages/syntheticGamma/node014',
    'pages/syntheticGamma/node015',
    'pages/syntheticGamma/node016',
    'pages/syntheticGamma/node017',
    'pages/syntheticGamma/node018',
    'pages/syntheticGamma/node019',
    'pages/syntheticGamma/node020',
    'pages/syntheticGamma/node021',
    'pages/syntheticGamma/node022',
    'pages/syntheticGamma/node023',
    'pages/syntheticGamma/node024',
    'pages/syntheticGamma/node025',
    'pages/syntheticGamma/node026',
    'pages/syntheticGamma/node027',
    'pages/syntheticGamma/node028',
    'pages/syntheticGamma/node029',
    'pages/syntheticGamma/node030',
    'pages/syntheticGamma/node031',
    'pages/syntheticGamma/node032',
    'pages/syntheticGamma/node033',
    'pages/syntheticGamma/node034',
    'pages/syntheticGamma/node035',
    'pages/syntheticGamma/node036',
    'pages/syntheticGamma/node037',
    'pages/syntheticGamma/node038',
    'pages/syntheticGamma/node039',
    'pages/syntheticGamma/node040',
    'pages/syntheticGamma/node041',
    'pages/syntheticGamma/node042',
    'pages/syntheticGamma/node043',
    'pages/syntheticGamma/node044',
    'pages/syntheticGamma/node045',
    'pages/syntheticGamma/node046',
    'pages/syntheticGamma/node047',
    'pages/syntheticGamma/node048',
    'pages/syntheticGamma/node049',
    'pages/syntheticGamma/node050',
    'pages/syntheticGamma/node051',
    'pages/syntheticGamma/node052',
    'pages/syntheticGamma/node053',
    'pages/syntheticGamma/node054',
    'pages/syntheticGamma/node055',
    'pages/syntheticGamma/node056',
    'pages/syntheticGamma/node057',
    'pages/syntheticGamma/node058',
    'pages/syntheticGamma/node059',
    'pages/syntheticGamma/node060',
    'pages/syntheticGamma/node061',
    'pages/syntheticGamma/node062',
    'pages/syntheticGamma/node063',
    'pages/syntheticGamma/node064',
    'pages/syntheticGamma/node065',
    'pages/syntheticGamma/node066',
    'pages/syntheticGamma/node067',
    'pages/syntheticGamma/node068',
    'pages/syntheticGamma/node069',
    'pages/syntheticGamma/node070',
    'pages/syntheticGamma/node071',
    'pages/syntheticGamma/node072',
    'pages/syntheticGamma/node073',
    'pages/syntheticGamma/node074',
    'pages/syntheticGamma/node075',
    'pages/syntheticGamma/node076',
    'pages/syntheticGamma/node077',
    'pages/syntheticGamma/node078',
    'pages/syntheticGamma/node079',
    'pages/syntheticGamma/node080',
    'pages/syntheticGamma/node081',
    'pages/syntheticGamma/node082',
    'pages/syntheticGamma/node083',
    'pages/syntheticGamma/node084',
    'pages/syntheticGamma/node085',
    'pages/syntheticGamma/node086',
    'pages/syntheticGamma/node087',
    'pages/syntheticGamma/node088',
    'pages/syntheticGamma/node089',
    'pages/syntheticGamma/node090',
    'pages/syntheticGamma/node091',
    'pages/syntheticGamma/node092',
    'pages/syntheticGamma/node093',
    'pages/syntheticGamma/node094',
    'pages/syntheticGamma/node095',
    'pages/syntheticGamma/node096',
    'pages/syntheticGamma/node097',
    'pages/syntheticGamma/node098',
    'pages/syntheticGamma/node099',
    'pages/syntheticGamma/node100',
    'pages/syntheticGamma/node101',
    'pages/syntheticGamma/node102',
    'pages/syntheticGamma/node103',
    'pages/syntheticGamma/node104',
    'pages/syntheticGamma/node105',
    'pages/syntheticGamma/node106',
    'pages/syntheticGamma/node107',
    'pages/syntheticGamma/node108',
    'pages/syntheticGamma/node109',
    'pages/syntheticGamma/node110',
    'pages/syntheticGamma/node111',
    'pages/syntheticGamma/node112',
    'pages/syntheticGamma/node113',
    'pages/syntheticGamma/node114',
    'pages/syntheticGamma/node115',
    'pages/syntheticGamma/node116',
    'pages/syntheticGamma/node117',
    'pages/syntheticGamma/node118',
    'pages/syntheticGamma/node119',
    'pages/syntheticGamma/node120',
    'pages/syntheticGamma/node121',
    'pages/syntheticGamma/node122',
    'pages/syntheticGamma/node123',
    'pages/syntheticGamma/node124',
    'pages/syntheticGamma/node125',
    'pages/syntheticGamma/node126',
    'pages/syntheticGamma/node127',
    'pages/syntheticGamma/node128',
    'pages/syntheticGamma/node129',
    'pages/syntheticGamma/node130',
    'pages/syntheticGamma/node131',
    'pages/syntheticGamma/node132',
    'pages/syntheticGamma/node133',
    'pages/syntheticGamma/node134',
    'pages/syntheticGamma/node135',
    'pages/syntheticGamma/node136',
    'pages/syntheticGamma/node137',
    'pages/syntheticGamma/node138',
    'pages/syntheticGamma/node139',
    'pages/syntheticGamma/node140',
    'pages/syntheticGamma/node141',
    'pages/syntheticGamma/node142',
    'pages/syntheticGamma/node143',
    'pages/syntheticGamma/node144',
    'pages/syntheticGamma/node145',
    'pages/syntheticGamma/node146',
    'pages/syntheticGamma/node147',
    'pages/syntheticGamma/node148',
    'pages/syntheticGamma/node149',
    'pages/syntheticGamma/node150',
    'pages/syntheticGamma/node151',
    'pages/syntheticGamma/node152',
    'pages/syntheticGamma/node153',
    'pages/syntheticGamma/node154',
    'pages/syntheticGamma/node155',
    'pages/syntheticGamma/node156',
    'pages/syntheticGamma/node157',
    'pages/syntheticGamma/node158',
    'pages/syntheticGamma/node159',
    'pages/syntheticGamma/node160'
  ];

  describe('MegaSyntheticRouteAtlasGammaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteGamma_[A-Za-z0-9_]+_[0-9]{3}$/;
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

