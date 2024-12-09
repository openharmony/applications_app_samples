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
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { logger } from '../common/utils/Logger';
import { MusicModel } from './MusicModel';
import CommonConstants from '../common/constants/CommonConstants';
import { util } from '@kit.ArkTS';


/**
 * AVSession管理模块，负责以下业务功能：
 * 1. 创建/销毁AVSession实例
 * 2. 注册AVSession实例业务回调功能
 * 3. 启动/关闭于AVSession共同使用的音频后台任务
 */
export class AVSessionModel {
  private bindContext?: Context;
  private session?: AVSessionManager.AVSession;
  private avSessionTag: string = 'MUSIC_PLAYER';
  private avSessionType: AVSessionManager.AVSessionType = 'audio';
  private curState: AVSessionManager.AVPlaybackState = {
    state: AVSessionManager.PlaybackState.PLAYBACK_STATE_INITIAL,
    position: {
      elapsedTime: 0,
      updateTime: 0,
    },
    loopMode:AVSessionManager.LoopMode.LOOP_MODE_SEQUENCE,
  };
  private isBackgroundTaskRunning: boolean = false;

  // AVPlayer状态同AVSession状态业务对应关系
  private playerState2PlaybackStateMap: Map<string, number> = new Map([
    [CommonConstants.AVPLAYER_STATE_IDLE, AVSessionManager.PlaybackState.PLAYBACK_STATE_IDLE],
    [CommonConstants.AVPLAYER_STATE_INITIALIZED, AVSessionManager.PlaybackState.PLAYBACK_STATE_INITIAL],
    [CommonConstants.AVPLAYER_STATE_PREPARED, AVSessionManager.PlaybackState.PLAYBACK_STATE_PREPARE],
    [CommonConstants.AVPLAYER_STATE_PLAYING, AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY],
    [CommonConstants.AVPLAYER_STATE_PAUSED, AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE],
    [CommonConstants.AVPLAYER_STATE_COMPLETED, AVSessionManager.PlaybackState.PLAYBACK_STATE_COMPLETED],
    [CommonConstants.AVPLAYER_STATE_STOPPED, AVSessionManager.PlaybackState.PLAYBACK_STATE_STOP],
    [CommonConstants.AVPLAYER_STATE_RELEASED, AVSessionManager.PlaybackState.PLAYBACK_STATE_RELEASED],
    [CommonConstants.AVPLAYER_STATE_ERROR, AVSessionManager.PlaybackState.PLAYBACK_STATE_ERROR],
  ]);

  constructor(context: Context) {
    this.bindContext = context;
  }

  /**
   * 创建AVSession实例
   * @param eventListener AVSession事件回调
   * @returns {Promise<void>}
   */
  async createSession(eventListener: AVSessionEventListener): Promise<void> {
    // TODO：知识点：创建AVSession实例
    this.session = await AVSessionManager.createAVSession(this.bindContext!, this.avSessionTag, this.avSessionType);
    // TODO：知识点：注册AVSession事件
    this.registerSessionListener(eventListener);
    // TODO：知识点：激活AVSession实例
    await this.session.activate().catch((error: BusinessError) => {
      logger.error('activate error: ', error.code.toString(), error.message)
    });

    logger.info(`session create done : sessionId : ${this.session.sessionId}`);
  }

  /**
   * 销毁AVSession实例
   * @returns {void}
   */
  destroySession(): void {
    // TODO：知识点：注销AVSession事件
    this.unRegisterListener();
    // TODO：知识点：销毁AVSession实例
    this.session?.destroy((err) => {
      if (err) {
        logger.error(`Destroy BusinessError: code: ${err.code}, message: ${err.message}`);
      } else {
        logger.info('Destroy : SUCCESS');
      }
    });
  }

  /**
   * 注册AVSession实例事件
   * 播控中心有多种操作，播放、暂停、停止、下一首、上一首、拖进度、标记喜好、播放循环模式切换、快进、快退
   * @returns {void}
   */
  registerSessionListener(eventListener: AVSessionEventListener): void {
    // 播放
    this.session?.on('play', () => {
      logger.info('avsession on play');
      eventListener.onPlay();
    });

    // 暂停
    this.session?.on('pause', () => {
      logger.info('avsession on pause');
      eventListener.onPause();
    });

    // 停止
    this.session?.on('stop', () => {
      logger.info('avsession on stop');
      eventListener.onStop();
    });

    // 下一首
    this.session?.on('playNext', async () => {
      logger.info('avsession on playNext');
      eventListener.onPlayNext();
    });

    // 上一首
    this.session?.on('playPrevious', async () => {
      logger.info('avsession on playPrevious');
      eventListener.onPlayPrevious();
    });

    // 拖进度
    this.session?.on('seek', (position) => {
      logger.info('avsession on seek', position.toString());
      eventListener.onSeek(position);
    });

    // 标记喜好
    this.session?.on('toggleFavorite', (assetId) => {
      logger.info('avsession on toggleFavorite', assetId);
    });

    // 播放循环模式切换
    this.session?.on('setLoopMode', (mode) => {
      logger.info('avsession on setLoopMode', mode.toString());
      eventListener.onSetLoopMode();
    });

    // 快进
    this.session?.on('fastForward', (skipInterval?: number) => {
      logger.info('avsession on fastForward', skipInterval ? skipInterval?.toString() : 'no skipInterval');
    });

    // 快退
    this.session?.on('rewind', (skipInterval?: number) => {
      logger.info('avsession on rewind', skipInterval ? skipInterval?.toString() : 'no skipInterval');
    });
  }

  /**
   * 注销AVSession实例事件
   * @returns {void}
   */
  unRegisterListener(): void {
    this.session?.off('play');
    this.session?.off('pause');
    this.session?.off('stop');
    this.session?.off('playNext');
    this.session?.off('playPrevious');
    this.session?.off('fastForward');
    this.session?.off('rewind');
    this.session?.off('seek');
    this.session?.off('setLoopMode');
    this.session?.off('toggleFavorite');
  }

  /**
   * 设置AVSession实例初始化数据和状态
   * @param {MusicModel | undefined} musicModel 歌曲数据
   * @returns {Promise<void>}
   */
  async setSessionInfo(musicModel?: MusicModel): Promise<void> {
    const resourceManager = this.bindContext!.resourceManager;
    const coverUInt8Arr: Uint8Array = await resourceManager.getRawFileContent(musicModel?.cover!);
    const imageBuffer: ArrayBuffer = coverUInt8Arr.buffer as ArrayBuffer;
    const imageSource: image.ImageSource = image.createImageSource(imageBuffer);
    const imagePixel: image.PixelMap = await imageSource.createPixelMap({
      desiredSize: {
        width: CommonConstants.MUSIC_MEDIA_IMAGE_WIDTH,
        height: CommonConstants.MUSIC_MEDIA_IMAGE_HEIGHT
      }
    });

    const lrcUInt8Arr: Uint8Array = await resourceManager.getRawFileContent(musicModel?.lrcRes!);
    const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    const lrcStr: string = textDecoder.decodeToString(lrcUInt8Arr, { stream: false });

    // 设置必要的媒体信息
    let metadata: AVSessionManager.AVMetadata = {
      assetId: 'testMusic', // 由应用指定，用于标识应用媒体库里的媒体
      title: musicModel?.title,
      mediaImage: imagePixel,
      artist: musicModel?.singer,
      duration: musicModel?.totalTime,
      lyric: lrcStr
    }
    // TODO：知识点：设置AVSession元信息
    this.session?.setAVMetadata(metadata).then(() => {
      logger.info(`SetAVMetadata successfully`);
    }).catch((err: BusinessError) => {
      logger.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
    });

    // 设置状态： 播放状态，进度位置，播放倍速，缓存的时间
    this.curState.state = AVSessionManager.PlaybackState.PLAYBACK_STATE_PREPARE;
    this.curState.position = {
      elapsedTime: 0,
      updateTime: new Date().getTime()
    }
    this.setAVPlaybackState();
  }

  /**
   * 更新AVSession实例状态
   * @param {AVSessionUpdateState} updateState 更新状态数据
   * @returns {void}
   */
  updateCurState(updateState: AVSessionUpdateState): void {
    const newState: string | undefined = updateState.playerState;
    const newElapsedTime: number | undefined = updateState.curTime;
    const newLoopMode: number | undefined = updateState.loopMode;
    logger.info('avsession updateCurState', newState + '', newElapsedTime + '');

    // 播控中心状态更新
    if (newState !== undefined) {
      this.curState.state = this.playerState2PlaybackStateMap.get(newState);
    }

    // 单曲进度更新
    if (newElapsedTime !== undefined) {
      this.curState.position = {
        elapsedTime: newElapsedTime,
        updateTime: new Date().getTime()
      }
    }

    // 循环播放模式更新
    if (newLoopMode !== undefined) {
      this.curState.loopMode = newLoopMode;
    }

    this.setAVPlaybackState();
  }

  /**
   * 设置AVSession实例状态
   * @returns {void}
   */
  setAVPlaybackState(): void {
    logger.info('avsession setAVPlaybackState', JSON.stringify(this.curState));
    // TODO：知识点：设置AVSession当前状态
    this.session?.setAVPlaybackState(this.curState, (err) => {
      if (err) {
        logger.error(`Failed to set AVPlaybackState. Code: ${err.code}, message: ${err.message}`);
      } else {
        logger.info(`SetAVPlaybackState successfully`);
      }
    });
  }

  /**
   * 启动后台任务
   * @returns {void}
   */
  startContinuousTask(): void {
    // 避免重新启动后台任务
    if (this.isBackgroundTaskRunning) {
      return;
    }

    // TODO：知识点：创建WantAgent实例，在后台任务时拉起应用
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表
      // 添加需要被拉起应用的bundleName和abilityName
      wants: [
        {
          bundleName: 'com.samples.musicplayer',
          abilityName: 'com.samples.musicplayer.EntryAbility'
        }
      ],
      // 指定点击通知栏消息后的动作是拉起ability
      actionType: wantAgent.OperationType.START_ABILITY,
      // 使用者自定义的一个私有值
      requestCode: 0,
      // 点击通知后，动作执行属性
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };
    // 通过wantAgent模块下getWantAgent方法获取WantAgent对象
    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
      // TODO：知识点：设置后台任务类型，启动后台任务
      backgroundTaskManager.startBackgroundRunning(this.bindContext!,
        backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
        // 此处执行具体的长时任务逻辑，如放音等。
        logger.info(`Succeeded in operationing startBackgroundRunning.`);
        this.isBackgroundTaskRunning = true;
      }).catch((err: BusinessError) => {
        logger.error(`Failed to operation startBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
      });
    });
  }

  /**
   * 结束后台任务
   * @returns {void}
   */
  stopContinuousTask(): void {
    // 避免重新停止后台任务
    if (!this.isBackgroundTaskRunning) {
      return;
    }

    // TODO：知识点：停止后台任务
    backgroundTaskManager.stopBackgroundRunning(this.bindContext!).then(() => {
      logger.info(`Succeeded in operationing stopBackgroundRunning.`);
      this.isBackgroundTaskRunning = false;
    }).catch((err: BusinessError) => {
      logger.error(`Failed to operation stopBackgroundRunning. Code is ${err.code}, message is ${err.message}`);
    });
  }
}

/**
 * AVSession会话交互事件监听接口
 */
export interface AVSessionEventListener {
  onPlay: Function,
  onPause: Function,
  onStop: Function,
  onSeek: Function,
  onSetLoopMode: Function,
  onPlayNext: Function,
  onPlayPrevious: Function
}

export interface AVSessionUpdateState {
  playerState?: string,
  curTime?: number,
  loopMode?: number,
}
