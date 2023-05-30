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

import router from '@ohos.router'
import emitter from '@ohos.events.emitter'
import Logger from '../util/Logger'


@Component
export default struct NavigationBar {
  @Prop buttonEnable: boolean;
  private title: string = "";
  private buttonTip: string = "";
  private clickCallback = () => {
  }

  startUpload() {
    let innerEvent = {
      eventId: 1,
      priority: emitter.EventPriority.HIGH
    };
    emitter.emit(innerEvent);
    Logger.info("send publish event!")
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.Back'))
          .width($r('app.float.navigation_back_ic_width'))
          .height($r('app.float.navigation_back_ic_width'))
          .focusable(false)
      }
      .width($r('app.float.navigation_back_click_area_width'))
      .height($r('app.float.navigation_back_click_area_width'))
      .onClick(() => {
        router.back()
      })

      Text(this.title)
        .fontSize($r('app.float.navigation_back_title_font_size'))
      Blank()
      Button(this.buttonTip)
        .id('finish')
        .fontSize($r('app.float.navigation_button_font_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor(this.buttonEnable ? $r('app.color.button_available') : $r('app.color.button_disable'))
        .enabled(this.buttonEnable)
        .height($r('app.float.navigation_button_height'))
        .backgroundColor($r('app.color.transparent'))
        .onClick(this.clickCallback)
        .padding({ left: $r('app.float.navigation_button_padding'), right: $r('app.float.navigation_button_padding') })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .padding({ left: $r('app.float.menu_lr_padding'), right: $r('app.float.menu_lr_padding') })
    .width('100%')
    .margin({ right: $r('app.float.navigation_margin'), top: $r('app.float.navigation_margin') })
  }
}