/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { ChatListDisplayView } from "@ohos/chatList"
import { FriendsPage } from './FriendsPage'
import { DiscoverPage } from './DiscoverPage'
import { SettingPage } from './SettingPage'
import { TopBar } from '../view/TopBar'

PersistentStorage.persistProp('lazy_for_each', true);
PersistentStorage.persistProp('reusable', true);
PersistentStorage.persistProp('image_sync_load', true);
PersistentStorage.persistProp('page_layout', true);
PersistentStorage.persistProp('list_cached_count', true);

@Entry
@Component
struct Index {
  @StorageLink('page_layout') page_layout: boolean | undefined = AppStorage.get('page_layout')
  @State currentIndex: number = 0
  @State message: Resource = $r('app.string.chat')
  private controller: TabsController = new TabsController()

  aboutToAppear(): void {
  }

  onPageShow() {
  }

  @Builder
  TabBuilder(index: number, img: string, text: Resource) {
    Column() {
      Image(this.currentIndex === index ? `${img}_pressed.png` : `${img}.png`)
        .syncLoad(true)
        .width(24)
        .height(24)
        .margin(6)
        .objectFit(ImageFit.Contain)
      Text(text)
        .fontSize(10)
    }
    .height('100%')
    .width('100%')
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.controller, index: this.currentIndex }) {
      TabContent() {
        Column() {
          TopBar()
          ChatListDisplayView()
        }
      }
      .tabBar(this.TabBuilder(0, '/resources/images/chatIcon', $r('app.string.chat')))

      TabContent() {
        FriendsPage()
      }
      .tabBar(this.TabBuilder(1, '/resources/images/contact', $r('app.string.contacts')))

      TabContent() {
        DiscoverPage()
      }
      .tabBar(this.TabBuilder(2, '/resources/images/find', $r('app.string.discovery')))

      TabContent() {
        SettingPage()
      }
      .tabBar(this.TabBuilder(3, '/resources/images/profile', $r('app.string.my')))
    }
    .onChange((index: number) => {
      this.currentIndex = index
      if (this.currentIndex == 0) {
        this.message = $r('app.string.chat')
      } else if (this.currentIndex == 1) {
        this.message = $r('app.string.contacts')
      } else if (this.currentIndex == 2) {
        this.message = $r('app.string.discovery')
      } else if (this.currentIndex == 3) {
        this.message = $r('app.string.my')
      }
    })
    .barWidth(400)
    .barHeight(50)
    .animationDuration(0)
    .backgroundColor('#EEEEEE')
  }
}
