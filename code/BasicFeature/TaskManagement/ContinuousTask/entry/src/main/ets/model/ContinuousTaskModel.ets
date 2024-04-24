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

import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';
import wantAgent from '@ohos.app.ability.wantAgent';
import common from '@ohos.app.ability.common'
import { BusinessError } from '@ohos.base';
import Logger from '../util/Logger'

const TAG: string = 'ContinuousTaskModel'

export default class ContinuousTaskModel {
  private context: common.UIAbilityContext
  private list: Array<string> = ["audioPlayback"];

  constructor(context: common.UIAbilityContext) {
    this.context = context
  }

  // start continuous task
  startContinuousTask(): void {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: 'ohos.samples.continuoustask',
          abilityName: 'ohos.samples.continuoustask.MainAbility',
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    }

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj) => {
      backgroundTaskManager.startBackgroundRunning(this.context, this.list, wantAgentObj).then(() => {
        Logger.info(TAG, 'startBackgroundRunning succeeded');
        this.list = ["audioPlayback","audioRecording"]
        setTimeout(()=>{
          backgroundTaskManager.updateBackgroundRunning(this.context, this.list).then(() => {
            Logger.info(TAG, 'Operation updateBackgroundRunning succeeded');
          }).catch((error: BusinessError) => {
            Logger.info(TAG, `Operation updateBackgroundRunning failed. code is ${error.code} message
            is ${error.message}`);
          });
        },5000)
      }).catch((error: BusinessError) => {
        Logger.error(TAG, `Operation startBackgroundRunning failed. code is ${error.code} message is ${error.message}`);
      });
    });
  }

  // cancel continuous task
  stopContinuousTask(): void {
    try {
      backgroundTaskManager.stopBackgroundRunning(this.context).then(() => {
        Logger.info(TAG, `stopBackgroundRunning succeeded`);
      }).catch((err: BusinessError) => {
        Logger.info(TAG, `stopBackgroundRunning failed Cause:  ${JSON.stringify(err)}`);
      })
    } catch (error) {
      Logger.error(TAG, `stopBackgroundRunning failed. code is ${error.code} message is ${error.message}`);
    }
  }
}
