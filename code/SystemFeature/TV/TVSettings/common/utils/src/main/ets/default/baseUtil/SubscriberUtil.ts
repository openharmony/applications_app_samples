/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import ConfigData from './ConfigData';
import CommonEvent from '@ohos.commonEventManager';
import LogUtil from './LogUtil'

let mCommonEventSubscribeInfo = {
  events: ['BRIGHTNESS_VALUE_SYSTEM_UI']
};

let mCommonEventSubscriber = null;
let mCustomStatusSubscriberCallBack = null;

/**
 * broadcast
 */
export class SubscriberUtils {
  /**
   * Send broadcast
   *
   * @param value - value
   * @param broadcastName - broadcastName
   */
  sendEvent(value, broadcastName) {
    let commonEventPublishData = {
      data: value
    };
    CommonEvent.publish(broadcastName, commonEventPublishData, (err, data) => {
      LogUtil.info(ConfigData.TAG + `SubscriberUtils sendEvent ets ${JSON.stringify(err)}`);
      LogUtil.info(ConfigData.TAG + `SubscriberUtils sendEvent ets ${JSON.stringify(data)}`);
    });
    LogUtil.info(ConfigData.TAG + `SubscriberUtils sendEvent ets out`);
  }

  /**
   * Register to broadcast
   */
  registerStatusListener(pCommonEventSubscribeInfo?, pCallback?) {
    LogUtil.info(ConfigData.TAG + `SubscriberUtils Subscriberregister status listener in`);

    mCustomStatusSubscriberCallBack = pCallback;

    var subscribeInfo = pCommonEventSubscribeInfo ? pCommonEventSubscribeInfo : mCommonEventSubscribeInfo;
    CommonEvent.createSubscriber(
      subscribeInfo,
      this.createStatusSubscriberCallBack.bind(this)
    );

    LogUtil.info(ConfigData.TAG + `SubscriberUtils Subscriberregister status listener out`);
  }

  createStatusSubscriberCallBack(err, data) {
    LogUtil.info(ConfigData.TAG +
      `SubscriberUtils Subscriberregister in ets ${JSON.stringify(err)} ${JSON.stringify(data)}`);
    mCommonEventSubscriber = data;
    CommonEvent.subscribe(mCommonEventSubscriber, this.statusSubscriberCallBack.bind(this));
    LogUtil.info(ConfigData.TAG + `SubscriberUtils Subscriberregister in`);
  }

  statusSubscriberCallBack(err, data) {
    LogUtil.info(ConfigData.TAG + `SubscriberUtils statusSubscriberCallBack data ets : ${JSON.stringify(data)}`);
    LogUtil.info(ConfigData.TAG + `SubscriberUtils statusSubscriberCallBack err ets : ${JSON.stringify(err)}`);
    LogUtil.info(ConfigData.TAG + `SubscriberUtils statusSubscriberCallBack data.event ets : ${data.event} `);
    if (mCustomStatusSubscriberCallBack) {
      mCustomStatusSubscriberCallBack(err, data);
    }
    if (err) {
      LogUtil.info(ConfigData.TAG + `SubscriberUtils statusSubscriberCallBack error : ${err}`)
      return;
    }
    LogUtil.info(ConfigData.TAG + `SubscriberUtils statusSubscriberCallBack out`);
  }

  /**
   * unRegister to broadcast
   */
  unSubscriberListener() {
    CommonEvent.unsubscribe(mCommonEventSubscriber, () => {
      LogUtil.info(ConfigData.TAG + 'SubscriberUtils unSubscriberListener');
    });
  }
}

let subscriberUtils = new SubscriberUtils();
export default subscriberUtils as SubscriberUtils;