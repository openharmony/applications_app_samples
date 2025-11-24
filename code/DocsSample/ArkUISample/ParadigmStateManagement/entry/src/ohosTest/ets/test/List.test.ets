/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { MigrationDestination } from '../../../main/ets/pages/migrationDataObjectVariables/Index';
import abilityTest from './Ability.test';
import extendTest from './Extend.test';
import InternalTest from './Internalmigrate.test';
import localTest from './Local.test';
import localBuilderTest from './LocalBuilder.test';
import migrationTest from './MigrationDataObjectVariables.test';
import monitorTest from './Monitor.test';
import paramTest from './Param.test';
import persistenceV2Test from './PersistenceV2.test';
import provideConsumeTest from './ProvideConsume.test';
import stateTest from './State.test';
import syncStateManagerTest from './SyncStateManager.test';

export default function testsuite() {
  abilityTest();
  localBuilderTest();
  extendTest();
  localTest();
  monitorTest();
  syncStateManagerTest();
  migrationTest();
  persistenceV2Test();
  provideConsumeTest();
  stateTest();
  paramTest();
  InternalTest();
}