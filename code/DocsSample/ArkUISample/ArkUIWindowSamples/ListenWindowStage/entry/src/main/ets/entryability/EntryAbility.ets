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

// [Start listen_window_stage]
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0X0000;
const TAG: string = '[Sample_ListenWindowStage]';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    // [StartExclude listen_window_stage]
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      hilog.info(DOMAIN, TAG, `Succeeded in loading the content.`);
    })
    // [EndExclude listen_window_stage]
    try {
      windowStage.on('windowStageEvent', (data) => {
        hilog.info(DOMAIN, TAG, `Succeeded in enabling the listener for window stage event changes. Data: ${JSON.stringify(data)}`);

        // 根据事件状态类型选择进行相应的处理
        if (data === window.WindowStageEventType.SHOWN) {
          hilog.info(DOMAIN, TAG, `current window stage event is SHOWN`);
          // 应用进入前台，默认为可交互状态
          // ...
        } else if (data === window.WindowStageEventType.HIDDEN) {
          hilog.info(DOMAIN, TAG, `current window stage event is HIDDEN`);
          // 应用进入后台，默认为不可交互状态
          // ...
        } else if (data === window.WindowStageEventType.PAUSED) {
          hilog.info(DOMAIN, TAG, `current window stage event is PAUSED`);
          // 前台应用进入多任务，转为不可交互状态
          // ...
        } else if (data === window.WindowStageEventType.RESUMED) {
          hilog.info(DOMAIN, TAG, `current window stage event is RESUMED`);
          // 进入多任务后又继续返回前台时，恢复可交互状态
          // ...
        }

        // ...
      });
    } catch (exception) {
      hilog.error(DOMAIN, TAG, `Failed to enable the listener for window stage event changes. Cause: ${JSON.stringify(exception)}`);
    }
  }
}
// [End listen_window_stage]