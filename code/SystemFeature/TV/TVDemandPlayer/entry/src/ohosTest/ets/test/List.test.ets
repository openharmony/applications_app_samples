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
import AbilityRoutingContractTest from './AbilityRoutingContract.test'
import AvPlayerAllInTest from './AvPlayerAllIn.test'
import AvPlayerAllScenariosTest from './AvPlayerAllScenarios.test'
import AvPlayerAllScenariosContractTest from './AvPlayerAllScenariosContract.test'
import AvPlayerCoreTest from './AvPlayerCore.test'
import AvPlayerLightContractTest from './AvPlayerLightContract.test'
import AvPlayerPlayStopContractTest from './AvPlayerPlayStopContract.test'
import AvPlayerSeekSpeedContractTest from './AvPlayerSeekSpeedContract.test'
import AvPlayerStateMachineContractTest from './AvPlayerStateMachineContract.test'
import AvPlayerSubtitleFullContractTest from './AvPlayerSubtitleFullContract.test'
import CommonEventContractTest from './CommonEventContract.test'
import ComprehensiveContractTest from './ComprehensiveContract.test'
import ConcurrencyStressContractTest from './ConcurrencyStressContract.test'
import ConstantsContractTest from './ConstantsContract.test'
import ContractAllInTest from './ContractAllIn.test'
import CoreAllInTest from './CoreAllIn.test'
import CoreGuardContractTest from './CoreGuardContract.test'
import DateContractTest from './DateContract.test'
import DistributedContractTest from './DistributedContract.test'
import DistributedEventCodeContractTest from './DistributedEventCodeContract.test'
import DlnaServiceContractTest from './DlnaServiceContract.test'
import DlnaServiceCoreTest from './DlnaServiceCore.test'
import DlnaServiceFullContractTest from './DlnaServiceFullContract.test'
import DomainModelsTest from './DomainModels.test'
import DrmAndContractCoreTest from './DrmAndContractCore.test'
import DrmModelContractTest from './DrmModelContract.test'
import EventBusAllInTest from './EventBusAllIn.test'
import EventBusContractTest from './EventBusContract.test'
import EventBusFullContractTest from './EventBusFullContract.test'
import EventBusLargeDatasetTest from './EventBusLargeDataset.test'
import FoldListArrayContractTest from './FoldListArrayContract.test'
import FullCoverageStressTest from './FullCoverageStress.test'
import FullMatrixContractTest from './FullMatrixContract.test'
import HttpContractTest from './HttpContract.test'
import KeyEventContractTest from './KeyEventContract.test'
import LanguageCodeUtilContractTest from './LanguageCodeUtilContract.test'
import LanguageTimeDrmContractTest from './LanguageTimeDrmContract.test'
import LogContractTest from './LogContract.test'
import PageBusinessContractTest from './PageBusinessContract.test'
import PageIntegrationContractTest from './PageIntegrationContract.test'
import PagePlayerMatrixTest from './PagePlayerMatrix.test'
import PermissionContractTest from './PermissionContract.test'
import PointerEventUtilContractTest from './PointerEventUtilContract.test'
import ProjectionPopupContractTest from './ProjectionPopupContract.test'
import RdbWindowContractTest from './RdbWindowContract.test'
import ReplayRecoveryScenarioTest from './ReplayRecoveryScenario.test'
import ServiceAbilityContractTest from './ServiceAbilityContract.test'
import SettingButtonVideoSizeContractTest from './SettingButtonVideoSizeContract.test'
import StressAllInTest from './StressAllIn.test'
import StressAndBoundaryContractTest from './StressAndBoundaryContract.test'
import SubWindowDeepContractTest from './SubWindowDeepContract.test'
import ThrottleDecoratorContractTest from './ThrottleDecoratorContract.test'
import TypeContractTest from './TypeContract.test'
import TypeModelConstantFullContractTest from './TypeModelConstantFullContract.test'
import TypeModelContractTest from './TypeModelContract.test'
import UiSmokeScenarioTest from './UiSmokeScenario.test'
import UtilsCoreTest from './UtilsCore.test'
import UtilsLibraryContractTest from './UtilsLibraryContract.test'
import UtilsMatrixContractTest from './UtilsMatrixContract.test'
import UtilsTimeVideoContractTest from './UtilsTimeVideoContract.test'
import VideoOperateContractTest from './VideoOperateContract.test'
import VideoSettingControllerContractTest from './VideoSettingControllerContract.test'
import WindowRotationContractTest from './WindowRotationContract.test'
import WorkerAllInTest from './WorkerAllIn.test'
import WorkerDataFlowTest from './WorkerDataFlow.test'
import WorkerDataFlowContractTest from './WorkerDataFlowContract.test'
import WorkerFullContractTest from './WorkerFullContract.test'

export default function testsuite() {
  abilityTest()
  AbilityRoutingContractTest()
  AvPlayerAllInTest()
  AvPlayerAllScenariosTest()
  AvPlayerAllScenariosContractTest()
  AvPlayerCoreTest()
  AvPlayerLightContractTest()
  AvPlayerPlayStopContractTest()
  AvPlayerSeekSpeedContractTest()
  AvPlayerStateMachineContractTest()
  AvPlayerSubtitleFullContractTest()
  CommonEventContractTest()
  ComprehensiveContractTest()
  ConcurrencyStressContractTest()
  ConstantsContractTest()
  ContractAllInTest()
  CoreAllInTest()
  CoreGuardContractTest()
  DateContractTest()
  DistributedContractTest()
  DistributedEventCodeContractTest()
  DlnaServiceContractTest()
  DlnaServiceCoreTest()
  DlnaServiceFullContractTest()
  DomainModelsTest()
  DrmAndContractCoreTest()
  DrmModelContractTest()
  EventBusAllInTest()
  EventBusContractTest()
  EventBusFullContractTest()
  EventBusLargeDatasetTest()
  FoldListArrayContractTest()
  HttpContractTest()
  KeyEventContractTest()
  LanguageCodeUtilContractTest()
  LanguageTimeDrmContractTest()
  LogContractTest()
  PageBusinessContractTest()
  PageIntegrationContractTest()
  PagePlayerMatrixTest()
  PermissionContractTest()
  PointerEventUtilContractTest()
  ProjectionPopupContractTest()
  RdbWindowContractTest()
  ReplayRecoveryScenarioTest()
  ServiceAbilityContractTest()
  SettingButtonVideoSizeContractTest()
  StressAllInTest()
  StressAndBoundaryContractTest()
  SubWindowDeepContractTest()
  ThrottleDecoratorContractTest()
  TypeContractTest()
  TypeModelConstantFullContractTest()
  TypeModelContractTest()
  UiSmokeScenarioTest()
  UtilsCoreTest()
  UtilsLibraryContractTest()
  UtilsMatrixContractTest()
  UtilsTimeVideoContractTest()
  VideoOperateContractTest()
  VideoSettingControllerContractTest()
  WindowRotationContractTest()
  WorkerAllInTest()
  WorkerDataFlowTest()
  WorkerDataFlowContractTest()
  FullCoverageStressTest()
  FullMatrixContractTest()
  WorkerFullContractTest()
}
