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
};

const CHAT_COMMUNITY = 'chatCommunity';
// divider组件的strokWidth为20
const DIVIDER_STROKWIDTH: number = 20;

@Component
export struct DiscoverPage {
  private scroller: Scroller = new Scroller();
  private settingViewData: Array<SettingViewData> = [
    new SettingViewData($r('app.media.icon_de_scan'), $r('app.string.scan')),
    new SettingViewData($r('app.media.icon_de_shake'), $r('app.string.shake')),
    new SettingViewData($r('app.media.searchOne'), $r('app.string.search_one')),
    new SettingViewData($r('app.media.applet'), $r('app.string.applet')),
    new SettingViewData($r('app.media.icon_de_nearby'), $r('app.string.around')),
    new SettingViewData($r('app.media.icon_de_shop'), $r('app.string.shopping')),
    new SettingViewData($r('app.media.icon_de_game'), $r('app.string.game'))];

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Divider()
            .vertical(false)
            .strokeWidth(DIVIDER_STROKWIDTH)
            .color($r('app.color.divider_color'))
          // 设置项组件
          SettingItemView(new SettingViewData($r('app.media.find_friends'), $r('app.string.circle')))
            .id(CHAT_COMMUNITY)
            .onClick(() => {
              router.pushUrl({ url: 'pages/FriendsMomentsPage' })
            })
          ForEach(this.settingViewData, (item: SettingViewData, index: number) => {
            // 当index为1或者为6的时候不需要设置Divider
            if (index === 1 || index === 6) {
              SettingItemView(new SettingViewData(item.image, item.text))
            } else {
              Divider()
                .vertical(false)
                .strokeWidth(DIVIDER_STROKWIDTH)
                .color($r('app.color.divider_color'))
              SettingItemView(new SettingViewData(item.image, item.text))
            }
          })
        }
      }
    }
    .backgroundColor($r('app.color.discover_page_background'))
    .width('100%')
    .height('100%')
  }
}