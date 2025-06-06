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


import userFileManager from '@ohos.filemanagement.userFileManager';
import { gridData } from '../model/GridData'
import { AVPlayer } from '../model/AVPlayer'
import { MediaItem } from './MediaItem'
import { ToolKitItem } from '../common/ToolkitItem'

@Component
export struct Toolkit {
  @Link myMedia: AVPlayer
  @Link isOpacity: number
  @Link isSurface: boolean
  @Link btnEnabled: boolean
  @Link streamOpacity: number
  @Link isPlaying: boolean
  @Link currentTime: number
  @Link isShowMenu: boolean
  @Link isXComponent: boolean
  @Link isStreamShow: boolean
  @Link streamBtnText: Resource
  @Link itemData: userFileManager.FileAsset
  @Link audioData: userFileManager.FileAsset[]
  @Link videoData: userFileManager.FileAsset[]
  @Link fileIndex: number
  @Link fileType: number
  @State isBom: boolean = true
  @State leftSliderIndex: number = -1
  @State isTitle: string = ''
  @State audioText: string = ''
  @State videoText: string = ''
  private timer: number = 0
  private timerOut: number = 0
  private scroller: Scroller = new Scroller()
  private mXComponentController: XComponentController = {} as XComponentController
  private deleteDialogShow: () => void = () => {
  }
  private renameDialogShow: () => void = () => {
  }
  private context: Context = getContext(this)
  private GridData: gridData[] = [
    { icon: $r('app.media.icon_color_music'), textStr: '音频' },
    { icon: $r('app.media.icon_color_video'), textStr: '视频' },
    { icon: $r('app.media.icon_color_search'), textStr: '搜索' },
    { icon: $r('app.media.icon_color_favorite'), textStr: '收藏' },
    { icon: $r('app.media.icon_color_me'), textStr: '我的' },
    { icon: $r('app.media.icon_color_setting'), textStr: '设置' }
  ]

  clearVideoPlayer() {
    this.currentTime = 0
    clearInterval(this.timer)
    this.myMedia.stop()
    this.myMedia.release()
  }

  async aboutToAppear() {
    this.audioText = await this.convertResourceToString($r('app.string.phoneMain_audio'))
    this.videoText = await this.convertResourceToString($r('app.string.phoneMain_video'))
  }

  async convertResourceToString(resource: Resource) {
    return await this.context.resourceManager.getString(resource.id)
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      if (!this.isBom) {
        Row() {
          Image(this.isBom ? '' : $r('app.media.icon_back'))
            .width(24)
            .height(24)
            .onClick(() => {
              this.isBom = true
              this.isTitle = ''
              this.isXComponent = true
            })
          Text(this.isTitle)
            .margin({ left: 15 })
            .fontSize(20)
            .fontStyle(FontStyle.Normal)
            .fontWeight(500)
            .fontColor('#FFFFFFF')
            .textAlign(TextAlign.Center)
            .fontFamily('HarmonyHeiTi')
            .height(28)
        }
        .padding(15)
        .width('100%')
      }
      Column() {
        if (this.isBom) {
          Grid(this.scroller) {
            ForEach(this.GridData, (item: gridData) => {
              GridItem() {
                ToolKitItem({ GridData: item })
              }.onClick(() => {
                this.isBom = !this.isBom
                this.isTitle = item.textStr
              })
            }, (item: gridData) => item.textStr)
          }
          .columnsTemplate('1fr 1fr')
          .margin({ top: 5 })
          .width('94%')
          .layoutWeight(1)
          .padding(2)
        }
        if (this.isTitle == this.audioText) {
          Column() {
            List({ initialIndex: 0 }) {
              ForEach(this.audioData, (item: userFileManager.FileAsset, index) => {
                ListItem() {
                  MediaItem({
                    index: index,
                    mediaItem: item,
                    leftSliderIndex: $leftSliderIndex,
                    fileIndex: $fileIndex,
                    fileType: $fileType,
                    deleteDialogShow: () => this.deleteDialogShow(),
                    renameDialogShow: () => this.renameDialogShow()
                  })
                }
                .padding({ bottom: 8, left: 12 })
                .onClick(() => {
                  this.btnEnabled = true
                  this.clearVideoPlayer()
                  this.isXComponent = false
                  this.isPlaying = true
                  this.isOpacity = 1
                  this.isStreamShow = false
                  this.streamOpacity = 0.4
                  this.streamBtnText = $r('app.string.toolKit_play')
                  this.isShowMenu = true
                  this.itemData = item
                  this.myMedia.init(this.itemData)
                  if (this.isPlaying) {
                    this.timer = setInterval(() => {
                      this.currentTime = this.myMedia.getCurrentTime()
                    }, 1000)
                  }
                })
              }, (item: userFileManager.FileAsset) => item.uri)
            }
            .editMode(true)
          }
          .height('100%')
        }
        if (this.isTitle == this.videoText) {
          Column() {
            List({ initialIndex: 0 }) {
              ForEach(this.videoData, (item: userFileManager.FileAsset, index) => {
                ListItem() {
                  MediaItem({
                    index: index,
                    mediaItem: item,
                    leftSliderIndex: $leftSliderIndex,
                    fileIndex: $fileIndex,
                    fileType: $fileType,
                    deleteDialogShow: () => this.deleteDialogShow(),
                    renameDialogShow: () => this.renameDialogShow()
                  })
                }
                .padding({ bottom: 8, left: 12 })
                .onClick(() => {
                  this.btnEnabled = true
                  this.clearVideoPlayer()
                  this.isShowMenu = true
                  this.isPlaying = true
                  this.isOpacity = 1
                  this.itemData = item
                  this.isSurface = !this.isSurface
                  this.isStreamShow = false
                  this.streamBtnText = $r('app.string.toolKit_play')
                  this.streamOpacity = 0.4
                  this.timerOut = setTimeout(() => {
                    let surfaceId = this.mXComponentController.getXComponentSurfaceId()
                    this.myMedia.init(this.itemData, surfaceId)
                  }, 100)

                  if (this.isPlaying) {
                    this.timer = setInterval(() => {
                      this.currentTime = this.myMedia.getCurrentTime()
                    }, 1000)
                  }
                })
              }, (item: userFileManager.FileAsset) => item.uri)
            }
            .editMode(true)
          }
          .height('100%')
        }
      }
      .width('100%')
      .height('100%')
    }
    .borderRadius(16)
    .backgroundColor('rgba(255,255,255,0.06)')
    .width('22%')
    .height('100%')
  }
}