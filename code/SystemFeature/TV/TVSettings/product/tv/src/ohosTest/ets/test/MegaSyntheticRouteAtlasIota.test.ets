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
  return /^pages\/syntheticIota\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasIotaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteIota_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticIota/node001',
    'pages/syntheticIota/node002',
    'pages/syntheticIota/node003',
    'pages/syntheticIota/node004',
    'pages/syntheticIota/node005',
    'pages/syntheticIota/node006',
    'pages/syntheticIota/node007',
    'pages/syntheticIota/node008',
    'pages/syntheticIota/node009',
    'pages/syntheticIota/node010',
    'pages/syntheticIota/node011',
    'pages/syntheticIota/node012',
    'pages/syntheticIota/node013',
    'pages/syntheticIota/node014',
    'pages/syntheticIota/node015',
    'pages/syntheticIota/node016',
    'pages/syntheticIota/node017',
    'pages/syntheticIota/node018',
    'pages/syntheticIota/node019',
    'pages/syntheticIota/node020',
    'pages/syntheticIota/node021',
    'pages/syntheticIota/node022',
    'pages/syntheticIota/node023',
    'pages/syntheticIota/node024',
    'pages/syntheticIota/node025',
    'pages/syntheticIota/node026',
    'pages/syntheticIota/node027',
    'pages/syntheticIota/node028',
    'pages/syntheticIota/node029',
    'pages/syntheticIota/node030',
    'pages/syntheticIota/node031',
    'pages/syntheticIota/node032',
    'pages/syntheticIota/node033',
    'pages/syntheticIota/node034',
    'pages/syntheticIota/node035',
    'pages/syntheticIota/node036',
    'pages/syntheticIota/node037',
    'pages/syntheticIota/node038',
    'pages/syntheticIota/node039',
    'pages/syntheticIota/node040',
    'pages/syntheticIota/node041',
    'pages/syntheticIota/node042',
    'pages/syntheticIota/node043',
    'pages/syntheticIota/node044',
    'pages/syntheticIota/node045',
    'pages/syntheticIota/node046',
    'pages/syntheticIota/node047',
    'pages/syntheticIota/node048',
    'pages/syntheticIota/node049',
    'pages/syntheticIota/node050',
    'pages/syntheticIota/node051',
    'pages/syntheticIota/node052',
    'pages/syntheticIota/node053',
    'pages/syntheticIota/node054',
    'pages/syntheticIota/node055',
    'pages/syntheticIota/node056',
    'pages/syntheticIota/node057',
    'pages/syntheticIota/node058',
    'pages/syntheticIota/node059',
    'pages/syntheticIota/node060',
    'pages/syntheticIota/node061',
    'pages/syntheticIota/node062',
    'pages/syntheticIota/node063',
    'pages/syntheticIota/node064',
    'pages/syntheticIota/node065',
    'pages/syntheticIota/node066',
    'pages/syntheticIota/node067',
    'pages/syntheticIota/node068',
    'pages/syntheticIota/node069',
    'pages/syntheticIota/node070',
    'pages/syntheticIota/node071',
    'pages/syntheticIota/node072',
    'pages/syntheticIota/node073',
    'pages/syntheticIota/node074',
    'pages/syntheticIota/node075',
    'pages/syntheticIota/node076',
    'pages/syntheticIota/node077',
    'pages/syntheticIota/node078',
    'pages/syntheticIota/node079',
    'pages/syntheticIota/node080',
    'pages/syntheticIota/node081',
    'pages/syntheticIota/node082',
    'pages/syntheticIota/node083',
    'pages/syntheticIota/node084',
    'pages/syntheticIota/node085',
    'pages/syntheticIota/node086',
    'pages/syntheticIota/node087',
    'pages/syntheticIota/node088',
    'pages/syntheticIota/node089',
    'pages/syntheticIota/node090',
    'pages/syntheticIota/node091',
    'pages/syntheticIota/node092',
    'pages/syntheticIota/node093',
    'pages/syntheticIota/node094',
    'pages/syntheticIota/node095',
    'pages/syntheticIota/node096',
    'pages/syntheticIota/node097',
    'pages/syntheticIota/node098',
    'pages/syntheticIota/node099',
    'pages/syntheticIota/node100',
    'pages/syntheticIota/node101',
    'pages/syntheticIota/node102',
    'pages/syntheticIota/node103',
    'pages/syntheticIota/node104',
    'pages/syntheticIota/node105',
    'pages/syntheticIota/node106',
    'pages/syntheticIota/node107',
    'pages/syntheticIota/node108',
    'pages/syntheticIota/node109',
    'pages/syntheticIota/node110',
    'pages/syntheticIota/node111',
    'pages/syntheticIota/node112',
    'pages/syntheticIota/node113',
    'pages/syntheticIota/node114',
    'pages/syntheticIota/node115',
    'pages/syntheticIota/node116',
    'pages/syntheticIota/node117',
    'pages/syntheticIota/node118',
    'pages/syntheticIota/node119',
    'pages/syntheticIota/node120',
    'pages/syntheticIota/node121',
    'pages/syntheticIota/node122',
    'pages/syntheticIota/node123',
    'pages/syntheticIota/node124',
    'pages/syntheticIota/node125',
    'pages/syntheticIota/node126',
    'pages/syntheticIota/node127',
    'pages/syntheticIota/node128',
    'pages/syntheticIota/node129',
    'pages/syntheticIota/node130',
    'pages/syntheticIota/node131',
    'pages/syntheticIota/node132',
    'pages/syntheticIota/node133',
    'pages/syntheticIota/node134',
    'pages/syntheticIota/node135',
    'pages/syntheticIota/node136',
    'pages/syntheticIota/node137',
    'pages/syntheticIota/node138',
    'pages/syntheticIota/node139',
    'pages/syntheticIota/node140',
    'pages/syntheticIota/node141',
    'pages/syntheticIota/node142',
    'pages/syntheticIota/node143',
    'pages/syntheticIota/node144',
    'pages/syntheticIota/node145',
    'pages/syntheticIota/node146',
    'pages/syntheticIota/node147',
    'pages/syntheticIota/node148',
    'pages/syntheticIota/node149',
    'pages/syntheticIota/node150',
    'pages/syntheticIota/node151',
    'pages/syntheticIota/node152',
    'pages/syntheticIota/node153',
    'pages/syntheticIota/node154',
    'pages/syntheticIota/node155',
    'pages/syntheticIota/node156',
    'pages/syntheticIota/node157',
    'pages/syntheticIota/node158',
    'pages/syntheticIota/node159',
    'pages/syntheticIota/node160'
  ];

  describe('MegaSyntheticRouteAtlasIotaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteIota_[A-Za-z0-9_]+_[0-9]{3}$/;
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

