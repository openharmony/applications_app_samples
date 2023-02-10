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

import router from '@ohos.router'
import image from '@ohos.multimedia.image'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { logger } from '../util/Logger'

const TAG: string = 'EditPage'

@Component
export struct EditPage {
  @State mediaUris: Array<string> = router.getParams()['mediaUris']
  @State pixelMaps: Array<image.PixelMap> = []
  @State tasks: Array<Resource> = [$r('app.media.scale'), $r('app.media.crop'), $r('app.media.rotate')]
  @State tempTasks: Array<Resource> = [$r('app.media.scale'), $r('app.media.crop'), $r('app.media.rotate')]
  @State choiceTasks: Array<Resource> = [$r('app.media.scale_red'), $r('app.media.crop_red'), $r('app.media.rotate_red')]
  @State taskText: Array<Resource> = [$r('app.string.scale'), $r('app.string.crop'), $r('app.string.rotate')]
  @State cropRatios: Array<Resource> = [$r('app.string.origin_photo'), $r('app.string.proportion_one_one'), $r('app.string.proportion_three_four'), $r('app.string.proportion_nine_sixth')]
  @State cropMedias: Array<Resource> = [$r('app.media.origin_gray'), $r('app.media.one_one_gray'), $r('app.media.three_four_gray'), $r('app.media.nine_sixth_gray')]
  @State tempCropMedias: Array<Resource> = [$r('app.media.origin_gray'), $r('app.media.one_one_gray'), $r('app.media.three_four_gray'), $r('app.media.nine_sixth_gray')]
  @State cropChoiceMedias: Array<Resource> = [$r('app.media.origin_red'), $r('app.media.one_one_red'), $r('app.media.three_four_red'), $r('app.media.nine_sixth_red')]
  @State scaleTexts: Array<Resource> = [$r('app.string.narrow'), $r('app.string.amplification')]
  @State scaleMedias: Array<Resource> = [$r('app.media.scale_small'), $r('app.media.scale_big')]
  @State cropFrontShows: Array<boolean> = new Array(4).fill(false)
  @State tasksFrontShows: Array<boolean> = new Array(3).fill(false)
  @State borderShows: Array<boolean> = new Array(this.mediaUris.length).fill(false)
  @State pixelMap: image.PixelMap = undefined
  @State tempPixelMap: image.PixelMap = undefined
  @State single: number = 0
  @State isCrop: boolean = false
  @State isScale: boolean = false
  @State scaleSliderValue: number = 0
  @State selectIndex: number = 0
  @State isLand: boolean = false
  private mediaLibraryInstance: mediaLibrary.MediaLibrary = mediaLibrary.getMediaLibrary(getContext(this) as any)


  flushPage() {
    this.tempPixelMap = this.pixelMap
    this.pixelMap = undefined
    this.pixelMap = this.tempPixelMap
  }

  async queryFile(dataUri: string) {
    logger.info(TAG, `enter queryFile`)
    let fileKeyObj = mediaLibrary.FileKey
    logger.info(TAG, `fileKeyObj = ${fileKeyObj}`)
    let fetchOp = {
      selections: '',
      selectionArgs: [],
      uri: dataUri
    }
    const fetchFileResult = await this.mediaLibraryInstance.getFileAssets(fetchOp)
    logger.info(TAG, `fetchFileResult = ${JSON.stringify(fetchFileResult)} ,count = ${JSON.stringify(fetchFileResult.getCount())}`)
    if (!fetchFileResult) {
      return
    }
    const fileAsset = await fetchFileResult.getFirstObject()
    if (!fileAsset) {
      return
    }
    logger.info(TAG, `fileAsset = ${JSON.stringify(fileAsset)}`)
    return fileAsset
  }

  async getPixelMap(uri: string) {
    let fileAssert: mediaLibrary.FileAsset = await this.queryFile(uri)
    if (!fileAssert) {
      return
    }
    let fd = await fileAssert.open('Rw')
    if (!fd) {
      return
    }
    logger.info(TAG, `fd = ${fd}`)
    let imageSourceApi = image.createImageSource(fd)
    if (!imageSourceApi) {
      return
    }
    let pixmap = await imageSourceApi.createPixelMap()
    if (!pixmap) {
      return
    }
    return pixmap
  }

  async cropImage(proportion: number) {
    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo()
    if (!imageInfo) {
      return
    }
    let imageHeight = imageInfo.size.height
    let imageWith = imageInfo.size.width
    logger.info(TAG, `imageInfo = ${JSON.stringify(imageInfo)}`)
    if (proportion === 1) {
      if (imageHeight > imageWith) {
        imageHeight = imageWith
      } else {
        imageWith = imageHeight
      }
      logger.info(TAG, `imageHeight = ${JSON.stringify(imageHeight)},imageWith = ${JSON.stringify(imageWith)}`)
    }

    try {
      await this.pixelMap.crop({
        size: { height: imageHeight * proportion, width: imageWith },
        x: 0,
        y: 0
      })
    } catch (error) {
      logger.info(TAG, `crop error = ${JSON.stringify(error)}`)
    }
    this.flushPage()
  }

  async aboutToAppear() {
    logger.info(TAG, `enter aboutToAppear uris = ${JSON.stringify(router.getParams()['mediaUris'])}`)
    this.pixelMaps = []
    if(router.getParams() && router.getParams()['isLand']){
      this.isLand = router.getParams()['isLand']
    }
    for (let i = 0; i < this.mediaUris.length; i++) {
      let pixelMap = await this.getPixelMap(this.mediaUris[i])
      logger.info(TAG, `this.pixelMap = ${JSON.stringify(this.pixelMap)}`)
      if (pixelMap) {
        this.pixelMaps.push(pixelMap)
      }
    }
    logger.info(TAG, `this.pixelMaps = ${JSON.stringify(this.pixelMaps)}`)
    if (this.pixelMaps.length > 0) {
      this.pixelMap = this.pixelMaps[0]
    }
    if (this.borderShows.length > 0) {
      this.borderShows[0] = true
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(44)
          .height(24)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })

        Blank()

        Button($r('app.string.confirm'))
          .fontSize(20)
          .height(32)
          .width(80)
          .backgroundColor('#E92F4F')
          .margin({ right: 10 })
          .onClick(() => {
            AppStorage.Delete('pixelMap')
            AppStorage.SetOrCreate('pixelMaps', this.pixelMaps)
            router.push({
              url: 'pages/Index',
              params: { isShowCamera: true }
            })
          })
      }
      .width('100%')
      .height('5%')
      .constraintSize({ minHeight: 40 })
      .padding({ left: 15 })
      .backgroundColor('#f1f3f5')
      .margin({ top: 15 })

      Scroll() {
        Column() {
          Column() {
            Image(this.pixelMap)
              .height('100%')
              .width('90%')
              .objectFit(ImageFit.None)
              .backgroundColor('#ff070707')
          }
          .height('89%')
          .width('100%')
          .backgroundColor('#ff070707')

          if (!this.isCrop && !this.isScale) {
            Row() {
              ForEach(this.pixelMaps, (item, index) => {
                Image(item)
                  .width(60)
                  .height(60)
                  .borderRadius(15)
                  .margin({ left: 8 })
                  .border({
                    style: BorderStyle.Solid,
                    width: 2,
                    color: (this.borderShows[index] === true ? '#e92f4f' : '#ffffff')
                  })
                  .onClick(async () => {
                    if (this.pixelMap === item) {
                      return
                    }
                    this.borderShows.fill(false)
                    if (this.borderShows.length > index) {
                      this.borderShows[index] = true
                    }
                    this.single = 0
                    this.pixelMap = item
                    this.selectIndex = index
                  })
              })
              Row() {
                Image($r('app.media.add'))
                  .width(40)
                  .height(40)
                  .borderRadius(15)
                  .onClick(() => {
                    router.back()
                  })
              }
              .backgroundColor('#ffeae9e9')
              .justifyContent(FlexAlign.Center)
              .borderRadius(8)
              .width(60)
              .height(60)
              .margin({ left: 8 })
            }
            .margin({ top: 10 })
            .alignSelf(ItemAlign.Start)
            .backgroundColor('#f1f3f5')

          } else if (this.isCrop) {
            Row() {
              ForEach(this.cropMedias, (item, index) => {
                Column() {
                  Image(item)
                    .width(30)
                    .height(30)
                  Text(this.cropRatios[index])
                    .fontSize(15)
                    .fontColor(this.cropFrontShows[index] === true ? '#e92f4f' : '#acabab')
                    .margin({ top: 5 })
                }
                .layoutWeight(1)
                .onClick(async () => {
                  this.cropMedias = this.tempCropMedias.map((item) => {
                    return item
                  })
                  if (index === 0) {
                    if (this.mediaUris.length > this.selectIndex && this.pixelMaps.length > this.selectIndex) {
                      this.pixelMap = await this.getPixelMap(this.mediaUris[this.selectIndex])
                      this.pixelMaps[this.selectIndex] = this.pixelMap
                    }
                  }
                  else if (index === 1) {
                    await this.cropImage(1)
                  } else if (index === 2) {
                    await this.cropImage(3 / 4)
                  } else if (index === 3) {
                    await this.cropImage(9 / 16)
                  }
                  if (this.cropMedias.length > index && this.cropChoiceMedias.length > index) {
                    this.cropMedias[index] = this.cropChoiceMedias[index]
                  }
                  this.cropFrontShows.fill(false)
                  if (this.cropFrontShows.length > index) {
                    this.cropFrontShows[index] = true
                  }
                })
              })
            }
            .width('100%')
            .margin({ top: 15 })
          } else if (this.isScale) {
            Row() {
              ForEach(this.scaleMedias, (item, index) => {
                Column() {
                  Image(item)
                    .height(30)
                    .width(30)
                  Text(this.scaleTexts[index])
                    .fontSize(15)
                    .margin({ top: 5 })
                }
                .layoutWeight(1)
                .onClick(async () => {
                  if (index === 0) {
                    await this.pixelMap.scale(0.8, 0.8)
                  } else if (index === 1) {
                    await this.pixelMap.scale(1.25, 1.25)
                  }
                  this.flushPage()
                })
              })
            }
            .width('100%')
            .margin({ top: 15 })
          }
        }
        .height('100%')
        .width('100%')
      }
      .constraintSize(this.isLand === false ? { maxHeight: '84%' } : { maxHeight: '82%' })
      .backgroundColor('#f1f3f5')

      Divider()
        .vertical(false)
        .strokeWidth(0.8)
        .color('#ffd9d5d6')
        .lineCap(LineCapStyle.Round)
        .width('100%')
        .margin({ top: 8 })

      Row() {
        ForEach(this.tasks, (item, index) => {
          Column() {
            Image(item)
              .width(30)
              .height(30)
            Text(this.taskText[index])
              .fontSize(15)
              .fontColor(this.tasksFrontShows[index] === true ? '#e92f4f' : '#acabab')
          }
          .height(60)
          .width(60)
          .layoutWeight(1)
          .onClick(async () => {
            if (index === 0) {
              this.isScale = !this.isScale
              this.isCrop = false
            } else if (index === 1) {
              this.isCrop = !this.isCrop
              this.isScale = false
            } else if (index === 2) {
              await this.pixelMap.rotate(90)
              this.isCrop = false
              this.isScale = false
              this.flushPage()

            }
            this.tasksFrontShows.fill(false)
            if (this.tasksFrontShows.length > index) {
              this.tasksFrontShows[index] = true
            }
            this.tasks = this.tempTasks.map((item) => {
              return item
            })
            if (this.tasks.length > index && this.choiceTasks.length > index) {
              this.tasks[index] = this.choiceTasks[index]
            }
            this.cropFrontShows.fill(false)
            this.cropMedias = this.tempCropMedias.map((item) => {
              return item
            })
          })
        })
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }
}