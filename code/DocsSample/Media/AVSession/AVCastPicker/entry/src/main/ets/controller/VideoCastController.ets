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

import { avSession } from '@kit.AVSessionKit';
import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { VideoData } from '../model/VideoData';
import { getPixmapFromMedia } from '../common/utils/ImageUtil';

const TAG = 'AVCastPlayerController ';
const uiContext: UIContext | undefined = AppStorage.get('uiContext');

// [Start VideoCastController]
@Observed
export class VideoCastController {
  @Track public state: avSession.PlaybackState = avSession.PlaybackState.PLAYBACK_STATE_INITIAL;
  // [StartExclude VideoCastController]
  @Track public elapsedTime: number = 0;
  @Track public duration: number = 0;
  @Track public volume: number = 0;
  @Track public maxVolume: number = 0;
  @Track public videoIndex: number = -1;
  public avCastController: avSession.AVCastController;
  private videoDataArray: VideoData[] = [];
  public videoType: string = '';

  constructor(avCastController: avSession.AVCastController) {
    this.avCastController = avCastController;
  }

  // playItem方法为使用AVCastController进行资源播放的示例代码，实际应用参考setCastResource方法。
  // [Start render_video]
  playItem() {
    // 设置播放参数，开始播放
    let playItem : avSession.AVQueueItem = {
      itemId: 0,
      description: {
        assetId: 'VIDEO-1',
        title: 'ExampleTitle',
        artist: 'ExampleArtist',
        // 网络资源投播，设置mediaUri; 本地资源投播，将本地文件打开后，相关的文件描述符设置到fdSrc
        mediaUri: 'https://xxx.xxx.com/example.mp4',
        // 该字段大写，音频'AUDIO'，视频'VIDEO'
        mediaType: 'VIDEO',
        mediaSize: 1000,
        //startPosition为投播当前进度，设置该字段可将本机播放进度同步到远端
        startPosition: 0,
        // 投播资源播放时长，设置该字段可将本机播放时长同步到远端显示
        duration: 100000,
        albumCoverUri: 'https://www.examples.com',
        albumTitle: '《ExampleAlbum》',
        appName: 'ExampleApp',
        // DRM资源，需要配置支持的DRM类型, 以chinaDRM为例。
        drmScheme: '3d5e6d35-9b9a-41e8-b843-dd3c6e72c42c',
      }
    };
    // 准备播放，这个不会触发真正的播放，会进行加载和缓冲
    this.avCastController?.prepare(playItem, () => {
      console.info('Preparation done');
      // 启动播放，真正触发对端播放。请在Prepare成功后再调用start。
      this.avCastController?.start(playItem, () => {
        console.info('Playback started');
      });
    });
  }
  // [End render_video]

  /**
   * Sets and casts the specified video resource for playback.
   * @param videoIndex Index of the video in videoDataArray.
   * @param startPosition Starting position for playback in milliseconds.
   */
  async setCastResource(videoIndex: number, startPosition: number) {
    let imgPixel = await getPixmapFromMedia(this.videoDataArray[videoIndex].head);
    this.videoIndex = videoIndex;
    if (this.videoType === 'network') {
      let playItem: avSession.AVQueueItem = {
        itemId: videoIndex,
        description: {
          assetId: 'VIDEO-' + JSON.stringify(videoIndex),
          title: this.videoDataArray[videoIndex].name,
          subtitle: 'video',
          mediaUri: this.videoDataArray[videoIndex].url as string,
          mediaType: 'VIDEO',
          mediaImage: imgPixel,
          startPosition: startPosition,
          duration: this.videoDataArray[videoIndex].duration
        }
      };
      await this.avCastController.prepare(playItem).catch((err: BusinessError)=> {
        if (err.code) {
          hilog.error(0x0000, TAG, 'testTag', 'prepare failed, cause: %{public}s', JSON.stringify(err));
        }
      });
      await this.avCastController.start(playItem).catch((err: BusinessError)=>{
        if (err.code) {
          hilog.error(0x0000, TAG, 'testTag', 'start failed, cause: %{public}s', JSON.stringify(err));
        }
      });
    } else {
      let context = uiContext?.getHostContext() as common.UIAbilityContext;
      try {
        // [Start ArticleCitationsInitLocalWork]
        let file = await fileIo.open(context.filesDir + '/' + this.videoDataArray[videoIndex].url);
        let avFileDescriptor: media.AVFileDescriptor = { fd: file.fd };
        let playItem: avSession.AVQueueItem = {
          itemId: videoIndex,
          description: {
            assetId: 'VIDEO-' + JSON.stringify(videoIndex),
            title: this.videoDataArray[videoIndex].name,
            subtitle: 'video',
            mediaType: 'VIDEO',
            mediaImage: imgPixel,
            fdSrc: avFileDescriptor,
            startPosition: startPosition,
            duration: this.videoDataArray[videoIndex].duration
          }
        };
        // 准备播放，这个不会触发真正的播放，会进行加载和缓冲
        await this.avCastController.prepare(playItem);
        // 启动播放，真正触发对端播放。请在Prepare成功后再调用start。
        await this.avCastController.start(playItem);
      } catch (err) {
        hilog.error(0x0000, TAG, `open file ${err}`);
      }
    }
  }

  // playControl方法为使用AVCastController，监听控制命令和进行播放控制的示例代码。
  // 实际应用参考setAVCastCallback，setAVCastPlay，setAVCastPause等方法。
  // [Start play_control]
  playControl() {
    // 记录从avsession获取的远端控制器this.castController
    // 应用向对端设备下发播放命令
    let avCommand: avSession.AVCastControlCommand = {command:'play'};
    this.avCastController?.sendControlCommand(avCommand);

    // 应用向对端设备下发暂停命令
    avCommand = {command:'pause'};
    this.avCastController?.sendControlCommand(avCommand);

    // 应用调节对端设备音量
    avCommand = {
      command: 'setVolume',
      parameter: 1
    };
    this.avCastController?.sendControlCommand(avCommand);

    // 应用调节对端设备进度
    avCommand = {
      command: 'seek',
      parameter: 1
    };
    this.avCastController?.sendControlCommand(avCommand);
    // 更多控制指令请参考AVCastControlCommand
  }
  controlListener() {
    // 应用监听对端或播控中心上下一首/上下一集切换
    this.avCastController?.on('playPrevious', () => {
      console.info('PlayPrevious done');
    });
    this.avCastController?.on('playNext', () => {
      console.info('PlayNext done');
    });

    // 应用监听对端或播控中心播放状态、实时进度和音量变化事件
    this.avCastController?.on('playbackStateChange', 'all', (playbackState: avSession.AVPlaybackState)=>{
      if (playbackState?.state) {
        // 播放状态变化
      }
      if (playbackState?.position) {
        // 进度变化，可以根据position来获取对端播放的进度
      }
      if (playbackState?.volume) {
        // 音量变化
      }
    });

    // 应用监听对端投播内容播放完毕事件。应用监听到此回调，可以按照业务在以下三种选其一实现，否则无内容播放，对端出现黑屏。
    // 1. 有下一集时，自动切换下一集投播，此时需要调用Prepare和start重新设置新的url，参考步骤5
    // 2. 无下一集时，建议循环播放同一集，重新调用prepare和start来设置当前新的url，参考步骤5
    // 3. 业务不再支持投播，可以主动断开投播，参考步骤9。
    this.avCastController?.on('endOfStream', () => {
      // 按业务处理
    });

    // 应用监听对端或播控中心的进度调节完成事件，包括快进、快退、进度条拖拽完毕
    this.avCastController?.on('seekDone', (position: number) => {
      // seekDone表示用户在对端或是播控内进度调节完毕，可以在收到该回调后，根据'playbackStateChange'回调的position刷新绘制应用内进度条
      // 应用主动调用seek调节对端进度后，也请等待seekDone回调再根据'playbackStateChange'中的position来刷新，更精准
    });
  }
  // [End play_control]

  /**
   * Initializes AV casting session with specified video data.
   * @param videoDataArray Array of video data objects.
   * @param videoIndex Initial video index to play.
   * @param videoType Type of video source ('network' or 'local').
   * @param startPosition Initial playback position in milliseconds.
   */
  public async initAVCast(videoDataArray: VideoData[], videoIndex: number, videoType: string, startPosition: number) {
    this.videoDataArray = videoDataArray;
    this.videoType = videoType;
    await this.setCastResource(videoIndex, startPosition);
    try {
      let currentItem = await this.avCastController.getCurrentItem();
      this.duration = currentItem.description!.duration!;
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'prepare failed, cause: %{public}s', JSON.stringify(err));
      }
    }

    this.setAVCastCallback();
  }

  // [EndExclude VideoCastController]
  /**
   * Sets up AV cast playback state change callbacks.
   * Handles playback completion, position updates, volume changes and errors.
   */
  setAVCastCallback() {
    try{
      this.avCastController.on('playbackStateChange', ['state'], async (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.state) {
          this.state = playbackState.state;
        }
      });
      // [StartExclude VideoCastController]
      this.avCastController.on('playbackStateChange', ['position'], (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.position) {
          this.elapsedTime = playbackState.position.elapsedTime;
        }
      });
      this.avCastController.on('playbackStateChange', ['volume'], (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.volume) {
          this.volume = playbackState.volume;
        }
      });
      this.avCastController.on('playbackStateChange', ['maxVolume'], (playbackState: avSession.AVPlaybackState) => {
        if (playbackState.maxVolume) {
          this.maxVolume = playbackState.maxVolume;
        }
      });
      this.avCastController.on('playNext',async  () => {
        if (this.videoIndex < this.videoDataArray.length - 1) {
          this.videoIndex = this.videoIndex + 1;
        } else {
          this.videoIndex = 0;
        }
      });
      this.avCastController.on('playPrevious', () => {
        if (this.videoIndex === 0) {
          this.videoIndex = 0;
        } else {
          this.videoIndex = this.videoIndex - 1;
        }
      });
      this.avCastController.on('endOfStream',async () => {
        if (this.videoIndex < this.videoDataArray.length - 1) {
          this.videoIndex = this.videoIndex + 1;
        } else {
          this.videoIndex = 0;
        }
      });
      this.avCastController.on('error', (error: BusinessError) => {
        hilog.error(0x0000, TAG, `error happened, error code: ${error.code}, error message : ${error.message}.`);
      })
      this.avCastController.on('playbackStateChange', 'all', (playbackState: avSession.AVPlaybackState) => {
        hilog.info(0x0000, TAG, `playbackStateChange state ${playbackState}`);
      });
      // [EndExclude VideoCastController]
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast callback failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  // [StartExclude VideoCastController]
  // [Start AVCastControlCommand]
  public async setAVCastPlay() {
    let avCommand: avSession.AVCastControlCommand = { command: 'play' };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast play failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }
  // [End AVCastControlCommand]

  public async setAVCastPause() {
    let avCommand: avSession.AVCastControlCommand = { command: 'pause' };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast pause failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  /**
   * Sends fast forward command to AV cast controller.
   * Fast forwards playback by 15 seconds.
   */
  public async setAVCastFastForward() {
    let avCommand: avSession.AVCastControlCommand = { command: 'fastForward', parameter: 15 };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast forward failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  /**
   * Sends rewind command to AV cast controller.
   * Rewinds playback by 15 seconds.
   */
  public async setAVCastRewind() {
    let avCommand: avSession.AVCastControlCommand = { command: 'rewind', parameter: 15 };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast rewind failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  // [Start OtherAVCastControlCommand]
  public async setAVCastSeek(timeMS: number) {
    let avCommand: avSession.AVCastControlCommand = { command: 'seek', parameter: timeMS };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast seek failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  public async setAVCastVolume(volume: number) {
    let avCommand: avSession.AVCastControlCommand = { command: 'setVolume', parameter: volume };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast volume failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  public async setAVCastSpeed(speed: media.PlaybackSpeed) {
    let avCommand: avSession.AVCastControlCommand = { command: 'setSpeed', parameter: speed };
    try {
      await this.avCastController.sendControlCommand(avCommand);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV cast speed failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }
  // [End OtherAVCastControlCommand]

  /**
   * Releases AV cast controller resources and removes event listeners.
   */
  public async releaseAVCast() {
    try {
      this.avCastController.off('playbackStateChange');
      this.avCastController.off('playNext');
      this.avCastController.off('playPrevious');
      this.avCastController.off('endOfStream');
      await this.avCastController.release();
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'release AV cast failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }
  // [EndExclude VideoCastController]
}
// [End VideoCastController]