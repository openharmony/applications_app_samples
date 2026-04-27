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
 
import { window } from '@kit.ArkUI';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

export interface Rect {
  left: number;
  top: number;
  width: number;
  height: number;
};

export type WindowType = 'status' | 'navigation' | 'volume';

export function getWindowName(windowType: number): WindowType {
  switch (windowType) {
    case window.WindowType.TYPE_NAVIGATION_BAR:
      return 'navigation';
    case window.WindowType.TYPE_STATUS_BAR:
      return 'status';
    case window.WindowType.TYPE_VOLUME_OVERLAY:
      return 'volume';
  }
  return 'status';
}

export default class Constants {
  static readonly URI_VAR = 'datashare:///com.ohos.settingsdata.DataAbility';
}

export enum FASlotName {
  AUTO_ROTATE = 'auto_rotate',
  AIR_PLANE = 'air_plane',
  BATTERY = 'battery',
  BLUETOOTH = 'bluetooth',
  CAPSULE = 'capsule',
  CLOCK = 'clock',
  EMPTY = 'empty',
  LOCATION = 'location',
  NOTIFICATION = 'notification',
  RING_MODE = 'ring_mode',
  SIGNAL = 'signal',
  WIFI = 'wifi',
  NFC = 'nfc',
}

export function isNfcAvailable(){
  if (systemParameterEnhance.getSync('const.SystemCapability.Communication.NFC.Core', 'false') == 'false'){
    return false
  } else {
    return true
  }
 }
