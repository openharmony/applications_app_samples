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
        Text(`文件资源编号：${this.isInformation.id}`).fontColor('#FFFFFF')
        Text(`文件资源uri：${this.isInformation.uri}`).fontColor('#FFFFFF')
        Text(`文件扩展属性：${this.isInformation.mimeType}`).fontColor('#FFFFFF')
        Text(`媒体类型：${this.isInformation.mediaType}`).fontColor('#FFFFFF')
        Text(`文件名：${this.isInformation.displayName}`).fontColor('#FFFFFF')
        Text(`文件标题：${this.isInformation.title}`).fontColor('#FFFFFF')
        Text(`相对公共目录路径：${this.isInformation.relativePath}`).fontColor('#FFFFFF')
        Text(`父目录id：${this.isInformation.parent}`).fontColor('#FFFFFF')
        Text(`文件大小：${filterSize(this.isInformation.size)}`).fontColor('#FFFFFF')
        Text(`添加日期：${getDateTime(this.isInformation.dateAdded)}`).fontColor('#FFFFFF')
        Text(`修改日期：${getDateTime(this.isInformation.dateModified)}`).fontColor('#FFFFFF')
        Text(`拍摄日期：${getDateTime(this.isInformation.dateTaken)}`).fontColor('#FFFFFF')
        Text(`作者：${this.isInformation.artist}`).fontColor('#FFFFFF')
        Text(`专辑：${this.isInformation.audioAlbum}`).fontColor('#FFFFFF')
        Text(`图片宽度：${this.isInformation.width}`).fontColor('#FFFFFF')
        Text(`图片高度：${this.isInformation.height}`).fontColor('#FFFFFF')
        Text(`图片显示方向：${this.isInformation.orientation}`).fontColor('#FFFFFF')
        Text(`持续时间：${getTimeString(this.isInformation.duration)}`).fontColor('#FFFFFF')
        Text(`文件所归属的相册编号：${this.isInformation.albumId}`).fontColor('#FFFFFF')
        Text(`文件所归属相册uri：${this.isInformation.albumUri}`).fontColor('#FFFFFF')
        Text(`文件所归属相册名称： ${this.isInformation.albumName}`).fontColor('#FFFFFF')
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