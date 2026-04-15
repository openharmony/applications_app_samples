/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import DateTimeUtil from '../model/DateTimeUtil';
import Logger from '../model/Logger';
import { CameraHotplugLogger } from '../utils/CameraHotplugLogger';
import { CameraHotplugToast } from '../utils/CameraHotplugToast';
import cameraDemo from 'libentry.so';
import { image } from '@kit.ImageKit';
import { media } from '@kit.MediaKit';
import MediaUtils from '../model/MediaUtils';
import { deviceInfo } from '@kit.BasicServicesKit';
import { fileIo as fileio } from '@kit.CoreFileKit';
import { Constants, isHaveOpenedPhotoFrameKey, photoFrameMarkKey, SettingDataObj } from '../common/Constants';
import { common } from '@kit.AbilityKit';
// 当前版本未接入用户文件管理模块
import { camera } from '@kit.CameraKit';


import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ColorMetrics, display, LengthMetrics, promptAction, router } from '@kit.ArkUI';
import PreferenceUtil from '../utils/PreferenceUtil';
import { EventUtil } from '../utils/EventUtil';
import PreferenceUtils from '../utils/PreferencesManager';
import { fileIo as fs } from '@kit.CoreFileKit';
import { inputConsumer, KeyCode } from '@kit.InputKit';
import { floatWindowManager } from '../utils/FloatWindowManager';

interface UriResult {
  uri: string;
}

interface CameraSize {
  WIDTH: number,
  HEIGHT: number
};

interface PhotoSettings {
  quality: number, // Photo quality
  rotation: number, // Photo direction
  mirror: boolean, // Mirror Enable
  latitude: number, // geographic location
  longitude: number, // geographic location
  altitude: number // geographic location
};

interface PhotoRotationMap {
  rotation0: number,
  rotation90: number | string,
  rotation180: number,
  rotation270: number | string,
};

const imageReceiverTwoThousand = 2000;
const imageReceiverEight = 8;
const imageReceiverFour = 4;
const imageReceiverFortyEight = 2048;

@Component
export struct modeSwitchPage {
  @Link isVideo:boolean
  // 屏幕离左边与上面的距离
  @Link leftToTotal:number
  @Link upToTotal:number
  // 用于判断是否在录制过程中按返回停止录制
  @Link @Watch('handleCameraRecordClickBack')isCameraRecordingBack:boolean
  @State camerasList: camera.CameraDevice[] = []
  private cameraManager: camera.CameraManager = camera.getCameraManager(getContext(this));
  @State focusId: string = '4';
  private tag: string = 'sample modeSwitchPage:';
  private mediaUtil = MediaUtils.getInstance();
  private fileAsset?: UriResult;
  private fileAssetSecond?: UriResult;
  private fileAssetAll?: UriResult;
  private fd: number = -1;
  private fdSecond: number = -1;
  @State videoId: string = '';
  @State videoIdSecond: string = '';
  @State mSurfaceId: string = '';
  @State mSurfaceIdSecond: string = '';
  //是否双录相机
  @StorageLink('isDoubleRecord') isDoubleRecord: boolean = false;
  // 新增：是否多摄像头模式
  @StorageLink('isMultiCameraMode') isMultiCameraMode: boolean = false;
  @Link onShow: boolean
  private cameraSize: CameraSize = {
    WIDTH: 1280,
    HEIGHT: 720
  };
  private photoSettings: PhotoSettings = {
    quality: 0,
    rotation: 0,
    mirror: false,
    latitude: 12.9698,
    longitude: 77.7500,
    altitude: 1000
  };
  // 拉起悬浮窗并退出当前应用
  private launchFloatWindowAndExit() {
    try {
      let want:Want = {
        bundleName: 'com.samples.camera', // 替换为你的应用包名
        abilityName: 'FloatWindowAbility',
        parameters: {
          // 可以传递参数给悬浮窗Ability
        }
      };

      // 启动悬浮窗 Ability
      let context = getContext(this) as common.UIAbilityContext;
      // 将startServiceExtensionAbility替换为startUIServiceExtensionAbility
      context.startUIServiceExtensionAbility(want)
        .then(() => {
          console.info('启动悬浮窗Ability成功');
          // 延迟一段时间后关闭当前Ability，确保悬浮窗已经创建
          setTimeout(() => {
            context.terminateSelf()
              .then(() => {
                console.info('原Ability已关闭');
              })
              .catch((err: BusinessError) => {
                console.error('关闭原Ability失败: ' + JSON.stringify(err));
              });
          }, 0); // 增加延迟时间确保悬浮窗完全创建
        })
        .catch((err: BusinessError) => {
          console.error('启动悬浮窗Ability失败: ' + JSON.stringify(err));
        });
    } catch (error) {
      console.error('拉起悬浮窗异常: ' + JSON.stringify(error));
    }
  }
  //点击tab键触发聚焦
  tabClick() {
  }

  private mReceiver?: image.ImageReceiver;
  private mReceiverSecond?: image.ImageReceiver;
  private videoRecorder?: media.AVRecorder;
  private videoRecorderSecond?: media.AVRecorder;
  private avMetadata: media.AVMetadata = {}
  private videoConfig: media.AVRecorderConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
    videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
    profile: {
      audioBitrate: 48000,
      audioChannels: 2,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      audioSampleRate: 48000,
      fileFormat: media.ContainerFormatType.CFT_MPEG_4,
      videoBitrate: 512000,
      videoCodec: media.CodecMimeType.VIDEO_AVC,
      videoFrameWidth: 640,
      videoFrameHeight: 480,
      videoFrameRate: 30
    },
    url: '',
    rotation: 0
  };
  private videoConfigSecond: media.AVRecorderConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
    videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
    profile: {
      audioBitrate: 48000,
      audioChannels: 2,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      audioSampleRate: 48000,
      fileFormat: media.ContainerFormatType.CFT_MPEG_4,
      videoBitrate: 512000,
      videoCodec: media.CodecMimeType.VIDEO_AVC,
      videoFrameWidth: 640,
      videoFrameHeight: 480,
      videoFrameRate: 30
    },
    url: '',
    rotation: 0
  };
  private photoRotationMap: PhotoRotationMap = {
    rotation0: 0,
    rotation90: 90,
    rotation180: 180,
    rotation270: 270,
  };

  // 统一使用cameraId进行状态管理，移除索引相关变量
  @Link currentCameraId: string;
  @State secondCameraId: string = ''; // 用于双录模式的第二个相机
  @State callBackCameraId: string = '';
  @State isDeviceCb: boolean = false;

  // 相机ID变化监听器
  private onCurrentCameraIdChanged() {
    Logger.info(this.tag, `当前相机ID发生变化: ${this.currentCameraId}`);
    // 确保当前相机ID存储到AppStorage
    if (this.currentCameraId) {
      AppStorage.setOrCreate('cameraId', this.currentCameraId);
    }
  }

  // 新增：获取当前相机ID的方法
  private getCurrentCameraId(): string {
    // 1. 优先使用当前状态中的相机ID
    if (this.currentCameraId && this.currentCameraId.length > 0) {
      return this.currentCameraId;
    }

    // 2. 从AppStorage获取当前选中的相机ID
    let currentCameraId: string | undefined = AppStorage.get('cameraId');
    if (currentCameraId && currentCameraId.length > 0) {
      this.currentCameraId = currentCameraId;
      return currentCameraId;
    }

    // 3. 如果AppStorage中没有，获取相机列表并使用第一个相机的ID
    this.camerasList = this.cameraManager.getSupportedCameras();
    if (this.camerasList.length > 0) {
      currentCameraId = this.camerasList[0].cameraId;
      // 存储到状态和AppStorage
      this.currentCameraId = currentCameraId;
      AppStorage.setOrCreate('cameraId', currentCameraId);
      return currentCameraId;
    }

    // 4. 如果都没有，返回空字符串
    Logger.error(this.tag, 'getCurrentCameraId: 无法获取有效的相机ID');
    return '';
  }

  // 获取用于双录模式的第二个相机ID
  private getSecondCameraId(): string {
    this.camerasList = this.cameraManager.getSupportedCameras();
    if (this.camerasList.length > 1) {
      // 找到一个不同于当前相机的相机ID
      const secondCamera = this.camerasList.find(cam => cam.cameraId !== this.currentCameraId);
      if (secondCamera) {
        this.secondCameraId = secondCamera.cameraId;
        return secondCamera.cameraId;
      }
    }
    // 如果只有一个相机或找不到其他相机，返回当前相机ID
    this.secondCameraId = this.currentCameraId;
    return this.currentCameraId;
  }

  // 新增：根据索引获取相机ID的方法（用于向后兼容）
  private getCameraIdByIndex(index: number): string {
    this.camerasList = this.cameraManager.getSupportedCameras();
    if (this.camerasList.length > index && index >= 0) {
      return this.camerasList[index].cameraId;
    }
    Logger.error(this.tag, `getCameraIdByIndex: 索引${index}超出范围，相机总数: ${this.camerasList.length}`);
    return '';
  }

  // 新增：根据摄像头ID获取摄像头设备信息
  private getCameraDeviceById(cameraId: string): camera.CameraDevice | undefined {
    try {
      this.camerasList = this.cameraManager.getSupportedCameras();
      return this.camerasList.find(camera => camera.cameraId === cameraId);
    } catch (err) {
      Logger.error(this.tag, `getCameraDeviceById: 获取摄像头设备信息失败: ${JSON.stringify(err)}`);
      return undefined;
    }
  }
  // 处理多相机模式下，正在录制时按返回键中断录制视频
  handleCameraRecordClickBack(){
    if(this.isCameraRecordingBack){
      if (this.timer !== undefined) {
        clearInterval(this.timer);
      }
      // Stop video
      this.stopVideo().then(async (fileAsset: UriResult | undefined) => {
        this.videoRecodeTime = 0;
        this.isModeBol = true;
        try {
          await this.createVideoThumbnail(fileAsset);
          this.fileAssetAll = fileAsset;
          this.clickFocusBtn('5');
          promptAction.showToast({
            message: $r('app.string.videoSavedSuccessfully'),
            duration: 2000,
          });
        } catch (err) {
          Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
        }
      });
      this.isPause = false;
      // 最后重置录像中按返回的开关
      this.isCameraRecordingBack=false;
      this.isRecording=false;
    }
  }
  // 处理摄像头断开
  private handleCameraDisconnected(cameraId: string, cameraDevice?: camera.CameraDevice) {
    CameraHotplugLogger.logUserAction('ModeSwitchPage', 'HANDLE_DISCONNECT', cameraId, '开始处理摄像头断开');
    Logger.info(this.tag, `handleCameraDisconnected: 处理摄像头断开 ${cameraId}`);

    // 记录录像中断（如果正在录像）
    if (!this.isModeBol && this.timer !== undefined) {
      CameraHotplugToast.showRecordingInterrupted(cameraId, cameraDevice, '单路模式');
      CameraHotplugLogger.logUserAction('ModeSwitchPage', 'RECORDING_INTERRUPTED', cameraId, '录像因摄像头断开而中断');
    }

    // 停止当前录像
    this.onShow = false;
    if (this.timer !== undefined) {
      clearInterval(this.timer);
    }

    // 停止录像
    this.stopVideo().then(async (fileAsset: UriResult | undefined) => {
      this.videoRecodeTime = 0;
      this.isModeBol = true;
      try {
        await this.createVideoThumbnail(fileAsset);
        this.clickFocusBtn('5');
      } catch (err) {
        Logger.info(this.tag, 'camera js camerastatus videoThumbnail err----------:' + JSON.stringify(err.message));
        CameraHotplugLogger.logError('ModeSwitchPage', 'GET_THUMBNAIL', cameraId, err.message);
      }

      // 尝试切换到其他可用摄像头
      this.switchToAvailableCamera(cameraId, cameraDevice);
    });

    this.isPause = false;
    this.pauseVideoImage = $r('app.media.camera_goon_default');
  }

  // 处理摄像头重连
  private handleCameraReconnected(cameraId: string, cameraDevice?: camera.CameraDevice) {
    CameraHotplugLogger.logUserAction('ModeSwitchPage', 'HANDLE_RECONNECT', cameraId, '处理摄像头重新连接');
    Logger.info(this.tag, `handleCameraReconnected: 摄像头重新连接 ${cameraId}`);
    this.onShow = true;

    // 显示重连提示
    CameraHotplugToast.showCameraReconnected(cameraId, cameraDevice, '单路模式');

    // 重新初始化摄像头
    if (this.surfaceId) {
      CameraHotplugLogger.logCameraInitialized('ModeSwitchPage', cameraId, this.surfaceId, true);
      cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, cameraId,this.isVideo);
    }
  }

  // 处理新摄像头连接
  private handleNewCameraConnected(cameraId: string, cameraDevice?: camera.CameraDevice) {
    CameraHotplugLogger.logUserAction('ModeSwitchPage', 'HANDLE_NEW_CONNECT', cameraId, '处理新摄像头连接');
    Logger.info(
      this.tag,
      `handleNewCameraConnected: 新摄像头连接 ${cameraId}, 当前状态 - ` +
      `onShow: ${this.onShow}, currentCameraId: ${this.currentCameraId}`
    );

    // 检查当前是否处于无摄像头状态
    // 条件：1. 预览未显示 2. 当前摄像头ID为空或无效
    const isNoCameraState = !this.onShow && (!this.currentCameraId || this.currentCameraId === '');

    if (isNoCameraState) {
      Logger.info(this.tag, `handleNewCameraConnected: 检测到无摄像头状态，自动切换到新连接的摄像头: ${cameraId}`);

      // 更新当前摄像头ID
      this.currentCameraId = cameraId;
      AppStorage.setOrCreate('cameraId', this.currentCameraId);

      // 显示切换提示
      CameraHotplugToast.showCameraSwitched('', cameraId, cameraDevice, '单路模式');

      // 初始化摄像头
      setTimeout(() => {
        this.onShow = true;
        if (this.surfaceId) {
          CameraHotplugLogger.logCameraInitialized('ModeSwitchPage', this.currentCameraId, this.surfaceId, true);
          cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.currentCameraId,this.isVideo);
        }
      }, 500);
    } else {
      Logger.info(this.tag, `handleNewCameraConnected: 当前已有摄像头预览，显示新摄像头连接提示: ${cameraId}`);
      // 显示新摄像头连接提示
      CameraHotplugToast.showCameraConnected(cameraId, cameraDevice, '单路模式');
    }
  }

  // 切换到其他可用摄像头
  private switchToAvailableCamera(disconnectedCameraId: string, disconnectedCameraDevice?: camera.CameraDevice) {
    CameraHotplugLogger.logUserAction('ModeSwitchPage', 'SWITCH_CAMERA', disconnectedCameraId, '尝试切换到其他可用摄像头');
    Logger.info(this.tag, `switchToAvailableCamera: 尝试切换摄像头，断开的摄像头: ${disconnectedCameraId}`);

    // 更新摄像头列表
    const oldCount = this.camerasList.length;
    this.camerasList = this.cameraManager.getSupportedCameras();
    const newCount = this.camerasList.length;

    CameraHotplugLogger.logCameraListUpdated('ModeSwitchPage', oldCount, newCount,
      this.camerasList.map(cam => cam.cameraId));

    if (this.camerasList.length === 0) {
      // 没有可用摄像头
      Logger.info(this.tag, 'switchToAvailableCamera: 没有可用摄像头');
      this.showNoCameraMessage();
      return;
    }

    // 查找第一个可用的摄像头
    const availableCamera = this.camerasList.find(camera => camera.cameraId !== disconnectedCameraId);

    if (availableCamera) {
      CameraHotplugLogger.logCameraSwitched('ModeSwitchPage', disconnectedCameraId, availableCamera.cameraId, '自动切换');
      Logger.info(this.tag, `switchToAvailableCamera: 切换到摄像头 ${availableCamera.cameraId}`);

      // 更新当前摄像头ID
      this.currentCameraId = availableCamera.cameraId;
      AppStorage.setOrCreate('cameraId', this.currentCameraId);

      // 显示切换提示
      CameraHotplugToast.showCameraSwitched(disconnectedCameraId, availableCamera.cameraId, availableCamera, '单路模式');

      // 重新初始化摄像头
      setTimeout(() => {
        this.onShow = true;
        if (this.surfaceId) {
          CameraHotplugLogger.logCameraInitialized('ModeSwitchPage', this.currentCameraId, this.surfaceId, true);
          cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, this.currentCameraId,this.isVideo);
        }
      }, 500);
    } else {
      // 没有其他可用摄像头
      this.showNoCameraMessage();
    }
  }

  // 显示无摄像头消息
  private showNoCameraMessage() {
    CameraHotplugLogger.logUserAction('ModeSwitchPage', 'SHOW_NO_CAMERA', '', '显示无摄像头提示');
    Logger.info(this.tag, 'showNoCameraMessage: 显示无摄像头提示');

    // 清理摄像头状态
    this.onShow = false;
    this.currentCameraId = '';
    AppStorage.setOrCreate('cameraId', '');

    CameraHotplugToast.showNoCameraAvailable('单路模式');
  }

  // SurfaceID
  @Prop surfaceId: string;
  @Prop surfaceIdSecond: string;
  @Link cameraRotate: number;
  @Link photoMirror: boolean;
  // Countdown value
  @Link countdownNum: number;
  // Countdown timer
  @State countTimerInt: number = -1;
  @State countTimerOut: number = -1;
  // Photo Thumbnails
  @State imgThumbnail: string | image.PixelMap = '';
  // Recording time
  @Link videoRecodeTime: number;
  @Link videoRecodeTimeSecond: number;
  // Recording time timer
  @State timer: number = 0;
  @State timerSecond: number = 0;
  // Time Manager
  @State dateTimeUtil: DateTimeUtil = new DateTimeUtil();
  // Select mode
  @Link modelBagCol: string
  // Choose camera or capture
  @Link @Watch('onChangeIsModeBol') isModeBol: boolean
  // Video Thumbnails
  // private videoThumbnail?: image.PixelMap;
  @State videoThumbnail: image.PixelMap | undefined | null = undefined;
  //旋转
  @State rotateImage: ResourceStr = $r('app.media.camera_rotate_default');
  //拍照图片
  @State takePhotoImageFirst: ResourceStr = $r('app.media.camera_takephoto_default');
  //拍照图片
  @State takePhotoImageSecond: ResourceStr = $r('app.media.camera_takephoto_default');
  //相册图片
  @State albumImage: ResourceStr = $r('app.media.camera_album_default');
  //拍视频图片
  @State takeVideoImageFirst: ResourceStr = $r('app.media.camera_video_default');
  //拍视频图片
  @State takeVideoImageSecond: ResourceStr = $r('app.media.camera_video_default');
  //停止拍视频图片
  @State stopVideoImage: ResourceStr = $r('app.media.camera_stopvideo_default');
  //暂停拍视频图片
  @State pauseVideoImage: ResourceStr = $r('app.media.camera_goon_default');
  //停止拍视频图片
  @State stopVideoImageSecond: ResourceStr = $r('app.media.camera_stopvideo_default');
  //暂停拍视频图片
  @State pauseVideoImageSecond: ResourceStr = $r('app.media.camera_goon_default');
  //暂停状态
  @State isPause: boolean = false;
  @State isPauseSecond: boolean = false;
  //暂停播放是否聚焦状态
  @State isPauseFocus: boolean = false;
  @State isPauseFocusSecond: boolean = false;
  @State isTakingPhoto: boolean = false;
  @State isDevicePhotoFrist: boolean = false;
  @State isDevicePhotoSecond: boolean = false;
  @State isSwitchCamera: boolean = false;
  @Link isRecording: boolean
  @Link isRecordingSecond: boolean
  preferencePhoto: PreferenceUtils<string > = new PreferenceUtils<string>(getContext(this), '');
  @State videoUri:  string = '';
  @State focusStyle:  string = '';
  private settingDataObj: SettingDataObj = {
    mirrorBol: false,
    videoStabilizationMode: 0,
    exposureMode: 1,
    focusMode: 2,
    photoQuality: 1,
    locationBol: false,
    photoFormat: 1,
    photoOrientation: 0,
    photoResolution: 0,
    videoResolution: 0,
    videoFrame: 0,
    referenceLineBol: false
  };
  // 新增
  private context: common.Context = getContext(this);
  private context1 = this.getUIContext().getHostContext() as common.UIAbilityContext;

  getSupportedCamerasFn(): Boolean {
    return this.cameraManager!.getSupportedCameras().length >= 1;
  }

  getSupportedCamerasFns(): Boolean {
    return this.cameraManager!.getSupportedCameras().length >= 2;
  }

  // After pausing, click 'stop' to reset the pause to default
  onChangeIsModeBol() {
  }

  // Countdown capture and video
  countTakeVideoFn() {
    Logger.info(this.tag, `cheyang, getVideoSurfaceID videoRecorder1: ${this.countdownNum}`);
    if (this.countdownNum) {
      // Clear Countdown
      if (this.countTimerOut) {
        clearTimeout(this.countTimerOut);
      }
      if (this.countTimerInt) {
        clearInterval(this.countTimerInt);
      }
      // Turn on timer
      this.countTimerOut = setTimeout(() => {
        this.isVideoPhotoFn();
      }, this.countdownNum * 1000)
      // Turn on timer
      this.countTimerInt = setInterval(() => {
        this.countdownNum--;
        if (this.countdownNum === 0) {
          clearInterval(this.countTimerInt);
        }
      }, 1000)
    } else {
      switch (this.modelBagCol) {
        case 'photo':
          this.isVideoPhotoFn();
          break;
        case 'video':
          this.videoRecodeTime = 0; //初始化录像时间
          this.isVideoPhotoFn();
          break;
        default:
          promptAction.showToast({
            message: $r('app.string.reset_mode_error'),
            duration: 2000
          });
      }
    }
  }

  private async onRecordPaused(): Promise<void> {
    clearInterval(this.timer);
  }

  private async onRecordResumed(): Promise<void> {
    this.countTakeVideoFn();
  }

  async getVideoSurfaceID() {
    Logger.info(this.tag, `getVideoSurfaceID`);
    this.fileAsset = await this.mediaUtil.createAndGetUri(Constants.VIDEO) as UriResult;
    Logger.info(this.tag, `getVideoSurfaceID fileAsset: ${this.fileAsset}`);

    this.fd = await this.mediaUtil.getFdPath(this.fileAsset);
    Logger.info(this.tag, `getVideoSurfaceID fd: ${this.fd}`);

    this.videoConfig.url = `fd://${this.fd}`;
    Logger.info(this.tag, `getVideoSurfaceID videoConfig.url : ${this.videoConfig.url}`);

    if (deviceInfo.deviceType == 'default') {
      Logger.info(this.tag, `deviceType = default`);
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    if (deviceInfo.deviceType == 'phone') {
      Logger.info(this.tag, `deviceType = phone`);
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      this.videoConfig.profile.videoCodec = media.CodecMimeType.VIDEO_AVC;
      if (this.currentCameraId == this.secondCameraId) {
        this.avMetadata.videoOrientation = this.photoRotationMap.rotation270 as string;
      } else {
        this.avMetadata.videoOrientation = this.photoRotationMap.rotation90 as string;
      }
    }
    if (deviceInfo.deviceType == 'tablet') {
      Logger.info(this.tag, `deviceType = tablet`);
      this.videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    }

    //修复：使用相机ID而不是索引
    const cameraId = this.getCurrentCameraId();
    if (cameraId) {
      let resolutionStr = PreferenceUtil.getConfig('resolutionList', '') as string;
      if (resolutionStr.length) {
        let list = JSON.parse(resolutionStr) as string[];
        let videoIndex = PreferenceUtil.getConfig('videoResolution', 0) as number;
        let resolution = list[videoIndex];
        // 使用正则匹配所有数字
        let numbers = resolution.split('*');
        if (numbers && numbers.length >= 2) {
          this.videoConfig.profile.videoFrameWidth = parseInt(numbers[0]); // 1080
          this.videoConfig.profile.videoFrameHeight = parseInt(numbers[1]); // 720
        }
      }else {
        // 使用系统默认的
        this.videoConfig.profile.videoFrameWidth = cameraDemo.getVideoFrameWidth(cameraId);
        this.videoConfig.profile.videoFrameHeight = cameraDemo.getVideoFrameHeight(cameraId);
      }
      this.videoConfig.profile.videoFrameRate = cameraDemo.getVideoFrameRate(cameraId);
    }

    this.videoRecorder = await media.createAVRecorder();
    await this.videoRecorder.prepare(this.videoConfig);
    Logger.info(this.tag, `getVideoSurfaceID updateRotation: ${this.cameraRotate}`);
    await this.videoRecorder.updateRotation(this.cameraRotate);
    this.videoId = await this.videoRecorder.getInputSurface();
    Logger.info(this.tag, `getVideoSurfaceID videoId: ${this.videoId}`);
  }

  async getVideoSurfaceIDSecond() {
    this.videoRecorderSecond = await media.createAVRecorder();
    this.fileAssetSecond = await this.mediaUtil.createAndGetUri(Constants.VIDEO) as UriResult;
    this.fdSecond = await this.mediaUtil.getFdPath(this.fileAssetSecond);
    this.videoConfigSecond.url = `fd://${this.fdSecond}`;
    if (deviceInfo.deviceType == 'default') {
      Logger.info(this.tag, `deviceType = default`);
      this.videoConfigSecond.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    if (deviceInfo.deviceType == 'phone') {
      Logger.info(this.tag, `deviceType = phone`);
      this.videoConfigSecond.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      this.videoConfigSecond.profile.videoCodec = media.CodecMimeType.VIDEO_AVC;
      if (this.currentCameraId == this.secondCameraId) {
        this.avMetadata.videoOrientation = this.photoRotationMap.rotation270 as string;
      } else {
        this.avMetadata.videoOrientation = this.photoRotationMap.rotation90 as string;
      }
    }
    if (deviceInfo.deviceType == 'tablet') {
      Logger.info(this.tag, `deviceType = tablet`);
      this.videoConfigSecond.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    }

    //修复：使用相机ID而不是索引（恢复被注释的代码）
    const cameraId = this.getCameraIdByIndex(0); // 向后兼容，使用索引0
    if (cameraId) {
      let resolutionStr = PreferenceUtil.getConfig('resolutionList', '') as string;
      if (resolutionStr.length) {
        let list = JSON.parse(resolutionStr) as string[];
        let videoIndex = PreferenceUtil.getConfig('videoResolution', 0) as number;
        let resolution = list[videoIndex];
        // 使用正则匹配所有数字
        let numbers = resolution.split('*');
        if (numbers && numbers.length >= 2) {
          this.videoConfigSecond.profile.videoFrameWidth = parseInt(numbers[0]);
          this.videoConfigSecond.profile.videoFrameHeight = parseInt(numbers[1]);
        }
      } else {
        // 使用系统默认的
        this.videoConfigSecond.profile.videoFrameWidth = cameraDemo.getVideoFrameWidth(cameraId);
        this.videoConfigSecond.profile.videoFrameHeight = cameraDemo.getVideoFrameHeight(cameraId);
      }
      this.videoConfigSecond.profile.videoFrameRate = cameraDemo.getVideoFrameRate(cameraId);
    }

    await this.videoRecorderSecond.prepare(this.videoConfigSecond);
    this.videoIdSecond = await this.videoRecorderSecond.getInputSurface();
    Logger.info(this.tag, `getVideoSurfaceID videoIdsecond: ${this.videoIdSecond}`);
  }

  createImageReceiver() {
    try {
      let size: image.Size = {
        height: this.cameraSize.HEIGHT,
        width: this.cameraSize.WIDTH
      }
      this.mReceiver = image.createImageReceiver(size, 2000, 8);
      Logger.info(this.tag, `createImageReceiver value: ${this.mReceiver} `);
      this.mReceiver.on('imageArrival', () => {
        Logger.info(this.tag, 'imageArrival start');
        if (this.mReceiver) {
          this.mReceiver.readNextImage((err, image) => {
            Logger.info(this.tag, 'readNextImage start');
            if (err || image === undefined) {
              Logger.error(this.tag, 'readNextImage failed ');
              return;
            }
            image.getComponent(4, async (errMsg, img) => {
              Logger.info(this.tag, 'getComponent start');
              if (errMsg || img === undefined) {
                Logger.info(this.tag, 'getComponent failed ');
                return;
              }
              let buffer = new ArrayBuffer(2048);
              if (img.byteBuffer) {
                buffer = img.byteBuffer;
              } else {
                Logger.error(this.tag, 'img.byteBuffer is undefined');
              }
              this.savePicture(buffer, image);
            });
          });
        }
      });
    } catch {
      Logger.info(this.tag, 'savePicture err');
    }
  }

  createImageReceiverSecond() {
    try {
      let size: image.Size = {
        height: this.cameraSize.HEIGHT,
        width: this.cameraSize.WIDTH
      }
      this.mReceiverSecond = image.createImageReceiver(size, imageReceiverTwoThousand, imageReceiverEight);
      Logger.info(this.tag, `createImageReceiverSecond value: ${this.mReceiverSecond} `);
      this.mReceiverSecond.on('imageArrival', () => {
        Logger.info(this.tag, 'imageArrival start');
        if (this.mReceiverSecond) {
          this.mReceiverSecond.readNextImage((err, image) => {
            Logger.info(this.tag, 'readNextImage start');
            if (err || image === undefined) {
              Logger.error(this.tag, 'readNextImage failed ');
              return;
            }
            image.getComponent(imageReceiverFour, (errMsg, img) => {
              Logger.info(this.tag, 'getComponent start');
              if (errMsg || img === undefined) {
                Logger.info(this.tag, 'getComponent failed ');
                return;
              }
              let buffer = new ArrayBuffer(imageReceiverFortyEight);
              if (img.byteBuffer) {
                buffer = img.byteBuffer;
              } else {
                Logger.error(this.tag, 'img.byteBuffer is undefined');
              }
              this.savePicture(buffer, image);
            });
          });
        }
      });
    } catch {
      Logger.info(this.tag, 'savePicture err');
    }
  }

  // Read Image
  async savePicture(buffer: ArrayBuffer, img: image.Image) {
    try {
      Logger.info(this.tag, 'savePicture start', img);
      this.fileAsset = await this.mediaUtil.createAndGetUri(Constants.IMAGE) as UriResult;
      Logger.info(this.tag, `savePicture start1---- ${JSON.stringify(this.fileAsset)}`);
      let imgPhotoUri = this.fileAsset.uri;
      Logger.info(this.tag, `photoUri = ${imgPhotoUri}`);
      let imgFd: number = await this.mediaUtil.getFdPath(this.fileAsset);
      Logger.info(this.tag, `fd = ${imgFd}`);
      await fileio.write(imgFd, buffer);
      await img.release();
      Logger.info(this.tag, 'save image End');
      if (this.handleTakePicture) {
        this.handleTakePicture(imgPhotoUri);
      }
    } catch (err) {
      Logger.info(this.tag, 'savePicture err' + JSON.stringify(err.message));
    }
  }

  async getPhotoSurfaceID() {
    if (this.mReceiver) {
      Logger.info(this.tag, 'imageReceiver has been created');
    } else {
      this.createImageReceiver();
    }
    if (this.mReceiver) {
      this.mSurfaceId = await this.mReceiver.getReceivingSurfaceId();
    }
    if (this.mSurfaceId) {
      Logger.info(this.tag, `createImageReceiver mSurfaceId: ${this.mSurfaceId} `);
    } else {
      Logger.info(this.tag, `Get mSurfaceId failed `);
    }
  }

  async getPhotoSurfaceIDSecond() {
    if (this.mReceiverSecond) {
      Logger.info(this.tag, 'mReceiverSecond has been created');
    } else {
      this.createImageReceiverSecond();
    }
    if (this.mReceiverSecond) {
      this.mSurfaceIdSecond = await this.mReceiverSecond.getReceivingSurfaceId();
    }
    if (this.mSurfaceIdSecond) {
      Logger.info(this.tag, `createImageReceiver mSurfaceIdSecond: ${this.mSurfaceId} `);
    } else {
      Logger.info(this.tag, `Get mSurfaceId failed `);
    }
  }

  // Determine the video or photo mode
  async isVideoPhotoFn() {
    Logger.info(this.tag, `cheyang,createImageReceiver mSurfaceId4: ${this.modelBagCol} `);
    if (this.modelBagCol == 'photo') {
      await this.getPhotoSurfaceID();
      await this.getPhotoSurfaceIDSecond();
      Logger.info(
        this.tag,
        `createImageReceiver mSurfaceId4: ${this.modelBagCol}--${this.modelBagCol}--` +
        `${this.mSurfaceId}--${this.mSurfaceIdSecond} `
      );
      if (this.getSupportedCamerasFn()) {
        Logger.info(this.tag, `cheyang, cur: ${this.currentCameraId }---${this.secondCameraId } `);
        if (this.currentCameraId != this.secondCameraId) {
          Logger.info(this.tag, `cheyang, use one: ${this.currentCameraId }--- `);
          //modify by cy for new camera - 恢复并使用相机ID
          if (this.currentCameraId) {
            this.setPhotoSettings(this.currentCameraId);
            cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId, this.currentCameraId);
            setTimeout(() => {
              this.clickFocusBtn('8');
            }, 500)
            console.log('===focus-1-===');
          }
        } else {
          // 双录模式下，使用第二个相机ID
          Logger.info(this.tag, `cheyang, use second: ---${this.secondCameraId } `);
          if (this.secondCameraId) {
            this.setPhotoSettings(this.currentCameraId);
            cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceIdSecond, this.secondCameraId);
            this.clickFocusBtn('8');
            console.log('===focus-2-===');
          }
        }

      }
    } else if (this.modelBagCol == 'video') {
      if (!this.isDoubleRecord) {
        this.isModeBol = false;
      }
      // Start record
      if (this.getSupportedCamerasFn()) {
        Logger.info(this.tag, `cheyang,record : ${this.currentCameraId }---${this.secondCameraId }`);
        if (this.currentCameraId != this.secondCameraId) {
          if (this.timer !== undefined) {
            clearInterval(this.timer);
          }
          await this.getVideoSurfaceID();
          this.timer = setInterval(() => {
            this.videoRecodeTime += 1000;
          }, 1000);
          //modify by cy for new camera - 恢复并使用相机ID
          const cameraId = this.getCurrentCameraId();
          Logger.info(this.tag, `cheyang,use one cameraId : ${cameraId }---`);
          if (cameraId) {
            cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId, cameraId);
            cameraDemo.videoOutputStart(cameraId, this.photoMirror);
            this.videoRecorder?.start();
            setTimeout(() => {
              this.tabClick();
            }, 200)
            console.log('===focus-3-===');
          }
        } else {
          if (this.timer !== undefined) {
            clearInterval(this.timer);
          }
          await this.getVideoSurfaceID();
          this.timer = setInterval(() => {
            this.videoRecodeTime += 1000;
          }, 1000);
          //modify by cy for new camera - 恢复并使用相机ID
          const cameraId = this.getCurrentCameraId();
          Logger.info(this.tag, `cheyang,use one cameraId : ${cameraId }---`);
          if (cameraId) {
            cameraDemo.startPhotoOrVideo(this.modelBagCol, this.videoId, this.mSurfaceId, cameraId);
            cameraDemo.videoOutputStart(cameraId, this.photoMirror);
            this.videoRecorder?.start();
            setTimeout(() => {
              this.tabClick();
            }, 200)
            console.log('===focus-3-===');
          }
        }
      }
    }
  }

  setPhotoSettings(currentCameraId:string){
    this.photoSettings.rotation = this.cameraRotate;
    this.photoSettings.mirror = this.photoMirror;
    Logger.info(
      this.tag,
      `setPhotoSettings: ${JSON.stringify(this.photoSettings)}, currentCameraId :${currentCameraId}`
    );
    cameraDemo.setPhotoSettings(this.photoSettings,currentCameraId);
  }


  aboutToAppear() {
    let focusId = AppStorage.get<string>('focusId') || '4';
    focusControl.requestFocus(focusId);

    // 初始化时确保当前相机ID有效
    if (!this.currentCameraId) {
      this.currentCameraId = this.getCurrentCameraId();
    }

    // 初始化第二个相机ID（用于双录模式）
    this.secondCameraId = this.getSecondCameraId();

    Logger.info(this.tag, `ModeSwitchPage初始化，使用相机ID: ${this.currentCameraId}, 第二相机ID: ${this.secondCameraId}`);

    // 检查初始状态，如果没有可用摄像头，设置为无摄像头状态
    if (!this.currentCameraId || this.currentCameraId === '') {
      Logger.info(this.tag, 'ModeSwitchPage初始化：检测到无可用摄像头，设置为无摄像头状态');
      this.showNoCameraMessage();
    }

    cameraDemo.cameraStatusCallBack((cameraId, deviceStatus) => {
      // 获取摄像头设备信息
      const cameraDevice = this.getCameraDeviceById(cameraId);

      // 检查断开的摄像头是否是当前正在使用的摄像头
      const isCurrentCamera = cameraId === this.currentCameraId;
      const isSecondCamera = this.isDoubleRecord && cameraId === this.secondCameraId;
      const isActiveCamera = isCurrentCamera || isSecondCamera;

      // 记录状态变化日志
      const statusText = deviceStatus.toString() == '1' ? 'DISCONNECTED' : 'CONNECTED';
      CameraHotplugLogger.logCameraStatusChange('ModeSwitchPage', cameraId, 'UNKNOWN', statusText);

      Logger.info(
        this.tag,
        `camera js camerastatus - 摄像头: ${cameraId}, 状态: ${deviceStatus}, ` +
        `当前摄像头: ${this.currentCameraId}, 第二摄像头: ${this.secondCameraId}, ` +
        `是否影响当前使用: ${isActiveCamera}`
      );

      // 相机不可用
      this.callBackCameraId = cameraId;
      this.isDeviceCb = true;

      if (deviceStatus.toString() == '1') {
        // 摄像头断开处理
        CameraHotplugLogger.logCameraDisconnected('ModeSwitchPage', cameraId, cameraDevice);

        if (isActiveCamera) {
          Logger.info(this.tag, 'camera js camerastatus - 当前使用的摄像头断开，开始处理切换逻辑');
          this.handleCameraDisconnected(cameraId, cameraDevice);
        } else {
          Logger.info(this.tag, `camera js camerastatus - 非当前使用的摄像头断开，忽略: ${cameraId}`);
          // 显示非活跃摄像头断开提示
          CameraHotplugToast.showCameraDisconnected(cameraId, cameraDevice, '单路模式');
        }
      } else if (deviceStatus.toString() == '0') {
        // 摄像头连接处理
        CameraHotplugLogger.logCameraConnected('ModeSwitchPage', cameraId, cameraDevice);

        if (isActiveCamera) {
          Logger.info(this.tag, `camera js camerastatus - 当前使用的摄像头重新连接: ${cameraId}`);
          this.handleCameraReconnected(cameraId, cameraDevice);
        } else {
          Logger.info(this.tag, `camera js camerastatus - 新摄像头连接: ${cameraId}`);
          this.handleNewCameraConnected(cameraId, cameraDevice);
        }
      }

      this.isDeviceCb = false;
    });

    this.getUIContext().getFocusController().activate(true, false);

    this.imgThumbnail = this.preferencePhoto.getPreValue('imgThumbnail');
    this.videoUri = this.preferencePhoto.getPreValue('videoThumbnail');
    if (this.videoUri) {
      this.getFetchFrameByTime(this.preferencePhoto.getPreValue('videoThumbnail'));
    }
  }

  async getFetchFrameByTime(url: string) {
    // 创建AVImageGenerator对象
    let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator();
    // 设置fdSrc
    // let fd = await fileAsset.open("r")
    let file = fs.openSync(url, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    avImageGenerator.fdSrc = {
      fd: file.fd
    }
    // 初始化入参
    let timeUs = 0;
    let queryOption = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC;
    let param: media.PixelMapParams = {
      width: 100,
      height: 100
    }
    // 获取缩略图（promise模式）
    try {
      this.videoThumbnail = await avImageGenerator.fetchFrameByTime(timeUs, queryOption, param);
    } catch (err) {
    }
    // 释放资源（promise模式）
    avImageGenerator.release();
  }

  //判断是否安装此软件
  isAppInstalled(): boolean {
    try {
      return true;
    } catch (errData) {
      let code = (errData as BusinessError).code;
      let message = (errData as BusinessError).message;
      console.error(`errData is errCode:${code}  message:${message}`);
    }
    return false;
  }

  aboutToDisappear(): void {
    this.getUIContext().getFocusController().activate(false);
    try {
      AppStorage.setOrCreate<string>('focusId', this.focusId);
      this.preferencePhoto.setPreValue('imgThumbnail', this.imgThumbnail as string);
      this.preferencePhoto.setPreValue('videoThumbnail', this.fileAssetAll?.uri as string);
    } catch (e) {
      console.error(this.tag,  'aboutToDisappear err:' + JSON.stringify(e));
    }
  }

  handleTakePicture = (thumbnail: string) => {
    this.imgThumbnail = thumbnail;
    this.isTakingPhoto = false;
  }

  clickFocusBtn(id: string) {
    this.focusId = id;
    AppStorage.setOrCreate<string>('focusId', id);
    focusControl.requestFocus(id);
  }

  async stopVideoAll() {
    if (this.isRecording) {
      if (this.timer !== undefined) {
        clearInterval(this.timer);
      }
      this.isRecording = false;
      // Stop video
      try {
        let fileAsset = await this.stopVideo();
        this.videoRecodeTime = 0;
        if (!this.isDoubleRecord) {
          this.isModeBol = true;
        }
        await this.createVideoThumbnail(fileAsset);
        this.fileAssetAll = fileAsset;
        this.clickFocusBtn('15');
        promptAction.showToast({
          message: $r('app.string.videoSavedSuccessfully'),
          duration: 2000,
        });
      } catch (err) {
        Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
      }
    }
    if (this.isRecordingSecond) {
      if (this.timerSecond !== undefined) {
        clearInterval(this.timerSecond);
      }
      this.isRecordingSecond = false;
      try {
        let fileAsset = await this.stopVideoSecond();
        this.videoRecodeTimeSecond = 0;
        await this.createVideoThumbnail(fileAsset);
        this.fileAssetAll = fileAsset;
        this.clickFocusBtn('16');
        promptAction.showToast({
          message: $r('app.string.videoSavedSuccessfully'),
          duration: 2000,
        });
      } catch (err) {
        Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
      }
    }
  }

  build() {
    Column({ space: 24 }) {
      Row() {
        Stack() {
          // 添加遮罩层
          Row()
            .width(floatWindowManager.windowInstance?'190lpx':'109lpx')
            .height(floatWindowManager.windowInstance?'90lpx':'60lpx')
            .borderRadius(floatWindowManager.windowInstance?'45lpx':'30lpx')
            .backgroundColor( this.focusStyle == 'photo'?'rgba(0, 0, 0, 0.9)':'rgba(0, 0, 0, 0.6)')
            .margin({
              right: '111lpx'
            });
          Text($r('app.string.takePhotos'))
            .fontSize(floatWindowManager.windowInstance?'70lpx':'36lpx')
            .fontColor(this.focusStyle == 'photo' ? $r('app.color.white') : $r('app.color.white_transparent'))
            .textAlign(TextAlign.Center)
            .margin({
              right: '111lpx'
            })
            .id('0')
            .focusable(true)
            .focusBox({
              margin: LengthMetrics.px(2),
              strokeColor: ColorMetrics.resourceColor(Color.White),
              strokeWidth: LengthMetrics.px(0)
            })
            .onFocus(() => {
              this.focusStyle = 'photo';
            })
            .onBlur(() => {
              this.focusStyle = '';
            })
            .onHover(() => {
              this.clickFocusBtn('0');
              this.focusStyle = 'photo';
            })
            .onClick(async () => {
              // 如果是由于录像页面导致的关闭相框，就打开相框
              if ((PreferenceUtil.getConfig(isHaveOpenedPhotoFrameKey, false) as boolean) &&
                !(PreferenceUtil.getConfig(photoFrameMarkKey, false) as boolean)) {
                AppStorage.setOrCreate('cameraWaterFrameSwitch', true);
                PreferenceUtil.saveConfig(photoFrameMarkKey, true);
                PreferenceUtil.saveConfig(isHaveOpenedPhotoFrameKey, false);
                PreferenceUtil.saveConfig(isHaveOpenedPhotoFrameKey, true);
              }
              this.modelBagCol = 'photo';
              await this.stopVideoAll();
              this.clickFocusBtn('0');
              if (this.getSupportedCamerasFn()) {
                if (this.isDoubleRecord) {
                  //modify by cy for new camera - 恢复并使用相机ID
                  const cameraId0 = this.getCameraIdByIndex(0);
                  const cameraId1 = this.getCameraIdByIndex(1);
                  if (cameraId0) {
                    cameraDemo.releaseSession(cameraId0);
                    cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, cameraId0,this.isVideo);
                  }
                  if (cameraId1) {
                    cameraDemo.releaseSession(cameraId1);
                    cameraDemo.initCamera(this.surfaceIdSecond, this.settingDataObj.focusMode, cameraId1,this.isVideo);
                  }
                } else {
                  //modify by cy for new camera - 恢复并使用相机ID
                  const cameraId = this.getCurrentCameraId();
                  if (cameraId) {
                    cameraDemo.releaseSession(cameraId);
                    Logger.info(this.tag,
                      'takePhoto 111  current cameraId----------:' + JSON.stringify(cameraId));
                    cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, cameraId,this.isVideo);
                  }
                }
              }
            });
        }
        .alignContent(Alignment.Center)
        Stack() {
          // 添加遮罩层
          Row()
            .width(floatWindowManager.windowInstance?'190lpx':'109lpx')
            .height(floatWindowManager.windowInstance?'90lpx':'60lpx')
            .borderRadius(floatWindowManager.windowInstance?'45lpx':'30lpx')
            .backgroundColor( this.focusStyle == 'video'?'rgba(0, 0, 0, 0.9)':'rgba(0, 0, 0, 0.6)')
            .margin({
              right: '111lpx'
            });
          Text($r('app.string.takeVideo'))
            .fontSize(floatWindowManager.windowInstance?'70lpx':'36lpx')
            .fontColor(this.focusStyle == 'video' ? $r('app.color.white') : $r('app.color.white_transparent'))
            .textAlign(TextAlign.Center)
            .id('1')
            .focusable(true)
            .focusBox({
              margin: LengthMetrics.px(2),
              strokeColor: ColorMetrics.resourceColor(Color.White),
              strokeWidth: LengthMetrics.px(0)
            })
            .margin({
              right: '111lpx'
            })
            .onFocus(() => {
              this.focusStyle = 'video';
            })
            .onBlur(() => {
              this.focusStyle = '';
            })
            .onHover(() => {
              this.clickFocusBtn('1');
              this.focusStyle = 'video';
            })
            .onClick(() => {
              this.modelBagCol = 'video';
              this.clickFocusBtn('1');
              if (this.getSupportedCamerasFn()) {
                if (this.isDoubleRecord) {
                  //modify by cy for new camera - 恢复并使用相机ID
                  const cameraId0 = this.getCameraIdByIndex(0);
                  const cameraId1 = this.getCameraIdByIndex(1);
                  if (cameraId0) {
                    cameraDemo.releaseSession(cameraId0);
                    cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, cameraId0,this.isVideo);
                  }
                  if (cameraId1) {
                    cameraDemo.releaseSession(cameraId1);
                    cameraDemo.initCamera(this.surfaceIdSecond, this.settingDataObj.focusMode, cameraId1,this.isVideo);
                  }
                } else {
                  //modify by cy for new camera - 恢复并使用相机ID
                  const cameraId = this.getCurrentCameraId();
                  if (cameraId) {
                    cameraDemo.releaseSession(cameraId);
                    Logger.info(this.tag,
                      'takevideo 111  current cameraId----------:' + JSON.stringify(cameraId));
                    cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, cameraId,this.isVideo);
                  }
                }
              }
              // 关闭相框
              if (PreferenceUtil.getConfig(photoFrameMarkKey, false) as boolean) {
                AppStorage.setOrCreate('cameraWaterFrameSwitch', false);
                PreferenceUtil.saveConfig(isHaveOpenedPhotoFrameKey, false);
                PreferenceUtil.saveConfig(photoFrameMarkKey, false);
                PreferenceUtil.saveConfig(isHaveOpenedPhotoFrameKey, true);
              }
            });

        }
        .alignContent(Alignment.Center)
        Stack() {
          // 添加遮罩层
          Row()
            .width(floatWindowManager.windowInstance?'250lpx':'129lpx')
            .height(floatWindowManager.windowInstance?'90lpx':'60lpx')
            .borderRadius(floatWindowManager.windowInstance?'45lpx':'30lpx')
            .backgroundColor( this.focusStyle == 'distribute'?'rgba(0, 0, 0, 0.9)':'rgba(0, 0, 0, 0.6)')
          Text($r('app.string.distribute'))
            .fontSize(floatWindowManager.windowInstance?'70lpx':'36lpx')
            .textAlign(TextAlign.Center)
            .fontColor(this.focusStyle == 'distribute' ? $r('app.color.white') : $r('app.color.white_transparent'))
            .id('10')
            .focusable(true)
            .focusBox({
              margin: LengthMetrics.px(2),
              strokeColor: ColorMetrics.resourceColor(Color.White),
              strokeWidth: LengthMetrics.px(0)
            })
            .onFocus(() => {
              this.focusStyle = 'distribute';
            })
            .onBlur(() => {
              this.focusStyle = '';
            })
            .onHover(() => {
              this.clickFocusBtn('10');
              this.focusStyle = 'distribute';
            })
            .onClick(() => {
              this.clickFocusBtn('10');
              //分布式代码
              router.pushUrl({
                url: 'pages/DeviceMangerPage'
              });
            })
            .onKeyEvent((e)=>{
              if(floatWindowManager.windowInstance){
                if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                  if(this.leftToTotal<floatWindowManager.displayWidth-floatWindowManager.windowWidth){
                    console.log('执行了',this.leftToTotal+'   '+floatWindowManager.displayWidth);
                    console.log('执行了',this.leftToTotal+'   '+floatWindowManager.windowWidth);
                    this.leftToTotal+=floatWindowManager.movingStepSize;
                    floatWindowManager.moveTo(this.leftToTotal, this.upToTotal);
                  }
                }
              }

            });
        }
        .alignContent(Alignment.Center)
        Stack() {
          // 添加遮罩层
          Row()
            .width(floatWindowManager.windowInstance?'250lpx':'129lpx')
            .height(floatWindowManager.windowInstance?'90lpx':'60lpx')
            .borderRadius(floatWindowManager.windowInstance?'45lpx':'30lpx')
            .margin({left:'111lpx'})
            .backgroundColor( this.focusStyle == 'flowWindow'?'rgba(0, 0, 0, 0.9)':'rgba(0, 0, 0, 0.6)')
          Text('悬浮窗')
            .fontSize(floatWindowManager.windowInstance?'70lpx':'36lpx')
            .textAlign(TextAlign.Center)
            .fontColor(this.focusStyle == 'flowWindow' ? $r('app.color.white') : $r('app.color.white_transparent'))
            .id('11')
            .focusable(true)
            .margin({left:'111lpx'})
            .focusBox({
              margin: LengthMetrics.px(2),
              strokeColor: ColorMetrics.resourceColor(Color.White),
              strokeWidth: LengthMetrics.px(0)
            })
            .onFocus(() => {
              this.focusStyle = 'flowWindow';
            })
            .onBlur(() => {
              this.focusStyle = '';
            })
            .onHover(() => {
              this.clickFocusBtn('11');
              this.focusStyle = 'flowWindow';
            })
            .onClick(() => {
              this.clickFocusBtn('11');

              this.launchFloatWindowAndExit();
            });
        }
        .alignContent(Alignment.Center)
        .visibility(floatWindowManager.windowInstance? Visibility.None : Visibility.Visible)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .visibility(this.isModeBol ? Visibility.Visible : Visibility.None)
      .height('76lpx')

      Row() {
        if (this.isDoubleRecord) {
          Column() {
            if (this.modelBagCol === 'photo' && !this.isRecording) {
              Image(this.takePhotoImageFirst)
                .width('96lpx')
                .height('96lpx')
                .id('12')
                .focusable(true)
                .focusBox({
                  margin: LengthMetrics.px(5),
                  strokeColor: ColorMetrics.resourceColor(Color.White),
                  strokeWidth: LengthMetrics.px(0)
                })
                .onFocus(() => {
                  this.takePhotoImageFirst = $r('app.media.camera_takephoto_focus');
                })
                .onBlur(() => {
                  this.takePhotoImageFirst = $r('app.media.camera_takephoto_default');
                })
                .onClick(() => {
                  Logger.info(this.tag, `cheyang ,拍照使用相机ID: ${this.currentCameraId}`);
                  if (this.isTakingPhoto) {
                    promptAction.showToast({
                      message: $r('app.string.takingPhotos'),
                      duration: 1000,
                    });
                    return;
                  }
                  this.isTakingPhoto = true;
                  this.clickFocusBtn('12');
                  if (this.getSupportedCamerasFn()) {
                    this.modelBagCol = 'photo';
                    // 使用正确的相机ID，而不是硬编码为0
                    Logger.info(this.tag, `拍照使用相机ID: ${this.currentCameraId}`);
                    this.countTakeVideoFn();
                  } else {
                    promptAction.showToast({
                      message: $r('app.string.pleaseConnectCamera'),
                      duration: 2000,
                    });
                  }
                });
            } else if (this.modelBagCol === 'video' && !this.isRecording) {
              Image(this.takeVideoImageFirst)
                .width('96lpx')
                .height('96lpx')
                .id('13')
                .onFocus(() => {
                  this.takeVideoImageFirst = $r('app.media.camera_video_focus');
                })
                .onBlur(() => {
                  this.takeVideoImageFirst = $r('app.media.camera_video_default');
                })
                .focusable(true)
                .focusBox({
                  margin: LengthMetrics.px(5),
                  strokeColor: ColorMetrics.resourceColor(Color.White),
                  strokeWidth: LengthMetrics.px(0)
                })
                .onClick((e) => {
                  Logger.info(this.tag, `cheyang ,录像使用相机ID: ${this.currentCameraId}`);
                  if (this.getSupportedCamerasFn()) {
                    // 使用正确的相机ID，而不是硬编码为0
                    Logger.info(this.tag, `录像使用相机ID: ${this.currentCameraId}`);
                    this.modelBagCol = 'video';
                    this.isRecording = true;
                    this.countTakeVideoFn();
                    this.clickFocusBtn('15');
                  } else {
                    promptAction.showToast({
                      message: $r('app.string.pleaseConnectCamera'),
                      duration: 2000,
                    });
                  }
                });
            } else {
              Column() {
                Image(this.stopVideoImage)
                  .width('96lpx')
                  .height('96lpx')
                  .borderRadius(50)
                  .id('15')
                  .focusable(true)
                  .onFocus(() => {
                    this.stopVideoImage = $r('app.media.camera_stopvideo_focus');
                  })
                  .onBlur(() => {
                    this.stopVideoImage = $r('app.media.camera_stopvideo_default');
                  })
                  .focusBox({
                    margin: LengthMetrics.px(5),
                    strokeColor: ColorMetrics.resourceColor(Color.White),
                    strokeWidth: LengthMetrics.px(2)
                  })
                  .onClick(async () => {
                    if (this.isRecording) {
                      if (this.timer !== undefined) {
                        clearInterval(this.timer);
                      }
                      this.isRecording = false;
                      // Stop video
                      this.stopVideo().then(async (fileAsset: UriResult | undefined) => {
                        this.videoRecodeTime = 0;
                        if (!this.isDoubleRecord) {
                          this.isModeBol = true;
                        }
                        try {
                          await this.createVideoThumbnail(fileAsset);
                          this.fileAssetAll = fileAsset;
                          this.clickFocusBtn('15');
                          promptAction.showToast({
                            message: $r('app.string.videoSavedSuccessfully'),
                            duration: 2000,
                          });
                        } catch (err) {
                          Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
                        }
                      });
                    }
                  });
              }
            }
          }
        }

        Column() {
          if (this.modelBagCol === 'photo') {
            Image(this.imgThumbnail || this.albumImage)
              .objectFit(ImageFit.Fill)
              .width('92lpx')
              .height('92lpx')
              .borderRadius(this.imgThumbnail ? '46lpx' : 0)
              .id('2')
              .onFocus(() => {
                this.albumImage = $r('app.media.camera_album_focus');
              })
              .onBlur(() => {
                this.albumImage = $r('app.media.camera_album_default');
              })
              .focusBox({
                margin: LengthMetrics.lpx(2),
                strokeColor: ColorMetrics.resourceColor(Color.White),
                strokeWidth: LengthMetrics.lpx(this.imgThumbnail ? 3: 0)
              })
              .onHover(() => {
                this.clickFocusBtn('2');
              })
              .focusable(true)
              .onKeyEvent((e)=>{
                if(floatWindowManager.windowInstance){
                  if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                    if(this.upToTotal<floatWindowManager.displayHeight-floatWindowManager.windowHeight){
                      console.log('执行了',this.leftToTotal+'   '+floatWindowManager.displayWidth);
                      this.upToTotal+=floatWindowManager.movingStepSize;
                      floatWindowManager.moveTo(this.leftToTotal, this.upToTotal);
                    }
                  }
                }
              });
          } else {
            Image(this.videoThumbnail || this.albumImage)
              .objectFit(ImageFit.Fill)
              .width('92lpx')
              .height('92lpx')
              .borderRadius(this.imgThumbnail ? '46lpx' : 0)
              .id('3')
              .focusable(true)
              .onFocus(() => {
                this.albumImage = $r('app.media.camera_album_focus');
              })
              .onBlur(() => {
                this.albumImage = $r('app.media.camera_album_default');
              })
              .onHover(() => {
                this.clickFocusBtn('3');
              })
              .focusBox({
                margin: LengthMetrics.lpx(2),
                strokeColor: ColorMetrics.resourceColor(Color.White),
                strokeWidth: LengthMetrics.lpx(this.imgThumbnail ? 3: 0)
              });
          }
        }.onClick(async () => {
          if (this.modelBagCol === 'photo' ? !this.imgThumbnail : (!this.fileAssetAll?.uri && !this.videoUri)) {
            promptAction.showToast({
              message: $r('app.string.noPhoto'),
              duration: 1000,
            });
            return
          }
          await this.stopVideoAll();
          if (this.modelBagCol === 'photo') {
            this.clickFocusBtn('2');
          } else {
            this.clickFocusBtn('3');
          }
          if (this.isAppInstalled()) {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            context.startAbility({
              bundleName: 'com.samples.album',
              abilityName: 'MainAbility',
              parameters: {
                uri: this.modelBagCol === 'photo' ? this.imgThumbnail : (this.fileAssetAll?.uri) ?
                  this.fileAssetAll.uri : this.videoUri,
                type: this.modelBagCol
              }
            });
          } else {
            promptAction.showToast({
              message: $r('app.string.uninstallPhotos'),
              duration: 2000,
            });
          }
        });

        Column() {
          if (this.modelBagCol === 'photo' && !this.isRecordingSecond) {
            Image(this.takePhotoImageSecond)
              .width('96lpx')
              .height('96lpx')
              .id('4')
              .focusable(true)
              .focusBox({
                margin: LengthMetrics.px(5),
                strokeColor: ColorMetrics.resourceColor(Color.White),
                strokeWidth: LengthMetrics.px(0)
              })
              .onFocus(() => {
                this.takePhotoImageSecond = $r('app.media.camera_takephoto_focus');
              })
              .onBlur(() => {
                this.takePhotoImageSecond = $r('app.media.camera_takephoto_default');
              })
              .onHover(() => {
                this.clickFocusBtn('4');
              })
              .defaultFocus(true)
              .onClick(() => {
                Logger.info(this.tag, `cheyang ,sec使用相机ID: ${this.currentCameraId}`);
                if (this.isTakingPhoto) {
                  promptAction.showToast({
                    message: $r('app.string.takingPhotos'),
                    duration: 1000,
                  });
                  return;
                }
                this.isTakingPhoto = true;
                this.clickFocusBtn('4');
                if (this.getSupportedCamerasFn()) {
                  this.modelBagCol = 'photo';
                  if (this.isDoubleRecord) {
                    this.currentCameraId = this.currentCameraId === this.secondCameraId
                      ? this.secondCameraId
                      : this.currentCameraId;
                  }
                  Logger.info(
                    this.tag,
                    `cheyang,第二个拍照按钮使用相机ID: ${this.currentCameraId}`
                  );
                  this.countTakeVideoFn();
                } else {
                  promptAction.showToast({
                    message: $r('app.string.pleaseConnectCamera'),
                    duration: 2000,
                  });
                }
              })
              .onKeyEvent((e)=>{
                if(floatWindowManager.windowInstance){
                  if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                    if(this.upToTotal<floatWindowManager.displayHeight-floatWindowManager.windowHeight){
                      console.log('执行了',this.leftToTotal+'   '+floatWindowManager.displayWidth);
                      this.upToTotal+=floatWindowManager.movingStepSize;
                      floatWindowManager.moveTo(this.leftToTotal, this.upToTotal);
                    }
                  }
                }
              });
          } else if (this.modelBagCol === 'video' && !this.isRecordingSecond) {
            Image(this.takeVideoImageSecond)
              .width('96lpx')
              .height('96lpx')
              .id('5')
              .onFocus(() => {
                this.takeVideoImageSecond = $r('app.media.camera_video_focus');
              })
              .onBlur(() => {
                this.takeVideoImageSecond = $r('app.media.camera_video_default');
              })
              .focusable(true)
              .defaultFocus(true)
              .focusBox({
                margin: LengthMetrics.lpx(5),
                strokeColor: ColorMetrics.resourceColor(Color.White),
                strokeWidth: LengthMetrics.lpx(0)
              })
              .onHover(() => {
                this.clickFocusBtn('5');
              })
              .onClick((e) => {
                if (this.getSupportedCamerasFn()) {
                  if (this.isDoubleRecord) {
                    this.currentCameraId = this.currentCameraId === this.secondCameraId ?
                      this.secondCameraId : this.currentCameraId;
                  }
                  this.isRecording = true;
                  Logger.info(this.tag, `第二个录像按钮使用相机ID: ${this.currentCameraId}`);
                  this.modelBagCol = 'video';

                  const cameraId = this.getCameraIdByIndex(0); // 向后兼容，使用索引0
                  Logger.info(this.tag, `camera js camerastatus cameraId:${cameraId}`);
                  Logger.info(this.tag, `camera js camerastatus cameracbid:${this.callBackCameraId}`);
                  Logger.info(this.tag, `camera js camerastatus isDeviceCb:${this.isDeviceCb}`);
                  if(!this.isDeviceCb){
                    this.callBackCameraId = cameraId ;
                  }
                  if (this.callBackCameraId) {
                    cameraDemo.releaseSession(this.callBackCameraId);
                    cameraDemo.initCamera(this.isDoubleRecord ? this.surfaceIdSecond : this.surfaceId,
                      this.settingDataObj.focusMode, this.callBackCameraId,this.isVideo);
                  }
                  if (this.isDoubleRecord) {
                    this.isRecordingSecond = true;
                  }
                  this.countTakeVideoFn();
                  this.clickFocusBtn(this.isDoubleRecord ? '16' : '8');
                } else {
                  promptAction.showToast({
                    message: $r('app.string.pleaseConnectCamera'),
                    duration: 2000,
                  });
                }
              });
          } else {
            if (this.isDoubleRecord) {
              Column() {
                Image(this.stopVideoImageSecond)
                  .width('96lpx')
                  .height('96lpx')
                  .borderRadius(50)
                  .id('16')
                  .defaultFocus(true)
                  .focusable(true)
                  .onFocus(() => {
                    this.stopVideoImageSecond = $r('app.media.camera_stopvideo_focus');
                  })
                  .onBlur(() => {
                    this.stopVideoImageSecond = $r('app.media.camera_stopvideo_default');
                  })
                  .focusBox({
                    margin: LengthMetrics.px(5),
                    strokeColor: ColorMetrics.resourceColor(Color.White),
                    strokeWidth: LengthMetrics.px(2)
                  })
                  .onClick(async () => {
                    if (this.isRecordingSecond) {
                      if (this.timerSecond !== undefined) {
                        clearInterval(this.timerSecond);
                      }
                      this.isRecordingSecond = false;
                      // Stop video
                      this.stopVideoSecond().then(async (fileAsset: UriResult | undefined) => {
                        this.videoRecodeTimeSecond = 0;
                        try {
                          await this.createVideoThumbnail(fileAsset);
                          promptAction.showToast({
                            message: $r('app.string.videoSavedSuccessfully'),
                            duration: 2000,
                          });
                        } catch (err) {
                          Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
                        }
                      });
                    }
                  });
              }
            }
          }
        }

        Image(this.rotateImage)
          .width('96lpx')
          .height('96lpx')
          .id('17')
          .focusable(true)
          .onHover(() => {
            this.clickFocusBtn('17');
          })
          .focusBox({
            margin: LengthMetrics.px(5),
            strokeColor: ColorMetrics.resourceColor(Color.White),
            strokeWidth: LengthMetrics.px(0)
          })
          .onFocus(() => {
            this.rotateImage = $r('app.media.camera_rotate_focus');
          })
          .onBlur(() => {
            this.rotateImage = $r('app.media.camera_rotate_default');
          })
          .onClick(() => {
            Logger.info(this.tag, ` rotateImage : ${this.cameraRotate}`);
            this.cameraRotate  = (this.cameraRotate + 90) % 360;
          })
          .onKeyEvent((e) => {
            if(floatWindowManager.windowInstance){
              if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
                if(this.leftToTotal<floatWindowManager.displayWidth-floatWindowManager.windowWidth){
                  console.log('执行了',this.leftToTotal+'   '+floatWindowManager.displayWidth);
                  this.leftToTotal+=floatWindowManager.movingStepSize;
                  floatWindowManager.moveTo(this.leftToTotal, this.upToTotal);
                }
              }
              if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                if(this.upToTotal<floatWindowManager.displayHeight-floatWindowManager.windowHeight){
                  console.log('执行了',this.leftToTotal+'   '+floatWindowManager.displayWidth);
                  this.upToTotal+=floatWindowManager.movingStepSize;
                  floatWindowManager.moveTo(this.leftToTotal, this.upToTotal);
                }
              }
            }
          });
      }
      .margin({ top: '20lpx' })
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .visibility(this.isModeBol ? Visibility.Visible : Visibility.None)

      Row()
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .height('35lpx')
        .visibility(!this.isModeBol ? Visibility.Visible : Visibility.None)
      Row() {
        Column() {
          Image(this.pauseVideoImage)
            .width('96lpx')
            .height('96lpx')
            .id('9')
            .focusable(true)
            .onFocus(() => {
              this.isPauseFocus = true;
              if (this.isPause) {
                this.pauseVideoImage = $r('app.media.camera_pause_focus');
              } else {
                this.pauseVideoImage = $r('app.media.camera_goon_focus');
              }
            })
            .onBlur(() => {
              this.isPauseFocus = false;
              if (this.isPause) {
                this.pauseVideoImage = $r('app.media.camera_pause_default');
              } else {
                this.pauseVideoImage = $r('app.media.camera_goon_default');
              }
            })
            .focusBox({
              margin: LengthMetrics.px(5),
              strokeColor: ColorMetrics.resourceColor(Color.White),
              strokeWidth: LengthMetrics.px(0)
            })
            .onHover(() => {
              this.clickFocusBtn('9');
            })
            .onClick(() => {
              this.clickFocusBtn('9');
              this.isPause = !this.isPause;
              if (this.isPause) {
                this.videoRecorder?.pause();
                this.onRecordPaused();
                if (this.isPauseFocus) {
                  this.pauseVideoImage = $r('app.media.camera_pause_focus');
                } else {
                  this.pauseVideoImage = $r('app.media.camera_pause_default');
                }
              } else {
                this.videoRecorder?.resume();
                if (this.getSupportedCamerasFn()) {
                  this.timer = setInterval(() => {
                    this.videoRecodeTime += 1000;
                  }, 1000);
                }
                if (this.isPauseFocus) {
                  this.pauseVideoImage = $r('app.media.camera_goon_focus');
                } else {
                  this.pauseVideoImage = $r('app.media.camera_goon_default');
                }
              }
            });
        }

        Column() {
          Image(this.stopVideoImage)
            .width('96lpx')
            .height('96lpx')
            .borderRadius(50)
            .id('8')
            .defaultFocus(true)
            .focusable(true)
            .onFocus(() => {
              this.stopVideoImage = $r('app.media.camera_stopvideo_focus');
            })
            .onBlur(() => {
              this.stopVideoImage = $r('app.media.camera_stopvideo_default');
            })
            .focusBox({
              margin: LengthMetrics.px(5),
              strokeColor: ColorMetrics.resourceColor(Color.White),
              strokeWidth: LengthMetrics.px(0)
            })
            .onHover(()=>{
              this.clickFocusBtn('8');
            })
            .onClick(() => {
              if (this.timer !== undefined) {
                clearInterval(this.timer);
              }
              // Stop video
              this.stopVideo().then(async (fileAsset: UriResult | undefined) => {
                this.videoRecodeTime = 0;
                this.isModeBol = true;
                try {
                  await this.createVideoThumbnail(fileAsset);
                  this.fileAssetAll = fileAsset;
                  this.clickFocusBtn('5');
                  promptAction.showToast({
                    message: $r('app.string.videoSavedSuccessfully'),
                    duration: 2000,
                  });
                } catch (err) {
                  Logger.info(this.tag, 'videoThumbnail err----------:' + JSON.stringify(err.message));
                }
              });
              this.isPause = false;
              this.pauseVideoImage = $r('app.media.camera_goon_default');
            });
        }
      }
      .margin({ top: '20lpx' })
      .width('70%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .visibility(!this.isModeBol ? Visibility.Visible : Visibility.None)

    }.height('30%').position({ x: '0%', y: '70%' })
    .focusable(true)
    .onTouch(event => {
      EventUtil.isTouchEvent(event);
    });
  }

  async stopVideo(): Promise<UriResult | undefined> {
    this.isRecording=false;
    try {
      if (this.videoRecorder) {
        await this.videoRecorder.stop();
        await this.videoRecorder.release();
      }
      if (this.getSupportedCamerasFn()) {
        //modify by cheyang for new0714 - 恢复并使用相机ID

        const cameraId = this.getCurrentCameraId();
        if (cameraId) {
          cameraDemo.videoOutputStopAndRelease(cameraId);
        }
      }
      if (this.fileAsset) {
        return this.fileAsset;
      }
      Logger.info(this.tag, 'stopVideo end');
    } catch (err) {
      Logger.info(this.tag, 'stopVideo err: ' + JSON.stringify(err));
    }
    return undefined;
  }

  async stopVideoSecond(): Promise<UriResult | undefined> {
    try {
      if (this.videoRecorderSecond) {
        await this.videoRecorderSecond.stop();
        await this.videoRecorderSecond.release();
      }
      if (this.getSupportedCamerasFn()) {
        //modify by cy 0714 - 恢复并使用相机ID
        const cameraId = this.getCameraIdByIndex(1);  // 第二个相机通常是索引1
        if (cameraId) {
          cameraDemo.videoOutputStopAndRelease(cameraId);
        }
      }
      if (this.fileAssetSecond) {
        // 移除对fileAssetSecond.close的调用，因为UriResult接口中没有这个方法
        return this.fileAssetSecond;
      }
      Logger.info(this.tag, 'stopVideo end');
    } catch (err) {
      Logger.info(this.tag, 'stopVideo err: ' + JSON.stringify(err));
    }
    return undefined;
  }


  async createVideoThumbnail(fileAsset: UriResult | undefined) {
    if (!fileAsset || !fileAsset.uri) {
      Logger.error(this.tag, 'createVideoThumbnail failed: fileAsset or uri is null');
      return;
    }
    Logger.info(this.tag, 'createVideoThumbnail start');
    try {
      let videoFile: fileio.File = fileio.openSync(fileAsset.uri);
      let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator();
      avImageGenerator.fdSrc = videoFile;
      let timeUs: number = 1000;
      let queryOption: media.AVImageQueryOptions = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC;
      let param: media.PixelMapParams = {};
      const videoThumbnail:image.PixelMap = await avImageGenerator.fetchFrameByTime(timeUs, queryOption, param);
      if (videoThumbnail) {
        this.videoThumbnail = videoThumbnail;
        Logger.info(this.tag, 'createVideoThumbnail success: ' + JSON.stringify(this.videoThumbnail));
      } else {
        Logger.error(this.tag, `videoThumbnail is null`);
      }
    } catch (err) {
      Logger.error(this.tag, `createVideoThumbnail failed: ${JSON.stringify(err)}`);
    }
  }
}
