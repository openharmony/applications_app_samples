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

import { CommonConstants } from '../common/constants/CommonConstants';

@Component
export struct IconButton {
  @Prop iconResource: Resource;

  build() {
    Row() {
      SymbolGlyph(this.iconResource)
        .fontSize(24)
        .fontColor([Color.White])
    }
    .width(40)
    .height(40)
    .backgroundColor('rgba(255,255,255,0.1)')
    .borderRadius(20)
    .justifyContent(FlexAlign.Center)
    .margin({
      right: 8
    })
  }
}

@Component
export struct EpisodeChoose {
  @Prop numberTest: number[];
  @Link videoIndex: number;
  @Link episodeChooseIndex: number;

  build() {
    Flex() {
      ForEach(this.numberTest, (item: number, index) => {
        RelativeContainer() {
          Text(JSON.stringify(item))
            .width(46)
            .height(46)
            .fontSize(16)
            .textAlign(TextAlign.Center)
          SymbolGlyph($r('sys.symbol.rhythm'))
            .fontSize(16)
            .alignRules({
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
            })
            .fontColor(['rgba(10,89,247,0.5)'])
            .offset({
              x: 2,
              y: 2
            })
            .visibility(this.videoIndex === index ? Visibility.Visible : Visibility.Hidden)
        }
        .width(46)
        .height(46)
        .borderWidth('1')
        .backgroundColor(this.videoIndex === index ? 'rgba(10,89,247,0.05)' : Color.White)
        .borderColor(this.videoIndex === index ? 'rgba(10,89,247,0.5)' : 'rgb(241,243,245)')
        .borderRadius(8)
        .margin({
          right: 12
        })
        .onClick(() => {
          this.episodeChooseIndex = item - 1;
        })
      }, (item: number) => JSON.stringify(item))
    }
  }
}

@Component
export struct SpeedChoose {
  @Link speedChoosen: string;
  @Link isSpeedSheetShow: boolean;

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
        ForEach(CommonConstants.SPEED_CHOOSE, (item: string, index: number) => {
          Row() {
            Text(item)
              .fontSize(16)
              .fontWeight(700)
              .fontColor(this.speedChoosen === item ? 'rgb(10,89,247)' : 'rgba(0,0,0,0.9)')
          }
          .width(100)
          .height(72)
          .backgroundColor(this.speedChoosen === item ? 'rgba(10,89,247,0.05)' : '#eeeeee')
          .borderWidth(1)
          .borderColor(this.speedChoosen === item ? 'rgba(10,89,247,0.5)' : '#eeeeee')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .layoutWeight(1)
          .margin({
            bottom: 12,
            right: 16
          })
          .borderRadius(8)
          .onClick(() => {
            this.speedChoosen = item;
            this.isSpeedSheetShow = false;
          })
        }, (item: string) => item)
      }
      .width('100%')
    }
    .padding({
      top: 16,
      left: 16,
      bottom: 42
    })
  }
}
