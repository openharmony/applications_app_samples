/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import Logger from '../model/Logger';
import { AccountData } from '../model/AccountData';
import { AccountModel } from '../model/AccountModel';

const TAG: string = '[AccountInfo]';

@Component
export struct AccountInfo {
  @Prop email: string;
  @Prop username: string;
  @Prop signature: string;
  @Prop bundleName: string;
  private storage: AccountData = AccountData.getInstance();
  private accountModel: AccountModel = new AccountModel();

  @Builder infoShow(title: Resource, value: string) {
    Row() {
      Text(title)
        .margin(10)
        .fontSize(18)
        .width('25%')
        .textAlign(TextAlign.End)
      Text(value)
        .margin(10)
        .width('55%')
        .fontSize(20)
        .textAlign(TextAlign.Start)
    }
    .padding({ left: 5 })
  }

  build() {
    Scroll() {
      Column() {
        this.infoShow($r('app.string.appname'), this.bundleName)
        this.infoShow($r('app.string.unusername'), this.username)
        this.infoShow($r('app.string.email'), this.email)
        this.infoShow($r('app.string.signature'), this.signature)

        Button($r('app.string.modify'))
          .id('modify')
          .margin(10)
          .width('60%')
          .fontSize(20)
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Modify',
              params: {
                username: this.username,
                bundleName: this.bundleName,
                signature: this.signature,
                email: this.email
              }
            })
          })

        Button($r('app.string.application'))
          .id('application')
          .margin(10)
          .width('60%')
          .fontSize(20)
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.warning'),
                message: $r('app.string.switch_app'),
                primaryButton: {
                  value: $r('app.string.confirm'),
                  action: () => {
                    router.push({
                      url: 'pages/Index'
                    })
                  }
                },
                secondaryButton: {
                  value: $r('app.string.cancel'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          })

        Button($r('app.string.delete'))
          .id('delete')
          .margin(10)
          .width('60%')
          .fontSize(20)
          .fontColor(Color.White)
          .type(ButtonType.Capsule)
          .onClick(() => {
            AlertDialog.show(
              {
                title: $r('app.string.warning'),
                message: $r('app.string.delete_account'),
                primaryButton: {
                  value: $r('app.string.confirm'),
                  action: () => {
                    this.accountModel.deleteAccount(`${this.username}_${this.bundleName}`);
                    this.storage.deleteStorageValue(getContext(), this.username, this.bundleName)
                    router.push({
                      url: 'pages/Login',
                      params: {
                        bundleName: this.bundleName
                      }
                    })
                  }
                },
                secondaryButton: {
                  value: $r('app.string.cancel'),
                  action: () => {
                    Logger.info(TAG, `AlertDialog enter`)
                  }
                },
                cancel: () => {
                  Logger.info(TAG, `AlertDialog close`)
                }
              })
          })
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
  }
}