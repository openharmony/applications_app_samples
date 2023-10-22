/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import TouchManagerUtil from '../util/InputEventUtil'
import { injectBackEvent } from '../util/InputEventUtil'
/**
 * 输入事件管理
 */
@Preview
@Component
export struct InputEventManager {
  @State mIsShowTouchData: boolean = false // 是否显示触屏事件详情
  @State mTouchData: string = '' // 触屏数据
  @State mBtnBg: Resource = $r('app.color.btn_normal_bg')

  aboutToDisappear() {
    TouchManagerUtil.unregisterTouch()
  }

  touchCallback(touchData: string) {
    if (this.mIsShowTouchData) {
      this.mTouchData = touchData
    }
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        Column() {
          Row() {
            Text($r('app.string.input_touch_event_listener'))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
            Blank()
            Toggle({
              type: ToggleType.Switch,
              isOn: false
            })
              .width(42)
              .onChange((isOn) => {
                this.mIsShowTouchData = isOn
                if (isOn) {
                  TouchManagerUtil.registerTouch((touchData: string): void => this.touchCallback(touchData));
                } else {
                  this.mTouchData = ''
                  TouchManagerUtil.unregisterTouch()
                }
              })
          }
          .width('100%')

          Text($r('app.string.input_touch_event_hint'))
            .fontColor($r('app.color.battery_info_value_text'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .width('100%')
        }
        .padding(px2vp(24))
        .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
        .border({
          radius: $r('sys.float.ohos_id_corner_radius_default_l')
        })
        .id('columnInputListener')

        if (this.mIsShowTouchData) {
          Text($r('app.string.input_touch_event_data_title'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight(FontWeight.Regular)
            .fontFamily('HarmonyHeiTi')
          Column() {
            Text(this.mTouchData)
              .fontColor($r('app.color.input_consumer_hint'))
              .fontSize(14)
              .fontWeight(FontWeight.Regular)
              .width('100%')
          }
          .padding(px2vp(24))
          .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
          .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l')
          })
        }

        Column() {
          Text($r('app.string.input_inject_back_event'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .margin({
              bottom: px2vp(10)
            })

          Text($r('app.string.input_inject_back_event_hint'))
            .fontColor($r('app.color.battery_info_value_text'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .width('100%')

          Column() {
            Text($r('app.string.input_inject_back_text'))
              .fontColor(Color.White)
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
          }
          .width('60%')
          .height(35)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(this.mBtnBg)
          .margin({
            top: px2vp(24)
          })
          .onTouch((event) => {
            if (event !== undefined && event !== null) {
              console.log(`TouchManagerUtil onTouch event ${JSON.stringify(event)}`);
              if (event.type === TouchType.Down) {
                this.mBtnBg = $r('app.color.btn_press_bg');
              }
              if (event.type === TouchType.Up) {
                this.mBtnBg = $r('app.color.btn_normal_bg');
              }
            }
          })
          .onClick(() => {
            injectBackEvent()
          })
          .border({
            radius: $r('sys.float.ohos_id_corner_radius_default_l')
          })
          .id('columnBackBtn')
        }
        .padding(px2vp(24))
        .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
        .border({
          radius: $r('sys.float.ohos_id_corner_radius_default_l')
        })
        .id('columnBackEvent')

      }.justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .margin(px2vp(24))
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .id('scrollInputEvent')
  }
}