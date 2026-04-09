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
  return /^pages\/syntheticUmbra\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasUmbraTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteUmbra_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticUmbra/node001',
    'pages/syntheticUmbra/node002',
    'pages/syntheticUmbra/node003',
    'pages/syntheticUmbra/node004',
    'pages/syntheticUmbra/node005',
    'pages/syntheticUmbra/node006',
    'pages/syntheticUmbra/node007',
    'pages/syntheticUmbra/node008',
    'pages/syntheticUmbra/node009',
    'pages/syntheticUmbra/node010',
    'pages/syntheticUmbra/node011',
    'pages/syntheticUmbra/node012',
    'pages/syntheticUmbra/node013',
    'pages/syntheticUmbra/node014',
    'pages/syntheticUmbra/node015',
    'pages/syntheticUmbra/node016',
    'pages/syntheticUmbra/node017',
    'pages/syntheticUmbra/node018',
    'pages/syntheticUmbra/node019',
    'pages/syntheticUmbra/node020',
    'pages/syntheticUmbra/node021',
    'pages/syntheticUmbra/node022',
    'pages/syntheticUmbra/node023',
    'pages/syntheticUmbra/node024',
    'pages/syntheticUmbra/node025',
    'pages/syntheticUmbra/node026',
    'pages/syntheticUmbra/node027',
    'pages/syntheticUmbra/node028',
    'pages/syntheticUmbra/node029',
    'pages/syntheticUmbra/node030',
    'pages/syntheticUmbra/node031',
    'pages/syntheticUmbra/node032',
    'pages/syntheticUmbra/node033',
    'pages/syntheticUmbra/node034',
    'pages/syntheticUmbra/node035',
    'pages/syntheticUmbra/node036',
    'pages/syntheticUmbra/node037',
    'pages/syntheticUmbra/node038',
    'pages/syntheticUmbra/node039',
    'pages/syntheticUmbra/node040',
    'pages/syntheticUmbra/node041',
    'pages/syntheticUmbra/node042',
    'pages/syntheticUmbra/node043',
    'pages/syntheticUmbra/node044',
    'pages/syntheticUmbra/node045',
    'pages/syntheticUmbra/node046',
    'pages/syntheticUmbra/node047',
    'pages/syntheticUmbra/node048',
    'pages/syntheticUmbra/node049',
    'pages/syntheticUmbra/node050',
    'pages/syntheticUmbra/node051',
    'pages/syntheticUmbra/node052',
    'pages/syntheticUmbra/node053',
    'pages/syntheticUmbra/node054',
    'pages/syntheticUmbra/node055',
    'pages/syntheticUmbra/node056',
    'pages/syntheticUmbra/node057',
    'pages/syntheticUmbra/node058',
    'pages/syntheticUmbra/node059',
    'pages/syntheticUmbra/node060',
    'pages/syntheticUmbra/node061',
    'pages/syntheticUmbra/node062',
    'pages/syntheticUmbra/node063',
    'pages/syntheticUmbra/node064',
    'pages/syntheticUmbra/node065',
    'pages/syntheticUmbra/node066',
    'pages/syntheticUmbra/node067',
    'pages/syntheticUmbra/node068',
    'pages/syntheticUmbra/node069',
    'pages/syntheticUmbra/node070',
    'pages/syntheticUmbra/node071',
    'pages/syntheticUmbra/node072',
    'pages/syntheticUmbra/node073',
    'pages/syntheticUmbra/node074',
    'pages/syntheticUmbra/node075',
    'pages/syntheticUmbra/node076',
    'pages/syntheticUmbra/node077',
    'pages/syntheticUmbra/node078',
    'pages/syntheticUmbra/node079',
    'pages/syntheticUmbra/node080',
    'pages/syntheticUmbra/node081',
    'pages/syntheticUmbra/node082',
    'pages/syntheticUmbra/node083',
    'pages/syntheticUmbra/node084',
    'pages/syntheticUmbra/node085',
    'pages/syntheticUmbra/node086',
    'pages/syntheticUmbra/node087',
    'pages/syntheticUmbra/node088',
    'pages/syntheticUmbra/node089',
    'pages/syntheticUmbra/node090',
    'pages/syntheticUmbra/node091',
    'pages/syntheticUmbra/node092',
    'pages/syntheticUmbra/node093',
    'pages/syntheticUmbra/node094',
    'pages/syntheticUmbra/node095',
    'pages/syntheticUmbra/node096',
    'pages/syntheticUmbra/node097',
    'pages/syntheticUmbra/node098',
    'pages/syntheticUmbra/node099',
    'pages/syntheticUmbra/node100',
    'pages/syntheticUmbra/node101',
    'pages/syntheticUmbra/node102',
    'pages/syntheticUmbra/node103',
    'pages/syntheticUmbra/node104',
    'pages/syntheticUmbra/node105',
    'pages/syntheticUmbra/node106',
    'pages/syntheticUmbra/node107',
    'pages/syntheticUmbra/node108',
    'pages/syntheticUmbra/node109',
    'pages/syntheticUmbra/node110',
    'pages/syntheticUmbra/node111',
    'pages/syntheticUmbra/node112',
    'pages/syntheticUmbra/node113',
    'pages/syntheticUmbra/node114',
    'pages/syntheticUmbra/node115',
    'pages/syntheticUmbra/node116',
    'pages/syntheticUmbra/node117',
    'pages/syntheticUmbra/node118',
    'pages/syntheticUmbra/node119',
    'pages/syntheticUmbra/node120',
    'pages/syntheticUmbra/node121',
    'pages/syntheticUmbra/node122',
    'pages/syntheticUmbra/node123',
    'pages/syntheticUmbra/node124',
    'pages/syntheticUmbra/node125',
    'pages/syntheticUmbra/node126',
    'pages/syntheticUmbra/node127',
    'pages/syntheticUmbra/node128',
    'pages/syntheticUmbra/node129',
    'pages/syntheticUmbra/node130',
    'pages/syntheticUmbra/node131',
    'pages/syntheticUmbra/node132',
    'pages/syntheticUmbra/node133',
    'pages/syntheticUmbra/node134',
    'pages/syntheticUmbra/node135',
    'pages/syntheticUmbra/node136',
    'pages/syntheticUmbra/node137',
    'pages/syntheticUmbra/node138',
    'pages/syntheticUmbra/node139',
    'pages/syntheticUmbra/node140',
    'pages/syntheticUmbra/node141',
    'pages/syntheticUmbra/node142',
    'pages/syntheticUmbra/node143',
    'pages/syntheticUmbra/node144',
    'pages/syntheticUmbra/node145',
    'pages/syntheticUmbra/node146',
    'pages/syntheticUmbra/node147',
    'pages/syntheticUmbra/node148',
    'pages/syntheticUmbra/node149',
    'pages/syntheticUmbra/node150',
    'pages/syntheticUmbra/node151',
    'pages/syntheticUmbra/node152',
    'pages/syntheticUmbra/node153',
    'pages/syntheticUmbra/node154',
    'pages/syntheticUmbra/node155',
    'pages/syntheticUmbra/node156',
    'pages/syntheticUmbra/node157',
    'pages/syntheticUmbra/node158',
    'pages/syntheticUmbra/node159',
    'pages/syntheticUmbra/node160'
  ];

  describe('MegaSyntheticRouteAtlasUmbraSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteUmbra_[A-Za-z0-9_]+_[0-9]{3}$/;
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

