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

/**
 * @file List.test.ets
 * @overview TVSettingsData 自动化测试入口文件
 *           整合所有测试模块，按功能域组织测试套件
 */

import configAndConstantsTest from './ConfigAndConstants.test';
import globalContextAndLogTest from './GlobalContextAndLog.test';
import settingsDBHelperTest from './SettingsDBHelper.test';
import dataExtAbilityCoreTest from './DataExtAbilityCore.test';
import permissionAndSecurityTest from './PermissionAndSecurity.test';
import systemSettingsTest from './SystemSettings.test';
import persistenceAndLifecycleTest from './PersistenceAndLifecycle.test';
import boundaryAndExceptionTest from './BoundaryAndException.test';
import performanceAndStressTest from './PerformanceAndStress.test';
import integrationAndScenarioTest from './IntegrationAndScenario.test';
import dataExtAbilityAdvancedTest from './DataExtAbilityAdvanced.test';
import dataModelAndTypesTest from './DataModelAndTypes.test';
import settingsDataConfigExtendedTest from './SettingsDataConfigExtended.test';
import settingsDBHelperExtendedTest from './SettingsDBHelperExtended.test';
import globalContextExtendedTest from './GlobalContextExtended.test';
import logExtendedTest from './LogExtended.test';
import dataExtAbilityLifecycleTest from './DataExtAbilityLifecycle.test';
import dataSharePredicatesExtendedTest from './DataSharePredicatesExtended.test';
import settingsDataOperationsTest from './SettingsDataOperations.test';
import settingsDataOperationsEnhancedTest from './SettingsDataOperationsEnhanced.test';
import settingsDataOperationsOptimizedTest from './SettingsDataOperationsOptimized.test';
import settingsDataValidationTest from './SettingsDataValidation.test';
import errorHandlingAndRecoveryTest from './ErrorHandlingAndRecovery.test';
import rdbStoreOperationsTest from './RdbStoreOperations.test';
import settingsDataMigrationTest from './SettingsDataMigration.test';
import settingsDataConcurrencyTest from './SettingsDataConcurrency.test';
import settingsDataSecurityTest from './SettingsDataSecurity.test';
import settingsDataPerformanceTest from './SettingsDataPerformance.test';
import settingsDataCompatibilityTest from './SettingsDataCompatibility.test';
import settingsDataStressExtendedTest from './SettingsDataStressExtended.test';
import settingsDataEdgeCasesTest from './SettingsDataEdgeCases.test';
import settingsDataConsistencyTest from './SettingsDataConsistency.test';
import settingsDataRegressionTest from './SettingsDataRegression.test';
import settingsDataPredicatesTest from './SettingsDataPredicates.test';
import settingsDataResultSetTest from './SettingsDataResultSet.test';
import settingsDataContractTest from './SettingsDataContract.test';
import settingsDataFinalTest from './SettingsDataFinal.test';
import settingsDataRobustnessTest from './SettingsDataRobustness.test';
import settingsDataSmokeTest from './SettingsDataSmoke.test';

export default function testsuite(): void {
  configAndConstantsTest();
  globalContextAndLogTest();
  settingsDBHelperTest();
  dataExtAbilityCoreTest();
  permissionAndSecurityTest();
  systemSettingsTest();
  persistenceAndLifecycleTest();
  boundaryAndExceptionTest();
  performanceAndStressTest();
  integrationAndScenarioTest();
  dataExtAbilityAdvancedTest();
  dataModelAndTypesTest();
  settingsDataConfigExtendedTest();
  settingsDBHelperExtendedTest();
  globalContextExtendedTest();
  logExtendedTest();
  dataExtAbilityLifecycleTest();
  dataSharePredicatesExtendedTest();
  settingsDataOperationsTest();
  settingsDataOperationsEnhancedTest();
  settingsDataOperationsOptimizedTest();
  settingsDataValidationTest();
  errorHandlingAndRecoveryTest();
  rdbStoreOperationsTest();
  settingsDataMigrationTest();
  settingsDataConcurrencyTest();
  settingsDataSecurityTest();
  settingsDataPerformanceTest();
  settingsDataCompatibilityTest();
  settingsDataStressExtendedTest();
  settingsDataEdgeCasesTest();
  settingsDataConsistencyTest();
  settingsDataRegressionTest();
  settingsDataPredicatesTest();
  settingsDataResultSetTest();
  settingsDataContractTest();
  settingsDataFinalTest();
  settingsDataRobustnessTest();
  settingsDataSmokeTest();
}
