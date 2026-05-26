import { ColorMetrics, LengthMetrics, promptAction, window } from '@kit.ArkUI';
import {
  CodeInputItem,
  NormalInputItem,
  PhoneNumberInputItem,
  UserAgreement
} from '@ohos/mine/src/main/ets/components/LoginComponent';
import { LoginEvent, PageViewUtils, UserLibraryDao } from '@ohos/common';
import { LoginCloud } from '@ohos/mine/src/main/ets/model/cloud/LoginCloud';
import { LoginUtil } from '@ohos/mine/src/main/ets/model/utils/LoginUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { KeyCode } from '@kit.InputKit';
import {
  registrationMonitoring,
  unRegistrationMonitoring
} from '@ohos/nearbydevice/src/main/ets/pages/DeviceDetailPage';
import { inputMethod } from '@kit.IMEKit';
import { scale } from '../../common/utils/ScreenAdaptation';

// 登陆页面
@Entry
@HMRouter({ pageUrl: 'AccountLoginPagePage' })
@Component
export struct AccountLoginPagePage {
  @State isLoading: boolean = false; // 是否正在登录请求中
  @State aboutBlean: boolean = false;
  @State titletext: Resource | string = $r('app.string.account_password_login');
  @State inputAText: string = '';
  @State inputBText: string = '';
  @State loginModeChange: Resource | string = $r('app.string.mobile_number_login');
  @State agreement: boolean = false;
  @State isAccountLogin: boolean = true;
  @State validCodeReqNo: string = '';
  @StorageLink('currentBreakpoint') currentBreakpoint: string = '';
  @State currentIndex: number = 7;
  @State inputBoxHeight: number = 0;
  @State inputFocus: number = 0;
  inputController: inputMethod.InputMethodController | null = inputMethod.getController();

  aboutToAppear(): void {
    PageViewUtils.tabClick();
    this.inputController = inputMethod.getController();
  }

  aboutToDisappear(): void {
    this.aboutBlean = true;
    unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
  }

  build() {
    Stack() {
      Column() {
        Column() {
          Row() {
            Text(this.titletext)
              .fontSize($r('app.string.font_20'))
              .fontColor($r('app.color.text_color_white'))
              .fontWeight(FontWeight.Bold)
              .focusable(false)
              .onClick(() => {
                HMRouterMgr.pop();
              });
          };
        };

        // 输入位置
        Column() {
          Column() {
            if (this.isAccountLogin) {
              Stack() {
                NormalInputItem({
                  focusId: 'account_input',
                  title: $r('app.string.account'),
                  placeholder: $r('app.string.input_account'),
                  inputText: this.inputAText,
                  onDirectionKeyEvent: (e) => {
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                      unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                      focusControl.requestFocus('password_input');
                    }
                    return false;
                  }
                });
              }
              .onFocus(() => {
                registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                  focusControl.requestFocus('account_input');
                });
              });

              Column() {
                NormalInputItem({
                  focusId: 'password_input',
                  title: $r('app.string.password'),
                  placeholder: $r('app.string.input_password'),
                  inputText: this.inputBText,
                  onDirectionKeyEvent: (e) => {
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                      unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                      focusControl.requestFocus('account_input');
                    }
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                      unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                      focusControl.requestFocus('agreement');
                    }
                    return false;
                  }
                });
              }
              .onFocus(() => {
                registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                  focusControl.requestFocus('password_input');
                });
              });
            } else {
              Column() {
                PhoneNumberInputItem({
                  inputText: this.inputAText,
                  focusId: 'phone_input',
                  onDirectionKeyEvent: (e) => {
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                      unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                      focusControl.requestFocus('phone_input_code');
                    }
                    return false;
                  }
                });
              }
              .onFocus(() => {
                registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                  focusControl.requestFocus('phone_input');
                });
              });

              Column() {
                CodeInputItem({
                  inputPhoneNumber: this.inputAText,
                  inputText: this.inputBText,
                  validCodeReqNo: this.validCodeReqNo,
                  focusId: 'phone_input_code',
                  onDirectionKeyEvent: (e) => {
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                      unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                      focusControl.requestFocus('phone_input');
                    }
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                      unRegistrationMonitoring(KeyCode.KEYCODE_ENTER);
                      focusControl.requestFocus('agreement');
                    }
                    return false;
                  }
                });
              }
              .onFocus(() => {
                registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
                  focusControl.requestFocus('phone_input_code');
                });
              });
            }
          }
          .justifyContent(FlexAlign.Center)
          .width('60%');

          UserAgreement({ focusId: 'agreement', agreement: this.agreement })
            .margin({ top: scale(40) })
            .onFocus(() => {
              unRegistrationMonitoring(KeyCode.KEYCODE_DPAD_CENTER);
            });
          // 登录按钮
          Button($r('app.string.login'))
            .width('20%')
            .height(scale(40))
            .fontSize(scale(16))
            .borderRadius(scale(40))
            .backgroundColor($r('app.color.default_button_bg'))
            .fontColor($r('app.color.text_color_black'))
            .focusBox({
              margin: LengthMetrics.lpx(8),
              strokeColor: ColorMetrics.resourceColor($r('app.color.white')),
              strokeWidth: LengthMetrics.lpx(2)
            })
            .margin({
              top: scale(20),
              left: scale(20),
              right: scale(20),
              bottom: scale(10)
            })
            .onClick(() => {
              if (!this.agreement) {
                promptAction.showToast({
                  message: $r('app.string.consent_agreement'),
                  duration: 2000
                });
                return;
              }
              if (this.isLoading) {
                return;
              } // 双重保护
              this.isLoading = true; // 显示加载状态
              // 账号登录
              if (this.isAccountLogin) {
                if (LoginUtil.isNumberRight(this.inputAText) && LoginUtil.isNumberRight(this.inputBText)) {
                  LoginCloud.accountLogin(this.inputAText, this.inputBText)
                    .then((data) => {
                      if (data.code == 200) {
                        promptAction.showToast({
                          message: $r('app.string.login_successful'),
                          duration: 2000
                        });
                        HMRouterMgr.pop({ pageUrl: 'CategoryPage' });
                        LoginEvent.sendLoginEvent();
                      } else {
                        if (!this.aboutBlean) {
                          promptAction.showToast({
                            message: $r('app.string.login_failure'),
                            duration: 2000
                          });
                        }
                      }
                    })
                    .catch((err: BusinessError) => {
                      if (!this.aboutBlean) {
                        promptAction.showToast({
                          message: $r('app.string.login_failure'),
                          duration: 2000
                        });
                      }
                    }).finally(() => {
                    this.isLoading = false; // 无论成功失败都隐藏加载
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.account_or_password_incorrect'),
                    duration: 2000
                  });
                  this.isLoading = false; // 输入校验失败立即隐藏
                }
                // 手机号登录
              } else {
                if (LoginUtil.getCountryCodeByPhoneNumber(this.inputAText) && LoginUtil.isCodeRight(this.inputBText)) {
                  LoginCloud.phoneLogin(this.inputAText, this.inputBText, this.validCodeReqNo)
                    .then((token) => {
                      if (token != '-1') {
                        promptAction.showToast({
                          message: $r('app.string.login_successful'),
                          duration: 2000
                        });
                        UserLibraryDao.setUserData({
                          userName: '模拟账号名',
                          userAccount: '134343434343',
                          userPassword: '13434343434',
                          userPhoneNumber: '134343434343',
                          userEmail: '8787787@163.com',
                          userToken: token,
                          isLogin: true
                        });
                        HMRouterMgr.pop({ pageUrl: 'CategoryPage' });
                        LoginEvent.sendLoginEvent();
                      } else {
                        promptAction.showToast({
                          message: $r('app.string.login_failure'),
                          duration: 2000
                        });
                      }
                    })
                    .catch((err: BusinessError) => {
                      promptAction.showToast({
                        message: $r('app.string.login_failure'),
                        duration: 2000
                      });
                    })
                    .finally(() => {
                      this.isLoading = false; // 无论成功失败都隐藏加载
                    });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.account_or_password_incorrect'),
                    duration: 2000
                  });
                  this.isLoading = false;
                }
              }
            })
            .onKeyEvent((e) => {
              if ((e.keyCode == KeyCode.KEYCODE_DPAD_UP || e.keyCode == KeyCode.KEYCODE_DPAD_DOWN ||
                e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) &&
                e.type == KeyType.Down) {
                if (this.isLoading) {
                  e.stopPropagation();
                }
              }
            });
        }
        .margin({
          left: scale(10),
          right: scale(10),
          top: $r('app.string.vp_40'),
          bottom: scale(5)
        });

        Blank();
      }
      .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.page_background'));

      // 加载遮罩层
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(scale(40))
            .height(scale(40))
            .color($r('app.color.white'));
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.6)')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center);
      }

    };
  }
}


