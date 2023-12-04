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
import { formatJson } from '@ohos/common/src/main/ets/util/JSONUtils';
/**
 * 输入按键事件管理
 */
@Preview
@Component
export struct InputKeyEventManager {
  @State mKeyEventData: string = '' // 按键数据

  build() {
    Scroll() {
      Column({ space: 12 }) {
        Column({ space: 8 }) {
          Text($r('app.string.input_key_event_listener'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .focusable(true)

          Text($r('app.string.input_key_event_hint'))
            .fontColor($r('app.color.battery_info_value_text'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .width('100%')
        }
        .padding(px2vp(24))
        .backgroundColor($r('sys.color.ohos_id_color_list_card_bg'))
        .border({
          radius: $r('sys.float.ohos_id_corner_radius_default_l')
        })
        .id('columnKeyListener')

        Text($r('app.string.input_key_event_data'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyHeiTi')
        Column() {
          Text(this.mKeyEventData)
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
        .id('columnKeyEventData')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
      .margin(px2vp(24))
      .focusable(true)
      .onKeyEvent((event) => {
        console.log('InputKeyEventManager Column ' + JSON.stringify(event))
        this.mKeyEventData = formatJson(JSON.stringify(event))
      })
    }
    .width('100%')
    .scrollBar(BarState.Off)
    .id('scrollKeyEvent')
  }
}