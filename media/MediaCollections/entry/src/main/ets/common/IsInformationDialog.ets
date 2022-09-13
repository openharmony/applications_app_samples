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
import { myMedia } from '../model/myMedia'
import { filterSize, getTimeString, getDateTime } from '../model/TimeTools'

@CustomDialog
export struct isInformationDialog {
  private controller: CustomDialogController
  private scroller: Scroller = new Scroller()
  private isInformation: mediaLibrary.FileAsset = null
  @Link myMedia: myMedia

  async aboutToAppear() {
    this.myMedia.getPause()
    this.isInformation = this.myMedia.getResourceAddress()
  }

  build() {
    Scroll(this.scroller) {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.SpaceEvenly
      }) {
        Text($r('app.string.index_formation'))
          .fontColor('#FFFFFF')
        Text($r('app.string.index_formation')+`${this.isInformation.id}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_id')}${this.isInformation.uri}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_mimeType')}${this.isInformation.mimeType}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_mediaType')}${this.isInformation.mediaType}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_displayName')}${this.isInformation.displayName}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_title')}${this.isInformation.title}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_relativePath')}${this.isInformation.relativePath}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_parent')}${this.isInformation.parent}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_size')}${filterSize(this.isInformation.size)}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_dateAdded')}${getDateTime(this.isInformation.dateAdded)}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_dateModified')}${getDateTime(this.isInformation.dateModified)}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_dateTaken')}${getDateTime(this.isInformation.dateTaken)}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_artist')}${this.isInformation.artist}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_audioAlbum')}${this.isInformation.audioAlbum}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_width')}${this.isInformation.width}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_height')}${this.isInformation.height}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_orientation')}${this.isInformation.orientation}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_duration')}${getTimeString(this.isInformation.duration)}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_albumId')}${this.isInformation.albumId}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_albumUri')}${this.isInformation.albumUri}`).fontColor('#FFFFFF')
        Text(`${$r('app.string.index_formation_albumName')}${this.isInformation.albumName}`).fontColor('#FFFFFF')
      }
      .width('100%')
      .height('100%')
    }
    .scrollBar(BarState.Off)
    .scrollBarColor(Color.White)
    .padding('1%')
    .backgroundColor('rgba(0,0,0,0.6)')
    .width('22%')
    .height('71%')
  }
}