/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { getStringData } from '../../../../data/ResourceDataHandle';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import ShowToast from '../../../../util/ShowToast';
import Logger from '../../../../util/Logger';

const TAG: string = 'CustomScrollingEvent';

@Entry
@Component
struct CustomScrollingEvent {
  private scrollerForScroll: Scroller = new Scroller();
  private scrollerForList: Scroller = new Scroller();
  @State files: string[] = [];
  @State listPosition: number = 0; // 0代表滚动到List顶部，1代表中间值，2代表滚动到List底部。

  aboutToAppear() {
    for (let i = 1; i <= 30; i++) {
      let file: string = "file" + i.toString();
      this.files.push(file);
    }
  }

  build() {
    Column() {
      // 标题
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .margin({ left: 12 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back()
            })
            .id('backBtn')
          Text($r('app.string.custom_scrolling_event'))
            .fontSize(20)
            .layoutWeight(1)
            .fontWeight(700)
            .margin({ left: 16 })
            .align(Alignment.Start)
          Blank()
        }
        .height(56)
        .width('100%')
      }
      .height(56)
      .width('100%')
      .padding({ left: 12, right: 12 })

      Scroll(this.scrollerForScroll) {
        Column() {
          Column() {
            Text($r('app.string.custom_scrolling_area'))
              .fontSize(36)
              .fontWeight(400)
              .fontFamily('HarmonyHeiTi')
              .textAlign(TextAlign.Start)
              .fontColor('#182431')
              .opacity(0.15)
              .margin({ top: 142 })
              .id('scrollText')
            Image($r('app.media.button'))
              .width(40)
              .height(40)
              .margin({ top: 78, bottom: 40 })
              .id('scrollBtn')
              .objectFit(ImageFit.Contain)
          }
          .height(332)
          .width('100%')
          .border({
            width: 1,
            color: '#55182431',
            radius: 24,
            style: BorderStyle.Solid
          })
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 16 })
          .backgroundColor('#F2F3F4')
          .id('ScrollArea')

          // 目录列表
          List({ space: 12, scroller: this.scrollerForList }) {
            ForEach(this.files, (file: string, index: number) => {
              ListItem() {
                Row() {
                  Text(file)
                    .fontSize(16)
                    .fontWeight(500)
                    .fontFamily('HarmonyHeiTi-Medium')
                    .textAlign(TextAlign.Start)
                }
                .width('100%')
                .height(56)
                .borderRadius(24)
                .backgroundColor(0xFFFFFF)
                .alignItems(VerticalAlign.Center)
                .padding({ left: 12, right: 12 })
              }
              .id("ListItem" + index)
              .width('100%')
            })
          }
          .width('100%')
          .height('80%')
          .listDirection(Axis.Vertical) // 排列方向
          .borderRadius(24)
          .edgeEffect(EdgeEffect.None) // 边缘效果设置为Spring
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
          .onReachStart(() => {
            this.listPosition = 0
          })
          .onReachEnd(() => {
            this.listPosition = 2
          })
          .onScrollFrameBegin((offset: number) => {
            if ((this.listPosition == 0 && offset <= 0) || (this.listPosition == 2 && offset >= 0)) {
              this.scrollerForScroll.scrollBy(0, offset);
              return { offsetRemain: 0 };
            }
            this.listPosition = 1;
            return { offsetRemain: offset };
          })
          .id('fileList')
        }
        .margin({ left: 12, right: 12 })
        .onChildTouchTest((touchinfo) => {
          Logger.info(TAG, `touchinfo array len: ${touchinfo.length}`);
          for (let info of touchinfo) {
            Logger.info(TAG, `touchinfo info.id: ${info.id}`);
            Logger.info(TAG, `touchinfo windowX: ${info.windowX}, windowY: ${info.windowY}`);
            Logger.info(TAG, `touchinfo parentX: ${info.parentX}, parentY: ${info.parentY}`);
            Logger.info(TAG, `touchinfo x: ${info.x}, y: ${info.y}`);
            Logger.info(TAG, `touchinfo rect.x: ${info.rect.x}, rect.y: ${info.rect.y}, rect.width: ${info.rect.width}, rect.height: ${info.rect.height}`);
            let compontWidth = info.rect.x + info.rect.width;
            let compontHeight = info.rect.y + info.rect.height;
            if (info.id == 'ScrollArea' &&
              info.x > 0 &&
              info.parentX < compontWidth &&
              info.parentX > info.rect.x &&
              info.y > 0 &&
              info.parentY < compontHeight &&
              info.parentY > info.rect.y) {
              Logger.info(TAG, `touchinfo touch point at scope of component: ${info.id}`);
              return { id: 'fileList', strategy: TouchTestStrategy.FORWARD };
            }
          }
          return { strategy: TouchTestStrategy.DEFAULT };
        })
      }
      .edgeEffect(EdgeEffect.Spring)
      .friction(0.6)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(700)
      .id('GlobalScroll')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}