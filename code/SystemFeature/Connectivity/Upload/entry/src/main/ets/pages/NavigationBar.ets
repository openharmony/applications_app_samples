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

import router from '@ohos.router'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import fileio from '@ohos.fileio'
import request from '@ohos.request'
import common from '@ohos.app.ability.common'
import Logger from '../util/Logger'
import { UploadFile } from '../feature/UploadFile'

const TAG: string = '[Upload]'
const URL: string = 'http://10.56.237.202:8080/upload/'

@Component
export struct NavigationBar {
  @StorageLink('imageList') imageList: Array<string> = [] // 用于接收选中的照片
  @StorageLink('photoUri') @Watch('addToImageList') photoUri: string = '' // 用于接收拍照里的照片
  @State isSuccessNum: number = 0 // 记录上传成功的图片数量

  // 当拍照结束后，将图片添加到imageList的头部
  addToImageList(): void {
    this.imageList.unshift(this.photoUri)
  }

  async copyImage(url: string): Promise<void> {
    // 将选中图片存入沙箱路径
    let id = url.split('image/')[1]
    Logger.info(TAG, `this.id = ${id}`)
    let mContext: common.Context = getContext(this) as common.Context
    let media = mediaLibrary.getMediaLibrary(mContext)
    Logger.info(TAG, `this.media = ${JSON.stringify(media)}`)
    let imagesFetchOp = {
      selections: mediaLibrary.FileKey.ID + '= ?',
      selectionArgs: [`${id}`],
    }
    let fetchFileResult = await media.getFileAssets(imagesFetchOp)
    Logger.info(TAG, `this.fetchFileResult = ${JSON.stringify(fetchFileResult)}`)
    let fileAsset = await fetchFileResult.getFirstObject()
    Logger.info(TAG, `this.fileAsset = ${JSON.stringify(fileAsset)}`)
    let fd = await fileAsset.open('rw')
    Logger.info(TAG, `this.fd = ${JSON.stringify(fd)}`)
    // upload可访问的沙箱路径：data/app/el2/100/base/com.example.myapplication/haps/entry/cache/
    let imagePath = `${mContext.filesDir.split('files')[0]}cache/${new Date().getTime().toString()}.jpg`
    Logger.info(TAG, `this.imagePath = ${JSON.stringify(imagePath)}`)
    try {
      fileio.copyFileSync(fd, imagePath)
      await this.isUploadImage(imagePath)
    } catch (err) {
      Logger.info(TAG, `this.err = ${err}`)
    }
  }

  async isUploadImage(imagePath: string): Promise<void> {
    // 转成可上传的图片格式进行上传
    let file = new UploadFile()
    file.uri = `internal://cache/${imagePath.split('cache/')[1]}`
    Logger.info(TAG, `file.uri = ${file.uri}`)
    file.filename = imagePath.split('cache/')[1].split('.')[0]
    Logger.info(TAG, `file.filename = ${file.filename}`)
    file.name = imagePath.split('cache/')[1].split('.')[0]
    Logger.info(TAG, `file.name = ${file.name}`)
    file.type = imagePath.split('.')[1]
    Logger.info(TAG, `file.type = ${file.type}`)
    let uploadConfig = {
      url: URL,
      header: { key1: 'value1', key2: 'value2' },
      method: 'POST',
      files: [{ filename: file.filename, name: file.name, uri: file.uri, type: file.type }],
      data: [{ name: 'name123', value: '123' }],
    }
    Logger.info(TAG, `uploadConfig = ${JSON.stringify(uploadConfig)}`)
    let uploadContext: common.BaseContext = getContext(this) as common.BaseContext
    let uploadTask = await request.uploadFile(uploadContext, uploadConfig)
    uploadTask.on('complete', async (taskStates) => {
      this.isSuccessNum++
      await uploadTask.delete()
      Logger.info(TAG, `isSuccessNum:${this.isSuccessNum}`)
      if (this.isSuccessNum === this.imageList.length) {
        this.imageList = []
        this.isSuccessNum = 0
        AlertDialog.show({
          message: $r('app.string.publish_success'),
          primaryButton: {
            value: $r('app.string.confirm'),
            action: () => {
              Logger.info(TAG, `publish success`)
            }
          }
        })
      }
    })
    uploadTask.on('fail', err => {
      AlertDialog.show({
        message: $r('app.string.publish_fail'),
        primaryButton: {
          value: $r('app.string.confirm'),
          action: () => {
            Logger.info(TAG, `publish err:${err}`)
          }
        }
      })
    })
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.Back'))
          .width(24)
          .height(24)
          .focusable(false)
      }
      .width(48)
      .height(56)
      .onClick(() => {
        router.back()
      })

      Blank()
      Button() {
        Text($r('app.string.publish'))
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.white'))
      }
      .width(80)
      .height(40)
      .backgroundColor($r('app.color.green'))
      .onClick(() => {
        this.imageList.forEach(async url => {
          await this.copyImage(url)
        })
      })
    }
    .width('100%')
    .height(32)
    .padding({ left: 14, right: 14 })
    .margin({ right: 20, top: 20 })
  }
}