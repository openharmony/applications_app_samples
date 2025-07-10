/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

// model/SongModel.ets

// 歌曲模型接口
export interface Song {
  id: string;             // 歌曲唯一标识
  title: string;          // 歌曲标题
  artist: string;         // 演唱者
  album: string;          // 所属专辑
  coverUrl: Resource | string; // 封面图片资源路径
  duration: number;       // 歌曲时长（秒）
  filePath: string;       // 本地文件路径
  isLiked: boolean;       // 是否收藏
  genre?: string;         // 音乐流派（可选）
  trackNumber?: number;   // 在专辑中的曲目编号（可选）
}

// 播放列表状态类
export class PlaylistState {
  // 当前播放列表
  private _playlist: Song[] = [];
  // 当前播放索引
  private _currentIndex: number = 0;

  // 获取当前播放列表
  get playlist(): Song[] {
    return this._playlist;
  }

  // 设置当前播放列表
  set playlist(songs: Song[]) {
    if (songs && songs.length > 0) {
      this._playlist = [...songs];
      this._currentIndex = 0;
    } else {
      this._playlist = [];
      this._currentIndex = -1;
    }
  }

  // 获取当前播放歌曲
  get currentSong(): Song | null {
    return this._currentIndex >= 0 && this._playlist.length > 0
      ? this._playlist[this._currentIndex]
      : null;
  }

  // 获取当前播放索引
  get currentIndex(): number {
    return this._currentIndex;
  }

  // 下一首
  next(): boolean {
    if (this._playlist.length === 0) {
      return false;
    }

    this._currentIndex = (this._currentIndex + 1) % this._playlist.length;
    return true;
  }

  // 上一首
  prev(): boolean {
    if (this._playlist.length === 0) {
      return false;
    }

    this._currentIndex = (this._currentIndex - 1 + this._playlist.length) % this._playlist.length;
    return true;
  }

  // 跳转到指定位置
  jumpTo(index: number): boolean {
    if (index >= 0 && index < this._playlist.length) {
      this._currentIndex = index;
      return true;
    }
    return false;
  }

  // 添加到播放列表
  addSongs(songs: Song[]): void {
    if (songs.length === 0) {
      return;
    }

    this._playlist = [...this._playlist, ...songs];
    // 如果当前没有播放的歌曲，设置第一首为当前播放
    if (this._currentIndex === -1 && this._playlist.length > 0) {
      this._currentIndex = 0;
    }
  }

  // 移除歌曲
  removeSong(id: string): void {
    const index = this._playlist.findIndex(song => song.id === id);
    if (index === -1) {
      return;
    }

    // 如果移除的是当前播放歌曲
    if (index === this._currentIndex) {
      if (this._playlist.length === 1) {
        // 如果是最后一首
        this._playlist = [];
        this._currentIndex = -1;
      } else if (this._currentIndex === this._playlist.length - 1) {
        // 如果是最后一首
        this._currentIndex = 0;
        this._playlist.splice(index, 1);
      } else {
        // 保留当前索引，但列表往前移动
        this._playlist.splice(index, 1);
      }
    } else {
      // 如果移除的歌曲在当前播放之前，更新当前索引
      if (index < this._currentIndex) {
        this._currentIndex--;
      }
      this._playlist.splice(index, 1);
    }
  }

  // 清空播放列表
  clear(): void {
    this._playlist = [];
    this._currentIndex = -1;
  }

  // 切换歌曲喜欢状态
  toggleLike(id: string): void {
    const song = this._playlist.find(s => s.id === id);
    if (song) {
      song.isLiked = !song.isLiked;
    }
  }
}

// 播放模式枚举
export enum PlayMode {
  SEQUENCE = 0,      // 顺序播放
  SINGLE_CYCLE = 1,  // 单曲循环
  RANDOM = 2,        // 随机播放
  LIST_CYCLE = 3     // 列表循环
}

// 示例数据
export const DEFAULT_SONG: Song = {
  id: '0',
  title: 'Default Song',
  artist: 'Unknown Artist',
  album: 'Unknown Album',
  coverUrl: $r('app.media.app_icon'),
  duration: 225, // 3分45秒
  filePath: '',
  isLiked: false
};

// 类型转换工具
export class SongUtils {
  // 时长格式化工具（秒 → mm:ss）
  static formatDuration(duration: number): string {
    const mins = Math.floor(duration / 60);
    const secs = Math.floor(duration % 60);
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  // 从本地媒体库项目转为Song对象
  static fromMediaLibraryItem(item: MediaLibrary): Song {
    return {
      id: item.id,
      title: item.title || 'Unknown',
      artist: item.artist || 'Unknown Artist',
      album: item.album || 'Unknown Album',
      coverUrl: item.thumbnailUri || $r('app.media.app_icon'),
      duration: Math.floor(item.duration / 1000), // 毫秒转秒
      filePath: item.uri,
      isLiked: false,
      genre: item.genre,
      trackNumber: item.trackNumber
    };
  }
}

// 媒体库类型定义（需要根据实际API调整）
interface MediaLibrary {
  id: string;
  title: string;
  artist: string;
  album: string;
  thumbnailUri: string;
  duration: number; // 毫秒
  uri: string;
  genre: string;
  trackNumber: number;
}