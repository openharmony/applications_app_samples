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

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({
          title: $r('app.string.ToggleCustomStyle_titleOne'),
          description: $r('app.string.ToggleCustomStyle_descriptionOne')
        }) {
          Toggle({ type: ToggleType.Button, isOn: true }) {
            Text('status button')
              .fontColor(Color.White)
              .fontSize(12)
          }.width(100)
          .selectedColor(Color.Pink)
          .id('toggle1')

          Toggle({ type: ToggleType.Checkbox, isOn: true })
            .selectedColor(Color.Pink)
            .id('toggle2')
          Toggle({ type: ToggleType.Switch, isOn: true })
            .selectedColor(Color.Pink)
            .id('toggle3')
        }

        ComponentCard({
          title: $r('app.string.ToggleCustomStyle_titleTwo'),
          description: $r('app.string.ToggleCustomStyle_descriptionTwo')
        }) {
          Toggle({ type: ToggleType.Switch, isOn: false })
            .switchPointColor(Color.Pink)
            .id('toggle4')
          Toggle({ type: ToggleType.Switch, isOn: true })
            .switchPointColor(Color.Pink)
            .id('toggle5')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.ToggleCustomStyle_title')))
  }
}
