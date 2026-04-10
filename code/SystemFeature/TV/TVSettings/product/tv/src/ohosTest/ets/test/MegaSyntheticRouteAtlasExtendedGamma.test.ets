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
  return /^pages\/syntheticExtendedGamma\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasExtendedGammaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteExtendedGamma_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticExtendedGamma/node001',
    'pages/syntheticExtendedGamma/node002',
    'pages/syntheticExtendedGamma/node003',
    'pages/syntheticExtendedGamma/node004',
    'pages/syntheticExtendedGamma/node005',
    'pages/syntheticExtendedGamma/node006',
    'pages/syntheticExtendedGamma/node007',
    'pages/syntheticExtendedGamma/node008',
    'pages/syntheticExtendedGamma/node009',
    'pages/syntheticExtendedGamma/node010',
    'pages/syntheticExtendedGamma/node011',
    'pages/syntheticExtendedGamma/node012',
    'pages/syntheticExtendedGamma/node013',
    'pages/syntheticExtendedGamma/node014',
    'pages/syntheticExtendedGamma/node015',
    'pages/syntheticExtendedGamma/node016',
    'pages/syntheticExtendedGamma/node017',
    'pages/syntheticExtendedGamma/node018',
    'pages/syntheticExtendedGamma/node019',
    'pages/syntheticExtendedGamma/node020',
    'pages/syntheticExtendedGamma/node021',
    'pages/syntheticExtendedGamma/node022',
    'pages/syntheticExtendedGamma/node023',
    'pages/syntheticExtendedGamma/node024',
    'pages/syntheticExtendedGamma/node025',
    'pages/syntheticExtendedGamma/node026',
    'pages/syntheticExtendedGamma/node027',
    'pages/syntheticExtendedGamma/node028',
    'pages/syntheticExtendedGamma/node029',
    'pages/syntheticExtendedGamma/node030',
    'pages/syntheticExtendedGamma/node031',
    'pages/syntheticExtendedGamma/node032',
    'pages/syntheticExtendedGamma/node033',
    'pages/syntheticExtendedGamma/node034',
    'pages/syntheticExtendedGamma/node035',
    'pages/syntheticExtendedGamma/node036',
    'pages/syntheticExtendedGamma/node037',
    'pages/syntheticExtendedGamma/node038',
    'pages/syntheticExtendedGamma/node039',
    'pages/syntheticExtendedGamma/node040',
    'pages/syntheticExtendedGamma/node041',
    'pages/syntheticExtendedGamma/node042',
    'pages/syntheticExtendedGamma/node043',
    'pages/syntheticExtendedGamma/node044',
    'pages/syntheticExtendedGamma/node045',
    'pages/syntheticExtendedGamma/node046',
    'pages/syntheticExtendedGamma/node047',
    'pages/syntheticExtendedGamma/node048',
    'pages/syntheticExtendedGamma/node049',
    'pages/syntheticExtendedGamma/node050',
    'pages/syntheticExtendedGamma/node051',
    'pages/syntheticExtendedGamma/node052',
    'pages/syntheticExtendedGamma/node053',
    'pages/syntheticExtendedGamma/node054',
    'pages/syntheticExtendedGamma/node055',
    'pages/syntheticExtendedGamma/node056',
    'pages/syntheticExtendedGamma/node057',
    'pages/syntheticExtendedGamma/node058',
    'pages/syntheticExtendedGamma/node059',
    'pages/syntheticExtendedGamma/node060',
    'pages/syntheticExtendedGamma/node061',
    'pages/syntheticExtendedGamma/node062',
    'pages/syntheticExtendedGamma/node063',
    'pages/syntheticExtendedGamma/node064'
  ];

  describe('MegaSyntheticRouteAtlasExtendedGammaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteExtendedGamma_[A-Za-z0-9_]+_[0-9]{3}$/;
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

