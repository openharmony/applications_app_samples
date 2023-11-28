/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import Contact from '../model/Contact'

const enum Gender {
  MALE,
  FEMALE
};

@Component
export struct QueryItem {
  private contact: Contact | undefined = undefined;

  aboutToAppear() {
    if (this.contact) {
      let phone: string = this.contact.phone;
      phone = phone.replace(phone.substring(3, 7), '****');
      this.contact.phone = phone;
    }
  }

  build() {
    if (this.contact != undefined) {
      Row() {
        Image(this.contact.gender === Gender.MALE ? $r('app.media.contact_photo_male') : $r('app.media.contact_photo_female'))
          .height(80).width(80)
          .objectFit(ImageFit.Fill)
        Column() {

          Row() {
            Text($r("app.string.contact_name"))
              .fontSize(25)
              .fontColor($r("app.color.grey"))
            Text(this.contact.name)
              .fontSize(30)
              .margin({ left: 16 })
              .fontColor($r("app.color.grey"))
          }.width('100%')

          Row() {
            Text($r("app.string.phone"))
              .fontSize(25)
              .fontColor($r("app.color.grey"))

            Text(this.contact.phone)
              .fontSize(25)
              .margin({ left: 16 })
              .fontColor($r("app.color.grey"))
          }.width('100%')

          Row() {
            Text($r("app.string.age"))
              .fontSize(25)
              .fontColor($r("app.color.grey"))

            Text(this.contact.age == 0 ? "--" : this.contact.age + "")
              .fontSize(25)
              .margin({ left: 16 })
              .fontColor($r("app.color.grey"))
          }.width('100%')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor($r("app.color.white"))
      .borderRadius(16)
    }
  }
}