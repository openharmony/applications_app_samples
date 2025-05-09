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
export struct SetButtonType {
  pathStack: NavPathStack = new NavPathStack();

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({
          title: $r('app.string.SetButtonType_titleOne'),
          description: $r('app.string.SetButtonType_descriptionOne')
        }) {
          // [Start create_capsule_button]
          Button('Button', { type: ButtonType.Capsule })
            .id('Capsule')
          // [End create_capsule_button]
        }

        ComponentCard({
          title: $r('app.string.SetButtonType_titleTwo'),
          description: $r('app.string.SetButtonType_descriptionTwo')
        }) {
          // [Start create_circle_button]
          Button('Button', { type: ButtonType.Circle })
            .id('Circle')
            .width(80)
          // [End create_circle_button]
        }

        ComponentCard({
          title: $r('app.string.SetButtonType_titleThree'),
          description: $r('app.string.SetButtonType_descriptionThree')
        }) {
          // [Start create_normal_button]
          Button('Button', { type: ButtonType.Normal })
            .id('Normal')
          // [End create_normal_button]
        }

        ComponentCard({
          title: $r('app.string.SetButtonType_titleFour'),
          description: $r('app.string.SetButtonType_descriptionFour')
        }) {
          Button('Button', { type: ButtonType.ROUNDED_RECTANGLE })
            .id('Round')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.SetButtonType_title')))
  }
}