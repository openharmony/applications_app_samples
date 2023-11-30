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

@Entry
@Component
struct WidgetCard {
  /*
   * The title.
   */
  readonly TITLE: Resource = $r('app.string.FormTitle');
  /*
   * The subtext.
   */
  readonly SUBTEXT: Resource = $r('app.string.FormThemes');
  /*
   * The action topic.
   */
  readonly TOPIC: Resource = $r('app.string.Topic');
  /*
   * The action topic.
   */
  readonly TOPIC_AGAIN: Resource = $r('app.string.Topic_Again');
  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'message';
  /*
   * The message.
   */
  readonly MESSAGE: string = 'message';
  /*
   * The width percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  @State isClick: Boolean = false

  build() {
    Row() {
      Column() {
        Row() {
          Column() {
            Text(this.TITLE)
              .fontColor($r('app.color.fount_color'))
              .fontSize($r('app.float.16fp'))
              .width($r('app.float.240vp'))
              .height($r('app.float.22vp'))
              .fontWeight(500)
              .textAlign(TextAlign.Start)
              .margin({
                top: $r('app.float.14vp')
              })
            Text(this.SUBTEXT)
              .fontColor($r('app.color.fount_color'))
              .opacity(0.6)
              .fontSize($r('app.float.14fp'))
              .width($r('app.float.240vp'))
              .height($r('app.float.19vp'))
              .fontWeight(400)
              .textAlign(TextAlign.Start)
              .margin({
                top: $r('app.float.2vp'),
                bottom: $r('app.float.15vp')
              })
          }
          .margin({
            left: $r('app.float.12vp')
          })

          Column() {
            if (this.isClick) {
              Button(this.TOPIC_AGAIN)
                .backgroundColor($r('app.color.subscribe_events_background'))
                .fontSize($r('app.float.button_fount_size'))
                .fontColor($r('app.color.subscribe_events_fount'))
                .width($r('app.float.72vp'))
                .height($r('app.float.28vp'))
                .margin({
                  right: $r('app.float.12vp')
                })
            } else {
              Button(this.TOPIC)
                .backgroundColor($r('app.color.subscribe_events_background'))
                .fontSize($r('app.float.button_fount_size'))
                .fontColor($r('app.color.subscribe_events_fount'))
                .width($r('app.float.72vp'))
                .height($r('app.float.28vp'))
                .margin({
                  right: $r('app.float.12vp')
                })
            }
          }
        }
      }
      .backgroundColor($r('app.color.start_window_background'))
      .width(this.FULL_WIDTH_PERCENT)
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .onClick(() => {
      this.isClick = true
      postCardAction(this, {
        'action': this.ACTION_TYPE,
        'params': {
          message: this.MESSAGE
        }
      });
    })
  }
}