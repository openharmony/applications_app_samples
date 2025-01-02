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
export struct ButtonCustomStyle {
  pathStack: NavPathStack = new NavPathStack();

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({
          title: $r('app.string.ButtonCustomStyle_titleOne'),
          description: $r('app.string.ButtonCustomStyle_descriptionOne')
        }) {
          Button('Button', { type: ButtonType.Normal })
            .id('circle_border')
            .borderRadius(10)
        }

        ComponentCard({
          title: $r('app.string.ButtonCustomStyle_titleTwo'),
          description: $r('app.string.ButtonCustomStyle_descriptionTwo')
        }) {
          Button('Button').id('font_style')
            .fontSize(20)
            .fontColor(Color.Pink)
            .fontWeight(800)
        }

        ComponentCard({
          title: $r('app.string.ButtonCustomStyle_titleThree'),
          description: $r('app.string.ButtonCustomStyle_descriptionThree')
        }) {
          Button('Button').id('background_color')
            .backgroundColor(Color.Red)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.ButtonCustomStyle_title')))
  }
}

