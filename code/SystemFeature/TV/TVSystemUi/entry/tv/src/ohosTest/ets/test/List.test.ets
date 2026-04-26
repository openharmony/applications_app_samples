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
 

import abilityManagerTest from './AbilityManager.test';
import checkEmptyUtilsTest from './CheckEmptyUtils.test';
import commonStyleManagerTest from './CommonStyleManager.test';
import dialogModuleTest from './DialogModule.test';
import decoratorsTest from './Decorators.test';
import eventBusTest from './EventBus.test';
import heightConfigUtilsTest from './HeightConfigUtils.test';
import logTest from './Log.test';
import partsPairModelTest from './PartsPairModel.test';
import pairModelsTest from './PairModels.test';
import resourceUtilTest from './ResourceUtil.test';
import sceneTests from './SceneTests.test';
import timeManagerTest from './TimeManager.test';
import volumeConstantsTest from './VolumeConstants.test';
import volumePanelVMTest from './VolumePanelVM.test';
import volumeWindowControllerTest from './VolumeWindowController.test';
import settingsUtilIntegrationTest from './SettingsUtilIntegration.test';
import windowManagerFullTest from './WindowManagerFull.test';
import stringUtilTest from './StringUtil.test';
import volumePanelServiceTest from './VolumePanelService.test';
import arrayBufferUtilTest from './ArrayBufferUtil.test';
import eventUtilTest from './EventUtil.test';
import timeoutPromiseTest from './TimeoutPromise.test';

export default function testsuite() {
  abilityManagerTest();
  checkEmptyUtilsTest();
  commonStyleManagerTest();
  dialogModuleTest();
  decoratorsTest();
  eventBusTest();
  heightConfigUtilsTest();
  logTest();
  partsPairModelTest();
  pairModelsTest();
  resourceUtilTest();
  sceneTests();
  timeManagerTest();
  volumeConstantsTest();
  volumePanelVMTest();
  volumeWindowControllerTest();
  settingsUtilIntegrationTest();
  windowManagerFullTest();
  stringUtilTest();
  volumePanelServiceTest();
  arrayBufferUtilTest();
  eventUtilTest();
  timeoutPromiseTest();
}
