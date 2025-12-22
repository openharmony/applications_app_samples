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

// [Start click_event_handle]
@Entry
@Component
export struct Click {
  @State flag: boolean = true;
  @State btnMsg: string = 'show';

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // 请将$r('app.string.Touch_ClickEvent_text')替换为实际资源文件，在本示例中该资源文件的value值为"通过按钮的点击事件控制图片的显示和隐藏"
        Text($r('app.string.Touch_ClickEvent_text'))
          .fontSize(14)
          .fontColor('#666')
        Column() {
          Button(this.btnMsg).width(80).height(30).margin(30)
            .onClick(() => {
              if (this.flag) {
                this.btnMsg = 'hide';
              } else {
                this.btnMsg = 'show';
              }
              // 点击Button控制Image的显示和消失
              this.flag = !this.flag;
            })
          if (this.flag) {
            // 请将$r('app.media.app_icon')替换为实际资源文件
            Image($r('app.media.app_icon')).width(200).height(200)
          }
        }.height('100%').width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Touch_ClickEvent_text')替换为实际资源文件，在本示例中该资源文件的value值为"点击事件"
    .title($r('app.string.Touch_ClickEvent_title'))
  }
}
// [End click_event_handle]