/*
* Copyright (c) 2022 Huawei Device Co., Ltd.
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
export struct Choice {
  build() {
    Row() {
      Text($r('app.string.selected'))
        .fontSize(14)
        .fontColor($r('app.color.blank'))
      Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
        Text($r('app.string.select_configuration'))
          .fontSize(14)
          .padding({ left: 16 })
      }
      .flexGrow(1)
      .flexShrink(1)

      Image($r('app.media.alternative'))
        .objectFit(ImageFit.Contain)
        .width(12)
        .aspectRatio(1)
    }
    .width('100%')
    .padding({ top: 12, bottom: 18, left: 12, right: 12 })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Top)
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
  }
}