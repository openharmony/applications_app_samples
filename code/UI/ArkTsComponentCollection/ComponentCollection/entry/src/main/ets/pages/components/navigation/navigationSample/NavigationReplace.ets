/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { TitleBar } from '../../../../common/TitleBar';

@Entry
@Component
struct NavigationHideBar {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  @Builder
  Pages(name: string) {
    NavDestination() {
      Column() {
        Button() {
          Text($r('app.string.navigation_replace_page'))
            .fontSize(16)
            .fontColor(Color.White)
        }.onClick(() => {
          console.info("repalce pages");
          this.pageInfos.replacePath({ name: `after_replace` }, true);
        })
        .backgroundColor('#007DFF')
        .height(40)
        .width('80%')
        .id('replace')
      }
      .justifyContent(FlexAlign.Center)
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  aboutToAppear() {
    this.pageInfos.pushPath({ name: `after_replace` });
    this.pageInfos.pushPath({ name: `before_replace` });
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.navigation_replace_title') })
      Navigation(this.pageInfos) {

      }
      .hideTitleBar(true)
      .navDestination(this.Pages)
      .mode(NavigationMode.Stack)
      .width('100%')
      .height('90%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}