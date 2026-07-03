/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { PageViewUtils } from '@ohos/common';
import { CommonGroup, CommonItem, CommonList, NavItem, SimpleItem } from '../ListComponents';
import { UpgradePageItem } from '../UpgradeComponent';
import { KeyCode } from '@kit.InputKit';

/**
 * 设置页面
 */
@HMRouter({ pageUrl: 'SettingsPage' })
@Component
export struct SettingsPage {
  private marketSupport = false;
  @State currentIndex: number = 0;
  @State isFirst: boolean = true;

  build() {
    Column() {
      Row() {
        Text($r('app.string.page_settings'))
          .fontColor($r('app.color.text_color_white'))
          .fontSize($r('app.string.font_20'))
          .fontWeight(FontWeight.Bold)
          .focusable(false)
          .onClick(() => {
            HMRouterMgr.pop();
          });
      }.width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center);

      Column() {
        CommonList() {
          CommonGroup() {

            if (this.marketSupport) {
              NavItem({ pushName: 'LanguagePage' }) {
                SimpleItem({ name: $r('app.string.page_settings_language') });
              };
            }
          };

          CommonGroup() {
            if (this.marketSupport) {
              CommonItem() {
                UpgradePageItem();
              };
            }

            NavItem({ pushName: 'AboutPage' }) {
              SimpleItem({ name: $r('app.string.page_settings_about') });
            };
          };
        };
      }
      .width('60%')
      .margin({ top: $r('app.string.30_vp') });
    }
    .width('100%')
    .height('100%')
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .backgroundColor($r('app.color.page_background'))
    .onAppear(() => {
      setTimeout(() => {
        PageViewUtils.tabClick();
      }, 100);
    })
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE && event.type == 0) {
        HMRouterMgr.pop();
      }
    });
  }
}