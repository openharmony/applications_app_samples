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
import {
  CodeInputItem,
  NormalInputItem,
  PhoneNumberInputItem,
  UserAgreement
} from '@ohos/mine/src/main/ets/components/LoginComponent';
import { ColorMetrics, LengthMetrics, promptAction } from '@kit.ArkUI';
import { LoginCloud } from '@ohos/mine/src/main/ets/model/cloud/LoginCloud';
import { BusinessError } from '@kit.BasicServicesKit';
import { LoginUtil } from '@ohos/mine/src/main/ets/model/utils/LoginUtil';
import { Logger, NavBar, PageViewUtils } from '@ohos/common';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { KeyCode } from '@kit.InputKit';
import {
  registrationMonitoring,
  unRegistrationMonitoring
} from '@ohos/nearbydevice/src/main/ets/pages/DeviceDetailPage';

// 注册页面
@Entry
@HMRouter({ pageUrl: 'AccountRegistrationPage' })
@Component
export struct AccountRegistrationPagePage {
  @State titletext: Resource | string = $r('app.string.input_registration');
  @State inputAText: string = '';
  @State inputBText: string = '';
  @State inputCText: string = '';
  @State inputDText: string = '';
  @State inputEText: string = '';
  @State agreement: boolean = false;
  @State isphoneRE: boolean = true;
  @State flag: boolean = false;
  @State flagTest: boolean = true;
  @State sec: number = 60;
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
          Column() {
            PhoneNumberInputItem({
              inputText: this.inputAText,
              focusId: 'register_phone',
              onDirectionKeyEvent: (e) => {
                if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                  focusControl.requestFocus('register_valid');
                }
                return false;
              }
            });
          }
          .onFocus(() => {
            registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
              focusControl.requestFocus('register_phone');
            });
          });

          Column() {
            CodeInputItem({
              inputPhoneNumber: this.inputAText,
              inputText: this.inputBText,
              validCodeReqNo: this.validCodeReqNo,
              focusId: 'register_valid',
              btnId: 'register_valid_btn',
              onDirectionKeyEvent: (e) => {
                if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register_phone');
                } else if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register_create');
                }

                return true;
              }

            });
          }
          .onFocus(() => {
            registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
              focusControl.requestFocus('register_valid');
            });
          });

          Column() {
            NormalInputItem({
              title: $r('app.string.Create_account'),
              placeholder: $r('app.string.input_verification'),
              inputText: this.inputCText,
              focusId: 'register_create',
              onDirectionKeyEvent: (e) => {
                if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register_valid');
                }
                if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register_new_pwd');
                }
                return false;
              }
            });
          }
          .onFocus(() => {
            registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
              focusControl.requestFocus('register_create');
            });
          });

          Column() {
            NormalInputItem({
              title: $r('app.string.password'),
              placeholder: $r('app.string.input_verification'),
              inputText: this.inputDText,
              focusId: 'register_new_pwd',
              onDirectionKeyEvent: (e) => {
                if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register_create');
                }
                if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register_again_pwd');
                }
                return false;
              }
            });
          }
          .onFocus(() => {
            registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
              focusControl.requestFocus('register_new_pwd');
            });
          });

          Column() {
            NormalInputItem({
              title: $r('app.string.reenter_password'),
              placeholder: $r('app.string.input_verification'),
              inputText: this.inputEText,
              focusId: 'register_again_pwd',
              onDirectionKeyEvent: (e) => {
                if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register_new_pwd');
                }
                if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                  unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                  focusControl.requestFocus('register');
                }
                return false;
              }
            });
          }
          .onFocus(() => {
            registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
              focusControl.requestFocus('register_again_pwd');
            });
          });
        }
        .justifyContent(FlexAlign.Center)
        .width('60%');

      }.margin({
        left: 10,
        right: 10,
        top: 5,
        bottom: 5
      });

      Blank();
      Column() {
        UserAgreement({ agreement: this.agreement, focusId: 'register' })
          .margin({ top: 40, bottom: 20 });
        // 注册按钮
        Button(this.verifybutton)
          .width('20%')
          .height(40)
          .backgroundColor($r('app.color.default_button_bg'))
          .fontColor($r('app.color.text_color_black'))
          .focusBox({
            margin: LengthMetrics.px(10),
            strokeColor: ColorMetrics.resourceColor($r('app.color.white')),
            strokeWidth: LengthMetrics.px(2)
          })
          .onClick(() => {
            if (!this.agreement) {
              promptAction.showToast({
                message: $r('app.string.consent_agreement'),
                duration: 2000
              });
              return;
            }
            if (LoginUtil.getCountryCodeByPhoneNumber(this.inputAText) && LoginUtil.isCodeRight(this.inputBText) &&
            LoginUtil.isNumberRight(this.inputCText) && LoginUtil.isNumberRight(this.inputDText) &&
              this.inputDText === this.inputEText) {
              LoginCloud.tryToRegister(this.inputCText, this.inputDText, this.inputAText, this.inputBText,
                this.validCodeReqNo)
                .then((isSuccess) => {
                  if (isSuccess) {
                    promptAction.showToast({
                      message: $r('app.string.registered_successfully'),
                      duration: 2000
                    });
                    HMRouterMgr.pop();
                  } else {
                    promptAction.showToast({
                      message: $r('app.string.registered_failure'),
                      duration: 2000
                    });
                  }
                })
                .catch((err: BusinessError) => {
                  promptAction.showToast({
                    message: $r('app.string.registered_failure'),
                    duration: 2000
                  });
                });
            } else {
              promptAction.showToast({
                message: $r('app.string.registration_format_incorrect'),
                duration: 2000
              });
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
        Logger.info(`DeviceDetailPage isVisible: ${isVisible}, currentRatio: ${currentRatio}`);
        unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
      }
    });
  }
}