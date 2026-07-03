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
import { CommonGroup, NavItem, SimpleItem } from '../ListComponents';
import { AppInfo, getBundleInfo } from '../../viewmodel/AboutViewModel';
import { NavBar, PageViewUtils } from '@ohos/common';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { KeyCode } from '@kit.InputKit';
import { scale } from '../../model/utils/ScreenAdaptation';

/**
 * 关于页面UI组件
 */
@HMRouter({ pageUrl: 'AboutPage' })
@Component
export struct AboutPage {
  build() {
    Column() {
      Row() {
        Text($r('app.string.page_settings_about'))
          .fontColor($r('app.color.text_color_white'))
          .fontSize($r('app.string.font_20'))
          .fontWeight(FontWeight.Bold)
          .focusable(false)
          .onClick(() => {
            HMRouterMgr.pop();
          });
      }.width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: $r('app.string.20_vp') });

      Column() {
        AboutLogoComponent();
        AboutInfoListComponent();
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: $r('app.string.20_vp') })
      .width('100%')
      .height('70%');
    }
    .onAppear(() => {
      setTimeout(() => {
        PageViewUtils.tabClick();
      }, 100);
    })
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        HMRouterMgr.pop();
      }
    });
  }
}

/**
 * 关于页面logo组件
 */
@Component
export struct AboutLogoComponent {
  @State appInfo: AppInfo = new AppInfo();
  appLogo: Resource = $r('app.media.icon');

  aboutToAppear() {
    this.getAppInfo();
  }

  async getAppInfo() {
    this.appInfo = await getBundleInfo();
  }

  @Builder
  buildPairs() {
    Row() {
      Text($r('app.string.version_number'))
        .fontColor($r('app.color.text_color_white'))
        .fontSize(scale(16));
      Text(':')
        .fontColor($r('app.color.text_color_white'))
        .fontSize(scale(16));
      Text(this.appInfo.versionCode)
        .fontColor($r('app.color.text_color_white'))
        .fontSize(scale(16));
    }.margin(scale(5));
  }

  build() {
    Column() {
      Image(this.appLogo).height(scale(70)).margin(scale(5));
      Text(this.appInfo.name).margin(scale(5)).fontColor($r('app.color.text_color_white'))
        .fontSize(scale(16));
      this.buildPairs();
    }.justifyContent(FlexAlign.Center).margin(scale(10));
  }
}

/**
 * 关于页面信息列表
 */
@Component
export struct AboutInfoListComponent {
  build() {
    Column() {
      CommonGroup() {
        NavItem({ pushName: 'OpenSourceLicensePage' }) {
          SimpleItem({ name: $r('app.string.open_source_license') });
        };

        NavItem({ pushName: 'UserAgreementPage' }) {
          SimpleItem({ name: $r('app.string.universal_connected_user_agreement') });
        };

        NavItem({ pushName: 'UserPrivacyPage' }) {
          SimpleItem({ name: $r('app.string.device_management_services_and_privacy') });
        };
      };
    }.justifyContent(FlexAlign.Center).width('60%');
  }
}