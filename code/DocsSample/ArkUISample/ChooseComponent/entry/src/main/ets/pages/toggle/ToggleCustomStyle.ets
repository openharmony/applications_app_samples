/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct CustomStyle {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({
          // 请将$r('app.string.ToggleCustomStyle_titleOne')替换为实际资源文件，在本示例中该资源文件的value值为"selectedColor设置选中后的背景颜色"
          title: $r('app.string.ToggleCustomStyle_titleOne'),
          description: $r('app.string.ToggleCustomStyle_descriptionOne')
        }) {
          // [Start custom_toggle]
          Toggle({ type: ToggleType.Button, isOn: true }) {
            Text('status button')
              .fontColor('#182431')
              .fontSize(12)
          }.width(100)
          .selectedColor(Color.Pink)
          // [StartExclude custom_toggle]
          .id('toggle1')
          // [EndExclude custom_toggle]

          Toggle({ type: ToggleType.Checkbox, isOn: true })
            .selectedColor(Color.Pink)
            // [StartExclude custom_toggle]
            .id('toggle2')
          // [EndExclude custom_toggle]
          Toggle({ type: ToggleType.Switch, isOn: true })
            .selectedColor(Color.Pink)
            // [StartExclude custom_toggle]
            .id('toggle3')
          // [EndExclude custom_toggle]
          // [End custom_toggle]
        }

        ComponentCard({
          // 请将$r('app.string.ToggleCustomStyle_titleTwo')替换为实际资源文件，在本示例中该资源文件的value值为"设置Switch类型的圆形滑块颜色"
          title: $r('app.string.ToggleCustomStyle_titleTwo'),
          description: $r('app.string.ToggleCustomStyle_descriptionTwo')
        }) {
          // [Start custom_switch_point_color]
          Toggle({ type: ToggleType.Switch, isOn: false })
            .switchPointColor(Color.Pink)
            // [StartExclude custom_switch_point_color]
            .id('toggle4')
            // [EndExclude custom_switch_point_color]
          Toggle({ type: ToggleType.Switch, isOn: true })
            .switchPointColor(Color.Pink)
            // [StartExclude custom_switch_point_color]
            .id('toggle5')
            // [EndExclude custom_switch_point_color]
          // [End custom_switch_point_color]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.ToggleCustomStyle_title')替换为实际资源文件，在本示例中该资源文件的value值为"自定义切换按钮"
    .title($r('app.string.ToggleCustomStyle_title'))
  }
}
