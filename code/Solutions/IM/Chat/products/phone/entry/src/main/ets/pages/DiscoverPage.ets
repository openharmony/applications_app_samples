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

  constructor(image: string | Resource, text: string | Resource) {
    this.image = image;
    this.text = text;
  }
}

const CHAT_COMMUNITY = 'chatCommunity';
const LIST_SPACE: number = 16; // 列表默认间隔
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间

@Component
export struct DiscoverPage {
  private settingViewData: Array< Array<SettingViewData>> = [
    [new SettingViewData($r('app.media.icon_de_scan'), $r('app.string.scan')),
        new SettingViewData($r('app.media.icon_de_shake'), $r('app.string.shake'))],
    [new SettingViewData($r('app.media.searchOne'), $r('app.string.search_one'))],
    [new SettingViewData($r('app.media.applet'), $r('app.string.applet'))],
    [new SettingViewData($r('app.media.icon_de_nearby'), $r('app.string.around'))],
    [new SettingViewData($r('app.media.icon_de_shop'), $r('app.string.shopping')),
      new SettingViewData($r('app.media.icon_de_game'), $r('app.string.game'))]
  ];

  build() {
    Column() {
      Row() {
        Text($r('app.string.discovery'))
          .fontSize($r('app.integer.discovery_bar_font_size'))
          .fontColor($r('app.color.discovery_bar_title_color'))
          .fontWeight(FontWeight.Bold)
          .backgroundColor($r('app.color.discovery_bar_background_color'))
          .width($r('app.integer.discovery_bar_title_width'))
          .height($r('app.integer.discovery_bar_text_height'))
          .lineHeight($r('app.integer.setting_title_height'))
          .margin({
            left: $r('app.integer.discovery_text_margin_left')
          })
      }
      .backgroundColor($r('app.color.discovery_bar_background_color'))
      .height($r('app.integer.discovery_bar_height'))
      .width($r('app.string.layout_100'))
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      List({ space: LIST_SPACE }) {
        ListItem() {
          // 设置项组件
          SettingItemView(new SettingViewData($r('app.media.circle'), $r('app.string.circle')))
            .id(CHAT_COMMUNITY)
            .onClick(() => {
              router.pushUrl({ url: 'pages/FriendsMomentsPage' })
            })
        }
        .backgroundColor($r('app.color.setting_text_background'))
        .borderRadius($r('app.integer.setting_menu_border_radius'))
        .height($r('app.integer.setting_other_menu_list_height'))

        ForEach(this.settingViewData, (itemList: Array<SettingViewData>) => {
          ListItem() {
            List() {
              ForEach(itemList,
                (item: SettingViewData) => {
                  ListItem() {
                    SettingItemView({ image: item.image, text: item.text })
                  }
                })
            }
            .divider({
              strokeWidth: $r('app.integer.setting_list_divider_width'),
              color: $r('app.color.setting_divider_color'),
              startMargin: $r('app.integer.setting_search_divider_start_margin'),
              endMargin: $r('app.integer.setting_search_divider_end_margin')
            })
          }
          .backgroundColor($r('app.color.setting_text_background'))
          .borderRadius($r('app.integer.setting_menu_border_radius'))
          .padding({ top: $r('app.integer.layout_5'), bottom: $r('app.integer.layout_5') })
          .alignSelf(ItemAlign.Center)
        })
      }
      .padding({ left: $r('app.integer.setting_padding_left'), right: $r('app.integer.setting_padding_left') })
      .layoutWeight(LAYOUT_WEIGHT)
      .margin({ top: $r('app.integer.discovery_list_margin_top') })
      .width($r('app.string.layout_100'))
      .height($r('app.string.layout_100'))
    }
    .backgroundColor($r('app.color.discover_page_background'))
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
  }
}