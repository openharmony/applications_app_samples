/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import commonEvent from '@ohos.commonEvent'

export default class SurveillanceEventsManager {
  constructor() {
  }

  static getSurveillanceEventStates(): any {
    return {
      "usual.event.wifi.POWER_STATE": globalThis.settings.get(commonEvent.Support.COMMON_EVENT_WIFI_POWER_STATE),
      "usual.event.SCREEN_OFF": globalThis.settings.get(commonEvent.Support.COMMON_EVENT_SCREEN_OFF),
      "usual.event.SCREEN_ON": globalThis.settings.get(commonEvent.Support.COMMON_EVENT_SCREEN_ON),
    }
  }

  static surveillanceEvents: Array<string> = [
    commonEvent.Support.COMMON_EVENT_WIFI_POWER_STATE,
    commonEvent.Support.COMMON_EVENT_SCREEN_OFF,
    commonEvent.Support.COMMON_EVENT_SCREEN_ON
  ]
}