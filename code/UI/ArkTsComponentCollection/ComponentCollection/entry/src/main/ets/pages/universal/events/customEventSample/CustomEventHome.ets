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

@Entry
@Component
struct CustomEventHome {
  private btnFontColor: Resource = $r('app.color.white');
  private customClickUrl: string = 'pages/universal/events/customEventSample/CustomClickEvent';
  private customScrollingUrl: string = 'pages/universal/events/customEventSample/CustomScrollingEvent';

  build() {
    Column() {
      // 标题
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .margin({ left: 24 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back()
            })
            .id('backBtn')
          Text($r('app.string.send_event'))
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

      Blank()
      Column({ space: 12 }) {
        Button($r('app.string.custom_click_event_button'))
          .backgroundColor('#007DFF')
          .width('100%')
          .height(40)
          .fontSize(16)
          .fontWeight(500)
          .borderRadius(20)
          .fontColor(this.btnFontColor)
          .id('customClick')
          .onClick(() => {
            router.pushUrl({
              url: this.customClickUrl
            });
          })

        Button($r('app.string.custom_Scrolling_event_button'))
          .backgroundColor('#007DFF')
          .width('100%')
          .height(40)
          .fontSize(16)
          .fontWeight(500)
          .borderRadius(20)
          .fontColor(this.btnFontColor)
          .id('customScrolling')
          .onClick(() => {
            router.pushUrl({
              url: this.customScrollingUrl
            });
          })
      }
      .padding({ left: 24, right: 24, bottom: 16 })
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.End)
      .flexShrink(1)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}