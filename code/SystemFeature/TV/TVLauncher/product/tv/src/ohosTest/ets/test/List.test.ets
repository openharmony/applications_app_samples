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

import LauncherTest from './Launcher.test';
import AppEditTest from './AppEdit.test';
import AppEditDeepTest from './AppEditDeep.test';
import CacheTest from './Cache.test';
import BeanAndUtilsTest from './BeanAndUtils.test';
import ConstantsAndModelTest from './ConstantsAndModel.test';
import ConstantsAndModelContractsTest from './ConstantsAndModelContracts.test';
import ThrottleTest from './Throttle.test';
import AbilityContractTest from './AbilityContract.test';
import CoreUtilsAndContractsTest from './CoreUtilsAndContracts.test';
import CoreUtilsAndContractsOnlyTest from './CoreUtilsAndContractsOnly.test';
import StorageAndPolicyTest from './StorageAndPolicy.test';
import StorageAndPolicyDeepTest from './StorageAndPolicyDeep.test';
import StorageContractDeepTest from './StorageContractDeep.test';
import DockerPolicyTest from './DockerPolicy.test';
import AccessibilityTest from './Accessibility.test';
import FocusAndNavigationTest from './FocusAndNavigation.test';
import FocusNavigationDeepTest from './FocusNavigationDeep.test';
import KeyEventTest from './KeyEvent.test';
import KeyEventAndNavigationTest from './KeyEventAndNavigation.test';
import LifecycleTest from './Lifecycle.test';
import LifecycleStressTest from './LifecycleStress.test';
import RecentTest from './Recent.test';
import RecentAndLifecycleDeepTest from './RecentAndLifecycleDeep.test';
import MultiWindowTest from './MultiWindow.test';
import PersistenceTest from './Persistence.test';
import OpsInteractionTest from './OpsInteraction.test';
import PerformanceAndRenderTest from './PerformanceAndRender.test';
import DesktopAndEditFlowTest from './DesktopAndEditFlow.test';
import ExpandedScenarioTest from './ExpandedScenario.test';
import ScenarioRegressionTest from './ScenarioRegression.test';
import IntegrationEndToEndTest from './IntegrationEndToEnd.test';
import FullContractRegressionTest from './FullContractRegression.test';
import StatusBarAndAccessibilityDeepTest from './StatusBarAndAccessibilityDeep.test';
import StressChaosRegressionDeepTest from './StressChaosRegressionDeep.test';
import StyleConstantsDeepTest from './StyleConstantsDeep.test';
import MassiveAutoExpansionTest from './MassiveAutoExpansion.test';
import RotationTest from './Rotation.test';
import RotationResolutionPerformanceDeepTest from './RotationResolutionPerformanceDeep.test';
import ManagerAndLoggingContractsTest from './ManagerAndLoggingContracts.test';
import CacheManagerContractsTest from './CacheManagerContracts.test';
import MainAbilityAndPreferenceContractsTest from './MainAbilityAndPreferenceContracts.test';
import LauncherWindowDockerContractsTest from './LauncherWindowDockerContracts.test';
import ResourceAndEventContractsTest from './ResourceAndEventContracts.test';

export default function testsuite() {
  LauncherTest();
  AppEditTest();
  AppEditDeepTest();
  CacheTest();
  BeanAndUtilsTest();
  ConstantsAndModelTest();
  ConstantsAndModelContractsTest();
  ThrottleTest();
  AbilityContractTest();
  CoreUtilsAndContractsTest();
  CoreUtilsAndContractsOnlyTest();
  StorageAndPolicyTest();
  StorageAndPolicyDeepTest();
  StorageContractDeepTest();
  DockerPolicyTest();
  AccessibilityTest();
  FocusAndNavigationTest();
  FocusNavigationDeepTest();
  KeyEventTest();
  KeyEventAndNavigationTest();
  LifecycleTest();
  LifecycleStressTest();
  RecentTest();
  RecentAndLifecycleDeepTest();
  MultiWindowTest();
  PersistenceTest();
  OpsInteractionTest();
  PerformanceAndRenderTest();
  ExpandedScenarioTest();
  ScenarioRegressionTest();
  FullContractRegressionTest();
  StatusBarAndAccessibilityDeepTest();
  StyleConstantsDeepTest();
  MassiveAutoExpansionTest();
  ManagerAndLoggingContractsTest();
  CacheManagerContractsTest();
  MainAbilityAndPreferenceContractsTest();
  LauncherWindowDockerContractsTest();
  ResourceAndEventContractsTest();
  IntegrationEndToEndTest();
  DesktopAndEditFlowTest();
  StressChaosRegressionDeepTest();
  // RotationTest();
  // RotationResolutionPerformanceDeepTest();
}
