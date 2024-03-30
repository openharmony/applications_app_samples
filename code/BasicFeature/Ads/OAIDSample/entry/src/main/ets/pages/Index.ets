/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { BusinessError } from '@ohos.base';
import identifier from '@ohos.identifier.oaid';
import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import Want from '@ohos.app.ability.Want';
import Logger from '../log/Logger';

const TAG = 'OAIDPage';

@Entry
@Component
struct Index {
  // 获取到的oaid
  @State oaid: string = '';
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    // 进入页面时触发动态授权弹框，向用户请求授权广告跟踪权限
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(this.context, ["ohos.permission.APP_TRACKING_CONSENT"]).then((data) => {
        if (data.authResults[0] == 0) {
          Logger.info(TAG, 'request permission success');
        } else {
          Logger.info(TAG, `user rejected`);
        }
      }).catch((err: BusinessError) => {
        Logger.info(TAG, `request permission failed, error message: ${(err as BusinessError).message}`);
      })
    } catch (err) {
      Logger.info(TAG, `catch err->${JSON.stringify((err as BusinessError))}`);
    }
  }

  build() {
    Column() {
      ActionBar({ title: $r("app.string.oaid_title") }).height('10%')
      Column() {
        // 获取到的OAID显示区域
        FormItemText({
          label: $r("app.string.oaid_label"),
          value: $oaid,
          compId: 'hiad_demo_oaid_textArea'
        }).width('90%')

        // 1.通过Promise方式获取OAID
        CustomButton({
          mText: $r("app.string.oaid_btn_promise"),
          mOnClick: () => {
            try {
              identifier.getOAID().then((data: string) => {
                this.oaid = data;
                Logger.info(TAG, `getAdsIdentifierInfo by promise success`);
              }).catch((err: BusinessError) => {
                Logger.info(TAG, `getAdsIdentifierInfo failed, message: ${err.message}`);
              })
            } catch (err) {
              Logger.error(TAG, `catch err->${JSON.stringify(err)}`);
            }
          }
        });

        // 2.通过Async Callback方式获取OAID
        CustomButton({
          mText: $r("app.string.oaid_btn_asynccallback"),
          mOnClick: () => {
            try {
              identifier.getOAID((err: BusinessError, data: string) => {
                if (err.code) {
                  Logger.info(TAG, `getAdsIdentifierInfo failed, message: ${err.message}`);
                } else {
                  this.oaid = data;
                  Logger.info(TAG, `getAdsIdentifierInfo by callback success`);
                }
              });
            } catch (err) {
              Logger.error(TAG, `catch err->${JSON.stringify(err)}`);
            }
          }
        });

        // 3.重置OAID
        CustomButton({
          mText: $r("app.string.oaid_btn_reset"),
          mOnClick: () => {
            let want: Want = {
              bundleName: 'com.samples.resetOAID',
              abilityName: 'EntryAbility',
            };
            this.context.startAbility(want,  (err) => {
              if (err.code) {
                Logger.error('StartAbility', `Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
              }
            });
          }
        });
      }
      .width('100%')
      .height('80%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct ActionBar {
  private title: Resource | string = '';

  build() {
    Row() {
      if (this.title) {
        Text(this.title)
          .fontSize(24)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
    }
    .width('100%')
    .padding({ top: 16, bottom: 16, left: 24, right: 24 })
    .backgroundColor(Color.Black)
  }
}

@Component
struct CustomButton {
  private mText: string | Resource = '';
  private mHeight: number = 40;
  private mOnClick: (event?: ClickEvent) => void = (): void => {};
  private componentId: string = '';

  build() {
    Column() {
      Button(this.mText)
        .backgroundColor('#d3d4d6')
        .fontSize(20)
        .fontColor('#000')
        .fontWeight(FontWeight.Normal)
        .align(Alignment.Center)
        .type(ButtonType.Capsule)
        .width('90%')
        .height(this.mHeight)
        .margin({ top: 10, bottom: 5 })
        .onClick(this.mOnClick)
        .id(this.componentId);
    }
  }
}

@Component
struct FormItemText {
  @Link @Watch('WatchValueChange') value: string | boolean;
  label: Resource | string = '';
  private compId: string = '';

  WatchValueChange() {
    Logger.info(TAG, `WatchValueChange value: ${this.value}`);
  }

  build() {
    Row() {
      Text(this.label)
        .fontSize(20)
        .fontColor('#666')
      Text(this.value + '')
        .height(40)
        .borderRadius(20)
        .fontSize(14)
        .backgroundColor('#F1F3F5')
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
        .margin({left: 5})
        .copyOption(CopyOptions.InApp)
        .id(this.compId)
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(50)
  }
}