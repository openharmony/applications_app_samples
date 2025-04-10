/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

@Component
export default struct TitleBar {
  private title: string | Resource = $r('app.string.Socket');
  private hasBackPress: boolean = false;

  build() {
    Row() {
      if (this.hasBackPress) {
        Row() {
          Image($r('app.media.back'))
            .id('btnBack')
            .width(12)
            .height(12)
        }
        .height('100%')
        .aspectRatio(1)
        .margin({ left: 24 })
        .onClick(() => {
          router.back();
        })
      }
      Text(this.title)
        .fontSize(20)
        .fontColor(Color.Black)
        .margin(this.hasBackPress ? {} : { left: 24 })
      Blank()
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.Transparent)
  }
}