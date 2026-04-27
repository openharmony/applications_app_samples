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

import abilityTest from './Ability.test'
import mockFactoriesTest from './foundation/MockFactories.test'
import testAssertsTest from './foundation/TestAsserts.test'
import testDataBuilderTest from './foundation/TestDataBuilder.test'
import srManagerDomainTest from './srmanager/SRManagerDomain.test'
import srManagerConcurrencyTest from './srmanager/SRManagerConcurrency.test'
import srManagerChaosTest from './srmanager/SRManagerChaos.test'
import windowManagerDomainTest from './window/WindowManagerDomain.test'
import floatWindowSceneTest from './window/FloatWindowScene.test'
import abilityLifecycleTest from './ability/AbilityLifecycle.test'
import recordingOrchestrationTest from './ability/RecordingOrchestration.test'

export default function testsuite() {
  abilityTest()
  mockFactoriesTest()
  testAssertsTest()
  testDataBuilderTest()
  srManagerDomainTest()
  srManagerConcurrencyTest()
  srManagerChaosTest()
  windowManagerDomainTest()
  floatWindowSceneTest()
  abilityLifecycleTest()
  recordingOrchestrationTest()
}
