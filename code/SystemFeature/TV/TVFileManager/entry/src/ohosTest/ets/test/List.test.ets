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

import abilityTest from './Ability.test';
import dataModelsTest from './DataModels_Test';
import utilsTest001 from './Utils_Test_001';
import utilsTest002 from './Utils_Test_002';
import managersCoreTest001 from './Managers_Core_Test_001';
import managersCoreTest002 from './Managers_Core_Test_002';
import managersAdvTest from './Managers_Adv_Test';
import adaptersDialogsTest001 from './Adapters_Dialogs_Test_001';
import adaptersDialogsTest002 from './Adapters_Dialogs_Test_002';
import pagesIntegrationTest001 from './Pages_Integration_Test_001';
import pagesIntegrationTest002 from './Pages_Integration_Test_002';
import boundaryEdgeTest001 from './Boundary_Edge_Test_001';
import stressMockTest001 from './Stress_Mock_Test_001';
import securityCompatTest from './Security_Compat_Test';
import mockStubTest from './Mock_Stub_Test';
import fileAccessManagerDeepTest from './FileAccessManager_Deep_Test';
import navPathStackDeepTest from './NavPathStack_Deep_Test';
import fileListStateMachineTest from './FileList_StateMachine_Test';
import indexLifecycleTest from './Index_Lifecycle_Test';
import permissionModelTest from './Permission_Model_Test';
import comprehensiveBoundaryTest from './Comprehensive_Boundary_Test';
import comprehensiveStressTest from './Comprehensive_Stress_Test';
import parameterizedDataDriveTest from './Parameterized_DataDrive_Test';
import crossModuleIntegrationTest from './CrossModule_Integration_Test';
import entryAbilityLifecycleTest from './EntryAbility_Lifecycle_Test';
import fileUtilTest from './FileUtil_Test';
import dialogComponentTest from './Dialog_Component_Test';
import extendedManagersTest from './Extended_Managers_Test';
import comprehensiveOperationTest from './Comprehensive_Operation_Test';
import dataConsistencyTest from './Data_Consistency_Test';
import shareWorkflowTest from './Share_Workflow_Test';
import fileTaskPoolTest from './FileTaskPool_Test';
import exhaustiveSuffixTest from './Exhaustive_Suffix_Test';
import finalIntegrationTest from './Final_Integration_Test';
import concurrencyRaceTest from './Concurrency_Race_Test';
import regressionEdgeTest from './Regression_Edge_Test';
import comprehensiveUIStateTest from './Comprehensive_UI_State_Test';

export default function testsuite() {
  abilityTest();
  dataModelsTest();
  utilsTest001();
  utilsTest002();
  managersCoreTest001();
  managersCoreTest002();
  managersAdvTest();
  adaptersDialogsTest001();
  adaptersDialogsTest002();
  pagesIntegrationTest001();
  pagesIntegrationTest002();
  boundaryEdgeTest001();
  stressMockTest001();
  securityCompatTest();
  mockStubTest();
  fileAccessManagerDeepTest();
  navPathStackDeepTest();
  fileListStateMachineTest();
  indexLifecycleTest();
  permissionModelTest();
  comprehensiveBoundaryTest();
  comprehensiveStressTest();
  parameterizedDataDriveTest();
  crossModuleIntegrationTest();
  entryAbilityLifecycleTest();
  fileUtilTest();
  dialogComponentTest();
  extendedManagersTest();
  comprehensiveOperationTest();
  dataConsistencyTest();
  shareWorkflowTest();
  fileTaskPoolTest();
  exhaustiveSuffixTest();
  finalIntegrationTest();
  concurrencyRaceTest();
  regressionEdgeTest();
  comprehensiveUIStateTest();
}
