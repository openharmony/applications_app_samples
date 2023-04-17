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
import Contacts from './Contacts'
import { OPERATE_STATUS } from '@ohos/common'

@Component
export default struct HomeContent {
  private searchHolder: string = ''
  @State contactsCount: number = 0
  @Link showSearchView: boolean

  build() {
    Navigation() {
      if (!this.showSearchView) {
        if (this.contactsCount > 0) {
          Row() {
            Text(this.contactsCount.toString())
              .fontColor($r('app.color.text_gray'))
              .fontSize(14)
            Text($r('app.string.sub_title'))
              .margin({ left: 5 })
              .fontColor($r('app.color.text_gray'))
              .fontSize(14)
          }
          .width('100%')
          .padding({ left: 24, right: 24 })
        }
        Search({ value: '', placeholder: this.searchHolder, icon: '/common/images/search.png' })
          .placeholderFont({ size: 16 })
          .placeholderColor('#88000000')
          .margin({ left: 24, right: 24, top: 12 })
          .focusable(false)
          .onTouch((event: TouchEvent) => {
            animateTo({ duration: 300, curve: Curve.LinearOutSlowIn }, () => {
              this.showSearchView = true
            })
          })
      }
      Contacts({ contactsCount: $contactsCount })
        .margin({ left: 24, right: 24, bottom: 56 })
    }
    .title(this.NavigationTitle)
    .backgroundColor($r('app.color.page_background'))
    .menus(this.NavigationMenus)
    .titleMode(NavigationTitleMode.Free)
    .hideTitleBar(false)
    .hideBackButton(false)
  }

  @Builder NavigationTitle() {
    Column() {
      Text($r('app.string.MainAbility_label'))
        .fontSize(25)
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder NavigationMenus() {
    Row() {
      Image($r('app.media.add'))
        .width($r('app.float.navigation_image_size'))
        .height($r('app.float.navigation_image_size'))
        .onClick(() => {
          router.push({
            url: 'pages/ContactEdit',
            params: {
              operate: OPERATE_STATUS.ADD
            }
          })
        })
      Image($r('app.media.more'))
        .width($r('app.float.navigation_image_size'))
        .height($r('app.float.navigation_image_size'))
        .margin({ left: 30 })
    }
    .width($r('app.float.navigation_menu_width'))
  }

  aboutToAppear() {
    this.searchHolder = getContext(this).resourceManager.getStringSync($r('app.string.search_placeholder'))
  }
}