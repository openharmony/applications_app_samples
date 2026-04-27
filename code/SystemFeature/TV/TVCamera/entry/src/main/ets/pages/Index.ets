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

import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import cameraDemo from 'libentry.so';
import { CameraHotplugLogger } from '../utils/CameraHotplugLogger';
import { modeSwitchPage } from '../views/ModeSwitchPage';
import {
  Constants,
  isHaveOpenedPhotoFrameKey,
  photoFrameMarkKey,
  photoMirrorKey,
  photoResolutionKey,
  photoWaterMarkKey,
  resolutionListKey,
  videoResolutionKey,
  videoWaterMarkKey
} from '../common/Constants';
import DisplayCalculator from '../common/DisplayCalculator';

import { SettingDataObj } from '../common/Constants';

import { camera } from '@kit.CameraKit';
import DateTimeUtil from '../model/DateTimeUtil';
import { ShootFrame } from '../views/ShootFrame';
import { ColorMetrics, display, LengthMetrics, promptAction, router } from '@kit.ArkUI';
import PreferenceUtil from '../utils/PreferenceUtil';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { getGlobalObject } from '../utils/GlobalThis';

const TAG: string = 'UI indexPage';

// 定义路由参数接口
interface MultiCameraRouterParams {
  fromMultiCamera?: boolean;
  selectedCameraId?: string;
  selectedCameraIndex?: number;
  cameraPosition?: camera.CameraPosition;
  cameraType?: camera.CameraType;
}

// 使用@Observed装饰器，让这个类可以被观察状态变化
// 相机包装器类，实现了camera.CameraDevice接口，封装了相机设备信息和控制器
@Observed
export class CamerasWrapper implements camera.CameraDevice {
  cameraId: string
  cameraPosition: camera.CameraPosition
  cameraType: camera.CameraType
  connectionType: camera.ConnectionType
  hostDeviceName: string
  hostDeviceType: camera.HostDeviceType
  cameraOrientation: number
  control: XComponentController
  surfaceId: string

  // 构造函数，初始化相机包装器的所有属性
  constructor(cameraId: string, cameraPosition: camera.CameraPosition, cameraType: camera.CameraType,
    connectionType: camera.ConnectionType
    , hostDeviceName: string
    , hostDeviceType: camera.HostDeviceType
    , cameraOrientation: number
    , control: XComponentController
    , surfaceId: string) {
    this.cameraId = cameraId;
    this.cameraPosition = cameraPosition;
    this.cameraType = cameraType;
    this.connectionType = connectionType;
    this.hostDeviceName = hostDeviceName;
    this.hostDeviceType = hostDeviceType;
    this.cameraOrientation = cameraOrientation;
    this.control = control;
    this.surfaceId = surfaceId;
  }
}

@Entry
@Component
struct Index {
  @State isVideo:boolean=false;
  @State isCameraRecordingBack:boolean=false;
  // 由于首页并没有悬浮窗，这几个数据是用来占位的
  @State leftToTotal:number=300;
  @State rightToTotal:number=300;
  @State windowHeight: number = 500;
  @State windowWidth:number=500;
  @State videoRecodeTime: number = 0;
  @State videoRecodeTimeSecond: number = 0;

  // 新增：多相机选择相关状态
  @State fromMultiCamera: boolean = false;
  @State selectedCameraId: string = '';
  @State selectedCameraIndex: number = 0;
  @State selectedCameraPosition: camera.CameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;
  @State selectedCameraType: camera.CameraType = camera.CameraType.CAMERA_TYPE_WIDE_ANGLE;

  // 统一使用cameraId进行状态管理，移除cameraDeviceIndex
  @State currentCameraId: string = '';

  // XComponentController
  private mXComponentController1: XComponentController = new XComponentController();
  private cameraManager: camera.CameraManager | null = null;
  // surfaceID value
  @State surfaceId: string = '';
  @State surfaceIdSecond: string = '';
  // Select mode
  @State @Watch('updateIsVideo')modelBagCol: string = 'photo';
  @State settingImage: ResourceStr = $r('app.media.setting_default');
  // Countdown, photography, and video recording
  @State countdownNum: number = 0;
  // Front and rear cameras
  @State cameraDeviceIndex: number = 0;
  @State xComponentWidth: number = 384;
  @State xComponentHeight: number = 450;
  @State rotateAngle:number =0;
  @State photoMirror:boolean = false;
  private screenHeight: number = 0;
  private screenWidth: number = 0;
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
  private appContext: common.Context = getContext(this);
  @StorageLink('defaultAspectRatio') @Watch('initXComponentSize') defaultAspectRatio: number =
    Constants.MIN_ASPECT_RATIO;
  @State onShow: boolean = false;
  atManager = abilityAccessCtrl.createAtManager();
  @StorageLink('isMultiCameraMode') isMultiCameraMode: boolean = false;
  @State isModeBol: boolean = true;
  @State isRecording: boolean = false;
  @State isRecordingSecond: boolean = false;
  @State private hasRecordedTime: boolean = false; // 添加标志位，确保只记录一次
  // 及时更新相机模式，相机初始化时选择正确的分辨率
  updateIsVideo() {
    this.isVideo = this.modelBagCol == 'video';
  }

  // 新增：获取当前相机ID的方法
  private getCurrentCameraId(): string {
    // 如果来自多相机页面，使用选中的相机ID
    if (this.fromMultiCamera && this.selectedCameraId) {
      hilog.info(0x0000, TAG, `multi_camera: getCurrentCameraId - 使用多相机页面选中的相机ID: ${this.selectedCameraId}`);
      return this.selectedCameraId;
    }

    // 否则从AppStorage获取当前相机ID
    let currentCameraId: string | undefined = AppStorage.get('cameraId');
    if (currentCameraId && currentCameraId.length > 0) {
      hilog.info(0x0000, TAG, `multi_camera: getCurrentCameraId - 使用AppStorage中的相机ID: ${currentCameraId}`);
      return currentCameraId;
    }

    // 如果AppStorage中没有，获取相机列表并使用第一个相机的ID
    const cameraManager = this.getCameraManager();
    const camerasArray = cameraManager.getSupportedCameras();
    if (camerasArray.length > 0) {
      const firstCameraId = camerasArray[0].cameraId;
      // 存储到AppStorage以备后用
      AppStorage.setOrCreate('cameraId', firstCameraId);
      hilog.info(0x0000, TAG, `multi_camera: getCurrentCameraId - 使用第一个相机ID: ${firstCameraId}`);
      return firstCameraId;
    }

    // 如果都没有，返回空字符串
    hilog.error(0x0000, TAG, 'multi_camera: getCurrentCameraId - 无法获取有效的相机ID');
    return '';
  }

  // 新增：根据索引获取相机ID的方法
  private getCameraIdByIndex(index: number): string {
    const cameraManager = this.getCameraManager();
    const camerasArray = cameraManager.getSupportedCameras();
    if (camerasArray.length > index && index >= 0) {
      const cameraId = camerasArray[index].cameraId;
      hilog.info(0x0000, TAG, `multi_camera: getCameraIdByIndex - 索引${index}对应相机ID: ${cameraId}`);
      return cameraId;
    }
    hilog.error(0x0000, TAG, `multi_camera: getCameraIdByIndex - 索引${index}超出范围，相机总数: ${camerasArray.length}`);
    return '';
  }

  // Entry initialization function
  // 业务背景：应用启动时需要初始化相机系统，采用异步方式避免阻塞UI
  // 策略：先设置基础状态保证界面显示，再并行执行耗时的权限和配置加载
  async aboutToAppear() {
    console.log('=== FORCE LOG: Index aboutToAppear called ===');
    hilog.info(0x0000, TAG, 'multi_camera: Index页面aboutToAppear - 开始初始化');
    this.onShow = true;

    // 初始化fromMultiCamera状态
    if (!AppStorage.has('fromMultiCamera')) {
      AppStorage.setOrCreate('fromMultiCamera', false);
    }

    // 首先处理路由参数，确保相机索引正确设置
    this.handleRouteParams();

    // 立即初始化摄像头管理器，确保能监听热插拔事件
    // 这个调用不依赖于surfaceId，即使没有摄像头也要执行
    console.log('=== FORCE LOG: About to call initCameraManager ===');
    hilog.info(0x0000, TAG, 'multi_camera: aboutToAppear - 初始化摄像头管理器以监听热插拔');
    try {
      console.log('=== FORCE LOG: Calling cameraDemo.initCameraManager() ===');
      const result = cameraDemo.initCameraManager();
      console.log(`=== FORCE LOG: initCameraManager result: ${result} ===`);
      hilog.info(0x0000, TAG, `multi_camera: 摄像头管理器初始化结果: ${result}`);
    } catch (err) {
      console.log(`=== FORCE LOG: initCameraManager error: ${JSON.stringify(err)} ===`);
      hilog.error(0x0000, TAG, `multi_camera: 摄像头管理器初始化失败: ${JSON.stringify(err)}`);
    }

    // 所有初始化操作异步执行，不阻塞UI
    this.initializeAsync();
  }

  // 异步初始化所有内容
  private async initializeAsync() {
    // 立即设置显示默认值，不等待获取屏幕尺寸
    this.setDefaultDisplaySettings();

    // 并行执行权限请求和偏好设置
    Promise.all([
      this.requestPermissionsFn(),
      this.initPreferences()
    ]).then(() => {
      // 权限和偏好设置完成后，后台获取分辨率
      this.getSupportCameraResolution();
    });

    // 显示设置异步更新
    setTimeout(() => {
      this.initDisplaySettings();
    }, 0);
  }

  // 立即设置显示默认值
  private setDefaultDisplaySettings() {
    // 使用常见的屏幕尺寸作为默认值
    this.screenWidth = 720;
    this.screenHeight = 1280;
    this.initXComponentSize();
  }

  // 处理路由参数（同步执行，确保在其他初始化之前完成）
  // 业务背景：多相机场景下需要从路由参数中获取目标相机信息，以支持相机切换功能
  // 如果不从多相机页面来，则使用默认相机（第一个可用相机）
  private handleRouteParams() {
    try {
      const params = router.getParams() as MultiCameraRouterParams;
      if (params?.fromMultiCamera) {
        hilog.info(0x0000, TAG, 'multi_camera: 检测到来自多相机页面的路由参数');
        this.fromMultiCamera = true;
        this.selectedCameraId = params.selectedCameraId || '';
        this.selectedCameraIndex = params.selectedCameraIndex || 0;
        this.selectedCameraPosition = params.cameraPosition || camera.CameraPosition.CAMERA_POSITION_BACK;
        this.selectedCameraType = params.cameraType || camera.CameraType.CAMERA_TYPE_WIDE_ANGLE;
        this.isMultiCameraMode = false;
        this.currentCameraId = this.selectedCameraId;

        // 将fromMultiCamera状态存储到AppStorage，供设置页面使用
        AppStorage.setOrCreate('fromMultiCamera', true);

        hilog.info(0x0000, TAG, `multi_camera: 从多相机页面进入，选择的相机索引: ${this.selectedCameraIndex}, 相机ID: ${this.selectedCameraId}`);
        hilog.info(0x0000, TAG, `multi_camera: 相机位置: ${this.selectedCameraPosition}, 相机类型: ${this.selectedCameraType}`);
      } else {
        // 不是从多相机页面进入，设置为false
        AppStorage.setOrCreate('fromMultiCamera', false);
        hilog.info(0x0000, TAG, 'multi_camera: 正常启动，非多相机页面进入');

        // 初始化当前相机ID
        this.currentCameraId = this.getCurrentCameraId();
      }
    } catch (err) {
      hilog.error(0x0000, TAG, `multi_camera: 路由参数解析失败: ${JSON.stringify(err)}`);
      // 路由参数解析失败不影响基本功能，使用默认值
      this.currentCameraId = this.getCurrentCameraId();
      AppStorage.setOrCreate('fromMultiCamera', false);
    }
  }

  // 异步处理显示设置（优化后的版本）
  private initDisplaySettings() {
    try {
      let mDisplay = display.getDefaultDisplaySync();
      const newWidth = px2vp(mDisplay.width);
      const newHeight = px2vp(mDisplay.height);

      // 只有当尺寸发生变化时才更新
      if (this.screenWidth !== newWidth || this.screenHeight !== newHeight) {
        this.screenWidth = newWidth;
        this.screenHeight = newHeight;
        this.initXComponentSize();
      }
    } catch (err) {
      // 继续使用默认值
    }
  }

  // 异步初始化偏好设置
  private async initPreferences() {
    try {
      await PreferenceUtil.getConfigPreference(this.appContext);

      let openPhotoWaterMark = PreferenceUtil.getConfig(photoWaterMarkKey, false) as boolean;

      let openVideoWaterMark = PreferenceUtil.getConfig(videoWaterMarkKey, false) as boolean;

      let openPhotoFrame = PreferenceUtil.getConfig(photoFrameMarkKey, false) as boolean;
    } catch (err) {
      // 静默处理错误
    }
  }

  // 恢复原来的权限请求方法
  // 业务背景：应用需要相机和麦克风等权限才能正常工作
  // 采用requestPermissionsFromUser弹窗请求，而非静默检查，提升用户体验
  async requestPermissionsFn() {
    try {
      const permissions = await this.atManager.requestPermissionsFromUser(this.appContext, [
        'ohos.permission.CAMERA',
        'ohos.permission.MICROPHONE',
        'ohos.permission.READ_MEDIA',
        'ohos.permission.WRITE_MEDIA',
        'ohos.permission.MEDIA_LOCATION',
        'ohos.permission.READ_IMAGEVIDEO',
        'ohos.permission.WRITE_IMAGEVIDEO',
        'ohos.permission.DISTRIBUTED_DATASYNC'
      ]);

      // 权限获取完成后，立即初始化相机（如果已经有surfaceId）
      if (this.surfaceId) {
        this.initCameraImmediate();
      }
    } catch (err) {
      // 权限失败也不影响UI显示
    }
  }

  // 立即初始化相机（移除权限请求）
  // 业务背景：surfaceId就绪后需要立即初始化相机，否则预览界面无法显示
  // 策略：先释放旧相机资源，再创建新相机会话，确保相机状态一致
  private async initCameraImmediate() {
    if (!this.surfaceId) {
      hilog.warn(0x0000, TAG, 'multi_camera: initCameraImmediate - surfaceId为空，跳过初始化');
      return;
    }

    try {
      hilog.info(0x0000, TAG, 'camera js camerastatus multi_camera: START_TIME - 开始相机初始化');

      // 释放当前相机资源
      const currentCameraId = this.getCurrentCameraId();
      if (currentCameraId) {
        hilog.info(0x0000, TAG, `multi_camera: 释放当前相机资源: ${currentCameraId}`);
        cameraDemo.releaseCamera(currentCameraId);
      }

      // 根据来源使用正确的相机ID
      const targetCameraId = this.fromMultiCamera ? this.selectedCameraId : currentCameraId;

      hilog.info(0x0000, TAG, `multi_camera: 初始化相机，ID: ${targetCameraId}, 来源: ${this.fromMultiCamera ? '多相机页面' : '正常启动'}`);
      hilog.info(0x0000, TAG, `multi_camera: surfaceId: ${this.surfaceId}, focusMode: ${this.settingDataObj.focusMode}`);

      // 如果是从多相机页面来的，需要特殊处理
      if (this.fromMultiCamera) {
        // 先确保释放其他可能活跃的相机
        hilog.info(0x0000, TAG, 'multi_camera: 从多相机页面切换，先释放其他相机session');
        await this.releaseOtherCamerasAsync(targetCameraId);

        // 等待一段时间确保资源释放完成
        await new Promise<void>(resolve => setTimeout(resolve, 200));
      }

      const finalCameraId = targetCameraId || currentCameraId || '';

      // 检查是否有可用摄像头
      if (!finalCameraId || finalCameraId === '') {
        hilog.warn(0x0000, TAG, 'multi_camera: 无可用摄像头，但仍需初始化摄像头管理器以监听热插拔');
        // 即使没有摄像头，也要初始化摄像头管理器来监听热插拔事件
        // 使用空字符串作为摄像头ID，让C++层知道这是无摄像头状态
        CameraHotplugLogger.logCameraInitialized('Index', 'NO_CAMERA', this.surfaceId, false);
        cameraDemo.initCameraManager(); // 只初始化管理器，不初始化具体摄像头
      } else {
        CameraHotplugLogger.logCameraInitialized('Index', finalCameraId, this.surfaceId, true);
        cameraDemo.initCamera(this.surfaceId, this.settingDataObj.focusMode, finalCameraId, this.isVideo);
      }

      hilog.info(0x0000, TAG, 'multi_camera: START_TIME - 相机初始化完成');

      // 基于相机初始化完成后，使用短延迟记录UI显示时间
      if (!this.hasRecordedTime) {
        this.hasRecordedTime = true;

        setTimeout(() => {
          const endTime = Date.now();
          const startTime = Number(getGlobalObject('appStartTime'));

          if (startTime) {
            const duration = endTime - startTime;
            hilog.info(0x0000, TAG, 'multi_camera: START_TIME - UI displayed at %{public}s, total duration: %{public}d ms',
              new Date(endTime).toISOString(), duration);
          }
        }, 200); // 相机初始化完成后200ms记录
      }

    } catch (err) {
      hilog.error(0x0000, TAG, 'multi_camera: START_TIME - 相机初始化失败: %{public}s', JSON.stringify(err));
    }
  }

  // 新增：释放其他相机的异步方法
  private async releaseOtherCamerasAsync(keepCameraId: string) {
    try {
      hilog.info(0x0000, TAG, `multi_camera: 开始释放其他相机，保留相机ID: ${keepCameraId}`);

      const cameraManager = this.getCameraManager();
      const camerasArray = cameraManager.getSupportedCameras();

      for (let i = 0; i < camerasArray.length; i++) {
        const cameraId = camerasArray[i].cameraId;
        if (cameraId !== keepCameraId) {
          hilog.info(0x0000, TAG, `multi_camera: 释放其他相机session: ${cameraId}`);
          cameraDemo.releaseSession(cameraId);
        }
      }

      hilog.info(0x0000, TAG, 'multi_camera: 其他相机session释放完成');
    } catch (err) {
      hilog.error(0x0000, TAG, `multi_camera: 释放其他相机失败: ${JSON.stringify(err)}`);
    }
  }

  // 延迟初始化相机管理器
  private getCameraManager(): camera.CameraManager {
    if (!this.cameraManager) {
      this.cameraManager = camera.getCameraManager(getContext(this));
    }
    return this.cameraManager;
  }

  getSupportedCamerasFn(): Boolean {
    return this.getCameraManager().getSupportedCameras().length >= 1;
  }

  getSupportedCamerasFnconnectionType(): Boolean {
    const cameraManager = this.getCameraManager();
    if (cameraManager.getSupportedCameras().length >= 1) {
      if (cameraManager.getSupportedCameras().length == 1) {
        let camerasArray = cameraManager.getSupportedCameras();
        let mCamera = camerasArray.find((item) => item.connectionType == 2);
        if (!mCamera) {
          //无远端相机
          return true;
        } else {
          //有远端相机
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  // 获取支持的相机分辨率列表
  // 业务背景：需要在启动时获取设备支持的分辨率，用于设置页面展示和用户选择
  // 策略：延迟500ms执行，避免影响应用启动速度；根据分辨率列表更新系统参数
  getSupportCameraResolution() {
    // 延迟更长时间，避免影响启动
    setTimeout(() => {
      try {
        const cameraManager = this.getCameraManager();
        let camerasArray = cameraManager.getSupportedCameras();
        // 使用当前相机ID查找对应的相机设备
        let targetCameraDevice: camera.CameraDevice | null = null;
        const targetCameraId = this.fromMultiCamera ? this.selectedCameraId : this.currentCameraId;
        if (targetCameraId) {
          targetCameraDevice = camerasArray.find(cam => cam.cameraId === targetCameraId) || null;
        }

        // 如果没找到，使用第一个相机
        if (!targetCameraDevice && camerasArray.length > 0) {
          targetCameraDevice = camerasArray[0];
          this.currentCameraId = targetCameraDevice.cameraId;
        }

        if (!targetCameraDevice) {
          hilog.error(0x0000, TAG, `无法找到有效的相机设备`);
          return;
        }

        let list = cameraManager.getSupportedOutputCapability(targetCameraDevice);
        let resolutionList: string[] = [];
        list.previewProfiles.forEach(((item) => {
          resolutionList.push(item.size.width + '*' + item.size.height);
        }))
        PreferenceUtil.saveConfig(resolutionListKey, JSON.stringify(resolutionList));
        let cameraResolutionIndex = PreferenceUtil.getConfig(photoResolutionKey, 0) as number;
        let videoResolutionIndex = PreferenceUtil.getConfig(videoResolutionKey, 0) as number;
        if (resolutionList.length < cameraResolutionIndex || resolutionList.length < videoResolutionIndex) {
          PreferenceUtil.saveConfig(photoResolutionKey, 0);
          PreferenceUtil.saveConfig(videoResolutionKey, 0);
        } else {
          cameraDemo.resolutionPhoto(resolutionList[cameraResolutionIndex]);
          cameraDemo.resolutionVedio(resolutionList[videoResolutionIndex]);
        }
        // 由于分辨率后面才获取，再次初始化
        this.initCameraImmediate();
        hilog.info(0x0000, TAG, `相机${targetCameraDevice.cameraId}分辨率配置完成`);
      } catch (err) {
        hilog.error(0x0000, TAG, `获取相机分辨率失败: ${JSON.stringify(err)}`);
      }
    }, 500); // 增加延迟避免影响启动
  }

  onPageHide() {
    hilog.info(0x0000, TAG, 'multi_camera: Index页面onPageHide');
    this.onShow = false;
    if (this.getSupportedCamerasFn()) {
      // 释放当前使用的相机
      const targetCameraId = this.fromMultiCamera ? this.selectedCameraId : this.currentCameraId;

      if (targetCameraId) {
        hilog.info(0x0000, TAG, `multi_camera: 释放当前相机: ${targetCameraId}`);
        cameraDemo.releaseCamera(targetCameraId);
      }

      // 如果是从多相机页面来的，也释放其他可能的相机
      if (this.fromMultiCamera) {
        hilog.info(0x0000, TAG, 'multi_camera: 从多相机页面进入，额外清理其他相机资源');
        // 释放所有其他相机以确保资源清理
        const cameraManager = this.getCameraManager();
        const camerasArray = cameraManager.getSupportedCameras();
        camerasArray.forEach((camera, index) => {
          if (camera.cameraId !== targetCameraId) {
            try {
              hilog.info(0x0000, TAG, `multi_camera: 释放其他相机: ${camera.cameraId}`);
              cameraDemo.releaseCamera(camera.cameraId);
            } catch (err) {
              // 忽略释放不存在相机的错误
              hilog.warn(0x0000, TAG, `multi_camera: 释放相机${camera.cameraId}时出错，可能相机不存在`);
            }
          }
        });
      }
    }
  }

  onBackPress(): boolean | void {
    if (this.fromMultiCamera) {
      hilog.info(0x0000, TAG, 'multi_camera: 从多相机页面返回时，重置状态');
      // 从多相机页面返回时，重置状态
      this.fromMultiCamera = false;
      AppStorage.setOrCreate('fromMultiCamera', false);
      // 如果正在录制按返回
      if(this.isRecording){
        this.isCameraRecordingBack=true;
      }
      router.back();
      return true;
    } else {
      hilog.info(0x0000, TAG, 'multi_camera: 正常返回，终止应用');
      (getContext() as common.UIAbilityContext).terminateSelf();
    }
  }

  // 页面显示时的回调，记录UI真正显示的时间
  onPageShow() {
    hilog.info(0x0000, TAG, 'multi_camera: Index页面onPageShow');
    this.onShow = true;

    // 原有的onPageShow逻辑
    // 多摄像头模式处理
    if (this.isMultiCameraMode) {
      hilog.info(0x0000, TAG, 'multi_camera: 检测到多相机模式，跳转到多相机预览页面');
      router.pushUrl({
        url: 'pages/MultiCameraPreviewPage'
      });
      return;
    }

    // 相机初始化
    if (this.surfaceId) {
      hilog.info(0x0000, TAG, `multi_camera: 有surfaceId，开始初始化相机: ${this.surfaceId}`);
      this.initCameraImmediate();
    } else {
      hilog.warn(0x0000, TAG, 'multi_camera: onPageShow时surfaceId为空，等待XComponent加载');
      // 即使没有surfaceId，也要确保摄像头管理器已初始化
      hilog.info(0x0000, TAG, 'multi_camera: onPageShow - 确保摄像头管理器已初始化');
      try {
        const result = cameraDemo.initCameraManager();
        hilog.info(0x0000, TAG, `multi_camera: onPageShow摄像头管理器初始化结果: ${result}`);
      } catch (err) {
        hilog.error(0x0000, TAG, `multi_camera: onPageShow摄像头管理器初始化失败: ${JSON.stringify(err)}`);
      }
    }

    // 非关键操作异步处理
    setTimeout(() => {
      if (this.modelBagCol == 'video' && PreferenceUtil.getConfig(photoFrameMarkKey, false) as boolean) {
        PreferenceUtil.saveConfig(photoFrameMarkKey, false);
      }
      // 如果是由于录像页面导致的关闭相框，就打开相框
      if (this.modelBagCol == 'photo' &&PreferenceUtil.getConfig(isHaveOpenedPhotoFrameKey,false) as boolean&&!(PreferenceUtil.getConfig(photoFrameMarkKey, false) as boolean)) {
        PreferenceUtil.saveConfig(photoFrameMarkKey, true);
        PreferenceUtil.saveConfig(isHaveOpenedPhotoFrameKey, false);
      }
    }, 0);
    this.photoMirror = !(PreferenceUtil.getConfig(photoMirrorKey, false) as boolean);
  }

  // 延迟创建 DateTimeUtil 实例
  private getVideoTime(): string {
    // 只有在需要显示时间时才创建实例
    if (this.videoRecodeTime > 0) {
      const dateTimeUtil: DateTimeUtil = new DateTimeUtil();
      return dateTimeUtil.getVideoTimes(this.videoRecodeTime);
    }
    return '';
  }

  initXComponentSize(): void {
    let defaultSize =
      DisplayCalculator.calcSurfaceDisplaySize(this.screenWidth, this.screenHeight, this.defaultAspectRatio);
    this.xComponentWidth = defaultSize.width;
    this.xComponentHeight = defaultSize.height;
  }

  async aboutToDisAppear() {
    if (this.getSupportedCamerasFn()) {
      // 释放当前使用的相机
      const targetCameraId = this.fromMultiCamera ? this.selectedCameraId : this.currentCameraId;
      if (targetCameraId) {
        hilog.info(0x0000, TAG, `multi_camera: 释放当前相机资源-1: ${targetCameraId}`);
        await cameraDemo.releaseCamera(targetCameraId);
      }

      // 如果是从多相机页面来的，确保释放所有相机资源
      if (this.fromMultiCamera) {
        const cameraManager = this.getCameraManager();
        const camerasArray = cameraManager.getSupportedCameras();
        camerasArray.forEach((camera, index) => {
          if (camera.cameraId !== targetCameraId) {
            try {
              hilog.info(0x0000, TAG, `multi_camera: 释放其他相机: ${camera.cameraId}`);
              cameraDemo.releaseCamera(camera.cameraId);
            } catch (err) {
              // 忽略释放不存在相机的错误
            }
          }
        });
      }
    }
  }

  build() {
    // 业务背景：相机应用采用Stack布局叠加多层级组件
    // 第一层：XComponent用于相机预览（Surface模式直接渲染到硬件缓冲区）
    // 第二层：ShootFrame单相机边框装饰
    // 第三层：模式切换和设置按钮
    // 第四层：录像时间显示（条件渲染）
    Stack({ alignContent: Alignment.Top }) {
      if (this.onShow) {
        XComponent({
          id: 'componentId1',
          type: XComponentType.SURFACE,
          controller: this.mXComponentController1
        })
          .onLoad(() => {
            // 原有的onLoad逻辑
            this.surfaceId = this.mXComponentController1.getXComponentSurfaceId();
            this.initCameraImmediate();
          })
          .backgroundColor(Color.Black)
          .width('100%')
          .height('100%')
          .scale({ x: this.photoMirror ? -1 : 1 }) // 镜像：水平翻转
          .rotate({ angle: this.rotateAngle })    // 旋转

        //预览界面边框--单相机模式
        ShootFrame({
          outsideWidth: '100%',
          outsideHeight: '100%',
          insideWidth: '370lpx',
          insideHeight: '370lpx'
        });
      } else {
        // 无摄像头时显示的提示界面
        Column() {
          Image($r('app.media.setting'))
            .width('120lpx')
            .height('120lpx')
            .fillColor(Color.White)
            .margin({ bottom: '20lpx' })

          Text('请连接摄像头设备')
            .fontSize('18fp')
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .margin({ bottom: '10lpx' })

          Text('检测到摄像头断开，请重新连接摄像头设备')
            .fontSize('14fp')
            .fontColor('#CCCCCC')
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(Color.Black)
      }

      Column() {
        if (this.onShow) {
          Row() {
            Row()
            //设置按钮
            Image(this.settingImage)
              .id('CameraSettings')
              .objectFit(ImageFit.Fill)
              .width('70lpx')
              .height('70lpx')
              .focusable(true)
              .onHover(()=>{
                focusControl.requestFocus('CameraSettings');
              })
              .onFocus(() => {
                this.settingImage = $r('app.media.setting_focus');
              })
              .onBlur(() => {
                this.settingImage = $r('app.media.setting_default');
              })
              .focusBox({
                margin: LengthMetrics.px(5),
                strokeColor: ColorMetrics.resourceColor(Color.White),
                strokeWidth: LengthMetrics.px(0)
              })
              .onClick(() => {
                AppStorage.setOrCreate<string>('focusId', 'CameraSettings');
                if (this.getSupportedCamerasFnconnectionType()) {
                  router.pushUrl({
                    url: 'pages/CameraSettingsPage'
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.pleaseConnectCamera'),
                    duration: 2000,
                  });
                }
              });
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ right: '92lpx', top: '75lpx' })
          .visibility(this.isRecording || this.isRecordingSecond || !this.isModeBol ? Visibility.None :
            Visibility.Visible)
        }

        modeSwitchPage({
          isVideo:this.isVideo,
          isCameraRecordingBack: this.isCameraRecordingBack,
          leftToTotal: this.leftToTotal,
          upToTotal: this.rightToTotal,
          surfaceId: this.surfaceId,
          surfaceIdSecond: this.surfaceIdSecond,
          currentCameraId: $currentCameraId,
          countdownNum: $countdownNum,
          videoRecodeTime: $videoRecodeTime,
          videoRecodeTimeSecond: $videoRecodeTimeSecond,
          onShow: $onShow,
          modelBagCol: $modelBagCol,
          isRecording: this.isRecording,
          isRecordingSecond: $isRecordingSecond,
          isModeBol: $isModeBol,
          cameraRotate: $rotateAngle,
          photoMirror: $photoMirror,
        });
      }
      .width('100%')
      .height('100%')

      if (this.onShow) {
        // 如果是从多相机页面进入，显示返回按钮和相机信息
        if (this.fromMultiCamera) {
          Row() {
            // 当前相机信息
            Text(`当前相机: ${this.selectedCameraId} (索引: ${this.selectedCameraIndex})`)
              .fontSize('14fp')
              .fontColor(Color.White)
              .backgroundColor('rgba(0, 0, 0, 0.5)')
              .padding('8lpx')
              .borderRadius('5lpx')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: '150lpx' })
          .visibility(this.isRecording || this.isRecordingSecond || !this.isModeBol ? Visibility.None : Visibility.Visible)
        }
      }
      if (this.videoRecodeTime > 0) {
        Row() {
          Row() {
            Text()
              .size({ width: '22lpx', height: '22lpx' })
              .backgroundColor($r('app.color.theme_color'))
              .borderRadius('11lpx')
              .textAlign(TextAlign.Center)
            Text(this.getVideoTime())
              .fontSize('40lpx')
              .fontColor('#FFFFFF')
              .margin({ left: '12lpx' }).textAlign(TextAlign.Center)
          }
          .width('248lpx')
          .height('56lpx')
          .backgroundColor('#3A3F62')
          .borderRadius('100lpx')
          .margin({ top: '28lpx' })
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
  }
}
