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
  return /^pages\/syntheticTorrent\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasTorrentTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteTorrent_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticTorrent/node001',
    'pages/syntheticTorrent/node002',
    'pages/syntheticTorrent/node003',
    'pages/syntheticTorrent/node004',
    'pages/syntheticTorrent/node005',
    'pages/syntheticTorrent/node006',
    'pages/syntheticTorrent/node007',
    'pages/syntheticTorrent/node008',
    'pages/syntheticTorrent/node009',
    'pages/syntheticTorrent/node010',
    'pages/syntheticTorrent/node011',
    'pages/syntheticTorrent/node012',
    'pages/syntheticTorrent/node013',
    'pages/syntheticTorrent/node014',
    'pages/syntheticTorrent/node015',
    'pages/syntheticTorrent/node016',
    'pages/syntheticTorrent/node017',
    'pages/syntheticTorrent/node018',
    'pages/syntheticTorrent/node019',
    'pages/syntheticTorrent/node020',
    'pages/syntheticTorrent/node021',
    'pages/syntheticTorrent/node022',
    'pages/syntheticTorrent/node023',
    'pages/syntheticTorrent/node024',
    'pages/syntheticTorrent/node025',
    'pages/syntheticTorrent/node026',
    'pages/syntheticTorrent/node027',
    'pages/syntheticTorrent/node028',
    'pages/syntheticTorrent/node029',
    'pages/syntheticTorrent/node030',
    'pages/syntheticTorrent/node031',
    'pages/syntheticTorrent/node032',
    'pages/syntheticTorrent/node033',
    'pages/syntheticTorrent/node034',
    'pages/syntheticTorrent/node035',
    'pages/syntheticTorrent/node036',
    'pages/syntheticTorrent/node037',
    'pages/syntheticTorrent/node038',
    'pages/syntheticTorrent/node039',
    'pages/syntheticTorrent/node040',
    'pages/syntheticTorrent/node041',
    'pages/syntheticTorrent/node042',
    'pages/syntheticTorrent/node043',
    'pages/syntheticTorrent/node044',
    'pages/syntheticTorrent/node045',
    'pages/syntheticTorrent/node046',
    'pages/syntheticTorrent/node047',
    'pages/syntheticTorrent/node048',
    'pages/syntheticTorrent/node049',
    'pages/syntheticTorrent/node050',
    'pages/syntheticTorrent/node051',
    'pages/syntheticTorrent/node052',
    'pages/syntheticTorrent/node053',
    'pages/syntheticTorrent/node054',
    'pages/syntheticTorrent/node055',
    'pages/syntheticTorrent/node056',
    'pages/syntheticTorrent/node057',
    'pages/syntheticTorrent/node058',
    'pages/syntheticTorrent/node059',
    'pages/syntheticTorrent/node060',
    'pages/syntheticTorrent/node061',
    'pages/syntheticTorrent/node062',
    'pages/syntheticTorrent/node063',
    'pages/syntheticTorrent/node064',
    'pages/syntheticTorrent/node065',
    'pages/syntheticTorrent/node066',
    'pages/syntheticTorrent/node067',
    'pages/syntheticTorrent/node068',
    'pages/syntheticTorrent/node069',
    'pages/syntheticTorrent/node070',
    'pages/syntheticTorrent/node071',
    'pages/syntheticTorrent/node072',
    'pages/syntheticTorrent/node073',
    'pages/syntheticTorrent/node074',
    'pages/syntheticTorrent/node075',
    'pages/syntheticTorrent/node076',
    'pages/syntheticTorrent/node077',
    'pages/syntheticTorrent/node078',
    'pages/syntheticTorrent/node079',
    'pages/syntheticTorrent/node080',
    'pages/syntheticTorrent/node081',
    'pages/syntheticTorrent/node082',
    'pages/syntheticTorrent/node083',
    'pages/syntheticTorrent/node084',
    'pages/syntheticTorrent/node085',
    'pages/syntheticTorrent/node086',
    'pages/syntheticTorrent/node087',
    'pages/syntheticTorrent/node088',
    'pages/syntheticTorrent/node089',
    'pages/syntheticTorrent/node090',
    'pages/syntheticTorrent/node091',
    'pages/syntheticTorrent/node092',
    'pages/syntheticTorrent/node093',
    'pages/syntheticTorrent/node094',
    'pages/syntheticTorrent/node095',
    'pages/syntheticTorrent/node096',
    'pages/syntheticTorrent/node097',
    'pages/syntheticTorrent/node098',
    'pages/syntheticTorrent/node099',
    'pages/syntheticTorrent/node100',
    'pages/syntheticTorrent/node101',
    'pages/syntheticTorrent/node102',
    'pages/syntheticTorrent/node103',
    'pages/syntheticTorrent/node104',
    'pages/syntheticTorrent/node105',
    'pages/syntheticTorrent/node106',
    'pages/syntheticTorrent/node107',
    'pages/syntheticTorrent/node108',
    'pages/syntheticTorrent/node109',
    'pages/syntheticTorrent/node110',
    'pages/syntheticTorrent/node111',
    'pages/syntheticTorrent/node112',
    'pages/syntheticTorrent/node113',
    'pages/syntheticTorrent/node114',
    'pages/syntheticTorrent/node115',
    'pages/syntheticTorrent/node116',
    'pages/syntheticTorrent/node117',
    'pages/syntheticTorrent/node118',
    'pages/syntheticTorrent/node119',
    'pages/syntheticTorrent/node120',
    'pages/syntheticTorrent/node121',
    'pages/syntheticTorrent/node122',
    'pages/syntheticTorrent/node123',
    'pages/syntheticTorrent/node124',
    'pages/syntheticTorrent/node125',
    'pages/syntheticTorrent/node126',
    'pages/syntheticTorrent/node127',
    'pages/syntheticTorrent/node128',
    'pages/syntheticTorrent/node129',
    'pages/syntheticTorrent/node130',
    'pages/syntheticTorrent/node131',
    'pages/syntheticTorrent/node132',
    'pages/syntheticTorrent/node133',
    'pages/syntheticTorrent/node134',
    'pages/syntheticTorrent/node135',
    'pages/syntheticTorrent/node136',
    'pages/syntheticTorrent/node137',
    'pages/syntheticTorrent/node138',
    'pages/syntheticTorrent/node139',
    'pages/syntheticTorrent/node140',
    'pages/syntheticTorrent/node141',
    'pages/syntheticTorrent/node142',
    'pages/syntheticTorrent/node143',
    'pages/syntheticTorrent/node144',
    'pages/syntheticTorrent/node145',
    'pages/syntheticTorrent/node146',
    'pages/syntheticTorrent/node147',
    'pages/syntheticTorrent/node148',
    'pages/syntheticTorrent/node149',
    'pages/syntheticTorrent/node150',
    'pages/syntheticTorrent/node151',
    'pages/syntheticTorrent/node152',
    'pages/syntheticTorrent/node153',
    'pages/syntheticTorrent/node154',
    'pages/syntheticTorrent/node155',
    'pages/syntheticTorrent/node156',
    'pages/syntheticTorrent/node157',
    'pages/syntheticTorrent/node158',
    'pages/syntheticTorrent/node159',
    'pages/syntheticTorrent/node160'
  ];

  describe('MegaSyntheticRouteAtlasTorrentSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteTorrent_[A-Za-z0-9_]+_[0-9]{3}$/;
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

