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
// [Start module_MusicPlayer]
// entry/src/main/ets/service/MusicPlayer.ets

// 单曲信息
export interface Track {
  name: string;
  singer: string;
  duration: number;
}

// 搜索结果
export interface PlayResult {
  tracks: Track[];
}

export class MusicPlayer {
  // 模拟歌库
  private static readonly library: Track[] = [
    { name: 'SongA', singer: 'SingerA', duration: 269 },
    { name: 'SongB', singer: 'SingerA', duration: 299 },
    { name: 'SongC', singer: 'SingerB', duration: 287 }
  ];

  // 当前正在播放的曲目；无播放时为null
  private static current: Track | null = null;

  /**
   * 按歌名 / 歌手搜索并播放
   * 命中 → 返回PlayResult(成功场景)
   * 未命中 → 返回null(失败场景，由调用方映射为ERR_NOT_FOUND)
   */
  public static searchAndPlay(songName: string, singer: string): PlayResult | null {
    const hits: Track[] = MusicPlayer.library.filter((t: Track): boolean => {
      const songMatch: boolean = songName.length === 0 || t.name.includes(songName);
      const singerMatch: boolean = singer.length === 0 || t.singer.includes(singer);
      return songMatch && singerMatch;
    });

    if (hits.length === 0) {
      return null;
    }

    MusicPlayer.current = hits[0];
    // 实际项目此处调用AVPlayer开始播放
    const result: PlayResult = { tracks: hits };
    return result;
  }

  /**
   * 控制当前播放
   * 有播放 → 返回操作后的当前曲目(成功场景)
   * 无播放 → 返回null(失败场景，可由调用方按需映射)
   */
  public static control(action: string): Track | null {
    // 用局部变量承接,以便后续类型收窄
    let current: Track | null = MusicPlayer.current;
    if (current === null) {
      return null;
    }

    if (action === 'next' || action === 'previous') {
      const idx: number = MusicPlayer.library.indexOf(current);
      const len: number = MusicPlayer.library.length;
      const step: number = action === 'next' ? 1 : -1;
      current = MusicPlayer.library[(idx + step + len) % len];
      MusicPlayer.current = current;
    }
    // 实际项目此处调用AVPlayer的pause / play / seekToNext等接口

    return current;
  }
}
// [End module_MusicPlayer]