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

// [Start insight_intent_play_music]
// `insight_intent.json`文件的"insightIntentsSrcEntry"字段的实现
import { InsightIntentEntryExecutor, insightIntent, InsightIntentEntry } from '@kit.AbilityKit';

// 意图执行返回值数据格式定义
class PlayMusicResultDef {
  public msg?: string = '';
}

// 意图定义
@InsightIntentEntry({
  intentName: 'PlayMusic',
  domain: 'MusicDomain',
  intentVersion: '1.0.1',
  displayName: '播放歌曲',
  displayDescription: '播放音乐意图',
  icon: $r('app.media.viewLogistics'), // $r表示本地图标，需要在资源目录中定义
  llmDescription: '支持传递歌曲名称，播放音乐',
  keywords: ['音乐播放', '播放歌曲', 'PlayMusic'],
  abilityName: 'EntryAbility',
  executeMode: [insightIntent.ExecuteMode.UI_ABILITY_FOREGROUND],
  parameters: {
    'type': 'object',
    'description': 'A schema for describing songs and their artists',
    'properties': {
      'songName': {
        'type': 'string',
        'description': 'The name of the song',
        'minLength': 1
      },
      'singer': {
        'type': 'string',
        'description': 'The name of the singer',
        'minLength': 1
      }
    },
    'required': ['songName']
  }
})
export default class PlayMusicImpl extends InsightIntentEntryExecutor<PlayMusicResultDef> {
  public songName: string = '';
  public singer?: string = '';

  onExecute(): Promise<insightIntent.IntentResult<PlayMusicResultDef>> {
    // 执行音乐播放逻辑
    let result: insightIntent.IntentResult<PlayMusicResultDef> = {
      code: 123,
      result: {
        msg: 'play music succeed'
      }
    };
    return Promise.resolve(result);
  };
}

// [End insight_intent_play_music]