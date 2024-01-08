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

import { MediaItem } from '../common/MediaItem'
import { AVPlayer } from '../model/AVPlayer'
import { gridData } from '../model/GridData'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { GridDataItem } from '../phoneView/GridDataItem'

@Component
export struct Toolkit {
  @State isBom: boolean = true
  @State isTitle: string = ''
  @State leftSliderIndex: number = -1
  @State clickIndex: number = -1
  @State itemData: mediaLibrary.FileAsset = {} as mediaLibrary.FileAsset
  @State audioText: string = ''
  @State videoText: string = ''
  @Link myMedia: AVPlayer
  @Link currentTime: number
  @Link isXComponent: boolean
  @Link audioData: mediaLibrary.FileAsset[]
  @Link videoData: mediaLibrary.FileAsset[]
  @Link isPlaying: boolean
  @Link surfaceId: number
  @Link fileIndex: number
  @Link fileType: number
  private timer: number = 0
  private scroller: Scroller = new Scroller()
  private deleteDialogShow: () => void = () => {
  }
  private renameDialogShow: () => void = () => {
  }
  private GridData: gridData[] = [
    { icon: $r('app.media.icon_color_music'), textStr: '音频', id: 'music' },
    { icon: $r('app.media.icon_color_video'), textStr: '视频', id: 'video' },
    { icon: $r('app.media.icon_color_favorite'), textStr: '收藏', id: 'favorite' },
    { icon: $r('app.media.icon_color_me'), textStr: '我的', id: 'me' },
  ]
  private context: Context = getContext(this)

  async aboutToAppear() {
    this.audioText = await this.convertResourceToString($r('app.string.phoneMain_audio'))
    this.videoText = await this.convertResourceToString($r('app.string.phoneMain_video'))
  }

  async convertResourceToString(resource: Resource) {
    return await this.context.resourceManager.getStringValue(resource.id)
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        ForEach(this.GridData, (item: gridData, index) => {
          GridDataItem({
            item: item,
            index: index,
            clickIndex: $clickIndex,
            isBom: $isBom,
            isTitle: $isTitle,
            context: this.context,
            isXComponent: $isXComponent
          })
        }, (item: gridData) => item.textStr)
      }.padding({ top: 10, bottom: 16 })

      if (this.isTitle == this.audioText || this.isTitle == this.videoText) {
        Scroll(this.scroller) {
          Column() {
            List({ initialIndex: 0 }) {
              ForEach(this.isTitle == this.audioText ? this.audioData : this.videoData, (item: mediaLibrary.FileAsset, index) => {
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
                .width('96%')
                .padding({ bottom: 12, left: 4 })
                .onClick(async () => {
                  this.isPlaying = true
                  this.itemData = item
                  if (this.isTitle == this.audioText) {
                    this.isXComponent = false
                    this.myMedia.init(this.itemData)
                  } else {
                    this.myMedia.init(this.itemData, this.surfaceId.toString())
                  }
                  if (this.isPlaying) {
                    this.timer = setInterval(() => {
                      this.currentTime = this.myMedia.getCurrentTime()
                    }, 1000)
                  }
                })
              }, (item: mediaLibrary.FileAsset) => item.displayName)
            }
            .height(260)
            .alignListItem(ListItemAlign.Center)
            .editMode(true)
          }.height('57%')
        }
      }
    }.height('100%')
  }
}