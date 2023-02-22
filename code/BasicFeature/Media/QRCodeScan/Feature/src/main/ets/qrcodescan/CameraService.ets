/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import camera from '@ohos.multimedia.camera'
import image from '@ohos.multimedia.image'
import Logger from '../utils/Logger'
import { QRCodeScanConst } from './QRCodeScanConst'

/**
 * 相机服务
 */
class CameraService {
  private cameraInput: camera.CameraInput
  private photoOutput: camera.PhotoOutput
  private previewOutput: camera.PreviewOutput
  private captureSession: camera.CaptureSession
  public imageReceiver: image.ImageReceiver

  constructor(imgReceiver?: image.ImageReceiver) {
    if (imgReceiver === undefined) {
      this.imageReceiver = image.createImageReceiver(QRCodeScanConst.IMG_DEFAULT_SIZE.WIDTH,
      QRCodeScanConst.IMG_DEFAULT_SIZE.HEIGHT, image.ImageFormat.JPEG, QRCodeScanConst.MAX_IMAGE_CAPACITY)
    } else {
      this.imageReceiver = image.createImageReceiver(imgReceiver.size.width, imgReceiver.size.height,
      imgReceiver.format, imgReceiver.capacity)
    }
  }

  /**
   * 以指定参数触发一次拍照
   */
  takePicture() {
    let photoSetting = {
      rotation: camera.ImageRotation.ROTATION_0,
      quality: camera.QualityLevel.QUALITY_LEVEL_MEDIUM,
      mirror: false
    }
    this.photoOutput.capture(photoSetting)
  }

  /**
   * 创建相机
   */
  async createCamera(surfaceId: string) {
    Logger.info("createCamera start")
    // 根据context获取CameraManager
    let cameraManager = await camera.getCameraManager(AppStorage.Get('context'))
    // 获取Camera对象数组
    let cameras = await cameraManager.getSupportedCameras()
    // 没有相机就停止
    if (cameras.length === 0) {
      Logger.error("createCamera: cameras length is 0.")
      return
    }
    // 拿到相机列表中的第一个默认相机id, 根据id获取相机输入流
    this.cameraInput = await cameraManager.createCameraInput(cameras[0])
    this.cameraInput.open()
    // 获取cameraOutputCapability参数
    let cameraOutputCapability = await cameraManager.getSupportedOutputCapability(cameras[0])
    // 获取相机输出流
    this.previewOutput = await cameraManager.createPreviewOutput(cameraOutputCapability.previewProfiles[0], surfaceId)
    // 获取一个可以创建相片输出流的id
    let receivingSurfaceId = await this.imageReceiver.getReceivingSurfaceId()
    // 创建相片输出流
    this.photoOutput = await cameraManager.createPhotoOutput(cameraOutputCapability.photoProfiles[0], receivingSurfaceId)
    // 获取捕获会话的实例
    this.captureSession = await cameraManager.createCaptureSession()
    // 开始会话配置
    await this.captureSession.beginConfig()
    // 使用相机输入流---添加一个摄像头输入流
    await this.captureSession.addInput(this.cameraInput)
    // 使用相机输出流---添加一个摄像头输出
    await this.captureSession.addOutput(this.previewOutput)
    // 使用相片输出流---添加相机照片的输出
    await this.captureSession.addOutput(this.photoOutput)
    // 结束并提交配置
    await this.captureSession.commitConfig()
    // 开始捕获会话
    await this.captureSession.start()
    Logger.info("createCamera end")
  }

  /**
   * 创建相机
   */
  async releaseCamera() {
    await this.captureSession.release()
    await this.cameraInput.close()
    await this.photoOutput.release()
    await this.previewOutput.release()
    await this.imageReceiver.release()
  }
}

export { CameraService }