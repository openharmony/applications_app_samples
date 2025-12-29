/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import CameraService from '../model/CameraService';
import Logger from '../common/utils/Logger';
import { ModeComponent } from '../views/ModeComponent';
import { SlideComponent } from '../views/SlideComponent';
import { GlobalContext } from '../common/utils/GlobalContext';
import { Constants } from  '../common/Constants';
import { camera } from '@kit.CameraKit';
import { display, window } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'Indexfkr';
//分辨率选项接口
interface ResolutionOption {
  value: string;    // 显示文本
  width: number;    // 宽度像素
  height: number;   // 高度像素
};

@Entry
@Component
struct Index {
  private isfirst: boolean = false;
  private static readonly DYNAMIC_FULL_ROTATIO: number = 0;
  private static readonly DYNAMIC_1_1_ROTATIO: number = 1;
  private static readonly DYNAMIC_16_9_ROTATIO: number =2;
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
  private selectedIndex = 2; //画面显示比例默认16:9
  private mWindowHeight = 0;
  private mWindowWidth = 0;
private mDynamicConfigRotatio: Map<number, number> = new Map([
    [0 , Index.DYNAMIC_FULL_ROTATIO],
    [1 , Index.DYNAMIC_1_1_ROTATIO],
    [2 , Index.DYNAMIC_16_9_ROTATIO]
  ]);

  private selectedResolutionIndex = 8;

  private resolutionOptions: ResolutionOption[] = [
    { value: '4096*3072', width: 4096, height: 3072 },
    { value: '4096*2304 ', width: 4096, height: 2304 },
    { value: '3840*2160', width: 3840, height: 2160 },
    { value: '2880*2160', width: 2880, height: 2160 },
    { value: '2560*1440', width: 2560, height: 1440 },
    { value: '2408*1080', width: 2408, height: 1080 },
    { value: '2384*1080', width: 2384, height: 1080 },
    { value: '1920*1440', width: 1920, height: 1440 },
    { value: '1920*1080', width: 1920, height: 1080 },          //默认分辨率
    { value: '1440*1080', width: 1440, height: 1080 },
    { value: '1280*720', width: 1280, height: 720 },
    { value: '1088*1088', width: 1088, height: 1088 },
    { value: '1080*1080', width: 1080, height: 1080 },
    { value: '720*720', width: 720, height: 720 },
    { value: '640*480', width: 640, height: 480 },
    { value: '480*480', width: 480, height: 480 }
  ];
  // 当前选中的分辨率（默认1920*1080）
  @State private currentResolution: camera.Size = {
    width: this.resolutionOptions[this.selectedResolutionIndex].width,
    height: this.resolutionOptions[this.selectedResolutionIndex].height
  };

  // 初始预览尺寸使用默认分辨率
  private previewProfile: camera.Profile = {
    format: 1003,
    // size: {
    //   width: 1280,
    //   height: 720
    // }
    size:this.currentResolution // 初始预览尺寸使用默认分辨率
  };

  onStridePixel(): void {
    this.isShowStridePixel = true;
  }
  private preconfigRatioSelectOptions: Array<SelectOption> = [
    { 'value': 'full' },
    { 'value': '1:1' },
    { 'value': '16:9' }];
  private foldStatusCallback =
    (err: BusinessError, info: camera.FoldStatusInfo): void => this.registerFoldStatusChanged(err, info);
  private cameras = CameraService.getSupportedCamerasFn(this.mCameraManager);
  private defaultCameraPosition = this.cameras[0].cameraPosition;
  // 折叠屏适配：registerFoldStatusChanged()/onFoldStatusChange()/offFoldStatusChange()
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
  // 屏幕旋转适配：updateRotation()
  updateRotation() {
    let cameraPosition = GlobalContext.get().getT<number>('curCameraPosition')
    if (cameraPosition === camera.CameraPosition.CAMERA_POSITION_FRONT) {
      this.cameraSwitchRotation = { y: 0.5, angle:Index.ROTATE_ANGLE_180 };
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
  // reloadXComponent()：重新加载预览
  reloadXComponent(): void {
    this.reloadXComponentFlag = !this.reloadXComponentFlag;
  }

  isIsolateForSpecialType(): boolean {
    return deviceInfo.deviceType == 'tablet' && this.targetVersion <= 50000013;
  }

   // 根据「设备类型（平板 / 手机）、API 版本、屏幕旋转角度、预览比例」4 个维度，动态计算 XComponent（相机预览容器）的宽高，确保预览画面在不同场景下不拉伸、适配屏幕。
   // 其核心目标是：根据当前设备的屏幕尺寸、摄像头的方向以及应用的配置，计算出一个合适的预览窗口大小，以确保相机预览画面不会被拉伸或压缩，而是保持正确的宽高比（Aspect Ratio）。
   // 分辨率变更无需改变窗口大小
   updateXcomponentSize() {
    if (this.cameras.length < 1) {
      return;
    }
    // 校验设备是否有可用摄像头
    let cameraDevice = CameraService.selectCameraDevice(this.cameras, GlobalContext.get().getT<number>('curCameraPosition'));
    if (!cameraDevice) {
      return;
    }
    Logger.error(TAG, `this.reconfigWidth = ${this.mWindowWidth}, this.reconfigHeight ${this.mWindowHeight}`);
    // 只有在 “全屏” 模式下，才需要动态计算比例,如果用户选择了固定比例（如 4:3 或 16:9），selectedIndex 会是其他值，这部分代码会被跳过，mConfigRatio 将保持其之前被设置的值。
    if (this.selectedIndex === 0) {
      this.mConfigRatio = (this.mWindowWidth > this.mWindowHeight) ? (this.mWindowWidth / this.mWindowHeight) :
        (this.mWindowHeight / this.mWindowWidth);
      Logger.info(TAG, `onconfigChanged 111: ${this.mConfigRatio}`);
      // 查询摄像头硬件，获取一个与我们提供的 “参考比例” 最接近的、并且摄像头支持的预览尺寸。
      let previewProfile = CameraService.getSurfaceSize(cameraDevice, this.mConfigRatio);
      if (previewProfile === undefined || previewProfile.size === undefined) {
        Logger.info(TAG, `onconfigChanged 333: ${this.mConfigRatio}`);
        return;
      }
      // 采用了摄像头硬件实际支持的、最匹配的那个比例
      this.mConfigRatio = previewProfile.size.width / previewProfile.size.height;
      //  将这个最终确定的、硬件支持的比例存入全局上下文，方便应用的其他部分（比如拍照、录像模块）获取和使用。
      GlobalContext.get().setObject('configRatio', this.mConfigRatio);
    }

    Logger.info(TAG, `onconfigChanged 2222: ${this.mConfigRatio}`);
     let angleDiff = (this.mRotate + cameraDevice?.cameraOrientation) % 360;
     if (this.isIsolateForSpecialType()) { // 平板 并且API小于14
       if (angleDiff === 90 || angleDiff=== 270) {
         this.mXComponentWidth = this.mConfigRatio * this.mWindowHeight;
         this.mXComponentHeight = this.mWindowHeight;
       } else {
         this.mXComponentWidth = this.mWindowWidth;
         this.mXComponentHeight = this.mConfigRatio * this.mWindowWidth; //1920 *1080
       }
     } else { // 非平板或者平板API大于等于14，
       if (angleDiff === 90 || angleDiff=== 270) { // 平板的api14以下 api14以上
         this.mXComponentWidth = this.mWindowWidth;
         this.mXComponentHeight = this.mConfigRatio * this.mWindowWidth; //1920 *1080
       } else {
         this.mXComponentWidth = this.mConfigRatio * this.mWindowHeight;
         this.mXComponentHeight = this.mWindowHeight;
       }
     }
    Logger.info(TAG, `this.mXComponentWidth = : ${this.mXComponentWidth}, this.isIsolateForSpecialType() = ${this.isIsolateForSpecialType()}`);
    Logger.info(TAG, `this.mXComponentHeight =: ${this.mXComponentHeight}`);
  }

  getConfigRatio (): number {
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
    this.getBundleInfoForSelf();
    await window.getLastWindow(getContext(this)).then((window: window.Window) => {
      this.mWindowWidth = window.getWindowProperties().windowRect.width;
      this.mWindowHeight = window.getWindowProperties().windowRect.height;
      Logger.error(TAG, `111 this.reconfigWidth = ${this.mWindowWidth}, this.reconfigHeight ${this.mWindowHeight}`);
    });
    this.updateXcomponentSize();
    this.windowClass.on('windowSizeChange', (size) => {
      this.mWindowWidth = size.width;
      this.mWindowHeight = size.height;
      this.updateXcomponentSize();
    });
    let displayVersionInfo: string = deviceInfo.displayVersion;
    // 输出结果：the value of the displayVersion is :XXX X.X.X.X
    console.info('the value of the deviceInfo displayVersion is :' + displayVersionInfo);
    let osFullNameInfo: string = deviceInfo.osFullName;
    // 输出结果：the value of the osFullName is :OpenHarmony-5.0.0.1
    console.info('the value of the deviceInfo osFullName is :' + osFullNameInfo);
    Logger.info(TAG, 'aboutToAppear');
    // 监听折叠屏状态变化
    this.onFoldStatusChange();
  }


  async aboutToDisAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToDisAppear fkr');
    display.off('change');

    this.windowClass.off('windowSizeChange');
    // 解注册
    this.offFoldStatusChange();
    // 释放相机 释放相机资源（关闭摄像头、释放硬件占用）
    await CameraService.releaseCamera();
  }

  async onPageShow(): Promise<void> {
    Logger.info(TAG, 'onPageShow');
    if (this.surfaceId !== '' && !this.isOpenEditPage) {
      await CameraService.initCamera2(this.surfaceId, GlobalContext.get().getT<number>('curCameraPosition'), this.currentResolution.width, this.currentResolution.height);
    }
    display.off('change');
    display.on('change', (n: number) => {
      this.mRotate = display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90;
      this.updateXcomponentSize();
      CameraService.updateRotateForCamera(this.mRotate);
      Logger.error(TAG, `onconfig 444 displayChange = ${display.getDefaultDisplaySync().rotation}`);
      Logger.info(TAG, `onLoad getFoldDisplayModefkr: ${display.getFoldDisplayMode()}`);
      Logger.info(TAG, `onLoad getFoldDisplayModefkr foldstatus: ${display.getFoldStatus()}`);
    });
    this.isOpenEditPage = false;
  }

  async onPageHide(): Promise<void> {
    Logger.info(TAG, 'onPageHide');
    let isRecording = AppStorage.get<boolean>('isRecording');
    // 若正在录像，调用CameraService.stopVideo()停止录像，避免后台耗电。
    if (isRecording) {
      await CameraService.stopVideo();
    }
  }

  // XComponent加载后执行
  async loadXComponent(): Promise<void> {
    Logger.info(TAG, 'onLoad is called');
    // this.mXComponentController.setXComponentSurfaceSize(
    //   {
    //     surfaceWidth: 1920,
    //     surfaceHeight: 1080
    //   }
    // );
    // this.mXComponentController.setXComponentSurfaceRotation({lock:true})  fixrotation
    this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
    let curCameraPosition = GlobalContext.get().getT<number>('curCameraPosition');
    GlobalContext.get().setObject('xComponentSurfaceId', this.surfaceId);
    Logger.info(TAG, `onLoad surfaceId: ${this.surfaceId}`);
    await CameraService.initCamera2(this.surfaceId, curCameraPosition, 
      this.currentResolution.width, this.currentResolution.height);
  }

  isExpandedOrHalfFolded(): boolean {
    return display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED ||
      display.getFoldStatus() == display.FoldStatus.FOLD_STATUS_HALF_FOLDED
  }

  async onconfigChanged() {
   //  selectedIndex 就三种值 0 1 2对应不同预览比例
   if (this.selectedIndex === 2) {
     this.mConfigRatio = 16/9;
   } else if (this.selectedIndex === 1) {
     this.mConfigRatio = 1;
   }
    Logger.info(TAG, `onconfigChanged 111: ${this.mXComponentHeight} this.selectedIndex ${this.selectedIndex}`);
    this.updateXcomponentSize();
    Logger.info(TAG, `onconfigChanged 333: ${this.mXComponentHeight} this.mConfigRatio= ${this.mConfigRatio}`);
    await CameraService.initCamera2(this.surfaceId, GlobalContext.get().getT<number>('curCameraPosition'), this.currentResolution.width, this.currentResolution.height);
  }

  // 新增：分辨率变更处理方法
  async onResolutionChanged() {
    // 1. 获取选中的分辨率配置
    this.currentResolution = this.resolutionOptions[this.selectedResolutionIndex];
    // 2. 更新预览配置的尺寸
    // 3. 重新计算预览容器尺寸
    this.updateXcomponentSize();
    // 4. 重新初始化相机，应用新分辨率
    await CameraService.initCamera2(
      this.surfaceId,
      GlobalContext.get().getT<number>('curCameraPosition'),
      this.currentResolution.width,
      this.currentResolution.height
    );
    Logger.info(TAG, `分辨率已切换至：${this.currentResolution.width}x${this.currentResolution.height}`);
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
      // 模式切换组件（如拍照 / 录像 / 专业模式切换，接收mScreenshotPixelMap和mShowModeSwitchImg状态，控制模式切换 UI）。
      ModeComponent({
        screenshotPixel: $mScreenshotPixelMap,
        isShowModeSwitchImg: $mShowModeSwitchImg,
        resolution: $currentResolution // 绑定分辨率
      })
      Row({ space: Constants.ROW_SPACE_24 }) {
        Column() {
          Text('分辨率')
            .width(48)
            .height(Constants.BACK_ICON_SIZE)
            .backgroundColor(Color.White)
            .textAlign(TextAlign.Center)
          // Select组件是用于提供选项选择的交互组件（类似下拉选择框），而onSelect是Select组件的选择事件回调函数—— 当用户从下拉选项中选中某一项时，该回调会被触发，用于处理用户的选择逻辑。
          Select(this.resolutionOptions)
            .selected(this.selectedResolutionIndex) // 默认选中当前索引对应的分辨率
            .backgroundColor("#fff")
            .font({ size: '10vp' })
            .onSelect(async (index:number, value:string) => {
              this.selectedResolutionIndex = index; // 更新选中索引 表明用户希望选中的分辨率
              await this.onResolutionChanged(); // 调用分辨率变更处理方法
            });
        }
      }.visibility(!CameraService.is2in1() ?  Visibility.Visible : Visibility.Hidden)
      .margin({ left: Constants.CAPTURE_BUTTON_COLUMN_MARGIN })
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Start)
      .position({ x: 0, y: 50 })
    }
    .size({ width: Constants.FULL_PERCENT, height: Constants.FULL_PERCENT })
    .backgroundColor(Color.Black)
  }
}
