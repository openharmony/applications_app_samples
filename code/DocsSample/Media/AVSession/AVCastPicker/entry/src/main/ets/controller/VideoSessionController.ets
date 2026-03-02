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
import { BusinessError } from '@kit.BasicServicesKit';
// [Start create_session]
// [Start set_avMetadata]
import { avSession } from '@kit.AVSessionKit'; // 导入AVSession模块
// [StartExclude create_session]
// [StartExclude set_avMetadata]
import { common, wantAgent } from '@kit.AbilityKit';
import { media } from '@kit.MediaKit';
import { BackgroundTaskManager } from '../common/utils/BackgroundTaskManager';
import { VideoData } from '../model/VideoData';
import { VideoPlayerController } from './VideoPlayerController';
import { getPixmapFromMedia } from '../common/utils/ImageUtil';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [EndExclude create_session]
// [EndExclude set_avMetadata]

const TAG = 'VideoSessionController'

export class VideoSessionController {
  // [StartExclude create_session]
  // [StartExclude set_avMetadata]
  @Track public deviceName: string = '';
  @Track public connectionState: avSession.ConnectionState = avSession.ConnectionState.STATE_DISCONNECTED;
  public videoSession: avSession.AVSession;
  private constructor(videoSession: avSession.AVSession) {
    this.videoSession = videoSession;
  }

  // [EndExclude create_session]
  /**
   * Creates and activates a new AVSession for video playback.
   * @param context The UIAbility context for session creation.
   * @returns Promise<AVSessionController> Initialized session controller instance.
   */
  static async create(context: common.UIAbilityContext) {
    try {
      let videoSession = await avSession.createAVSession(context, 'VIDEO_SESSION', 'video');
      // Set up a background task.
      BackgroundTaskManager.startContinuousTask(context);
      const wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: context.abilityInfo.bundleName,
            abilityName: context.abilityInfo.name
          }
        ],
        actionType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };

      let agent = wantAgent.getWantAgent(wantAgentInfo).catch((error: Error) => {
        let err = error as BusinessError
        if (err.code) {
          hilog.error(0x0000, TAG, 'testTag', 'get want agent failed, cause: %{public}s', JSON.stringify(err));
        }
      });
      videoSession.setLaunchAbility(agent).catch((error: Error) => {
        let err = error as BusinessError
        if (err.code) {
          hilog.error(0x0000, TAG, 'testTag', 'set launch ability failed, cause: %{public}s', JSON.stringify(err));
        }
      });
      videoSession.activate().catch((error: Error) => {
        let err = error as BusinessError
        if (err.code) {
          hilog.error(0x0000, TAG, 'testTag', 'activate failed, cause: %{public}s', JSON.stringify(err));
          }
      });
      // 请按照如下参数设置，告知系统应用当前支持投播，才能成功投播。
      videoSession.setExtras({
        requireAbilityList: ['url-cast'],
      });
      console.info(`Session created. sessionId: ${videoSession.sessionId}`);
      return new VideoSessionController(videoSession);
    } catch(error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'create video session controller failed, cause: %{public}s', JSON.stringify(err));
      }
      return;
    }
  }

  // [StartExclude create_session]
  // [EndExclude set_avMetadata]
  /**
   * Sets metadata for the current video session.
   * @param curSource Video data containing index, name and head image.
   * @param duration Total duration of the video in milliseconds.
   */
  public async setAVMetadata(curSource: VideoData, duration: number) {
    let headPixel = await getPixmapFromMedia(curSource.head);
    let metadata: avSession.AVMetadata = {
      assetId: `${curSource.index}`,
      title: curSource.name,
      mediaImage: headPixel,
      duration: duration,
      // 发现Cast+ Stream 和 DLNA协议设备，TYPE_CAST_PLUS_STREAM为默认必选。
      filter: avSession.ProtocolType.TYPE_DLNA | avSession.ProtocolType.TYPE_CAST_PLUS_STREAM,
      // 如果是DRM资源，配置支持的DRM uuid 用于设备过滤。非DRM资源不配置。
      drmSchemes: ['3d5e6d35-9b9a-41e8-b843-dd3c6e72c42c']
    };
    try {
      await this.videoSession.setAVMetadata(metadata);
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AVMedia failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }
  // [StartExclude set_avMetadata]
  /**
   * Initializes AV session playback state from player controller.
   * @param avPlayerController The player controller providing playback state.
   */
  public initAvSessionPlayState(avPlayerController: VideoPlayerController) {
    this.videoSession.setAVPlaybackState({
      state: avPlayerController.state === 'playing' ? avSession.PlaybackState.PLAYBACK_STATE_PLAY :
      avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      position: {
        elapsedTime: avPlayerController.currentTime,
        updateTime: new Date().getTime(),
      },
      speed: 1.0,
      bufferedTime: 14000,
      duration: avPlayerController.durationTime
    }).catch((error: Error) => {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'create video session controller failed, cause: %{public}s', JSON.stringify(err));
      }
    });
  }

  /**
   * Updates AV session playback state.
   * @param state Current player state ('playing' or other).
   */
  public async setAvSessionState(state: string) {
    // [Start ArticleCitationsSetAvSessionState]
    await this.videoSession.setAVPlaybackState({
      state: state === 'playing' ? avSession.PlaybackState.PLAYBACK_STATE_PLAY :
      avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
    }).catch((error: Error) => {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AVSession state failed, cause: %{public}s', JSON.stringify(err));
      }
    });
    // [End ArticleCitationsSetAvSessionState]
  }

  /**
   * Updates playback speed in AV session.
   * @param speed The current playback speed (1.0 = normal speed).
   */
  public async setAvSessionSpeed(speed: number) {
    await this.videoSession.setAVPlaybackState({
      speed: speed
    }).catch((error: Error) => {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'create video session controller failed, cause: %{public}s', JSON.stringify(err));
      }
    });
  }

  /**
   * Updates playback position in AV session.
   * @param position Current playback position in milliseconds.
   */
  public async setAvSessionPosition(position: number) {
    try {
      await this.videoSession.setAVPlaybackState({
        position: {
          elapsedTime: position,
          updateTime: new Date().getTime()
        }
      });
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AV session position failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  // [Start release_session]
  public async stopCasting() {
    try {
      await this.videoSession.stopCasting();
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'stop casting failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }
  // [End release_session]

  // [EndExclude set_avMetadata]
  /**
   * Sets up AV session event listeners for playback control.
   * Handles play/pause/stop commands, seeking, fast forward/rewind, and device changes.
   * @param avPlayerController The player controller to manage playback.
   */
  public async setAvSessionListener(avPlayerController: VideoPlayerController) {
    try {
      // [Start ArticleCitationsSetSetAvSessionListener]
      this.videoSession.on('play', () => avPlayerController.setAVPlayerPlaying());
      this.videoSession.on('pause', () => avPlayerController.setAVPlayerPause());
      // [End ArticleCitationsSetSetAvSessionListener]
      this.videoSession.on('stop', () => avPlayerController.setAVPlayerPause());
      this.videoSession.on('seek', (time: number) => {
        avPlayerController.avPlayerSeek(time, media.SeekMode.SEEK_CLOSEST).catch((error: Error) => {
          let err = error as BusinessError
          if (err.code) {
            hilog.error(0x0000, TAG, 'testTag', 'avPlayer seek failed, cause: %{public}s', JSON.stringify(err));
          }
        });
      });
      this.videoSession.on('fastForward', (time?: number) => {
        if (time) {
          avPlayerController.avPlayerSeek(avPlayerController.currentTime + 15000, media.SeekMode.SEEK_NEXT_SYNC)
            .catch((error: Error) => {
              let err = error as BusinessError
              if (err.code) {
                hilog.error(0x0000, TAG, 'testTag', 'avPlayer seek failed, cause: %{public}s', JSON.stringify(err));
              }
            });
        }
      });
      this.videoSession.on('rewind', (time?: number) => {
        if (time) {
          avPlayerController.avPlayerSeek(avPlayerController.currentTime - 15000, media.SeekMode.SEEK_PREV_SYNC)
            .catch((error: Error) => {
              let err = error as BusinessError
              if (err.code) {
                hilog.error(0x0000, TAG, 'testTag', 'avPlayer seek failed, cause: %{public}s', JSON.stringify(err));
              }
            });
        }
      });
      this.videoSession.on('outputDeviceChange',
        (state: avSession.ConnectionState, device: avSession.OutputDeviceInfo) => {
          this.connectionState = state;
          this.deviceName = device.devices[0].deviceName;
        })
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set AVSession Listener failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  // [StartExclude set_avMetadata]
  /**
   * Releases AV session resources and removes all listeners.
   * @param context The UIAbility context for cleanup tasks.
   */
  public async releaseAvSessionListener(context: common.UIAbilityContext) {
    try {
      this.videoSession.off('play');
      this.videoSession.off('pause');
      this.videoSession.off('playNext');
      this.videoSession.off('playPrevious');
      this.videoSession.off('setLoopMode');
      this.videoSession.off('seek');
      this.videoSession.off('rewind');
      this.videoSession.off('outputDeviceChange');
      await BackgroundTaskManager.stopContinuousTask(context);
      await this.videoSession.stopCasting();
      await this.videoSession.destroy();
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'release AVSession Listener failed, cause: %{public}s', JSON.stringify(err));
      }
    }
  }

  // [Start get_outputDevice]
  getOutputDevice() {
    this.videoSession?.getOutputDevice().then((outputDeviceInfo: avSession.OutputDeviceInfo) => {
      // 当前设备的castCategory为Remote，则表示正在投播中
      let isCasting = outputDeviceInfo.devices[0].castCategory === avSession.AVCastCategory.CATEGORY_REMOTE;
    }).catch((err: BusinessError) => {
      console.error(`GetOutputDevice BusinessError: code: ${err.code}, message: ${err.message}`);
    });
  }
  // [End get_outputDevice]

  // [Start check_otherCast]
  async checkOtherCast() {
    try {
      let currentOutputDevice: avSession.OutputDeviceInfo | undefined = this.videoSession.getOutputDeviceSync();
    } catch (err) {
      let error = err as BusinessError;
      console.error(`getOutputDeviceSync error, error code: ${error.code}, error message: ${error.message}`);
    }
  }
  // [End check_otherCast]
  // [EndExclude create_session]
  // [EndExclude set_avMetadata]
}
// [End create_session]
// [End set_avMetadata]