/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import Ability_test from './Ability.test';
import ability_EntryAbility_test from './ability/EntryAbility.test';
import common_Constants_test from './common/Constants.test';
import common_DisplayCalculator_test from './common/DisplayCalculator.test';
import comprehensive_CameraAdvanced_test from './comprehensive/CameraAdvanced.test';
import comprehensive_CameraComprehensive_test from './comprehensive/CameraComprehensive.test';
import comprehensive_CameraUltimate_test from './comprehensive/CameraUltimate.test';
import features_CameraFeature_test from './features/CameraFeature.test';
import i18n_CameraI18n_test from './i18n/CameraI18n.test';
import integration_CameraIntegration_test from './integration/CameraIntegration.test';
import model_CameraPermissionManager_test from './model/CameraPermissionManager.test';
import model_CameraPreviewManager_test from './model/CameraPreviewManager.test';
import model_CameraSettingsManager_test from './model/CameraSettingsManager.test';
import model_CameraStateManager_test from './model/CameraStateManager.test';
import model_MediaStoreManager_test from './model/MediaStoreManager.test';
import model_MediaUtils_test from './model/MediaUtils.test';
import model_RemoteDeviceModel_test from './model/RemoteDeviceModel.test';
import models_CameraModel_test from './models/CameraModel.test';
import pages_CameraSettingsPage_test from './pages/CameraSettingsPage.test';
import pages_Index_test from './pages/Index.test';
import pages_IndexPageExtensive_test from './pages/IndexPageExtensive.test';
import pages_MultiCameraPreviewPage_test from './pages/MultiCameraPreviewPage.test';
import performance_CameraPerformance_test from './performance/CameraPerformance.test';
import security_CameraSecurity_test from './security/CameraSecurity.test';
import services_CameraService_test from './services/CameraService.test';
import ui_CameraUI_test from './ui/CameraUI.test';
import utils_AdvancedSettings_test from './utils/AdvancedSettings.test';
import utils_AIService_test from './utils/AIService.test';
import utils_ARService_test from './utils/ARService.test';
import utils_ArrayUtil_test from './utils/ArrayUtil.test';
import utils_AudioManager_test from './utils/AudioManager.test';
import utils_BooleanUtil_test from './utils/BooleanUtil.test';
import utils_CameraHotplugLogger_test from './utils/CameraHotplugLogger.test';
import utils_CameraHotplugToast_test from './utils/CameraHotplugToast.test';
import utils_CloudService_test from './utils/CloudService.test';
import utils_DateTimeUtil_test from './utils/DateTimeUtil.test';
import utils_DeviceManager_test from './utils/DeviceManager.test';
import utils_EventUtil_test from './utils/EventUtil.test';
import utils_FileUtil_test from './utils/FileUtil.test';
import utils_FloatWindowManager_test from './utils/FloatWindowManager.test';
import utils_GlobalThis_test from './utils/GlobalThis.test';
import utils_I18nService_test from './utils/I18nService.test';
import utils_ImageProcessing_test from './utils/ImageProcessing.test';
import utils_ListDetailed_test from './utils/ListDetailed.test';
import utils_Logger_test from './utils/Logger.test';
import utils_MultiDeviceService_test from './utils/MultiDeviceService.test';
import utils_NetworkManager_test from './utils/NetworkManager.test';
import utils_NumberUtil_test from './utils/NumberUtil.test';
import utils_ObjectUtil_test from './utils/ObjectUtil.test';
import utils_PerformanceOptimization_test from './utils/PerformanceOptimization.test';
import utils_PreferenceManagerDetailed_test from './utils/PreferenceManagerDetailed.test';
import utils_PreferencesManager_test from './utils/PreferencesManager.test';
import utils_PreferenceUtil_test from './utils/PreferenceUtil.test';
import utils_PointerUtil_test from './utils/PointerUtil.test';
import utils_SecurityService_test from './utils/SecurityService.test';
import utils_SensorManager_test from './utils/SensorManager.test';
import utils_StorageManager_test from './utils/StorageManager.test';
import utils_StringUtil_test from './utils/StringUtil.test';
import utils_UserInterface_test from './utils/UserInterface.test';
import utils_VideoManager_test from './utils/VideoManager.test';
import utils_WindowMoverManager_test from './utils/WindowMoverManager.test';
import views_ModeSwitchPage_test from './views/ModeSwitchPage.test';
import views_ShootFrame_test from './views/ShootFrame.test';

export default function testsuite() {
  Ability_test();
  ability_EntryAbility_test();
  common_Constants_test();
  common_DisplayCalculator_test();
  comprehensive_CameraAdvanced_test();
  comprehensive_CameraComprehensive_test();
  comprehensive_CameraUltimate_test();
  features_CameraFeature_test();
  i18n_CameraI18n_test();
  integration_CameraIntegration_test();
  model_CameraPermissionManager_test();
  model_CameraPreviewManager_test();
  model_CameraSettingsManager_test();
  model_CameraStateManager_test();
  model_MediaStoreManager_test();
  model_MediaUtils_test();
  model_RemoteDeviceModel_test();
  models_CameraModel_test();
  pages_CameraSettingsPage_test();
  pages_Index_test();
  pages_IndexPageExtensive_test();
  pages_MultiCameraPreviewPage_test();
  performance_CameraPerformance_test();
  security_CameraSecurity_test();
  services_CameraService_test();
  ui_CameraUI_test();
  utils_AdvancedSettings_test();
  utils_AIService_test();
  utils_ARService_test();
  utils_ArrayUtil_test();
  utils_AudioManager_test();
  utils_BooleanUtil_test();
  utils_CameraHotplugLogger_test();
  utils_CameraHotplugToast_test();
  utils_CloudService_test();
  utils_DateTimeUtil_test();
  utils_DeviceManager_test();
  utils_EventUtil_test();
  utils_FileUtil_test();
  utils_FloatWindowManager_test();
  utils_GlobalThis_test();
  utils_I18nService_test();
  utils_ImageProcessing_test();
  utils_ListDetailed_test();
  utils_Logger_test();
  utils_MultiDeviceService_test();
  utils_NetworkManager_test();
  utils_NumberUtil_test();
  utils_ObjectUtil_test();
  utils_PerformanceOptimization_test();
  utils_PreferenceManagerDetailed_test();
  utils_PreferencesManager_test();
  utils_PreferenceUtil_test();
  utils_PointerUtil_test();
  utils_SecurityService_test();
  utils_SensorManager_test();
  utils_StorageManager_test();
  utils_StringUtil_test();
  utils_UserInterface_test();
  utils_VideoManager_test();
  utils_WindowMoverManager_test();
  views_ModeSwitchPage_test();
  views_ShootFrame_test();
}
