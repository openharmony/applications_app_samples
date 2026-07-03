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

import common from '@ohos.app.ability.common';
import DragSceneInitParams from './DragSceneInitParams';
import PositionComputerUtil from '../util/PositionComputingUtil';
import WindowsUtil from '../util/WindowsUtil';
import VirtualDevicesController from '../model/virtual/VirtualDevicesController';
import OpenValleyManager from '../model/ble/openvalley/OpenValleyManager';
import { DeviceManagerFactory } from '@ohos/device_manager';

/**
 * 扫描模块，初始化入口
 */
export default class ScanRunner {
  static init(context: common.UIAbilityContext) {
    DragSceneInitParams.getInstance().initParams(context);
    PositionComputerUtil.getInstance().init();
    WindowsUtil.getInstance().initWindows(context);
    OpenValleyManager.init(context);
  }
};