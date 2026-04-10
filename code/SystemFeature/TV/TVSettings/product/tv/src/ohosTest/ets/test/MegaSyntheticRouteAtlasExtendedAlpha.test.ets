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
  return /^pages\/syntheticExtendedAlpha\/node[0-9]{3}$/.test(path);
}

export default function MegaSyntheticRouteAtlasExtendedAlphaTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteExtendedAlpha_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes: Array<string> = [
    'pages/syntheticExtendedAlpha/node001',
    'pages/syntheticExtendedAlpha/node002',
    'pages/syntheticExtendedAlpha/node003',
    'pages/syntheticExtendedAlpha/node004',
    'pages/syntheticExtendedAlpha/node005',
    'pages/syntheticExtendedAlpha/node006',
    'pages/syntheticExtendedAlpha/node007',
    'pages/syntheticExtendedAlpha/node008',
    'pages/syntheticExtendedAlpha/node009',
    'pages/syntheticExtendedAlpha/node010',
    'pages/syntheticExtendedAlpha/node011',
    'pages/syntheticExtendedAlpha/node012',
    'pages/syntheticExtendedAlpha/node013',
    'pages/syntheticExtendedAlpha/node014',
    'pages/syntheticExtendedAlpha/node015',
    'pages/syntheticExtendedAlpha/node016',
    'pages/syntheticExtendedAlpha/node017',
    'pages/syntheticExtendedAlpha/node018',
    'pages/syntheticExtendedAlpha/node019',
    'pages/syntheticExtendedAlpha/node020',
    'pages/syntheticExtendedAlpha/node021',
    'pages/syntheticExtendedAlpha/node022',
    'pages/syntheticExtendedAlpha/node023',
    'pages/syntheticExtendedAlpha/node024',
    'pages/syntheticExtendedAlpha/node025',
    'pages/syntheticExtendedAlpha/node026',
    'pages/syntheticExtendedAlpha/node027',
    'pages/syntheticExtendedAlpha/node028',
    'pages/syntheticExtendedAlpha/node029',
    'pages/syntheticExtendedAlpha/node030',
    'pages/syntheticExtendedAlpha/node031',
    'pages/syntheticExtendedAlpha/node032',
    'pages/syntheticExtendedAlpha/node033',
    'pages/syntheticExtendedAlpha/node034',
    'pages/syntheticExtendedAlpha/node035',
    'pages/syntheticExtendedAlpha/node036',
    'pages/syntheticExtendedAlpha/node037',
    'pages/syntheticExtendedAlpha/node038',
    'pages/syntheticExtendedAlpha/node039',
    'pages/syntheticExtendedAlpha/node040',
    'pages/syntheticExtendedAlpha/node041',
    'pages/syntheticExtendedAlpha/node042',
    'pages/syntheticExtendedAlpha/node043',
    'pages/syntheticExtendedAlpha/node044',
    'pages/syntheticExtendedAlpha/node045',
    'pages/syntheticExtendedAlpha/node046',
    'pages/syntheticExtendedAlpha/node047',
    'pages/syntheticExtendedAlpha/node048',
    'pages/syntheticExtendedAlpha/node049',
    'pages/syntheticExtendedAlpha/node050',
    'pages/syntheticExtendedAlpha/node051',
    'pages/syntheticExtendedAlpha/node052',
    'pages/syntheticExtendedAlpha/node053',
    'pages/syntheticExtendedAlpha/node054',
    'pages/syntheticExtendedAlpha/node055',
    'pages/syntheticExtendedAlpha/node056',
    'pages/syntheticExtendedAlpha/node057',
    'pages/syntheticExtendedAlpha/node058',
    'pages/syntheticExtendedAlpha/node059',
    'pages/syntheticExtendedAlpha/node060',
    'pages/syntheticExtendedAlpha/node061',
    'pages/syntheticExtendedAlpha/node062',
    'pages/syntheticExtendedAlpha/node063',
    'pages/syntheticExtendedAlpha/node064'
  ];

  describe('MegaSyntheticRouteAtlasExtendedAlphaSuite', () => {
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
      const regex = /^Settings_MegaSyntheticRouteExtendedAlpha_[A-Za-z0-9_]+_[0-9]{3}$/;
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

