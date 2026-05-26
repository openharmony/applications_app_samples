/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { CommonGroup, } from '@ohos/mine/src/main/ets/components/ListComponents';
import { MineAvatarItem, MineMessageItem } from '@ohos/mine/src/main/ets/components/MineComponent';
import { promptAction, router } from '@kit.ArkUI';
import { Logger, LoginEvent, NavBar, UserLibraryDao } from '@ohos/common';
import { BusinessError } from '@kit.BasicServicesKit';
import { LoginCloud } from '@ohos/mine/src/main/ets/model/cloud/LoginCloud';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

// 我的详情页面
@HMRouter({ pageUrl: 'MineSettingPage', interceptors: ['LoginCheckInterceptor'] })
@Component
export struct MineSettingPage {
  @State @Watch('userNameChange') userName: string = UserLibraryDao.getUserName();
  @State @Watch('userPhoneChange') userPhone: string = UserLibraryDao.getPhoneNumber();
  @State @Watch('userEmailChange') userEmail: string = UserLibraryDao.getEmail();

  userNameChange() {
    LoginCloud.setUserData({ nickname: this.userName }).then((isSuccess) => {
      if (isSuccess) {
      }
    }).catch((error: BusinessError) => {
      Logger.error('Failed to setUserData:' + JSON.stringify(error));
    });
  }

  userPhoneChange() {
    LoginCloud.setUserData({ phone: this.userPhone }).then((isSuccess) => {
      if (isSuccess) {
      }
    }).catch((error: BusinessError) => {
      Logger.error('Failed to setUserData:' + JSON.stringify(error));
    });
  }

  userEmailChange() {
    LoginCloud.setUserData({ email: this.userEmail }).then((isSuccess) => {
      if (isSuccess) {
      }
    }).catch((error: BusinessError) => {
      Logger.error('Failed to setUserData:' + JSON.stringify(error));
    });
  }

  aboutToAppear() {
    if (UserLibraryDao.getIsLogin()) {
    } else {
      promptAction.showToast({
        message: $r('app.string.please_login_first'),
        duration: 2000
      });
      HMRouterMgr.pop();
    }
  }

  build() {
    Column() {
      NavBar({ title: $r('app.string.account_management') });
      MineAvatarItem();
      Row() {
        Text($r('app.string.personal_information')).fontSize(15).fontColor(0x808080).width('100%');
      }
      .margin({
        left: 15,
        right: 15,
        top: 5,
        bottom: 5
      });

      CommonGroup() {
        MineMessageItem({ name: $r('app.string.nickname'), message: this.userName });
        MineMessageItem({ name: $r('app.string.mobile_number'), message: this.userPhone });
        MineMessageItem({ name: $r('app.string.mail_address'), message: this.userEmail });
      };

      CommonGroup() {
        Row() {
          Text($r('app.string.account_security'));
          Blank();
          Image($r('app.media.ic_public_arrow_right')).height(20).margin({ right: 5 });
        }.margin(10).width('100%')
        .onClick(() => {
          HMRouterMgr.push({ pageUrl: 'AccountSecurityPage' });
        });
      };

      Blank();
      Column() {
        Button($r('app.string.log_out'))
          .width('100%')
          .margin(10)
          .fontColor(Color.Red)
          .backgroundColor(0xe4e7e9)
          .onClick(() => {
            LoginCloud.getLoginOut().then(() => {
              LoginEvent.sendOutLoginEvent();
              HMRouterMgr.pop({ pageUrl: 'CategoryPage' }, 1);
            }).catch((error: BusinessError) => {
              Logger.error('Failed to getLoginOut:' + JSON.stringify(error));
            });
          });
      }
      .backgroundColor(Color.Transparent)
      .borderRadius(15)
      .margin({
        left: 15,
        right: 15,
        top: 5,
        bottom: 5
      });
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}