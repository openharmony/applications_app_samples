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
import screenshot from '@ohos.screenshot'
import image from '@ohos.multimedia.image'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from "../model/logger"
import MediaUtils from '../feature/mediautils'

const TAG: string = "[Sample_ShareComponent]"
let context: any = getContext(this)

class ShareUtils {
  convertResourceToString(resource: Resource) {
    return context.resourceManager.getStringSync(resource.id)
  }

  // 分享图片、链接
  async startAbility(contextCaller, title: string, srcImg: string) {
    try {
      Logger.info(TAG, 'begin to start ability explicitly')
      Logger.info(TAG, JSON.stringify(contextCaller))
      await contextCaller.startAbility({
        bundleName: "ohos.samples.chat",
        abilityName: "ohos.samples.chat.MainAbility", // 未设置ability名称，代表该want为隐式
        parameters: { // 分享的内容
          "kindId": 1,
          "text": title,
          "srcImg": srcImg
        }
      })
      Logger.info(TAG, 'explicit start ability succeed')
    } catch (error) {
      prompt.showToast({
        message: this.convertResourceToString($r("app.string.startChatFail")),
        duration: 3000,
      });
      Logger.error(TAG, `explicit start ability failed with ${error.code}`)
    }
    Logger.info(TAG, 'Callback when the second button is clicked')
  }

  // 分享图片文件
  async savePicture(data: image.PixelMap, contextCaller) {
    let path
    let fdTemp
    try {
      Logger.info(TAG, `savePicture`)
      // 处理图片的格式
      let packOpts: image.PackingOption = {
        format: "image/jpeg", quality: 100
      }
      // 创建图片打包
      let imgPackerApi = image.createImagePacker()
      let arrayBuffer = await imgPackerApi.packing(data, packOpts)
      // 创建空的文件路径
      path = contextCaller.filesDir
      fdTemp = fileio.openSync(path + "/phone.png", 0o2 | 0o100, 0o666) // 新的文件
      Logger.info(TAG, "FileIoPath-----" + path + " " + "fileio----fdImg: " + fdTemp)
      // 路径格式： data/storage/el2/base/haps/entry/files
      let numFromFd = await fileio.write(fdTemp, arrayBuffer) // arrayBuffer是内容
      Logger.info(TAG, "savePicture---number" + numFromFd)
    } catch (error) {
      Logger.info(TAG, "savePicture----error" + JSON.stringify(error))
    }

    await fileio.close(fdTemp)
    fdTemp = fileio.openSync(path + "/phone.png") // 新的文件
    Logger.info(TAG, "shareBefore---fdImg" + fdTemp)
    return fdTemp
  }

  async shareImageStartAbility(fdImg: number, contextCaller) {
    Logger.info(TAG, 'begin to  shareFileStartAbility')
    try {
      Logger.info(TAG, JSON.stringify(contextCaller))
      let buf = new ArrayBuffer(90960);
      let opt = {
        offset: 0,
        position: 0,
        length: 90000
      }
      try {
        let readOut = await fileio.readSync(fdImg, buf, opt)
        // let readOut = await fileio.readSync(fd, buf, opt)
        Logger.info(TAG, "y**, readOutBefore = " + JSON.stringify(readOut));
        Logger.info(TAG, "y**, buf = " + JSON.stringify(buf));
        let view = new Uint32Array(buf);
        Logger.info(TAG, "shareImageStartAbility, view = " + JSON.stringify(view));
      } catch (e) {
        Logger.info(TAG, "shareImageStartAbility, e = " + JSON.stringify(e));
      }

      let want = {
        bundleName: "ohos.samples.chat",
        abilityName: "ohos.samples.chat.MainAbility", // 未设置ability名称，代表该want为隐式，
        parameters: { // 分享的内容
          "kindId": 2,
          "keyFd": { "type": "FD", "value": fdImg },
        }
      }
      await contextCaller.startAbility(want)
      Logger.info(TAG, 'shareFileStartAbility succeed')
    } catch (error) {
      prompt.showToast({
        message: this.convertResourceToString($r("app.string.startChatFail")),
        duration: 3000,
      });
      Logger.error(TAG, `shareFileStartAbility failed with ${error.code}`)
    }
  }

  async getScreen(isPhone: boolean, contextCaller) {
    let data: image.PixelMap
    let screenShotHeight: number
    let screenShotWeight: number
    let QRCODE_SIZE: number = isPhone ? 300 : 300 // 生成截图的大小
    let QRCODE_PADDING: number = isPhone ? 80 : 80 // 截图保存时图片边距
    let fdImg: number
    try {
      // 截屏图片
      Logger.info(`${TAG} getScreen,isFullScreen`)
      screenShotWeight = QRCODE_SIZE + 1.1 * QRCODE_PADDING
      screenShotHeight = QRCODE_SIZE + 6 * QRCODE_PADDING
      let screenshotOptions: screenshot.ScreenshotOptions = {
        screenRect: { // 表示截取图像的区域，不传值默认为全屏。以下参数仅支持number
          left: 160,
          top: 180, // 二维码保存时图片顶部距离屏幕顶部边缘距离
          width: screenShotWeight,
          height: screenShotHeight
        },
        imageSize: { // 表示截取图像的大小，不传值默认为全屏。
          width: screenShotWeight,
          height: screenShotHeight
        },
        rotation: 0,
        displayId: 0
      }
      data = await screenshot.save(screenshotOptions)
    } catch (error) {
      Logger.error(TAG, "getScreen----" + error)
    }
    // 保存图片
    fdImg = await this.savePicture(data, contextCaller)
    prompt.showToast({
      "message": this.convertResourceToString($r("app.string.shotPrompt")),
      "duration": 500
    })
    setTimeout(() => {
      this.shareImageStartAbility(fdImg, contextCaller)
    }, 1500)
  }

  // 分析视频文件
  async startApp(fd: number, fileAssetName: string, contextCaller) {
    Logger.info(TAG, "startApp:startApp----fd" + fd)
    try {
      let want = {
        bundleName: "com.example.revievedvideo",
        abilityName: "MainAbility", // 未设置ability名称，代表该want为隐式，
        parameters: { // 分享的内容
          "fileAssetName": fileAssetName,
          "keyFd": { "type": "FD", "value": fd },
        }
      }
      await contextCaller.startAbility(want)
    } catch (error) {
      Logger.info(TAG, "startApp: startAbility----error" + JSON.stringify(error))
    }
  }

  async queryMedia(mediaList: Array<mediaLibrary.FileAsset>, fileAssetName: string) {
    let fdNum: number
    let currentIndex: number = -1
    for (let i = 0; i < mediaList.length; i++) {
      Logger.info(TAG, `queryMedia: file.id=${mediaList[i].id} --- file.name=${mediaList[i].displayName}`)
      try {
        if (mediaList[i].displayName == fileAssetName) {
          let fileAsset = mediaList[i]
          //          currentIndex = index
          fdNum = await fileAsset.open('Rw')
          Logger.info(TAG, `queryMedia:queryMedia---------fd  ${fdNum}`)
          break;
        }
      } catch (error) {
        Logger.info(TAG, `queryMedia: ERROR----- ${error}`)
      }
    }
    return fdNum
  }

  async getFileData(contextCaller) {
    let mediaList: Array<mediaLibrary.FileAsset> = []
    let fileAssets = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO)
    let fileAssetName: string = "video_4.mp4"
    let fdVideo
    mediaList = await MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO)
    Logger.info(TAG, `getFileData: getFileData------mediaList ${mediaList}`)
    fdVideo = await this.queryMedia(mediaList, fileAssetName)
    Logger.info(TAG, `getFileData: getFileData------fd ${fdVideo}`)
    await this.startApp(fdVideo, fileAssetName, contextCaller)
  }
}

export default new ShareUtils()