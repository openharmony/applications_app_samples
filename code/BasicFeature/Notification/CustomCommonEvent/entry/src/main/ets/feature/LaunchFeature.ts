/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import commonEvent from '@ohos.commonEventManager';
import dataPreferences from '@ohos.data.preferences';
import Want from '@ohos.app.ability.Want';
import router from '@ohos.router';
import consts from '../module/Consts';
import Logger from '../module/Logger';

export default class LaunchFeature {
  private innerContext: common.UIAbilityContext = null;
  private pref: dataPreferences.Preferences = null;
  private subscriber = null;
  private subscriberLow = null;
  private currentRecordTimes: number = 0;

  constructor(abilityContext: common.UIAbilityContext) {
    this.innerContext = abilityContext;
  }

  async init(): Promise<void> {
    await dataPreferences.getPreferences(this.innerContext, consts.DATA_BASE_NAME).then((pref) => {
      this.pref = pref;
    });
    await this.pref.get(consts.DATA_BASE_KEY_WIFI_POWER_STATE, 0).then((value: number) => {
      globalThis.settings.set(commonEvent.Support.COMMON_EVENT_WIFI_POWER_STATE, value);
    });
    await this.pref.get(consts.DATA_BASE_KEY_SCREEN_OFF, 0).then((value1: number) => {
      globalThis.settings.set(commonEvent.Support.COMMON_EVENT_SCREEN_OFF, value1);
    });
    await this.pref.get(consts.DATA_BASE_KEY_SCREEN_ON, 0).then((value2: number) => {
      globalThis.settings.set(commonEvent.Support.COMMON_EVENT_SCREEN_ON, value2);
    });
    await this.pref.get(consts.DATA_BASE_KEY_SCREEN_LOCKED, 0).then((value3: number) => {
      globalThis.settings.set(commonEvent.Support.COMMON_EVENT_SCREEN_LOCKED, value3);
    });
    await this.pref.get(consts.DATA_BASE_KEY_SCREEN_UNLOCKED, 0).then((value4: number) => {
      globalThis.settings.set(commonEvent.Support.COMMON_EVENT_SCREEN_UNLOCKED, value4);
    });
  }

  private insertRecord = (event, value) => {
    value.push(event.parameters[consts.DATA_BASE_KEY_START_TIME]);
    // refresh database
    this.pref.put(consts.DATA_BASE_KEY_TOTAL_TIMES, value).then(() => {
      let detail: Array<string> = [];
      detail.push(event.parameters["startTime"]);
      detail.push(event.parameters["endTime"]);
      detail.push(event.parameters["totalTime"]);
      detail.push(event.parameters["totalEvents"]);
      this.pref.put(event.parameters[consts.DATA_BASE_KEY_START_TIME], detail).then(() => {
        this.pref.flush()
      })
    });
  }

  private callbackFunc = (error, event) => {
    this.pref.has(consts.DATA_BASE_KEY_TOTAL_TIMES, (err, ret) => {
      if (ret) {
        this.pref.get(consts.DATA_BASE_KEY_TOTAL_TIMES, []).then((value) => {
          this.insertRecord(event, value);
        });
      } else {
        let value: Array<string> = [];
        this.insertRecord(event, value);
      }
      if (this.currentRecordTimes >= consts.MAX_RECORD_NUM) {
        this.subscriber.finishCommonEvent();
        return;
      }
      this.subscriber.abortCommonEvent();
      this.subscriber.finishCommonEvent();
      this.currentRecordTimes++;
    })
  }

  private callbackLowFunc = (error, event) => {
    this.currentRecordTimes = 1;
    this.pref.get(consts.DATA_BASE_KEY_TOTAL_TIMES, []).then((value: Array<string>) => {
      for (let i = 0; i < consts.MAX_RECORD_NUM; i++) {
        this.pref.delete(value[i]).then(() => {
          this.pref.flush();
          this.subscriberLow.finishCommonEvent();
        })
      }
      let records = value.slice(consts.MAX_RECORD_NUM, consts.MAX_RECORD_NUM + 1);
      this.pref.put(consts.DATA_BASE_KEY_TOTAL_TIMES, records);
      this.pref.flush();
    })
  }

  jumpToStart = () => {
    // subscribe
    if (this.subscriber == null) {
      let highSubscriberInfo = {
        events: [
          consts.COMMON_EVENT_FINISH_MEDITATION // unordered self defined event
        ],
        priority: 2 // 2 indicates high priority subscriber
      };
      commonEvent.createSubscriber(highSubscriberInfo, (err, subscriber) => {
        this.subscriber = subscriber
        if (subscriber != null) {
          commonEvent.subscribe(subscriber, this.callbackFunc)
        }
      });
    }
    // subscribe
    if (this.subscriberLow == null) {
      let lowSubscriberInfo = {
        events: [
          consts.COMMON_EVENT_FINISH_MEDITATION // unordered self defined event
        ],
        priority: 1 // 1 indicates low priority subscriber
      };
      commonEvent.createSubscriber(lowSubscriberInfo, (updaerr, subscriber) => {
        this.subscriberLow = subscriber
        if (subscriber != null) {
          commonEvent.subscribe(subscriber, this.callbackLowFunc)
        }
      });
    }
    let want = {
      bundleName: 'com.samples.customcommonevent',
      abilityName: 'MainAbility',
    };
    this.innerContext.startAbility(want);
  }

  jumpToHistory = () => {
    Logger.info("ready to jump to history page");
    router.pushUrl({
      url: 'pages/History',
      params: {}
    });
  }

  jumpToSetting = () => {
    Logger.info("ready to jump to setting page");
    router.pushUrl({
      url: 'pages/Setting',
      params: {}
    });
  }

  jumpToAbout = () => {
    Logger.info("ready to jump to about page");
    router.pushUrl({
      url: 'pages/About',
      params: {}
    });
  }

  jumpToCommonEvent = (): void => {
    Logger.info('ready to jump to commonEvent page');
    let context: common.UIAbilityContext | undefined = AppStorage.get('context');
    let want: Want = {
      bundleName: "com.samples.cardevent",
      abilityName: "EntryAbility",
    };
    context && context.startAbility(want,  (err) => {
      if (err.code) {
        Logger.error('StartAbility', `Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
      }
    });
  };
}