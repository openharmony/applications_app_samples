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

// [Start x_component_implement_index_page]
// XComponentImplementPage.ets
// 该页面用于展示Navigation在画中画场景的使用。如果UIAbility是单页面，则无需使用Navigation
import { Page1 } from '../xcomponent/Page1'

@Entry
@Component
struct XComponentImplementPage {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  private navId: string = 'navId';

  @Builder
  PageMap(name: string) {
    if (name === 'pageOne') {
      Page1({ navId: this.navId });
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Button('pushPath', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'pageOne' }) // 将name指定的NavDestination页面信息入栈
          })
          .stateStyles({
            pressed: {
              .backgroundColor(Color.Red);
            },
            normal: {
              .backgroundColor(Color.Blue);
            }
          })
      }
    }
    .title('NavIndex')
    .navDestination(this.PageMap)
    .id(this.navId) // 设置Navigation组件的id属性
  }
}
// [End x_component_implement_index_page]