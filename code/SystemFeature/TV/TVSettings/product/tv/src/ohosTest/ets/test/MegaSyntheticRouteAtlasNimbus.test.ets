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
  return /^pages\/syntheticNimbus\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasNimbusTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteNimbus_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticNimbus/node001',
    'pages/syntheticNimbus/node002',
    'pages/syntheticNimbus/node003',
    'pages/syntheticNimbus/node004',
    'pages/syntheticNimbus/node005',
    'pages/syntheticNimbus/node006',
    'pages/syntheticNimbus/node007',
    'pages/syntheticNimbus/node008',
    'pages/syntheticNimbus/node009',
    'pages/syntheticNimbus/node010',
    'pages/syntheticNimbus/node011',
    'pages/syntheticNimbus/node012',
    'pages/syntheticNimbus/node013',
    'pages/syntheticNimbus/node014',
    'pages/syntheticNimbus/node015',
    'pages/syntheticNimbus/node016',
    'pages/syntheticNimbus/node017',
    'pages/syntheticNimbus/node018',
    'pages/syntheticNimbus/node019',
    'pages/syntheticNimbus/node020',
    'pages/syntheticNimbus/node021',
    'pages/syntheticNimbus/node022',
    'pages/syntheticNimbus/node023',
    'pages/syntheticNimbus/node024',
    'pages/syntheticNimbus/node025',
    'pages/syntheticNimbus/node026',
    'pages/syntheticNimbus/node027',
    'pages/syntheticNimbus/node028',
    'pages/syntheticNimbus/node029',
    'pages/syntheticNimbus/node030',
    'pages/syntheticNimbus/node031',
    'pages/syntheticNimbus/node032',
    'pages/syntheticNimbus/node033',
    'pages/syntheticNimbus/node034',
    'pages/syntheticNimbus/node035',
    'pages/syntheticNimbus/node036',
    'pages/syntheticNimbus/node037',
    'pages/syntheticNimbus/node038',
    'pages/syntheticNimbus/node039',
    'pages/syntheticNimbus/node040',
    'pages/syntheticNimbus/node041',
    'pages/syntheticNimbus/node042',
    'pages/syntheticNimbus/node043',
    'pages/syntheticNimbus/node044',
    'pages/syntheticNimbus/node045',
    'pages/syntheticNimbus/node046',
    'pages/syntheticNimbus/node047',
    'pages/syntheticNimbus/node048',
    'pages/syntheticNimbus/node049',
    'pages/syntheticNimbus/node050',
    'pages/syntheticNimbus/node051',
    'pages/syntheticNimbus/node052',
    'pages/syntheticNimbus/node053',
    'pages/syntheticNimbus/node054',
    'pages/syntheticNimbus/node055',
    'pages/syntheticNimbus/node056',
    'pages/syntheticNimbus/node057',
    'pages/syntheticNimbus/node058',
    'pages/syntheticNimbus/node059',
    'pages/syntheticNimbus/node060',
    'pages/syntheticNimbus/node061',
    'pages/syntheticNimbus/node062',
    'pages/syntheticNimbus/node063',
    'pages/syntheticNimbus/node064',
    'pages/syntheticNimbus/node065',
    'pages/syntheticNimbus/node066',
    'pages/syntheticNimbus/node067',
    'pages/syntheticNimbus/node068',
    'pages/syntheticNimbus/node069',
    'pages/syntheticNimbus/node070',
    'pages/syntheticNimbus/node071',
    'pages/syntheticNimbus/node072',
    'pages/syntheticNimbus/node073',
    'pages/syntheticNimbus/node074',
    'pages/syntheticNimbus/node075',
    'pages/syntheticNimbus/node076',
    'pages/syntheticNimbus/node077',
    'pages/syntheticNimbus/node078',
    'pages/syntheticNimbus/node079',
    'pages/syntheticNimbus/node080',
    'pages/syntheticNimbus/node081',
    'pages/syntheticNimbus/node082',
    'pages/syntheticNimbus/node083',
    'pages/syntheticNimbus/node084',
    'pages/syntheticNimbus/node085',
    'pages/syntheticNimbus/node086',
    'pages/syntheticNimbus/node087',
    'pages/syntheticNimbus/node088',
    'pages/syntheticNimbus/node089',
    'pages/syntheticNimbus/node090',
    'pages/syntheticNimbus/node091',
    'pages/syntheticNimbus/node092',
    'pages/syntheticNimbus/node093',
    'pages/syntheticNimbus/node094',
    'pages/syntheticNimbus/node095',
    'pages/syntheticNimbus/node096',
    'pages/syntheticNimbus/node097',
    'pages/syntheticNimbus/node098',
    'pages/syntheticNimbus/node099',
    'pages/syntheticNimbus/node100',
    'pages/syntheticNimbus/node101',
    'pages/syntheticNimbus/node102',
    'pages/syntheticNimbus/node103',
    'pages/syntheticNimbus/node104',
    'pages/syntheticNimbus/node105',
    'pages/syntheticNimbus/node106',
    'pages/syntheticNimbus/node107',
    'pages/syntheticNimbus/node108',
    'pages/syntheticNimbus/node109',
    'pages/syntheticNimbus/node110',
    'pages/syntheticNimbus/node111',
    'pages/syntheticNimbus/node112',
    'pages/syntheticNimbus/node113',
    'pages/syntheticNimbus/node114',
    'pages/syntheticNimbus/node115',
    'pages/syntheticNimbus/node116',
    'pages/syntheticNimbus/node117',
    'pages/syntheticNimbus/node118',
    'pages/syntheticNimbus/node119',
    'pages/syntheticNimbus/node120',
    'pages/syntheticNimbus/node121',
    'pages/syntheticNimbus/node122',
    'pages/syntheticNimbus/node123',
    'pages/syntheticNimbus/node124',
    'pages/syntheticNimbus/node125',
    'pages/syntheticNimbus/node126',
    'pages/syntheticNimbus/node127',
    'pages/syntheticNimbus/node128',
    'pages/syntheticNimbus/node129',
    'pages/syntheticNimbus/node130',
    'pages/syntheticNimbus/node131',
    'pages/syntheticNimbus/node132',
    'pages/syntheticNimbus/node133',
    'pages/syntheticNimbus/node134',
    'pages/syntheticNimbus/node135',
    'pages/syntheticNimbus/node136',
    'pages/syntheticNimbus/node137',
    'pages/syntheticNimbus/node138',
    'pages/syntheticNimbus/node139',
    'pages/syntheticNimbus/node140',
    'pages/syntheticNimbus/node141',
    'pages/syntheticNimbus/node142',
    'pages/syntheticNimbus/node143',
    'pages/syntheticNimbus/node144',
    'pages/syntheticNimbus/node145',
    'pages/syntheticNimbus/node146',
    'pages/syntheticNimbus/node147',
    'pages/syntheticNimbus/node148',
    'pages/syntheticNimbus/node149',
    'pages/syntheticNimbus/node150',
    'pages/syntheticNimbus/node151',
    'pages/syntheticNimbus/node152',
    'pages/syntheticNimbus/node153',
    'pages/syntheticNimbus/node154',
    'pages/syntheticNimbus/node155',
    'pages/syntheticNimbus/node156',
    'pages/syntheticNimbus/node157',
    'pages/syntheticNimbus/node158',
    'pages/syntheticNimbus/node159',
    'pages/syntheticNimbus/node160'
  ];

  describe('MegaSyntheticRouteAtlasNimbusSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteNimbus_[A-Za-z0-9_]+_[0-9]{3}$/;
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

