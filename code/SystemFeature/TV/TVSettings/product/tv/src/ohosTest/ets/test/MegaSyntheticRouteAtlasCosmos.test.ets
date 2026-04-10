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
  return /^pages\/syntheticCosmos\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasCosmosTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteCosmos_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticCosmos/node001',
    'pages/syntheticCosmos/node002',
    'pages/syntheticCosmos/node003',
    'pages/syntheticCosmos/node004',
    'pages/syntheticCosmos/node005',
    'pages/syntheticCosmos/node006',
    'pages/syntheticCosmos/node007',
    'pages/syntheticCosmos/node008',
    'pages/syntheticCosmos/node009',
    'pages/syntheticCosmos/node010',
    'pages/syntheticCosmos/node011',
    'pages/syntheticCosmos/node012',
    'pages/syntheticCosmos/node013',
    'pages/syntheticCosmos/node014',
    'pages/syntheticCosmos/node015',
    'pages/syntheticCosmos/node016',
    'pages/syntheticCosmos/node017',
    'pages/syntheticCosmos/node018',
    'pages/syntheticCosmos/node019',
    'pages/syntheticCosmos/node020',
    'pages/syntheticCosmos/node021',
    'pages/syntheticCosmos/node022',
    'pages/syntheticCosmos/node023',
    'pages/syntheticCosmos/node024',
    'pages/syntheticCosmos/node025',
    'pages/syntheticCosmos/node026',
    'pages/syntheticCosmos/node027',
    'pages/syntheticCosmos/node028',
    'pages/syntheticCosmos/node029',
    'pages/syntheticCosmos/node030',
    'pages/syntheticCosmos/node031',
    'pages/syntheticCosmos/node032',
    'pages/syntheticCosmos/node033',
    'pages/syntheticCosmos/node034',
    'pages/syntheticCosmos/node035',
    'pages/syntheticCosmos/node036',
    'pages/syntheticCosmos/node037',
    'pages/syntheticCosmos/node038',
    'pages/syntheticCosmos/node039',
    'pages/syntheticCosmos/node040',
    'pages/syntheticCosmos/node041',
    'pages/syntheticCosmos/node042',
    'pages/syntheticCosmos/node043',
    'pages/syntheticCosmos/node044',
    'pages/syntheticCosmos/node045',
    'pages/syntheticCosmos/node046',
    'pages/syntheticCosmos/node047',
    'pages/syntheticCosmos/node048',
    'pages/syntheticCosmos/node049',
    'pages/syntheticCosmos/node050',
    'pages/syntheticCosmos/node051',
    'pages/syntheticCosmos/node052',
    'pages/syntheticCosmos/node053',
    'pages/syntheticCosmos/node054',
    'pages/syntheticCosmos/node055',
    'pages/syntheticCosmos/node056',
    'pages/syntheticCosmos/node057',
    'pages/syntheticCosmos/node058',
    'pages/syntheticCosmos/node059',
    'pages/syntheticCosmos/node060',
    'pages/syntheticCosmos/node061',
    'pages/syntheticCosmos/node062',
    'pages/syntheticCosmos/node063',
    'pages/syntheticCosmos/node064',
    'pages/syntheticCosmos/node065',
    'pages/syntheticCosmos/node066',
    'pages/syntheticCosmos/node067',
    'pages/syntheticCosmos/node068',
    'pages/syntheticCosmos/node069',
    'pages/syntheticCosmos/node070',
    'pages/syntheticCosmos/node071',
    'pages/syntheticCosmos/node072',
    'pages/syntheticCosmos/node073',
    'pages/syntheticCosmos/node074',
    'pages/syntheticCosmos/node075',
    'pages/syntheticCosmos/node076',
    'pages/syntheticCosmos/node077',
    'pages/syntheticCosmos/node078',
    'pages/syntheticCosmos/node079',
    'pages/syntheticCosmos/node080',
    'pages/syntheticCosmos/node081',
    'pages/syntheticCosmos/node082',
    'pages/syntheticCosmos/node083',
    'pages/syntheticCosmos/node084',
    'pages/syntheticCosmos/node085',
    'pages/syntheticCosmos/node086',
    'pages/syntheticCosmos/node087',
    'pages/syntheticCosmos/node088',
    'pages/syntheticCosmos/node089',
    'pages/syntheticCosmos/node090',
    'pages/syntheticCosmos/node091',
    'pages/syntheticCosmos/node092',
    'pages/syntheticCosmos/node093',
    'pages/syntheticCosmos/node094',
    'pages/syntheticCosmos/node095',
    'pages/syntheticCosmos/node096',
    'pages/syntheticCosmos/node097',
    'pages/syntheticCosmos/node098',
    'pages/syntheticCosmos/node099',
    'pages/syntheticCosmos/node100',
    'pages/syntheticCosmos/node101',
    'pages/syntheticCosmos/node102',
    'pages/syntheticCosmos/node103',
    'pages/syntheticCosmos/node104',
    'pages/syntheticCosmos/node105',
    'pages/syntheticCosmos/node106',
    'pages/syntheticCosmos/node107',
    'pages/syntheticCosmos/node108',
    'pages/syntheticCosmos/node109',
    'pages/syntheticCosmos/node110',
    'pages/syntheticCosmos/node111',
    'pages/syntheticCosmos/node112',
    'pages/syntheticCosmos/node113',
    'pages/syntheticCosmos/node114',
    'pages/syntheticCosmos/node115',
    'pages/syntheticCosmos/node116',
    'pages/syntheticCosmos/node117',
    'pages/syntheticCosmos/node118',
    'pages/syntheticCosmos/node119',
    'pages/syntheticCosmos/node120',
    'pages/syntheticCosmos/node121',
    'pages/syntheticCosmos/node122',
    'pages/syntheticCosmos/node123',
    'pages/syntheticCosmos/node124',
    'pages/syntheticCosmos/node125',
    'pages/syntheticCosmos/node126',
    'pages/syntheticCosmos/node127',
    'pages/syntheticCosmos/node128',
    'pages/syntheticCosmos/node129',
    'pages/syntheticCosmos/node130',
    'pages/syntheticCosmos/node131',
    'pages/syntheticCosmos/node132',
    'pages/syntheticCosmos/node133',
    'pages/syntheticCosmos/node134',
    'pages/syntheticCosmos/node135',
    'pages/syntheticCosmos/node136',
    'pages/syntheticCosmos/node137',
    'pages/syntheticCosmos/node138',
    'pages/syntheticCosmos/node139',
    'pages/syntheticCosmos/node140',
    'pages/syntheticCosmos/node141',
    'pages/syntheticCosmos/node142',
    'pages/syntheticCosmos/node143',
    'pages/syntheticCosmos/node144',
    'pages/syntheticCosmos/node145',
    'pages/syntheticCosmos/node146',
    'pages/syntheticCosmos/node147',
    'pages/syntheticCosmos/node148',
    'pages/syntheticCosmos/node149',
    'pages/syntheticCosmos/node150',
    'pages/syntheticCosmos/node151',
    'pages/syntheticCosmos/node152',
    'pages/syntheticCosmos/node153',
    'pages/syntheticCosmos/node154',
    'pages/syntheticCosmos/node155',
    'pages/syntheticCosmos/node156',
    'pages/syntheticCosmos/node157',
    'pages/syntheticCosmos/node158',
    'pages/syntheticCosmos/node159',
    'pages/syntheticCosmos/node160'
  ];

  describe('MegaSyntheticRouteAtlasCosmosSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteCosmos_[A-Za-z0-9_]+_[0-9]{3}$/;
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

