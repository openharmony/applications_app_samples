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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../model/Logger'
import { myMedia } from '../model/myMedia'
import MediaUtils from '../model/MediaUtils'
import { promptShowToast } from '../model/Prompt'
import { DeleteDialog } from '../common/DeleteDialog'
import { RenameDialog } from '../common/RenameDialog'
import { TitleBar } from '../phoneView/TitleBar'
import { Toolkit } from '../phoneView/Toolkit'
import { BroadcastControl } from '../phoneView/BroadcastControl'

const TAG = 'PhoneIndex: '

@Entry
@Component
struct Send {
  @State surfaceId: number = -1
  @State myMedia: myMedia = new myMedia()
  @State audioData: Array<mediaLibrary.FileAsset> = []
  @State videoData: Array<mediaLibrary.FileAsset> = []
  @State fillIndex: number = -1
  @State fillMediaType: number = -1
  @State currentTime: number = 0
  @State @Watch('onChangePlay') isPlaying: boolean = false
  @State isXComponent: boolean = true
  @State httpUrl: string = ''
  private renameDialogController: CustomDialogController = null
  private deleteDialogController: CustomDialogController = null
  private timerOut: number = undefined
  private mXComponentController: XComponentController = new XComponentController()
  private context: any = getContext(this)

  async aboutToAppear() {
    MediaUtils.mediaLib = await mediaLibrary.getMediaLibrary(this.context)
    const PERMISSIONS: Array<string> = [
      'ohos.permission.WRITE_MEDIA',
      'ohos.permission.READ_MEDIA',
      'ohos.permission.INTERNET'
    ]
    await this.context.requestPermissionsFromUser(PERMISSIONS)
    await this.getAudioData()
    await this.getVideoData()
  }

  async getAudioData() {
    this.audioData = []
    let fileAsset = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.AUDIO)
    fileAsset.then(fileList => {
      Logger.info(TAG, 'getFileList callback')
      this.audioData = fileList
      this.myMedia.getAudioData(this.audioData)

    }).catch(err => {
      Logger.error(TAG, `getFileList err,err = ${err}`)
    })
  }

  async getVideoData() {
    this.videoData = []
    let fileAsset = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO)
    fileAsset.then(fileList => {
      Logger.info(TAG, 'getFileList callback')
      this.videoData = fileList
      this.myMedia.getVideoData(this.videoData)
    }).catch(err => {
      Logger.error(TAG, `getFileList err,err = ${err}`)
    })
  }

  onChangePlay() {
      this.isPlaying ? this.myMedia.getPlay() : this.myMedia.getPause()
  }
  async convertResourceToString(resource: Resource){
    return await this.context.resourceManager.getString(resource)
  }
  async renameDialogShow(index, mediaType) {
    this.fillIndex = index
    this.fillMediaType = mediaType
    let disPlayName
    let disPlayType
    if (mediaType == mediaLibrary.MediaType.AUDIO) {
      disPlayName = this.audioData[index].displayName
      let audio = await this.convertResourceToString($r('app.string.phoneMain_audioTitle'))
      disPlayType = audio
    } else {
      disPlayName = this.videoData[index].displayName
      let video = await this.convertResourceToString($r('app.string.phoneMain_videoTitle'))
      disPlayType = video
    }
    this.renameDialogController = new CustomDialogController({
      builder: RenameDialog({ title: disPlayName, disPlayType: disPlayType, setRename: this.setRename.bind(this) }),
      autoCancel: true,
      customStyle: true,
    })
    this.renameDialogController.open()
  }

  setRename(newName) {
    if (this.fillMediaType == mediaLibrary.MediaType.AUDIO) {
      this.audioData[this.fillIndex].displayName = newName
      this.audioData[this.fillIndex].commitModify((err) => {
        if (err !== undefined) {
          console.info(`commitModify, err: ${err}`)
          promptShowToast($r('app.string.phoneMain_legitimateStr'))
          return
        }
        this.renameDialogController.close()
        this.getAudioData()
      })
    } else {
      this.videoData[this.fillIndex].displayName = newName
      this.videoData[this.fillIndex].commitModify((err) => {
        if (err !== undefined) {
          console.info(`commitModify, err: ${err}`)
          promptShowToast($r('app.string.phoneMain_legitimateStr'))
          return
        }
        this.renameDialogController.close()
        this.getVideoData()
      })
    }
  }

  deleteDialogShow(index, mediaType) {
    let mediaData
    if (mediaType == mediaLibrary.MediaType.AUDIO) {
      mediaData = this.audioData
    } else {
      mediaData = this.videoData
    }
    this.deleteDialogController = new CustomDialogController({
      builder: DeleteDialog({ index: index, mediaData: mediaData }),
      autoCancel: true,
      customStyle: true,
    })
    this.deleteDialogController.open()
  }

  build() {
    Column() {
      TitleBar({
        myMedia: $myMedia,
        isPlaying: $isPlaying,
        currentTime: $currentTime,
        httpUrl: this.httpUrl,
        isXComponent: $isXComponent,
        mXComponentController: this.mXComponentController,
      })
      BroadcastControl({
        myMedia: $myMedia,
        isXComponent: $isXComponent,
        surfaceId: $surfaceId,
        isPlaying: $isPlaying,
        currentTime: $currentTime,
        mXComponentController: this.mXComponentController,
      })
      Toolkit({
        myMedia: $myMedia,
        currentTime: $currentTime,
        isXComponent: $isXComponent,
        audioData: $audioData,
        videoData: $videoData,
        deleteDialogShow: this.deleteDialogShow.bind(this),
        renameDialogShow: this.renameDialogShow.bind(this),
        isPlaying: $isPlaying,
        surfaceId: $surfaceId,
        context: this.context
      })
    }.height('100%').backgroundColor('#222324')
  }
}
