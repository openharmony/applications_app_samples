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
export struct CreateToggle {
  pathStack: NavPathStack = new NavPathStack();

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({
          title: 'ToggleType is Checkbox',
        }) {
          Toggle({ type: ToggleType.Checkbox, isOn: false }).id('toggle1')
          Toggle({ type: ToggleType.Checkbox, isOn: true }).id('toggle2')
        }

        ComponentCard({
          title: 'ToggleType is Switch',
        }) {
          Toggle({ type: ToggleType.Switch, isOn: false }).id('toggle3')
          Toggle({ type: ToggleType.Switch, isOn: true }).id('toggle4')
        }

        ComponentCard({
          title: 'ToggleType is Button',
        }) {
          Toggle({ type: ToggleType.Button, isOn: false }) {
            Text('status button')
              .fontColor('#182431')
              .fontSize(12)
          }.width(100).id('toggle5')

          Toggle({ type: ToggleType.Button, isOn: true }) {
            Text('status button')
              .fontColor('#182431')
              .fontSize(12)
          }.width(100).id('toggle6')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.CreateToggle_title')))
  }
}