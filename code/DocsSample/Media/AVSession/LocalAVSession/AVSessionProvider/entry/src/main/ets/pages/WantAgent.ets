/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start wantAgent]
import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { wantAgent } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State message: string = 'hello world';

  build() {
    Column() {
      Text(this.message)
        .onClick(async () => {
          let context = this.getUIContext().getHostContext() as Context;
          let type: AVSessionManager.AVSessionType = 'audio';
          // 假设已经创建了一个session，如何创建session可以参考之前的案例。
          let session = await AVSessionManager.createAVSession(context, 'SESSION_NAME', type);
          let wantAgentInfo: wantAgent.WantAgentInfo = {
            wants: [
              {
                bundleName: 'com.example.musicdemo',
                abilityName: 'MainAbility'
              }
            ],
            // OperationType.START_ABILITIES
            operationType: 2,
            requestCode: 0,
            wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
          }
          wantAgent.getWantAgent(wantAgentInfo).then((agent) => {
            session.setLaunchAbility(agent);
          })
          // [StartExclude wantAgent]
          session.destroy((err) => {
            if (err) {
              console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
            } else {
              console.info(`Destroy : SUCCESS `);
            }
          });
          // [EndExclude wantAgent]
        })
    }
    .width('100%')
    .height('100%')
  }
}
// [End wantAgent]