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

import { TabBarData, TabBarType, tabsInfo } from '../model/TabBarModel';
import { promptAction } from '@kit.ArkUI';

const FONT_WEIGHT: number = 600; // 设置文本的字体粗细
const INITIAL_MARGIN: number = 0; //非选中状态的外边距初始值

@Component
export struct CustomTabBar {
  @Link currentIndex: TabBarType;

  build() {
    Row() {
      ForEach(tabsInfo, (item: TabBarData) => {
        this.tabItem(item.id);
      }, (item: TabBarData) => item.id.toString())
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .clip(false)
    .height($r('app.integer.video_list_autoplay_custom_tab_bar_height'))
    .width($r('app.string.video_list_autoplay_custom_tab_bar_width'))
  }

  @Builder
  tabItem(index: number) {
    Column() {
      Image(this.currentIndex === index ? tabsInfo[index].activeIcon : tabsInfo[index].defaultIcon)
        .size(index === TabBarType.CHALLENGE ?
          {
            width: $r('app.float.video_list_autoplay_tab_big_img_width'),
            height: $r('app.float.video_list_autoplay_tab_big_img_height')
          } :
          {
            width: $r('app.float.video_list_autoplay_tab_img_size'),
            height: $r('app.float.video_list_autoplay_tab_img_size')
          })
        .margin({
          top: index === TabBarType.CHALLENGE ? $r('app.float.video_list_autoplay_tab_margin') : INITIAL_MARGIN
        })
      Text(tabsInfo[index].title)
        .fontSize($r('app.float.video_list_autoplay_tab_font_size'))
        .margin({ top: $r('app.float.video_list_autoplay_tab_title_margin') })
        .fontWeight(FONT_WEIGHT)
        .fontColor(this.currentIndex === index ? $r('app.color.video_list_autoplay_tab_title_font_color') :
        $r('app.color.video_list_autoplay_tab_title_font_color_change'))
    }
    .clip(false)
    .padding({
      top: $r('app.integer.video_list_autoplay_tab_item_padding'),
      bottom: $r('app.integer.video_list_autoplay_tab_item_padding')
    })
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 调用Toast显示提示:此样式仅为案例展示
      promptAction.showToast({ message: $r('app.string.video_list_autoplay_toast_tips') });
    })
  }
}