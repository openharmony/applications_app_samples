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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { ColorMetrics, LengthMetrics, promptAction, router } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import cameraDemo from 'libentry.so';
import Logger from '../utils/Logger';
import { CameraHotplugLogger } from '../utils/CameraHotplugLogger';
import { CameraHotplugToast } from '../utils/CameraHotplugToast';
import CameraService from '../models/CameraModel';
import { camera } from '@kit.CameraKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';

import { CamerasWrapper } from './Index';
import { SettingDataObj } from '../common/Constants';

const TAG: string = 'MultiCameraPreviewPage';

@Entry
@Component
struct MultiCameraPreviewPage {
  @State camerasArray: CamerasWrapper[] = [];
  @State currentFocusIndex: number = 0;
  @State onShow: boolean = false;
  @State isFirstLoad: boolean = true; // 添加首次加载标志位
  @State cameraInitStatus: Map<string, boolean> = new Map(); // 添加相机初始化状态跟踪
  @State activeCameraIds: Set<string> = new Set(); // 添加活跃相机ID跟踪
  
  // 设置
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

  async aboutToAppear() {
    Logger.info(TAG, 'multi_camera: MultiCameraPreviewPage aboutToAppear - 开始初始化');

    // 快速显示UI，先设置基本状态
    this.onShow = true;

    // 注册摄像头状态监听
    this.registerCameraStatusCallback();

    // 先请求权限，然后异步获取摄像头列表和初始化
    await this.requestPermissionsAndInitCameras();
  }

  // 请求权限并初始化相机列表
  private async requestPermissionsAndInitCameras() {
    try {
      Logger.info(TAG, 'multi_camera: 开始请求权限');
      // 先获取权限管理器
      const atManager = abilityAccessCtrl.createAtManager();
      const context = getContext(this) as common.UIAbilityContext;
      
      // 请求相机权限
      await atManager.requestPermissionsFromUser(context, [
        'ohos.permission.CAMERA',
        'ohos.permission.MICROPHONE',
        'ohos.permission.READ_MEDIA',
        'ohos.permission.WRITE_MEDIA',
        'ohos.permission.MEDIA_LOCATION',
        'ohos.permission.READ_IMAGEVIDEO',
        'ohos.permission.WRITE_IMAGEVIDEO',
        'ohos.permission.DISTRIBUTED_DATASYNC'
      ]);
      
      Logger.info(TAG, 'multi_camera: 权限请求完成，开始初始化相机列表');
      
      // 权限获取成功后，异步获取摄像头列表
      this.initCamerasAsync();
      
    } catch (err) {
      Logger.error(TAG, `multi_camera: 权限请求失败: ${JSON.stringify(err)}`);
      // 即使权限失败也尝试获取相机列表
      this.initCamerasAsync();
    }
  }

  // 注册摄像头状态回调
  private registerCameraStatusCallback() {
    CameraHotplugLogger.logUserAction('MultiCameraPreviewPage', 'REGISTER_CALLBACK', '', '注册摄像头状态回调');
    Logger.info(TAG, 'multi_camera: 注册摄像头状态回调');

    cameraDemo.cameraStatusCallBack((cameraId, deviceStatus) => {
      // 获取摄像头设备信息
      const cameraDevice = this.getCameraDeviceById(cameraId);

      // 记录状态变化日志
      const statusText = deviceStatus.toString() == '1' ? 'DISCONNECTED' : 'CONNECTED';
      CameraHotplugLogger.logCameraStatusChange('MultiCameraPreviewPage', cameraId, 'UNKNOWN', statusText);
      Logger.info(TAG, `multi_camera: 摄像头状态变化 - ID: ${cameraId}, 状态: ${deviceStatus}`);

      if (deviceStatus.toString() == '1') {
        // 摄像头断开
        CameraHotplugLogger.logCameraDisconnected('MultiCameraPreviewPage', cameraId, cameraDevice);
        Logger.info(TAG, `multi_camera: 摄像头断开: ${cameraId}`);
        this.handleCameraDisconnectedInMultiMode(cameraId, cameraDevice);
      } else if (deviceStatus.toString() == '0') {
        // 摄像头连接
        CameraHotplugLogger.logCameraConnected('MultiCameraPreviewPage', cameraId, cameraDevice);
        Logger.info(TAG, `multi_camera: 摄像头连接: ${cameraId}`);
        this.handleCameraConnectedInMultiMode(cameraId, cameraDevice);
      }
    });
  }

  // 根据摄像头ID获取摄像头设备信息
  private getCameraDeviceById(cameraId: string): camera.CameraDevice | undefined {
    try {
      const supportedCameras = CameraService.getSupportedCameras();
      return supportedCameras.find(camera => camera.cameraId === cameraId);
    } catch (err) {
      Logger.error(TAG, `getCameraDeviceById: 获取摄像头设备信息失败: ${JSON.stringify(err)}`);
      return undefined;
    }
  }

  // 处理多路模式下摄像头断开
  private handleCameraDisconnectedInMultiMode(cameraId: string, cameraDevice?: camera.CameraDevice) {
    CameraHotplugLogger.logUserAction('MultiCameraPreviewPage', 'HANDLE_DISCONNECT', cameraId, '处理多路模式摄像头断开');
    Logger.info(TAG, `multi_camera: 处理摄像头断开 ${cameraId}, 页面显示状态: ${this.onShow}`);

    // 只有当前页面显示时才处理热插拔事件
    if (!this.onShow) {
      Logger.info(TAG, `multi_camera: 页面未显示，跳过摄像头断开处理: ${cameraId}`);
      return;
    }

    // 显示断开提示
    CameraHotplugToast.showCameraDisconnected(cameraId, cameraDevice, '多路模式');

    // 从活跃相机列表中移除
    this.activeCameraIds.delete(cameraId);
    CameraHotplugLogger.logCameraReleased('MultiCameraPreviewPage', cameraId, '摄像头断开');

    // 刷新摄像头列表和UI
    setTimeout(() => {
      this.refreshCameraListAndUI();
    }, 500);
  }

  // 处理多路模式下摄像头连接
  private handleCameraConnectedInMultiMode(cameraId: string, cameraDevice?: camera.CameraDevice) {
    CameraHotplugLogger.logUserAction('MultiCameraPreviewPage', 'HANDLE_CONNECT', cameraId, '处理多路模式摄像头连接');
    Logger.info(TAG, `multi_camera: 处理摄像头连接 ${cameraId}, 页面显示状态: ${this.onShow}`);

    // 只有当前页面显示时才处理热插拔事件
    if (!this.onShow) {
      Logger.info(TAG, `multi_camera: 页面未显示，跳过摄像头连接处理: ${cameraId}`);
      return;
    }

    // 显示连接提示
    CameraHotplugToast.showCameraConnected(cameraId, cameraDevice, '多路模式');

    // 刷新摄像头列表和UI
    setTimeout(() => {
      this.refreshCameraListAndUI();
    }, 500);
  }

  // 刷新摄像头列表和UI
  private refreshCameraListAndUI() {
    CameraHotplugLogger.logUserAction('MultiCameraPreviewPage', 'REFRESH_UI', '', '刷新摄像头列表和UI');
    Logger.info(TAG, 'multi_camera: 刷新摄像头列表和UI');

    try {
      // 记录旧的摄像头数量
      const oldCount = this.camerasArray.length;
      const oldCameraIds = this.camerasArray.map(cam => cam.cameraId);

      // 重新获取摄像头列表
      const supportedCameras = CameraService.getSupportedCameras();
      const newCount = supportedCameras.length;
      const newCameraIds = supportedCameras.map(cam => cam.cameraId);

      CameraHotplugLogger.logCameraListUpdated('MultiCameraPreviewPage', oldCount, newCount, newCameraIds);
      Logger.info(TAG, `multi_camera: 刷新后获取到${newCount}个相机设备`);

      // 更精确地检测摄像头变化类型
      const isAddingFourthCamera = (oldCount === 3 && newCount === 4);
      const isRemovingFromFour = (oldCount === 4 && newCount === 3);
      const isMinorChange = Math.abs(oldCount - newCount) === 1; // 只有一个摄像头的变化

      Logger.info(TAG, `multi_camera: 摄像头变化分析 - 添加第四个: ${isAddingFourthCamera}, 从四个移除: ${isRemovingFromFour}, 轻微变化: ${isMinorChange}`);

      // 显示列表更新提示
      if (oldCount !== newCount) {
        CameraHotplugToast.showCameraListUpdated(oldCount, newCount, '多路模式');
      }

      // 智能释放策略：根据变化类型选择最优策略
      if (isMinorChange && (isAddingFourthCamera || isRemovingFromFour)) {
        Logger.info(TAG, 'multi_camera: 检测到轻微摄像头变化，使用增量更新策略');

        if (isRemovingFromFour) {
          // 从四个摄像头移除一个：找出被移除的摄像头并释放
          const removedCameraIds = oldCameraIds.filter(id => !newCameraIds.includes(id));
          Logger.info(TAG, `multi_camera: 检测到被移除的摄像头: ${removedCameraIds.join(', ')}`);

          for (const removedId of removedCameraIds) {
            try {
              CameraHotplugLogger.logCameraReleased('MultiCameraPreviewPage', removedId, '增量移除');
              cameraDemo.releaseSession(removedId);
              this.cameraInitStatus.set(removedId, false);
              this.activeCameraIds.delete(removedId);
            } catch (err) {
              Logger.warn(TAG, `multi_camera: 释放被移除摄像头session失败: ${removedId}`);
            }
          }

          // 不需要释放其他摄像头，它们应该继续工作
          Logger.info(TAG, 'multi_camera: 保持其他摄像头继续运行');
        } else if (isAddingFourthCamera) {
          // 添加第四个摄像头：不释放现有摄像头，只需要初始化新的
          Logger.info(TAG, 'multi_camera: 添加第四个摄像头，保持现有摄像头运行');
        }
      } else {
        // 重大变化：释放所有相机session
        Logger.info(TAG, 'multi_camera: 检测到重大摄像头变化，释放所有session');
        for (let i = 0; i < this.camerasArray.length; i++) {
          const cameraId = this.camerasArray[i].cameraId;
          try {
            CameraHotplugLogger.logCameraReleased('MultiCameraPreviewPage', cameraId, '重大变化释放');
            cameraDemo.releaseSession(cameraId);
            this.cameraInitStatus.set(cameraId, false);
          } catch (err) {
            Logger.warn(TAG, `multi_camera: 释放相机session失败: ${cameraId}`);
            CameraHotplugLogger.logError('MultiCameraPreviewPage', 'RELEASE_SESSION', cameraId, err.toString());
          }
        }
        // 清空活跃相机列表
        this.activeCameraIds.clear();
      }

      // 重新初始化摄像头列表
      if (isMinorChange && (isAddingFourthCamera || isRemovingFromFour)) {
        // 增量更新：只更新摄像头列表，不清空活跃列表
        Logger.info(TAG, 'multi_camera: 执行增量摄像头列表更新');
        this.initCamerasAsync(true); // 传入增量更新标志
      } else {
        // 完全重新初始化
        Logger.info(TAG, 'multi_camera: 执行完全摄像头列表重新初始化');
        this.initCamerasAsync(false);
      }

    } catch (err) {
      Logger.error(TAG, `multi_camera: 刷新摄像头列表失败: ${JSON.stringify(err)}`);
      CameraHotplugLogger.logError('MultiCameraPreviewPage', 'REFRESH_UI', '', err.toString());
    }
  }

  // 异步初始化摄像头列表
  private async initCamerasAsync(isIncrementalUpdate: boolean = false) {
    try {
      Logger.info(TAG, `multi_camera: 开始初始化相机列表 - 增量更新: ${isIncrementalUpdate}`);
      // 添加小延迟确保UI先显示
      await new Promise<void>(resolve => setTimeout(resolve, 100));

      const supportedCameras = CameraService.getSupportedCameras();

      // 检查相机列表是否有效
      if (!supportedCameras || supportedCameras.length === 0) {
        Logger.error(TAG, 'multi_camera: 无法获取相机列表或相机列表为空');
        this.camerasArray = [];
        return;
      }

      Logger.info(TAG, `multi_camera: 获取到${supportedCameras.length}个相机设备`);
      
      // 修复类型错误：使用简单的过滤方法
      const validCameras: CamerasWrapper[] = [];
      supportedCameras.forEach((item, index) => {
        // 添加空值检查，确保所有属性都存在
        if (item && item.cameraId) {
          const temp: CamerasWrapper = new CamerasWrapper(
            item.cameraId,
            item.cameraPosition,
            item.cameraType,
            item.connectionType,
            item.hostDeviceName,
            item.hostDeviceType,
            item.cameraOrientation,
            new XComponentController(),
            ''
          )
          validCameras.push(temp);
          
          // 初始化相机状态跟踪
          this.cameraInitStatus.set(item.cameraId, false);
          
          Logger.info(TAG, `multi_camera: 相机 ${index} 详细信息:`);
          Logger.info(TAG, `multi_camera:   - cameraId: ${item.cameraId}`);
          Logger.info(TAG, `multi_camera:   - cameraPosition: ${item.cameraPosition}`);
          Logger.info(TAG, `multi_camera:   - cameraType: ${item.cameraType}`);
          Logger.info(TAG, `multi_camera:   - connectionType: ${item.connectionType}`);
          Logger.info(TAG, `multi_camera:   - hostDeviceName: ${item.hostDeviceName}`);
          Logger.info(TAG, `multi_camera:   - hostDeviceType: ${item.hostDeviceType}`);
        } else {
          Logger.error(TAG, `multi_camera: 发现无效的相机设备信息 at index ${index}`);
        }
      });
      
      this.camerasArray = validCameras;
      Logger.info(TAG, `multi_camera: 成功创建${this.camerasArray.length}个有效相机包装器`);

      // 根据更新类型决定是否释放旧session
      if (!isIncrementalUpdate) {
        // 完全重新初始化：释放旧相机session
        Logger.info(TAG, 'multi_camera: 完全重新初始化，释放旧session');
        this.releaseOldSessionsAsync();
      } else {
        // 增量更新：跳过释放，只初始化新增的摄像头
        Logger.info(TAG, 'multi_camera: 增量更新，只初始化新增的摄像头');
        setTimeout(() => {
          this.incrementalInitializeCameras();
        }, 200);
      }
      
    } catch (err) {
      Logger.error(TAG, `multi_camera: 初始化摄像头列表失败: ${JSON.stringify(err)}`);
      this.camerasArray = []; // 确保数组不是undefined
    }
  }

  // 异步释放旧相机session
  private async releaseOldSessionsAsync() {
    try {
      Logger.info(TAG, 'multi_camera: 开始释放旧相机session');
      for (let i = 0; i < this.camerasArray.length; i++) {
        const cameraId = this.camerasArray[i].cameraId;
        Logger.info(TAG, `multi_camera: 释放相机 ${i} (${cameraId}) 的旧session`);
        cameraDemo.releaseSession(cameraId);
      }
      Logger.info(TAG, 'multi_camera: 已释放所有旧相机session');
    } catch (err) {
      Logger.error(TAG, `multi_camera: 释放旧相机session失败: ${JSON.stringify(err)}`);
    }
  }

  // 页面重新显示的生命周期方法
  onPageShow() {
    Logger.info(TAG, 'multi_camera: MultiCameraPreviewPage onPageShow - 重新初始化相机');
    this.onShow = true;

    // 重新注册摄像头状态回调，确保热插拔功能正常
    this.registerCameraStatusCallback();

    // 只有非首次加载才执行重新初始化逻辑
    if (!this.isFirstLoad) {
      Logger.info(TAG, 'multi_camera: 非首次加载，执行重新初始化逻辑');
      // 重置焦点状态
      this.currentFocusIndex = 0;

      // 先释放所有相机session，然后重新初始化
      setTimeout(() => {
        this.reinitializeAllCameras();
      }, 100);
    } else {
      // 首次加载，标记为非首次
      this.isFirstLoad = false;
      Logger.info(TAG, 'multi_camera: 首次加载，跳过onPageShow初始化');
    }
  }

  // 增量初始化摄像头（只初始化新增的摄像头）
  private incrementalInitializeCameras() {
    try {
      Logger.info(TAG, 'multi_camera: 开始增量初始化摄像头');

      // 获取当前活跃的摄像头ID列表
      const activeCameraIdArray = Array.from(this.activeCameraIds);
      Logger.info(TAG, `multi_camera: 当前活跃摄像头数量: ${this.activeCameraIds.size}`);
      Logger.info(TAG, `multi_camera: 当前活跃摄像头: ${activeCameraIdArray.join(', ')}`);
      Logger.info(TAG, `multi_camera: 当前摄像头数组长度: ${this.camerasArray.length}`);

      // 找出需要初始化的新摄像头
      const camerasToInit: CamerasWrapper[] = [];
      const indexesToInit: number[] = [];

      this.camerasArray.forEach((camera, index) => {
        Logger.info(TAG, `multi_camera: 检查摄像头 ${index} (${camera.cameraId}) - surfaceId: ${camera.surfaceId ? '有' : '无'}`);
        if (!this.activeCameraIds.has(camera.cameraId)) {
          Logger.info(TAG, `multi_camera: 发现需要初始化的新摄像头: ${index} (${camera.cameraId})`);
          camerasToInit.push(camera);
          indexesToInit.push(index);
        } else {
          Logger.info(TAG, `multi_camera: 摄像头 ${index} (${camera.cameraId}) 已经活跃，跳过初始化`);
        }
      });

      if (camerasToInit.length === 0) {
        Logger.info(TAG, 'multi_camera: 没有需要初始化的新摄像头');
        return;
      }

      // 等待XComponent加载完成后再初始化
      this.waitForSurfaceIdAndInit(camerasToInit, indexesToInit);

    } catch (err) {
      Logger.error(TAG, `multi_camera: 增量初始化摄像头失败: ${JSON.stringify(err)}`);
    }
  }

  // 等待surfaceId准备好后初始化摄像头
  private waitForSurfaceIdAndInit(camerasToInit: CamerasWrapper[], indexesToInit: number[]) {
    Logger.info(TAG, `multi_camera: 等待 ${camerasToInit.length} 个新摄像头的surfaceId准备完成`);

    const checkAndInit = (retryCount: number = 0) => {
      if (retryCount > 20) { // 最多等待2秒
        Logger.error(TAG, 'multi_camera: 等待surfaceId超时，停止初始化');
        return;
      }

      let allReady = true;
      for (let i = 0; i < camerasToInit.length; i++) {
        const camera = camerasToInit[i];
        if (!camera.surfaceId || camera.surfaceId.length === 0) {
          allReady = false;
          break;
        }
      }

      if (allReady) {
        Logger.info(TAG, 'multi_camera: 所有新摄像头的surfaceId已准备完成，开始初始化');
        for (let i = 0; i < camerasToInit.length; i++) {
          const camera = camerasToInit[i];
          const index = indexesToInit[i];
          const delay = 100 * i; // 新摄像头之间100ms间隔
          setTimeout(() => {
            Logger.info(TAG, `multi_camera: 初始化新摄像头 ${index} (${camera.cameraId})，延时: ${delay}ms`);
            this.initSingleCamera(camera, index, '增量初始化');
          }, delay);
        }
      } else {
        Logger.info(TAG, `multi_camera: surfaceId未准备完成，重试 ${retryCount + 1}/20`);
        setTimeout(() => {
          checkAndInit(retryCount + 1);
        }, 100);
      }
    };

    // 延迟一点时间开始检查，给XComponent一些加载时间
    setTimeout(() => {
      checkAndInit();
    }, 200);
  }

  // 重新初始化所有相机
  private reinitializeAllCameras() {
    try {
      Logger.info(TAG, 'multi_camera: 开始重新初始化所有相机');
      
      // 先释放所有相机session
      for (let i = 0; i < this.camerasArray.length; i++) {
        const cameraId = this.camerasArray[i].cameraId;
        Logger.info(TAG, `multi_camera: 释放相机 ${i} (${cameraId}) session`);
        cameraDemo.releaseSession(cameraId);
        this.cameraInitStatus.set(cameraId, false);
      }
      
      // 清空活跃相机ID集合
      this.activeCameraIds.clear();
      
      // 延时后重新初始化所有相机
      setTimeout(() => {
        Logger.info(TAG, 'multi_camera: 开始逐个重新初始化相机');
        this.camerasArray.forEach((camera, index) => {
          if (camera.surfaceId) {
            // 优化延时策略：减少延时，但确保第四个摄像头有足够的资源
            const delay = index < 3 ? 100 * index : 200 * index; // 前3个摄像头100ms间隔，第4个摄像头200ms间隔
            setTimeout(() => {
              Logger.info(TAG, `multi_camera: 准备初始化相机 ${index} (${camera.cameraId})，延时: ${delay}ms`);
              this.initSingleCamera(camera, index, '重新初始化');
            }, delay);
          } else {
            Logger.warn(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) 没有surfaceId，跳过初始化`);
          }
        });

        // 重新设置焦点 - 减少等待时间
        const totalDelay = this.camerasArray.length <= 3 ? 100 * this.camerasArray.length + 300 : 200 * 3 + 300;
        setTimeout(() => {
          this.resetFocusSystem();
        }, totalDelay);

      }, 200);
      
    } catch (err) {
      Logger.error(TAG, `multi_camera: 重新初始化所有相机失败: ${JSON.stringify(err)}`);
    }
  }

  // 重置焦点系统
  private resetFocusSystem() {
    try {
      Logger.info(TAG, 'multi_camera: 开始重置焦点系统');
      
      // 重置焦点控制器
      this.getUIContext().getFocusController().activate(false);
      this.getUIContext().getFocusController().activate(true, true);
      Logger.info(TAG, 'multi_camera: 焦点控制器已强制重置并重新激活');

    } catch (err) {
      Logger.error(TAG, `multi_camera: 焦点控制器激活失败: ${JSON.stringify(err)}`);
      // 添加备用方案：至少设置当前焦点索引
      this.currentFocusIndex = 0;
    }
  }

  // 添加页面隐藏的生命周期方法
  onPageHide() {
    Logger.info(TAG, 'multi_camera: MultiCameraPreviewPage onPageHide');
    this.onShow = false;
  }

  getSupportedCamerasFn(): Boolean {
    const result = this.camerasArray.length >= 1;
    Logger.info(TAG, `multi_camera: getSupportedCamerasFn返回: ${result}, 相机数量: ${this.camerasArray.length}`);
    return result;
  }

  // 选择相机方法
  selectCamera(camera: CamerasWrapper, index: number) {
    Logger.info(TAG, `multi_camera: 选择相机: ${camera.cameraId}, index: ${index}`);
    Logger.info(TAG, `multi_camera: 相机位置: ${camera.cameraPosition}, 相机类型: ${camera.cameraType}`);
    
    // 记录当前活跃相机状态
    const activeCount = this.activeCameraIds.size;
    Logger.info(TAG, `multi_camera: 当前活跃相机数量: ${activeCount}`);
    this.activeCameraIds.forEach(cameraId => {
      Logger.info(TAG, `multi_camera: 活跃相机ID: ${cameraId}`);
    });
    
    // 目前不在这里释放相机资源，让它们保持运行状态
    // 这样返回时相机资源仍然可用
    
    router.pushUrl({
      url: 'pages/Index',
      params: {
        selectedCameraId: camera.cameraId,
        selectedCameraIndex: index,
        fromMultiCamera: true,
        cameraPosition: camera.cameraPosition,
        cameraType: camera.cameraType
      }
    });
  }

  aboutToDisappear(): void {
    try {
      Logger.info(TAG, 'multi_camera: 页面即将销毁，释放所有相机资源');
      // 页面完全销毁时释放所有相机资源
      this.camerasArray.forEach((camera, index) => {
        Logger.info(TAG, `multi_camera: 释放相机 ${index} (${camera.cameraId}) 资源`);
        cameraDemo.releaseCamera(camera.cameraId);
      });
      
      // 清空状态跟踪
      this.cameraInitStatus.clear();
      this.activeCameraIds.clear();
      
      Logger.info(TAG, 'multi_camera: 页面销毁，已释放所有相机资源');
    } catch (err) {
      Logger.error(TAG, `multi_camera: 释放相机资源失败: ${JSON.stringify(err)}`);
    }
  }

  @Builder
  buildCameraPreview(camera: CamerasWrapper, index: number, width: string) {
    if (!camera || !camera.cameraId) {
      Column() {
        Text('相机无效')
          .fontSize('16fp')
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
      }
      .width(width)
      .height('100%')
      .backgroundColor(Color.Black)
      .justifyContent(FlexAlign.Center)
    } else {
      Column() {
        XComponent({
          id: `multiCamera${camera.cameraId}`,
          type: XComponentType.SURFACE,
          controller: camera.control
        })
        .width(width)
        .height('100%')
        .focusable(true)
        .id(`camera_${index}`)
        .borderRadius('6lpx')
        .onAppear(() => {
          if (index === 0) {
            this.getUIContext().getFocusController().requestFocus('camera_0');
          }
        })
        .onFocus(() => {
          this.currentFocusIndex = index;
          Logger.info(TAG, `multi_camera: 焦点切换到相机 ${index} (${camera.cameraId})`);
        })
        .onBlur(() => {
          Logger.info(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) 失去焦点`);
        })
        .defaultFocus(index === 0)
        .onLoad(async () => {
          Logger.info(TAG, `multi_camera: XComponent onLoad called for camera ${index} (${camera.cameraId})`);
          Logger.info(TAG, `multi_camera_test: XComponent onLoad - 摄像头${index} ID:${camera.cameraId}`);
          try {
            camera.surfaceId = camera.control.getXComponentSurfaceId();
            Logger.info(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) surfaceId: ${camera.surfaceId}`);
            Logger.info(TAG, `multi_camera_test: 摄像头${index} surfaceId获取结果: ${camera.surfaceId ? '成功' : '失败'} - ${camera.surfaceId}`);

            // 检查是否已经在活跃列表中
            if (this.activeCameraIds.has(camera.cameraId)) {
              Logger.info(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) 已经活跃，跳过重复初始化`);
              Logger.info(TAG, `multi_camera_test: 摄像头${index} 已在活跃列表中，跳过初始化`);
              return;
            }

            Logger.info(TAG, `multi_camera_test: 摄像头${index} 当前活跃列表: [${Array.from(this.activeCameraIds).join(', ')}]`);

            // 释放旧session
            Logger.info(TAG, `multi_camera: 释放相机 ${index} (${camera.cameraId}) 的旧session`);
            cameraDemo.releaseSession(camera.cameraId);

            // 使用优化的初始化方法
            Logger.info(TAG, `multi_camera_test: 摄像头${index} 开始调用initSingleCamera`);
            this.initSingleCamera(camera, index, 'XComponent onLoad');

          } catch (err) {
            Logger.error(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) onLoad失败: ${JSON.stringify(err)}`);
            Logger.error(TAG, `multi_camera_test: 摄像头${index} onLoad异常: ${JSON.stringify(err)}`);
          }
        })
        .onClick(() => {
          Logger.info(TAG, `multi_camera: 点击相机 ${index} (${camera.cameraId})`);
          this.selectCamera(camera, index);
        })
        .backgroundColor(Color.Black)
      }
      .border({ width: '4lpx', color: this.currentFocusIndex === index ? '#00FF00' : '#CCCCCC' })
      .borderRadius('10lpx')
      .margin('8lpx')
      .focusable(true) // 添加：确保相机预览容器可聚焦
    }
  }

  // 优化的单个相机初始化方法
  private initSingleCamera(camera: CamerasWrapper, index: number, source: string) {
    Logger.info(TAG, `multi_camera_test: initSingleCamera开始 - 摄像头${index} ID:${camera.cameraId} 来源:${source}`);

    // 检查相机是否已经在初始化中
    if (this.cameraInitStatus.get(camera.cameraId) === true) {
      Logger.warn(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) 正在初始化中，跳过重复初始化`);
      Logger.warn(TAG, `multi_camera_test: 摄像头${index} 正在初始化中，跳过`);
      return;
    }

    // 标记相机开始初始化
    this.cameraInitStatus.set(camera.cameraId, true);
    Logger.info(TAG, `multi_camera_test: 摄像头${index} 标记为初始化中`);

    // 优化延时策略：第四个摄像头使用更长延时，确保资源可用
    let delay = 0;
    if (index === 3) {
      // 第四个摄像头：使用固定延时，不依赖其他摄像头状态
      delay = 200;
      Logger.info(TAG, `multi_camera: 第四个摄像头使用固定延时策略: ${delay}ms`);
      Logger.info(TAG, `multi_camera_test: 摄像头${index} 使用固定延时: ${delay}ms`);
    } else if (index === 2) {
      // 第三个摄像头：也使用较长延时
      delay = 150;
      Logger.info(TAG, `multi_camera_test: 摄像头${index} 使用延时: ${delay}ms`);
    } else {
      // 前两个摄像头：较短延时
      delay = 50 * index;
      Logger.info(TAG, `multi_camera_test: 摄像头${index} 使用延时: ${delay}ms`);
    }

    Logger.info(TAG, `multi_camera: 计划在${delay}ms后初始化相机 ${index} (${camera.cameraId})，来源: ${source}`);
    Logger.info(TAG, `multi_camera_test: 摄像头${index} 计划延时${delay}ms后初始化`);

    setTimeout(() => {
      try {
        Logger.info(TAG, `multi_camera: 开始初始化相机 ${index} (${camera.cameraId}) surfaceId: ${camera.surfaceId}`);
        
        // 检查surfaceId是否有效
        Logger.info(TAG, `multi_camera_test: 摄像头${index} 开始检查surfaceId: ${camera.surfaceId}`);
        if (!camera.surfaceId || camera.surfaceId.length === 0) {
          Logger.error(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) surfaceId无效，跳过初始化`);
          Logger.error(TAG, `multi_camera_test: 摄像头${index} surfaceId无效，初始化失败`);
          this.cameraInitStatus.set(camera.cameraId, false);
          return;
        }
        Logger.info(TAG, `multi_camera_test: 摄像头${index} surfaceId有效，继续初始化`);
        
        // 第四个摄像头使用简化的初始化逻辑
        if (index === 3) {
          Logger.info(TAG, `multi_camera: 第四个摄像头初始化 - 当前活跃摄像头数: ${this.activeCameraIds.size}`);

          // 检查是否已经重试过多次
          const retryCount = (source.match(/ - 重试/g) || []).length;
          if (retryCount > 2) {
            Logger.error(TAG, `multi_camera: 第四个摄像头重试次数过多(${retryCount})，停止重试`);
            this.cameraInitStatus.set(camera.cameraId, false);
            return;
          }

          Logger.info(TAG, `multi_camera: 第四个摄像头直接进行初始化，重试次数: ${retryCount}`);
        }

        // 调用native初始化
        Logger.info(TAG, `multi_camera: 开始调用native初始化相机 ${index} (${camera.cameraId})`);
        Logger.info(TAG, `multi_camera: 初始化参数 - surfaceId: ${camera.surfaceId}, focusMode: ${this.settingDataObj.focusMode}, cameraId: ${camera.cameraId}`);
        Logger.info(TAG, `multi_camera_test: 摄像头${index} 开始native初始化 - surfaceId:${camera.surfaceId} focusMode:${this.settingDataObj.focusMode}`);

        const initResult = cameraDemo.initCamera(camera.surfaceId, this.settingDataObj.focusMode, camera.cameraId);
        Logger.info(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) native初始化返回值: ${initResult}`);
        Logger.info(TAG, `multi_camera_test: 摄像头${index} native初始化返回值: ${initResult}`);

        if (initResult === 0) {
          // 初始化成功
          this.activeCameraIds.add(camera.cameraId);
          Logger.info(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) native初始化成功`);
          Logger.info(TAG, `multi_camera: 当前活跃相机数量: ${this.activeCameraIds.size}`);
          Logger.info(TAG, `multi_camera_test: 摄像头${index} 初始化成功，添加到活跃列表`);
          Logger.info(TAG, `multi_camera_test: 当前活跃摄像头列表: [${Array.from(this.activeCameraIds).join(', ')}]`);

          // 避免强制UI更新，因为这会导致XComponent重新创建
          Logger.info(TAG, `multi_camera_test: 摄像头${index} 跳过UI更新，避免XComponent重新创建`);

          // 第四个摄像头需要更长的稳定时间
          const stabilizeTime = index === 3 ? 300 : 100;
          setTimeout(() => {
            this.cameraInitStatus.set(camera.cameraId, false);
            Logger.info(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) 初始化状态重置完成`);
            Logger.info(TAG, `multi_camera_test: 摄像头${index} 初始化状态重置完成`);
          }, stabilizeTime);
        } else {
          // 初始化失败
          Logger.error(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) native初始化失败，返回值: ${initResult}`);
          Logger.error(TAG, `multi_camera_test: 摄像头${index} 初始化失败，返回值: ${initResult}`);
          this.cameraInitStatus.set(camera.cameraId, false);

          // 初始化失败时，尝试恢复
          setTimeout(() => {
            Logger.info(TAG, `multi_camera: 尝试恢复相机 ${index} (${camera.cameraId})`);
            Logger.info(TAG, `multi_camera_test: 摄像头${index} 开始恢复流程`);
            this.recoverCamera(camera, index);
          }, 1000);
        }
        
      } catch (err) {
        Logger.error(TAG, `multi_camera: 相机 ${index} (${camera.cameraId}) 初始化失败: ${JSON.stringify(err)}`);
        this.cameraInitStatus.set(camera.cameraId, false);
        
        // 初始化失败时，尝试恢复
        setTimeout(() => {
          Logger.info(TAG, `multi_camera: 尝试恢复相机 ${index} (${camera.cameraId})`);
          this.recoverCamera(camera, index);
        }, 1000);
      }
    }, delay);
  }

  // 相机恢复方法
  private recoverCamera(camera: CamerasWrapper, index: number) {
    try {
      Logger.info(TAG, `multi_camera: 开始恢复相机 ${index} (${camera.cameraId})`);
      
      // 先释放资源
      cameraDemo.releaseSession(camera.cameraId);
      
      // 等待一段时间后重新初始化
      setTimeout(() => {
        if (camera.surfaceId && camera.surfaceId.length > 0) {
          Logger.info(TAG, `multi_camera: 重新初始化恢复的相机 ${index} (${camera.cameraId})`);
          cameraDemo.initCamera(camera.surfaceId, this.settingDataObj.focusMode, camera.cameraId);
          this.activeCameraIds.add(camera.cameraId);
        }
      }, 500);
      
    } catch (err) {
      Logger.error(TAG, `multi_camera: 恢复相机 ${index} (${camera.cameraId}) 失败: ${JSON.stringify(err)}`);
    }
  }

  @Builder 
  buildCamerasLayout() {
    if (!this.camerasArray || this.camerasArray.length === 0) {
      Column() {
        Text('暂无可用相机')
          .fontSize('20fp')
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
      .justifyContent(FlexAlign.Center)
      .focusable(true) // 添加：确保容器可聚焦
    } else if (this.camerasArray.length === 1) {
      // 单相机模式：缩小到85%，居中显示，为UI预留空间
      Column() {
        this.buildCameraPreview(this.camerasArray[0], 0, '85%');
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ top: '5%', bottom: '5%', left: '7.5%', right: '7.5%' })
      .focusable(true) // 添加：确保容器可聚焦
    } else if (this.camerasArray.length === 2) {
      // 双相机模式：缩小宽度到45%，增加间距
      Row() {
        ForEach(this.camerasArray, (item: CamerasWrapper, index) => {
          this.buildCameraPreview(item, index, '45%');
        });
      }
      .width('100%')
      .height('90%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(VerticalAlign.Center)
      .padding({ top: '5%', bottom: '5%', left: '2.5%', right: '2.5%' })
      .focusable(true) // 添加：确保容器可聚焦
    } else {
      // 多相机模式：缩小高度到45%，调整布局
      Column() {
        Row() {
          this.buildCameraPreview(this.camerasArray[0], 0, '45%');
          this.buildCameraPreview(this.camerasArray[1], 1, '45%');
        }
        .width('100%')
        .height('45%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .alignItems(VerticalAlign.Center)
        .focusable(true) // 添加：确保Row可聚焦
    
        Row() {
          ForEach(this.camerasArray.slice(2), (item: CamerasWrapper, forEachIndex) => {
            this.buildCameraPreview(item, forEachIndex + 2, '45%');
          });
        }
        .width('100%')
        .height('45%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .alignItems(VerticalAlign.Center)
        .focusable(true) // 添加：确保Row可聚焦
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignItems(HorizontalAlign.Center)
      .padding({ top: '2.5%', bottom: '2.5%', left: '2.5%', right: '2.5%' })
      .focusable(true) // 添加：确保Column可聚焦
    }
  }

  build() {
    Column() {
      this.buildCamerasLayout();
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    .focusable(true) // 添加：确保父组件可聚焦
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE || event.keyCode == KeyCode.KEYCODE_BACK) {
        Logger.info(TAG, 'multi_camera: 按下返回键，退出应用');
        (getContext() as common.UIAbilityContext).terminateSelf();
      } else if (event.keyCode == KeyCode.KEYCODE_DPAD_CENTER || event.keyCode == KeyCode.KEYCODE_ENTER) {
        if (this.currentFocusIndex < this.camerasArray.length) {
          Logger.info(TAG, `multi_camera: 按下确认键，选择相机 ${this.currentFocusIndex}`);
          this.selectCamera(this.camerasArray[this.currentFocusIndex], this.currentFocusIndex);
        }
      }
    });
  }
} 
