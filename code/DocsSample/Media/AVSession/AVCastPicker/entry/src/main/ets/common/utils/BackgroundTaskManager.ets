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

// [Start task_manager]
import { common, wantAgent } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[BackgroundTaskManager]';

export class BackgroundTaskManager {
  /**
   * Starts a continuous background task with audio playback mode.
   * @param context Optional UIAbility context for the background task.
   */
  public static startContinuousTask(context?: common.UIAbilityContext): void {
    if (!context) {
      return;
    }
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj) => {
      backgroundTaskManager.startBackgroundRunning(context,
        backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
        hilog.info(0x0000, TAG, 'startBackgroundRunning succeeded');
      }).catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, `startBackgroundRunning failed, cause:  ${JSON.stringify(err)}`);
      });
    }).catch((error: Error) => {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'get want agent failed, cause: %{public}s', JSON.stringify(err));
      }
    });
    return;
  }

  /**
   * Stops the currently running continuous background task.
   * @param context Optional UIAbility context for the background task.
   */
  public static async stopContinuousTask(context?: common.UIAbilityContext) {
    if (!context) {
      return;
    }
    try {
      await backgroundTaskManager.stopBackgroundRunning(context);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'Failed to stop background running. Cause: %{public}s', JSON.stringify(err));
      }
    }
    return;
  }
}
// [End task_manager]