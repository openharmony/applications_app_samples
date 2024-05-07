/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import media from '@ohos.multimedia.media';
import resourceManager from '@ohos.resourceManager';
import emitter from '@ohos.events.emitter';
import Logger from '../utils/Logger';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';

const CASE_ZERO = 0;
const CASE_ONE = 1;
const CASE_TWO = 2;
const CASE_THREE = 3;

export default class AvPlayManager {
  private tag: string = 'AVPlayManager';
  private avPlayer: media.AVPlayer | null = null;
  private surfaceID: string | null = null;
  private mgr: resourceManager.ResourceManager | null = null;
  private currentTime: number = 0;
  // 视频当前时间
  private durationTime: number = 0;
  // 视频总长
  private speedSelect: number | null = null;
  // 倍速选择
  private fileDescriptor: resourceManager.RawFileDescriptor | null = null;
  private videoSrc: string | null = null;
  private fileSrc: string | null = null;
  private default_track_value: string = "";
  private track_name_value: string = "";
  private currentAudioTrackValue: number = 0 ;
  public arrList: Array<SelectOption>  = [];

  /**
   * 初始化视频
   */
  async initPlayer(ctx: common.UIAbilityContext, surfaceId: string, callback: (avPlayer: media.AVPlayer) => void): Promise<void> {
    Logger.info(this.tag, `initPlayer==initCamera surfaceId== ${surfaceId}`);
    this.surfaceID = surfaceId;
    Logger.info(this.tag, `initPlayer==this.surfaceID surfaceId== ${this.surfaceID}`);
    try {
      Logger.info(this.tag, 'initPlayer videoPlay avPlayerDemo');
      // 创建avPlayer实例对象
      this.avPlayer = await media.createAVPlayer();
      // 创建状态机变化回调函数
      await this.setAVPlayerCallback(callback);
      Logger.info(this.tag, 'initPlayer videoPlay setAVPlayerCallback');
      this.mgr = ctx.resourceManager;
      Logger.info(this.tag, 'initPlayer videoPlay this.mgr');
      this.fileDescriptor = await this.mgr.getRawFd('test1.mp4');
      Logger.info(this.tag, `initPlayer videoPlay fileDescriptor = ${JSON.stringify(this.fileDescriptor)}`);
      this.avPlayer.fdSrc = this.fileDescriptor;
      this.mgr.getStringValue($r('app.string.default_track')).then((value: string) => {
        this.default_track_value = value;
      }).catch((error: BusinessError) => {
        console.error("getStringValue promise error is " + error);
      });
      this.mgr.getStringValue($r('app.string.track_name')).then((value: string) => {
        this.track_name_value = value;
      }).catch((error: BusinessError) => {
        console.error("getStringValue promise error is " + error);
      });
    } catch (err) {
      Logger.error(this.tag, `initPlayer initPlayer err：${JSON.stringify(err)}`);
    }
  }

  // 注册avplayer回调函数
  async setAVPlayerCallback(callback: (avPlayer: media.AVPlayer) => void, videoSrc?: string): Promise<void> {
    // seek操作结果回调函数
    if (this.avPlayer == null) {
      Logger.info(this.tag, 'avPlayer has not init');
      return;
    }
    this.avPlayer.on('seekDone', (seekDoneTime) => {
      Logger.info(this.tag, `setAVPlayerCallback AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用reset接口触发重置流程
    this.avPlayer.on('error', (err) => {
      Logger.error(this.tag, `setAVPlayerCallback Invoke avPlayer failed ${JSON.stringify(err)}`);
      if (this.avPlayer == null) {
        Logger.info(this.tag, 'avPlayer has not init');
        return;
      }
      this.avPlayer.reset();
    });
    // 状态机变化回调函数
    this.avPlayer.on('stateChange', async (state, reason) => {

      if (this.avPlayer == null) {
        Logger.info(this.tag, 'avPlayer has not init');
        return;
      }
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          this.avPlayer.release();
          this.avPlayerChoose(callback);
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state idle called.');
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayerstate initialized called.');
          if(this.surfaceID){
            this.avPlayer.surfaceId = this.surfaceID; // 设置显示画面，当播放的资源为纯音频时无需设置
            Logger.info(this.tag, `setAVPlayerCallback this.avPlayer.surfaceId = ${this.avPlayer.surfaceId}`);
            this.avPlayer.prepare();
          }
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state prepared called.');
          this.getAudioTrack();
          this.durationTime = this.avPlayer.duration;
          this.currentTime = this.avPlayer.currentTime;
          this.avPlayer.play(); // 调用播放接口开始播放
          callback(this.avPlayer);
          break;
        case 'playing': // play成功调用后触发该状态机上报
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state playing called.');
          let eventDataTrue: emitter.EventData = {
            data: {
              'flag': true
            }
          };
          let innerEventTrue: emitter.InnerEvent = {
            eventId: 2,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEventTrue, eventDataTrue);
          break;
        case 'completed': // 播放结束后触发该状态机上报
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state completed called.');
          let eventDataFalse: emitter.EventData = {
            data: {
              'flag': false
            }
          };
          let innerEvent: emitter.InnerEvent = {
            eventId: 1,
            priority: emitter.EventPriority.HIGH
          };
          emitter.emit(innerEvent, eventDataFalse);
          break;
        default:
          Logger.info(this.tag, 'setAVPlayerCallback AVPlayer state unknown called.');
          break;
      }
    });
    // 时间上报监听函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time;
      Logger.info(this.tag, `setAVPlayerCallback timeUpdate success,and new time is = ${this.currentTime}`);
    });
  }

  /**
   * 获取总时间
   */
  getDurationTime(): number {
    return this.durationTime;
  }

  /**
   * 获取当前时间
   */
  getCurrentTime(): number {
    return this.currentTime;
  }

  /**
   * 视频播放
   */
  videoPlay(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.play();
      } catch (e) {
        Logger.error(this.tag, `videoPlay = ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 视频暂停
   */
  videoPause(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.pause();
        Logger.info(this.tag, 'videoPause==');
      } catch (e) {
        Logger.info(this.tag, `videoPause== ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 调节1.0倍速
   */
  videoSpeedOne(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
        Logger.info(this.tag, 'videoSpeed_1_00');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1_00== ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 调节1.25倍速
   */
  videoSpeedOnePointTwentyFive(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
        Logger.info(this.tag, 'videoSpeed_1_25');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1_25== ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 调节1.75倍速
   */
  videoSpeedOnePointSeventyFive(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
        Logger.info(this.tag, 'videoSpeed_1_75');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_1_75==` + JSON.stringify(e));
      }
    }
  }

  /**
   * 调节2.0倍速
   */
  videoSpeedTwo(): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
        Logger.info(this.tag, 'videoSpeed_2_0');
      } catch (e) {
        Logger.info(this.tag, `videoSpeed_2_0== ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 视频跳转
   */
  async videoSeek(seekTime: number): Promise<void> {
    if (this.avPlayer) {
      try {
        this.avPlayer.seek(seekTime, media.SeekMode.SEEK_PREV_SYNC);
        this.currentTime = seekTime;
        Logger.info(this.tag, `videoSeek== ${seekTime}`);
      } catch (e) {
        Logger.info(this.tag, `videoSeek== ${JSON.stringify(e)}`);
      }
    }
  }

  /**
   * 视频重置
   */
  async videoReset(): Promise<void> {
    if (this.avPlayer == null) {
      Logger.info(this.tag, 'avPlayer has not init');
      return;
    }
    this.avPlayer.reset();
  }

  /**
   * 视频预下载
   */
  async preDownload(url: string): Promise<void> {
    if (this.avPlayer) {
      let mediaSource : media.MediaSource = media.createMediaSourceWithUrl(url,  {"aa" : "bb", "cc" : "dd"});
      let playbackStrategy : media.PlaybackStrategy = {preferredWidth: 1, preferredHeight: 2, preferredBufferDuration: 3, preferredHdr: false};
      this.avPlayer.setMediaSource(mediaSource, playbackStrategy)
    }
  }

  // 获取视频多音轨列表
  async getAudioTrack(): Promise<void> {
    if (this.avPlayer) {
      this.avPlayer.getTrackDescription().then((arrList: Array<media.MediaDescription>) => {
        Logger.info('getTrackDescription success');
        Logger.info(this.tag, 'get AudioTrackList: ' + arrList.length);
        if (this.arrList.length == 0 && arrList != null) {
          let selectOptions: SelectOption[] = [];
          for (let i = 0; i < arrList.length; i++) {
            if (i == 0) {
              selectOptions.push({ value: this.default_track_value});
            } else {
              let property: Object = arrList[i][media.MediaDescriptionKey.MD_KEY_TRACK_INDEX];
              selectOptions.push({ value: this.track_name_value + property.toString()});
            }
          }
          this.arrList = selectOptions
        } else {
          Logger.info(this.tag, 'audio getTrackDescription fail');
        }
      }).catch((error: BusinessError) => {
        Logger.error(`video catchCallback, error:${error}`);
      });
      return;
    }
  }

  // 设置视频多音轨轨道
  async setAudioTrack(audioTrackValue: number): Promise<void> {
    Logger.info(this.tag, 'selectTrack set AudioTrackType value is:' + audioTrackValue);
    switch (audioTrackValue) {
      case 0:
        if (this.avPlayer != null && this.currentAudioTrackValue != 0) {
          Logger.info(this.tag, 'deselectTrack start:' + (this.currentAudioTrackValue));
          this.avPlayer.deselectTrack(this.currentAudioTrackValue)
          Logger.info(this.tag, 'deselectTrack end:' + (this.currentAudioTrackValue));
        }
        break;
      default:
        if (this.avPlayer != null) {
          this.currentAudioTrackValue = audioTrackValue;
          Logger.info(this.tag, 'selectTrack start:' + (audioTrackValue));
          this.avPlayer.selectTrack(audioTrackValue)
          Logger.info(this.tag, 'selectTrack end:' + (audioTrackValue));
        }
        break;
    }
  }

  /**
   * 释放视频资源
   */
  async videoRelease(): Promise<void> {
    if (this.avPlayer == null) {
      Logger.info(this.tag, 'avPlayer has not init');
      return;
    }
    this.avPlayer.release((err) => {
      if (err == null) {
        Logger.info(this.tag, 'videoRelease release success');
      } else {
        Logger.error(this.tag, `videoRelease release filed,error message is = ${JSON.stringify(err.message)}`);
      }
    });
  }

  /**
   * 视频切换，前台调用
   */
  async videoChoose(videoSrc: string, speedSelect: number, callback: (avPlayer: media.AVPlayer) => void): Promise<void> {
    try {
      this.videoSrc = videoSrc;
      this.speedSelect = speedSelect;
      Logger.info(this.tag, `videoChoose this.videoSrc = ${this.videoSrc}`);
      this.currentTime = 0;
      this.currentAudioTrackValue = 0;
      this.arrList = []
      this.videoReset();
    } catch (e) {
      Logger.info(this.tag, 'videoChoose== ${JSON.stringify(e)}');
    }
  }

  /**
   * 视频切换，换视频资源
   */
  async avPlayerChoose(callback: (avPlayer: media.AVPlayer) => void): Promise<void> {
    try {
      Logger.info(this.tag, 'avPlayerChoose avPlayerDemo');
      if (this.avPlayer == null) {
        return;
      }
      // 创建avPlayer实例对象
      this.avPlayer = await media.createAVPlayer();
      // 创建状态机变化回调函数
      this.fileDescriptor = null;
      Logger.info(this.tag, `avPlayerChoose this.fileDescriptor = ${this.fileDescriptor}`);
      await this.setAVPlayerCallback(callback);
      Logger.info(this.tag, 'avPlayerChoose setAVPlayerCallback');
      if (this.videoSrc === 'network.mp4') {
        this.fileSrc = 'https:\/\/vd3.bdstatic.com\/mda-pdc2kmwtd2vxhiy4\/cae_h264\/1681502407203843413\/mda-pdc2kmwtd2vxhiy4.mp4';
      } else if (this.videoSrc === 'pre_download_network.mp4') {
        this.fileSrc = 'https:\/\/vd3.bdstatic.com\/mda-nmh2004d24kf4bjh\/hd/h264\/1671326683061787710\/mda-nmh2004d24kf4bjh.mp4';
      } else {
        this.fileSrc = this.videoSrc;
      }
      if (this.fileSrc) {
        let regex = new RegExp("^(http|https)", "i");
        let bool = regex.test(this.fileSrc);
        if (bool) {
          Logger.info(this.tag, `avPlayerChoose avPlayerChoose fileDescriptor = ${JSON.stringify(this.fileDescriptor)}`);
          if (this.videoSrc === 'pre_download_network.mp4') {
            this.preDownload(this.fileSrc);
          } else {
            this.avPlayer.url = this.fileSrc;
          }
        } else {
          if (this.mgr) {
            this.fileDescriptor = await this.mgr.getRawFd(this.fileSrc);
            Logger.info(this.tag, `avPlayerChoose avPlayerChoose fileDescriptor = ${JSON.stringify(this.fileDescriptor)}`);
            this.avPlayer.fdSrc = this.fileDescriptor;
          }
        }
      }
    } catch (e) {
      Logger.info(this.tag, 'avPlayerChoose trycatch avPlayerChoose');
      this.videoReset();
    }
  }
}