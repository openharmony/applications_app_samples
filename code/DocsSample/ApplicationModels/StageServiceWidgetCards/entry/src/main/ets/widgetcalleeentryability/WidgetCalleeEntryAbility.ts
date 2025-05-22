/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start widget_callee_entry_ability]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { formBindingData, formProvider } from '@kit.FormKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'WidgetCalleeEntryAbility';
const DOMAIN_NUMBER: number = 0xFF00;
const MSG_SEND_METHOD: string = 'funA';
const CONST_NUMBER_1: number = 1;

class MyParcelable implements rpc.Parcelable {
  num: number;
  str: string;

  constructor(num: number, str: string) {
    this.num = num;
    this.str = str;
  };

  marshalling(messageSequence: rpc.MessageSequence): boolean {
    messageSequence.writeInt(this.num);
    messageSequence.writeString(this.str);
    return true;
  };

  unmarshalling(messageSequence: rpc.MessageSequence): boolean {
    this.num = messageSequence.readInt();
    this.str = messageSequence.readString();
    return true;
  };
}

// 在收到call事件后会触发callee监听的方法
let funACall = (data: rpc.MessageSequence): MyParcelable => {
  // 获取call事件中传递的所有参数
  let params: Record<string, string> = JSON.parse(data.readString());
  if (params.formId !== undefined) {
    let curFormId: string = params.formId;
    let message: string = params.calleeDetail;
    hilog.info(DOMAIN_NUMBER, TAG, `UpdateForm formId: ${curFormId}, message: ${message}`);
    let formData: Record<string, string> = {
      'calleeDetail': message
    };
    let formMsg: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(curFormId, formMsg).then((data) => {
      hilog.info(DOMAIN_NUMBER, TAG, `updateForm success. ${JSON.stringify(data)}`);
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `updateForm failed: ${JSON.stringify(error)}`);
    });
  }
  return new MyParcelable(CONST_NUMBER_1, 'aaa');
};

export default class WidgetCalleeEntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      // 监听call事件所需的方法
      this.callee.on(MSG_SEND_METHOD, funACall);
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, `${MSG_SEND_METHOD} register failed with error ${JSON.stringify(error)}`);
    }
    ;
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN_NUMBER, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }
}
// [End widget_callee_entry_ability]