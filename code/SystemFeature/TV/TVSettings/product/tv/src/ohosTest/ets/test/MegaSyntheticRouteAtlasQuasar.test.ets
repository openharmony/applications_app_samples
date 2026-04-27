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
  return /^pages\/syntheticQuasar\/node[0-9]{3}$/.test(path);
}

function createRoutes(): Array<string> {
  const routes: Array<string> = [];
  for (let i = 1; i <= 160; i++) {
    const value = i < 10 ? `00${i}` : i < 100 ? `0${i}` : `${i}`;
    routes.push(`pages/syntheticQuasar/node${value}`);
  }
  return routes;
}

export default function MegaSyntheticRouteAtlasQuasarTest() {
  const casePrefix = 'Settings_MegaSyntheticRouteQuasar_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const routes = createRoutes();

  describe('MegaSyntheticRouteAtlasQuasarSuite', () => {
    it(addCase(casePrefix + 'RouteRegex_001'), 0, () => {
      for (let i = 0; i < routes.length; i++) {
        expect(isSyntheticRouteValid(routes[i])).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'RouteUnique_002'), 0, () => {
      const unique = new Set<string>(routes);
      expect(unique.size).assertEqual(routes.length);
    });

    it(addCase(casePrefix + 'RouteStress_003'), 0, () => {
      let validCount = 0;
      for (let i = 0; i < 3200; i++) {
        if (isSyntheticRouteValid(routes[i % routes.length])) {
          validCount++;
        }
      }
      expect(validCount).assertEqual(3200);
    });

    it(addCase(casePrefix + 'CaseNaming_004'), 0, () => {
      const regex = /^Settings_MegaSyntheticRouteQuasar_[A-Za-z0-9_]+_[0-9]{3}$/;
      const unique = new Set<string>(allCaseNames);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
      }
      expect(unique.size).assertEqual(allCaseNames.length);
    });
  });
}