/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import cameraDemo from 'libentry.so';

import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { display, router , window} from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import { camera } from '@kit.CameraKit';
import { Constants } from '../common/Constants';
import Logger from '../common/utils/Logger';
import { GlobalContext } from '../common/utils/GlobalContext';
import { Decimal } from '@kit.ArkTS';
import { sensor } from '@kit.SensorServiceKit';
import { media } from '@kit.MediaKit';
import { bundleManager, common } from '@kit.AbilityKit';

const TAG = 'IndexPage';

@Entry
@Component
struct Index {
  private targetVersion: number = 0;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private mXComponentController: XComponentController = new XComponentController();
  private mXComponentControllerSlave: XComponentController = new XComponentController();
  private mCameraManager: camera.CameraManager = camera.getCameraManager(this.context);
  @StorageLink('previewSurfaceIdSlave') previewSurfaceIdSlave: string = '';
  @StorageLink('previewSurfaceId') previewSurfaceId: string = '';
  @StorageLink('videoSurfaceId') @Watch('videoIdChange') videoSurfaceId: string = '';
  @StorageLink('sceneMode') sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  @State mRotate: number = display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90;
  @State mXComponentWidth: number = Constants.X_COMPONENT_SURFACE_WIDTH;
  @State mXComponentHeight: number = Constants.X_COMPONENT_SURFACE_HEIGHT;
  @State videoTrigger: number = 0;
  private mWindowHeight = 0;
  private mWindowWidth = 0;
  @State reloadXComponentFlag: boolean = false;
  @State mConfigRatio: number = 16 / 9;
  @StorageLink('foldStatus') @Watch('reloadXComponent') foldStatus: number = 0;
  private windowClass = (this.context as common.UIAbilityContext).windowStage.getMainWindowSync();
  private cameraManager: camera.CameraManager = camera.getCameraManager(GlobalContext.get().getCameraSettingContext());
  private cameras = this.getSupportedCamerasFn(this.mCameraManager);
  @StorageLink('curCameraPosition') curCameraPosition: camera.CameraPosition = this.cameras[0].cameraPosition;
  // ArrayBuffer处理回调函数
  photoBufferCallback: (arrayBuffer: ArrayBuffer) => void = (arrayBuffer: ArrayBuffer) => {
    Logger.info(TAG, 'photoBufferCallback');
    GlobalContext.get().setObject('photoArrayBuffer', arrayBuffer);
    AppStorage.set<boolean>('isOpenEditPage', true);
  }

  videoIdChange() {
    Logger.info(TAG, 'videoIdChange id:' + this.videoSurfaceId)
  }

  reloadXComponent(): void {
    this.reloadXComponentFlag = !this.reloadXComponentFlag;
    this.updateXComponentSize();
  }

  onFoldStatusChange(): void {
  }

  offFoldStatusChange(): void {
  }

  getBundleInfoForSelf() {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    try {
      bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
        Logger.info(TAG, `getBundleInfoForSelf successfully. Data: ${data.targetVersion}`);
        this.targetVersion = data.targetVersion;
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `getBundleInfoForSelf failed ${err}`);
      });
    } catch (err) {
      let message = (err as BusinessError).message;
      Logger.error(TAG, `getBundleInfoForSelf failed ${message}`);
    }
  }

  isIsolateForSpecialType(): boolean {
    return deviceInfo.deviceType == 'tablet' && this.targetVersion <= 50000013;
  }

  foldStatusChanged(foldStatusInfo: camera.FoldStatusInfo) {
    console.info(TAG + 'foldStatusChanged foldStatus: ' + foldStatusInfo.foldStatus);
    for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
      console.info(TAG +
        `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
    }
    let deviceIndex = -1;
    if (foldStatusInfo.foldStatus === camera.FoldStatus.EXPANDED ||
      foldStatusInfo.foldStatus === camera.FoldStatus.FOLDED) {
      this.cameras = foldStatusInfo.supportedCameras;
      AppStorage.set('cameraNumber', this.cameras.length);
      deviceIndex = foldStatusInfo.supportedCameras.findIndex((cameraDeviceTemp: camera.CameraDevice) => {
        let cameraPositionTemp = AppStorage.get<number>('curCameraPosition')
        console.info(TAG + 'cameraDeviceTemp.cameraPosition: ' + cameraPositionTemp);
        return cameraPositionTemp === cameraDeviceTemp.cameraPosition;
      })
    }
    if (deviceIndex === -1) {
      AppStorage.set('curCameraPosition', foldStatusInfo.supportedCameras[0].cameraPosition);
      return;
    } else {
      AppStorage.set('curCameraPosition', foldStatusInfo.supportedCameras[deviceIndex].cameraPosition);
    }
    AppStorage.setOrCreate<number>('foldStatus', foldStatusInfo.foldStatus);
  }


  /**
   * Obtains the object that supports the specified camera device.
   */
  getSupportedCamerasFn(cameraManager: camera.CameraManager): Array<camera.CameraDevice> {
    let supportedCameras: camera.CameraDevice[] = [];
    try {
      supportedCameras = cameraManager.getSupportedCameras();
      for (let i = 0; i < supportedCameras.length; i++) {
        Logger.info(TAG,
          `getSupportedCameras camera[${i}]: ${supportedCameras[i].cameraId},cameraPosition: ${supportedCameras[i].cameraPosition}, cameraOrientation: ${supportedCameras[i].cameraOrientation},cameraType: ${supportedCameras[i].cameraType}`);
      }
      Logger.info(TAG, `getSupportedCameras success: ${supportedCameras}, length: ${supportedCameras.length}`);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getSupportedCameras failed: ${JSON.stringify(err)}`);
    }
    return supportedCameras;
  }

  selectCameraDevice(cameras: Array<camera.CameraDevice>,
    cameraPosition: camera.CameraPosition): camera.CameraDevice | undefined {
    let deviceIndex = cameras.findIndex((cameraDevice: camera.CameraDevice) => {
      return cameraPosition == cameraDevice.cameraPosition;
    })
    if (deviceIndex === -1) {
      Logger.error(TAG, 'No supported camera device found.');
      return undefined;
    }
    return cameras[deviceIndex];
  }

  updateXComponentSize() {
    let cameraPostion = AppStorage.get<number>('curCameraPosition');
    if (cameraPostion === undefined) {
      cameraPostion = camera.CameraPosition.CAMERA_POSITION_BACK;
    }
    let selectedCamera = this.selectCameraDevice(this.cameras, cameraPostion);
    AppStorage.SetOrCreate('cameraNumber', this.cameras.length);
    if (selectedCamera === undefined) {
      return;
    }
    let angleDiff = (this.mRotate + selectedCamera?.cameraOrientation) % 360;
    Logger.info(TAG, `angleDiff : ${angleDiff}`);
    Logger.info(TAG, `mRotate : ${this.mRotate}`);
    Logger.info(TAG, `cameraOrientation : ${selectedCamera?.cameraOrientation}`);
    if (this.isIsolateForSpecialType()) { // 平板 并且API小于14
      if (angleDiff === 90 || angleDiff=== 270) {
        this.mXComponentWidth = this.mConfigRatio * this.mWindowHeight;
        this.mXComponentHeight = this.mWindowHeight;
      } else {
        this.mXComponentWidth = this.mWindowWidth;
        this.mXComponentHeight = this.mConfigRatio * this.mWindowWidth; //1920 *1080
      }
    } else { // 非平板或者平板大于等于14，比如
        this.mXComponentWidth = this.mWindowWidth;
        this.mXComponentHeight = this.mConfigRatio * this.mWindowWidth; //1920 *1080
    }
    Logger.info(TAG, `this.mXComponentWidth = : ${this.mXComponentWidth}`);
    Logger.info(TAG, `this.mXComponentHeight =: ${this.mXComponentHeight}`);
  }

  async aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear enter');
    Logger.error(TAG, `deviceType:${deviceInfo.deviceType}`);
    await window.getLastWindow(this.context).then((window: window.Window) => {
      this.mWindowWidth = window.getWindowProperties().windowRect.width;
      this.mWindowHeight = window.getWindowProperties().windowRect.height;
    });
    this.mRotate = display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90;
    cameraDemo.updateRotateForCamera(this.mRotate);
    this.updateXComponentSize();
    this.windowClass.on('windowSizeChange', (size) => {
      this.mWindowWidth = size.width;
      this.mWindowHeight = size.height;
      this.updateXComponentSize();
    });
    display.on('change', (n: number) => {
      Logger.error(TAG, `display change:${display.getDefaultDisplaySync().rotation}`);
      if (this.mRotate != display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90) {
        this.mRotate = display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90;
        Logger.error(TAG, `updateRotate = ${this.mRotate}`);
        this.updateXComponentSize();
        cameraDemo.updateRotateForCamera(this.mRotate);
      }
    });
    this.cameras = this.getSupportedCamerasFn(this.cameraManager);
    AppStorage.setOrCreate<boolean>('isFirstRecording', false);
    this.onFoldStatusChange();
    Logger.info(TAG, 'aboutToAppear');
  }

  aboutToDisAppear() {
    Logger.info(TAG, 'aboutToDisAppear');
    display.off('change');
    this.windowClass.off('windowSizeChange');
    // 解注册
    this.offFoldStatusChange();
  }


  onPageShow(): void {
    Logger.info(TAG, 'onPageShow enter');
    if (this.previewSurfaceId != '') {
      Logger.info(TAG,
        `onPageShow previewSurfaceId:${this.previewSurfaceId} videoSurfaceId:${this.videoSurfaceId} sceneMode:${this.sceneMode}`);
      if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
        this.videoTrigger++;
      } else {
        cameraDemo.initCamera(this.previewSurfaceId, this.previewSurfaceIdSlave, this.videoSurfaceId, this.sceneMode,
          this.curCameraPosition);
        cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
          Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
          for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
            console.info(TAG +
              `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
          }
          this.foldStatusChanged(foldStatusInfo);
        });
        cameraDemo.setBufferCb(this.photoBufferCallback);
        AppStorage.setOrCreate<boolean>('isOpenEditPage', false);
      }
    }
  }

  onPageHide(): void {
    cameraDemo.releaseCamera();
  }

  build() {
    Column() {
      Column() {
        if (this.reloadXComponentFlag) {
          XComponent({
            id: 'componentId1',
            type: 'surface',
            libraryname: 'entry',
            controller: this.mXComponentController
          })
            .onLoad(async () => {
              Logger.info(TAG, 'onLoad is called');
              this.previewSurfaceId = this.mXComponentController.getXComponentSurfaceId();
              this.previewSurfaceIdSlave = this.mXComponentControllerSlave.getXComponentSurfaceId();
              AppStorage.set('previewSurfaceId', this.previewSurfaceId);
              AppStorage.set('previewSurfaceIdSlave', this.previewSurfaceIdSlave);
              Logger.info(TAG, `onLoad previewSurfaceId: ${this.previewSurfaceId}`);
              Logger.info(TAG, `onLoad previewSurfaceIdSlave: ${this.previewSurfaceIdSlave}`);
              await cameraDemo.initCamera(this.previewSurfaceId, this.previewSurfaceIdSlave, this.videoSurfaceId,
                this.sceneMode,
                this.curCameraPosition);
              cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
                Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
                for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
                  console.info(TAG +
                    `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
                }
                this.foldStatusChanged(foldStatusInfo);
              });
              cameraDemo.setBufferCb(this.photoBufferCallback);
            })// The width and height of the surface are opposite to those of the XComponent.
            .width(px2vp(this.mXComponentWidth))//surface 1920*1080 宽*高
            .height(px2vp(this.mXComponentHeight)) //1080
        } else {
          XComponent({
            id: 'componentId1',
            type: 'surface',
            libraryname: 'entry',
            controller: this.mXComponentController
          })
            .onLoad(async () => {
              Logger.info(TAG, 'onLoad is called');
              this.previewSurfaceId = this.mXComponentController.getXComponentSurfaceId();
              this.previewSurfaceIdSlave = this.mXComponentControllerSlave.getXComponentSurfaceId();
              AppStorage.set('previewSurfaceId', this.previewSurfaceId);
              AppStorage.set('previewSurfaceIdSlave', this.previewSurfaceIdSlave);
              Logger.info(TAG, `onLoad previewSurfaceId: ${this.previewSurfaceId}`);
              Logger.info(TAG, `onLoad previewSurfaceIdSlave: ${this.previewSurfaceIdSlave}`);
              await cameraDemo.initCamera(this.previewSurfaceId, this.previewSurfaceIdSlave, this.videoSurfaceId,
                this.sceneMode,
                this.curCameraPosition);
              cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
                Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
                for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
                  console.info(TAG +
                    `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
                }
                this.foldStatusChanged(foldStatusInfo);
              });
              cameraDemo.setBufferCb(this.photoBufferCallback);
            })// The width and height of the surface are opposite to those of the XComponent.
            .width(px2vp(this.mXComponentWidth))//1280 surface 1280*720 宽*高
            .height(px2vp(this.mXComponentHeight)) //720
        }
      }
      .justifyContent(FlexAlign.Center)
      .height('70%')

      ModeComponent({
        videoTrigger: this.videoTrigger
      })
        .height('15%')

      Row() {
        Column() {
          XComponent({
            id: 'componentId1',
            type: 'surface',
            libraryname: 'entry',
            controller: this.mXComponentControllerSlave
          }).backgroundColor(Color.Yellow).width(px2vp(324)).height(px2vp(576))
        }.align(Alignment.TopStart)
      }.width(px2vp(324)).height(px2vp(576))
      .justifyContent(FlexAlign.Start)
      .backgroundColor(Color.Blue)
      .position({ x: 0, y: 100 })

      Column()
        .height('5%')
    }
    .justifyContent(FlexAlign.End)
    .backgroundColor(Color.Black)
    .height('100%')
    .width('100%')
  }
}

@Component
struct ModeComponent {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State videoWidth: number = 0;
  @State videoHeight: number = 0;
  @StorageLink('profile') @Watch('updateProfile') curProfile: number = 0;
  @StorageLink('ratio') @Watch('updateProfile') ratio: number = 0;
  @StorageLink('isOpenEditPage') @Watch('changePageState') isOpenEditPage: boolean = false;
  @State sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  @StorageLink('isRecording') @Watch('changeRecord') isRecording: boolean = false;
  @Prop @Watch('onTriggerChange') videoTrigger: number;
  private avRecorder: media.AVRecorder | undefined = undefined;
  private videoConfigForPrepare: media.AVRecorderConfig = {
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
        videoFrameWidth: 1920,
        videoFrameHeight: 1080,
        videoFrameRate: 30,
        isHdr: false
      },
      url: `fd://0`,
      rotation: 90
    };

  async onTriggerChange() {
    await this.prepareAVRecorder();
    let previewSurfaceId = AppStorage.get<string>('previewSurfaceId');
    let previewSurfaceIdSlave = AppStorage.get<string>('previewSurfaceIdSlave');
    let videoSurfaceId = AppStorage.get<string>('videoSurfaceId');
    let curCameraPosition = AppStorage.get<number>('curCameraPosition');
    cameraDemo.initCamera(previewSurfaceId, previewSurfaceIdSlave, videoSurfaceId, this.sceneMode, curCameraPosition);
    cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
      Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
      for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
        console.info(TAG +
          `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
      }
    });
    AppStorage.setOrCreate<boolean>('isOpenEditPage', false);
  }

  updateProfile() {
    let profile = AppStorage.get<number>('profile');
    let ratio = AppStorage.get<number>('ratio');
    let previewSurfaceId = AppStorage.get<string>('previewSurfaceId');
    let previewSurfaceIdSlave = AppStorage.get<string>('previewSurfaceIdSlave');
    let videoSurfaceId = AppStorage.get<string>('videoSurfaceId');
    let curCameraPosition = AppStorage.get<number>('curCameraPosition');
    Logger.info(TAG,
      `updateProfile profile:${profile} ratio:${ratio} previewSurfaceId:${previewSurfaceId} videoSurfaceId:${videoSurfaceId} sceneMode:${this.sceneMode} curCameraPosition:${curCameraPosition}`)
    cameraDemo.initCamera(previewSurfaceId, previewSurfaceIdSlave, videoSurfaceId, this.sceneMode, curCameraPosition);
    cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
      Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
      for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
        console.info(TAG +
          `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
      }
    });
    // 720
    if (profile == 0) {
      // 1:1
      if (ratio == 0) {
        this.videoWidth = 720;
        this.videoHeight = 720;
      } else if (ratio == 1) {
        // 4:3
        this.videoWidth = 640;
        this.videoHeight = 480;
      } else if (ratio == 2) {
        // 16:9
        this.videoWidth = 1280;
        this.videoHeight = 720;
      }
    }
    // 1080
    if (profile == 0) {
      // 1:1
      if (ratio == 0) {
        this.videoWidth = 1080;
        this.videoHeight = 1080;
      } else if (ratio == 1) {
        // 4:3
        this.videoWidth = 1920;
        this.videoHeight = 1440;
      } else if (ratio == 2) {
        // 16:9
        this.videoWidth = 1920;
        this.videoHeight = 1080;
      }
    }
    // 4k
    if (profile == 0) {
      // 1:1
      if (ratio == 0) {
        this.videoWidth = 3120;
        this.videoHeight = 3120;
      } else if (ratio == 1) {
        // 4:3
        this.videoWidth = 4096;
        this.videoHeight = 3072;
      } else if (ratio == 2) {
        // 16:9
        this.videoWidth = 4096;
        this.videoHeight = 2304;
      }
    }
  }

  async onPageShow() {
    if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
      await this.prepareAVRecorder();
    }
  }

  changePageState() {
    Logger.info(TAG, 'isOpenEditPage change:' + this.isOpenEditPage);
    if (this.isOpenEditPage) {
      this.onJumpClick();
    }
  }

  changeRecord() {
    Logger.info(TAG, 'isRecording change:' + this.isRecording);
  }

  onJumpClick(): void {
    GlobalContext.get().setObject('sceneMode', this.sceneMode);
    router.pushUrl({
      url: 'pages/EditPage'
    }, router.RouterMode.Single, (err) => {
      if (err) {
        Logger.error(TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Invoke pushUrl succeeded.');
    });
  }

  getRealData(data: sensor.GravityResponse): number {
  let getDeviceDegree: number = 0;
  let x = data.x;
  let y = data.y;
  let z = data.z;
  if ((x * x + y * y) * 3 < z * z) {
    return getDeviceDegree;
  } else {
    try {
      let sd: Decimal = Decimal.atan2(y, -x);
      let sc: Decimal = Decimal.round(Number(sd) / 3.141592653589 * 180);
      getDeviceDegree = 90 - Number(sc);
      getDeviceDegree = getDeviceDegree >= 0 ? getDeviceDegree % 360 : getDeviceDegree % 360 + 360;
    } catch (error) {
      let err = error as BusinessError;
      console.error(`decimal failed, error: ${err.code}`);
    }
  }
  return getDeviceDegree;
}

  async getGravity() : Promise<number> {
    let isSupported: boolean = false;
    let data: sensor.Sensor[];
    try {
      data = await sensor.getSensorList();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`getSensorList failed, error: ${err.code}`);
      return -1; // 异常场景下返回默认值
    }

    for (let i = 0; i < data.length; i++) {
      if (data[i].sensorId === sensor.SensorId.GRAVITY) {
        isSupported = true;
        break;
      }
    }
    try {
      if (isSupported === true) {
        const promise: Promise<number> = new Promise((resolve) => {
          sensor.once(sensor.SensorId.GRAVITY, (data: sensor.GravityResponse) => {
            resolve(this.getRealData(data));
          });
        })
        return promise;
      } else {
        const promise: Promise<number> = new Promise((resolve) => {
          sensor.once(sensor.SensorId.ACCELEROMETER, (data: sensor.AccelerometerResponse) => {
            resolve(this.getRealData(data as sensor.GravityResponse));
          });
        })
        return promise;
      }
    } catch (error) {
      let err = error as BusinessError;
      console.error(`gePromise failed, error: ${err.code}`);
      return -1; // 异常场景下返回默认值
    }
  }


  onAvChange(state: media.AVRecorderState, reason: media.StateChangeReason): void {
    Logger.info(TAG, 'onAvChange state:' + state);
    if (state == 'error') {
      Logger.info(TAG, 'onAvChange reason:' + JSON.stringify(reason));
    }
  }

  async createAVRecorder(): Promise<media.AVRecorder | undefined> {
    let avRecorder: media.AVRecorder | undefined = undefined;
    try {
      avRecorder = await media.createAVRecorder();
      avRecorder.on('stateChange', this.onAvChange);
    } catch (error) {
      Logger.error(TAG, `createAVRecorder error: ${error}`);
    }
    return avRecorder;
  }

  initFd(): number {
    Logger.info(TAG, 'initFd is called');
    let filesDir = this.context.filesDir;
    let fileName = `${Date.now()}.mp4`;
    AppStorage.setOrCreate<string>('fileName', fileName);
    let filePath = filesDir + `/${fileName}`;
    let file: fileIo.File = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    Logger.info(TAG, `filePath =  ${filePath}`);

    return file.fd;
  }

  async prepareAVRecorder(): Promise<void> {
    Logger.info(TAG, `prepareAVRecorder is called videoWidth:${this.videoWidth} videoHeight:${this.videoHeight}`);
    this.avRecorder = await this.createAVRecorder();
    let fd = this.initFd();
    Logger.info(TAG, `fd://${fd.toString()}`);
    let videoConfig: media.AVRecorderConfig = {
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
        videoFrameWidth: 1920,
        videoFrameHeight: 1080,
        videoFrameRate: 30,
        isHdr: false
      },
      url: `fd://${fd.toString()}`,
      rotation: 90
    };
    if (deviceInfo.deviceType == 'default') {
      Logger.info(TAG, `deviceType = default`);
      videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_ES;
    }
    if (deviceInfo.deviceType == 'phone') {
      Logger.info(TAG, `deviceType = phone`)
      videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
      videoConfig.profile.videoCodec = media.CodecMimeType.VIDEO_AVC;
    }
    if (deviceInfo.deviceType == 'tablet') {
      Logger.info(TAG, `deviceType = tablet`);
      videoConfig.videoSourceType = media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV;
    }
    await this.avRecorder?.prepare(videoConfig).catch((err: BusinessError): void => {
      Logger.error(TAG, `prepareAVRecorder prepare err: ${JSON.stringify(err)}`);
    });
    this.videoConfigForPrepare = videoConfig;
    let videoSurfaceId = await this.avRecorder?.getInputSurface();
    Logger.info(TAG, `getVideoSurfaceID videoSurfaceId: ${videoSurfaceId}`);
    AppStorage.set<string>('videoSurfaceId', videoSurfaceId);
  }

  async startVideo(): Promise<void> {
    Logger.info(TAG, 'startVideo is called');

    Logger.info(TAG, 'startVideo is called 33333');

    // updateRotation
    let deviceDegree = await this.getGravity();
    Logger.info(TAG, `startVideo deviceDegree:${deviceDegree}`);
    let videoRotation = cameraDemo.getVideoRotation(deviceDegree);
    Logger.info(TAG, `startVideo getVideoRotation:${videoRotation}`);
    this.avRecorder?.updateRotation(videoRotation);

    try {
      Logger.info(TAG, 'startVideo start videoOutput');
      cameraDemo.startVideoOutput(AppStorage.get<string>('videoSurfaceId'));
      Logger.info(TAG, 'startVideo start videoOutput 11111');
      await this.avRecorder?.start();
      Logger.info(TAG, 'startVideo start videoOutput 222222');
      AppStorage.set<boolean>('isRecording', true);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `startVideo err: ${JSON.stringify(err)}`);
    }
    Logger.info(TAG, 'startVideo End of call');
  }

  async stopVideo(): Promise<void> {
    let isRecording = AppStorage.get<boolean>('isRecording');
    Logger.info(TAG, 'stopVideo is called ' + isRecording);
    if (!isRecording) {
      Logger.info(TAG, 'not in recording');
      return;
    }
    try {
      AppStorage.set<boolean>('isRecording', false);
      await this.avRecorder?.stop();
      await this.avRecorder?.prepare(this.videoConfigForPrepare);
      cameraDemo.stopVideoOutput();
      this.isOpenEditPage = true;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `stopVideo err: ${JSON.stringify(err)}`);
    }
    Logger.info(TAG, 'stopVideo End of call');
  }

  build() {
    Column() {
      Row({ space: Constants.COLUMN_SPACE_24 }) {
        Column() {
          Text($r('app.string.photo'))
            .fontSize(Constants.FONT_SIZE_14)
            .fontColor(Color.White)
        }
        .id('PhotoMode')
        .width(Constants.CAPTURE_COLUMN_WIDTH)
        .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_PHOTO ? $r('app.color.theme_color') : '')
        .borderRadius(Constants.BORDER_RADIUS_14)
        .onTouch(async (event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            Logger.info(TAG, `TouchType.Down`);
          }
          if (event.type == TouchType.Up) {
            if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
              return;
            }
            cameraDemo.releaseCamera();
            this.sceneMode = camera.SceneMode.NORMAL_PHOTO;
            AppStorage.set('sceneMode', this.sceneMode);
            let previewSurfaceId = AppStorage.get<string>('previewSurfaceId');
            let previewSurfaceIdSlave = AppStorage.get<string>('previewSurfaceIdSlave');
            let curCameraPosition = AppStorage.get<number>('curCameraPosition');
            await cameraDemo.initCamera(previewSurfaceId, previewSurfaceIdSlave, '', this.sceneMode, curCameraPosition);
            cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
              Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
              for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
                console.info(TAG +
                  `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
              }
            });
          }
        })
        Column() {
          Text($r('app.string.video'))
            .fontSize(Constants.FONT_SIZE_14)
            .fontColor(Color.White)
        }
        .width(Constants.CAPTURE_COLUMN_WIDTH)
        .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_VIDEO ? $r('app.color.theme_color') : '')
        .borderRadius(Constants.BORDER_RADIUS_14)
        .onTouch(async (event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            Logger.info(TAG, `TouchType.Down`);
          }
          if (event.type == TouchType.Up) {
            if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
              return;
            }
            cameraDemo.releaseCamera();
            this.sceneMode = camera.SceneMode.NORMAL_VIDEO;
            AppStorage.set('sceneMode', this.sceneMode);
            await this.prepareAVRecorder();
            let previewSurfaceId = AppStorage.get<string>('previewSurfaceId');
            let previewSurfaceIdSlave = AppStorage.get<string>('previewSurfaceIdSlave');
            let curCameraPosition = AppStorage.get<number>('curCameraPosition');
            let videoSurfaceId = AppStorage.get<string>('videoSurfaceId');
            await cameraDemo.initCamera(previewSurfaceId, previewSurfaceIdSlave, videoSurfaceId, this.sceneMode,
              curCameraPosition);
            cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
              Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
              for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
                console.info(TAG +
                  `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
              }
            });
          }
        })
      }
      .height(Constants.CAPTURE_ROW_HEIGHT)
      .width(Constants.FULL_PERCENT)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Row() {
        Column() {
        }
        .width($r('app.float.size_200'))

        // Camera/Video button
        Column() {
          if (!this.isRecording) {
            Row() {
              Button() {
                Text()
                  .width($r('app.float.size_120'))
                  .height($r('app.float.size_120'))
                  .borderRadius($r('app.float.size_40'))
                  .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_VIDEO ?
                  $r('app.color.theme_color') : Color.White)
              }
              .id('TakePicture')
              .border({
                width: Constants.CAPTURE_BUTTON_BORDER_WIDTH,
                color: $r('app.color.border_color'),
                radius: Constants.CAPTURE_BUTTON_BORDER_RADIUS
              })
              .width($r('app.float.size_200'))
              .height($r('app.float.size_200'))
              .backgroundColor(Color.Black)
              .onClick(async () => {
                if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
                  let deviceDegree = await this.getGravity();
                  Logger.info(TAG, `takePicture deviceDegree:${deviceDegree}`);
                  cameraDemo.takePicture(deviceDegree);
                } else if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
                  this.startVideo();
                }
              })
            }
          } else {
            Row() {
              // Recording stop button
              Button() {
                Image($r('app.media.ic_camera_video_close'))
                  .size({ width: Constants.IMAGE_SIZE, height: Constants.IMAGE_SIZE })
              }
              .id('StopVideo')
              .width($r('app.float.size_120'))
              .height($r('app.float.size_120'))
              .backgroundColor($r('app.color.theme_color'))
              .onClick(() => {
                this.stopVideo();
              })
            }
            .width($r('app.float.size_200'))
            .height($r('app.float.size_200'))
            .borderRadius($r('app.float.size_60'))
            .backgroundColor($r('app.color.theme_color'))
            .justifyContent(FlexAlign.SpaceAround)
          }
        }

        // Switching between the front and rear cameras
        Column() {
          Row() {
            Button() {
              Image($r('app.media.switch_camera'))
                .width($r('app.float.size_120'))
                .height($r('app.float.size_120'))
            }
            .width($r('app.float.size_200'))
            .height($r('app.float.size_200'))
            .backgroundColor('rgba(255,255,255,0.20)')
            .borderRadius($r('app.float.size_40'))
            .onTouch(async (event: TouchEvent) => {
              if (event.type == TouchType.Down) {
                Logger.info(TAG, `TouchType.Down`);
              }
              if (event.type == TouchType.Up) {
                let curCameraPosition = AppStorage.get<camera.CameraPosition>('curCameraPosition')
                let curCameraNumber = AppStorage.get<number>('cameraNumber')
                if (curCameraNumber !== undefined && curCameraNumber <= 1) {
                  return;
                }
                Logger.info(TAG, `switchCamera curCameraPosition:${curCameraPosition}`);
                if (curCameraPosition === camera.CameraPosition.CAMERA_POSITION_BACK) {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_FRONT;
                } else if (curCameraPosition === camera.CameraPosition.CAMERA_POSITION_FRONT) {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;
                } else {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;
                }
                AppStorage.set('curCameraPosition', curCameraPosition);
                Logger.info(TAG, `switchCamera to position:${curCameraPosition}`);
                if (this.sceneMode == camera.SceneMode.NORMAL_VIDEO) {
                  await this.prepareAVRecorder();
                }
                let previewSurfaceId = AppStorage.get<string>('previewSurfaceId');
                let previewSurfaceIdSlave = AppStorage.get<string>('previewSurfaceIdSlave');
                let videoSurfaceId = AppStorage.get<string>('videoSurfaceId');
                Logger.info(TAG,
                  `switch previewSurfaceId:${previewSurfaceId} videoSurfaceId:${videoSurfaceId} sceneMode:${this.sceneMode},curCameraPosition:${curCameraPosition}`);
                await cameraDemo.releaseCamera();
                await cameraDemo.initCamera(previewSurfaceId, previewSurfaceIdSlave, videoSurfaceId, this.sceneMode,
                  curCameraPosition);
                cameraDemo.setFoldCb((foldStatusInfo: camera.FoldStatusInfo) => {
                  Logger.info(TAG, `onPageShow fold mode change ${foldStatusInfo.foldStatus}`);
                  for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
                    console.info(TAG +
                      `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
                  }
                });
              }
            })
          }
        }
        .visibility(this.isRecording ? Visibility.Hidden : Visibility.Visible)
      }
      .padding({ left: Constants.CAPTURE_BUTTON_COLUMN_PADDING, right: Constants.CAPTURE_BUTTON_COLUMN_PADDING })
      .width(Constants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.End)
  }
}