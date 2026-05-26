/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { NavBar, PageViewUtils } from '@ohos/common';
import { KeyCode } from '@kit.InputKit';
import { LengthMetrics } from '@kit.ArkUI';
import { scale } from '../../common/utils/ScreenAdaptation';

/**
 * 关于-隐私声明页面UI组件
 */
@Entry
@Component
export struct UserPrivacyPage {
  aboutToAppear(): void {
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 100);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.device_management_services_and_privacy'))
          .fontColor($r('app.color.text_color_white'))
          .fontSize($r('app.string.font_20'))
          .fontWeight(FontWeight.Bold)
          .focusable(true)
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
          .onClick(() => {
            HMRouterMgr.pop();
          });
      }.width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: $r('app.string.20_vp') });

      Column() {
        Text($r('app.string.Content_of_user_privacy_agreement'))
          .fontColor($r('app.color.text_color_white'))
          .fontSize($r('app.string.font_16'))
          .fontWeight(FontWeight.Bold)
          .lineHeight(scale(20));
      }
      .width('60%')
      .height('70%')
      .backgroundColor($r('app.color.default_component_color'))
      .borderRadius($r('app.string.20_vp'))
      .padding($r('app.string.40_vp'));
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        HMRouterMgr.pop();
      }
    });
  }
}