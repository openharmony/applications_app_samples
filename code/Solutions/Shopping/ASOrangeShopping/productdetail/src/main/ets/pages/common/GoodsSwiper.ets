/*
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import RouterUtil from '../../utils/RouterUtil';
import { GoodsInfo } from '../../model/DetailMode';
import { SWIPER_PICTURE_DATA } from '../../mock/LocationData';
import { VideoPage } from 'video';

@Component
export struct GoodsSwiper {
  @LocalStorageProp('goodsInfo') goodsInfo: GoodsInfo = new GoodsInfo();
  @LocalStorageProp('goodsDataRoot') goodsDataRoot: string = '';
  @State backBtnPosition: Position = {};
  @State swiperIndex: number = 0;
  @Link openFirst: boolean;

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Swiper() {
        // 视频播放
        VideoPage({ isStart: $openFirst, previewImg: this.goodsDataRoot + this.goodsInfo.imageUrl })
        ForEach(SWIPER_PICTURE_DATA, item => {
          Column() {
            Image(this.goodsDataRoot + this.goodsInfo.imageUrl)
              .height('100%')
              .padding(12)
            Image($r('app.media.alternative'))
              .width('100%')
              .aspectRatio(1)
          }
          .width('100%')
        })
      }
      .height(300)
      .index(this.swiperIndex)
      .indicator(false)
      .onChange((index: number) => {
        this.swiperIndex = index;
      })

      Text(`${this.swiperIndex + 1}/${SWIPER_PICTURE_DATA.length + 1}`)
        .fontSize(12)
        .borderRadius(12)
        .textAlign(TextAlign.Center)
        .size({ width: 46, height: 24 })
        .backgroundColor($r('app.color.bg3'))
        .margin({ right: 16, bottom: 16 })
        .fontColor($r('app.color.white'))

      Row() {
        Image($r('app.media.back'))
          .width(32)
          .aspectRatio(1)
          .onClick(() => {
            RouterUtil.goHome(getContext(this));
          })
        Blank()
      }
      .alignItems(VerticalAlign.Top)
      .padding({ left: 12, right: 12 })
      .size({ width: '100%' })
      .position(this.backBtnPosition)
    }
    .width('100%')
    .height(300)
    .backgroundColor($r('app.color.white'))
    .onAreaChange((oldArea: Area, newArea: Area) => {
      this.backBtnPosition = newArea.position;
    })
  }
}
