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

import { TitleBar } from '../../../../common/TitleBar';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { getStringData } from '../../../../data/ResourceDataHandle';

@Entry
@Component
struct MouseEventSample {
  @State hoverText: Resource = $r('app.string.mouse_event_onHover_description');
  @State mouseText: string = '';
  @State action: string = '';
  @State mouseBtn: string = '';

  build() {
    Column() {
      TitleBar({ title: $r('app.string.mouse_event') })
      Column({ space: 12 }) {
        Row() {
          Text(this.mouseText)
            .width('100%')
            .textAlign(TextAlign.Start)
            .padding({ left: 12 })
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius(24)
        .backgroundColor(Color.White)
        .height(150)
        .width('90%')

        IntroductionTitle({ introduction: $r('app.string.mouse_event_move_description') })
        Button(this.hoverText, { type: ButtonType.Capsule, stateEffect: false })
          .width('90%')
          .height(40)
          .onHover((isHover: boolean) => {
            // 通过onHover事件动态修改按钮在是否有鼠标悬浮时的文本内容与背景颜色
            if (isHover) {
              this.hoverText = $r('app.string.mouse_event_hover_description');
            } else {
              this.hoverText = $r('app.string.mouse_event_onHover_description');
            }
          })

        IntroductionTitle({ introduction: $r('app.string.mouse_event_click_description') })
        Button($r('app.string.mouse_event_onMouse_text'), { type: ButtonType.Capsule, stateEffect: false })
          .width('90%')
          .height(40)
          .onMouse((event: MouseEvent) => {
            switch (event.button) {
              case MouseButton.None:
                this.mouseBtn = getStringData($r('app.string.mouse_event_mouseBtn_none'));
                break;
              case MouseButton.Left:
                this.mouseBtn = getStringData($r('app.string.mouse_event_mouseBtn_left'));
                break;
              case MouseButton.Right:
                this.mouseBtn = getStringData($r('app.string.mouse_event_mouseBtn_right'));
                break;
              case MouseButton.Back:
                this.mouseBtn = getStringData($r('app.string.mouse_event_mouseBtn_back'));
                break;
              case MouseButton.Forward:
                this.mouseBtn = getStringData($r('app.string.mouse_event_mouseBtn_forward'));
                break;
              case MouseButton.Middle:
                this.mouseBtn = getStringData($r('app.string.mouse_event_mouseBtn_middle'));
                break;
            }
            switch (event.action) {
              case MouseAction.Hover:
                this.action = getStringData($r('app.string.mouse_event_mouseAction_hover'));
                break;
              case MouseAction.Press:
                this.action = getStringData($r('app.string.mouse_event_mouseAction_press'));
                break;
              case MouseAction.Move:
                this.action = getStringData($r('app.string.mouse_event_mouseAction_move'));
                break;
              case MouseAction.Release:
                this.action = getStringData($r('app.string.mouse_event_mouseAction_release'));
                break;
            }
            this.mouseText = 'onMouse:\nButton = ' + this.mouseBtn +
            '\nAction = ' + this.action + '\nXY=(' + event.x + ',' + event.y + ')' +
            '\nscreenXY=(' + event.screenX + ',' + event.screenY + ')';
          })
      }
      .margin({ top: 12 })
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}

