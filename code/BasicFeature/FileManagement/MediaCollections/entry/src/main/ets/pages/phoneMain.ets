/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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
import common from '@ohos.app.ability.common'
import Logger from '../model/Logger'
import { AVPlayer } from '../model/AVPlayer'
import MediaUtils from '../model/MediaUtils'
import { promptShowToast } from '../model/Prompt'
import { DeleteDialog } from '../common/DeleteDialog'
import { RenameDialog } from '../common/RenameDialog'
import { TitleBar } from '../phoneView/TitleBar'
import { Toolkit } from '../phoneView/Toolkit'
import { BroadcastControl } from '../phoneView/BroadcastControl'
import { MediaUtiles } from '../common/utils'

const TAG = 'PhoneIndex: '

@Entry
@Component
struct Send {
  @State surfaceId: number = -1
  @State myMedia: AVPlayer = new AVPlayer()
  @State audioData: mediaLibrary.FileAsset[] = []
  @State videoData: mediaLibrary.FileAsset[] = []
  @State fillIndex: number = -1
  @State fillMediaType: number = -1
  @State currentTime: number = 0
  @State @Watch('onChangeLoop') isLoop: boolean = false
  @State @Watch('onChangePlay') isPlaying: boolean = false
  @State isXComponent: boolean = true
  @State httpUrl: string = ''
  @State fileIndex: number = 0
  @State fileType: number = 0
  @State newName: string = ''
  private testUtile: MediaUtiles = new MediaUtiles()
  private renameDialogController: CustomDialogController = {} as CustomDialogController
  private deleteDialogController: CustomDialogController = {} as CustomDialogController
  private mXComponentController: XComponentController = new XComponentController()
  private context: Context = getContext(this) as common.UIAbilityContext

  async aboutToAppear() {
    MediaUtils.mediaLib = mediaLibrary.getMediaLibrary(this.context)
    await this.getAudioData()
    await this.getVideoData()
    this.myMedia.setCompleteCallback(() => {
      Logger.info(TAG, 'completed state called')
      this.isPlaying = !this.isPlaying
    })
  }

  aboutToDisappear() {
    this.myMedia.release()
  }

  async getAudioData() {
    this.audioData = []
    let fileAsset = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.AUDIO)
    fileAsset.then((fileList: mediaLibrary.FileAsset[]) => {
      Logger.info(TAG, 'getFileList callback')
      this.audioData = fileList
      this.myMedia.getAudioData(this.audioData)
    }).catch((err: Error) => {
      Logger.error(TAG, `getFileList err,err = ${err}`)
    })
  }

  async getVideoData() {
    this.videoData = []
    let fileAsset = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO)
    fileAsset.then((fileList: mediaLibrary.FileAsset[]) => {
      Logger.info(TAG, 'getFileList callback')
      this.videoData = fileList
      this.myMedia.getVideoData(this.videoData)
    }).catch((err: Error) => {
      Logger.error(TAG, `getFileList err,err = ${err}`)
    })
  }

  onChangeLoop() {
    this.myMedia.setIsLoopCallBack(this.isLoop)
  }

  onChangePlay() {
    this.isPlaying ? this.myMedia.getPlay() : this.myMedia.getPause()
  }

  async convertResourceToString(resource: Resource): Promise<string> {
    return this.context.resourceManager.getString(resource.id)
  }

  async renameDialogShow(): Promise<void> {
    this.fillIndex = this.fileIndex
    this.fillMediaType = this.fileType
    let disPlayName: string
    let disPlayType: string
    if (this.fileType == mediaLibrary.MediaType.AUDIO) {
      disPlayName = this.audioData[this.fileIndex].displayName
      let audio = await this.convertResourceToString($r('app.string.phoneMain_audioTitle'))
      disPlayType = audio
    } else {
      disPlayName = this.videoData[this.fileIndex].displayName
      let video = await this.convertResourceToString($r('app.string.phoneMain_videoTitle'))
      disPlayType = video
    }
    this.renameDialogController = new CustomDialogController({
      builder: RenameDialog({
        title: disPlayName,
        disPlayType: disPlayType,
        testUtile: this.testUtile,
        setRename: () => this.setRename()
      }),
      autoCancel: true,
      customStyle: true,
    })
    this.renameDialogController.open()
  }

  setRename(): void {
    this.newName = this.testUtile.getName()
    if (this.fillMediaType == mediaLibrary.MediaType.AUDIO) {
      this.audioData[this.fileIndex].displayName = this.newName
      this.audioData[this.fileIndex].commitModify((err) => {
        if (err !== undefined) {
          Logger.info(TAG, `commitModify, err: ${err}`)
          promptShowToast($r('app.string.phoneMain_legitimateStr'))
          return
        }
        this.renameDialogController.close()
        this.getAudioData()
      })
    } else {
      this.videoData[this.fileIndex].displayName = this.newName
      this.videoData[this.fileIndex].commitModify((err) => {
        if (err !== undefined) {
          Logger.info(TAG, `commitModify, err: ${err}`)
          promptShowToast($r('app.string.phoneMain_legitimateStr'))
          return
        }
        this.renameDialogController.close()
        this.getVideoData()
      })
    }
  }

  deleteDialogShow(): void {
    let mediaData: mediaLibrary.FileAsset[]
    if (this.fileType == mediaLibrary.MediaType.AUDIO) {
      mediaData = this.audioData
    } else {
      mediaData = this.videoData
    }
    this.deleteDialogController = new CustomDialogController({
      builder: DeleteDialog({ index: this.fileIndex, mediaData: mediaData, mediaType: this.fileType }),
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
        deleteDialogShow: () => this.deleteDialogShow(),
        renameDialogShow: () => this.renameDialogShow(),
        isPlaying: $isPlaying,
        surfaceId: $surfaceId,
        context: this.context,
        fileIndex: $fileIndex,
        fileType: $fileType
      })
    }.height('100%').backgroundColor('#222324')
  }
}
