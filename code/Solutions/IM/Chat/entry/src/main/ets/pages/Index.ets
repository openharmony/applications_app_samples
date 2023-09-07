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

import { ChatListDisplayView } from "@ohos/chatList";
import { FriendsPage } from './FriendsPage';
import { DiscoverPage } from './DiscoverPage';
import { SettingPage } from './SettingPage';
import { TopBar } from '../view/TopBar';

const TAB_INDEX_0: number = 0;
const TAB_INDEX_1: number = 1;
const TAB_INDEX_2: number = 2;
const TAB_INDEX_3: number = 3;
const chatIconNormal : string = './resources/images/chatIconNormal.png'; // 聊天未选中图片路径
const chatIconSelected : string = './resources/images/chatIconSelected.png'; // 聊天选中图片路径
const contactIconNormal : string = './resources/images/contactIconNormal.png'; // 通讯录未选中图片路径
const contactIconSelected : string = './resources/images/contactIconSelected.png'; // 通讯录选中图片路径
const findIconNormal : string = './resources/images/findIconNormal.png'; // 发现未选中图片路径
const findIconSelected : string = './resources/images/findIconSelected.png'; // 发现选中图片路径
const profileIconNormal : string = './resources/images/profileIconNormal.png'; // 我未选中图片路径
const profileIconSelected : string = './resources/images/profileIconSelected.png'; // 我选中图片路径

@Entry
@Component
struct Index {
  @StorageLink('page_layout') page_layout: boolean | undefined = AppStorage.get('page_layout'); // AppStorage中key对应的属性建立双向数据同步
  @State currentIndex: number = TAB_INDEX_0; // tabBar初始选中的位置
  @State message: Resource = $r('app.string.chat');
  private controller: TabsController = new TabsController();

  // 设置tabBar样式的位置、未选中图片、选中图片及文字显示的参数
  @Builder
  TabBuilder(index: number, imageNormal: string, imageSelected: string, text: Resource) {
    Column() {
      Image(this.currentIndex === index ? imageSelected : imageNormal)
        .syncLoad(true)
        .width($r('app.integer.tabbar_image_width'))
        .height($r('app.integer.tabbar_image_height'))
        .margin($r('app.integer.tabbar_image_margin'))
        .objectFit(ImageFit.Contain)
      Text(text)
        .fontSize($r('app.integer.tabbar_item_font_size'))
    }
    .height($r('app.string.layout_100'))
    .width($r('app.string.layout_100'))
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.controller, index: this.currentIndex }) {
      TabContent() {
        Column() {
          TopBar()
          ChatListDisplayView()
        }
      }
      .tabBar(this.TabBuilder(TAB_INDEX_0, chatIconNormal, chatIconSelected, $r('app.string.chat')))

      TabContent() {
        FriendsPage()
      }
      .tabBar(this.TabBuilder(TAB_INDEX_1, contactIconNormal, contactIconSelected, $r('app.string.contacts')))

      TabContent() {
        DiscoverPage()
      }
      .tabBar(this.TabBuilder(TAB_INDEX_2, findIconNormal, findIconSelected, $r('app.string.discovery')))

      TabContent() {
        SettingPage()
      }
      .tabBar(this.TabBuilder(TAB_INDEX_3, profileIconNormal, profileIconSelected, $r('app.string.my')))
    }
    .onChange((index: number) => {
      this.currentIndex = index;
      if (this.currentIndex === TAB_INDEX_0) {
        this.message = $r('app.string.chat');
      } else if (this.currentIndex === TAB_INDEX_1) {
        this.message = $r('app.string.contacts');
      } else if (this.currentIndex === TAB_INDEX_2) {
        this.message = $r('app.string.discovery');
      } else if (this.currentIndex === TAB_INDEX_3) {
        this.message = $r('app.string.my');
      }
    })
    .barWidth($r('app.integer.tabbar_width'))
    .barHeight($r('app.integer.tabbar_height'))
    .backgroundColor($r('app.color.tabbar_background'))
  }
}
