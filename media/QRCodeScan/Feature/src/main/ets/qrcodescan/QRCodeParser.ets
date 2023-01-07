/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import jsQR from 'jsqr'
import fileio from '@ohos.fileio'
import image from '@ohos.multimedia.image'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import context from '@ohos.application.context'
import DateTimeUtil from '../utils/DateTimeUtil'
import { CameraService } from './CameraService'
import { QRCodeScanConst } from './QRCodeScanConst'
import Logger from '../utils/Logger'

/**
 * 二维码解析器
 */
class QRCodeParser {

  /**
   * 解析从相机获取的二维码图片
   *
   * @param cameraService
   * @param canvasContext
   */
  parseQRCodeImageFromCamera(cameraService: CameraService,
                   canvasContext: CanvasRenderingContext2D,
                   imageComponentType?: image.ComponentType): void {
    Logger.info("parseQRCodeImageFromCamera start")
    let fileName = this.getRandomFileName(QRCodeScanConst.IMG_FILE_PREFIX, QRCodeScanConst.IMG_SUFFIX_JPG)
    this.parseQRCodeImageWithNameFromCamera(cameraService, canvasContext, fileName, imageComponentType)
    Logger.info("parseQRCodeImageFromCamera end")
  }

  /**
   * 解析从相机获取的二维码图片，指定文件名称
   *
   * @param cameraService
   * @param canvasContext
   */
  parseQRCodeImageWithNameFromCamera(cameraService: CameraService,
                             canvasContext: CanvasRenderingContext2D,
                             fileDisplayName: string,
                             imageComponentType?: image.ComponentType): void {
    Logger.info("parseQRCodeImageWithNameFromCamera...")
    cameraService.imageReceiver.on('imageArrival', async () => {
      Logger.info("parseQRCodeImageWithNameFromCamera imageArrival start")
      // 从接收器获取下一个图像，并返回结果
      let targetImage: image.Image = await cameraService.imageReceiver.readNextImage()
      // 默认按JPEG格式处理
      let imgComponentType = imageComponentType === undefined ? image.ComponentType.JPEG : imageComponentType
      let imageComponent = await targetImage.getComponent(imgComponentType)
      // 将image的ArrayBuffer写入指定文件中，返回文件uri
      let imageUri = await this.createPublicDirFileAsset(fileDisplayName, mediaLibrary.MediaType.IMAGE,
      mediaLibrary.DirectoryType.DIR_IMAGE, imageComponent.byteBuffer)
      // 释放已读取的image资源，以便处理下一个资源
      await targetImage.release()

      // 解析二维码
      let qrCodeParseRlt = this.parseImageQRCode(canvasContext, new ImageBitmap(imageUri))
      if (qrCodeParseRlt == null) {
        Logger.error("parseQRCodeImageWithNameFromCamera qrCodeParseRlt is null")
      }
      // 拼接解析结果
      AppStorage.SetOrCreate(QRCodeScanConst.QR_CODE_PARSE_RESULT, qrCodeParseRlt)
      Logger.info("parseQRCodeImageWithNameFromCamera imageArrival end")
    })
  }

  /**
   * 从相册中获取单张图片
   */
  async getSingleImageFromAlbum(context: context.AbilityContext): Promise<ImageBitmap> {
    Logger.info("getSingleImageFromAlbum start")
    let abilityResult = await context.startAbilityForResult({
      bundleName: 'com.ohos.photos',
      abilityName: 'com.ohos.photos.MainAbility',
      parameters: {
        uri: 'singleselect' // 只选取单个文件
      }
    })
    if (abilityResult.want === null || abilityResult.want === undefined) {
      Logger.info("getSingleImageFromAlbum end. abilityResult.want is null.")
      return null
    }

    if (abilityResult.want.parameters === null || abilityResult.want.parameters === undefined) {
      Logger.info("getSingleImageFromAlbum end. abilityResult.want.parameters is null.")
      return null
    }

    let images = abilityResult.want.parameters['select-item-list']
    Logger.info("getSingleImageFromAlbum end")
    return new ImageBitmap(images)
  }

  /**
   * 解析图片二维码信息
   * @param canvasContext
   * @param imageBitmap
   */
  parseImageQRCode(canvasContext: CanvasRenderingContext2D, imageBitmap: ImageBitmap): string {
    Logger.info(`parseImageQRCode start`)
    // 创建画布
    canvasContext.clearRect(0, 0, QRCodeScanConst.QR_CODE_SIZE, QRCodeScanConst.QR_CODE_SIZE)
    // 绘制画布
    canvasContext.drawImage(imageBitmap, 0, 0, QRCodeScanConst.QR_CODE_SIZE, QRCodeScanConst.QR_CODE_SIZE)
    // 获取util8格式的图片
    let imageData = canvasContext.getImageData(0, 0, QRCodeScanConst.QR_CODE_SIZE, QRCodeScanConst.QR_CODE_SIZE)
    // 解析二维码
    let jsQRRlt = jsQR(imageData.data, imageData.width, imageData.height, { inversionAttempts: 'dontInvert' })
    if (jsQRRlt === null) {
      Logger.error("parseImageQRCode: jsQR result QRCode is null")
      return null
    }
    Logger.debug("parseImageQRCode: jsQR result data: " + jsQRRlt.data)
    return jsQRRlt.data
  }

  /**
   * 在媒体公共资源目录下的创建指定类型的资源对象
   */
  async createPublicDirFileAsset(fileDisplayName: string,
                                 mediaType: mediaLibrary.MediaType,
                                 directoryType: mediaLibrary.DirectoryType,
                                 fileByteBuffer: ArrayBuffer): Promise<string> {
    Logger.info("createPublicDirFileAsset start")
    // 获取mediaLibrary对象
    let mediaLibraryObj = mediaLibrary.getMediaLibrary(AppStorage.Get('context'))
    // 获取媒体公共资源目录
    let publicDir = await mediaLibraryObj.getPublicDirectory(directoryType)
    // 使用资源类型、资源名称、和公共资源路径创建FileAccess对象
    let fileAsset = await mediaLibraryObj.createAsset(mediaType, fileDisplayName, publicDir)

    // 拿到fileAccess资源对应的uri
    let fileUri = fileAsset.uri
    // 调用open方法打开这个资源对象 // TODO 为啥要打开？
    let fd = await fileAsset.open('Rw')
    // 将图片资源写入对应的fileAccess
    await fileio.write(fd, fileByteBuffer)
    // 关闭这个资源对象
    await fileAsset.close(fd)
    Logger.info("createPublicDirFileAsset end")
    return fileUri
  }

  /**
   * 根据时间生成随机文件名
   *
   * @param filePrefix 文件名前缀
   * @param fileSuffix 文件名后缀
   */
  getRandomFileName(filePrefix: string, fileSuffix: string) {
    let dateTimeUtil = new DateTimeUtil()
    return filePrefix + `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}` + fileSuffix
  }

}

export { QRCodeParser }