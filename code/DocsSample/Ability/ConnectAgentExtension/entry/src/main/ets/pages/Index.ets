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
// [Start agent_manager_one]
// [Start agent_manager_two]
// [Start agent_manager_three]
// [Start agent_manager_four]
import { common, Want, agentManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  comProxy: common.AgentProxy | null = null;
  connectCallback: common.AgentExtensionConnectCallback = {
    onData: (data: string) => {
      console.info(`onData, data: ${data}.`);
    },
    onAuth: (handShakeData: string): void => {
      console.info(`onData, data: ${handShakeData}.`);
    },
    onDisconnect: () => {
      console.info(`onDisconnect.`);
      this.comProxy = null;
    }
  }

  build() {
    Column() {
      Row() {
        // [StartExclude agent_manager_two]
        // 创建连接按钮
        Button('connect ability')
          .enabled(true)
          .onClick(() => {
            let connectWant: Want = {
              bundleName: 'com.sample.agentextensionability',
              abilityName: 'AgentExtAbility',
            };
            let agentId: string = 'weather_assistant_001';
            try {
              // 连接AgentExtensionAbility
              agentManager.connectAgentExtensionAbility(connectWant, agentId, this.connectCallback)
                .then((proxy: common.AgentProxy) => {
                  this.comProxy = proxy;
                  // [StartExclude agent_manager_one]
                  // [StartExclude agent_manager_four]
                  let data = 'test data';
                  try {
                    this.comProxy.sendData(data);
                  } catch (err) {
                    let code = (err as BusinessError).code;
                    let msg = (err as BusinessError).message;
                    console.error(`sendData failed, err code: ${code}, err msg: ${msg}.`);
                  }
                  // [EndExclude  agent_manager_four]
                  // [StartExclude agent_manager_three]
                  let authorizeData = 'authorize data';
                  try {
                    this.comProxy.authorize(authorizeData);
                  } catch (err) {
                    let code = (err as BusinessError).code;
                    let msg = (err as BusinessError).message;
                    console.error(`sendData failed, err code: ${code}, err msg: ${msg}.`);
                  }
                  // [EndExclude  agent_manager_three]
                  // [EndExclude  agent_manager_one]
                })
                .catch((err: BusinessError) => {
                  console.error(`connectAgentExtensionAbility failed, err code: ${err.code}, err msg: ${err.message}.`);
                });
            } catch (err) {
              let code = (err as BusinessError).code;
              let msg = (err as BusinessError).message;
              console.error(`connectAgentExtensionAbility failed, err code: ${code}, err msg: ${msg}.`);
            }
          })
        // [EndExclude  agent_manager_two]
        // [StartExclude agent_manager_one]
        // [StartExclude agent_manager_three]
        // [StartExclude agent_manager_four]
        // 创建断连按钮
        Button('disconnect ability')
          .enabled(true)
          .onClick(() => {
            try{
              // this.agentProxy是连接时保存的proxy对象
              agentManager.disconnectAgentExtensionAbility(this.comProxy).then(() => {
                console.info(`disconnectAgentExtensionAbility success.`);
              }).catch((error: BusinessError) => {
                console.error(`disconnectAgentExtensionAbility failed, err code: ${error.code}, err msg: ${error.message}.`);
              });
            } catch (err) {
              let code = (err as BusinessError).code;
              let msg = (err as BusinessError).message;
              console.error(`connectAgentExtensionAbility failed, err code: ${code}, err msg: ${msg}.`);
            }
          })
        // [EndExclude  agent_manager_four]
        // [EndExclude  agent_manager_three]
        // [EndExclude  agent_manager_one]
      }
    }
  }
}
// [End agent_manager_four]
// [End agent_manager_three]
// [End agent_manager_two]
// [End agent_manager_one]