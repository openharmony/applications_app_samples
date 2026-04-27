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

import accessibilityDeepTest from './AccessibilityDeep.test'
import advancedTest from './Advanced.test'
import chaosTest from './Chaos.test'
import compatibilityMatrixTest from './CompatibilityMatrix.test'
import compatibilityMatrixCatalogATest from './CompatibilityMatrixCatalogA.test'
import compatibilityMatrixCatalogBTest from './CompatibilityMatrixCatalogB.test'
import compatibilityMatrixCatalogCTest from './CompatibilityMatrixCatalogC.test'
import concurrencyTest from './Concurrency.test'
import dataIntegrityTest from './DataIntegrity.test'
import i18nDeepTest from './I18nDeep.test'
import integrationSceneTest from './IntegrationScene.test'
import mainPageTest from './MainPage.test'
import performanceDeepTest from './PerformanceDeep.test'
import regressionTest from './Regression.test'
import screenShotModelTest from './ScreenShotModel.test'
import securityTest from './Security.test'
import serviceExtAbilityTest from './ServiceExtAbility.test'
import viewModelTest from './ViewModel.test'

/**
 * List.test.ets 是自动化测试套件的总入口。
 * 它负责聚合所有的测试模块，确保 Hvigor 编译器能一次性加载并执行全量用例。
 */
export default function testsuite() {
  accessibilityDeepTest()
  advancedTest()
  chaosTest()
  compatibilityMatrixTest()
  compatibilityMatrixCatalogATest()
  compatibilityMatrixCatalogBTest()
  compatibilityMatrixCatalogCTest()
  concurrencyTest()
  dataIntegrityTest()
  i18nDeepTest()
  integrationSceneTest()
  mainPageTest()
  performanceDeepTest()
  regressionTest()
  screenShotModelTest()
  securityTest()
  serviceExtAbilityTest()
  viewModelTest()
}
