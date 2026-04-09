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
  return /^pages\/syntheticDynamo\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasDynamoTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteDynamo_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticDynamo/node001',
    'pages/syntheticDynamo/node002',
    'pages/syntheticDynamo/node003',
    'pages/syntheticDynamo/node004',
    'pages/syntheticDynamo/node005',
    'pages/syntheticDynamo/node006',
    'pages/syntheticDynamo/node007',
    'pages/syntheticDynamo/node008',
    'pages/syntheticDynamo/node009',
    'pages/syntheticDynamo/node010',
    'pages/syntheticDynamo/node011',
    'pages/syntheticDynamo/node012',
    'pages/syntheticDynamo/node013',
    'pages/syntheticDynamo/node014',
    'pages/syntheticDynamo/node015',
    'pages/syntheticDynamo/node016',
    'pages/syntheticDynamo/node017',
    'pages/syntheticDynamo/node018',
    'pages/syntheticDynamo/node019',
    'pages/syntheticDynamo/node020',
    'pages/syntheticDynamo/node021',
    'pages/syntheticDynamo/node022',
    'pages/syntheticDynamo/node023',
    'pages/syntheticDynamo/node024',
    'pages/syntheticDynamo/node025',
    'pages/syntheticDynamo/node026',
    'pages/syntheticDynamo/node027',
    'pages/syntheticDynamo/node028',
    'pages/syntheticDynamo/node029',
    'pages/syntheticDynamo/node030',
    'pages/syntheticDynamo/node031',
    'pages/syntheticDynamo/node032',
    'pages/syntheticDynamo/node033',
    'pages/syntheticDynamo/node034',
    'pages/syntheticDynamo/node035',
    'pages/syntheticDynamo/node036',
    'pages/syntheticDynamo/node037',
    'pages/syntheticDynamo/node038',
    'pages/syntheticDynamo/node039',
    'pages/syntheticDynamo/node040',
    'pages/syntheticDynamo/node041',
    'pages/syntheticDynamo/node042',
    'pages/syntheticDynamo/node043',
    'pages/syntheticDynamo/node044',
    'pages/syntheticDynamo/node045',
    'pages/syntheticDynamo/node046',
    'pages/syntheticDynamo/node047',
    'pages/syntheticDynamo/node048',
    'pages/syntheticDynamo/node049',
    'pages/syntheticDynamo/node050',
    'pages/syntheticDynamo/node051',
    'pages/syntheticDynamo/node052',
    'pages/syntheticDynamo/node053',
    'pages/syntheticDynamo/node054',
    'pages/syntheticDynamo/node055',
    'pages/syntheticDynamo/node056',
    'pages/syntheticDynamo/node057',
    'pages/syntheticDynamo/node058',
    'pages/syntheticDynamo/node059',
    'pages/syntheticDynamo/node060',
    'pages/syntheticDynamo/node061',
    'pages/syntheticDynamo/node062',
    'pages/syntheticDynamo/node063',
    'pages/syntheticDynamo/node064',
    'pages/syntheticDynamo/node065',
    'pages/syntheticDynamo/node066',
    'pages/syntheticDynamo/node067',
    'pages/syntheticDynamo/node068',
    'pages/syntheticDynamo/node069',
    'pages/syntheticDynamo/node070',
    'pages/syntheticDynamo/node071',
    'pages/syntheticDynamo/node072',
    'pages/syntheticDynamo/node073',
    'pages/syntheticDynamo/node074',
    'pages/syntheticDynamo/node075',
    'pages/syntheticDynamo/node076',
    'pages/syntheticDynamo/node077',
    'pages/syntheticDynamo/node078',
    'pages/syntheticDynamo/node079',
    'pages/syntheticDynamo/node080',
    'pages/syntheticDynamo/node081',
    'pages/syntheticDynamo/node082',
    'pages/syntheticDynamo/node083',
    'pages/syntheticDynamo/node084',
    'pages/syntheticDynamo/node085',
    'pages/syntheticDynamo/node086',
    'pages/syntheticDynamo/node087',
    'pages/syntheticDynamo/node088',
    'pages/syntheticDynamo/node089',
    'pages/syntheticDynamo/node090',
    'pages/syntheticDynamo/node091',
    'pages/syntheticDynamo/node092',
    'pages/syntheticDynamo/node093',
    'pages/syntheticDynamo/node094',
    'pages/syntheticDynamo/node095',
    'pages/syntheticDynamo/node096',
    'pages/syntheticDynamo/node097',
    'pages/syntheticDynamo/node098',
    'pages/syntheticDynamo/node099',
    'pages/syntheticDynamo/node100',
    'pages/syntheticDynamo/node101',
    'pages/syntheticDynamo/node102',
    'pages/syntheticDynamo/node103',
    'pages/syntheticDynamo/node104',
    'pages/syntheticDynamo/node105',
    'pages/syntheticDynamo/node106',
    'pages/syntheticDynamo/node107',
    'pages/syntheticDynamo/node108',
    'pages/syntheticDynamo/node109',
    'pages/syntheticDynamo/node110',
    'pages/syntheticDynamo/node111',
    'pages/syntheticDynamo/node112',
    'pages/syntheticDynamo/node113',
    'pages/syntheticDynamo/node114',
    'pages/syntheticDynamo/node115',
    'pages/syntheticDynamo/node116',
    'pages/syntheticDynamo/node117',
    'pages/syntheticDynamo/node118',
    'pages/syntheticDynamo/node119',
    'pages/syntheticDynamo/node120',
    'pages/syntheticDynamo/node121',
    'pages/syntheticDynamo/node122',
    'pages/syntheticDynamo/node123',
    'pages/syntheticDynamo/node124',
    'pages/syntheticDynamo/node125',
    'pages/syntheticDynamo/node126',
    'pages/syntheticDynamo/node127',
    'pages/syntheticDynamo/node128',
    'pages/syntheticDynamo/node129',
    'pages/syntheticDynamo/node130',
    'pages/syntheticDynamo/node131',
    'pages/syntheticDynamo/node132',
    'pages/syntheticDynamo/node133',
    'pages/syntheticDynamo/node134',
    'pages/syntheticDynamo/node135',
    'pages/syntheticDynamo/node136',
    'pages/syntheticDynamo/node137',
    'pages/syntheticDynamo/node138',
    'pages/syntheticDynamo/node139',
    'pages/syntheticDynamo/node140',
    'pages/syntheticDynamo/node141',
    'pages/syntheticDynamo/node142',
    'pages/syntheticDynamo/node143',
    'pages/syntheticDynamo/node144',
    'pages/syntheticDynamo/node145',
    'pages/syntheticDynamo/node146',
    'pages/syntheticDynamo/node147',
    'pages/syntheticDynamo/node148',
    'pages/syntheticDynamo/node149',
    'pages/syntheticDynamo/node150',
    'pages/syntheticDynamo/node151',
    'pages/syntheticDynamo/node152',
    'pages/syntheticDynamo/node153',
    'pages/syntheticDynamo/node154',
    'pages/syntheticDynamo/node155',
    'pages/syntheticDynamo/node156',
    'pages/syntheticDynamo/node157',
    'pages/syntheticDynamo/node158',
    'pages/syntheticDynamo/node159',
    'pages/syntheticDynamo/node160'
  ];

  describe('MegaSyntheticRouteAtlasDynamoSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteDynamo_[A-Za-z0-9_]+_[0-9]{3}$/;
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

