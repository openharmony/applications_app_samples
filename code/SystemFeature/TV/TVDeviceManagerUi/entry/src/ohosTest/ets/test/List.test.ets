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

import accessibilityAndReadableTextTest from './AccessibilityAndReadableText.test';
import abilityAndStageLifecycleTest from './AbilityAndStageLifecycle.test';
import businessScenarioCatalogTest from './BusinessScenarioCatalog.test';
import concurrentWindowScenarioTest from './ConcurrentWindowScenario.test';
import confirmDialogCoreTest from './ConfirmDialogCore.test';
import constantsAndTypesTest from './ConstantsAndTypes.test';
import coveragePlanTest from './CoveragePlan.test';
import dataConsistencyAndRaceTest from './DataConsistencyAndRace.test';
import extensionSessionStorageContractTest from './ExtensionSessionStorageContract.test';
import extensionWindowScenarioExpansionTest from './ExtensionWindowScenarioExpansion.test';
import faultInjectionScenarioTest from './FaultInjectionScenario.test';
import foundationTest from './Foundation.test';
import inputShareStyleTest from './InputShareStyle.test';
import launchAndTerminationScenarioTest from './LaunchAndTerminationScenario.test';
import moduleContractTest from './ModuleContract.test';
import pincodeDisplayDeepContractTest from './PincodeDisplayDeepContract.test';
import pincodeShareStyleTest from './PincodeShareStyle.test';
import regressionCoverageMatrixTest from './RegressionCoverageMatrix.test';
import regressionSuiteTest from './RegressionSuite.test';
import rotationAndResolutionMatrixTest from './RotationAndResolutionMatrix.test';
import scenarioMatrixExpansionTest from './ScenarioMatrixExpansion.test';
import stressAndSoakScenarioTest from './StressAndSoakScenario.test';
import accessibilityFeaturesTest from './AccessibilityFeatures.test';
import boundaryConditionTestingTest from './BoundaryConditionTesting.test';
import comprehensiveIntegrationTest from './ComprehensiveIntegration.test';
import dataPersistenceTest from './DataPersistence.test';
import dialogScalePrecisionTest from './DialogScalePrecision.test';
import exceptionHandlingTest from './ExceptionHandling.test';
import internationalizationSupportTest from './InternationalizationSupport.test';
import mainAbilityLifecycleContractTest from './MainAbilityLifecycleContract.test';
import multiResolutionAdaptationTest from './MultiResolutionAdaptation.test';
import scenarioCaseScalePlanTest from './ScenarioCaseScalePlan.test';
import transparentCarrierContractTest from './TransparentCarrierContract.test';
import uiHarnessLocatorStrategyTest from './UiHarnessLocatorStrategy.test';
import windowCounterReleaseGateTest from './WindowCounterReleaseGate.test';
import pinDialogMergedTest from './PinDialogMerged.test';
import inputDialogMergedTest from './InputDialogMerged.test';
import extensionWindowMergedTest from './ExtensionWindowMerged.test';
import networkMergedTest from './NetworkMerged.test';
import performanceMergedTest from './PerformanceMerged.test';
import securityMergedTest from './SecurityMerged.test';
import networkConnectivityExtendedTest from './NetworkConnectivityExtended.test';
import performanceStabilityExtendedTest from './PerformanceStabilityExtended.test';
import securityPermissionsExtendedTest from './SecurityPermissionsExtended.test';
import compatibilityExtendedTest from './CompatibilityExtended.test';
import exceptionBoundaryExtendedTest from './ExceptionBoundaryExtended.test';

export default function testsuite(): void {
  accessibilityAndReadableTextTest();
  abilityAndStageLifecycleTest();
  accessibilityFeaturesTest();
  boundaryConditionTestingTest();
  businessScenarioCatalogTest();
  comprehensiveIntegrationTest();
  concurrentWindowScenarioTest();
  confirmDialogCoreTest();
  constantsAndTypesTest();
  coveragePlanTest();
  dataConsistencyAndRaceTest();
  dataPersistenceTest();
  dialogScalePrecisionTest();
  exceptionHandlingTest();
  extensionSessionStorageContractTest();
  extensionWindowScenarioExpansionTest();
  faultInjectionScenarioTest();
  foundationTest();
  inputShareStyleTest();
  internationalizationSupportTest();
  launchAndTerminationScenarioTest();
  mainAbilityLifecycleContractTest();
  moduleContractTest();
  multiResolutionAdaptationTest();
  pincodeDisplayDeepContractTest();
  pincodeShareStyleTest();
  regressionCoverageMatrixTest();
  regressionSuiteTest();
  rotationAndResolutionMatrixTest();
  scenarioCaseScalePlanTest();
  scenarioMatrixExpansionTest();
  stressAndSoakScenarioTest();
  transparentCarrierContractTest();
  uiHarnessLocatorStrategyTest();
  windowCounterReleaseGateTest();
  pinDialogMergedTest();
  inputDialogMergedTest();
  extensionWindowMergedTest();
  networkMergedTest();
  performanceMergedTest();
  securityMergedTest();
  networkConnectivityExtendedTest();
  performanceStabilityExtendedTest();
  securityPermissionsExtendedTest();
  compatibilityExtendedTest();
  exceptionBoundaryExtendedTest();
}
