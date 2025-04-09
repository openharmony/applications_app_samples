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

// 常量提取
const BACK_BUTTON_SIZE = 12; // 返回按钮宽高
const TITLE_BAR_HEIGHT = 56; // 标题栏高度
const BACK_BUTTON_MARGIN_LEFT = 24; // 返回按钮左边距
const TITLE_MARGIN_LEFT = 24; // 标题文字左边距
const TITLE_FONT_SIZE = 20; // 标题字体大小
const ASPECT_RATIO = 1; // 返回按钮宽高比

@Component
export default struct TitleBar {
  public title: string | Resource = $r('app.string.VPN_Case');
  public hasBackPress: boolean = false;

  build() {
    Row() {
      if (this.hasBackPress) {
        Row() {
          Image($r('app.media.back'))
            .id('btnBack')
            .width(BACK_BUTTON_SIZE)
            .height(BACK_BUTTON_SIZE)
        }
        .height('100%')
        .aspectRatio(ASPECT_RATIO)
        .margin({ left: BACK_BUTTON_MARGIN_LEFT })
        .onClick(() => {
          router.back();
        })
      }
      Text(this.title)
        .fontSize(TITLE_FONT_SIZE)
        .fontColor(Color.Black)
        .margin(this.hasBackPress ? {} : { left: TITLE_MARGIN_LEFT })
      Blank()
    }
    .width('100%')
    .height(TITLE_BAR_HEIGHT)
    .backgroundColor(Color.Transparent)
  }
}
