/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import commonEvent from '@ohos.commonEventManager';

export default class consts {
  // definition for database
  static readonly DATA_BASE_NAME: string = "nothing_pre";
  static readonly DATA_BASE_KEY_TOTAL_TIMES: string = "totalTimes";
  static readonly DATA_BASE_KEY_START_TIME: string = "startTime";
  static readonly DATA_BASE_KEY_WIFI_POWER_STATE: string = commonEvent.Support.COMMON_EVENT_WIFI_POWER_STATE;
  static readonly DATA_BASE_KEY_SCREEN_OFF: string = commonEvent.Support.COMMON_EVENT_SCREEN_OFF;
  static readonly DATA_BASE_KEY_SCREEN_ON: string = commonEvent.Support.COMMON_EVENT_SCREEN_ON;
  static readonly DATA_BASE_KEY_SCREEN_LOCKED: string = commonEvent.Support.COMMON_EVENT_SCREEN_LOCKED;
  static readonly DATA_BASE_KEY_SCREEN_UNLOCKED: string = commonEvent.Support.COMMON_EVENT_SCREEN_UNLOCKED;
  static readonly DATA_BASE_KEY_ONCE_EVENTS: string = "onceCall";
  static readonly DATA_BASE_KEY_NEVER_EVENTS: string = "neverCall";

  // definition for event enable state
  static readonly ENABLE_STATE_ALWAYS : number = 0
  static readonly ENABLE_STATE_ONCE : number = 1
  static readonly ENABLE_STATE_NEVER : number = 2

  // definition for record volume
  static readonly MAX_RECORD_NUM: number = 10;

  // definition for self defined common events
  static readonly COMMON_EVENT_FINISH_MEDITATION: string = "finish_meditation"
  static readonly COMMON_EVENT_SETTING_UPDATE: string = "setting_update"
}