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

// [Start insight_intent_play_music_list]
import { insightIntent, InsightIntentEntity, InsightIntentEntry, InsightIntentEntryExecutor } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const LOG_TAG: string = 'testTag';

// 意图实体定义
@InsightIntentEntity({
  entityCategory: 'playlist_entity_category',
  parameters: {
    '$id': '/schemas/AppPlaylistEntity',
    'type': 'object',
    'description': 'Playlist entity with dynamic query support',
    'properties': {
      'entityId': {
        'type': 'string',
        'description': 'Playlist unique identifier',
        'title': '歌单id'
      },
      'playlistName': {
        'type': 'string',
        'description': 'Playlist name',
        'title': '歌单名称'
      },
      'owner': {
        'type': 'string',
        'description': 'Playlist owner',
        'title': '创建者'
      },
      'displayName': {
        'type': 'string',
        'description': 'Playlist display name',
      }
    },
    'required': ['playlistName', 'displayName']
  },
  supportedQueryProperties: ['entityId', 'playlistName', 'owner'] // 支持通过歌单ID、歌单名称、创建者筛选目标歌单
})
export class AppPlaylistEntity extends insightIntent.AppIntentEntity<AppPlaylistEntity> {
  public entityId: string = 'default';
  public playlistName: string = '';
  public displayName: string = '';
  public owner: string = '';

  async onQueryEntity(params: insightIntent.QueryEntityParam): Promise<Array<AppPlaylistEntity>> {
    const playlists: AppPlaylistEntity[] = [
      this.createEntity('p001', '夜跑歌单', '夜跑歌单', 'Alice'),
      this.createEntity('p002', '通勤歌单', '通勤歌单', 'Bob'),
      this.createEntity('p003', '睡前轻音乐', '睡前轻音乐', 'Alice')
    ];

    if (params.queryType === insightIntent.QueryType.ALL) {
      return playlists;
    }

    const query = params.parameters ?? {};
    const validKeys = Object.keys(query).filter((key) => ['entityId', 'playlistName', 'owner'].includes(key));
    if (validKeys.length === 0) {
      return [];
    }

    return playlists.filter((item) => {
      return validKeys.every((key) => {
        const queryValue = query[key];
        if (key === 'entityId') {
          return item.entityId === queryValue;
        }
        if (key === 'playlistName') {
          return item.playlistName === queryValue;
        }
        if (key === 'owner') {
          return item.owner === queryValue;
        }
        return false;
      });
    });
  }

  private createEntity(entityId: string, playlistName: string, displayName: string, owner: string): AppPlaylistEntity {
    const entity = new AppPlaylistEntity();
    entity.entityId = entityId;
    entity.playlistName = playlistName;
    entity.displayName = displayName;
    entity.owner = owner;
    return entity;
  }
}

// 使用@InsightIntentEntry装饰器定义意图
@InsightIntentEntry({
  intentName: 'PlayMusicList',
  domain: 'MusicListDomain',
  intentVersion: '1.0.1',
  displayName: '播放歌单歌曲',
  displayDescription: '播放指定歌单中的歌曲',
  icon: $r('app.media.playMusicList'), // 请将$r('app.media.playMusicList')替换为实际资源文件
  llmDescription: '支持传递歌曲名称和歌单信息，播放歌单中的音乐',
  keywords: ['歌单播放', '播放歌单歌曲', 'PlayMusic'],
  abilityName: 'EntryAbility',
  executeMode: [insightIntent.ExecuteMode.UI_ABILITY_FOREGROUND],
  parameters: {
    'type': 'object',
    'title': 'Playlist Schema',
    'description': 'A schema for describing song names and playlist information',
    'properties': {
      'songName': {
        'type': 'string',
        'description': 'The name of the song',
        'minLength': 1
      },
      'playlist': {
        'type': 'object',
        'description': 'Information about the playlist',
        'properties': {
          'playlistName': {
            'type': 'string',
            'description': 'The name of the playlist',
            'minLength': 1
          },
          'displayName': {
            'type': 'string',
            'description': 'The displayName of the playlist'
          },
          'owner': {
            'type': 'string',
            'description': 'The owner of the playlist',
          },
          'entityId': {
            'type': 'string',
            'description': 'The unique identifier of the playlist'
          }
        },
        'required': ['playlistName', 'displayName']
      }
    },
    'required': ['songName']
  }
})
export default class PlayMusicListImpl extends InsightIntentEntryExecutor<string> {
  public songName: string = '';
  // 使用可查询意图实体
  public playlist?: AppPlaylistEntity;

  onExecute(): Promise<insightIntent.IntentResult<string>> {
    hilog.info(0x0000, LOG_TAG, 'PlayMusicListImpl executeMode %{public}s', JSON.stringify(this.executeMode));
    hilog.info(0x0000, LOG_TAG, 'PlayMusicListImpl playlist %{public}s', JSON.stringify(this.playlist));
    // 定义意图的执行结果
    let result: insightIntent.IntentResult<string> = {
      code: 123,
      result: 'execute success'
    }
    hilog.info(0x0000, LOG_TAG, 'PlayMusicListImpl return %{public}s', JSON.stringify(result));
    return Promise.resolve(result);
  }
}

// [End insight_intent_play_music_list]
