/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { getStringData } from '../../../../data/ResourceDataHandle';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import ShowToast from '../../../../util/ShowToast';

@Entry
@Component
struct FocusEventSample {
  @State oneButtonColor: Resource = $r('app.color.focus_on_background');
  @State twoButtonColor: Resource = $r('app.color.pop_up_background');
  @State threeButtonColor: Resource = $r('app.color.pop_up_background');
  @State oneFontColor: Resource = $r('app.color.white');
  @State twoFontColor: Resource = $r('app.color.focus_on_background');
  @State threeFontColor: Resource = $r('app.color.focus_on_background');

  build() {
    Column() {
      TitleBar({ title: $r('app.string.focus_event') })
      Scroll() {
        Column({ space: 16 }) {
          IntroductionTitle({ introduction: $r('app.string.focus_event_description') })
          // 通过外接键盘的Tab可以让焦点在三个按钮间移动，按钮获焦时颜色变化，失焦时变回原背景色
          Button($r('app.string.focus_event_button_one'))
            .backgroundColor(this.oneButtonColor)
            .width('100%')
            .margin({ left: 24, right: 24 })
            .height(40)
            .fontColor(this.oneFontColor)
            .focusable(true)
            .onFocus(() => {
              this.oneButtonColor = $r('app.color.focus_on_background');
              this.oneFontColor = $r('app.color.white');
              ShowToast.shortToast($r('app.string.focus_event_toast_text'));
            })
            .onBlur(() => {
              this.oneButtonColor = $r('app.color.pop_up_background');
              this.oneFontColor = $r('app.color.focus_on_background');
            })
          Button($r('app.string.focus_event_button_two'))
            .backgroundColor(this.twoButtonColor)
            .width('100%')
            .margin({ left: 24, right: 24 })
            .height(40)
            .fontColor(this.twoFontColor)
            .focusable(true)
            .onFocus(() => {
              this.twoButtonColor = $r('app.color.focus_on_background');
              this.twoFontColor = $r('app.color.white');
              ShowToast.shortToast($r('app.string.focus_event_toast_text'));
            })
            .onBlur(() => {
              this.twoFontColor = $r('app.color.focus_on_background');
              this.twoButtonColor = $r('app.color.pop_up_background');
            })
          Button($r('app.string.focus_event_button_three'))
            .backgroundColor(this.threeButtonColor)
            .width('100%')
            .height(40)
            .fontColor(this.threeFontColor)
            .focusable(true)
            .margin({ left: 24, right: 24, bottom: 10 })
            .onFocus(() => {
              this.threeButtonColor = $r('app.color.focus_on_background');
              this.threeFontColor = $r('app.color.white');
              ShowToast.shortToast($r('app.string.focus_event_toast_text'));
            })
            .onBlur(() => {
              this.threeFontColor = $r('app.color.focus_on_background');
              this.threeButtonColor = $r('app.color.pop_up_background');
            })
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}