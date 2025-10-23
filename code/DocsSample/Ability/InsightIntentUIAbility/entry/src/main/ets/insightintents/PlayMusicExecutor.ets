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
// [Start play_music0100]
// 本示例对应意图配置中的"srcEntry"字段对应的文件
import { InsightIntentExecutor, insightIntent } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
// [StartExclude play_music0100]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0002;
// [EndExclude play_music0100]

export default class PlayMusicExecutor extends InsightIntentExecutor {
  // 由于意图配置中"executeMode"配置了"foreground"前台模式执行，故需要实现该接口
  async onExecuteInUIAbilityForegroundMode(intentName: string, params: Record<string, Object>,
    windowStage: window.WindowStage): Promise<insightIntent.ExecuteResult> {
    // 实现播放逻辑
    // [StartExclude play_music0100]
    hilog.info(DOMAIN, "testTag", "[PlayMusicExecutor] onExecuteInUIAbilityForegroundMode run");
    // [EndExclude play_music0100]
    const result: insightIntent.ExecuteResult = {
      code: 0
    };
    return Promise.resolve(result);
  }

  // 由于意图配置中"executeMode"配置了"background"后台模式执行，故需要实现该接口
  async onExecuteInUIAbilityBackgroundMode(intentName: string,
    params: Record<string, Object>): Promise<insightIntent.ExecuteResult> {
    // 后台控制逻辑
    const result: insightIntent.ExecuteResult = {
      code: 0
    };
    return Promise.resolve(result);
  }
}
// [End play_music0100]