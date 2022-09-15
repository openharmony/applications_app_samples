// @ts-nocheck
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

import { mainDialog } from '../common/mainDialog'
import { RenameDialog } from '../common/RenameDialog'
import { DeleteDialog } from '../common/DeleteDialog'
import { TitleBar } from '../common/TitleBar'
import { BroadcastControl } from '../common/BroadcastControl'
import { Toolkit } from '../common/Toolkit'
import { StreamingMedia } from '../common/StreamingMedia'


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
  @State myMedia: myMedia = new myMedia()
  @State streamBtnText: Resource = $r('app.string.index_play')
  @State streamOpacity: number = 0.4
  @State itemDate: mediaLibrary.FileAsset = undefined
  @State audioData: Array<mediaLibrary.FileAsset> = []
  @State videoData: Array<mediaLibrary.FileAsset> = []
  @State @Watch('onChangeLoop') isLoop: boolean = false
  @State @Watch('onChangePlay') isPlaying: boolean = false
  @State streamBackgroundColor: string = '#99B9F8'
  private renameDialogController: CustomDialogController = null
  private deleteDialogController: CustomDialogController = null
  private mXComponentController: XComponentController = new XComponentController()
  private mainDialogController: CustomDialogController = new CustomDialogController({
    builder: mainDialog(),
    autoCancel: false,
    customStyle: true
  })

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
    this.mainDialogController.open()
  }
  async convertResourceToString(resource: Resource){
    return await this.context.resourceManager.getString(resource)
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

  onChangeLoop() {
    this.myMedia.setIsLoopCallBack(this.isLoop)
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
      builder: RenameDialog({
        title: disPlayName,
        disPlayType: disPlayType,
        setRename: this.setRename.bind(this)
      }),
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
          context:this.context,
          mXComponentController: this.mXComponentController
        })
        Toolkit({
          myMedia: $myMedia,
          itemData: $itemDate,
          context:this.context,
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
          mXComponentController: this.mXComponentController,
          deleteDialogShow: this.deleteDialogShow.bind(this),
          renameDialogShow: this.renameDialogShow.bind(this)
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