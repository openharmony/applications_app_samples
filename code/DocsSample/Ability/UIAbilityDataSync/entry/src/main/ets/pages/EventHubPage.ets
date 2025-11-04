/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start EventHubPage]
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct EventHubPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  eventHubFunc(): void {
    // 不带参数触发自定义“event1”事件
    this.context.eventHub.emit('event1');
    // 带1个参数触发自定义“event1”事件
    this.context.eventHub.emit('event1', 1);
    // 带2个参数触发自定义“event1”事件
    this.context.eventHub.emit('event1', 2, 'test');
    // 开发者可以根据实际的业务场景设计事件传递的参数
  }

  build() {
    Column() {
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude EventHubPage]
            Text('EventHubFuncA')
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
            // [EndExclude EventHubPage]
          }
          .onClick(() => {
            this.eventHubFunc();
            this.getUIContext().getPromptAction().showToast({
              message: 'EventHubFuncA'
            });
          })
          // [StartExclude EventHubPage]
          .id('EventHubFuncA')
          .width('60%').height(50)
          .backgroundColor(Color.Blue)
          .borderRadius(25)
          .justifyContent(FlexAlign.Center)
          // [EndExclude EventHubPage]
        }

        ListItem() {
          Row() {
            // [StartExclude EventHubPage]
            Text('EventHubFuncB')
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
            // [EndExclude EventHubPage]
          }
          .onClick(() => {
            this.context.eventHub.off('event1');
            this.getUIContext().getPromptAction().showToast({
              message: 'EventHubFuncB'
            });
          })
          // [StartExclude EventHubPage]
          .id('EventHubFuncB')
          .width('60%').height(50)
          .backgroundColor(Color.Blue)
          .borderRadius(25)
          .margin({top: 8})
          .justifyContent(FlexAlign.Center)
          // [EndExclude EventHubPage]
        }
      }
      // [StartExclude EventHubPage]
      .alignListItem(ListItemAlign.Center)
      // [EndExclude EventHubPage]
    }
    // [StartExclude EventHubPage]
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    // [EndExclude EventHubPage]
  }
}
// [End EventHubPage]