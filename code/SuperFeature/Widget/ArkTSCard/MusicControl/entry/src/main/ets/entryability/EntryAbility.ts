/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIAbility from '@ohos.app.ability.UIAbility';
import type Window from '@ohos.window';
import commonEvent from '@ohos.commonEventManager';
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';
import wantAgent from '@ohos.wantAgent';
import avSession from '@ohos.multimedia.avsession';
import rpc from '@ohos.rpc';
import PlayerModel from '../feature/BackgroundPlayerFeature';
import Logger from '../util/Logger';

const TAG: string = 'EntryAbility';
const ONE_HUNDRED: number = 100; // Convert Milliseconds
const ONE_THOUSAND: number = 1000; // Convert second
const SIXTY: number = 60; // Convert minute
const MIN_TIME: number = 10; // Convert min time
const MUSIC_SIZE: number = 2; // Convert music size

export default class EntryAbility extends UIAbility {
  private currentSession = null;
  private isSwitching = false;
  private currentTimeText: string = '';
  private currentProgress: number = 0; // Current progress
  private totalMs: number = 0; // Total time
  private title: string = '';
  private totalTimeText: string = '00:00';
  private albumSrc: Resource = $r('app.media.album');
  private backgroundShow: boolean = false;
  private subscriberContext = null;

  onPlayClick(): void {
    if (this.isSwitching) {
      Logger.info(TAG, 'onPlayClick ignored, isSwitching');
      return null;
    }

    this.isSwitching = true;
    Logger.info(TAG, 'onPlayClick isPlaying= ${PlayerModel.isPlaying}');
    if (!PlayerModel.isPlaying) {
      // start continuous task
      PlayerModel.preLoad(PlayerModel.playerIndex, () => {
        PlayerModel.playMusic(-1, true);
      });
      this.startContinuousTask();
    }
    this.isSwitching = false;
    return null;
  }

  onPauseClick(): void {
    if (this.isSwitching) {
      Logger.info(TAG, 'onPauseClick ignored, isSwitching');
      return null;
    }
    this.isSwitching = true;
    Logger.info(TAG, 'onPauseClick isPlaying= ${PlayerModel.isPlaying}');
    if (PlayerModel.isPlaying) {
      PlayerModel.pauseMusic();
      // cancel continuous task
      this.stopContinuousTask();
    }
    this.isSwitching = false;
    return null;
  }

  onPreviousClick(): void {
    if (this.isSwitching) {
      Logger.info(TAG, 'onPreviousClick ignored, isSwitching');
      return null;
    }
    Logger.info(TAG, 'onPreviousClick');
    PlayerModel.playerIndex--;
    if (PlayerModel.playerIndex < 0 && PlayerModel.playlist.audioFiles.length >= 1) {
      PlayerModel.playerIndex = PlayerModel.playlist.audioFiles.length - 1;
    }
    this.currentProgress = 0;
    this.isSwitching = true;
    PlayerModel.preLoad(PlayerModel.playerIndex, () => {
      this.refreshSongInfo(PlayerModel.playerIndex as number);
      PlayerModel.playMusic(0, true);
      this.isSwitching = false;
    });
    this.startContinuousTask();
    return null;
  }

  // next
  onNextClick(): void {
    if (this.isSwitching) {
      Logger.info(TAG, 'onNextClick ignored, isSwitching');
      return null;
    }
    Logger.info(TAG, 'onNextClick');
    PlayerModel.playerIndex++;
    if (PlayerModel.playerIndex >= PlayerModel.playlist.audioFiles.length) {
      PlayerModel.playerIndex = 0;
    }
    this.currentProgress = 0;
    this.isSwitching = true;
    PlayerModel.preLoad(PlayerModel.playerIndex, () => {
      this.refreshSongInfo(PlayerModel.playerIndex as number);
      PlayerModel.playMusic(0, true);
      this.isSwitching = false;
    });
    this.startContinuousTask();
    return null;
  }

  onTime(): number {
    return (new Date()).getTime();
  }

  // start continuous task
  startContinuousTask(): void {
    let wantAgentInfo = {
      wants: [
        {
          bundleName: 'com.samples.musiccontrol',
          abilityName: 'EntryAbility',
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj) => {
      try {
        backgroundTaskManager.startBackgroundRunning(this.context,
          backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
          Logger.info(TAG, 'startBackgroundRunning succeeded');
        }).catch((err) => {
          Logger.info(TAG, 'startBackgroundRunning failed Cause:  ${JSON.stringify(err)}');
        });
      } catch (error) {
        Logger.error(TAG, 'Operation startBackgroundRunning failed. code is ${error.code} message is ${error.message}');
      }
    });
  }

  // cancel continuous task
  stopContinuousTask(): void {
    try {
      backgroundTaskManager.stopBackgroundRunning(this.context).then(() => {
        Logger.info(TAG, 'stopBackgroundRunning succeeded');
      }).catch((err) => {
        Logger.info(TAG, 'stopBackgroundRunning failed Cause:  ${JSON.stringify(err)}');
      });
    } catch (error) {
      Logger.error(TAG, 'stopBackgroundRunning failed. code is ${error.code} message is ${error.message}');
    }
  }

  getShownTimer(ms: number): string {
    let minStr: string;
    let secStr: string;
    let seconds = Math.floor(ms / ONE_THOUSAND);
    let sec = seconds % SIXTY;
    Logger.info(TAG, 'getShownTimer sec = ${sec}');
    let min = (seconds - sec) / SIXTY;
    Logger.info(TAG, 'getShownTimer min = ${min}');
    if (sec < MIN_TIME) {
      secStr = '0' + sec;
    } else {
      secStr = sec.toString(MIN_TIME);
    }
    if (min < MIN_TIME) {
      minStr = '0' + min;
    } else {
      minStr = min.toString(MIN_TIME);
    }
    Logger.warn(TAG, 'getShownTimer = ${minStr}:${secStr}');
    return minStr + ':' + secStr;
  }

  // refresh song
  refreshSongInfo(index: number): number {
    Logger.info(TAG, 'refreshSongInfo ${index}/${PlayerModel.playlist.audioFiles.length}');
    if (index >= PlayerModel.playlist.audioFiles.length) {
      Logger.warn(TAG, 'refreshSongInfo ignored');
      return 0;
    }
    // update song title
    this.title = PlayerModel.playlist.audioFiles[index].name;
    this.albumSrc = (index % MUSIC_SIZE === 0) ? $r('app.media.album') : $r('app.media.album2');
    // update duration
    this.totalMs = PlayerModel.getDuration();
    this.totalTimeText = this.getShownTimer(this.totalMs);
    this.currentTimeText = this.getShownTimer(PlayerModel.getCurrentMs() as number);
    Logger.info(TAG, 'refreshSongInfo this.title= ${this.title}, this.totalMs= ${this.totalMs}' +
      'this.totalTimeText= ${this.totalTimeText},this.currentTimeText= ${this.currentTimeText}');
    return 0;
  }

  createSubscriber(): void {
    let subscriberInfo = {
      events: ['music.event']
    };

    commonEvent.createSubscriber(subscriberInfo, (err, subscriber) => {
      if (err) {
        Logger.error(TAG, 'createSubscriber error. Cause:' + JSON.stringify(err));
      } else {
        Logger.info(TAG, 'createSubscriber success');
        this.subscriberContext = subscriber;
        this.subscriber();
      }
    });
  }

  subscriber(): void {
    if (this.subscriberContext !== null) {
      commonEvent.subscribe(this.subscriberContext, (err, data) => {
        if (err) {
          Logger.error(TAG, 'subscribe error. Cause:' + JSON.stringify(err));
        } else {
          Logger.info(TAG, 'subscribe success');
          if (data.data === 'delete') {
            this.stopContinuousTask();
            PlayerModel.stopMusic();
          }
        }
      });
    }
  }

  onCreate(want, launchParam): void {

    Logger.info(TAG, 'onCreate');
    this.backgroundShow = true;
    try {
      this.callee.on('play', (data: rpc.MessageSequence)=>{
        this.onPlayClick();
        return null;
      });
      this.callee.on('pause', (data: rpc.MessageSequence)=>{
        this.onPauseClick();
        return null;
      });
      this.callee.on('prev', (data: rpc.MessageSequence)=>{
        this.onPreviousClick();
        return null;
      });
      this.callee.on('next', (data: rpc.MessageSequence)=>{
        this.onNextClick();
        return null;
      });
    } catch (error) {
      console.error('Failed to register callee on. Cause:' + JSON.stringify(error));
    }
  }

  onDestroy(): void {
    Logger.info(TAG, 'onDestroy');
    try {
      this.callee.off('play');
      this.callee.off('pause');
      this.callee.off('prev');
      this.callee.off('next');
    } catch (error) {
      console.error('Failed to register callee off. Cause:' + JSON.stringify(error));
    }
  }

  onWindowStageCreate(windowStage: Window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'onWindowStageCreate');
    this.backgroundShow = false;
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.info(TAG, 'Failed to load the content. Cause: ${JSON.stringify(err)}');
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content. Data:  ${JSON.stringify(data)}');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, 'onForeground');
  }

  onBackground(): void {
    Logger.info(TAG, 'onBackground');
    this.createSubscriber();
    avSession.createAVSession(this.context, 'AVSessionPlayer', 'audio').then(async (session) => {
      Logger.info(TAG, 'createAVSession success');
      this.currentSession = session;
      await this.currentSession.activate(() => {
        Logger.info(TAG, 'activate success');
      });
      Logger.info(TAG, 'begin');
      this.currentTimeText = this.getShownTimer(0);
      PlayerModel.setOnStatusChangedListener((isPlaying: boolean) => {
        Logger.info(TAG, 'on player status changed, isPlaying= ${isPlaying} refresh ui');
        PlayerModel.setOnPlayingProgressListener((currentTimeMs: number) => {
          this.currentTimeText = this.getShownTimer(currentTimeMs);
          this.currentProgress = Math.floor(currentTimeMs / this.totalMs * ONE_HUNDRED);
        });
      });
      PlayerModel.getPlaylist(() => {
        Logger.info(TAG, 'on playlist generated, refresh ui');
        PlayerModel.preLoad(0, () => {
          this.refreshSongInfo(0);
        });
      });
    });
  }
}
