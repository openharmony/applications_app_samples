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
// [Start ability_agent_service_one]
// [Start ability_agent_service_two]
// [Start ability_agent_service_three]
import { common, AgentExtensionAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class AgentExtAbility extends AgentExtensionAbility {
  // [StartExclude ability_agent_service_two]
  // [StartExclude ability_agent_service_three]
  private comProxy: common.AgentHostProxy | null = null;
  // 创建AgentExtensionAbility
  onCreate(want: Want) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  // 连接
  onConnect(want: Want, proxy: common.AgentHostProxy) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onConnect');
    this.comProxy = proxy;
  }

  // 断开连接
  onDisconnect(want: Want, proxy: common.AgentHostProxy) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDisconnect');
    this.comProxy = null;
  }
  // [EndExclude  ability_agent_service_two]
  // 接收数据
  onData(proxy: common.AgentHostProxy, data: string) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onData');
    try {
      let replyData = 'reply message';
      proxy.sendData(replyData);
    } catch (err) {
      let code = (err as BusinessError).code;
      let msg = (err as BusinessError).message;
      console.error(`sendData failed, err code: ${code}, err msg: ${msg}.`);
    }
  }
  // [EndExclude  ability_agent_service_three]
  // [StartExclude ability_agent_service_two]
  // 认证
  onAuth(proxy: common.AgentHostProxy, handshakeData: string) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onAuth');
    try {
      // 处理认证逻辑
      let authResult = 'auth success';
      proxy.authorize(authResult);
    } catch (err) {
      let code = (err as BusinessError).code;
      let msg = (err as BusinessError).message;
      console.error(`sendData failed, err code: ${code}, err msg: ${msg}.`);
    }
  }
  // [StartExclude ability_agent_service_three]
  // 销毁
  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }
  // [EndExclude  ability_agent_service_three]
  // [EndExclude  ability_agent_service_two]
}
// [End ability_agent_service_three]
// [End ability_agent_service_two]
// [End ability_agent_service_one]