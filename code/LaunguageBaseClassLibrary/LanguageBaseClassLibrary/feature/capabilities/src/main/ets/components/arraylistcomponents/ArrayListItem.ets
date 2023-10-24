/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { Information } from '../../model/Information';

@Component
export struct ArrayListItem {
  @ObjectLink information: Information;
  private index: number = 0;
  private handleOnClick: (index: number) => void = () => {};

  build() {
    Row() {
      Image($r('app.media.contact'))
        .width('20%')
        .objectFit(ImageFit.Contain)
      Column() {
        Row() {
          Text($r("app.string.contact_name"))
            .fontSize(24)
            .fontColor(Color.Black)
          Text(this.information.name)
            .fontColor(Color.Black)
            .fontSize(24)
        }
        .width('100%')
        .margin({ top: 5 })

        Row() {
          Text($r("app.string.contact_age"))
            .fontColor(Color.Black)
            .fontSize(24)
          Text(this.information.age.toString())
            .fontColor(Color.Black)
            .fontSize(24)
        }
        .width('100%')
        .margin({ top: 5 })

        Row() {
          Text($r("app.string.contact_phone"))
            .fontColor(Color.Black)
            .fontSize(24)
          Text(this.information.phone)
            .fontColor(Color.Black)
            .fontSize(24)
        }
        .width('100%')
        .margin({ top: 5 })
      }
      .width('55%')
      .margin({ left: 10 })
      .justifyContent(FlexAlign.Start)

      Blank()
      Button() {
        Text($r('app.string.button_delete'))
          .key('delContact')
          .fontColor(Color.Red)
          .fontSize(19)
          .width(100)
          .textAlign(TextAlign.Center)
      }
      .type(ButtonType.Capsule)
      .backgroundColor($r("app.color.button_bg"))
      .height(40)
      .onClick(() => {
        this.handleOnClick(this.index);
      })
    }
    .width('100%')
    .padding(10)
    .align(Alignment.Center)
    .borderRadius(20)
    .backgroundColor(Color.White)
  }
}