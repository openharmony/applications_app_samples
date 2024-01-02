/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
import Logger from '../utils/Logger';
import Caller from '../bean/Caller';
import Constants from '../Constants';
import commonEvent from '@ohos.commonEventManager';
import Want from '@ohos.app.ability.Want';

const TAG = 'OptionModel';

const callData: Array<Caller> = [{
  index: 0x01,
  name: $r('app.string.name1'),
  head: $r('app.string.head1')
}, {
  index: 0x02,
  name: $r('app.string.name2'),
  head: $r('app.string.head2')
}];

// 配合测试，默认打开被呼叫页
const DEFAULT_EVENT = Constants.EVENT_UI_ANSWER;

export declare interface OptCallback {
  //对端接听
  onRemoteAnswer();

  //对端挂断/拒绝
  onRemoteHangUp();
}


class OptionModel {
  private mSubscriber: commonEvent.CommonEventSubscriber | null = null;
  private mCallback: OptCallback | null = null;
  private caller: Caller = callData[0]; // 配合测试，默认用户

  getCaller(): Caller {
    return this.caller;
  }

  public readWant(want: Want): number {
    if (!want.parameters) {
      return DEFAULT_EVENT;
    }
    let event = want.parameters[Constants.START_ABILITY_EVENT_KEY];
    let data: number = want.parameters[Constants.START_ABILITY_DATA_KEY] as number;
    if ((!event) || !data) {
      Logger.log(TAG, `readWant param empty`);
      return DEFAULT_EVENT;
    }
    this.caller = callData[data-1];
    if (event === Constants.START_ABILITY_EVENT_CALL) {
      return Constants.EVENT_UI_CALL;
    } else if (event === Constants.START_ABILITY_EVENT_ANSWER) {
      return Constants.EVENT_UI_ANSWER;
    }
    return DEFAULT_EVENT;
  }

  public async subscriber(): Promise<void> {

    this.mSubscriber = await commonEvent.createSubscriber({
      events: [
        Constants.COMM_EVENT_ANSWER_FROM_HOST,
        Constants.COMM_EVENT_HANGUP_FROM_HOST,
      ]
    });

    commonEvent.subscribe(this.mSubscriber, (err, data) => {
      if (err) {
        Logger.error(TAG, `subscribe common event failed ${JSON.stringify(err)}`);
        return;
      }
      this.onRemoteEvent(data.event);
    });
  }

  // 注册监听
  public registerCallback(callback: OptCallback): void {
    this.mCallback = callback;
  }

  private onRemoteEvent(event: string) {
    Logger.log(TAG,` onRemoteEvent ${event}`);
    if (this.mCallback == null) {
      return;
    }
    switch (event) {
      case Constants.COMM_EVENT_ANSWER_FROM_HOST: //接听
        this.mCallback.onRemoteAnswer();
        break;
      case Constants.COMM_EVENT_HANGUP_FROM_HOST: //挂断 / 拒接
        this.mCallback.onRemoteHangUp();
        break;
    }
  }

  // 发送事件
  public async answer(): Promise<void> {
    Logger.info(TAG,`answer`);
    commonEvent.publish(Constants.COMM_EVENT_ANSWER_FROM_VOICE, (err) => {
      if (err) {
        Logger.error(TAG,`publish common event failed ${JSON.stringify(err)}`);
        return;
      }
    });
  }

  public async hangUp(): Promise<void> {
    Logger.info(TAG,`hangUp`);
    commonEvent.publish(Constants.COMM_EVENT_HANGUP_FROM_VOICE, (err) => {
      if (err) {
        Logger.error(TAG,`publish common event failed ${JSON.stringify(err)}`);
        return;
      }
    });
  }

  //销毁
  public destroy(): void {
    try {
      if (this.mSubscriber) {
        commonEvent.unsubscribe(this.mSubscriber);
      }
    } catch (err) {
      Logger.error(TAG,`destroy common event failed ${JSON.stringify(err)}`);
    }
    this.mCallback = null;
  }
}

let mOptionModel = new OptionModel();

export default mOptionModel as OptionModel;