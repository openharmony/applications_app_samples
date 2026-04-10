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

import { StaticSubscriberExtensionAbility } from '@kit.BasicServicesKit';
import { commonEventManager } from '@kit.BasicServicesKit';
import getScreenOffTime, {
  DEFAULT_SCREEN_OFF_TIME,
  DEFAULT_SWITCH_ITEM_VALUE,
  SCREEN_OFF_PREFERENCE_NAME,
  SCREEN_OFF_KEY_SWITCH,
  SCREEN_OFF_KEY_SINGLE_ITEM,
} from '../pages/general/AutoScreenOff';
import { PreferencesUtil } from './PreferencesUtil';
import { power } from '@kit.BasicServicesKit';

const TAG: string = '[BootCompletedSubscriber] : '
const COMMON_EVENT_BOOT_COMPLETED: string = 'usual.event.BOOT_COMPLETED'

export default class BootCompletedSubscriber extends StaticSubscriberExtensionAbility {
  onReceiveEvent(eventData: commonEventManager.CommonEventData) {
    console.info(TAG, `onReceiveEvent, event: ${JSON.stringify(eventData)}`);
    if (eventData && eventData.event === COMMON_EVENT_BOOT_COMPLETED) {
      let isSwitchOn = PreferencesUtil.getParam(this.context, SCREEN_OFF_PREFERENCE_NAME, SCREEN_OFF_KEY_SWITCH);
      if (isSwitchOn !== DEFAULT_SWITCH_ITEM_VALUE) {
        console.debug(TAG, 'onReceiveEvent setScreenOffTime off.');
        power.setScreenOffTime(DEFAULT_SCREEN_OFF_TIME);
      } else {
        let timeParam = PreferencesUtil.getParam(this.context, SCREEN_OFF_PREFERENCE_NAME, SCREEN_OFF_KEY_SINGLE_ITEM);
        console.debug(TAG, 'onReceiveEvent setScreenOffTime timeParam =' + timeParam);
        power.setScreenOffTime(getScreenOffTime(timeParam));
      }
    }
  }
}
