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

import { common } from '@kit.AbilityKit';
import { media } from '@kit.MediaKit';
import { hilog } from '@kit.PerformanceAnalysisKit'
import { VideoData } from '../model/VideoData';
import { FrameNode } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { CommonConstants, VideoDataType } from '../common/constants/CommonConstants';

const TAG = '[AVPlayerController]';

@Observed
export class AVPlayerController {
  @Track surfaceID: string = '';
  @Track isPlaying: boolean = false;
  @Track currentTime: number = 0;
  @Track durationTime: number = 0;
  private avPlayer?: media.AVPlayer;
  private curSource?: VideoData;
  private context: common.Context | undefined = undefined;
  private seekTime?: number;
  private isMuted: boolean | undefined = undefined;

  constructor(context: common.Context) {
    this.context = context;
  }

  // [Start av_player_init]
  public async initAVPlayer(source: VideoData, surfaceId: string) {
    this.curSource = source;
    if (source.seekTime) {
      this.seekTime = source.seekTime;
    }
    if (source.isMuted) {
      this.isMuted = source.isMuted;
    }
    if (!this.curSource) {
      return;
    }
    this.surfaceID = surfaceId; // 存储surfaceId
    try {
      this.avPlayer = await media.createAVPlayer();
      this.setAVPlayerCallback();
      // 根据不同的视频文件格式设置视频源
      switch (this.curSource.type) {
        case VideoDataType.RAW_FILE:
          let fileDescriptor = await this.context?.resourceManager.getRawFd(this.curSource.videoSrc);
          this.avPlayer.fdSrc = fileDescriptor;
          break;
        case VideoDataType.URL:
          this.avPlayer.url = this.curSource.videoSrc;
          break;
        case VideoDataType.RAW_M3U8_FILE:
          // [StartExclude av_player_init]
          let m3u8Fd = await this.context?.resourceManager.getRawFd(this.curSource.videoSrc);
          let fdUrl = 'fd://' + m3u8Fd?.fd + '?offset=' + m3u8Fd?.offset + '&size=' + m3u8Fd?.length;
          let mediaSource = media.createMediaSourceWithUrl(fdUrl);
          mediaSource.setMimeType(media.AVMimeTypes.APPLICATION_M3U8);
          let playbackStrategy: media.PlaybackStrategy = { preferredBufferDuration: 20, showFirstFrameOnPrepare: true };
          await this.avPlayer.setMediaSource(mediaSource, playbackStrategy);
          break;
        // [EndExclude av_player_init]
        case VideoDataType.RAW_MAP4_FILE:
          // [StartExclude av_player_init]
          let mp4Fd = await this.context?.resourceManager.getRawFd(this.curSource.videoSrc);
          let mp4FdUrl = 'fd://' + mp4Fd?.fd;
          this.avPlayer.url = mp4FdUrl;
          break;
        // [EndExclude av_player_init]
        default:
          break;
      }
    } catch (err) {
      hilog.error(CommonConstants.LOG_DOMAIN, TAG,
        `InitPlayer failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  private setAVPlayerCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('durationUpdate', (time: number) => {
      AppStorage.setOrCreate('DurationTime', time); // 更新视频总时长
    });
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time; // 更新当前进度
      AppStorage.setOrCreate('CurrentTime', time);
    });
    this.avPlayer.on('error', (err: BusinessError) => {
      if (!this.avPlayer) {
        return;
      }
      hilog.error(CommonConstants.LOG_DOMAIN, TAG,
        `Invoke avPlayer failed, code is ${err.code}, messasge is ${err.message}`);
      this.avPlayer.reset().catch((err: BusinessError) => {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `Reset failed, code is ${err.code}, message is ${err.message}`);
      });
    })
    this.setStateChangeCallback();
  }

  private setStateChangeCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('stateChange', async (state) => {
      if (!this.avPlayer) {
        return;
      }
      switch (state) {
        case 'idle':
          hilog.info(CommonConstants.LOG_DOMAIN, TAG, `setAVPlayerCallback AVPlayer state idle called.`);
          break;
        case 'initialized':
          this.avPlayer.surfaceId = this.surfaceID; // 设置surfaceId，作为视频画面承载的画布
          this.avPlayer.prepare().catch((err: BusinessError) => {
            hilog.error(CommonConstants.LOG_DOMAIN, TAG,
              `prepare failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        case 'prepared':
          // [StartExclude av_player_init]
          this.avPlayer.loop = true;
          this.durationTime = this.avPlayer.duration;
          this.currentTime = this.avPlayer.currentTime;
          if (this.seekTime) {
            this.avPlayer.seek(this.seekTime!, media.SeekMode.SEEK_CLOSEST);
          }
          let eventData: emitter.EventData = {
            data: {
              'percent': this.avPlayer.width / this.avPlayer.height
            }
          };
          emitter.emit(CommonConstants.AVPLAYER_PREPARED, eventData);
          if (this.isMuted) {
            try {
              await this.avPlayer.setMediaMuted(media.MediaType.MEDIA_TYPE_AUD, this.isMuted!);
            } catch (err) {
              hilog.error(CommonConstants.LOG_DOMAIN, TAG,
                `setMediaMuted failed, code is ${err.code}, message is ${err.message}`);
            }
          }
          this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_SCALED_ASPECT;
          // [EndExclude av_player_init]
          // 实现自动播放
          this.avPlayer.play().catch((err: BusinessError) => {
            hilog.error(CommonConstants.LOG_DOMAIN, TAG, `play failed, code is ${err.code}, message is ${err.message}`);
          })
          break;
        case 'playing':
          this.isPlaying = true;
          break;
        case 'completed':
          this.currentTime = 0;
          break;
        default:
          break;
      }
    });
  }
  // [End av_player_init]
  videoPlay(): void {
    if (this.avPlayer) {
      this.avPlayer.play().catch((err: BusinessError) => {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `play failed, code is ${err.code}, message is ${err.message}`);
      });
      this.isPlaying = true;
    }
  }

  videoPause(): void {
    if (this.avPlayer) {
      this.avPlayer.pause().catch((err: BusinessError) => {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `addSubtitleFromFd failed, code is ${err.code} message is ${err.message}`);
      });
      this.isPlaying = false;
    }
  }

  videoSeek(seekTime: number): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.seek(seekTime, media.SeekMode.SEEK_CLOSEST);
      } catch (err) {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `videoSeek failed, code is ${err.code}, message is ${err.message}`);
      }
    }
  }
}