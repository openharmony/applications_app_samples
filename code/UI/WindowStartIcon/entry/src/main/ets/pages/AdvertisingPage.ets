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

import { router, window } from '@kit.ArkUI';

@Entry
@Component
struct TransitionsAnimation {
  @State pageCountDown: number = 6; // 进场动画总用时6s
  private timer: number = 0;

  // 页面显示时打开定时器
  onPageShow() {
    this.changeFullScreen(true);
    this.timer = setInterval(() => {
      this.pageCountDown--;
      if (this.pageCountDown === 0) {
        this.changeFullScreen(false);
        clearInterval(this.timer); // 关闭定时器
        router.replaceUrl({ url: 'pages/Index' });
      }
    }, 1000)
  }

  /**
   * 页面显示打开沉浸式，页面销毁关闭
   * @param isFull是否需要打开沉浸式
   */
  changeFullScreen(isFull: boolean) {
    let context = getContext();
    window.getLastWindow(context, (err, window) => {
      window.setWindowLayoutFullScreen(isFull);
    })
  }

  build() {
    Column() {
      // 跳过按钮和倒计时
      Row() {
        Row() {
          Text($r('app.string.skip'))
            .fontSize($r('app.integer.advertising_description_skip_font_size'))
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .margin({ left: $r('app.integer.skip_text_margin_left') })
          Text(`${this.pageCountDown}`)
            .fontSize($r('app.integer.advertising_description_skip_font_size'))
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .margin({ left: $r('app.integer.advertising_description_pageCountDown_margin') })
        }
        .width($r('app.integer.advertising_description_skip_width'))
        .aspectRatio(2.4)
        .backgroundColor($r('app.string.advertising_description_backgroundColor'))
        .borderRadius($r('app.integer.advertising_description_skip_borderRadius'))
        .onClick(() => {
          this.changeFullScreen(false);
          this.pageCountDown = 0;
          clearInterval(this.timer); // 手动跳过时关闭定时器
          router.replaceUrl({ url: 'pages/Index' });
        })
      }
      .width('100%')
      .margin({top: $r('app.integer.skip_button_margin_top'),right: $r('app.integer.skip_button_margin_right')})
      .justifyContent(FlexAlign.End)

      // 广告页动图和描述
      Column() {
        Row() {
          Image($r('app.media.enter_app_animation'))
            .objectFit(ImageFit.Contain)
            .width('100%')
            .aspectRatio(1.4)
        }
        .margin({ top: $r('app.integer.advertising_page_gif_margin') })

        Column() {
          Text($r('app.string.Implementation_case_of_startup_page'))
            .fontSize($r('app.integer.advertising_page_font_size'))
          Text($r('app.string.advertising_description'))
            .margin({ top: $r('app.integer.advertising_description_text_margin') })
            .fontSize($r('app.integer.advertising_description_font_size'))
            .opacity(0.6)
        }
        .margin({ top: $r('app.integer.advertising_description_margin') })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.advertising_backgroundColor'))
  }
}