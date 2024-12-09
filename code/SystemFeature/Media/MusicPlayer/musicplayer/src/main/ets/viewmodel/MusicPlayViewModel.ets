/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { avSession as AVSessionManager } from '@kit.AVSessionKit';
import { promptAction } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';

import { logger } from '../common/utils/Logger';

import CommonConstants from '../common/constants/CommonConstants';
import { AVPlayerModel } from '../model/AVPlayerModel';
import { AVSessionEventListener, AVSessionModel, AVSessionUpdateState } from '../model/AVSessionModel';
import { MusicInfo, MusicModel } from '../model/MusicModel';
import { Decimal } from '@kit.ArkTS';

export class MusicPlayerViewModel {
  constructor() {
  }
  // avplayer模块实例
  private avplayerModel: AVPlayerModel = new AVPlayerModel();
  // avsession模块实例
  private avsessionModel?: AVSessionModel;
  // 歌单列表（歌曲数据实例列表）
  private musicModelArr: Array<MusicModel> = [];
  // 当前播放的歌曲索引
  private curMusicModelIndex: number = 0;

  private curMusicModelRaw: MusicModel | undefined;
  public get curMusicModel(): MusicModel | undefined {
    return this.curMusicModelRaw;
  }

  private totalTimeStrRaw: string = '';

  public get totalTimeStr(): string {
    return this.totalTimeStrRaw;
  }

  private curTimeRaw: number = 0;

  public get curTime(): number {
    return this.curTimeRaw;
  }

  private curTimeStrRaw: string = '';

  public get curTimeStr(): string {
    return this.curTimeStrRaw;
  }

  private curProgressRaw: number = 0;

  public get curProgress(): number {
    return this.curProgressRaw;
  }

  private curPlayerStateRaw: string = CommonConstants.AVPLAYER_STATE_IDLE;

  public get curPlayerState(): string {
    return this.curPlayerStateRaw;
  }

  private progressLockRaw: boolean = false;

  public get progressLock(): boolean {
    return this.progressLockRaw;
  }

  public set progressLock(val: boolean) {
    this.progressLockRaw = val;
  }

  private curMusiclyricsLineRaw: number = 0;

  public get curMusiclyricsLine(): number {
    return this.curMusiclyricsLineRaw;
  }

  private curLoopModeRaw: number = AVSessionManager.LoopMode.LOOP_MODE_LIST;

  public set curLoopMode(value: number) {
    this.curLoopModeRaw = value;
  }

  public get curLoopMode(): number {
    return this.curLoopModeRaw;
  }


  /**
   * vm初始化
   * @param timeMs 跳跃到歌曲的毫秒时间点
   * @returns {Promise<void>}
   */
  async init(context: Context, musicInfoArr: Array<MusicInfo>): Promise<void> {
    // 初始化歌曲列表数据
    musicInfoArr.forEach((musicInfo: MusicInfo) => {
      const musicModel: MusicModel = new MusicModel(musicInfo);
      this.musicModelArr.push(musicModel);
    })
    this.curMusicModelRaw = this.musicModelArr[this.curMusicModelIndex];

    // 初始化计时
    this.updateTotalTime();
    this.updateCurTime(0);

    // 初始化AVSession
    this.avsessionModel = new AVSessionModel(context);
    const avSessionEventListener: AVSessionEventListener = {
      onPlay: () => {
        this.play();
      },
      onPause: () => {
        this.pause();
      },
      onStop: () => {
        this.stop();
      },
      onSeek: (timeMs: number) => {
        this.seek(timeMs);
      },
      onSetLoopMode: () => {
        this.updateLoopMode();
      },
      onPlayNext: () => {
        this.playNext();
      },
      onPlayPrevious: () => {
        this.playPrevious();
      }
    }
    await this.avsessionModel.createSession(avSessionEventListener);
    await this.avsessionModel.setSessionInfo(this.curMusicModelRaw);

    // 初始化AVPlayer
    await this.avplayerModel.initAVPlayer(
      (newTime: number) => {
        // 如果slider进度正在被用户拖动或点击过程中，则不通过avplayer来同步进度
        if (this.progressLockRaw) {
          // 如果本次同步过来的时间与slider当前时间一致，表示用户拖动或点击结束，此次之后开始接收avplayer的同步进度
          if (Math.abs(this.curTimeRaw - newTime) < 5) {
            this.progressLockRaw = false;
          }

          return;
        }

        this.updateCurTime(newTime);
      },
      (state: string) => {
        this.curPlayerStateRaw = state;
        this.avsessionModel?.updateCurState({
          playerState: state,
          curTime: this.curTimeRaw
        } as AVSessionUpdateState);
      },
      () => {
        this.playNext();
      }
    );
    this.prepare();

    // 监听应用前后台切换，注册后台任务启动和停止
    const applicationContext = context.getApplicationContext();
    const _that = this;
    applicationContext.on('applicationStateChange', {
      onApplicationForeground() {
        logger.info('applicationStateChangeCallback onApplicationForeground');
        _that.avsessionModel!.stopContinuousTask();
      },
      onApplicationBackground() {
        logger.info('applicationStateChangeCallback onApplicationBackground');
        if (_that.avplayerModel.getAVPlayerState() === CommonConstants.AVPLAYER_STATE_PLAYING) {
          _that.avsessionModel!.startContinuousTask();
        }
      }
    })
  }

  initAVSession() {

  }

  /**
   * 加载播放资源
   * @param finishTask prepare完成时的任务
   * @returns {Promise<void}
   */
  async prepare(finishTask?: Function): Promise<void> {
    if (!this.curMusicModelRaw) {
      return;
    }

    await this.avplayerModel.prepare(this.curMusicModelRaw.res, finishTask);
  }

  /**
   * 启动播放
   * @returns {void}
   */
  play(): void {
    this.avplayerModel.play();
  }

  /**
   * 暂停播放
   * @returns {void}
   */
  pause(): void {
    this.avplayerModel.pause();
  }

  /**
   * 恢复播放
   * @returns {void}
   */
  resume(): void {
    this.avplayerModel.resume();
  }

  /**
   * 结束播放
   * @returns {void}
   */
  stop(): void {
    this.avplayerModel.stop();
  }

  /**
   * 跳跃播放
   * @param timeMs 跳跃到歌曲的毫秒时间点
   * @returns {void}
   */
  seek(timeMs: number): void {
    this.avplayerModel.seek(timeMs);
    this.avsessionModel?.updateCurState({
      playerState: this.curPlayerStateRaw,
      curTime: timeMs
    } as AVSessionUpdateState);
  }

  /**
   * 重置播放器
   * @returns {Promise<void>}
   */
  async reset(): Promise<void> {
    await this.avplayerModel.resetAVPlayer();
  }

  /**
   * 释放播放器资源
   * @returns {void}
   */
  release(): void {
    this.avplayerModel.releaseAVPlayer();

    this.avsessionModel!.stopContinuousTask();
    this.avsessionModel!.destroySession();
  }

  /**
   * 生成时间字符串
   * @param timeMs 毫秒数
   * @returns {string} 时:分:秒 规格的字符串
   */
  genTimeStr(timeMs: number): string {
    const totalTime = timeMs / 1000;
    const hours = Math.floor(totalTime / CommonConstants.SECONDS_IN_HOUR);
    const leftTime = totalTime % CommonConstants.SECONDS_IN_HOUR;
    const minutes = Math.floor(leftTime / CommonConstants.SECONDS_IN_MINUTE);
    const seconds = Math.floor(leftTime % CommonConstants.SECONDS_IN_MINUTE);

    let hoursStr = '';
    let minutesStr = '';
    let secondsStr = '';

    if (hours < 10) {
      hoursStr = `0${hours}`;
    } else {
      hoursStr = hours.toString();
    }

    if (minutes < 10) {
      minutesStr = `0${minutes}`;
    } else {
      minutesStr = minutes.toString();
    }

    if (seconds < 10) {
      secondsStr = `0${seconds}`;
    } else {
      secondsStr = seconds.toString();
    }

    const totalTimeStr = `${hoursStr}:${minutesStr}:${secondsStr}`;
    return totalTimeStr;
  }

  /**
   * 更新播放歌曲总时间
   * @returns {void}
   */
  updateTotalTime(): void {
    if (!this.curMusicModelRaw) {
      return;
    }

    const totalTime = this.curMusicModelRaw.totalTime;
    this.totalTimeStrRaw = this.genTimeStr(totalTime);
  }

  /**
   * 更新播放歌曲当前进度时间
   * @param curTime 当前进度时间
   * @returns {void}
   */
  updateCurTime(curTime: number): void {
    if (!this.curMusicModelRaw) {
      return;
    }

    this.curTimeRaw = curTime;
    this.curTimeStrRaw = this.genTimeStr(curTime);
    this.curProgressRaw = curTime / this.curMusicModelRaw.totalTime * CommonConstants.MUSIC_SLIDER_MAX;
    this.curMusiclyricsLineRaw = this.curMusicModelRaw.lyricsInfo.checkCurLine(this.curTimeRaw);
  }

  /**
   * 更新播放循环模式（0:顺序，1:单曲循环，2:列表循环，3:随机循环）
   */
  updateLoopMode() {
    // 按顺序设置下一个循环模式
    this.curLoopMode = (this.curLoopMode + 1) % CommonConstants.LOOP_MODE_TOTAL_NUM;
    // 跳过顺序模式，不启用
    this.curLoopMode = this.curLoopMode ? this.curLoopMode : AVSessionManager.LoopMode.LOOP_MODE_SINGLE;
    this.avsessionModel?.updateCurState({
      loopMode: this.curLoopMode
    } as AVSessionUpdateState)
  }

  /**
   * 播放后一首（根据当前循环模式）
   */
  async playNext() {
    switch (this.curLoopMode) {
      case AVSessionManager.LoopMode.LOOP_MODE_SINGLE: {
        this.seek(0);
        break;
      }

      case AVSessionManager.LoopMode.LOOP_MODE_LIST: {
        this.curMusicModelIndex = (this.curMusicModelIndex + 1) % this.musicModelArr.length;
        this.curMusicModelRaw = this.musicModelArr[this.curMusicModelIndex];
        await this.reset();
        await this.avsessionModel?.setSessionInfo(this.curMusicModelRaw);
        await this.prepare(() => {
          this.play();
        });
        break;
      }

      case AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE: {
        const randomVal: number = Decimal.random(1).e;
        let dieta: number = 1;
        while (dieta < this.musicModelArr.length - 1) {
          if (randomVal >= dieta - 1 / this.musicModelArr.length - 1 &&
            randomVal < dieta / this.musicModelArr.length - 1) {
            break;
          }
          dieta++;
        }
        this.curMusicModelIndex = (this.curMusicModelIndex + dieta) % this.musicModelArr.length;
        this.curMusicModelRaw = this.musicModelArr[this.curMusicModelIndex];
        await this.reset();
        await this.avsessionModel?.setSessionInfo(this.curMusicModelRaw);
        await this.prepare(() => {
          this.play();
        });
        break;
      }
    }
  }

  /**
   * 播放前一首（根据当前循环模式）
   */
  async playPrevious() {
    switch (this.curLoopMode) {
      case AVSessionManager.LoopMode.LOOP_MODE_SINGLE: {
        this.seek(0);
        break;
      }

      case AVSessionManager.LoopMode.LOOP_MODE_LIST: {
        this.curMusicModelIndex = (this.curMusicModelIndex + this.musicModelArr.length - 1) % this.musicModelArr.length;
        this.curMusicModelRaw = this.musicModelArr[this.curMusicModelIndex];
        await this.reset();
        await this.avsessionModel?.setSessionInfo(this.curMusicModelRaw);
        await this.prepare(() => {
          this.play();
        });
        break;
      }

      case AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE: {
        const randomVal: number = Decimal.random(1).e;
        let dieta: number = 1;
        while (dieta < this.musicModelArr.length - 1) {
          if (randomVal >= dieta - 1 / this.musicModelArr.length - 1 &&
            randomVal < dieta / this.musicModelArr.length - 1) {
            break;
          }
          dieta++;
        }
        this.curMusicModelIndex = (this.curMusicModelIndex + dieta) % this.musicModelArr.length;
        this.curMusicModelRaw = this.musicModelArr[this.curMusicModelIndex];
        await this.reset();
        await this.avsessionModel?.setSessionInfo(this.curMusicModelRaw);
        await this.prepare(() => {
          this.play();
        });
        break;
      }
    }
  }

  /**
   * 未完成的功能，显示TODO消息提示
   * @returns {void}
   */
  showTodoToast(): void {
    promptAction.showToast({
      message: $r('app.string.foldable_screen_cases_toast_todo_show')
    })
  }
}

