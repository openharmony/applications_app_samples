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
// [Start background_util]
import { wantAgent, common } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';

const TAG = 'BackgroundUtil';

export class BackgroundUtil {
  /**
   * Start background task.
   *
   * @param context
   */
  public static startContinuousTask(context?: common.UIAbilityContext): void {
    if (!context) {
      Logger.error(TAG, 'startContinuousTask failed', `context undefined`);
      return;
    }
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: Object) => {
      try {
        backgroundTaskManager.startBackgroundRunning(context,
          backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
          Logger.info(TAG, 'startBackgroundRunning succeeded');
        }).catch((error: BusinessError) => {
          Logger.error(TAG, `startBackgroundRunning failed Cause: code ${error.code}`);
        });
      } catch (error) {
        Logger.error(TAG, `startBackgroundRunning failed.message ${(error as BusinessError).message}`);
      }
    })
      .catch((error: BusinessError) => {
        Logger.error('this audioRenderer: ', `getWantAgent failed Cause: code ${error.code}`);
      });
  }

  /**
   * Stop background task.
   *
   * @param context
   */
  public static stopContinuousTask(context: common.UIAbilityContext): void {
    try {
      backgroundTaskManager.stopBackgroundRunning(context).then(() => {
        Logger.info('this audioRenderer: ', 'stopBackgroundRunning succeeded');
      }).catch((error: BusinessError) => {
        Logger.error('this audioRenderer: ', `stopBackgroundRunning failed Cause: code ${error.code}`);
      });
    } catch (error) {
      Logger.error(TAG, `stopBackgroundRunning failed. message ${error}`);
    }
  }
}

// [End background_util]