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
import { ColorMetrics, LengthMetrics, promptAction } from '@kit.ArkUI';
import { Logger, NavBar, PageViewUtils } from '@ohos/common';
import {
  CodeInputItem,
  NormalInputItem,
  PhoneNumberInputItem
} from '@ohos/mine/src/main/ets/components/LoginComponent';
import { LoginUtil } from '@ohos/mine/src/main/ets/model/utils/LoginUtil';
import { KeyCode } from '@kit.InputKit';
import {
  registrationMonitoring,
  unRegistrationMonitoring
} from '@ohos/nearbydevice/src/main/ets/pages/DeviceDetailPage';

// 重置密码页面
@Entry
@HMRouter({ pageUrl: 'PasswordRetrievalPage' })
@Component
export struct PasswordRetrievalPage {
  @State titletext: Resource | string = $r('app.string.input_mobile_number');
  @State yourAccountNumberIs: Resource = $r('app.string.your_account_number_is');
  @State accountNumber: string = '12234234532';
  @State inputAText: string = '';
  @State inputBText: string = '';
  @State inputCText: string = '';
  @State inputDText: string = '';
  @State loginModeChange: Resource | string = $r('app.string.mobile_number_login');
  @State agreement: boolean = false;
  @State isphoneRE: boolean = true;
  @State verifybutton: Resource | string = $r('app.string.next');
  @State validCodeReqNo: string = '';
  @StorageLink('currentBreakpoint') currentBreakpoint: string = '';

  aboutToAppear(): void {
    PageViewUtils.tabClick();
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text(this.titletext)
            .fontSize($r('app.string.font_20'))
            .fontColor($r('app.color.text_color_white'))
            .fontWeight(FontWeight.Bold);
        };
      };

      // 输入位置
      Column() {
        Column() {
          if (this.isphoneRE) {
            Column() {
              PhoneNumberInputItem({
                inputText: this.inputAText,
                focusId: 'mobile_account',
                onDirectionKeyEvent: (e) => {
                  if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                    focusControl.requestFocus('mobile_valid');
                  }
                  return false;
                }
              });
            }
            .onFocus(() => {
              unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
              registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                focusControl.requestFocus('mobile_account');
              });
            });

            Column() {
              CodeInputItem({
                inputPhoneNumber: this.inputAText,
                inputText: this.inputBText,
                validCodeReqNo: this.validCodeReqNo,
                focusId: 'mobile_valid',
                btnId: 'valid_btn',
                onDirectionKeyEvent: (e) => {
                  if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                    unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                    focusControl.requestFocus('mobile_account');
                  }
                  return true;
                }
              });
            }
            .onFocus(() => {
              registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                focusControl.requestFocus('mobile_valid');
              });
            });

          } else {
            Row() {
              Text() {
                Span($r('app.string.your_account_number_is'));
                Span(':  ' + this.accountNumber);
              }
              .fontSize(20)
              .fontColor($r('app.color.text_color_white'));

            }.padding({ top: 20 }).align(Alignment.Top).width('100%');

            Column() {
              NormalInputItem({
                title: $r('app.string.enter_new_password'),
                placeholder: $r('app.string.input_verification'),
                inputText: this.inputCText,
                focusId: 'new_password_input',
                onDirectionKeyEvent: (e) => {
                  if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                    unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                    focusControl.requestFocus('again_password_input');
                  }
                  return false;
                }
              });
            }
            .onFocus(() => {
              registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                focusControl.requestFocus('new_password_input');
              });
            });

            Column() {
              NormalInputItem({
                title: $r('app.string.enter_the_new_password_again'),
                placeholder: '',
                inputText: this.inputDText,
                focusId: 'again_password_input',
                onDirectionKeyEvent: (e) => {
                  if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                    unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                    focusControl.requestFocus('new_password_input');
                  }
                  if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                    unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                    focusControl.requestFocus('again_password_input');
                  }
                  return false;
                }
              });
            }
            .onFocus(() => {
              registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                focusControl.requestFocus('mobile_valid');
              });
            });

          }
        }
        .justifyContent(FlexAlign.Center)
        .width('60%');

        // 确认按钮
        Button(this.verifybutton)
          .margin({ top: 40, bottom: 20 })
          .width('20%')
          .height(40)
          .backgroundColor($r('app.color.default_button_bg'))
          .fontColor($r('app.color.text_color_black'))
          .focusable(true)
          .id('verify_btn')
          .focusBox({
            margin: LengthMetrics.px(10),
            strokeColor: ColorMetrics.resourceColor($r('app.color.white')),
            strokeWidth: LengthMetrics.px(2)
          })
          .onClick(() => {
            if (this.isphoneRE) {
              if (LoginUtil.getCountryCodeByPhoneNumber(this.inputAText) && LoginUtil.isCodeRight(this.inputBText)) {
                promptAction.showToast({
                  message: $r('app.string.successful_verification'),
                  duration: 2000
                });
                this.isphoneRE = false;
                this.titletext = $r('app.string.ready_reset_password');
                this.verifybutton = $r('app.string.reset_password');
                PageViewUtils.tabClick();
              } else {
                promptAction.showToast({
                  message: $r('app.string.account_or_code_format_incorrect'),
                  duration: 2000
                });
              }
            } else {
              if (LoginUtil.isNumberRight(this.inputCText) && this.inputCText == this.inputDText) {
                promptAction.showToast({
                  message: $r('app.string.reset_successfully'),
                  duration: 2000
                });
              } else {
                promptAction.showToast({
                  message: $r('app.string.two_password_format_error'),
                  duration: 2000
                });
              }
            }
          });
      }.margin({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5
      });
    }
    .width('100%')
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onVisibleAreaChange([0.0], (isVisible: boolean, currentRatio: number) => {
      if (!isVisible) {
        Logger.info(`PasswordRetrievalPage isVisible: ${isVisible}, currentRatio: ${currentRatio}`);
        unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
      }
    });
  }
}