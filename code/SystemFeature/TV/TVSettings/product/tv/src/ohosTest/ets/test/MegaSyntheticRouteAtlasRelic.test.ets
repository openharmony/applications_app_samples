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
  return /^pages\/syntheticRelic\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasRelicTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteRelic_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticRelic/node001',
    'pages/syntheticRelic/node002',
    'pages/syntheticRelic/node003',
    'pages/syntheticRelic/node004',
    'pages/syntheticRelic/node005',
    'pages/syntheticRelic/node006',
    'pages/syntheticRelic/node007',
    'pages/syntheticRelic/node008',
    'pages/syntheticRelic/node009',
    'pages/syntheticRelic/node010',
    'pages/syntheticRelic/node011',
    'pages/syntheticRelic/node012',
    'pages/syntheticRelic/node013',
    'pages/syntheticRelic/node014',
    'pages/syntheticRelic/node015',
    'pages/syntheticRelic/node016',
    'pages/syntheticRelic/node017',
    'pages/syntheticRelic/node018',
    'pages/syntheticRelic/node019',
    'pages/syntheticRelic/node020',
    'pages/syntheticRelic/node021',
    'pages/syntheticRelic/node022',
    'pages/syntheticRelic/node023',
    'pages/syntheticRelic/node024',
    'pages/syntheticRelic/node025',
    'pages/syntheticRelic/node026',
    'pages/syntheticRelic/node027',
    'pages/syntheticRelic/node028',
    'pages/syntheticRelic/node029',
    'pages/syntheticRelic/node030',
    'pages/syntheticRelic/node031',
    'pages/syntheticRelic/node032',
    'pages/syntheticRelic/node033',
    'pages/syntheticRelic/node034',
    'pages/syntheticRelic/node035',
    'pages/syntheticRelic/node036',
    'pages/syntheticRelic/node037',
    'pages/syntheticRelic/node038',
    'pages/syntheticRelic/node039',
    'pages/syntheticRelic/node040',
    'pages/syntheticRelic/node041',
    'pages/syntheticRelic/node042',
    'pages/syntheticRelic/node043',
    'pages/syntheticRelic/node044',
    'pages/syntheticRelic/node045',
    'pages/syntheticRelic/node046',
    'pages/syntheticRelic/node047',
    'pages/syntheticRelic/node048',
    'pages/syntheticRelic/node049',
    'pages/syntheticRelic/node050',
    'pages/syntheticRelic/node051',
    'pages/syntheticRelic/node052',
    'pages/syntheticRelic/node053',
    'pages/syntheticRelic/node054',
    'pages/syntheticRelic/node055',
    'pages/syntheticRelic/node056',
    'pages/syntheticRelic/node057',
    'pages/syntheticRelic/node058',
    'pages/syntheticRelic/node059',
    'pages/syntheticRelic/node060',
    'pages/syntheticRelic/node061',
    'pages/syntheticRelic/node062',
    'pages/syntheticRelic/node063',
    'pages/syntheticRelic/node064',
    'pages/syntheticRelic/node065',
    'pages/syntheticRelic/node066',
    'pages/syntheticRelic/node067',
    'pages/syntheticRelic/node068',
    'pages/syntheticRelic/node069',
    'pages/syntheticRelic/node070',
    'pages/syntheticRelic/node071',
    'pages/syntheticRelic/node072',
    'pages/syntheticRelic/node073',
    'pages/syntheticRelic/node074',
    'pages/syntheticRelic/node075',
    'pages/syntheticRelic/node076',
    'pages/syntheticRelic/node077',
    'pages/syntheticRelic/node078',
    'pages/syntheticRelic/node079',
    'pages/syntheticRelic/node080',
    'pages/syntheticRelic/node081',
    'pages/syntheticRelic/node082',
    'pages/syntheticRelic/node083',
    'pages/syntheticRelic/node084',
    'pages/syntheticRelic/node085',
    'pages/syntheticRelic/node086',
    'pages/syntheticRelic/node087',
    'pages/syntheticRelic/node088',
    'pages/syntheticRelic/node089',
    'pages/syntheticRelic/node090',
    'pages/syntheticRelic/node091',
    'pages/syntheticRelic/node092',
    'pages/syntheticRelic/node093',
    'pages/syntheticRelic/node094',
    'pages/syntheticRelic/node095',
    'pages/syntheticRelic/node096',
    'pages/syntheticRelic/node097',
    'pages/syntheticRelic/node098',
    'pages/syntheticRelic/node099',
    'pages/syntheticRelic/node100',
    'pages/syntheticRelic/node101',
    'pages/syntheticRelic/node102',
    'pages/syntheticRelic/node103',
    'pages/syntheticRelic/node104',
    'pages/syntheticRelic/node105',
    'pages/syntheticRelic/node106',
    'pages/syntheticRelic/node107',
    'pages/syntheticRelic/node108',
    'pages/syntheticRelic/node109',
    'pages/syntheticRelic/node110',
    'pages/syntheticRelic/node111',
    'pages/syntheticRelic/node112',
    'pages/syntheticRelic/node113',
    'pages/syntheticRelic/node114',
    'pages/syntheticRelic/node115',
    'pages/syntheticRelic/node116',
    'pages/syntheticRelic/node117',
    'pages/syntheticRelic/node118',
    'pages/syntheticRelic/node119',
    'pages/syntheticRelic/node120',
    'pages/syntheticRelic/node121',
    'pages/syntheticRelic/node122',
    'pages/syntheticRelic/node123',
    'pages/syntheticRelic/node124',
    'pages/syntheticRelic/node125',
    'pages/syntheticRelic/node126',
    'pages/syntheticRelic/node127',
    'pages/syntheticRelic/node128',
    'pages/syntheticRelic/node129',
    'pages/syntheticRelic/node130',
    'pages/syntheticRelic/node131',
    'pages/syntheticRelic/node132',
    'pages/syntheticRelic/node133',
    'pages/syntheticRelic/node134',
    'pages/syntheticRelic/node135',
    'pages/syntheticRelic/node136',
    'pages/syntheticRelic/node137',
    'pages/syntheticRelic/node138',
    'pages/syntheticRelic/node139',
    'pages/syntheticRelic/node140',
    'pages/syntheticRelic/node141',
    'pages/syntheticRelic/node142',
    'pages/syntheticRelic/node143',
    'pages/syntheticRelic/node144',
    'pages/syntheticRelic/node145',
    'pages/syntheticRelic/node146',
    'pages/syntheticRelic/node147',
    'pages/syntheticRelic/node148',
    'pages/syntheticRelic/node149',
    'pages/syntheticRelic/node150',
    'pages/syntheticRelic/node151',
    'pages/syntheticRelic/node152',
    'pages/syntheticRelic/node153',
    'pages/syntheticRelic/node154',
    'pages/syntheticRelic/node155',
    'pages/syntheticRelic/node156',
    'pages/syntheticRelic/node157',
    'pages/syntheticRelic/node158',
    'pages/syntheticRelic/node159',
    'pages/syntheticRelic/node160'
  ];

  describe('MegaSyntheticRouteAtlasRelicSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteRelic_[A-Za-z0-9_]+_[0-9]{3}$/;
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
