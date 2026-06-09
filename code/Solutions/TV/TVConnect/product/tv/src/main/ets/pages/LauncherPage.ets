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

import { CommonConstants, PageViewUtils } from '@ohos/common';
import preferences from '@ohos.data.preferences';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@kit.BasicServicesKit';
import { scale } from '../common/utils/ScreenAdaptation';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

/**
 * The LauncherPage is the entry point of the application and shows how to develop the LauncherPage.
 * Stay on the LauncherPage for a few seconds to jump to the AdvertisingPage.
 * Developers can replace the background image.
 */

const TAG = 'LauncherPage';

@Entry
@Component
struct LauncherPage {
  @State isPrivacy: boolean = false;
  @State isOn: boolean = false;

  onConfirm() {
    if (!this.isOn) {
      promptAction.showToast({
        message: $r('app.string.UserAgreement_PrivacyPolicy'),
        duration: 2000
      });
    } else {
      this.saveIsPrivacy().then(() => {
        router.replaceUrl({
          url: 'pages/HomeIndex'
        });
      }).catch((error: BusinessError) => {
        router.replaceUrl({
          url: 'pages/HomeIndex'
        });
      });
    }
  }

  onPageHide() {
    if (this.isPrivacy) {
      router.clear();
    }
  }

  async saveIsPrivacy() {
    let preferences = await this.getDataPreferences(this);
    await preferences.put(CommonConstants.PREFERENCES_KEY_PRIVACY, true);
    await preferences.flush();
  }

  /**
   * Get data preferences action.
   */
  getDataPreferences(common: Object) {
    return preferences.getPreferences(getContext(common), CommonConstants.PREFERENCES_FILE_NAME);
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Stack() {
        Column() {
          Image($r('app.media.icon'))
            .width($r('app.string.launcher_logo_size'))
            .height($r('app.string.launcher_logo_size'));
          Text($r('app.string.launcher_text_name'))
            .width($r('app.string.launcher_life_text_width'))
            .height($r('app.string.launcher_life_text_height'))
            .fontSize($r('app.string.launcher_text_name_size'))
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)
            .margin({ top: scale(20) });
        };
      }.width('100%')
      .flexGrow(1);

      Column() {
        Button($r('app.string.launcher_btn_text'))
          .width($r('app.string.launcher_btn_size_width'))
          .height($r('app.string.launcher_btn_size_height'))
          .fontSize($r('app.string.launcher_btn_text_size'))
          .borderRadius($r('app.string.launcher_btn_size_height'))
          .visibility(this.isPrivacy ? Visibility.Hidden : Visibility.Visible)
          .margin({ bottom: scale(32) })
          .onClick(() => {
            this.onConfirm();
          })
          .focusBox({
            margin: LengthMetrics.lpx(3),
            // strokeColor: ColorMetrics.rgba(0,0,255,1),
            strokeWidth: LengthMetrics.lpx(3)
          });
        Row() {
          Toggle({ type: ToggleType.Checkbox, isOn: false })
            .selectedColor('#007DFF')
            .size({ width: scale(15), height: scale(15) })
            .onChange((isOn: boolean) => {
              this.isOn = isOn;
            });
          Row() {
            Text($r('app.string.Read_agree')).fontSize($r('app.string.launcher_privacy_text_size'));
            Text($r('app.string.User_Agreement'))
              .fontColor('#0A59F7')
              .fontSize($r('app.string.launcher_privacy_text_size'))
              .onClick(() => {
                router.pushUrl({ url: 'pages/login/UserAgreementPage' });
              });
            Text($r('app.string.Content_About')).fontSize($r('app.string.launcher_privacy_text_size'));
            Text($r('app.string.Services_Privacy'))
              .fontColor('#0A59F7')
              .fontSize($r('app.string.launcher_privacy_text_size')).onClick(() => {
              router.pushUrl({ url: 'pages/login/UserPrivacyPage' });
            });
          };
        }
        .visibility(this.isPrivacy ? Visibility.Hidden : Visibility.Visible)
        .margin({ left: scale(10), right: scale(10) });
      }.margin({ bottom: scale(10) })
      .width(CommonConstants.FULL_WIDTH_PERCENT);

    }
    .width('100%')
    .height('100%')
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio >= 1.0) {
        PageViewUtils.tabClick();
      }
    })
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .width(CommonConstants.FULL_WIDTH_PERCENT);
  }
}
