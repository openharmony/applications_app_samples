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
import { LoginCloud } from '../model/cloud/LoginCloud';
import { BusinessError } from '@kit.BasicServicesKit';
import { ColorMetrics, LengthMetrics, promptAction } from '@kit.ArkUI';
import { LoginUtil } from '../model/utils/LoginUtil';
import { HMRouterMgr } from '@hadss/hmrouter';
import { KeyCode } from '@kit.InputKit';
import { scale } from '../model/utils/ScreenAdaptation';

// 手机号输入框
@Component
export struct PhoneNumberInputItem {
  @State areaCode: Resource | string = '';
  @Link @Watch('isPhoneNumber') inputText: string; //手机号输入
  @Prop focusId: string;
  onDirectionKeyEvent?: (event: KeyEvent) => boolean;

  isPhoneNumber() {
    if (this.inputText != null) {
      this.areaCode = LoginUtil.getCountryCodeByPhoneNumber(this.inputText);
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.mobile_number'))
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.text_color_white'));
        Text(this.areaCode).fontColor(Color.Gray).fontSize(scale(17));
        TextInput({ placeholder: $r('app.string.input_mobile_number'), text: this.inputText })
          .placeholderColor($r('app.color.default_text_color'))
          .id(this.focusId)
          .placeholderFont({ size: scale(17), weight: 400 })
          .caretColor(Color.Blue)
          .showUnderline(true)
          .underlineColor({ typing: Color.Transparent, normal: Color.Transparent })
          .layoutWeight(1)
          .margin({ left: scale(20) })
          .fontSize(scale(17))
          .fontColor($r('app.color.default_text_color'))
          .onKeyEvent((event) => {
            if (this.onDirectionKeyEvent && this.onDirectionKeyEvent(event)) {
              event.stopPropagation();
            }
          })
          .onChange((value: string) => {
            this.inputText = value;
          });
      }.padding({ top: scale(20) });

      Divider()
        .strokeWidth(scale(1))
        .color($r('app.color.default_component_color'));
    };
  }
}

// 普通输入框
@Component
export struct NormalInputItem {
  @Prop focusId: string;
  title: Resource | string = '';
  placeholder: Resource | string = '';
  @Link inputText: string;
  onDirectionKeyEvent?: (event: KeyEvent) => boolean;

  build() {
    Column() {
      Row() {
        Text(this.title).fontSize($r('app.string.font_20')).fontColor($r('app.color.text_color_white'));
        TextInput({ placeholder: this.placeholder, text: this.inputText })
          .id(this.focusId)
          .placeholderColor($r('app.color.default_text_color'))
          .placeholderFont({ size: scale(17), weight: 400 })
          .caretColor(Color.Blue)
          .showUnderline(true)
          .underlineColor({ typing: Color.Transparent, normal: Color.Transparent })
          .layoutWeight(1)
          .margin({ left: scale(20) })
          .fontSize(scale(17))
          .fontColor($r('app.color.default_text_color'))
          .onChange((value: string) => {
            this.inputText = value;
          })
          .onKeyEvent((event) => {
            if (this.onDirectionKeyEvent && this.onDirectionKeyEvent(event)) {
              event.stopPropagation();
            }
          });
      }.padding({ top: scale(20) });

      Divider()
        .strokeWidth(1)
        .color($r('app.color.default_component_color'));
    };
  }
}

// 验证码输入框
@Component
export struct CodeInputItem {
  @Prop @Watch('isPhoneNumber') inputPhoneNumber: string = ''; // 需要的手机号
  @Link inputText: string; // 输入的验证码
  @Link validCodeReqNo: string; // 输入的验证码
  @State flag: boolean = false;
  @State flagTest: boolean = true;
  @State sec: number = 60;
  @State codeSeconds: Resource | string = `${this.sec}` + $r('app.string.seconds');
  @Prop focusId: string;
  @Prop btnId: string;
  onDirectionKeyEvent?: (event: KeyEvent) => boolean;

  isPhoneNumber() {
    if (LoginUtil.getCountryCodeByPhoneNumber(this.inputPhoneNumber)) {
      this.flag = true;
    } else {
      this.flag = false;
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.verification_code'))
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.text_color_white'));
        TextInput({ placeholder: $r('app.string.input_verification_code'), text: this.inputText })
          .placeholderColor($r('app.color.default_text_color'))
          .placeholderFont({ size: scale(17), weight: 400 })
          .caretColor(Color.Blue)
          .showUnderline(true)
          .underlineColor({ typing: Color.Transparent, normal: Color.Transparent })
          .layoutWeight(1)
          .margin({ left: scale(20) })
          .fontSize(scale(17))
          .fontColor($r('app.color.default_text_color'))
          .id(this.focusId)
          .onKeyEvent((event) => {
            if (this.onDirectionKeyEvent && this.onDirectionKeyEvent(event)) {
              event.stopPropagation();
            }
            if (event.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && event.type == KeyType.Down) {
              focusControl.requestFocus(this.btnId);
            }
          })
          .onChange((value: string) => {
            this.inputText = value;
          });

        Row() {
          if (this.flagTest) {
            Text($r('app.string.get_verification_code'))
              .fontColor($r('app.color.text_color_black'))
              .focusable(true)
              .focusBox({
                margin: LengthMetrics.lpx(10),
                strokeColor: ColorMetrics.resourceColor($r('app.color.white')),
                strokeWidth: LengthMetrics.lpx(2)
              });
          } else {
            Text() {
              Span(`${this.sec}`).focusable(true);
              Span($r('app.string.seconds')).focusable(true);
            }.fontColor($r('app.color.text_color_white')).focusable(true);
          }
        }
        .margin({ left: scale(10), right: scale(10) })
        .borderRadius(scale(5))
        .enabled(this.flag && this.flagTest)
        .height(scale(35))
        .id(this.btnId)
        .focusable(true)
        .onFocus(() => {
        })
        .backgroundColor(0xe4e7e9)
        .onClick(() => {
          LoginCloud.getLoginCode(this.inputPhoneNumber)
            .then((validCodeReqNo) => {
              console.log('LoginCloud.getLoginCode success' + JSON.stringify(validCodeReqNo));
              this.validCodeReqNo = validCodeReqNo;
              this.materOnClick();
            })
            .catch((err: BusinessError) => {
              console.log('LoginCloud.getLoginCode fail' + JSON.stringify(err));
              promptAction.showToast({
                message: $r('app.string.failed_get_code'),
                duration: 2000
              });
            });
        });
      }.padding({ top: scale(20) });

      Divider();
    };
  }

  private materOnClick() {
    this.flagTest = false;
    let T = setInterval(() => {
      if (this.sec <= 0) {
        this.flagTest = true;
        this.sec = 60;
        clearTimeout(T);
      } else {
        this.sec--;
      }
    }, 1000);
  }
}

// 用户协议组件
@Component
export struct UserAgreement {
  @Prop focusId: string;
  @Link agreement: boolean;

  build() {
    Row() {
      Toggle({ type: ToggleType.Checkbox })
        .id(this.focusId)
        .size({
          width: '25lpx',
          height: '25lpx'
        })
        .onChange((isOn: boolean) => {
          this.agreement = isOn;
        });
      Text($r('app.string.read_and_agree')).fontSize(scale(14)).fontColor($r('app.color.text_color_white'));
      Text($r('app.string.user_agreement')).fontColor(Color.Blue).fontSize(scale(14)).onClick(() => {
        HMRouterMgr.push({ pageUrl: 'UserAgreementPage' });
      });
      Text($r('app.string.and')).fontSize(scale(14)).fontColor($r('app.color.text_color_white'));
      Text($r('app.string.privacy_policy')).fontColor(Color.Blue).fontSize(scale(14)).onClick(() => {
        HMRouterMgr.push({ pageUrl: 'UserPrivacyPage' });
      });
    };
  }
}