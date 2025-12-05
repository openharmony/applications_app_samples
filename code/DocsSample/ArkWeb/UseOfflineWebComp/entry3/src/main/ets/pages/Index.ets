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

// [Start use_offline_web_component_index_page]

// Index.ets
import { Home } from './Home'
import { Page1 } from './Page1'
import { Page2 } from './Page2'
import { recycleNWebs, restoreNWebs, gerOfflineNWebsInfo } from './Common'

@Entry
@Component
struct Index {
  private navPath: NavPathStack = new NavPathStack();
  @State private offlineNWebsInfo: string = '[offlineNWebsInfo]';

  @Builder
  RouterMap(name: string, params: Record<string, ResourceStr>) {
    if (name === 'Home') {
      Home()
    } else if (name === 'Page1') {
      Page1()
    } else if (name === 'Page2') {
      Page2(params)
    }
  }

  aboutToAppear(): void {
    setInterval(() => {
      this.offlineNWebsInfo = gerOfflineNWebsInfo();
    }, 500)
  }

  build() {
    Navigation(this.navPath) {
      Column() {
        Button($r("app.string.Jump_to_Home_page"))
          .onClick(() => {
            this.navPath.clear();
            this.navPath.pushPathByName('Home', null);
          })
          .width('80%')
          .margin('5')
          .id('go_home')
        Button($r('app.string.recycle_offline_webs'))
          .onClick(() => {
            recycleNWebs()
          })
          .width('80%')
          .margin('5')
          .id("recycleNWebs")
        Button($r('app.string.recycle_offline_webs_force'))
          .onClick(() => {
            recycleNWebs(true);
          })
          .width('80%')
          .margin('5')
        Button($r('app.string.restore_offline_webs'))
          .onClick(() => {
            restoreNWebs();
          })
          .width('80%')
          .margin('5')
          .id('restoreNWebs')
        Text(this.offlineNWebsInfo)
          .width('80%')
      }
    }
    .navDestination(this.RouterMap)
    .hideToolBar(true)
    .height('100%')
    .width('100%')
  }
}

// [End use_offline_web_component_index_page]
