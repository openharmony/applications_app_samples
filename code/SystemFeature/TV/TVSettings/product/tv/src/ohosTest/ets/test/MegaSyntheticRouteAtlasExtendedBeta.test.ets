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

function isExtendedSyntheticRouteValid(path: string): boolean {
  return /^pages\/syntheticExtendedBeta\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasExtendedBetaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteExtendedBeta_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticExtendedBeta/node001',
    'pages/syntheticExtendedBeta/node002',
    'pages/syntheticExtendedBeta/node003',
    'pages/syntheticExtendedBeta/node004',
    'pages/syntheticExtendedBeta/node005',
    'pages/syntheticExtendedBeta/node006',
    'pages/syntheticExtendedBeta/node007',
    'pages/syntheticExtendedBeta/node008',
    'pages/syntheticExtendedBeta/node009',
    'pages/syntheticExtendedBeta/node010',
    'pages/syntheticExtendedBeta/node011',
    'pages/syntheticExtendedBeta/node012',
    'pages/syntheticExtendedBeta/node013',
    'pages/syntheticExtendedBeta/node014',
    'pages/syntheticExtendedBeta/node015',
    'pages/syntheticExtendedBeta/node016',
    'pages/syntheticExtendedBeta/node017',
    'pages/syntheticExtendedBeta/node018',
    'pages/syntheticExtendedBeta/node019',
    'pages/syntheticExtendedBeta/node020',
    'pages/syntheticExtendedBeta/node021',
    'pages/syntheticExtendedBeta/node022',
    'pages/syntheticExtendedBeta/node023',
    'pages/syntheticExtendedBeta/node024',
    'pages/syntheticExtendedBeta/node025',
    'pages/syntheticExtendedBeta/node026',
    'pages/syntheticExtendedBeta/node027',
    'pages/syntheticExtendedBeta/node028',
    'pages/syntheticExtendedBeta/node029',
    'pages/syntheticExtendedBeta/node030',
    'pages/syntheticExtendedBeta/node031',
    'pages/syntheticExtendedBeta/node032',
    'pages/syntheticExtendedBeta/node033',
    'pages/syntheticExtendedBeta/node034',
    'pages/syntheticExtendedBeta/node035',
    'pages/syntheticExtendedBeta/node036',
    'pages/syntheticExtendedBeta/node037',
    'pages/syntheticExtendedBeta/node038',
    'pages/syntheticExtendedBeta/node039',
    'pages/syntheticExtendedBeta/node040',
    'pages/syntheticExtendedBeta/node041',
    'pages/syntheticExtendedBeta/node042',
    'pages/syntheticExtendedBeta/node043',
    'pages/syntheticExtendedBeta/node044',
    'pages/syntheticExtendedBeta/node045',
    'pages/syntheticExtendedBeta/node046',
    'pages/syntheticExtendedBeta/node047',
    'pages/syntheticExtendedBeta/node048',
    'pages/syntheticExtendedBeta/node049',
    'pages/syntheticExtendedBeta/node050',
    'pages/syntheticExtendedBeta/node051',
    'pages/syntheticExtendedBeta/node052',
    'pages/syntheticExtendedBeta/node053',
    'pages/syntheticExtendedBeta/node054',
    'pages/syntheticExtendedBeta/node055',
    'pages/syntheticExtendedBeta/node056',
    'pages/syntheticExtendedBeta/node057',
    'pages/syntheticExtendedBeta/node058',
    'pages/syntheticExtendedBeta/node059',
    'pages/syntheticExtendedBeta/node060',
    'pages/syntheticExtendedBeta/node061',
    'pages/syntheticExtendedBeta/node062',
    'pages/syntheticExtendedBeta/node063',
    'pages/syntheticExtendedBeta/node064'
  ];

  describe('MegaSyntheticRouteAtlasExtendedBetaSuite', () => {
    it(addCase(casePrefix + 'RouteRegex_001'), 0, () => {
      for (let i = 0; i < routes.length; i++) {
        expect(isExtendedSyntheticRouteValid(routes[i])).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'RouteBoundary_002'), 0, () => {
      expect(routes[0].endsWith('node001')).assertEqual(true);
      expect(routes[routes.length - 1].endsWith('node064')).assertEqual(true);
      expect(routes.length).assertEqual(64);
    });

    it(addCase(casePrefix + 'CaseNaming_003'), 0, () => {
      const regex = /^Settings_MegaSyntheticRouteExtendedBeta_[A-Za-z0-9_]+_[0-9]{3}$/;
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

