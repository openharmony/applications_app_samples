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
 

import { commonEventManager } from '@kit.BasicServicesKit';
import { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import createOrGet from './SingleInstanceHelper';
import EventManager from './event/EventManager';
import Log from './Log';
import { obtainLocalEvent } from './event/EventUtil';

export const SCREEN_CHANGE_EVENT = 'screenChangeEvent';

const TAG = 'ScreenLockManager';
interface ScreenCommonEventInfo {
  events: string[];
}
const SCREEN_COMMON_EVENT_INFO: ScreenCommonEventInfo = {
  events: [commonEventManager.Support.COMMON_EVENT_SCREEN_OFF, commonEventManager.Support.COMMON_EVENT_SCREEN_ON],
};

class ScreenLockManager {
  private mSubscriber: CommonEventSubscriber | undefined;

  async init(): Promise<void> {
    this.mSubscriber = await commonEventManager.createSubscriber(SCREEN_COMMON_EVENT_INFO);
    commonEventManager.subscribe(this.mSubscriber, (err, data) => {
      if (err.code != 0) {
        Log.showError(TAG, `Can't handle screen change, err: ${JSON.stringify(err)}`);
        return;
      }
      Log.showDebug(TAG, `screenChange, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      switch (data.event) {
        case commonEventManager.Support.COMMON_EVENT_SCREEN_OFF:
          this.notifyScreenEvent(false);
          break;
        case commonEventManager.Support.COMMON_EVENT_SCREEN_ON:
          this.notifyScreenEvent(true);
          break;
        default:
          Log.showError(TAG, 'unknow event');
      }
    });
  }

  notifyScreenEvent(isScreenOn: boolean): void {
    EventManager.publish(obtainLocalEvent(SCREEN_CHANGE_EVENT, isScreenOn));
    Log.showDebug(TAG, `publish ${SCREEN_CHANGE_EVENT} screenState: ${isScreenOn ? 'true' : 'false'}`);
  }
}

let sScreenLockManager = createOrGet(() => new ScreenLockManager(), TAG);

export default sScreenLockManager;