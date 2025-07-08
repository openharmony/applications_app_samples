/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import { media } from '@kit.MediaKit';
import { Song } from '../util/SongModel';
import Logger from '../util/Logger'
import common from '@ohos.app.ability.common'

const TAG: string = 'Index'
const FD_PREFIX: string = 'fd://'
let player = media.createAudioPlayer()

@Entry
@Component
struct MusicPlayer {
  // 播放状态管理
  @State hasInit: boolean = false
  @State isPlaying: boolean = false;
  @State currentSong: Song = DEFAULT_SONG;
  @State playlist: Song[] = SAMPLE_PLAYLIST;
  @State currentPosition: number = 0; // 当前播放位置（秒）
  @State totalDuration: number = 4; // 歌曲总时长（秒），这里设为示例值4s
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext

  // 格式化时间显示（秒 → mm:ss）
  private formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  // 播放控制逻辑（需连接实际媒体服务）
  play() {
    this.isPlaying = true;
    if (this.hasInit) {
      player.play()
    } else {
      this.initAudioPlayer()
    }
  }

  pause() {
    this.isPlaying = false;
    player.pause()
  }

  prevSong() {
    // 实际逻辑应切换到前一首歌曲
    const currentIndex = this.playlist.findIndex(song => song.id === this.currentSong.id);
    const prevIndex = (currentIndex - 1 + this.playlist.length) % this.playlist.length;
    this.currentSong = this.playlist[prevIndex];
    // 重置播放进度
    this.currentPosition = 0;
  }

  nextSong() {
    // 实际逻辑应切换到下一首歌曲
    const currentIndex = this.playlist.findIndex(song => song.id === this.currentSong.id);
    const nextIndex = (currentIndex + 1) % this.playlist.length;
    this.currentSong = this.playlist[nextIndex];
    // 重置播放进度
    this.currentPosition = 0;
  }

  initAudioPlayer() {
    this.setCallback(player)
    this.context.resourceManager.getRawFd("1.mp3").then(value => {
      player.fdSrc = value
    })
  }

  setCallback(player: media.AudioPlayer) {
    player.on('dataLoad', () => {
      Logger.info(TAG, "audio load success")
      this.hasInit = true;
      player.play()
    })
    player.on('play', () => {
      Logger.info(TAG, "audio play success")
    })
    player.on('pause', () => {
      Logger.info(TAG, "audio pause success")
      this.pause()
    })
    player.on('finish', () => {
      Logger.info(TAG, "audio play finish")
      this.pause()
    })
    player.on('timeUpdate', (position) => {
      this.currentPosition = position / 1000
      Logger.info(TAG, "timeupdate play finish" + position)
    })
  }

  build() {
    Column() {
      // 顶部导航栏
      this.TopBar()

      // 专辑封面区域
      this.AlbumCover()

      // 歌曲信息区域
      this.SongInfo()

      // 进度条控制
      this.ProgressControl()

      // 播放控制按钮
      this.PlaybackControls()

      // 播放列表按钮
      this.PlaylistSection()
    }
    .width('100%')
    .height('100%')
  }

  @Builder TopBar() {
    Row() {
      Button(this.isPlaying ? '正在播放' : '已暂停')
        .fontSize(16)
        .fontColor('#FFFFFF')
        .backgroundColor('transparent')
        .opacity(0.7)

      Blank() // 占位空间

      Button()
        .backgroundColor('transparent')
    }
    .width('90%')
    .padding({ top: 12, bottom: 8 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder AlbumCover() {
    Column({ space: 8 }) {
      // 专辑封面图片
      Image(this.currentSong.coverUrl)
        .width(280)
        .height(280)
        .borderRadius(16)
        .objectFit(ImageFit.Cover)
        .margin({ top: 24 })

      // 播放指示器（动画效果）
      Row() {
        ForEach([1, 2, 3, 4, 5], (item: number) => {
          Column()
            .width(4)
            .height(20)
            .backgroundColor('#FF5C8D')
            .borderRadius(2)
            .margin({ left: 2, right: 2 })
            .animation({
              duration: 600,
              curve: Curve.EaseOut,
              delay: item * 100,
              iterations: -1, // 无限循环
              playMode: PlayMode.Alternate
            })
            .transform(
              { scale: { y: this.isPlaying ? (item % 2 ? 0.8 : 1.2) : 0.4 } }
            )
        })
      }
      .height(24)
      .margin({ top: 32 })
    }
    .height('35%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder SongInfo() {
    Column({ space: 8 }) {
      Text(this.currentSong.title)
        .fontSize(22)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(this.currentSong.artist)
        .fontSize(16)
        .fontColor('#9A9A9E')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('90%')
    .padding(8)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder ProgressControl() {
    Column() {
      Slider({
        value: this.currentPosition,
        min: 0,
        max: this.totalDuration,
        step: 1,
        style: SliderStyle.OutSet
      })
        .blockColor('#FF5C8D')
        .trackColor('#333333')
        .selectedColor('#FF5C8D')
        .onChange((value: number) => {
          // 实际开发中: avPlayer.seekTo(value * 1000)
          this.currentPosition = value;
        })
        .width('90%')

      Row() {
        Text(this.formatTime(this.currentPosition))
          .fontSize(12)
          .fontColor('#9A9A9E')

        Blank()

        Text(this.formatTime(this.totalDuration))
          .fontSize(12)
          .fontColor('#9A9A9E')
      }
      .width('90%')
      .margin({ top: -12 })
    }
    .width('100%')
    .margin({ top: 20, bottom: 24 })
  }

  @Builder PlaybackControls() {
    Row({ space: 48 }) {
      // 上一首按钮
      SymbolGlyph($r('sys.symbol.backward_end_fill'))
        .fontSize(42)
        .borderRadius(28)
        .onClick(() => this.prevSong())

      // 播放/暂停按钮
      SymbolGlyph(this.isPlaying ? $r('sys.symbol.pause') : $r('sys.symbol.play_fill'))
        .size({ width: 36, height: 36 })
        .fontSize(42)
        .borderRadius(36)
        .onClick(() => {
          if (this.isPlaying) {
            this.pause();
          } else {
            this.play();
          }
        })

      // 下一首按钮
      SymbolGlyph($r('sys.symbol.forward_end_fill'))
        .fontSize(42)
        .borderRadius(28)
        .onClick(() => this.nextSong())
    }
    .margin({ bottom: 36 })
  }

  @Builder PlaylistSection() {
    Row() {
      Button('播放列表')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#333333')
        .height(36)
        .borderRadius(18)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          // 展开播放列表逻辑
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}

// 示例数据模型
const DEFAULT_SONG: Song = {
  id: '0',
  title: 'Default Song',
  artist: 'Unknown Artist',
  album: 'Unkown Album',
  filePath: "",
  coverUrl: $r('app.media.app_icon'),
  duration: 5, // 3分45秒
  isLiked: false
};

const DEFAULT_SONG_SEC: Song = {
  id: '1',
  title: 'My Love',
  artist: 'Unknown Artist',
  album: 'Unkown Album',
  filePath: "",
  coverUrl: $r('app.media.app_icon'),
  duration: 5, // 3分45秒
  isLiked: false
};

const SAMPLE_PLAYLIST: Song[] = [
  DEFAULT_SONG, DEFAULT_SONG_SEC
];