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

import prompt from '@ohos.prompt'
import fileio from '@ohos.fileio'
import display from '@ohos.display'
import screenshot from '@ohos.screenshot'
import image from '@ohos.multimedia.image'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../util/Logger'
import MediaUtils from '../feature/MediaUtils'
import { ShareConst } from '../util/ShareConst'

const TAG: string = 'ShareUtils'

export class ShareUtils {
  private context: any

  constructor(context) {
    this.context = context
  }

  convertResourceToString(resource: Resource) {
    return this.context.resourceManager.getStringSync(resource.id)
  }

  // 分享图片、链接
  async startAbility(contextCaller, title: string, srcImage: string) {
    try {
      Logger.info(TAG, `begin to start ability explicitly, ${JSON.stringify(contextCaller)}`)
      await contextCaller.startAbility({
        bundleName: "ohos.samples.chat",
        abilityName: "ohos.samples.chat.MainAbility", // 未设置ability名称，代表该want为隐式
        parameters: { // 分享的内容
          "kindId": ShareConst.KIND_ID_NUMBER,
          "text": title,
          "srcImg": srcImage
        }
      })
      Logger.info(TAG, `explicit start ability succeed`)
    } catch (error) {
      prompt.showToast({
        message: this.convertResourceToString($r('app.string.start_chat_fail')),
        duration: ShareConst.DURATION_NUMBER
      })
      Logger.error(TAG, `explicit start ability failed with ${error.code}`)
    }
    Logger.info(TAG, `Callback when the second button is clicked`)
  }

  // 分享图片文件
  async savePicture(data: image.PixelMap, contextCaller) {
    let path
    let fdTemp
    try {
      Logger.info(TAG, `savePicture`)
      // 处理图片的格式
      let packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: ShareConst.QUALITY_NUMBER
      }
      // 创建图片打包
      let imgPackerApi = image.createImagePacker()
      let arrayBuffer = await imgPackerApi.packing(data, packOpts)
      // 创建空的文件路径
      path = contextCaller.filesDir
      fdTemp = fileio.openSync(`${path}/phone.png`, ShareConst.FLAGS_NUMBER, ShareConst.MODE_NUMBER) // 新的文件
      Logger.info(TAG, `FileIoPath:${path}, fileio fdImg: ${fdTemp}`)
      // 路径格式： data/storage/el2/base/haps/entry/files
      let numFromFd = await fileio.write(fdTemp, arrayBuffer) // arrayBuffer是内容
      Logger.info(TAG, `savePicture number: ${numFromFd}`)
    } catch (error) {
      Logger.info(TAG, `savePicture error: ${JSON.stringify(error)}`)
    }

    await fileio.close(fdTemp)
    fdTemp = fileio.openSync(`${path}/phone.png`) // 新的文件
    Logger.info(TAG, `shareBefore fdImg: ${fdTemp}`)
    return fdTemp
  }

  async shareImageStartAbility(fdImage: number, contextCaller) {
    Logger.info(TAG, `begin to shareFileStartAbility`)
    try {
      Logger.info(TAG, `${JSON.stringify(contextCaller)}`)
      let buf = new ArrayBuffer(ShareConst.BUFFER_LENGTH);
      let opt = {
        offset: ShareConst.OFFSET_NUMBER,
        position: ShareConst.POSITION_NUMBER,
        length: ShareConst.LENGTH_NUMBER
      }
      try {
        let readOut = await fileio.readSync(fdImage, buf, opt)
        Logger.info(TAG, `y, readOutBefore: ${JSON.stringify(readOut)}}`)
        Logger.info(TAG, `y, buf: ${JSON.stringify(buf)}}`)
        let view = new Uint32Array(buf)
        Logger.info(TAG, `shareImageStartAbility, view: ${JSON.stringify(view)}`)
      } catch (error) {
        Logger.info(TAG, `shareImageStartAbility, error: ${JSON.stringify(error)}`)
      }

      let want = {
        bundleName: 'ohos.samples.chat',
        abilityName: 'ohos.samples.chat.MainAbility', // 未设置ability名称，代表该want为隐式，
        parameters: { // 分享的内容
          'kindId': ShareConst.KIND_ID,
          'keyFd': { 'type': 'FD', 'value': fdImage }
        }
      }
      await contextCaller.startAbility(want)
      Logger.info(TAG, `shareFileStartAbility succeed`)
    } catch (error) {
      prompt.showToast({
        message: this.convertResourceToString($r("app.string.start_chat_fail")),
        duration: ShareConst.DURATION_NUMBER
      })
      Logger.error(TAG, `shareFileStartAbility failed with ${error.code}`)
    }
  }

  async getScreen(isLand: boolean, contextCaller) {
    let data: image.PixelMap

    let screenShotHeight: number
    let screenShotWeight: number
    let fdImg: number
    try {
      // 截屏图片
      let defaultDisplay = await display.getDefaultDisplay()
      Logger.info(TAG, `getScreen,isFullScreen`)
      screenShotWeight = defaultDisplay.width * 0.6
      screenShotHeight = defaultDisplay.height * 0.75
      let screenShotRectLeft = (defaultDisplay.width - screenShotWeight) / 2
      let screenShotTop = (defaultDisplay.height - screenShotHeight) / 2 + ShareConst.TITLE_HEIGHT
      let smScreenshotOptions: screenshot.ScreenshotOptions = {
        screenRect: { // 表示截取图像的区域，不传值默认为全屏。以下参数仅支持number
          left: screenShotRectLeft,
          top: screenShotTop, // 二维码保存时图片顶部距离屏幕顶部边缘距离
          width: screenShotWeight,
          height: screenShotHeight
        },
        imageSize: { // 表示截取图像的大小，不传值默认为全屏。
          width: screenShotWeight,
          height: screenShotHeight
        },
        rotation: ShareConst.ROTATION_NUMBER,
        displayId: ShareConst.DISPLAY_ID
      }
      let lgScreenshotOptions: screenshot.ScreenshotOptions = {
        screenRect: { // 表示截取图像的区域，不传值默认为全屏。以下参数仅支持number
          left: ShareConst.LEFT_NUMBER,
          top: ShareConst.TOP_NUMBER, // 二维码保存时图片顶部距离屏幕顶部边缘距离
          width: ShareConst.WIDTH,
          height: ShareConst.HEIGHT
        },
        imageSize: { // 表示截取图像的大小，不传值默认为全屏。
          width: ShareConst.WIDTH,
          height: ShareConst.HEIGHT
        },
        rotation: ShareConst.ROTATION_NUMBER,
        displayId: ShareConst.DISPLAY_ID
      }
      if (isLand) {
        data = await screenshot.save(smScreenshotOptions)
      } else {
        data = await screenshot.save(lgScreenshotOptions)
      }
    } catch (error) {
      Logger.error(TAG, `getScreen error : ${error}`)
    }
    // 保存图片
    fdImg = await this.savePicture(data, contextCaller)
    prompt.showToast({
      "message": this.convertResourceToString($r('app.string.shot_prompt')),
      "duration": ShareConst.DURATION
    })
    setTimeout(() => {
      this.shareImageStartAbility(fdImg, contextCaller)
    }, 1500)
  }

  // 分析视频文件
  async startApp(fd: number, fileAssetName: string, contextCaller) {
    Logger.info(TAG, `startApp:startApp fd : ${fd}`)
    try {
      let want = {
        bundleName: 'com.example.revievedvideo',
        abilityName: 'MainAbility', // 未设置ability名称，代表该want为隐式，
        parameters: { // 分享的内容
          'fileAssetName': fileAssetName,
          'keyFd': { 'type': 'FD', 'value': fd }
        }
      }
      await contextCaller.startAbility(want)
    } catch (error) {
      Logger.info(TAG, `startApp: startAbility error: ${JSON.stringify(error)}`)
    }
  }

  async queryMedia(mediaList: Array<mediaLibrary.FileAsset>, fileAssetName: string) {
    let fdNum: number
    for (let i = 0; i < mediaList.length; i++) {
      Logger.info(TAG, `queryMedia: file.id: ${mediaList[i].id}, file.name: ${mediaList[i].displayName}`)
      try {
        if (mediaList[i].displayName === fileAssetName) {
          let fileAsset = mediaList[i]
          fdNum = await fileAsset.open('Rw')
          Logger.info(TAG, `queryMedia:queryMedia fd: ${fdNum}`)
          break
        }
      } catch (error) {
        Logger.info(TAG, `queryMedia: ERROR: ${error}`)
      }
    }
    return fdNum
  }

  async getFileData(contextCaller) {
    let mediaList: Array<mediaLibrary.FileAsset> = []
    let fileAssets = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO, this.context)
    let fileAssetName: string = 'video_4.mp4'
    let fdVideo
    mediaList = await MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO, this.context)
    Logger.info(TAG, `getFileData: getFileData mediaList: ${mediaList}`)
    fdVideo = await this.queryMedia(mediaList, fileAssetName)
    Logger.info(TAG, `getFileData: getFileData fd: ${fdVideo}`)
    await this.startApp(fdVideo, fileAssetName, contextCaller)
  }
}