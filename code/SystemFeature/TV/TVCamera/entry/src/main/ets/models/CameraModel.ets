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

import { getGlobalObject } from '../utils/GlobalThis';
import Logger from '../utils/Logger';
import { camera } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { promptAction } from '@kit.ArkUI';
import { fileIo as fs } from '@kit.CoreFileKit';
import MediaUtils from '../model/MediaUtils';
import { Constants } from '../common/Constants';
// 当前版本未接入用户文件管理模块

const NORMAL_PHOTO = camera.SceneMode.NORMAL_PHOTO; // 普通拍照模式(API 12 不支持分布式使用该模式)
// 连接类型映射：用于日志和UI展示相机的物理连接方式
// 业务背景：不同连接类型的相机在功能上可能有差异（如远端相机不支持某些本地特性）
const connectionTypeMap = new Map([
  [0, '本地相机'], // 内置相机
  [1, 'USB相机'], // USB连接的相机
  [2, '远程相机']// 远程连接的相机
]);

const cameraPositionTypeMap = new Map([
  [0, '位置未指定'], // 相机位置未指定
  [1, '后置'], // 后置相机
  [2, '前置']// 前置相机
]);

const cameraTypeMap = new Map([
  [0, '类型未指定'], // 相机类型未指定
  [1, '广角相机'],
  [2, '超广角相机'],
  [3, '长焦相机'],
  [4, '景深相机']// 带景深信息的相机
]);

const TAG = 'CameraService';

class CameraService {
  private fileAsset?: object; // 替换any类型为object类型
  private mediaUtil = MediaUtils.getInstance();
  private static instance: CameraService;
  private cameraMgr?: camera.CameraManager = undefined;
  private camerasArray?: camera.CameraDevice[] = undefined;
  private cameraInput?: camera.CameraInput = undefined;
  private previewOutput?: camera.PreviewOutput = undefined;
  private photoOutPut?: camera.PhotoOutput = undefined;
  private capSession?: camera.CaptureSession = undefined;
  private capability?: camera.CameraOutputCapability = undefined;
  private context?: common.UIAbilityContext = undefined;
  private izDistributedCapture: boolean = false;

  public static getInstance(): CameraService {
    if (!CameraService.instance) {
      CameraService.instance = new CameraService();
    }
    return CameraService.instance;
  }

  private constructor() {
    this.context = getGlobalObject('context') as common.UIAbilityContext;
  }

  /**
   * 拍照回调注册类
   * 业务背景：拍照是异步操作，需要通过回调获取拍照结果
   * 策略：注册photoAvailable事件获取图片数据，处理完成后释放Image资源避免内存泄漏
   * @param photoOutput
   */
  async setPhotoOutputCb(photoOutput: camera.PhotoOutput): Promise<void> {
    photoOutput.on('photoAvailable', (errCode: BusinessError, photo: camera.Photo): void => {
      if (errCode || photo === undefined) {
        Logger.error(TAG, 'getPhoto failed');
        return;
      }
      let imageObj: image.Image = photo.main;
      imageObj.getComponent(image.ComponentType.JPEG,
        async (errCode: BusinessError, component: image.Component): Promise<void> => {
          if (errCode || component === undefined) {
            return;
          }
          let buffer: ArrayBuffer;
          if (component.byteBuffer) {
            buffer = component.byteBuffer;
          } else {
            Logger.error(TAG, 'byteBuffer is null');
            return;
          }
          await this.saveImage(buffer, imageObj);
        });
    });
    photoOutput.on('error', (err: BusinessError): void => {
      Logger.error(TAG, `${JSON.stringify(err)}`);
    });
  }

  /**
   * 远端拍照
   * @param surfaceId
   */
  distributedTakePicture(surfaceId: string) {
    // rk createPreviewOutput 只支持{"format":3,"size":{"width":640,"height":480}}
    let region: image.Region = { x: 0, y: 0, size: { width: 640, height: 480 } };
    image.createPixelMapFromSurface(surfaceId, region).then(async (pixelMap: image.PixelMap) => {
      let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 100 }
      const imagePackerApi: image.ImagePacker = image.createImagePacker();
      await pixelMap.rotate(-90.0);
      imagePackerApi.packing(pixelMap, packOpts, (err: BusinessError, data: ArrayBuffer) => {
        if (err) {
          Logger.error('Failed in packing the image.' + JSON.stringify(err));
        } else {
          this.saveImage(data);
          pixelMap.release();
        }
      });
    }).catch((error: BusinessError) => {
      Logger.error(TAG, 'Failed to create pixelMap ' + JSON.stringify(error));
    });
  }

  /**
   * 取消回调监听
   * @param photoOutput
   */
  clearPhotoOutputCb(photoOutput: camera.PhotoOutput) {
    photoOutput.off('photoAvailable', (errCode: BusinessError): void => {
      Logger.error(TAG, `off photoAvailable: ${JSON.stringify(errCode)}`);
    });
    photoOutput.off('error', (errCode: BusinessError): void => {
      Logger.error(TAG, `off error: ${JSON.stringify(errCode)}`);
    });
  }

  /**
   * 保存图片
   * @param buffer
   * @param img
   */
  async saveImage(buffer: ArrayBuffer, img?: image.Image) {
    Logger.info(TAG, 'savePicture begin');
    try {
      //保存到系统相册
      this.fileAsset = await this.mediaUtil.createAndGetUri(Constants.IMAGE);
      let imgFd: number = await this.mediaUtil.getFdPath(this.fileAsset);
      await fs.write(imgFd, buffer);
      promptAction.showToast({
        message: `图片保存成功`,
        duration: 2000,
      });
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `savePicture error code :${JSON.stringify(error.code)}==errorMsg==：${error.message}`);
    }
    await img?.release();
  }

  /**
   * 初始化相机
   * 业务背景：相机初始化涉及多个步骤（创建输入/输出流、会话配置等），需要按顺序执行
   * 策略：
   *   1. 先释放旧资源避免内存泄漏
   *   2. 优先使用本地相机，远端相机作为备选
   *   3. 创建预览流、拍照流并加入会话，统一管理
   *   4. 提交配置并启动会话
   * @param surfaceId
   * @param cameraDevice
   * @returns
   */
  async initCamera(surfaceId: string, cameraDevice?: camera.CameraDevice,
    netWorkId?: string | undefined): Promise<void> {
    // 释放资源
    await this.releaseCamera();
    this.cameraMgr = camera.getCameraManager(this.context);
    // 获取相机列表
    this.camerasArray = this.cameraMgr.getSupportedCameras();
    Logger.info(TAG, `getCameraManager==length== ${JSON.stringify(this.camerasArray.length)}`);
    if (this.camerasArray != undefined && this.camerasArray.length > 0) {
      for (let index = 0; index < this.camerasArray.length; index++) {
        Logger.info(TAG, 'get cameras connectionType : ' + this.camerasArray[index].connectionType); // 获取相机连接类型
      }
    } else {
      this.camerasArray = [];
    }
    // 相机列表为空则返回
    if (this.camerasArray.length == 0) {
      Logger.info(TAG, 'cannot get cameras');
      return;
    }
    // 默认取本地摄像头，防止初始化时错误加载远端摄像头
    let mCamera = this.camerasArray.find((item) => item.connectionType == 0);
    // 如果不存在本地摄像头，初始化远端摄像头
    if (mCamera == null) {
      mCamera = this.camerasArray[0];
    }
    if (cameraDevice) {
      // 处理入参
      mCamera = cameraDevice;
    }
    if (netWorkId?.length && this.camerasArray.length > 1) {
      mCamera = this.camerasArray.find((item) => item.cameraId.includes(netWorkId));
    }
    Logger.info(TAG, `mCamera ${JSON.stringify(mCamera)}`);    // 创建相机输入流
    try {
      this.cameraInput = this.cameraMgr.createCameraInput(mCamera);
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `createCameraInput ${JSON.stringify(error.code)}==msg==${error.message}`);
    }
    // 打开相机
    await this.cameraInput?.open();
    // 是否为远端摄像头拍照标志位
    if (mCamera) {
      this.izDistributedCapture = mCamera.connectionType === camera.ConnectionType.CAMERA_CONNECTION_REMOTE;
    }
    // 获取相机支持的输出能力
    try {
      if (mCamera) {
        this.capability = this.cameraMgr?.getSupportedOutputCapability(mCamera, camera.SceneMode.NORMAL_PHOTO);
      }
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `getSupportedOutputCapability ${JSON.stringify(error.code)}==msg==${error.message}`);
    }
    Logger.info(TAG, `this.capability ${JSON.stringify(this.capability)} `);

    let previewProfile = this.capability?.previewProfiles[0];
    // 创建预览流
    try {
      if (previewProfile && this.cameraMgr) {
        this.previewOutput = this.cameraMgr.createPreviewOutput(previewProfile, surfaceId);
      }
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `createPreviewOutput ${JSON.stringify(error.code)}==msg==${error.message}`);
    }
    let photoProfile = this.capability?.photoProfiles[0];
    // 创建拍照流
    try {
      if (photoProfile && this.cameraMgr) {
        this.photoOutPut = this.cameraMgr.createPhotoOutput(
          photoProfile
        );
      }
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `createPhotoOutput ${JSON.stringify(error.code)}==msg==${error.message}`);
    }
    // 设置拍照回调
    if (this.photoOutPut) {
      this.setPhotoOutputCb(this.photoOutPut);
    }
    // 创建会话
    try {
      if (this.cameraMgr) {
        this.capSession = this.cameraMgr.createCaptureSession();
      }
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `createPhotoOutput ${JSON.stringify(error.code)}==msg==${error.message}`);
    }
    try {
      this.capSession?.beginConfig();
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `createPhotoOutput ${JSON.stringify(error.code)}==msg==${error.message}`);
    }
    // 开始会话配置

    try {
      // 向会话中添加相机输入流
      if (this.capSession && this.cameraInput) {
        this.capSession.addInput(this.cameraInput);
      }
      // 向会话中添加拍照输出流
      if (this.capSession && this.photoOutPut) {
        this.capSession.addOutput(this.photoOutPut);
      }
      // 向会话中添加预览输出流
      if (this.capSession && this.previewOutput) {
        this.capSession.addOutput(this.previewOutput);
      }
      // 提交会话配置
      await this.capSession?.commitConfig();
      // 启动会话
      await this.capSession?.start();
    } catch (e) {
      let error = e as BusinessError;
      Logger.error(TAG, `captureSession error ${JSON.stringify(error.code)}==msg==${error.message}`);
    }
    Logger.info(TAG, 'captureSession start success.');
  }

  /**
   * 获取支持的相机数组
   * 须在初始化方法后调用
   * @returns
   */
  getSupportedCameras(): camera.CameraDevice[] {
    this.cameraMgr = camera.getCameraManager(this.context);
    return this.cameraMgr.getSupportedCameras();
  }

  /**
   * 获取支持的相机数组字符串，用于展示
   * 须在初始化方法后调用
   * @returns
   */
  getSupportedCamerasString(): string[] {
    let result: string[] = [];
    let tmpCameras = this.getSupportedCameras();
    if (tmpCameras != undefined && tmpCameras.length > 0) {
      for (let index = 0; index < tmpCameras.length; index++) {
        const connectionType = tmpCameras[index].connectionType;
        const cameraPosition = tmpCameras[index].cameraPosition;
        const cameraType = tmpCameras[index].cameraType;
        
        const connectionTypeStr = connectionTypeMap.get(connectionType) || '未知连接类型';
        const positionTypeStr = cameraPositionTypeMap.get(cameraPosition) || '未知位置';
        const cameraTypeStr = cameraTypeMap.get(cameraType) || '未知类型';
        
        result.push(`${connectionTypeStr} ${positionTypeStr} ${cameraTypeStr}`);
      }
    }
    return result;
  }

  /**
   * 拍照
   * @param surfaceId
   */
  takePicture(surfaceId: string): void {
    let photoSettings: camera.PhotoCaptureSetting = {
      rotation: camera.ImageRotation.ROTATION_0,
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,
    };
    if (this.izDistributedCapture) {
      Logger.info(TAG, 'DistributedCapture takePicture');
      this.distributedTakePicture(surfaceId);
    } else {
      Logger.info(TAG, 'LocalCapture takePicture');
      if (this.photoOutPut) {
        this.photoOutPut.capture(photoSettings, async (err: BusinessError) => {
          if (err) {
            Logger.error(TAG, `Failed to capture the photo. error: ${JSON.stringify(err)}`);
            return;
          }
          Logger.info(TAG, 'Callback invoked to indicate the photo capture request success.');
        });
      }
    }
    Logger.info(TAG, 'takePicture done');
  }

  /**
   * 资源释放
   */
  async releaseCamera(): Promise<void> {
    Logger.info(TAG, 'releaseCamera');
    if (this.cameraInput) {
      await this.cameraInput.close();
    }
    if (this.previewOutput) {
      await this.previewOutput.release();
    }
    if (this.photoOutPut) {
      this.clearPhotoOutputCb(this.photoOutPut);
      await this.photoOutPut.release();
    }
    if (this.capSession) {
      await this.capSession.release();
    }
  }
}

export default CameraService.getInstance();
