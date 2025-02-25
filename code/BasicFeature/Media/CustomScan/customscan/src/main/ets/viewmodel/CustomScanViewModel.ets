/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { display, promptAction, window } from '@kit.ArkUI';
import { customScan, detectBarcode, scanBarcode, scanCore } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

import { logger } from '../common/util/Logger';
import CommonConstants from '../common/constants/CommonConstants';
import PermissionModel from '../model/PermissionModel';
import WindowModel from '../model/WindowModel';
import { ScanSize } from '../model/ScanSize';

@Observed
export default class CustomScanViewModel {
  /**
   * 单例模型私有化构造函数，使用getInstance静态方法获得单例
   */
  private constructor() {
    // 初始化窗口管理model
    const windowStage: window.WindowStage | undefined = AppStorage.get('windowStage');
    if (windowStage) {
      this.windowModel.setWindowStage(windowStage);
    }

    // 初始化相机流尺寸
    this.updateCameraCompSize();
  }

  /**
   * CustomScanViewModel 单例
   */
  private static instance?: CustomScanViewModel;

  /**
   * 获取CustomScanViewModel单例实例
   * @returns {CustomScanViewModel} CustomScanViewModel
   */
  static getInstance(): CustomScanViewModel {
    if (!CustomScanViewModel.instance) {
      CustomScanViewModel.instance = new CustomScanViewModel();
    }

    return CustomScanViewModel.instance;
  }

  /**
   * 是否开启扫描动画
   */
  public isScanLine: Boolean = false;
  /**
   * 是否扫描成功
   */
  private isScannedRaw: boolean = false;
  get isScanned () {
    return this.isScannedRaw;
  }
  set isScanned (val: boolean) {
    this.isScannedRaw = val;
  }
  /**
   * 扫描结果
   */
  public scanResult: ScanResults = new ScanResults();
  /**
   * 扫描结果内容弹窗id
   */
  public scanResultDialogId?: number;
  /**
   * PermissionModel 单例
   */
  private permissionModel: PermissionModel = PermissionModel.getInstance();
  /**
   * WindowModel 单例
   */
  private windowModel: WindowModel = WindowModel.getInstance();

  private scanSize: ScanSize = ScanSize.getInstance();
  /**
   * 自定义扫码初始化配置参数
   */
  private customScanInitOptions: scanBarcode.ScanOptions = {
    scanTypes: [scanCore.ScanType.QR_CODE],
    enableMultiMode: true,
    enableAlbum: true
  }
  /**
   * 当前屏幕折叠态（仅折叠屏设备下有效）
   */
  public curFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  /**
   * 相机流展示组件（XComponent）的surfaceId
   */
  public surfaceId: string = '';
  /**
   * 相机流展示组件（XComponent）的宽
   */
  public cameraCompWidth: number = 0;
  /**
   * 相机流展示组件（XComponent）的高
   */
  public cameraCompHeight: number = 0;
  /**
   * 相机流展示组件（XComponent）的水平偏移位置
   */
  public cameraCompOffsetX: number = 0;
  /**
   * 相机流展示组件（XComponent）的竖直偏移位置
   */
  public cameraCompOffsetY: number = 0;
  /**
   * 相机流展示组件内容尺寸修改回调函数
   */
  public cameraCompSizeUpdateCb: Function = (): void => {
  };
  /**
   * 相机闪光灯状态更新回调函数
   */
  public cameraLightUpdateCb: Function = (): void => {
  };

  /**
   * 检测是否有相机权限，未授权尝试申请授权
   * @returns {Promise<boolean>} 相机权限/授权结果
   */
  async reqCameraPermission(): Promise<boolean> {
    const reqPermissionName = CommonConstants.PERMISSION_CAMERA;
    // 优先检测是否已授权
    let isGranted = await this.permissionModel.checkPermission(reqPermissionName);
    if (isGranted) {
      return true;
    }
    // 没有授权申请授权
    isGranted = await this.permissionModel.requestPermission(reqPermissionName);
    return isGranted;
  }

  /**
   * 当前主窗口是否开启沉浸模式
   * @param {boolean} enable 是否开启
   * @returns {void}
   */
  setMainWindowImmersive(enable: boolean): void {
    this.windowModel.setMainWindowImmersive(enable);
  }

  /**
   * 更新相机流展示组件（XComponent）的尺寸
   * @returns {void}
   */
  async updateCameraCompSize(): Promise<void> {
    // 通过窗口属性修改组件宽高
    let windowSize: window.Size | null = this.scanSize.setWindowSize();
    if (windowSize) {
      this.scanSize.setScanXComponentSize(true, windowSize)

      this.cameraCompWidth = this.scanSize.xComponentSize.width;
      this.cameraCompHeight = this.scanSize.xComponentSize.height
      this.cameraCompOffsetX = this.scanSize.xComponentSize.offsetX;
      this.cameraCompOffsetY = this.scanSize.xComponentSize.offsetY;
    }

    logger.debug(`updateCameraCompSize: width=${this.cameraCompWidth} height=${this.cameraCompHeight}`);
  }

  /**
   * 注册屏幕状态监听
   * @returns {void}
   */
  regDisplayListener(): void {
    if (display.isFoldable()) {
      // 监听折叠屏状态变更，更新折叠态，修改窗口显示方向
      display.on('foldStatusChange', async (curFoldStatus: display.FoldStatus) => {
        // 无视FOLD_STATUS_UNKNOWN状态
        if (curFoldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN) {
          return;
        }
        // FOLD_STATUS_HALF_FOLDED状态当作FOLD_STATUS_EXPANDED一致处理
        if (curFoldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
          curFoldStatus = display.FoldStatus.FOLD_STATUS_EXPANDED;
        }
        // 同一个状态重复触发不做处理
        if (this.curFoldStatus === curFoldStatus) {
          return;
        }

        // 缓存当前折叠状态
        this.curFoldStatus = curFoldStatus;

        // 当前没有相机流资源，只更新相机流宽高设置
        if (!this.surfaceId) {
          this.updateCameraCompSize();
          return;
        }

        // 关闭闪光灯
        this.tryCloseFlashLight();
        setTimeout(() => {
          // 重新启动扫码
          this.restartCustomScan();
        }, 10)
      })
    }
  }

  /**
   * 注册相机流展示组件内容尺寸修改回调函数
   * @param {Function} callback 相机流展示组件内容尺寸修改回调函数
   * @returns {void}
   */
  regXCompSizeUpdateListener(callback: Function): void {
    this.cameraCompSizeUpdateCb = callback;
  }

  /**
   * 注册相机闪光灯状态更新回调函数
   * @param {Function} callback 相机闪光灯状态更新回调函数
   * @returns {void}
   */
  regCameraLightUpdateListener(callback: Function): void {
    this.cameraLightUpdateCb = callback;
  }

  /**
   * 更新相机闪光灯状态
   * @returns {void}
   */
  updateFlashLightStatus(): void {
    // 根据当前闪光灯状态，选择打开或关闭闪关灯
    try {
      let isCameraLightOpen: boolean = false;
      if (customScan.getFlashLightStatus()) {
        customScan.closeFlashLight();
        isCameraLightOpen = false;
      } else {
        customScan.openFlashLight();
        isCameraLightOpen = true;
      }

      this.cameraLightUpdateCb(isCameraLightOpen);
    } catch (error) {
      logger.error('flashLight control failed, error: ' + JSON.stringify(error));
    }
  }

  /**
   * 尝试把开启的闪光灯关闭
   * @returns {void}
   */
  tryCloseFlashLight() {
    try {
      // 闪光灯标记移除
      this.cameraLightUpdateCb(false);
      // 如果闪光灯开启，则关闭
      if (customScan.getFlashLightStatus()) {
        customScan.closeFlashLight();
      }
    } catch (error) {
      logger.error('flashLight try close failed, error: ' + JSON.stringify(error));
    }
  }

  /**
   * 自定义扫码数据初始化
   * @returns {void}
   */
  initScanData() {
    this.isScanLine = false;
    this.isScanned = false;
    this.scanResult = {} as ScanResults;
  }

  /**
   * 初始化自定义扫码
   * @returns {void}
   */
  initCustomScan(): void {
    logger.info('initCustomScan');
    try {
      this.initScanData()
      customScan.init(this.customScanInitOptions);
      this.startCustomScan();
    } catch (error) {
      logger.error('init fail, error: ' + JSON.stringify(error));
    }
  }

  /**
   * 启动自定义扫码
   * @returns {void}
   */
  startCustomScan(): void {
    logger.info('startCustomScan');
    try {
      const viewControl: customScan.ViewControl = {
        width: this.cameraCompWidth,
        height: this.cameraCompHeight,
        surfaceId: this.surfaceId
      };
      customScan.start(viewControl).then((result) => {
        // TODO：知识点 请求扫码结果，通过Promise触发回调
        this.customScanCallback(result);
      }).catch((error: BusinessError) => {
        logger.error('customScan start failed error: ' + JSON.stringify(error));
      })
      this.isScanLine = true;
    } catch (error) {
      logger.error('startCustomScan failed error: ' + JSON.stringify(error));
    }
  }

  /**
   * 重新触发一次扫码（仅能使用在customScan.start的异步回调中）
   * @returns {void}
   */
  reCustomScan(): void {
    try {
      customScan.rescan();
    } catch (error) {
      logger.error('reCustomScan failed error: ' + JSON.stringify(error));
    }
  }

  /**
   * 停止自定义扫码
   * @returns {void}
   */
  stopCustomScan(): void {
    // 关闭相机闪光灯
    this.tryCloseFlashLight();

    // 关闭自定义扫码
    try {
      this.isScanLine = false;
      customScan.stop().then(() => {
      }).catch((error: BusinessError) => {
        logger.error('customScan stop failed error: ' + JSON.stringify(error));
      })
    } catch (error) {
      logger.error('stopCustomScan: stop error: ' + JSON.stringify(error));
    }
  }

  /**
   * 释放自定义扫码资源
   * @returns {Promise<void>}
   */
  async releaseCustomScan(): Promise<void> {
    logger.info('releaseCustomScan');
    try {
      await customScan.release();
    } catch (error) {
      logger.error('Catch: release error: ' + JSON.stringify(error));
    }
  }

  /**
   * 重新启动扫码
   * @returns {void}
   */
  async restartCustomScan(): Promise<void> {
    logger.info('restartCustomScan');
    // 关闭存在的扫描结果对话框
    this.closeScanResult();
    // 根据窗口尺寸调整展示组件尺寸
    await this.updateCameraCompSize();
    // 调整相机surface尺寸
    this.cameraCompSizeUpdateCb(this.cameraCompWidth,
                                this.cameraCompHeight,
                                this.cameraCompOffsetX,
                                this.cameraCompOffsetY);
    // 释放扫码资源
    await this.releaseCustomScan();
    // 初始化相机资源并启动
    this.initCustomScan();
  }

  /**
   * 扫码结果回调
   * @param {scanBarcode.ScanResult[]} result 扫码结果数据
   * @returns {void}
   */
  customScanCallback(result: scanBarcode.ScanResult[]): void {
    if (!this.isScanned) {
      this.scanResult.code = 0;
      this.scanResult.data = result || [];
      let resultLength: number = result ? result.length : 0;
      if (resultLength) {
        // 停止扫描
        this.stopCustomScan();
        // 标记扫描状态，触发UI刷新
        this.isScanned = true;
        this.scanResult.size = resultLength;
      } else {
        // 重新扫码
        this.reCustomScan()
      }
    }
  }

  /**
   * 关闭扫码结果
   * @returns {void}
   */
  closeScanResult(): void {
    logger.info('closeScanResult');
    if (this.scanResultDialogId) {
      promptAction.closeCustomDialog(this.scanResultDialogId);
      this.scanResultDialogId = undefined;
    }
  }

  /**
   * 打开系统相册，选择照片进行二维码识别
   * @returns {string}
   */
  async detectFromPhotoPicker(): Promise<string> {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    photoSelectOptions.maxSelectNumber = 1;
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    const photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoViewPicker.select(photoSelectOptions);
    const uris: string[] = photoSelectResult.photoUris;
    if (uris.length === 0) {
      return '';
    }

    // 识别结果
    let retVal = CommonConstants.DETECT_NO_RESULT;
    const inputImage: detectBarcode.InputImage = { uri: uris[0] };
    try {
      // 定义识码参数options
      let options: scanBarcode.ScanOptions = {
        scanTypes: [scanCore.ScanType.QR_CODE],
        enableMultiMode: true,
        enableAlbum: true,
      }
      // 调用图片识码接口
      const decodeResult: scanBarcode.ScanResult[] = await detectBarcode.decode(inputImage, options);
      if (decodeResult.length > 0) {
        retVal = decodeResult[0].originalValue;
      }
      logger.error('[customscan]', `Failed to get ScanResult by promise with options.`);
    } catch (error) {
      logger.error('[customscan]', `Failed to detectBarcode. Code: ${error.code}, message: ${error.message}`);
    }

    // 停止扫描
    this.stopCustomScan();
    return retVal;
  }
}

@Observed
export class ScanResults {
  public code: number;
  public data: scanBarcode.ScanResult[];
  public size: number;
  public uri: string;

  constructor() {
    this.code = 0;
    this.data = [];
    this.size = 0;
    this.uri = '';
  }
}


