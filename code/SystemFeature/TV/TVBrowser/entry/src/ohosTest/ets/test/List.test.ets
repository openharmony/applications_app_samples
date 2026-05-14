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

import appTest from './App.test';
import navigationTest from './Navigation.test';
import tabsTest from './Tabs.test';
import inputValidationTest from './InputValidation.test';
import webInteractionTest from './WebInteraction.test';
import stressTest from './Stress.test';
import rotationTest from './Rotation.test';
import contractTest from './Contract.test';
import accessibilityTests from './AccessibilityTests.test';
import chaosTests from './ChaosTests.test';
import compatibilityTests from './CompatibilityTests.test';
import coreEngine from './CoreEngine.test';
import dataConsistencyTests from './DataConsistencyTests.test';
import deviceAdaptation from './DeviceAdaptation.test';
import finalComprehensiveTests from './FinalComprehensiveTests.test';
import integration from './Integration.test';
import networkState from './NetworkState.test';
import performanceTests from './PerformanceTests.test';
import regressionTests from './RegressionTests.test';
import securityTests from './SecurityTests.test';
import stressTests from './StressTests.test';
import tabsManagement from './TabsManagement.test';
import uIInteraction from './UIInteraction.test';
import ultimateValidationTests from './UltimateValidationTests.test';
import unitTestsDeep from './UnitTestsDeep.test';

export default function testsuite(): void {
  appTest();
  navigationTest();
  tabsTest();
  inputValidationTest();
  webInteractionTest();
  stressTest();
  rotationTest();
  contractTest();
  accessibilityTests();
  chaosTests();
  compatibilityTests();
  coreEngine();
  dataConsistencyTests();
  deviceAdaptation();
  finalComprehensiveTests();
  integration();
  networkState();
  performanceTests();
  regressionTests();
  securityTests();
  stressTests();
  tabsManagement();
  uIInteraction();
  ultimateValidationTests();
  unitTestsDeep();
}
