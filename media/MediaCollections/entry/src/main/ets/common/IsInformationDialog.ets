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
  @Link myMedia: myMedia
  private controller: CustomDialogController
  private scroller: Scroller = new Scroller()
  private isInformation: mediaLibrary.FileAsset = null
  private context: any
  @State isInformation_id: string = ''
  @State isInformation_uri: string = ''
  @State isInformation_mimeType: string = ''
  @State isInformation_mediaType: string = ''
  @State isInformation_displayName: string = ''
  @State isInformation_title: string = ''
  @State isInformation_relativePath: string = ''
  @State isInformation_parent: string = ''
  @State isInformation_size: string = ''
  @State isInformation_dateAdded: string = ''
  @State isInformation_dateModified: string = ''
  @State isInformation_dateTaken: string = ''
  @State isInformation_artist: string = ''
  @State isInformation_audioAlbum: string = ''
  @State isInformation_width: string = ''
  @State isInformation_height: string = ''
  @State isInformation_orientation: string = ''
  @State isInformation_duration: string = ''
  @State isInformation_albumId: string = ''
  @State isInformation_albumUri: string = ''
  @State isInformation_albumName: string = ''
  async aboutToAppear() {
    this.myMedia.getPause()
    this.isInformation = this.myMedia.getResourceAddress()
    this.isInformation_id = await this.convertResourceToString($r('app.string.index_formation_id'))
    this.isInformation_uri = await this.convertResourceToString($r('app.string.index_formation_uri'))
    this.isInformation_mimeType = await this.convertResourceToString($r('app.string.index_formation_mimeType'))
    this.isInformation_mediaType = await this.convertResourceToString($r('app.string.index_formation_mediaType'))
    this.isInformation_displayName = await this.convertResourceToString($r('app.string.index_formation_displayName'))
    this.isInformation_title = await this.convertResourceToString($r('app.string.index_formation_title'))
    this.isInformation_relativePath = await this.convertResourceToString($r('app.string.index_formation_relativePath'))
    this.isInformation_parent = await this.convertResourceToString($r('app.string.index_formation_parent'))
    this.isInformation_size = await this.convertResourceToString($r('app.string.index_formation_size'))
    this.isInformation_dateAdded = await this.convertResourceToString($r('app.string.index_formation_dateAdded'))
    this.isInformation_dateModified = await this.convertResourceToString($r('app.string.index_formation_dateModified'))
    this.isInformation_dateTaken = await this.convertResourceToString($r('app.string.index_formation_dateTaken'))
    this.isInformation_artist = await this.convertResourceToString($r('app.string.index_formation_artist'))
    this.isInformation_audioAlbum = await this.convertResourceToString($r('app.string.index_formation_audioAlbum'))
    this.isInformation_width = await this.convertResourceToString($r('app.string.index_formation_width'))
    this.isInformation_height = await this.convertResourceToString($r('app.string.index_formation_height'))
    this.isInformation_orientation = await this.convertResourceToString($r('app.string.index_formation_orientation'))
    this.isInformation_duration = await this.convertResourceToString($r('app.string.index_formation_duration'))
    this.isInformation_albumId = await this.convertResourceToString($r('app.string.index_formation_albumId'))
    this.isInformation_albumUri = await this.convertResourceToString($r('app.string.index_formation_albumUri'))
    this.isInformation_albumName = await this.convertResourceToString($r('app.string.index_formation_albumName'))


  }
  async convertResourceToString(resource: Resource){
    return await this.context.resourceManager.getString(resource)
  }
  build() {
    Scroll(this.scroller) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceEvenly }) {
        Text($r('app.string.index_formation')).fontColor('#FFFFFF')
        Text(`${this.isInformation_id + this.isInformation.id}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_uri + this.isInformation.uri}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_mimeType + this.isInformation.mimeType}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_mediaType + this.isInformation.mediaType}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_displayName + this.isInformation.displayName}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_title + this.isInformation.title}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_relativePath + this.isInformation.relativePath}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_parent + this.isInformation.parent}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_size + filterSize(this.isInformation.size)}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_dateAdded + getDateTime(this.isInformation.dateAdded)}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_dateModified + getDateTime(this.isInformation.dateModified)}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_dateTaken + getDateTime(this.isInformation.dateTaken)}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_artist + this.isInformation.artist}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_audioAlbum  + this.isInformation.audioAlbum}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_width + this.isInformation.width}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_height + this.isInformation.height}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_orientation + this.isInformation.orientation}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_duration + getTimeString(this.isInformation.duration)}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_albumId + this.isInformation.albumId}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_albumUri + this.isInformation.albumUri}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_albumName + this.isInformation.albumName}`).fontColor('#FFFFFF')
      }.width('100%').height('100%')
    }
    .scrollBar(BarState.Off)
    .scrollBarColor(Color.White)
    .padding('1%')
    .backgroundColor('rgba(0,0,0,0.6)')
    .width('22%')
    .height('71%')
  }
}