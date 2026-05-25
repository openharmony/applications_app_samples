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
// [Start module_MusicSkill]
// entry/skills/music-assistant/scripts/MusicSkill.ets

import { scriptManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { MusicPlayer, Track, PlayResult } from '../../../src/main/ets/service/MusicPlayer';

export default class MusicSkill {

  // ============================================================
  // 能力1：按名称搜索并播放音乐
  //   argv[0] <- SKILL.md中的arg1：歌曲名（可空）
  //   argv[1] <- SKILL.md中的arg2：歌手名（可空）
  // ============================================================
  public async playMusicByName(
    arkTSScriptInfo: scriptManager.ArkTSScriptInfo,
    ...argv: string[]
  ): Promise<void> {
    const songName: string = argv.length > 0 ? argv[0].trim() : '';
    const singer: string = argv.length > 1 ? argv[1].trim() : '';

    // ---- 分支A：参数为空 → ERR_INVALID_PARAMS ----
    if (songName.length === 0 && singer.length === 0) {
      const payload: Record<string, Object> = {
        'type': 'result',
        'status': 'failed',
        'errCode': 'ERR_INVALID_PARAMS',
        'errMsg': 'songName and singer are both empty',
        'suggestion': '我没听清,你想听哪首歌?'
      };
      const result: scriptManager.ExecuteResult = { code: -1, result: payload };
      await this.report(arkTSScriptInfo, result);
      return;
    }

    try {
      const playResult: PlayResult | null = MusicPlayer.searchAndPlay(songName, singer);

      // ---- 分支B：歌库未命中 → ERR_NOT_FOUND ----
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
        await this.report(arkTSScriptInfo, result);
        return;
      }

      // ---- 分支C：播放成功 → success ----
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
      const result: scriptManager.ExecuteResult = { code: 0, result: payload };
      await this.report(arkTSScriptInfo, result);

    } catch (e) {
      // ---- 分支D：未知异常 → ERR_INTERNAL ----
      const err = e as BusinessError;
      const payload: Record<string, Object> = {
        'type': 'result',
        'status': 'failed',
        'errCode': 'ERR_INTERNAL',
        'errMsg': `play failed: ${err.message}`,
        'suggestion': '播放失败了,稍后再试试'
      };
      const result: scriptManager.ExecuteResult = { code: -1, result: payload };
      await this.report(arkTSScriptInfo, result);
    }
  }

  // ============================================================
  // 能力2：播放控制
  //   argv[0] <- SKILL.md中的arg1：pause | resume | next | previous
  // ============================================================
  public async controlPlayback(
    arkTSScriptInfo: scriptManager.ArkTSScriptInfo,
    ...argv: string[]
  ): Promise<void> {
    const action: string = argv.length > 0 ? argv[0].trim() : '';
    const validActions: string[] = ['pause', 'resume', 'next', 'previous'];

    // ---- 分支A：控制指令非法 → ERR_INVALID_PARAMS ----
    if (!validActions.includes(action)) {
      const payload: Record<string, Object> = {
        'type': 'result',
        'status': 'failed',
        'errCode': 'ERR_INVALID_PARAMS',
        'errMsg': `invalid action: ${action}`,
        'suggestion': '我没听清,你想暂停、继续还是切换歌曲?'
      };
      const result: scriptManager.ExecuteResult = { code: -1, result: payload };
      await this.report(arkTSScriptInfo, result);
      return;
    }

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
      await this.report(arkTSScriptInfo, result);

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
      await this.report(arkTSScriptInfo, result);
    }
  }

  // 唯一的回包出口：仅封装API调用与异常打印，不参与结果构造
  private async report(
    info: scriptManager.ArkTSScriptInfo,
    result: scriptManager.ExecuteResult
  ): Promise<void> {
    try {
      await scriptManager.completeArkTSScriptInApp(info.context, info.requestCode, result);
      console.info('completeArkTSScriptInApp succeeded');
    } catch (e) {
      const err = e as BusinessError;
      console.error(`completeArkTSScriptInApp failed, code: ${err.code}, message: ${err.message}`);
    }
  }
}

// [End module_MusicSkill]