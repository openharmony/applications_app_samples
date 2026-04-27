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
 

import Log from '../../../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
import { commonEventManager } from '@kit.BasicServicesKit';
import Constants from './common/constants';
import { inputEventClient as Input } from '@kit.InputKit';
const TAG = 'KeyCodeEvent'

let res;

export class KeyCodeEvent {
  public sendKeyEvent(keyCode: number, eventType: number) {
    Log.showInfo(TAG, `sendKeyEvent keycode: ${keyCode} type: ${eventType}`);
    switch (keyCode) {
      case Constants.KEYCODE_BACK:
        if (eventType === TouchType.Down) {
          Log.showDebug(TAG, 'sendKeyEvent : KEY_DOWN');
          this.sendBackKeyEventStart(); //down
        } else if (eventType === TouchType.Up) {
          Log.showDebug(TAG, `sendKeyEvent : KEY_UP`);
          this.sentEvnt();
          this.sendBackKeyEventEnd(); //up
        }
        break;
      case Constants.KEYCODE_HOME:
        if (eventType === TouchType.Up) {
          Log.showDebug(TAG, 'sendKeyEvent : KEY_UP');
          this.sentEvnt();
          this.sendHomeKeyEvent();
        }
        break;
      case Constants.KEYCODE_RECENT:
        if (eventType === TouchType.Up) {
          Log.showDebug(TAG, 'sendKeyEvent : KEY_UP');
          this.sentEvnt();
          this.sendRecentKeyEvent();
        }
        break;
      default:
        Log.showInfo(TAG, `sendKeyEvent case default keycode: ${keyCode} type: ${eventType}`);
        break;
    }
  }

  private sendBackKeyEventStart() {
    Log.showInfo(TAG, 'sendBackKeyEventStart');

    let keyEvent = {
      isPressed: true,
      // back keycode
      keyCode: 2,
      // After consulting the multi-mode subsystem, this parameter proved meaningless and remained unchanged
      keyDownDuration: 1,
      // This parameter changes with the version, and is currently 10008
      isIntercepted: false
    }
    res = Input.injectEvent({
      KeyEvent: keyEvent
    });
    Log.showDebug(TAG, `injectEventHandler injectEventSync down res: ${res}`);
  }

  private sendBackKeyEventEnd() {
    Log.showInfo(TAG, 'sendBackKeyEventEnd');
    let keyEvent = {
      isPressed: false,
      // back keycode
      keyCode: 2,
      // After consulting the multi-mode subsystem, this parameter proved meaningless and remained unchanged
      keyDownDuration: 1,
      // This parameter changes with the version, and is currently 10008
      isIntercepted: false
    }
    res = Input.injectEvent({
      KeyEvent: keyEvent
    });
  }

  private sendHomeKeyEvent() {
    AbilityManager.startServiceExtensionAbility(AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR), {
      bundleName: Constants.LAUNCHER_BUNDLE_NAME,
      abilityName: Constants.LAUNCHER_ABILITY_NAME
    });
  }

  private sendRecentKeyEvent() {
    commonEventManager.publish('CREATE_RECENT_WINDOW_EVENT', (err, data) => {
      Log.showInfo(TAG, `publish launcher err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
    });
  }

  private sentEvnt() {
    let commonEventPublishData = {
      code: 1,
      data: JSON.stringify({
        callType: 1
      })
    }

    commonEventManager.publish('SET_STATUSBAR_MIN_EVENT', commonEventPublishData, (err, data) => {
      Log.showInfo(TAG, `publish launcher err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
    });
  }
}

let keyCodeEvent = new KeyCodeEvent();

export default keyCodeEvent as KeyCodeEvent;
