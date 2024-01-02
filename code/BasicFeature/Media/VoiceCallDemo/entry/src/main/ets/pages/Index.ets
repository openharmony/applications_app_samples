/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Caller from '../bean/Caller';
import IndexController from '../controller/IndexController';
import Constants from '../Constants';
import UIAnswer from '../components/UIAnswer';
import UIVoice from '../components/UIVoice';
import UICall from '../components/UICall';
import emitter from '@ohos.events.emitter';
import grantPermission from '../utils/PermissionUtils';
import Logger from '../utils/Logger';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';

/**
 * 首页，通过emitter完成UI切换
 */
@Entry
@Component
struct Index {
  private controller: IndexController = IndexController.getInstance();
  @State mRemote: Caller = { index: -1, name: $r('app.string.name_default'), head: $r('app.media.icon') };
  @StorageLink('UI_EVENT') mUIEvent: number = -1;

  aboutToAppear() {
    emitter.on({ eventId: Constants.EVENT_UI_CALL }, (data: emitter.EventData) => {
      this.onUIEvent(Constants.EVENT_UI_CALL);
    });
    emitter.on({ eventId: Constants.EVENT_UI_ANSWER }, (data: emitter.EventData) => {
      this.onUIEvent(Constants.EVENT_UI_ANSWER);
    });
    emitter.on({ eventId: Constants.EVENT_UI_VOICE }, (data: emitter.EventData) => {
      this.onUIEvent(Constants.EVENT_UI_VOICE);
    });

    grantPermission(getContext(this) as common.UIAbilityContext).then(result => {
      if (!result) {
        promptAction.showToast({ message: $r('app.string.tips_no_permission'), duration: 2000 });
      }
    });

    this.controller.init();
    this.mRemote = this.controller.getCaller();
  }

  aboutToDisappear() {
    try {
      emitter.off(Constants.EVENT_UI_CALL);
      emitter.off(Constants.EVENT_UI_ANSWER);
      emitter.off(Constants.EVENT_UI_VOICE);
      this.controller.destroy();
    } catch (e) {
    }
  }

  onUIEvent(eventId: number, data?:emitter.EventData) {
    Logger.info(`Index onUIEvent ${eventId} : ${JSON.stringify(data)}`);
    this.mUIEvent = eventId; //切换UI
    AppStorage.setOrCreate('UI_EVENT', this.mUIEvent);
  }

  build() {
    Column() {
      if (this.mUIEvent === Constants.EVENT_UI_CALL) { //请求通话页面
        UICall({ controller: this.controller, mRemote: $mRemote })
      } else if (this.mUIEvent === Constants.EVENT_UI_ANSWER) { // 来电页面
        UIAnswer({ controller: this.controller, mRemote: $mRemote })
      } else if (this.mUIEvent === Constants.EVENT_UI_VOICE) { //通话页面
        UIVoice({ controller: this.controller, mRemote: $mRemote })
      }
    }
    .width('100%')
    .height('100%')
  }
}

