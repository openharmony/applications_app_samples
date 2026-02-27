/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { rpc } from '@kit.IPCKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';

// [Start continuous_task_call]
const MSG_SEND_METHOD: string = 'CallSendMsg';

let mContext: Context;

function startContinuousTask() {
  let wantAgentInfo : wantAgent.WantAgentInfo = {
    // 点击通知后，将要执行的动作列表
    wants: [
      {
        bundleName: 'ohos.samples.continuoustask',
        abilityName: 'MainAbility'
      }
    ],
    // 点击通知后，动作类型
    actionType: wantAgent.OperationType.START_ABILITY,
    // 使用者自定义的一个私有值
    requestCode: 0,
    // 点击通知后，动作执行属性
    actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  };

  // 通过wantAgent模块的getWantAgent方法获取WantAgent对象
  // 在原子化服务中，使用wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: object) => {替换下面一行代码
  wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj : WantAgent) => {
    backgroundTaskManager.startBackgroundRunning(mContext,
      backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
      console.info(`Succeeded in operationing startBackgroundRunning.`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to operation startBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
    });
  });
}

function stopContinuousTask() {
  backgroundTaskManager.stopBackgroundRunning(mContext).then(() => {
    console.info(`Succeeded in operationing stopBackgroundRunning.`);
  }).catch((err: BusinessError) => {
    console.error(`Failed to operation stopBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
  });
}

class MyParcelable implements rpc.Parcelable {
  public num: number = 0;
  public str: string = '';

  constructor(num: number, str: string) {
    this.num = num;
    this.str = str;
  }

  marshalling(messageSequence: rpc.MessageSequence) {
    messageSequence.writeInt(this.num);
    messageSequence.writeString(this.str);
    return true;
  }

  unmarshalling(messageSequence: rpc.MessageSequence) {
    this.num = messageSequence.readInt();
    this.str = messageSequence.readString();
    return true;
  }
}

function sendMsgCallback(data: rpc.MessageSequence) {
  console.info('BgTaskAbility funcCallBack is called ' + data);
  let receivedData: MyParcelable = new MyParcelable(0, '');
  data.readParcelable(receivedData);
  console.info(`receiveData[${receivedData.num}, ${receivedData.str}]`);
  // 可以根据Caller端发送的序列化数据的str值，执行不同的方法。
  if (receivedData.str === 'start_bgtask') {
    // 申请长时
    startContinuousTask();
  } else if (receivedData.str === 'stop_bgtask') {
    // 取消长时
    stopContinuousTask();
  }
  return new MyParcelable(10, 'Callee test');
}

export default class BgTaskAbility extends UIAbility {
  // Ability创建
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    console.info('[Demo] BgTaskAbility onCreate');
    try {
      this.callee.on(MSG_SEND_METHOD, sendMsgCallback);
    } catch (error) {
      console.error(`${MSG_SEND_METHOD} register failed with error ${JSON.stringify(error)}`);
    }
    mContext = this.context;
  }

  // Ability销毁
  onDestroy() {
    console.info('[Demo] BgTaskAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    console.info('[Demo] BgTaskAbility onWindowStageCreate');

    windowStage.loadContent('pages/Index', (error, data) => {
      if (error.code) {
        console.error(`load content failed with error ${JSON.stringify(error)}`);
        return;
      }
      console.info(`load content succeed with data ${JSON.stringify(data)}`);
    });
  }

  onWindowStageDestroy() {
    console.info('[Demo] BgTaskAbility onWindowStageDestroy');
  }

  onForeground() {
    console.info('[Demo] BgTaskAbility onForeground');
  }

  onBackground() {
    console.info('[Demo] BgTaskAbility onBackground');
  }
};
// [End continuous_task_call]