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

@Component
export struct IconItem {
  image: string | Resource = '';
  text: string | Resource = '';

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignContent: FlexAlign.Center }) {
      Image(this.image)
        .id('itemImage')
        .height($r('app.integer.LazyForEachPage_item_image_height'))
        .width($r('app.integer.LazyForEachPage_item_image_width'))
        .objectFit(ImageFit.Contain)
        .margin({
          left: $r('app.integer.LazyForEachPage_item_image_margin_left')
        })
      Text(this.text)
        .fontSize($r('app.integer.LazyForEachPage_text_font'))
        .fontColor(Color.Black)
        .width($r('app.integer.LazyForEachPage_text_width'))
        .height($r('app.integer.LazyForEachPage_text_height'))
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height($r('app.integer.LazyForEachPage_item_height'))
  }
}