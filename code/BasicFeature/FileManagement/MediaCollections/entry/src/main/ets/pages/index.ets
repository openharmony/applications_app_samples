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
import Logger from '../model/Logger'
import { AVPlayer } from '../model/AVPlayer'
import MediaUtils from '../model/MediaUtils'
import { promptShowToast } from '../model/Prompt'
import { DeleteDialog } from '../common/DeleteDialog'
import { RenameDialog } from '../common/RenameDialog'
import { TitleBar } from '../common/TitleBar'
import { Toolkit } from '../common/Toolkit'
import { BroadcastControl } from '../common/BroadcastControl'
import { StreamingMedia } from '../common/StreamingMedia'
import { MediaUtiles } from '../common/utils'
import { mainDialog } from '../common/mainDialog'

const TAG: string = 'IndexMain'

@Entry
@Component
struct Index {
  @State fillIndex: number = -1
  @State currentTime: number = 0
  @State isOpacity: number = 0.4
  @State isSurface: boolean = true
  @State isVolume: boolean = false
  @State fillMediaType: number = -1
  @State isShowMenu: boolean = false
  @State btnEnabled: boolean = false
  @State isXComponent: boolean = true
  @State isStreamShow: boolean = false
  @State isInformation: boolean = false
  @State myMedia: AVPlayer = new AVPlayer()
  @State streamBtnText: Resource = $r('app.string.index_play')
  @State streamOpacity: number = 0.4
  @State fileIndex: number = 0
  @State fileType: number = 0
  @State itemDate: mediaLibrary.FileAsset = {} as mediaLibrary.FileAsset
  @State audioData: mediaLibrary.FileAsset[] = []
  @State videoData: mediaLibrary.FileAsset[] = []
  @State @Watch('onChangeLoop') isLoop: boolean = false
  @State @Watch('onChangePlay') isPlaying: boolean = false
  @State streamBackgroundColor: string = '#99B9F8'
  @State newName: string = ''
  private testUtile: MediaUtiles = new MediaUtiles()
  private renameDialogController: CustomDialogController = {} as CustomDialogController
  private deleteDialogController: CustomDialogController = {} as CustomDialogController
  private mXComponentController: XComponentController = new XComponentController()
  private mainDialogController: CustomDialogController = new CustomDialogController({
    builder: mainDialog(),
    autoCancel: false,
    customStyle: true
  })
  private context: Context = getContext(this)

  async aboutToAppear() {
    MediaUtils.mediaLib = mediaLibrary.getMediaLibrary(this.context)
    await this.getAudioData()
    await this.getVideoData()
    this.mainDialogController.open()
    this.myMedia.setCompleteCallback(() => {
      Logger.info(TAG, 'completed state called')
      this.isPlaying = !this.isPlaying
    })
  }

  async convertResourceToString(resource: Resource) {
    return await this.context.resourceManager.getString(resource.id)
  }

  onPageShow() {
    MediaUtils.onDateChange(this.getAudioData, this.getVideoData)
  }

  onPageHide() {
    MediaUtils.offDateChange()
  }

  async getAudioData() {
    this.audioData = []
    let fileAsset = MediaUtils.getFileAssetsFromType(mediaLibrary.MediaType.AUDIO)
    fileAsset.then(fileList => {
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
    fileAsset.then(fileList => {
      Logger.info(TAG, 'getFileList callback')
      this.videoData = fileList
      this.myMedia.getVideoData(this.videoData)
    }).catch((err: Error) => {
      Logger.error(TAG, `getFileList err,err = ${err}`)
    })
  }

  onChangePlay() {
    Logger.info(TAG, 'onChangePlay, isPlaying is: ' + this.isPlaying)
    this.isPlaying ? this.myMedia.getPlay() : this.myMedia.getPause()
  }

  onChangeLoop() {
    this.myMedia.setIsLoopCallBack(this.isLoop)
  }

  async renameDialogShow(): Promise<void> {
    this.fillIndex = this.fileIndex
    this.fillMediaType = this.fileType
    let disPlayName: string = ''
    let disPlayType: string = ''
    if (this.fileType == mediaLibrary.MediaType.AUDIO) {
      disPlayName = this.audioData[this.fillIndex].displayName
      let audio: string = await this.convertResourceToString($r('app.string.phoneMain_audioTitle'))
      disPlayType = audio
    } else {
      disPlayName = this.videoData[this.fileIndex].displayName
      let video: string = await this.convertResourceToString($r('app.string.phoneMain_videoTitle'))
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
    let mediaData: mediaLibrary.FileAsset[] = []
    if (this.fileType == mediaLibrary.MediaType.AUDIO) {
      mediaData = this.audioData
    } else {
      mediaData = this.videoData
    }
    this.deleteDialogController = new CustomDialogController({
      builder: DeleteDialog({ index: this.fillIndex, mediaData: mediaData, mediaType: this.fileType }),
      autoCancel: true,
      customStyle: true,
    })
    this.deleteDialogController.open()
  }

  build() {
    Column() {
      Flex({
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.SpaceBetween
      }) {
        TitleBar()
        StreamingMedia({
          myMedia: $myMedia,
          isPlaying: $isPlaying,
          isShowMenu: $isShowMenu,
          currentTime: $currentTime,
          isStreamShow: $isStreamShow,
          isXComponent: $isXComponent,
          streamOpacity: $streamOpacity,
          streamBtnText: $streamBtnText,
          streamBackgroundColor: $streamBackgroundColor,
          mXComponentController: this.mXComponentController,
        })
      }
      .height(50)
      .width('98%')
      .margin({
        top: 24,
        bottom: 24
      })

      Flex({
        justifyContent: FlexAlign.SpaceBetween
      }) {
        BroadcastControl({
          isLoop: $isLoop,
          myMedia: $myMedia,
          itemData: $itemDate,
          isSurface: $isSurface,
          isPlaying: $isPlaying,
          isOpacity: $isOpacity,
          btnEnabled: $btnEnabled,
          isShowMenu: $isShowMenu,
          currentTime: $currentTime,
          isXComponent: $isXComponent,
          context: this.context,
          mXComponentController: this.mXComponentController
        })
        Toolkit({
          myMedia: $myMedia,
          itemData: $itemDate,
          context: this.context,
          audioData: $audioData,
          videoData: $videoData,
          isSurface: $isSurface,
          isPlaying: $isPlaying,
          isOpacity: $isOpacity,
          btnEnabled: $btnEnabled,
          isShowMenu: $isShowMenu,
          currentTime: $currentTime,
          isStreamShow: $isStreamShow,
          isXComponent: $isXComponent,
          streamBtnText: $streamBtnText,
          streamOpacity: $streamOpacity,
          fileIndex: $fileIndex,
          fileType: $fileType,
          mXComponentController: this.mXComponentController,
          deleteDialogShow: () => this.deleteDialogShow(),
          renameDialogShow: () => this.renameDialogShow()
        })
      }
      .width('97%')
      .height('83%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#222324')
  }
}