/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import CameraService from '../model/CameraService';
import Logger from '../common/utils/Logger';
import { ModeComponent } from '../views/ModeComponent';
import { SlideComponent } from '../views/SlideComponent';
import { GlobalContext } from '../common/utils/GlobalContext';
import { Constants } from '../common/Constants';
import { camera } from '@kit.CameraKit';
import { display, window } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'Indexfkr';

@Entry
@Component
struct Index {
  private isfirst: boolean = false;
  private static readonly DYNAMIC_FULL_ROTATIO: number = 0;
  private static readonly DYNAMIC_1_1_ROTATIO: number = 1;
  private static readonly DYNAMIC_16_9_ROTATIO: number = 2;
  @State @Watch('updateRotation') mShowModeSwitchImg: boolean = false;
  @State mScreenshotPixelMap: image.PixelMap | undefined = undefined;
  @State cameraSwitchRotation: RotateOptions = { angle: 0 };
  @StorageLink('isShow') isShow: boolean = false;
  @State isShowStridePixel: boolean = false;
  @StorageLink('stridePixel') @Watch('onStridePixel') stridePixel: image.PixelMap | undefined = undefined;
  // Flash Mode
  @State flashMode: camera.FlashMode = camera.FlashMode.FLASH_MODE_CLOSE;
  @State focusPointBol: boolean = false;
  // Coordinates of finger taps in the exposure area
  @State focusPointVal: Array<number> = [0, 0];
  @State xComponentAspectRatio: number = 1;
  @State mConfigRatio: number = 1;
  @State PreconfigType: camera.PreconfigType = camera.PreconfigType.PRECONFIG_720P;
  @State mIsSelectPreconfig: boolean = false;
  @State mXComponentSize: camera.Size =
    { width: Constants.X_COMPONENT_SURFACE_WIDTH, height: Constants.X_COMPONENT_SURFACE_HEIGHT };
  @State mXComponentWidth: number = Constants.X_COMPONENT_SURFACE_WIDTH;
  @State mXComponentHeight: number = Constants.X_COMPONENT_SURFACE_HEIGHT;
  @StorageLink('isOpenEditPage') isOpenEditPage: boolean = false;
  @StorageLink('foldStatus') @Watch('reloadXComponent') foldStatus: number = 0;
  private mXComponentController: XComponentController = new XComponentController();
  @State mRotate: number = display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90;
  @State reloadXComponentFlag: boolean = false;
  private windowClass = (getContext() as common.UIAbilityContext).windowStage.getMainWindowSync();
  private surfaceId = '';
  private static readonly ROTATE_ANGLE_180: number = 180;
  private mCameraManager: camera.CameraManager = camera.getCameraManager(getContext());
  private targetVersion: number = 0;
  private selectedIndex = 0;
  private ratioIndex = 0;
  private mWindowHeight = 0;
  private mWindowWidth = 0;
  private configRatioMapping: Map<number, [number, number]> = new Map([
    [1, [1080, 1080]],
    [(4 / 3), [1440, 1080]],
    [(16 / 9), [1920, 1080]]
  ]);
  private mDynamicConfigRotatio: Map<number, number> = new Map([
    [0, Index.DYNAMIC_FULL_ROTATIO],
    [1, Index.DYNAMIC_1_1_ROTATIO],
    [2, Index.DYNAMIC_16_9_ROTATIO]
  ]);
  private previewProfile: camera.Profile = {
    format: 1003,
    size: {
      width: 1280,
      height: 720
    }
  };

  onStridePixel(): void {
    this.isShowStridePixel = true;
  }

  private preconfigTypeSelectOptions: Array<SelectOption> = [
    { 'value': 'PRECONFIG_720P' },
    { 'value': 'PRECONFIG_1080P' },
    { 'value': 'PRECONFIG_4K' },
    { 'value': 'PRECONFIG_HIGH_QUALITY' }];
  private preconfigRatioSelectOptions: Array<SelectOption> = [
    { 'value': '1:1' },
    { 'value': '4:3' },
    { 'value': '16:9' }];
  private foldStatusCallback =
    (err: BusinessError, info: camera.FoldStatusInfo): void => this.registerFoldStatusChanged(err, info);
  private cameras = CameraService.getSupportedCamerasFn(this.mCameraManager);
  private defaultCameraPosition = this.cameras[0].cameraPosition;

  registerFoldStatusChanged(err: BusinessError, foldStatusInfo: camera.FoldStatusInfo) {
    console.info(TAG + 'foldStatusChanged foldStatus: ' + foldStatusInfo.foldStatus);
    for (let i = 0; i < foldStatusInfo.supportedCameras.length; i++) {
      console.info(TAG +
        `foldStatusChanged camera[${i}]: ${foldStatusInfo.supportedCameras[i].cameraId},cameraPosition: ${foldStatusInfo.supportedCameras[i].cameraPosition}`);
    }
    let currentCameraDevice = CameraService.getCurCameraDevice();
    if (currentCameraDevice === undefined) {
      console.info(TAG + 'currentCameraDevice is undefine ');
    } else {
      console.info(TAG + 'cameraDeviceTemp.cameraPosition: 111 ' + currentCameraDevice.cameraPosition);
    }
    let deviceIndex = -1;
    if (foldStatusInfo.foldStatus === camera.FoldStatus.EXPANDED ||
      foldStatusInfo.foldStatus === camera.FoldStatus.FOLDED) {
      deviceIndex = foldStatusInfo.supportedCameras.findIndex((cameraDeviceTemp: camera.CameraDevice) => {
        let cameraPositionTemp = GlobalContext.get().getT<number>('curCameraPosition')
        console.info(TAG + 'cameraDeviceTemp.cameraPosition: 222' + cameraPositionTemp);
        return cameraPositionTemp === cameraDeviceTemp.cameraPosition;
      })
    }
    if (deviceIndex === -1) {
      GlobalContext.get().setObject('curCameraPosition', foldStatusInfo.supportedCameras[0].cameraPosition);
      return;
    }
    AppStorage.setOrCreate<number>('foldStatus', foldStatusInfo.foldStatus);
  }

  updateRotation() {
    let cameraPosition = GlobalContext.get().getT<number>('curCameraPosition')
    if (cameraPosition === camera.CameraPosition.CAMERA_POSITION_FRONT) {
      this.cameraSwitchRotation = { y: 0.5, angle: Index.ROTATE_ANGLE_180 };
    } else {
      this.cameraSwitchRotation = { angle: 0 };
    }
  }

  onFoldStatusChange(): void {
    this.mCameraManager.on('foldStatusChange', this.foldStatusCallback);    
  }

  offFoldStatusChange(): void {
    this.mCameraManager.off('foldStatusChange', this.foldStatusCallback);
  }

  reloadXComponent(): void {
    this.reloadXComponentFlag = !this.reloadXComponentFlag;
  }

  isIsolateForSpecialType(): boolean {
    return deviceInfo.deviceType == 'tablet' && this.targetVersion <= 50000013;
  }

  updateXComponentSize() {
    if (this.cameras.length < 1) {
      return;
    }
    let cameraDevice =
      CameraService.selectCameraDevice(this.cameras, GlobalContext.get().getT<number>('curCameraPosition'));
    if (!cameraDevice) {
      return;
    }
    Logger.error(TAG,
      `this.reconfigWidth = ${this.mWindowWidth}, this.reconfigHeight ${this.mWindowHeight}, this.mConfigRatio = ${this.mConfigRatio}, this.PreconfigType = ${this.PreconfigType}`);
    let sceneMode = GlobalContext.get().getT<camera.SceneMode>('sceneMode');
    Logger.error(TAG, `sceneMode = ${sceneMode}`);
    let windowSize = this.configRatioMapping.get(this.mConfigRatio);
    if (windowSize != undefined) {
      this.mWindowHeight = windowSize?.[0];
      this.mWindowWidth = windowSize?.[1];
    }
    let angleDiff = (this.mRotate + cameraDevice?.cameraOrientation) % 360;
    if (this.isIsolateForSpecialType()) { // 平板 并且API小于14
      if (angleDiff === 90 || angleDiff === 270) {
        this.mXComponentWidth = this.mWindowHeight;
        this.mXComponentHeight = this.mWindowHeight;
      } else {
        this.mXComponentWidth = this.mWindowWidth;
        this.mXComponentHeight = this.mWindowWidth; //1920 *1080
      }
    } else { // 非平板或者平板API大于等于14，
      if (angleDiff === 90 || angleDiff === 270) { // 平板的api14以下 api14以上
        this.mXComponentWidth = this.mWindowWidth;
        this.mXComponentHeight = this.mWindowHeight; //1920 *1080
      } else {
        this.mXComponentWidth = this.mWindowWidth;
        this.mXComponentHeight = this.mWindowHeight;
      }
    }
    Logger.info(TAG,
      `this.mXComponentWidth = : ${this.mXComponentWidth}, this.isIsolateForSpecialType() = ${this.isIsolateForSpecialType()}, this.mXComponentHeight =: ${this.mXComponentHeight}`);
  }

  getConfigRatio(): number {
    return this.mConfigRatio;
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

  async aboutToAppear() {
    Logger.info(TAG, ' aboutToAppear enter');
    GlobalContext.get().setObject('curCameraPosition', this.defaultCameraPosition);
    GlobalContext.get().setObject('PreconfigType', this.PreconfigType);
    GlobalContext.get().setObject('configRatio', this.mConfigRatio);
    this.getBundleInfoForSelf();
    await window.getLastWindow(getContext(this)).then((window: window.Window) => {
      this.mWindowWidth = window.getWindowProperties().windowRect.width;
      this.mWindowHeight = window.getWindowProperties().windowRect.height;
      Logger.error(TAG, `111 this.reconfigWidth = ${this.mWindowWidth}, this.reconfigHeight ${this.mWindowHeight}`);
    });
    this.updateXComponentSize();
    this.windowClass.on('windowSizeChange', (size) => {
      this.mWindowWidth = size.width;
      this.mWindowHeight = size.height;
      this.updateXComponentSize();
    });
    let displayVersionInfo: string = deviceInfo.displayVersion;
    // 输出结果：the value of the displayVersion is :XXX X.X.X.X
    console.info('the value of the deviceInfo displayVersion is :' + displayVersionInfo);
    let osFullNameInfo: string = deviceInfo.osFullName;
    // 输出结果：the value of the osFullName is :OpenHarmony-5.0.0.1
    console.info('the value of the deviceInfo osFullName is :' + osFullNameInfo);
    Logger.info(TAG, 'aboutToAppear');
    this.onFoldStatusChange();
  }

  async aboutToDisAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToDisAppear fkr');
    display.off('change');

    this.windowClass.off('windowSizeChange');
    // 解注册
    this.offFoldStatusChange();
    await CameraService.releaseCamera();
  }

  async onPageShow(): Promise<void> {
    Logger.info(TAG, 'onPageShow');
    if (this.surfaceId !== '' && !this.isOpenEditPage) {
      await CameraService.initCamera(this.surfaceId, GlobalContext.get().getT<number>('curCameraPosition'),
        this.PreconfigType, this.mConfigRatio);
    }
    display.off('change');
    display.on('change', (n: number) => {
      this.mRotate = display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90;
      this.updateXComponentSize();
    });
    this.isOpenEditPage = false;
  }

  async onPageHide(): Promise<void> {
    Logger.info(TAG, 'onPageHide');
    let isRecording = AppStorage.get<boolean>('isRecording');
    if (isRecording) {
      await CameraService.stopVideo();
    }
  }

  async loadXComponent(): Promise<void> {
    Logger.info(TAG, 'onLoad is called');
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
    let curCameraPosition = GlobalContext.get().getT<number>('curCameraPosition');
    GlobalContext.get().setObject('xComponentSurfaceId', this.surfaceId);
    Logger.info(TAG, `onLoad surfaceId: ${this.surfaceId}`);
    await CameraService.initCamera(this.surfaceId, curCameraPosition, this.PreconfigType, this.mConfigRatio);
  }

  isExpandedOrHalfFolded(): boolean {
    return display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED ||
      display.getFoldStatus() == display.FoldStatus.FOLD_STATUS_HALF_FOLDED
  }

  async onConfigTypeChanged() {
    if (this.selectedIndex === 2) {
      this.PreconfigType = camera.PreconfigType.PRECONFIG_4K;
    } else if (this.selectedIndex === 1) {
      this.PreconfigType = camera.PreconfigType.PRECONFIG_1080P;
    } else if (this.selectedIndex === 3) {
      this.PreconfigType = camera.PreconfigType.PRECONFIG_HIGH_QUALITY;
    } else if (this.selectedIndex === 0) {
      this.PreconfigType = camera.PreconfigType.PRECONFIG_720P;
    }
    Logger.info(TAG, `onConfigTypeChanged 111: ${this.mXComponentHeight} this.selectedIndex ${this.selectedIndex}`);
    this.updateXComponentSize();
    Logger.info(TAG, `onConfigTypeChanged 333: ${this.mXComponentHeight} this.PreconfigType= ${this.mConfigRatio}`);
    GlobalContext.get().setObject('PreconfigType', this.PreconfigType);
    await CameraService.initCamera(this.surfaceId, GlobalContext.get().getT<number>('curCameraPosition'),
      this.PreconfigType, this.mConfigRatio);
  }

  async onRatioConfigChanged() {
    if (this.ratioIndex === 2) {
      this.mConfigRatio = 16 / 9;
    } else if (this.ratioIndex === 1) {
      this.mConfigRatio = 4 / 3;
    } else if (this.ratioIndex === 0) {
      this.mConfigRatio = 1;
    }
    GlobalContext.get().setObject('configRatio', this.mConfigRatio);
    Logger.info(TAG, `onConfigTypeChanged 111: ${this.mXComponentHeight} this.ratioIndex ${this.ratioIndex}`);
    this.updateXComponentSize();
    Logger.info(TAG, `onConfigTypeChanged 333: ${this.mXComponentHeight} this.mConfigRatio= ${this.mConfigRatio}`);
    await CameraService.initCamera(this.surfaceId, GlobalContext.get().getT<number>('curCameraPosition'),
      this.PreconfigType, this.mConfigRatio);
  }

  build() {
    Stack() {
      if (this.isShow) {
        if (this.reloadXComponentFlag) {
          XComponent({
            id: 'componentId',
            type: 'surface',
            controller: this.mXComponentController
          })
            .onLoad(async () => {
              await this.loadXComponent();
            })
            .border({
              width: {
                top: Constants.X_COMPONENT_BORDER_WIDTH,
                bottom: Constants.X_COMPONENT_BORDER_WIDTH
              },
              color: Color.Black
            })
            .width(px2vp(this.mXComponentWidth))//1280 surface 1280*720 宽*高
            .height(px2vp(this.mXComponentHeight)) //720
          // .renderFit(RenderFit.RESIZE_COVER)
        } else {
          XComponent({
            id: 'componentId',
            type: 'surface',
            controller: this.mXComponentController
          })
            .onLoad(async () => {
              // if (!this.isfirst) {
              //   this.reloadXComponent();
              //   this.isfirst = true;
              // }
              await this.loadXComponent();
            })
            .border({
              width: {
                top: Constants.X_COMPONENT_BORDER_WIDTH,
                bottom: Constants.X_COMPONENT_BORDER_WIDTH
              },
              color: Color.Black
            })
            .width(px2vp(this.mXComponentWidth))
            .height(px2vp(this.mXComponentHeight))
          // .renderFit(RenderFit.RESIZE_COVER)
        }
      }
      SlideComponent()

      ModeComponent({
        screenshotPixel: $mScreenshotPixelMap,
        isShowModeSwitchImg: $mShowModeSwitchImg,
      })

      Row({ space: Constants.ROW_SPACE_24 }) {
        Column() {
          Text('预配置类型')
            .width(100)
            .height(25)
            .backgroundColor(Color.White)
            .textAlign(TextAlign.Center)
          Select(this.preconfigTypeSelectOptions)
            .selected(this.selectedIndex)
            .value(this.mShowModeSwitchImg ? this.preconfigTypeSelectOptions[this.selectedIndex].value
              : this.preconfigTypeSelectOptions[this.selectedIndex].value)
            .backgroundColor("#fff")
            .font({ size: '10vp' })
            .onSelect(async (index, value) => {
              this.selectedIndex = index;
              await this.onConfigTypeChanged();
            });
        }
      }
      .visibility(!CameraService.is2in1() ? Visibility.Visible : Visibility.Hidden)
      .margin({ left: Constants.CAPTURE_BUTTON_COLUMN_MARGIN })
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Start)
      .position({ x: 0, y: 50 })

      Row({ space: Constants.ROW_SPACE_24 }) {
        Column() {
          Text('分辨率比例')
            .width(80)
            .height(Constants.BACK_ICON_SIZE)
            .backgroundColor(Color.White)
            .textAlign(TextAlign.Center)
          Select(this.preconfigRatioSelectOptions)
            .selected(this.ratioIndex)
            .value(this.preconfigRatioSelectOptions[this.ratioIndex].value)
            .backgroundColor("#fff")
            .font({ size: '10vp' })
            .onSelect(async (index, value) => {
              this.ratioIndex = index;
              await this.onRatioConfigChanged();
            });
        }
      }
      .visibility(!CameraService.is2in1() ? Visibility.Visible : Visibility.Hidden)
      .margin({ left: Constants.CAPTURE_BUTTON_COLUMN_MARGIN })
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Start)
      .position({ x: 0, y: 120 })
    }
    .size({ width: Constants.FULL_PERCENT, height: Constants.FULL_PERCENT })
    .backgroundColor(Color.Black)
  }
}