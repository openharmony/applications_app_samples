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
import { myMedia } from '../model/myMedia'
import { getTimeString } from '../model/TimeTools'

@CustomDialog
export struct isInformationDialog {
  @Link myMedia: myMedia
  @State isInformation_uri: string = ''
  @State isInformation_mediaType: string = ''
  @State isInformation_displayName: string = ''
  @State isInformation_title: string = ''
  @State isInformation_width: string = ''
  @State isInformation_height: string = ''
  @State isInformation_orientation: string = ''
  @State isInformation_duration: string = ''
  private controller: CustomDialogController = {} as CustomDialogController
  private isInformation: userFileManager.FileAsset = {} as userFileManager.FileAsset
  private scroller: Scroller = new Scroller()
  private context: Context = getContext(this)

  async aboutToAppear() {
    this.myMedia.getPause()
    this.isInformation = this.myMedia.getResourceAddress()
    this.isInformation_uri = await this.convertResourceToString($r('app.string.index_formation_uri'))
    this.isInformation_mediaType = await this.convertResourceToString($r('app.string.index_formation_mediaType'))
    this.isInformation_displayName = await this.convertResourceToString($r('app.string.index_formation_displayName'))
    this.isInformation_title = await this.convertResourceToString($r('app.string.index_formation_title'))
    this.isInformation_width = await this.convertResourceToString($r('app.string.index_formation_width'))
    this.isInformation_height = await this.convertResourceToString($r('app.string.index_formation_height'))
    this.isInformation_orientation = await this.convertResourceToString($r('app.string.index_formation_orientation'))
    this.isInformation_duration = await this.convertResourceToString($r('app.string.index_formation_duration'))
  }

  async convertResourceToString(resource: Resource): Promise<string> {
    return await this.context.resourceManager.getStringValue(resource.id)
  }

  build() {
    Scroll(this.scroller) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceEvenly }) {
        Text($r('app.string.index_formation')).fontColor('#FFFFFF')
        Text(`${this.isInformation_uri + this.isInformation.uri}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_mediaType + this.isInformation.fileType}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_displayName + this.isInformation.displayName}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_title + this.isInformation.get('title')}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_width + this.isInformation.get('width')}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_height + this.isInformation.get('height')}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_orientation + this.isInformation.get('orientation')}`).fontColor('#FFFFFF')
        Text(`${this.isInformation_duration + getTimeString(this.isInformation.get('duration'))}`).fontColor('#FFFFFF')
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