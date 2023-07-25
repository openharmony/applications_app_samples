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

class Utils {
  static rect_left
  static rect_top
  static rect_right
  static rect_bottom
  static rect_value

  //获取组件所占矩形区域坐标
  static getComponentRect(key) {
    let strJson = getInspectorByKey(key)
    let obj = JSON.parse(strJson)
    let rectInfo = JSON.parse('[' + obj.$rect + ']')
    this.rect_left = JSON.parse('[' + rectInfo[0] + ']')[0]
    this.rect_top = JSON.parse('[' + rectInfo[0] + ']')[1]
    this.rect_right = JSON.parse('[' + rectInfo[1] + ']')[0]
    this.rect_bottom = JSON.parse('[' + rectInfo[1] + ']')[1]
    return this.rect_value = {
      "left": this.rect_left, "top": this.rect_top, "right": this.rect_right, "bottom": this.rect_bottom
    }
  }
}

import { getStringData } from '../../../../data/ResourceDataHandle';
import { TitleBar } from '../../../../common/TitleBar';

@Extend(Button) function buttonStyle() {
  .fontSize(16)
  .height(40)
  .width('100%')
  .margin({ left: 24, right: 24, top: 12, bottom: 8 })
}

@Entry
@Component
struct ComponentIDSample {
  @State text: string = '';

  build() {
    Column() {
      TitleBar({ title: $r('app.string.component_id') })
      Row() {
        Column() {
          Row() {
            Text(this.text)
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ left: 12 })
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(24)
          .backgroundColor(Color.White)
          .height(60)
          .margin({ left: 12, right: 12, bottom: 8 })
          .width('100%')

          Button($r('app.string.component_id_onKeyTab'))
            .buttonStyle()
            .onKeyEvent(() => {
              this.text = getStringData($r('app.string.component_id_onKeyTab'));
            })

          Button($r('app.string.component_id_click'))
            .buttonStyle()
            .onClick(() => {
              this.text = getStringData($r('app.string.component_id_click_text'));
              setTimeout(() => {
                sendEventByKey(getStringData($r('app.string.componentId_longClick')), 11, ''); // 向id为"longClick"的组件发送长按事件
              }, 2000);
            })
            .id('click')

          Button($r('app.string.component_id_longClick'))
            .buttonStyle()
            .gesture(
              LongPressGesture().onActionEnd(() => {
                this.text = getStringData($r('app.string.component_id_longClick_text'));
                setTimeout(() => {
                  let rect = Utils.getComponentRect(getStringData($r('app.string.componentId_onTouch'))); // 获取id为"onTouch"组件的矩形区域坐标
                  let touchPoint: TouchObject = {
                    id: 1,
                    x: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
                    y: rect.top + (rect.bottom - rect.top) / 2, // 组件中心点y坐标
                    type: TouchType.Down,
                    screenX: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
                    screenY: rect.top + (rect.right - rect.left) / 2, // 组件中心点y坐标
                  };
                  sendTouchEvent(touchPoint); // 发送触摸事件
                  touchPoint.type = TouchType.Up;
                  sendTouchEvent(touchPoint); // 发送触摸事件
                }, 2000);
              }))
            .id('longClick')

          Button($r('app.string.component_id_onTouch'))
            .buttonStyle()
            .onClick(() => {
              this.text = getStringData($r('app.string.component_id_onTouch_text'))
              setTimeout(() => {
                let rect = Utils.getComponentRect(getStringData($r('app.string.componentId_onMouse'))); // 获取id为"onMouse"组件的矩形区域坐标
                let mouseEvent: MouseEvent = {
                  button: MouseButton.Left,
                  action: MouseAction.Press,
                  x: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
                  y: rect.top + (rect.bottom - rect.top) / 2, // 组件中心点y坐标
                  screenX: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
                  screenY: rect.top + (rect.bottom - rect.top) / 2, // 组件中心点y坐标
                  timestamp: 1,
                  target: {
                    area: {
                      width: 1,
                      height: 1,
                      position: {
                        x: 1,
                        y: 1
                      },
                      globalPosition: {
                        x: 1,
                        y: 1
                      }
                    }
                  },
                  source: SourceType.Mouse,
                  pressure: 1,
                  tiltX: 1,
                  tiltY: 1,
                  sourceTool: SourceTool.Unknown
                };
                sendMouseEvent(mouseEvent); // 发送鼠标事件
              }, 2000)
            })
            .id('onTouch')

          Button($r('app.string.component_id_onMouse'))
            .buttonStyle()
            .onMouse(() => {
              this.text = getStringData($r('app.string.component_id_onMouse_text'));
              setTimeout(() => {
                let keyEvent: KeyEvent = {
                  type: KeyType.Down,
                  keyCode: 2049,
                  keyText: 'tab',
                  keySource: 4,
                  deviceId: 0,
                  metaKey: 0,
                  timestamp: 0
                };
                sendKeyEvent(keyEvent); // 发送按键事件
              }, 2000)
            })
            .id('onMouse')
        }
      }
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}