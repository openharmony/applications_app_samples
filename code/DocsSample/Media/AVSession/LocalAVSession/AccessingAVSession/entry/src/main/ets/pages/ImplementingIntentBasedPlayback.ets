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

// [Start insightIntentExecutorImpl]
import { insightIntent, InsightIntentExecutor } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 意图调用样例
 */
export default class InsightIntentExecutorImpl extends InsightIntentExecutor {
  /**
   * override 执行后台启动UIAbility意图
   *
   * @param intentName 意图名称
   * @param intentParam 意图参数
   * @returns 意图调用结果
   */
  async onExecuteInUIAbilityBackgroundMode(intentName: string, intentParam: Record<string, Object>):
    Promise<insightIntent.ExecuteResult> {
    // 根据意图名称分发处理逻辑
    switch (intentName) {
      case 'PlayMusicList':
        // PlayMusicList参照如下解析方式
        let entityId: string = (intentParam.items as Array<object>)?.[0]?.['entityId'];
        return this.playFunc(entityId);
      case 'PlayAudio':
        // PlayAudio参照如下解析方式
        let data = intentParam as Record<string, string>;
        return this.playFunc(data.entityId);
      default:
        break;
    }
    return Promise.resolve({
      code: -1,
      result: {
        message: 'unknown intent'
      }
    } as insightIntent.ExecuteResult)
  }

  /**
   * 实现调用播放功能
   *
   * @param entityId 播放内容id
   */
  private playFunc(entityId: string): Promise<insightIntent.ExecuteResult> {
    // entityId 不为空，表示用户指定内容（歌单/专辑）播放
    // entityId 为空（entityId.length == 0），由应用自行决定播放内容，续播历史内容或者是推荐内容
    // 此时是后台拉起应用播放，除了初始化播放资源，还需要设置AVMetadata，注册播控控制回调，并申请播音长时任务
    // TODO 实现具体的播放业务
    return Promise.resolve({
      code: 0,
      result: {
        message: 'Intent execute succeed'
      }
    } as insightIntent.ExecuteResult)
  }
}
// [End insightIntentExecutorImpl]
@Entry
@Component
struct Index {
  @State message: string = 'hello world';

  build() {
    Column() {}
    .width('100%')
    .height('100%')
  }
}