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
// [Start music_skill_import]

import { scriptManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
// 应用既有业务模块
import { MusicPlayer, Track, PlayResult } from '../../../src/main/ets/service/MusicPlayer';

// [End music_skill_import]

// [Start music_skill]
export default class MusicSkill {
  // [StartExclude music_skill]
  // ============================================================
  // 能力1：按名称搜索并播放音乐
  //   argv[0] <- SKILL.md中的arg1：歌曲名（可空）
  //   argv[1] <- SKILL.md中的arg2：歌手名（可空）
  // ============================================================
  // [EndExclude music_skill]
  public async playMusicByName(info: scriptManager.ArkTSScriptInfo, ...argv: string[]): Promise<void> {
    /* 见 3.3 ~ 3.5 */
    // [StartExclude music_skill]
// [Start music_skill_verify]
// 例1：playMusicByName 的两个可选参数，至少一个非空
const songName: string = argv.length > 0 ? argv[0].trim() : '';
const singer: string = argv.length > 1 ? argv[1].trim() : '';
if (songName.length === 0 && singer.length === 0) {
  // 走 ERR_INVALID_PARAMS 分支回包（见 3.5），不再进入业务
      // [StartExclude music_skill_verify]
      const payload: Record<string, Object> = {
        'type': 'result',
        'status': 'failed',
        'errCode': 'ERR_INVALID_PARAMS',
        'errMsg': 'songName and singer are both empty',
        'suggestion': '我没听清,你想听哪首歌?'
      };
      const result: scriptManager.ExecuteResult = { code: -1, result: payload };
      await this.report(info, result);
      // [EndExclude music_skill_verify]
  return;
}
    // [StartExclude music_skill_verify]
    // [Start music_skill_try]

try {
  // 直接调用应用内已有业务API
  const playResult: PlayResult | null = MusicPlayer.searchAndPlay(songName, singer);
  // 业务返回值 → 映射到"成功"或"未命中"分支（见 3.5）
      // [StartExclude music_skill_try]

      if (playResult === null || playResult.tracks.length === 0) {
        const keywords: string[] = [];
        if (songName.length > 0) {
          keywords.push(songName);
        }
        if (singer.length > 0) {
          keywords.push(singer);
        }

        const data: Record<string, Object> = {
          'searchedKeywords': keywords
        };

        const payload: Record<string, Object> = {
          'type': 'result',
          'status': 'failed',
          'errCode': 'ERR_NOT_FOUND',
          'data': data,
          'suggestion': `没有找到${singer}${songName.length > 0 ? `的《${songName}》` : '相关歌曲'}`
        };
        const result: scriptManager.ExecuteResult = { code: -1, result: payload };
        await this.report(info, result);
        return;
      }
      // [Start music_skill_branch]
// 成功分支示例
const first: Track = playResult.tracks[0];	 
const playingTrack: Record<string, Object> = {	 
  'name': first.name,	 
  'singer': first.singer,	 
  'duration': first.duration	 
};
const data: Record<string, Object> = {	 
  'playingTrack': playingTrack,	 
  'matchedCount': playResult.tracks.length	 
};
const payload: Record<string, Object> = {
  'type': 'result',
  'status': 'success',
  'data': data
};
await this.report(info, { code: 0, result: payload });
      // [StartExclude music_skill_branch]
      // [EndExclude music_skill_try]
} catch (e) {
  // 业务异常 → 统一映射到 ERR_INTERNAL 分支（见 3.5）
  const err = e as BusinessError;
// [StartExclude music_skill_try]
// [EndExclude music_skill_branch]

// 失败分支示例（以 ERR_NOT_FOUND 为例）
const payloadData: Record<string, Object> = {	 
  'searchedKeywords': [] 
};
const payload: Record<string, Object> = {
  'type': 'result',
  'status': 'failed',
  'errCode': 'ERR_NOT_FOUND',
  'data': payloadData,
  'suggestion': `没有找到${singer}${songName.length > 0 ? `的《${songName}》` : '相关歌曲'}`
};
await this.report(info, { code: -1, result: payload });
// [StartExclude music_skill_branch]
// [EndExclude music_skill_try]
}
// [End music_skill_try]
// [EndExclude music_skill]
  }

  // [StartExclude music_skill]

  // ============================================================
  // 能力2：播放控制
  //   argv[0] <- SKILL.md中的arg1：pause | resume | next | previous
  // ============================================================
  // [EndExclude music_skill]
  public async controlPlayback(info: scriptManager.ArkTSScriptInfo, ...argv: string[]): Promise<void> {
    /* 同上模式 */
    // [StartExclude music_skill]
    // [EndExclude music_skill_verify]

// 例2：controlPlayback 的枚举值参数，需用白名单二次校验
const action: string = argv.length > 0 ? argv[0].trim() : '';
const validActions: string[] = ['pause', 'resume', 'next', 'previous'];
if (!validActions.includes(action)) {
  // 走 ERR_INVALID_PARAMS 分支回包
      // [StartExclude music_skill_verify]
      const payload: Record<string, Object> = {
        'type': 'result',
        'status': 'failed',
        'errCode': 'ERR_INVALID_PARAMS',
        'errMsg': `invalid action: ${action}`,
        'suggestion': '我没听清,你想暂停、继续还是切换歌曲?'
      };
      const result: scriptManager.ExecuteResult = { code: -1, result: payload };
      await this.report(info, result);
      // [EndExclude music_skill_verify]
  return;
}
    // [End music_skill_verify]
    try {
      const playing: Track | null = MusicPlayer.control(action);

      // ---- 分支B：控制成功 → success ----
      const data: Record<string, Object> = {
        'action': action
      };
      if (playing !== null) {
        const currentTrack: Record<string, Object> = {
          'name': playing.name,
          'singer': playing.singer
        };
        data['currentTrack'] = currentTrack;
      }
      const payload: Record<string, Object> = {
        'type': 'result',
        'status': 'success',
        'data': data
      };
      const result: scriptManager.ExecuteResult = { code: 0, result: payload };
      await this.report(info, result);

    } catch (e) {
      // ---- 分支C：未知异常 → ERR_INTERNAL ----
      const err = e as BusinessError;
      const payload: Record<string, Object> = {
        'type': 'result',
        'status': 'failed',
        'errCode': 'ERR_INTERNAL',
        'errMsg': `control failed: ${err.message}`,
        'suggestion': '操作失败了,稍后再试试'
      };
      const result: scriptManager.ExecuteResult = { code: -1, result: payload };
      await this.report(info, result);
    }
    // [EndExclude music_skill]
  }

  // [StartExclude music_skill]
// [EndExclude music_skill_branch]

// 唯一的回包出口：只封装API调用与异常打印，不参与结果构造
private async report(info: scriptManager.ArkTSScriptInfo, result: scriptManager.ExecuteResult): Promise<void> {
  try {
    await scriptManager.completeArkTSScriptInApp(info.context, info.requestCode, result);
  } catch (e) {
    const err = e as BusinessError;
    console.error(`completeArkTSScriptInApp failed, code: ${err.code}, message: ${err.message}`);
  }
}
// [End music_skill_branch]
// [EndExclude music_skill]
}

// [End music_skill]