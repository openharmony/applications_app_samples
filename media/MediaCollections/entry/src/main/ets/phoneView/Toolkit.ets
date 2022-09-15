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

import { MediaItem } from '../common/MediaItem'
import { myMedia } from '../model/myMedia'
import { gridData } from '../model/GridData'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import { GridDataItem } from '../phoneView/GridDataItem'

@Component
export struct Toolkit {
  @State isBom: boolean = true
  @State isTitle: string = ''
  @State leftSliderIndex: number = -1
  @State clickIndex: number = -1
  @State itemData: mediaLibrary.FileAsset = undefined
  @Link myMedia: myMedia
  @Link currentTime: number
  @Link isXComponent: boolean
  @Link audioData: Array<mediaLibrary.FileAsset>
  @Link videoData: Array<mediaLibrary.FileAsset>
  @Link isPlaying: boolean
  @Link surfaceId: number
  private timer: number = undefined
  private scroller: Scroller = new Scroller()
  private deleteDialogShow: (index: number, mediaType) => void
  private renameDialogShow: (index: number, mediaType) => void
  private GridData: gridData[] = [
    { icon: $r('app.media.icon_color_music'), textStr: '音频' },
    { icon: $r('app.media.icon_color_video'), textStr: '视频' },
    { icon: $r('app.media.icon_color_favorite'), textStr: '收藏' },
    { icon: $r('app.media.icon_color_me'), textStr: '我的' },
  ]
  private context: any
  @State audioText: string = ''
  @State videoText: string = ''
  async aboutToAppear(){
    this.audioText = await this.convertResourceToString($r('app.string.phoneMain_audio'))
    this.videoText = await this.convertResourceToString($r('app.string.phoneMain_video'))
  }
  async convertResourceToString(resource: Resource){
    return await this.context.resourceManager.getString(resource)
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
        }, item => item.textStr)
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
                    deleteDialogShow: this.deleteDialogShow.bind(this),
                    renameDialogShow: this.renameDialogShow.bind(this)
                  })
                }
                .width('96%')
                .padding({ bottom: 12, left: 4 })
                .onClick(() => {
                  this.isPlaying = true
                  this.itemData = item
                  if (this.isTitle == this.audioText) {
                    this.isXComponent = false
                    this.myMedia.init(this.itemData)
                  } else {
                    this.myMedia.init(this.itemData, this.surfaceId)
                  }
                  if (this.isPlaying) {
                    this.timer = setInterval(() => {
                      this.currentTime = this.myMedia.getCurrentTime()
                    }, 1000)
                  }
                })
              }, item => item.id)
            }
            .alignListItem(ListItemAlign.Center)
            .editMode(true)
          }.height('57%')
        }
      }
    }.height('100%')
  }
}