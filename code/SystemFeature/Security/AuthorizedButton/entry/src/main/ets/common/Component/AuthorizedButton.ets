/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Component
export struct AuthorizedButton {
  private title: Resource = $r('app.string.EntryAbility_label');
  @Link image: Resource;
  @Link backColor: Resource;
  @Link textColor: Resource;

  build() {
    Row() {
      Image(this.image)
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
      Text(this.title)
        .fontSize(16)
        .margin({ left: 5 })
        .fontColor(this.textColor)
    }
    .margin({ bottom: 10 })
    .width(92)
    .height(40)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .borderRadius(20)
    .backgroundColor(this.backColor)
  }
}