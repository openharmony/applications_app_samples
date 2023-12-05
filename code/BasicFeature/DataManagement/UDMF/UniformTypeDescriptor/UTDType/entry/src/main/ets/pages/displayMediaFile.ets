/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import router from '@ohos.router';
import { logger } from '../util/Logger';

const TAG: string = 'DisplayMediaFile';

interface paramsTape {
  src: string,
  selectIconFile: string,
}

@Entry
@Component
struct selectMediaType {
  @State src: string = (router.getParams() as paramsTape).src;
  @State selectIconFile: string = (router.getParams() as paramsTape).selectIconFile;
  private routerBackUrl: string = 'pages/selectMediaType'
  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.utdType_back'))
            .id('thirdPageBack')
            .width(24)
            .height(24)
            .visibility(Visibility.Visible)
            .objectFit(ImageFit.Fill)
            .margin({left: 24, right: 12})
            .onClick(() => {
              router.pushUrl({url: this.routerBackUrl})
            })
          Text('媒体文件信息')
            .fontStyle(FontStyle.Normal)
            .fontSize(20)
            .textAlign(TextAlign.Start)
            .fontWeight(700)
        }
        .width('100%')
        .height(56)
      }
      .width(280)
      .height(56)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      Column() {
        List({ space: 2, initialIndex: 0 }) {
          ListItem() {
            Row() {
              Image(this.selectIconFile == "" ? $r('app.media.file') : this.selectIconFile)
                .id('imageBack')
                .width(24)
                .height(24)
                .objectFit(ImageFit.Fill)
                  //.alignSelf(ItemAlign.Start)
                .margin({ left: 12, right: 12 })
              Text(this.src)
                .fontSize(16)
                .textAlign(TextAlign.Start)
                .fontWeight(500)
            }.width('100%').height('100%')
          }
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Auto)
        .friction(0.6)
        .margin({left: 12, right: 12})
        .borderRadius(24)
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
          logger.info(TAG, 'first' + firstIndex)
          logger.info(TAG, 'last' + lastIndex)
          logger.info(TAG, 'center' + centerIndex)
        })
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          logger.info(TAG, `onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset)
        })
        .backgroundColor(0xFFFFFF)
        .alignListItem(ListItemAlign.Center)
      }
      .width('100%')
      .height(64)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
