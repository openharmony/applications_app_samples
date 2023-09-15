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

import router from '@ohos.router';
// 引入设置项组件
import { SettingItemView } from './SettingPage';

// 设置项的数据类
class SettingViewData {
  image: string | Resource = '';
  text: string | Resource = '';
  topLeftBorderRadius: number | Resource = $r('app.integer.setting_menu_zero_borderRadius');
  topRightBorderRadius: number | Resource = $r('app.integer.setting_menu_zero_borderRadius');
  bottomLeftBorderRadius: number | Resource = $r('app.integer.setting_menu_zero_borderRadius');
  bottomRightBorderRadius: number | Resource = $r('app.integer.setting_menu_zero_borderRadius');

  constructor(image: string | Resource, text: string | Resource, topLeftBorderRadius: number | Resource, topRightBorderRadius: number | Resource, bottomLeftBorderRadius: number | Resource, bottomRightBorderRadius: number | Resource) {
    this.image = image;
    this.text = text;
    this.topLeftBorderRadius = topLeftBorderRadius;
    this.topRightBorderRadius = topRightBorderRadius;
    this.bottomLeftBorderRadius = bottomLeftBorderRadius;
    this.bottomRightBorderRadius = bottomRightBorderRadius;
  }
}
;

const CHAT_COMMUNITY = 'chatCommunity';
// divider组件的strokWidth为16
const DIVIDER_STROKWIDTH: number = 16;
// divider组件的strokWidth为1
const DIVIDER_LINE_STROKWIDTH: number = 1;

@Component
export struct DiscoverPage {
  private scroller: Scroller = new Scroller();
  private settingViewData: Array<SettingViewData> = [
    new SettingViewData($r('app.media.icon_de_scan'), $r('app.string.scan'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_zero_borderRadius'), $r('app.integer.setting_menu_zero_borderRadius')),
    new SettingViewData($r('app.media.icon_de_shake'), $r('app.string.shake'), $r('app.integer.setting_menu_zero_borderRadius'), $r('app.integer.setting_menu_zero_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius')),
    new SettingViewData($r('app.media.searchOne'), $r('app.string.search_one'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius')),
    new SettingViewData($r('app.media.applet'), $r('app.string.applet'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius')),
    new SettingViewData($r('app.media.icon_de_nearby'), $r('app.string.around'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius')),
    new SettingViewData($r('app.media.icon_de_shop'), $r('app.string.shopping'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_zero_borderRadius'), $r('app.integer.setting_menu_zero_borderRadius')),
    new SettingViewData($r('app.media.icon_de_game'), $r('app.string.game'), $r('app.integer.setting_menu_zero_borderRadius'), $r('app.integer.setting_menu_zero_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'))];

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text($r('app.string.discovery'))
          .fontSize($r('app.integer.discovery_bar_font_size'))
          .fontColor($r('app.color.discovery_bar_title_color'))
          .fontWeight(FontWeight.Bold)
          .backgroundColor($r('app.color.discovery_bar_background_color'))
          .width($r('app.integer.discovery_bar_title_width'))
          .height($r('app.integer.discovery_bar_text_height'))
          .margin({ top: 16, left: 32 })
      }
      .backgroundColor($r('app.color.discovery_bar_background_color'))
      .height($r('app.integer.discovery_bar_height'))
      .width($r('app.string.layout_100'))

      Scroll(this.scroller) {
        Column() {
          // Divider()
          //   .vertical(false)
          //   .strokeWidth(DIVIDER_STROKWIDTH)
          //   .color($r('app.color.divider_color'))
          // 设置项组件
          SettingItemView(new SettingViewData($r('app.media.find_friends'), $r('app.string.circle'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius'), $r('app.integer.setting_menu_borderRadius')))
            .id(CHAT_COMMUNITY)
            .onClick(() => {
              router.pushUrl({ url: 'pages/FriendsMomentsPage' })
            })
          ForEach(this.settingViewData, (item: SettingViewData, index: number) => {
            // 当index为1或者为6的时候不需要设置Divider
            if (index === 1 || index === 6) {
              Divider()
                .vertical(false)
                .strokeWidth(DIVIDER_LINE_STROKWIDTH)
                .color($r('app.color.divider_color'))
                // .padding({
                //   left: $r('app.integer.discovery_line_start_margin'),
                //   right: $r('app.integer.discovery_line_end_margin')
                // })

              SettingItemView({
                image: item.image,
                text: item.text,
                topLeftBorderRadius: item.topLeftBorderRadius,
                topRightBorderRadius: item.topRightBorderRadius,
                bottomLeftBorderRadius: item.bottomLeftBorderRadius,
                bottomRightBorderRadius: item.bottomRightBorderRadius
              })
            } else {
              Divider()
                .vertical(false)
                .strokeWidth(DIVIDER_STROKWIDTH)
                .color($r('app.color.divider_color'))
              SettingItemView({
                image: item.image,
                text: item.text,
                topLeftBorderRadius: item.topLeftBorderRadius,
                topRightBorderRadius: item.topRightBorderRadius,
                bottomLeftBorderRadius: item.bottomLeftBorderRadius,
                bottomRightBorderRadius: item.bottomRightBorderRadius
              })
            }
          })
          Divider()
            .vertical(false)
            .strokeWidth(DIVIDER_STROKWIDTH)
            .color($r('app.color.divider_color'))
        }
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .margin({ bottom: $r('app.integer.discovery_margin_bottom_size') })
    }
    .backgroundColor($r('app.color.discover_page_background'))
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
  }
}