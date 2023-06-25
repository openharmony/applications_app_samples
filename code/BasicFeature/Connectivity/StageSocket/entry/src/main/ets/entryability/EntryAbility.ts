/*
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
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import hilog from '@ohos.hilog';
import CommonEvent from '@ohos.commonEventManager';
import Logger from '../utils/Logger';
import Constants from '../Constants';

const TAG: string = '[EntryAbility] ';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    globalThis.abilityContext = this.context;

    let subscriber; // 用于保存创建成功的订阅者对象

    // 订阅者信息
    let subscribeInfo = {
      events: [
        Constants.COMM_EVENT_ANSWER_FROM_VOICE,
        Constants.COMM_EVENT_HANGUP_FROM_VOICE
      ],
    };

    // 订阅公共事件回调
    function subscribeCallBack(err, data): void {
      Logger.info(TAG, 'subscribeCallBack into ' + JSON.stringify(err));
      let sendEvent = ''; // 发送的事件
      if (err !== null && err.code) {
        Logger.error(TAG, 'subscribeCallBack failed ' + JSON.stringify(err));
      } else {
        Logger.info(TAG, 'subscribeCallBack data:' + JSON.stringify(data));
        // 拿出数据中的event事件
        sendEvent = data.event;
        Logger.info(
          TAG,
          'subscribeCallBack data sendEvent 1:' + JSON.stringify(sendEvent)
        );
        // 触发sendMsg发送消息
        AppStorage.SetOrCreate('sendMsg', sendEvent);
        AppStorage.SetOrCreate('sendMsg', 'clear');
        Logger.info(
          TAG,
          'subscribeCallBack data sendEvent 2:' + JSON.stringify(sendEvent)
        );
      }
      sendEvent = '';
    }

    // 创建订阅者回调
    function createSubscriberCallBack(err, commonEventSubscriber): void {
      Logger.info(TAG, 'createSubscriber into ' + JSON.stringify(err));
      if (err !== null && err.code) {
        Logger.error(TAG, 'createSubscriber failed ' + JSON.stringify(err));
      } else {
        Logger.info(TAG, 'createSubscriber success');
        subscriber = commonEventSubscriber;
        // 订阅公共事件
        CommonEvent.subscribe(subscriber, subscribeCallBack);
      }
    }

    // 创建订阅者
    CommonEvent.createSubscriber(subscribeInfo, createSubscriberCallBack);
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/NewLogin', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(
        0x0000,
        'testTag',
        'Succeeded in loading the content. Data: %{public}s',
        JSON.stringify(data) ?? ''
      );
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
