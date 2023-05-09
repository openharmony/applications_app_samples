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

import RouterUtil from '../../utils/RouterUtil';

@Component
export struct UserTitle {
  build() {
    Row() {
      Image($r('app.media.user_avatar'))
        .padding(2)
        .size({ width: 32, height: 32 })
        .borderRadius(6)
        .objectFit(ImageFit.Fill)

      Text($r('app.string.user_center'))
        .fontSize(16)
        .fontWeight(FontWeight.Bolder)
        .fontColor($r('app.color.white'))
        .margin({ left: 12 })

      Blank()
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .backgroundColor("#00000000")
    .padding({ top: 10, bottom: 10 })
    .onClick(() => {
      RouterUtil.gotoUserCenter();
    })
  }
}