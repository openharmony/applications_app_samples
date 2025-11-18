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
// 示例代码
import { common, Want } from '@kit.AbilityKit';
import { call, observer } from '@kit.TelephonyKit';
import { BusinessError } from '@kit.BasicServicesKit';

const MMS_ENTITIES = 'entity.system.home';



@Entry
@Component
struct JumpCall {
    private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    startCallAbilityExplicit() {
      // 调用查询能力接口
      let isSupport = call.hasVoiceCapability();
      if (isSupport) {
          // 如果设备支持呼叫能力，则继续跳转到拨号界面，并显示拨号的号码
          // 从API15开始支持tel格式电话号码，如："tel:13xxxx"
          call.makeCall('13xxxx', (err: BusinessError) => {
              if (!err) {
                  console.info('make call success.');
              } else {
                  console.error('make call fail, err is:' + JSON.stringify(err));
              }
          });
          // 订阅通话业务状态变化（可选）
          class SlotId {public slotId: number = 0}
          class CallStateCallback {
              public state: call.CallState = call.CallState.CALL_STATE_UNKNOWN;
              public number: string = '';
          }
          let slotId: SlotId = {slotId: 0}
          observer.on('callStateChange', slotId, (data: CallStateCallback) => {
              console.info('call state change, data is:' + JSON.stringify(data));
          });
    }
  }

    build() {
        Row() {
            Column() {
                Button('Make Call')
                  .onClick(() => {
                      this.startCallAbilityExplicit();
                  })
            }
            .width('100%')
        }
        .height('100%')
    }
}