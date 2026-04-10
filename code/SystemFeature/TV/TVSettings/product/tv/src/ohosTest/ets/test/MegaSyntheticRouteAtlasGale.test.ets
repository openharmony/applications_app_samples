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
  return /^pages\/syntheticGale\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasGaleTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteGale_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticGale/node001',
    'pages/syntheticGale/node002',
    'pages/syntheticGale/node003',
    'pages/syntheticGale/node004',
    'pages/syntheticGale/node005',
    'pages/syntheticGale/node006',
    'pages/syntheticGale/node007',
    'pages/syntheticGale/node008',
    'pages/syntheticGale/node009',
    'pages/syntheticGale/node010',
    'pages/syntheticGale/node011',
    'pages/syntheticGale/node012',
    'pages/syntheticGale/node013',
    'pages/syntheticGale/node014',
    'pages/syntheticGale/node015',
    'pages/syntheticGale/node016',
    'pages/syntheticGale/node017',
    'pages/syntheticGale/node018',
    'pages/syntheticGale/node019',
    'pages/syntheticGale/node020',
    'pages/syntheticGale/node021',
    'pages/syntheticGale/node022',
    'pages/syntheticGale/node023',
    'pages/syntheticGale/node024',
    'pages/syntheticGale/node025',
    'pages/syntheticGale/node026',
    'pages/syntheticGale/node027',
    'pages/syntheticGale/node028',
    'pages/syntheticGale/node029',
    'pages/syntheticGale/node030',
    'pages/syntheticGale/node031',
    'pages/syntheticGale/node032',
    'pages/syntheticGale/node033',
    'pages/syntheticGale/node034',
    'pages/syntheticGale/node035',
    'pages/syntheticGale/node036',
    'pages/syntheticGale/node037',
    'pages/syntheticGale/node038',
    'pages/syntheticGale/node039',
    'pages/syntheticGale/node040',
    'pages/syntheticGale/node041',
    'pages/syntheticGale/node042',
    'pages/syntheticGale/node043',
    'pages/syntheticGale/node044',
    'pages/syntheticGale/node045',
    'pages/syntheticGale/node046',
    'pages/syntheticGale/node047',
    'pages/syntheticGale/node048',
    'pages/syntheticGale/node049',
    'pages/syntheticGale/node050',
    'pages/syntheticGale/node051',
    'pages/syntheticGale/node052',
    'pages/syntheticGale/node053',
    'pages/syntheticGale/node054',
    'pages/syntheticGale/node055',
    'pages/syntheticGale/node056',
    'pages/syntheticGale/node057',
    'pages/syntheticGale/node058',
    'pages/syntheticGale/node059',
    'pages/syntheticGale/node060',
    'pages/syntheticGale/node061',
    'pages/syntheticGale/node062',
    'pages/syntheticGale/node063',
    'pages/syntheticGale/node064',
    'pages/syntheticGale/node065',
    'pages/syntheticGale/node066',
    'pages/syntheticGale/node067',
    'pages/syntheticGale/node068',
    'pages/syntheticGale/node069',
    'pages/syntheticGale/node070',
    'pages/syntheticGale/node071',
    'pages/syntheticGale/node072',
    'pages/syntheticGale/node073',
    'pages/syntheticGale/node074',
    'pages/syntheticGale/node075',
    'pages/syntheticGale/node076',
    'pages/syntheticGale/node077',
    'pages/syntheticGale/node078',
    'pages/syntheticGale/node079',
    'pages/syntheticGale/node080',
    'pages/syntheticGale/node081',
    'pages/syntheticGale/node082',
    'pages/syntheticGale/node083',
    'pages/syntheticGale/node084',
    'pages/syntheticGale/node085',
    'pages/syntheticGale/node086',
    'pages/syntheticGale/node087',
    'pages/syntheticGale/node088',
    'pages/syntheticGale/node089',
    'pages/syntheticGale/node090',
    'pages/syntheticGale/node091',
    'pages/syntheticGale/node092',
    'pages/syntheticGale/node093',
    'pages/syntheticGale/node094',
    'pages/syntheticGale/node095',
    'pages/syntheticGale/node096',
    'pages/syntheticGale/node097',
    'pages/syntheticGale/node098',
    'pages/syntheticGale/node099',
    'pages/syntheticGale/node100',
    'pages/syntheticGale/node101',
    'pages/syntheticGale/node102',
    'pages/syntheticGale/node103',
    'pages/syntheticGale/node104',
    'pages/syntheticGale/node105',
    'pages/syntheticGale/node106',
    'pages/syntheticGale/node107',
    'pages/syntheticGale/node108',
    'pages/syntheticGale/node109',
    'pages/syntheticGale/node110',
    'pages/syntheticGale/node111',
    'pages/syntheticGale/node112',
    'pages/syntheticGale/node113',
    'pages/syntheticGale/node114',
    'pages/syntheticGale/node115',
    'pages/syntheticGale/node116',
    'pages/syntheticGale/node117',
    'pages/syntheticGale/node118',
    'pages/syntheticGale/node119',
    'pages/syntheticGale/node120',
    'pages/syntheticGale/node121',
    'pages/syntheticGale/node122',
    'pages/syntheticGale/node123',
    'pages/syntheticGale/node124',
    'pages/syntheticGale/node125',
    'pages/syntheticGale/node126',
    'pages/syntheticGale/node127',
    'pages/syntheticGale/node128',
    'pages/syntheticGale/node129',
    'pages/syntheticGale/node130',
    'pages/syntheticGale/node131',
    'pages/syntheticGale/node132',
    'pages/syntheticGale/node133',
    'pages/syntheticGale/node134',
    'pages/syntheticGale/node135',
    'pages/syntheticGale/node136',
    'pages/syntheticGale/node137',
    'pages/syntheticGale/node138',
    'pages/syntheticGale/node139',
    'pages/syntheticGale/node140',
    'pages/syntheticGale/node141',
    'pages/syntheticGale/node142',
    'pages/syntheticGale/node143',
    'pages/syntheticGale/node144',
    'pages/syntheticGale/node145',
    'pages/syntheticGale/node146',
    'pages/syntheticGale/node147',
    'pages/syntheticGale/node148',
    'pages/syntheticGale/node149',
    'pages/syntheticGale/node150',
    'pages/syntheticGale/node151',
    'pages/syntheticGale/node152',
    'pages/syntheticGale/node153',
    'pages/syntheticGale/node154',
    'pages/syntheticGale/node155',
    'pages/syntheticGale/node156',
    'pages/syntheticGale/node157',
    'pages/syntheticGale/node158',
    'pages/syntheticGale/node159',
    'pages/syntheticGale/node160'
  ];

  describe('MegaSyntheticRouteAtlasGaleSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteGale_[A-Za-z0-9_]+_[0-9]{3}$/;
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

