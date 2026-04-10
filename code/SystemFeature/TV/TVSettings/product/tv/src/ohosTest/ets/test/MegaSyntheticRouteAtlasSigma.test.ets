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
  return /^pages\/syntheticSigma\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasSigmaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteSigma_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticSigma/node001',
    'pages/syntheticSigma/node002',
    'pages/syntheticSigma/node003',
    'pages/syntheticSigma/node004',
    'pages/syntheticSigma/node005',
    'pages/syntheticSigma/node006',
    'pages/syntheticSigma/node007',
    'pages/syntheticSigma/node008',
    'pages/syntheticSigma/node009',
    'pages/syntheticSigma/node010',
    'pages/syntheticSigma/node011',
    'pages/syntheticSigma/node012',
    'pages/syntheticSigma/node013',
    'pages/syntheticSigma/node014',
    'pages/syntheticSigma/node015',
    'pages/syntheticSigma/node016',
    'pages/syntheticSigma/node017',
    'pages/syntheticSigma/node018',
    'pages/syntheticSigma/node019',
    'pages/syntheticSigma/node020',
    'pages/syntheticSigma/node021',
    'pages/syntheticSigma/node022',
    'pages/syntheticSigma/node023',
    'pages/syntheticSigma/node024',
    'pages/syntheticSigma/node025',
    'pages/syntheticSigma/node026',
    'pages/syntheticSigma/node027',
    'pages/syntheticSigma/node028',
    'pages/syntheticSigma/node029',
    'pages/syntheticSigma/node030',
    'pages/syntheticSigma/node031',
    'pages/syntheticSigma/node032',
    'pages/syntheticSigma/node033',
    'pages/syntheticSigma/node034',
    'pages/syntheticSigma/node035',
    'pages/syntheticSigma/node036',
    'pages/syntheticSigma/node037',
    'pages/syntheticSigma/node038',
    'pages/syntheticSigma/node039',
    'pages/syntheticSigma/node040',
    'pages/syntheticSigma/node041',
    'pages/syntheticSigma/node042',
    'pages/syntheticSigma/node043',
    'pages/syntheticSigma/node044',
    'pages/syntheticSigma/node045',
    'pages/syntheticSigma/node046',
    'pages/syntheticSigma/node047',
    'pages/syntheticSigma/node048',
    'pages/syntheticSigma/node049',
    'pages/syntheticSigma/node050',
    'pages/syntheticSigma/node051',
    'pages/syntheticSigma/node052',
    'pages/syntheticSigma/node053',
    'pages/syntheticSigma/node054',
    'pages/syntheticSigma/node055',
    'pages/syntheticSigma/node056',
    'pages/syntheticSigma/node057',
    'pages/syntheticSigma/node058',
    'pages/syntheticSigma/node059',
    'pages/syntheticSigma/node060',
    'pages/syntheticSigma/node061',
    'pages/syntheticSigma/node062',
    'pages/syntheticSigma/node063',
    'pages/syntheticSigma/node064',
    'pages/syntheticSigma/node065',
    'pages/syntheticSigma/node066',
    'pages/syntheticSigma/node067',
    'pages/syntheticSigma/node068',
    'pages/syntheticSigma/node069',
    'pages/syntheticSigma/node070',
    'pages/syntheticSigma/node071',
    'pages/syntheticSigma/node072',
    'pages/syntheticSigma/node073',
    'pages/syntheticSigma/node074',
    'pages/syntheticSigma/node075',
    'pages/syntheticSigma/node076',
    'pages/syntheticSigma/node077',
    'pages/syntheticSigma/node078',
    'pages/syntheticSigma/node079',
    'pages/syntheticSigma/node080',
    'pages/syntheticSigma/node081',
    'pages/syntheticSigma/node082',
    'pages/syntheticSigma/node083',
    'pages/syntheticSigma/node084',
    'pages/syntheticSigma/node085',
    'pages/syntheticSigma/node086',
    'pages/syntheticSigma/node087',
    'pages/syntheticSigma/node088',
    'pages/syntheticSigma/node089',
    'pages/syntheticSigma/node090',
    'pages/syntheticSigma/node091',
    'pages/syntheticSigma/node092',
    'pages/syntheticSigma/node093',
    'pages/syntheticSigma/node094',
    'pages/syntheticSigma/node095',
    'pages/syntheticSigma/node096',
    'pages/syntheticSigma/node097',
    'pages/syntheticSigma/node098',
    'pages/syntheticSigma/node099',
    'pages/syntheticSigma/node100',
    'pages/syntheticSigma/node101',
    'pages/syntheticSigma/node102',
    'pages/syntheticSigma/node103',
    'pages/syntheticSigma/node104',
    'pages/syntheticSigma/node105',
    'pages/syntheticSigma/node106',
    'pages/syntheticSigma/node107',
    'pages/syntheticSigma/node108',
    'pages/syntheticSigma/node109',
    'pages/syntheticSigma/node110',
    'pages/syntheticSigma/node111',
    'pages/syntheticSigma/node112',
    'pages/syntheticSigma/node113',
    'pages/syntheticSigma/node114',
    'pages/syntheticSigma/node115',
    'pages/syntheticSigma/node116',
    'pages/syntheticSigma/node117',
    'pages/syntheticSigma/node118',
    'pages/syntheticSigma/node119',
    'pages/syntheticSigma/node120',
    'pages/syntheticSigma/node121',
    'pages/syntheticSigma/node122',
    'pages/syntheticSigma/node123',
    'pages/syntheticSigma/node124',
    'pages/syntheticSigma/node125',
    'pages/syntheticSigma/node126',
    'pages/syntheticSigma/node127',
    'pages/syntheticSigma/node128',
    'pages/syntheticSigma/node129',
    'pages/syntheticSigma/node130',
    'pages/syntheticSigma/node131',
    'pages/syntheticSigma/node132',
    'pages/syntheticSigma/node133',
    'pages/syntheticSigma/node134',
    'pages/syntheticSigma/node135',
    'pages/syntheticSigma/node136',
    'pages/syntheticSigma/node137',
    'pages/syntheticSigma/node138',
    'pages/syntheticSigma/node139',
    'pages/syntheticSigma/node140',
    'pages/syntheticSigma/node141',
    'pages/syntheticSigma/node142',
    'pages/syntheticSigma/node143',
    'pages/syntheticSigma/node144',
    'pages/syntheticSigma/node145',
    'pages/syntheticSigma/node146',
    'pages/syntheticSigma/node147',
    'pages/syntheticSigma/node148',
    'pages/syntheticSigma/node149',
    'pages/syntheticSigma/node150',
    'pages/syntheticSigma/node151',
    'pages/syntheticSigma/node152',
    'pages/syntheticSigma/node153',
    'pages/syntheticSigma/node154',
    'pages/syntheticSigma/node155',
    'pages/syntheticSigma/node156',
    'pages/syntheticSigma/node157',
    'pages/syntheticSigma/node158',
    'pages/syntheticSigma/node159',
    'pages/syntheticSigma/node160'
  ];

  describe('MegaSyntheticRouteAtlasSigmaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteSigma_[A-Za-z0-9_]+_[0-9]{3}$/;
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