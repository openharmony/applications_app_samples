/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import fileio from '@ohos.fileio'
import type common from '@ohos.app.ability.common'
import MediaUtils from './MediaUtils'
import Logger from '../util/Logger'

const TAG: string = '[CameraService]'
const CAMERASIZE = {
  WIDTH: 1920,
  HEIGHT: 1080
}

/**
 * 相机服务
 */
export default class CameraService {
  private cameraInput: camera.CameraInput
  private photoOutput: camera.PhotoOutput
  private previewOutput: camera.PreviewOutput
  private captureSession: camera.CaptureSession
  private fileAsset: mediaLibrary.FileAsset
  private photoUri: string = ''
  private mediaUtil: MediaUtils
  private fd: number = -1
  private mReceiver: image.ImageReceiver
  private context: any
  private cameraManager: camera.CameraManager
  private cameras: Array<camera.CameraDevice>
  private photoOutPut: camera.PhotoOutput
  // @ts-ignore
  private captureSession: camera.CaptureSession
  private cameraOutputCapability: camera.CameraOutputCapability

  constructor(context: common.Context) {
    this.context = context
    this.mediaUtil = MediaUtils.getInstance(context)
    // 服务端代码，创建ImageReceiver
    this.mReceiver = image.createImageReceiver(CAMERASIZE.WIDTH, CAMERASIZE.HEIGHT, 4, 8) // 4表示生成的图像格式，8表示用户希望同时访问的最大图像数
    Logger.info(TAG, `createImageReceiver`)
    // 获取Surface ID
    this.mReceiver.getReceivingSurfaceId((surfaceId) => {
      Logger.info(TAG, `getReceivingSurfaceId surfaceId is ${surfaceId}`)
    })
    // 注册Surface的监听，在surface的buffer准备好后触发
    this.mReceiver.on('imageArrival', () => {
      Logger.info(TAG, `imageArrival`)
      // 去获取Surface中最新的buffer
      this.mReceiver.readNextImage((err, image) => {
        Logger.info(TAG, `readNextImage`)
        if (err || image === undefined) {
          Logger.error(TAG, `failed to get valid image`)
          return
        }
        image.getComponent(4, (errMsg, img) => {
          // 4表示图像类型为JPEG
          // 消费component.byteBuffer，例如：将buffer内容保存成图片。
          Logger.info(TAG, `getComponent`)
          if (errMsg || img === undefined) {
            Logger.info(TAG, `failed to get valid buffer`)
            return
          }
          let buffer = new ArrayBuffer(4096)
          if (img.byteBuffer) {
            buffer = img.byteBuffer
          } else {
            Logger.error(TAG, `img.byteBuffer is undefined`)
          }
          this.savePicture(buffer, image)
        })
      })
    })
  }

  /**
   * 以指定参数触发一次拍照
   */
  async takePicture(): Promise<void> {
    let photoSettings = {
      rotation: camera.ImageRotation.ROTATION_0,
      quality: camera.QualityLevel.QUALITY_LEVEL_MEDIUM,
      mirror: false
    }
    await this.photoOutPut.capture(photoSettings)
    Logger.info(TAG, `takePicture success`)
  }

  /**
   * 创建相机
   */
  async createCamera(surfaceId: string): Promise<void> {
    Logger.info(TAG, `createCamera start surfaceId ${surfaceId}`)
    this.cameraManager = await camera.getCameraManager(this.context)
    Logger.info(TAG, `createCamera cameraManager`)
    this.cameras = await this.cameraManager.getSupportedCameras()
    Logger.info(TAG, `createCamera get cameras ${this.cameras.length}`)
    if (this.cameras.length === 0) {
      Logger.error(TAG, `createCamera error`)
      return
    }

    let cameraDevice = this.cameras[0]
    this.cameraInput = await this.cameraManager.createCameraInput(cameraDevice)
    Logger.info(TAG, `createCamera cameraInput ${JSON.stringify(this.cameraInput)}`)
    this.cameraInput.open()
    Logger.info(TAG, `createCamera open`)
    this.cameraOutputCapability = await this.cameraManager.getSupportedOutputCapability(cameraDevice)
    let previewProfile = this.cameraOutputCapability.previewProfiles[0]
    Logger.info(TAG, `createCamera previewProfile ${previewProfile}`)
    this.previewOutput = await this.cameraManager.createPreviewOutput(previewProfile, surfaceId)
    Logger.info(TAG, `createCamera previewOutput`)
    let mSurfaceId = await this.mReceiver.getReceivingSurfaceId()
    Logger.info(TAG, `createCamera mSurfaceId ${mSurfaceId}`)
    let photoProfile = this.cameraOutputCapability.photoProfiles[0]
    Logger.info(TAG, `createCamera photoProfile ${photoProfile}`)
    this.photoOutPut = await this.cameraManager.createPhotoOutput(photoProfile, mSurfaceId)
    Logger.info(TAG, `createCamera previewProfile ${previewProfile}`)
    this.captureSession = await this.cameraManager.createCaptureSession()
    Logger.info(TAG, `createCamera captureSession`)
    await this.captureSession.beginConfig()
    Logger.info(TAG, `createCamera beginConfig`)
    await this.captureSession.addInput(this.cameraInput)
    await this.captureSession.addOutput(this.previewOutput)
    await this.captureSession.addOutput(this.photoOutPut)
    await this.captureSession.commitConfig()
    await this.captureSession.start()
    Logger.info(TAG, `createCamera end`)
  }

  /**
   * 关闭相机
   */
  async releaseCamera(): Promise<void> {
    Logger.info(TAG, `releaseCamera start`)
    await this.captureSession.stop()
    if (this.cameraInput) {
      await this.cameraInput.close()
    }
    if (this.previewOutput) {
      await this.previewOutput.release()
    }
    if (this.photoOutput) {
      await this.photoOutput.release()
    }
    await this.cameraInput.close()
    await this.captureSession.release()
    Logger.info(TAG, `releaseCamera end`)
  }

  /**
   * 保存图片
   */
  async savePicture(buffer: ArrayBuffer, img: image.Image): Promise<void> {
    Logger.info(TAG, 'savePicture')
    this.fileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.IMAGE)
    this.photoUri = this.fileAsset.uri
    Logger.info(TAG, `this.photoUri = ${this.photoUri}`)
    Logger.info(TAG, `photoUri  = ${JSON.stringify(AppStorage.Get('photoUri'))}`)
    this.fd = await this.mediaUtil.getFdPath(this.fileAsset)
    Logger.info(TAG, `this.fd = ${this.fd}`)
    await fileio.write(this.fd, buffer)
    await this.fileAsset.close(this.fd)
    await img.release()
    AppStorage.SetOrCreate<string>("photoUri", this.photoUri)
    Logger.info(TAG, `save image done`)
  }
}

