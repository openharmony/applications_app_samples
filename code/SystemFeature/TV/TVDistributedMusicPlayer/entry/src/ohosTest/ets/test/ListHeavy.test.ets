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
 
import typeComprehensiveTest from './const/Type.comprehensive.test';
import mainAbilityComprehensiveTest from './ability/MainAbility.comprehensive.test';
import serviceAbilityComprehensiveTest from './serviceability/ServiceAbility.comprehensive.test';
import musicSharedDefinitionComprehensiveTest from './common/MusicSharedDefinition.comprehensive.test';
import kvStoreModelComprehensiveTest from './model/KvStoreModel.comprehensive.test';
import remoteDeviceModelComprehensiveTest from './model/RemoteDeviceModel.comprehensive.test';
import musicPlayerComprehensiveTest from './model/MusicPlayer.comprehensive.test';
import musicPlayerComprehensive001Test from './model/MusicPlayer.comprehensive.001.test';
import playStateComprehensiveTest from './model/PlayState.comprehensive.test';
import buttonModelComprehensiveTest from './model/ButtonModel.comprehensive.test';
import musicComprehensiveTest from './model/Music.comprehensive.test';
import uiModelsComprehensiveTest from './model/UIModels.comprehensive.test';
import logComprehensiveTest from './utils/Log.comprehensive.test';
import loggerComprehensiveTest from './utils/Logger.comprehensive.test';
import preferencesComprehensiveTest from './utils/Preferences.comprehensive.test';
import utilsComprehensiveTest from './utils/Utils.comprehensive.test';
import indexComprehensive001Test from './page/Index.comprehensive.001.test';
import indexComprehensive002Test from './page/Index.comprehensive.002.test';
import commonComprehensiveTest from './common/CommonComprehensive.test';
import eventUtilComprehensiveTest from './common/EventUtil.comprehensive.test';
import pointerUtilComprehensiveTest from './common/PointerUtil.comprehensive.test';
import deviceDialogComprehensiveTest from './common/DeviceDialog.comprehensive.test';
import musicConstantsComprehensiveTest from './common/MusicConstants.comprehensive.test';
import integrationScenario001Test from './integration/IntegrationScenario.001.test';
import integrationScenario002Test from './integration/IntegrationScenario.002.test';
import regressionCanarySecurity001Test from './stress/RegressionCanarySecurity.001.test';
import exceptionFlow001Test from './stress/ExceptionFlow.001.test';
import ultraStress001Test from './stress/UltraStress.001.test';
import depthDomain001Test from './stress/DepthDomain.001.test';
import megaStress001Test from './stress/MegaStress.001.test';
import extendedCoverage001Test from './stress/ExtendedCoverage.001.test';
import concurrentTest001Test from './stress/ConcurrentTest.001.test';
import fullRegressionSuite001Test from './stress/FullRegressionSuite.001.test';
import comprehensiveFinal001Test from './stress/ComprehensiveFinal.001.test';
import comprehensiveFinal002Test from './stress/ComprehensiveFinal.002.test';
import boundaryValue001Test from './stress/BoundaryValue.001.test';
import stressChaos002Test from './stress/StressChaos.002.test';

export default function testsuiteHeavy(): void {
  typeComprehensiveTest();
  mainAbilityComprehensiveTest();
  serviceAbilityComprehensiveTest();
  musicSharedDefinitionComprehensiveTest();
  kvStoreModelComprehensiveTest();
  remoteDeviceModelComprehensiveTest();
  musicPlayerComprehensiveTest();
  musicPlayerComprehensive001Test();
  playStateComprehensiveTest();
  buttonModelComprehensiveTest();
  musicComprehensiveTest();
  uiModelsComprehensiveTest();
  logComprehensiveTest();
  loggerComprehensiveTest();
  preferencesComprehensiveTest();
  utilsComprehensiveTest();
  indexComprehensive001Test();
  indexComprehensive002Test();
  commonComprehensiveTest();
  eventUtilComprehensiveTest();
  pointerUtilComprehensiveTest();
  deviceDialogComprehensiveTest();
  musicConstantsComprehensiveTest();
  integrationScenario001Test();
  integrationScenario002Test();
  regressionCanarySecurity001Test();
  exceptionFlow001Test();
  ultraStress001Test();
  depthDomain001Test();
  megaStress001Test();
  extendedCoverage001Test();
  concurrentTest001Test();
  fullRegressionSuite001Test();
  comprehensiveFinal001Test();
  comprehensiveFinal002Test();
  boundaryValue001Test();
  stressChaos002Test();
}
