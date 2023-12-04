/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { getString } from '@ohos/common/src/main/ets/util/ResourceUtil';
import {
  BatteryStats,
  BrightnessManager,
  PowerManager,
  SettingsManager,
  SystemCapability,
  SystemParameter,
  BatteryView,
  DeviceInfo,
  InputConsumer,
  MouseManager,
  InputEventManager,
  InputDeviceManager,
  InputKeyEventManager
} from '@ohos/capabilities';

@Component
export struct Capabilities {
  @StorageLink('selectedLabel') selectedLabel: string = '';
  @State label: string = '';

  aboutToAppear() {
    // StorageLink会触发多次刷新，用State接收
    this.label = this.selectedLabel;
  }

  build() {
    Column() {
      // 此处根据选中的菜单，显示对应的页面内容
      if (this.label === getString($r('app.string.battery_statistics'))) {
        BatteryStats()
      } else if (this.label === getString($r('app.string.brightness_manager'))) {
        BrightnessManager()
      } else if (this.label === getString($r('app.string.power_manager'))) {
        PowerManager()
      } else if (this.label === getString($r('app.string.settings'))) {
        SettingsManager()
      } else if (this.label === getString($r('app.string.system_capability'))) {
        SystemCapability()
      } else if (this.label === getString($r('app.string.system_parameter'))) {
        SystemParameter()
      } else if (this.label === getString($r('app.string.battery_info'))) {
        BatteryView()
      } else if (this.label === getString($r('app.string.device_info'))) {
        DeviceInfo()
      } else if (this.label === getString($r('app.string.input_consumer'))) {
        InputConsumer()
      } else if (this.label === getString($r('app.string.mouse_pointer'))) {
        MouseManager()
      } else if (this.label === getString($r('app.string.input_event'))) {
        InputEventManager()
      } else if (this.label === getString($r('app.string.input_device'))) {
        InputDeviceManager()
      } else if (this.label === getString($r('app.string.input_key_event'))) {
        InputKeyEventManager()
      }
    }
    .padding({ left: 12, right: 12 })
  }
}