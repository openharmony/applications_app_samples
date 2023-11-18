/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import avSession from '@ohos.multimedia.avsession';

@Component
export struct SongItem {
  @State index: number = -1;
  @State item: avSession.AVMediaDescription | null = null;
  @Link currentPlayInfo: avSession.AVMediaDescription;

  build(){
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }){
        Text('' + (this.index + 1)).fontSize(12)
          .fontColor(this.currentPlayInfo.assetId === this.item?.assetId ? '#0A59F7' : Color.Black)
          .opacity(0.3)
        Flex({
          direction: FlexDirection.Row,
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center
        }){
          Text(this.item?.title)
            .fontSize(14)
            .opacity(1)
            .maxLines(1)
            .fontWeight(FontWeight.Medium)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor(this.currentPlayInfo.assetId === this.item?.assetId ? '#0A59F7' : Color.Black)
          Text(this.item?.artist)
            .margin({ top: 8 })
            .fontSize(12)
            .opacity(1)
            .fontWeight(FontWeight.Regular)
            .fontColor(this.currentPlayInfo.assetId === this.item?.assetId ? '#0A59F7' : Color.Black)
        }.margin({ left: 12 })
      }
      .margin({ left: 0 })

      Image($r('app.media.icon'))
        .size({ width: '24vp', height: '24vp' })
        .fillColor('#0A59F7')
        .backgroundColor(Color.Transparent)
        .margin({ left: 4 })
        .opacity(1)
        .visibility(this.currentPlayInfo.assetId === this.item?.assetId ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
    .height(56)
    .padding({ right: 24 })
  }
}