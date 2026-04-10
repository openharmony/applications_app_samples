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
  return /^pages\/syntheticLambda\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasLambdaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteLambda_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticLambda/node001',
    'pages/syntheticLambda/node002',
    'pages/syntheticLambda/node003',
    'pages/syntheticLambda/node004',
    'pages/syntheticLambda/node005',
    'pages/syntheticLambda/node006',
    'pages/syntheticLambda/node007',
    'pages/syntheticLambda/node008',
    'pages/syntheticLambda/node009',
    'pages/syntheticLambda/node010',
    'pages/syntheticLambda/node011',
    'pages/syntheticLambda/node012',
    'pages/syntheticLambda/node013',
    'pages/syntheticLambda/node014',
    'pages/syntheticLambda/node015',
    'pages/syntheticLambda/node016',
    'pages/syntheticLambda/node017',
    'pages/syntheticLambda/node018',
    'pages/syntheticLambda/node019',
    'pages/syntheticLambda/node020',
    'pages/syntheticLambda/node021',
    'pages/syntheticLambda/node022',
    'pages/syntheticLambda/node023',
    'pages/syntheticLambda/node024',
    'pages/syntheticLambda/node025',
    'pages/syntheticLambda/node026',
    'pages/syntheticLambda/node027',
    'pages/syntheticLambda/node028',
    'pages/syntheticLambda/node029',
    'pages/syntheticLambda/node030',
    'pages/syntheticLambda/node031',
    'pages/syntheticLambda/node032',
    'pages/syntheticLambda/node033',
    'pages/syntheticLambda/node034',
    'pages/syntheticLambda/node035',
    'pages/syntheticLambda/node036',
    'pages/syntheticLambda/node037',
    'pages/syntheticLambda/node038',
    'pages/syntheticLambda/node039',
    'pages/syntheticLambda/node040',
    'pages/syntheticLambda/node041',
    'pages/syntheticLambda/node042',
    'pages/syntheticLambda/node043',
    'pages/syntheticLambda/node044',
    'pages/syntheticLambda/node045',
    'pages/syntheticLambda/node046',
    'pages/syntheticLambda/node047',
    'pages/syntheticLambda/node048',
    'pages/syntheticLambda/node049',
    'pages/syntheticLambda/node050',
    'pages/syntheticLambda/node051',
    'pages/syntheticLambda/node052',
    'pages/syntheticLambda/node053',
    'pages/syntheticLambda/node054',
    'pages/syntheticLambda/node055',
    'pages/syntheticLambda/node056',
    'pages/syntheticLambda/node057',
    'pages/syntheticLambda/node058',
    'pages/syntheticLambda/node059',
    'pages/syntheticLambda/node060',
    'pages/syntheticLambda/node061',
    'pages/syntheticLambda/node062',
    'pages/syntheticLambda/node063',
    'pages/syntheticLambda/node064',
    'pages/syntheticLambda/node065',
    'pages/syntheticLambda/node066',
    'pages/syntheticLambda/node067',
    'pages/syntheticLambda/node068',
    'pages/syntheticLambda/node069',
    'pages/syntheticLambda/node070',
    'pages/syntheticLambda/node071',
    'pages/syntheticLambda/node072',
    'pages/syntheticLambda/node073',
    'pages/syntheticLambda/node074',
    'pages/syntheticLambda/node075',
    'pages/syntheticLambda/node076',
    'pages/syntheticLambda/node077',
    'pages/syntheticLambda/node078',
    'pages/syntheticLambda/node079',
    'pages/syntheticLambda/node080',
    'pages/syntheticLambda/node081',
    'pages/syntheticLambda/node082',
    'pages/syntheticLambda/node083',
    'pages/syntheticLambda/node084',
    'pages/syntheticLambda/node085',
    'pages/syntheticLambda/node086',
    'pages/syntheticLambda/node087',
    'pages/syntheticLambda/node088',
    'pages/syntheticLambda/node089',
    'pages/syntheticLambda/node090',
    'pages/syntheticLambda/node091',
    'pages/syntheticLambda/node092',
    'pages/syntheticLambda/node093',
    'pages/syntheticLambda/node094',
    'pages/syntheticLambda/node095',
    'pages/syntheticLambda/node096',
    'pages/syntheticLambda/node097',
    'pages/syntheticLambda/node098',
    'pages/syntheticLambda/node099',
    'pages/syntheticLambda/node100',
    'pages/syntheticLambda/node101',
    'pages/syntheticLambda/node102',
    'pages/syntheticLambda/node103',
    'pages/syntheticLambda/node104',
    'pages/syntheticLambda/node105',
    'pages/syntheticLambda/node106',
    'pages/syntheticLambda/node107',
    'pages/syntheticLambda/node108',
    'pages/syntheticLambda/node109',
    'pages/syntheticLambda/node110',
    'pages/syntheticLambda/node111',
    'pages/syntheticLambda/node112',
    'pages/syntheticLambda/node113',
    'pages/syntheticLambda/node114',
    'pages/syntheticLambda/node115',
    'pages/syntheticLambda/node116',
    'pages/syntheticLambda/node117',
    'pages/syntheticLambda/node118',
    'pages/syntheticLambda/node119',
    'pages/syntheticLambda/node120',
    'pages/syntheticLambda/node121',
    'pages/syntheticLambda/node122',
    'pages/syntheticLambda/node123',
    'pages/syntheticLambda/node124',
    'pages/syntheticLambda/node125',
    'pages/syntheticLambda/node126',
    'pages/syntheticLambda/node127',
    'pages/syntheticLambda/node128',
    'pages/syntheticLambda/node129',
    'pages/syntheticLambda/node130',
    'pages/syntheticLambda/node131',
    'pages/syntheticLambda/node132',
    'pages/syntheticLambda/node133',
    'pages/syntheticLambda/node134',
    'pages/syntheticLambda/node135',
    'pages/syntheticLambda/node136',
    'pages/syntheticLambda/node137',
    'pages/syntheticLambda/node138',
    'pages/syntheticLambda/node139',
    'pages/syntheticLambda/node140',
    'pages/syntheticLambda/node141',
    'pages/syntheticLambda/node142',
    'pages/syntheticLambda/node143',
    'pages/syntheticLambda/node144',
    'pages/syntheticLambda/node145',
    'pages/syntheticLambda/node146',
    'pages/syntheticLambda/node147',
    'pages/syntheticLambda/node148',
    'pages/syntheticLambda/node149',
    'pages/syntheticLambda/node150',
    'pages/syntheticLambda/node151',
    'pages/syntheticLambda/node152',
    'pages/syntheticLambda/node153',
    'pages/syntheticLambda/node154',
    'pages/syntheticLambda/node155',
    'pages/syntheticLambda/node156',
    'pages/syntheticLambda/node157',
    'pages/syntheticLambda/node158',
    'pages/syntheticLambda/node159',
    'pages/syntheticLambda/node160'
  ];

  describe('MegaSyntheticRouteAtlasLambdaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteLambda_[A-Za-z0-9_]+_[0-9]{3}$/;
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

