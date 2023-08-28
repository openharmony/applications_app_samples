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

import router from '@ohos.router'
import { SettingItemView } from './SettingPage'

@Component
export struct DiscoverPage {
  private scroller: Scroller = new Scroller()

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Divider().vertical(false).strokeWidth(20).color("#cccccc")
          Row() {
            SettingItemView({ image: $r('app.media.find_friends'), text: $r('app.string.circle') })
          }
          .id('chatCommunity')
          .onClick(() => {
            router.pushUrl({ url: 'pages/FriendsMomentsPage' })
          })

          Divider().vertical(false).strokeWidth(20).color("#cccccc")
          SettingItemView({ image: $r('app.media.icon_de_scan'), text: $r('app.string.scan') })
          SettingItemView({ image: $r('app.media.icon_de_shake'), text: $r('app.string.shake') })
          Divider().vertical(false).strokeWidth(20).color("#cccccc")
          Column() {
            SettingItemView({ image: $r('app.media.searchOne'), text: $r('app.string.search_one') })
          }

          Divider().vertical(false).strokeWidth(20).color("#cccccc")
          Column() {
            SettingItemView({ image: $r('app.media.applet'), text: $r('app.string.applet') })
          }

          Divider().vertical(false).strokeWidth(20).color("#cccccc")
          Column() {
            SettingItemView({ image: $r('app.media.icon_de_nearby'), text: $r('app.string.around') })
          }

          Divider().vertical(false).strokeWidth(20).color("#cccccc")
          SettingItemView({ image: $r('app.media.icon_de_shop'), text: $r('app.string.shopping') })
          SettingItemView({ image: $r('app.media.icon_de_game'), text: $r('app.string.game') })
        }
      }
    }
    .backgroundColor("#cccccc")
    .width("100%")
    .height("100%")
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}