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
export struct CreateButton {
  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({
          title: $r('app.string.CreateButton_titleOne'),
          description: $r('app.string.CreateButton_descriptionOne')
        }) {
          Button('Button', { type: ButtonType.Capsule, stateEffect: true })
            .id('button')
        }

        ComponentCard({
          title: $r('app.string.CreateButton_titleTwo'),
          description: $r('app.string.CreateButton_descriptionTwo')
        }) {
          Button() {
            Row({ space: 4 }) {
              Image($r('sys.media.ohos_ic_back')).width(20).height(40).fillColor(0xffffff)
              Text('back').fontColor(0xffffff)
            }.alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center).width(90).height(40)
          }.id('button_back')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.CreateButton_title')))
  }
}