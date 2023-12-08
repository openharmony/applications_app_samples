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

import { MainView, SquareView, MineView } from '@ohos/authorizedcontrol';

AppStorage.setOrCreate('location', '北京市')
const TAB_INDEX_0: number = 0;
const TAB_INDEX_1: number = 1;
const TAB_INDEX_2: number = 2;
// divider组件的strokWidth为1
const DIVIDER_LINE_STROKWIDTH: number = 1;
const TABBAR_SEPARATE_LINE = 0.05;

@Entry
@Component
struct HomePage {
  // 默认显示第一个tab
  @State currentTabIndex: number = 0;
  @State message: Resource = $r('app.string.home');
  private controller: TabsController = new TabsController();

  // 设置tabBar样式的位置、未选中图片、选中图片及文字显示的参数
  @Builder
  TabBuilder(index: number, imageNormal: Resource, imageSelected: Resource, text: Resource) {
    Column() {
      Divider()
        .vertical(false)
        .strokeWidth(DIVIDER_LINE_STROKWIDTH)
        .color($r('app.color.tab_bar_separator_line_color'))
        .opacity(TABBAR_SEPARATE_LINE)
      Image(this.currentTabIndex === index ? imageSelected : imageNormal)
        .syncLoad(true)
        .width($r('app.integer.tabbar_image_width'))
        .height($r('app.integer.tabbar_image_height'))
        .margin($r('app.integer.tabbar_image_margin'))
        .objectFit(ImageFit.Contain)
      Text(text)
        .fontSize($r('app.integer.tabbar_item_font_size'))
    }
    .backgroundColor($r('app.color.tabbar_background'))
    .height($r('app.string.layout_100'))
    .width($r('app.string.layout_100'))
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.controller, index: this.currentTabIndex }) {
      TabContent() {
        // 首页
        MainView()
      }
      .tabBar(this.TabBuilder(TAB_INDEX_0,
        $r('app.media.ic_public_home'),
        $r('app.media.ic_public_home_filled'),
        $r('app.string.home')));

      TabContent() {
        // 广场页
        SquareView()
      }
      .tabBar(this.TabBuilder(TAB_INDEX_1,
        $r('app.media.ic_gallery_discover'),
        $r('app.media.ic_gallery_discover_filled'),
        $r('app.string.square')));

      TabContent() {
        // 我的
        MineView()
      }
      .tabBar(this.TabBuilder(TAB_INDEX_2,
        $r('app.media.ic_public_contacts'),
        $r('app.media.ic_public_contacts_filled'),
        $r('app.string.mine')));
    }
    .onChange((index: number) => {
      this.currentTabIndex = index;
      if (this.currentTabIndex === TAB_INDEX_0) {
        this.message = $r('app.string.home');
      } else if (this.currentTabIndex === TAB_INDEX_1) {
        this.message = $r('app.string.square');
      } else if (this.currentTabIndex === TAB_INDEX_2) {
        this.message = $r('app.string.mine');
      }
    })

    .barWidth($r('app.string.layout_100'))
    .barHeight($r('app.integer.tabbar_height'))
    .backgroundColor(Color.White)
  }
}