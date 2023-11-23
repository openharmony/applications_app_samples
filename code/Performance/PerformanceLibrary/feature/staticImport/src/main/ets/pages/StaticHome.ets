/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { StaticContentPageOne, StaticContentPageDataOne } from './StaticContentPageOne'
import { StaticContentPageTwo, StaticContentPageDataTwo } from './StaticContentPageTwo'
import router from '@ohos.router'


@Component
export struct StaticHome {
  @Provide('pathInfos') pageInfos: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string) {
    if (name === 'pageOne') {
      StaticContentPageOne(new StaticContentPageDataOne(name, this.pageInfos));
    } else if (name === 'pageTwo') {
      StaticContentPageTwo(new StaticContentPageDataTwo(name, this.pageInfos));
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Button($r('app.string.home_button_back'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            router.back();
          })
        Button($r('app.string.home_button_page_one'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'pageOne' }); //将name指定的NavDestination页面信息入栈
          })
        Button($r('app.string.home_button_page_two'), { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'pageTwo' }); //将name指定的NavDestination页面信息入栈
          })
      }
    }.title($r('app.string.home_title')).navDestination(this.PageMap)
  }
}