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

// 设置项的数据类型
class SettingViewDataType {
  image: string | Resource = ''
  text: string | Resource = ''
};

const CHAT_COMMUNITY = 'chatCommunity';
// divider组件的strokWidth为20
const DIVIDER_STROKWIDTH: number = 20;

@Component
export struct DiscoverPage {
  private scroller: Scroller = new Scroller()
  private settingViewData: Array<SettingViewDataType> = [
    { image: $r('app.media.icon_de_scan'), text: $r('app.string.scan') },
    { image: $r('app.media.icon_de_shake'), text: $r('app.string.shake') },
    { image: $r('app.media.searchOne'), text: $r('app.string.search_one') },
    { image: $r('app.media.applet'), text: $r('app.string.applet') },
    { image: $r('app.media.icon_de_nearby'), text: $r('app.string.around') },
    { image: $r('app.media.icon_de_shop'), text: $r('app.string.shopping') },
    { image: $r('app.media.icon_de_game'), text: $r('app.string.game') }];

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Divider()
            .vertical(false)
            .strokeWidth(DIVIDER_STROKWIDTH)
            .color($r('app.color.divider_color'))
          // 设置项组件
          SettingItemView({ image: $r('app.media.find_friends'), text: $r('app.string.circle') })
            .id(CHAT_COMMUNITY)
            .onClick(() => {
              router.pushUrl({ url: 'pages/FriendsMomentsPage' })
            })
          ForEach(this.settingViewData, (item: SettingViewDataType, index) => {
            // 当index为1或者为6的时候不需要设置Divider
            if (index === 1 || index === 6) {
              SettingItemView({ image: item.image, text: item.text })
            } else {
              Divider()
                .vertical(false)
                .strokeWidth(DIVIDER_STROKWIDTH)
                .color($r('app.color.divider_color'))
              SettingItemView({ image: item.image, text: item.text })
            }
          })
        }
      }
    }
    .backgroundColor($r('app.color.discover_page_background'))
    .width("100%")
    .height("100%")
  }
}