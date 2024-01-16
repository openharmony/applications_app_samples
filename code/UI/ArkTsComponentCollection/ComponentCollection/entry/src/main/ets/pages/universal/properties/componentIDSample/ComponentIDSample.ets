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
import { TitleBar } from '../../../../common/TitleBar';

@Extend(Button)
function commonButtonStyle() {
  .fontSize(16)
  .height(40)
  .width('100%')
  .margin({ left: 24, right: 24, top: 12, bottom: 8 })
}

class RectValue {
  left: number = 0;
  top: number = 0;
  right: number = 0;
  bottom: number = 0;
}

class Utils {
  static rect_left: number;
  static rect_top: number;
  static rect_right: number;
  static rect_bottom: number;
  static rect_value: RectValue;

  //获取组件所占矩形区域坐标
  static getComponentRect(key: string) {
    let strJson = getInspectorByKey(key);
    let obj: Record<string, Object> = JSON.parse(strJson);
    let rectInfo: Array<string> = JSON.parse('[' + obj.$rect + ']');
    Utils.rect_left = JSON.parse('[' + rectInfo[0] + ']')[0];
    Utils.rect_top = JSON.parse('[' + rectInfo[0] + ']')[1];
    Utils.rect_right = JSON.parse('[' + rectInfo[1] + ']')[0];
    Utils.rect_bottom = JSON.parse('[' + rectInfo[1] + ']')[1];
    return Utils.rect_value = {
      left: Utils.rect_left, top: Utils.rect_top, right: Utils.rect_right, bottom: Utils.rect_bottom
    }
  }
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
            .commonButtonStyle()
            .onKeyEvent(() => {
              this.text = getStringData($r('app.string.component_id_onKeyTab'));
            })

          Button($r('app.string.component_id_click'))
            .commonButtonStyle()
            .onClick(() => {
              this.text = getStringData($r('app.string.component_id_click_text'));
              setTimeout(() => {
                // 向id为"longClick"的组件发送长按事件
                sendEventByKey(getStringData($r('app.string.componentId_longClick')), 11, '');
              }, 2000);
            })
            .id('click')

          Button($r('app.string.component_id_longClick'))
            .commonButtonStyle()
            .gesture(
              LongPressGesture().onActionEnd(() => {
                this.text = getStringData($r('app.string.component_id_longClick_text'));
                setTimeout(() => {
                  // 获取id为"onTouch"组件的矩形区域坐标
                  let rect = Utils.getComponentRect(getStringData($r('app.string.componentId_onTouch')));
                  let touchPoint: TouchObject = {
                    id: 1,
                    displayX: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
                    displayY: rect.top + (rect.bottom - rect.top) / 2, // 组件中心点y坐标
                    windowX: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
                    windowY: rect.top + (rect.bottom - rect.top) / 2, // 组件中心点y坐标
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
            .commonButtonStyle()
            .onClick(() => {
              this.text = getStringData($r('app.string.component_id_onTouch_text'))
              setTimeout(() => {
                // 获取id为"onMouse"组件的矩形区域坐标
                let rect = Utils.getComponentRect(getStringData($r('app.string.componentId_onMouse')));
                let mouseEvent: MouseEvent = {
                  button: MouseButton.Left,
                  action: MouseAction.Press,
                  displayX: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
                  displayY: rect.top + (rect.bottom - rect.top) / 2, // 组件中心点y坐标
                  windowY: rect.top + (rect.bottom - rect.top) / 2, // 组件中心点y坐标
                  windowX: rect.left + (rect.right - rect.left) / 2, // 组件中心点x坐标
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
                  sourceTool: SourceTool.Unknown,
                  stopPropagation: () => {
                  }
                };
                sendMouseEvent(mouseEvent); // 发送鼠标事件
              }, 2000)
            })
            .id('onTouch')

          Button($r('app.string.component_id_onMouse'))
            .commonButtonStyle()
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
                  timestamp: 0,
                  intentionCode: 2,
                  stopPropagation: () => {
                  }
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