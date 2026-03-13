/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { VideoCastController } from '../controller/VideoCastController';
import { VideoData } from '../model/VideoData';
import { AVCastingControllerView } from './AVCastingControllerView';
import { VideoCastHeadView } from './VideoCastHeadView';

@Component
export struct VideoCastingView {
  @StorageLink('avCastController') avCastPlayerController?: VideoCastController = undefined;
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('castingList') castingList: string[] = [];
  @Consume videoType: string;
  @Prop videoList: VideoData[];
  @Link @Watch('indexChange') videoIndex: number;
  @Link @Watch('episodeChoose') episodeChooseIndex: number;
  @Link videoPlayPathStack: NavPathStack;
  @State duration: number = this.videoList[this.videoIndex].duration;

  episodeChoose() {
    this.videoIndex = this.episodeChooseIndex;
  }

  indexChange() {
    this.avCastPlayerController?.setCastResource(this.videoIndex, 0);
    this.duration = this.videoList[this.videoIndex].duration;
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
      VideoCastHeadView({ showDeviceName: false, path: this.videoPlayPathStack })

      Row() {
        SymbolGlyph($r('sys.symbol.wireless_projection'))
          .fontSize(24)
          .fontColor([Color.White])
          .margin({
            right: 12
          })
        Text($r('app.string.casting', this.deviceName))
          .fontColor(Color.White)

      }
      .alignItems(VerticalAlign.Center)
      .alignSelf(ItemAlign.Center)

      AVCastingControllerView({ durationTime: this.duration })

    }
    .padding({
      left: 16,
      right: 16
    })
    .width('100%')
    .height(184)
    .backgroundImage(this.videoList[this.videoIndex].head)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundBlurStyle(BlurStyle.Thin)
  }
}