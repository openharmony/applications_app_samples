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

// [Start controller_callback]
import { AVCastPicker, AVCastPickerState, AVCastPickerStyle, avSession } from '@kit.AVSessionKit';
import { GetLicense } from '../common/utils/GetLicense'
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude controller_callback]
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { VideoPlayerController } from '../controller/VideoPlayerController';
import { VideoData } from '../model/VideoData';
import { AVPlayerControllerView, VolumeControllerView } from './AVPlayerControllerView';
import { VideoSessionController } from '../controller/VideoSessionController';
import { VideoCastController } from '../controller/VideoCastController';
import { IconButton } from './CommonView';

const TAG = 'VideoPlayingView';
const uiContext: UIContext | undefined = AppStorage.get('uiContext');

class VideoPlayParam {
  public videoType: string;
  public videoTime: number = 0;
  public videoIndex: number = 0;

  constructor(videoType: string, videoTime?: number, videoIndex?: number) {
    this.videoType = videoType;
    if (videoTime) {
      this.videoTime = videoTime;
    }
    if (videoIndex) {
      this.videoIndex = videoIndex;
    }
  }
}
// [EndExclude controller_callback]
@Component
export struct VideoPlayingView {
  @StorageLink('avCastController') castController: avSession.AVCastController | undefined = undefined;
  @State getLicense: GetLicense = new GetLicense();
  // [StartExclude controller_callback]
  @StorageLink('avPlayerController') @Watch('avPlayerStateChange') avPlayerController?: VideoPlayerController = undefined;
  @StorageLink('avCastController') avCastController?: VideoCastController = undefined;
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('castingList') castingList: string[] = [];
  @StorageLink('avSessionController') @Watch('avSessionControllerChange') avSessionController ?: VideoSessionController =
    undefined;
  @StorageLink('avplayerContinueIndex') avplayerContinueIndex: number = 0;
  @Consume('remoteControlPathStack') remoteControlPathStack: NavPathStack;
   @Consume videoType: string;
  @Prop videoList: VideoData[];
  @Link videoIndex: number;
  @Link @Watch('episodeChoose') episodeChooseIndex: number;
  @State surfaceID: string = '';
  @State currentTime: number = 0;
  @State durationTime: number = 0;
  @State isPlaying: boolean = false;
  @State volumeValue: number = 0;
  @State isShowVolumeController: boolean = false;
  @State isShowAVPlayerController: boolean = false;
  @State avPlayerControllerTimeID: number = 0;
  @State connectionState: avSession.ConnectionState = avSession.ConnectionState.STATE_DISCONNECTED;
  public videoPlayPathStack: NavPathStack = new NavPathStack();
  private xComponentController = new XComponentController();

  avSessionControllerChange() {
    if (this.avSessionController) {
      this.deviceName = this.avSessionController.deviceName;
      this.connectionState = this.avSessionController.connectionState;
    }
  }

  async avPlayerStateChange() {
    if (this.avPlayerController) {
      this.currentTime = this.avPlayerController.currentTime;
      this.durationTime = this.avPlayerController.durationTime;
      this.isPlaying = Boolean(this.avPlayerController.state === 'playing');
      this.volumeValue = this.avPlayerController.volume;
      if (this.avPlayerController.state === 'prepared') {
        if (!this.avSessionController) {
          await this.initAVSession();
        } else {
          await this.configSession();
        }
      }
      if (this.avPlayerController.state === 'completed') {
        this.nextVideo();
      }
    }
  }

  async initAVPlayer() {
    this.surfaceID = this.xComponentController.getXComponentSurfaceId();
    this.avPlayerController =
      await VideoPlayerController.create(this.surfaceID, this.videoType, this.videoList[this.videoIndex].url);
  }

  async initAVSession() {
    if (this.avPlayerController) {
      this.avSessionController =
        await VideoSessionController.create(uiContext?.getHostContext() as common.UIAbilityContext);
      await this.configSession();
      await this.initAVCastPicker(this.avSessionController!.videoSession);
    }
  }

  /**
   * Configures AV session with player controller.
   * Sets up metadata, playback state, and event listeners.
   * Handles playNext/playPrevious commands and state synchronization.
   */
  async configSession() {
    if (!this.avSessionController || !this.avPlayerController) {
      return;
    }
    await this.avSessionController.setAVMetadata(this.videoList[this.videoIndex],
      this.videoList[this.videoIndex].duration);
    this.avSessionController.setAvSessionListener(this.avPlayerController);
    this.avSessionController.initAvSessionPlayState(this.avPlayerController);
    try {
      this.avSessionController.videoSession.on('playNext', () => {
        this.nextVideo();
      });
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'get video session failed, cause: %{public}s', JSON.stringify(err));
      }
    }
    try {
      this.avSessionController.videoSession.on('playPrevious', () => {
        if (this.videoIndex >= 1) {
          this.videoIndex -= 1;
        }
      });
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'get video session failed, cause: %{public}s', JSON.stringify(err));
      }
    }
    this.avPlayerController.onStateChange(async (newState: string) => {
      this.avSessionController?.setAvSessionState(newState);
    });
    this.avPlayerController.onSpeedChange(async (newSpeed: number) => {
      this.avSessionController?.setAvSessionSpeed(newSpeed);
    });
    this.avPlayerController.onPositionChange(async (newPosition: number) => {
      this.avSessionController?.setAvSessionPosition(newPosition);
    });
  }

  /**
   * Initializes AV casting device picker and handles device connection changes.
   * Manages remote/local device connections and playback transitions.
   * @param videoSession: The AV session to configure for casting.
   */
  async initAVCastPicker(videoSession: avSession.AVSession) {
    // [Start ArticleCitationsSetExtras]
    await videoSession.setExtras({
      'requireAbilityList': ['url-cast']
    }).catch((err: BusinessError) => {
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'set extras failed, cause: %{public}s', JSON.stringify(err));
      }
    })
    // [End ArticleCitationsSetExtras]
    // [Start outputDeviceChangeAll]
    try {
      videoSession.on('outputDeviceChange', async (connectState: avSession.ConnectionState,
        device: avSession.OutputDeviceInfo) => {
        hilog.info(0x0000, TAG, `device ${JSON.stringify(device)}`);
        hilog.info(0x0000, TAG, `connectState ${JSON.stringify(connectState)}`);
        // The linked device is a remote device.
        if (device.devices[0].castCategory === avSession.AVCastCategory.CATEGORY_REMOTE &&
          connectState === avSession.ConnectionState.STATE_CONNECTED) {
          // Page jump
          this.remoteControlPathStack.replacePath({ name: 'detail', param: this.currentTime });
          this.castingList.push(this.videoType);
          await this.releaseAVPlayer();
          // The linked device is the local device.
        } else if (device.devices[0].castCategory === avSession.AVCastCategory.CATEGORY_REMOTE &&
          connectState === avSession.ConnectionState.STATE_DISCONNECTED) {
          if (this.avCastController) {
            await this.avCastController.releaseAVCast();
            await this.avSessionController!.stopCasting();
            this.avCastController = undefined;
          }
        } else if (device.devices[0].castCategory === avSession.AVCastCategory.CATEGORY_LOCAL) {
          this.remoteControlPathStack.clear();
          let videoType = this.castingList[0];
          this.castingList = [];
          let videoPlayParam = new VideoPlayParam(videoType, 0, this.avplayerContinueIndex);
          this.videoPlayPathStack.replacePath({ name: 'detail', param: videoPlayParam });
          if (this.avCastController) {
            await this.avCastController.releaseAVCast();
            await this.avSessionController!.stopCasting();
            this.avCastController = undefined;
          }
        }
      })
    } catch (error) {
      let err = error as BusinessError
      if (err.code) {
        hilog.error(0x0000, TAG, 'testTag', 'init AVCast picker failed, cause: %{public}s', JSON.stringify(err));
      }
    }
    // [End outputDeviceChangeAll]
  }

  // [EndExclude controller_callback]
  /**
   * Register the AVSession playback control callback.
   * Used to detect the connection of playback devices.
   * @param videoSession: The AV session to configure for casting.
   */
  getAVCastController(videoSession: avSession.AVSession) {
    // 如支持投播，可使用下面接口监听设备连接状态的变化
    videoSession.on('outputDeviceChange', async (connectState: avSession.ConnectionState,
      device: avSession.OutputDeviceInfo) => {
      // 可以通过当前设备及设备连接状态来更新应用内播放界面的显示
      let currentDevice: avSession.DeviceInfo = device?.devices?.[0];
      if (currentDevice.castCategory === avSession.AVCastCategory.CATEGORY_REMOTE &&
          connectState === avSession.ConnectionState.STATE_CONNECTED) { // 设备连接成功
        console.info(`Device connected: ${device}`);
        this.castController = await videoSession.getAVCastController();
        console.info('Succeeded in getting a cast controller');
        // 查询当前播放的状态
        let avPlaybackState = await this.castController?.getAVPlaybackState();
        console.info(`Succeeded in AVPlaybackState resource obtained: ${avPlaybackState}`);
        // 监听播放状态的变化
        this.castController?.on('playbackStateChange', 'all', (state: avSession.AVPlaybackState) => {
          console.info(`Succeeded in Playback state changed: ${state}`);
        });
        if (currentDevice.supportedProtocols === avSession.ProtocolType.TYPE_CAST_PLUS_STREAM) {
          // 此设备支持cast+投播协议
        } else if (currentDevice.supportedProtocols === avSession.ProtocolType.TYPE_DLNA) {
          // 此设备支持DLNA投播协议
        }
        // 此设备支持chinaDRM，监听许可证请求事件，也可在发起DRM资源投播前监听。
        if (currentDevice.supportedDrmCapabilities?.includes('3d5e6d35-9b9a-41e8-b843-dd3c6e72c42c')) {
          this.castController?.on('keyRequest', this.keyRequestCallback);
        }
      }
    })
  }

  // 处理DRM许可证请求事件
  private keyRequestCallback: avSession.KeyRequestCallback = async (assetId: string, requestData: Uint8Array) => {
    // 根据assetId获取对应的DRM url
    let drmUrl: string = 'https://www.examples.com';
    // 从服务器获取许可证，具体实现可参考附录。
    let licenseResponseData = await this.getLicense.getLicense(drmUrl, requestData);
    try {
      // 处理DRM许可证响应
      await this.castController?.processMediaKeyResponse(assetId, licenseResponseData);
    } catch (error) {
      console.error(`Failed to process the response corresponding to the media key. Error: ${error}`);
    }
  }

  // [StartExclude controller_callback]
  async releaseAVPlayer() {
    if (this.avPlayerController) {
      {
        await this.avPlayerController.releasePlayer();
        this.avPlayerController = undefined;
      }
    }
  }

  async releaseAVSession() {
    if (this.avSessionController) {
      await this.avSessionController.releaseAvSessionListener(uiContext?.getHostContext() as common.UIAbilityContext);
      this.avSessionController = undefined;
    }
  }

  async episodeChoose() {
    if (!this.castingList.includes(this.videoType)) {
      this.videoIndex = this.episodeChooseIndex;
      await this.releaseAVPlayer();
      await this.initAVPlayer();
    }
  }

  /**
   * Shows AV player controls temporarily.
   * Hides controls automatically after 2 seconds.
   */
  showAVPlayerController() {
    this.isShowAVPlayerController = true;
    clearTimeout(this.avPlayerControllerTimeID);
    this.avPlayerControllerTimeID = setTimeout(() => {
      this.isShowAVPlayerController = false;
    }, 2000);
  }

  nextVideo() {
    if (this.videoIndex < this.videoList.length - 1) {
      this.videoIndex += 1;
    } else {
      this.videoIndex = 0;
    }
    this.episodeChooseIndex = this.videoIndex;
  }

  /**
   * Load XComponent.
   */
  async onDidBuild() {
    await this.releaseAVPlayer();
    if(!this.castingList.includes(this.videoType)){
      await this.initAVPlayer();
    }
  }

  build() {
    RelativeContainer() {
      XComponent({
        id: 'player',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
        .width('100%')
        .height('100%')
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        Row() {
          Row() {
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontSize(24)
              .fontColor([Color.White])
          }
          .width(40)
          .height(40)
          .backgroundColor('rgba(255,255,255,0.1)')
          .borderRadius(20)
          .justifyContent(FlexAlign.Center)
          .onClick(async () => {
            await this.releaseAVPlayer();
            if (this.castingList.length === 0) {
              await this.releaseAVSession();
            }
            this.videoPlayPathStack.pop();
          })

          Blank()

          Row() {
            // [Start ArticleCitationsAVCastPicker]
            AVCastPicker({
              normalColor: Color.White,
              pickerStyle: AVCastPickerStyle.STYLE_PANEL,
              sessionType: 'video',
              // [StartExclude ArticleCitationsAVCastPicker]
              onStateChange: ((state: AVCastPickerState) => {
                if (state === AVCastPickerState.STATE_APPEARING) {
                  this.isShowAVPlayerController = true;
                  clearTimeout(this.avPlayerControllerTimeID);
                } else {
                  this.avPlayerControllerTimeID = setTimeout(() => {
                    this.isShowAVPlayerController = false;
                  }, 2000)
                }
              })
              // [EndExclude ArticleCitationsAVCastPicker]
            })
              // [End ArticleCitationsAVCastPicker]
              .width(24)
              .height(24)
          }
          .width(40)
          .height(40)
          .backgroundColor('rgba(255,255,255,0.1)')
          .borderRadius(20)
          .justifyContent(FlexAlign.Center)
          .visibility(this.castingList.length === 0 ? Visibility.Visible : Visibility.None)

          IconButton({ iconResource: $r('sys.symbol.wireless_projection') })
            .visibility(this.castingList.length !== 0 ? Visibility.Visible : Visibility.None)
            .onClick(async () => {
              this.avCastController?.releaseAVCast();
              this.avCastController = undefined;
              this.castingList[0] = this.videoType;
              await this.releaseAVPlayer();
              this.remoteControlPathStack.replacePath({ name: 'detail', param: this.currentTime });
            })
        }
        .width('100%')
        .padding({
          top: 8
        })
        .visibility(this.isShowAVPlayerController ? Visibility.Visible : Visibility.Hidden)
        .backgroundColor('rgba(0,0,0,0.05)')
        .padding({
          left: 16,
          right: 16
        })

        VolumeControllerView({
          volumeValue: this.volumeValue
        })
          .visibility(this.isShowVolumeController ? Visibility.Visible : Visibility.Hidden)
          .alignSelf(ItemAlign.Center)
        AVPlayerControllerView({
          currentTime: this.currentTime,
          durationTime: this.durationTime,
          isPlaying: this.isPlaying,
          isShowAVPlayerController: this.isShowAVPlayerController,
          avPlayerControllerTimeID: this.avPlayerControllerTimeID
        })
          .visibility(this.isShowAVPlayerController ? Visibility.Visible : Visibility.Hidden)
          .backgroundColor('rgba(0,0,0,0.05)')
          .padding({
            left: 16,
            right: 16
          })
      }
      .onClick(() => {
        this.showAVPlayerController();
      })
      .gesture(
        PanGesture()
          .onActionStart((event: GestureEvent | undefined) => {
            if (event!.velocityX < 10 && event!.velocityY != 0) {
              this.isShowVolumeController = true;
            }
            ;
          })
          .onActionUpdate((event: GestureEvent | undefined) => {
            if (!event || !this.avPlayerController) {
              return;
            }
            this.showAVPlayerController();
            if (event.velocityX < 10 && event.velocityY != 0) {
              this.isShowVolumeController = true;
              if (this.volumeValue - (event.velocityY / 1000) > 0 && this.volumeValue - (event.velocityY / 1000) < 1) {
                try {
                  this.avPlayerController.setAVPlayerVolume(this.volumeValue - (event!.velocityY / 10000));
                } catch (error) {
                  let err = error as BusinessError
                  if (err.code) {
                    hilog.error(0x0000, TAG, 'testTag', 'set AVPlayer Volume failed, cause: %{public}s', JSON.stringify(err));
                  }
                }
              }
            }
          })
          .onActionEnd(() => {
            setTimeout(() => {
              this.isShowVolumeController = false;
            }, 100)
          })
      )
    }
    .width('100%')
    .height(184)
    .backgroundColor(Color.Black)
  }
  // [EndExclude controller_callback]
}
// [End controller_callback]