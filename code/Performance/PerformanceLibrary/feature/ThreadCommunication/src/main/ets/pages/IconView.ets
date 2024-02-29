/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// 字体透明度
const TEXT_OPACITY: number = 0.8;

@Component
export struct IconItem {
  image: string | Resource = '';
  text: string | Resource = '';

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignContent: FlexAlign.Center }) {
      Image(this.image)
        .height(40)
        .width(40)
        .objectFit(ImageFit.Contain)
        .margin({
          left: 15
        })

      Text(this.text)
        .fontSize(20)
        .fontColor(Color.Black)
        .width(100)
        .height(50)
        .opacity(TEXT_OPACITY)
        .textAlign(TextAlign.Center)
    }
    .width($r('app.string.percent_100'))
    .height(50)
  }
}