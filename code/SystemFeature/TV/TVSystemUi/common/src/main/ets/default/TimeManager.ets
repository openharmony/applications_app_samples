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
 

import { settings } from '@kit.BasicServicesKit';
import { commonEventManager } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import Log from './Log';
import EventManager from './event/EventManager';
import createOrGet from './SingleInstanceHelper';
import { obtainLocalEvent } from './event/EventUtil';
import { CommonEventManager, getCommonEventManager, POLICY, SubscribeInfos } from './commonEvent/CommonEventManager';

export const TIME_CHANGE_EVENT = 'Time_Change_Event';

export interface TimeEventArgs {
  date: Date;
  timeFormat: boolean;
}

const TAG = 'TimeManager';
const TIME_FORMAT_KEY = settings.date.TIME_FORMAT;
const TIME_SUBSCRIBE_INFO: SubscribeInfos = {
  events: [
    commonEventManager.Support.COMMON_EVENT_TIME_CHANGED,
    commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED,
    commonEventManager.Support.COMMON_EVENT_TIME_TICK,
  ],
};

function fill(value: number): string {
  return (value > 9 ? '' : '0') + value;
}

export function concatTime(h: number, m: number): string {
  return `${fill(h)}:${fill(m)}`;
}

class TimeManager {
  private mUse24hFormat: boolean = false;
  private mContext: common.Context | undefined;
  private mManager?: CommonEventManager;

  public init(context: common.Context): void {
    this.mContext = context;
    this.mManager = getCommonEventManager(
      TAG,
      TIME_SUBSCRIBE_INFO, 
      () => this.notifyTimeChange(),
      (isSubscribe) => isSubscribe && this.notifyTimeChange()
    );
    this.mManager.subscriberCommonEvent();
    this.mManager.applyPolicy([POLICY.SCREEN_POLICY]);
    this.initTimeFormat(context);
  }

  public release(): void {
    this.mManager?.release();
    this.mManager = undefined;
  }

  public formatTime(date: Date): string {
    return concatTime(date.getHours() % (this.mUse24hFormat ? 24 : 12), date.getMinutes());
  }

  private initTimeFormat(context: common.Context): void {
    Log.showDebug(TAG, 'initTimeFormat');
    try {
      let timeString = settings.getValueSync(context, TIME_FORMAT_KEY, '24');
      Log.showDebug(TAG, `timeFormat change: ${timeString}`);
      this.mUse24hFormat = timeString == '24';
      this.notifyTimeChange();
    } catch (e) {
      Log.showError(TAG, `Can't listen timeformate change.`);
    }
  }

  private notifyTimeChange(): void {
    Log.showDebug(TAG, 'notifyTimeChange');
    let args: TimeEventArgs = {
      date: new Date(),
      timeFormat: this.mUse24hFormat,
    };
    EventManager.publish(obtainLocalEvent(TIME_CHANGE_EVENT, args));
  }
}

let sTimeManager = createOrGet(() => new TimeManager(), TAG);

export default sTimeManager as TimeManager;
