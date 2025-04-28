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

import { appAccount, BusinessError } from '@kit.BasicServicesKit';

const appAccountManager = appAccount.createAppAccountManager();

@Entry
@Component
struct Index {
  @State message: string = 'No Name';

  private async createAccount(): Promise<void> {
    let name: string = 'ZhangSan';
    let options: appAccount.CreateAccountOptions = {
      customData: {
        age: '10'
      }
    };
    try {
      await appAccountManager.createAccount(name, options);
      console.log('createAccount successfully');
      this.message = 'Account creation successful';
    } catch (err) {
      console.error('createAccount failed, error: ' + JSON.stringify(err));
      this.message = 'Account creation failed: ' + JSON.stringify(err);
    }
  }

  private async getAccounts(): Promise<void> {
    appAccountManager.getAllAccounts().then((data: appAccount.AppAccountInfo[]) => {
      console.debug('getAllAccounts successfully, data: ' + JSON.stringify(data));
      this.message = 'Query account result: ' + data[0].name;
    }).catch((err: BusinessError) => {
      console.error('getAllAccounts failed, error: ' + JSON.stringify(err));
      this.message = 'Query account failed: ' + JSON.stringify(err);
    });
  }

  private async setCredential(): Promise<void> {
    let name: string = 'ZhangSan';
    let credentialType: string = 'PIN_SIX';
    let credential: string = 'xxxxxx';

    await appAccountManager.setCredential(name, credentialType, credential).then(() => {
      console.log('setCredential successfully');
    }).catch((err: BusinessError) => {
      console.error('setCredential failed: ' + JSON.stringify(err));
      this.message = 'Failed to set account credentials: ' + JSON.stringify(err);
    });

    appAccountManager.getCredential(name, credentialType).then((data: string) => {
      console.log('getCredential successfully, data: ' + data);
      this.message = 'Successfully set account credentials: ' + data;
    }).catch((err: BusinessError) => {
      console.error('getCredential failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to query account credentials: ' + JSON.stringify(err);
    });
  }

  private async setCustomData(): Promise<void> {
    let name: string = 'ZhangSan';
    let key: string = 'age';
    let value: string = '12';
    await appAccountManager.setCustomData(name, key, value).then(() => {
      console.log('setCustomData successfully');
    }).catch((err: BusinessError) => {
      console.error('setCustomData failed: ' + JSON.stringify(err));
      this.message = 'Failed to set custom account credentials: ' + JSON.stringify(err);
    });
    appAccountManager.getCustomData(name, key).then((data: string) => {
      console.log('getCustomData successfully, data: ' + data);
      this.message = 'Successfully set custom account credentials, ' + key + ' is ' + data;
    }).catch((err: BusinessError) => {
      console.error('getCustomData failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to query custom account credentials: ' + JSON.stringify(err);
    });
  }

  private async setAuthToken(): Promise<void> {
    let name: string = 'ZhangSan';
    let owner: string = 'com.samples.managerapplicationaccount';
    let authType: string = 'getSocialData';
    let token: string = 'xxxxxx';
    await appAccountManager.setAuthToken(name, authType, token).then(() => {
      console.log('setAuthToken successfully');
    }).catch((err: BusinessError) => {
      console.error('setAuthToken failed: ' + JSON.stringify(err));
      this.message = 'Failed to store account authorization token: ' + JSON.stringify(err);
    });
    await appAccountManager.getAuthToken(name, owner, authType).then((data: string) => {
      console.log('getAuthToken successfully, data: ' + data);
      this.message = 'Successfully stored account authorization token: ' + data;
    }).catch((err: BusinessError) => {
      console.error('getAuthToken failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to get account authorization token: ' + JSON.stringify(err);
    });
  }

  private async removeAccount(): Promise<void> {
    let name: string = 'ZhangSan';
    appAccountManager.removeAccount(name).then(() => {
      console.log('removeAccount successfully');
      this.message = 'removeAccount successfully';
    }).catch((err: BusinessError) => {
      console.error('removeAccount failed, error: ' + JSON.stringify(err));
      this.message = 'Account removal failed: ' + JSON.stringify(err);
    });

  }

  build() {
    Column() {
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.Application1'))
        .margin(10)
        .id('button1')
        .onClick(() => this.createAccount())
      Button($r('app.string.Application2'))
        .margin(10)
        .id('button2')
        .onClick(() => this.getAccounts())
      Button($r('app.string.Application3'))
        .margin(10)
        .id('button3')
        .onClick(() => this.setCredential())
      Button($r('app.string.Application4'))
        .margin(10)
        .id('button4')
        .onClick(() => this.setCustomData())
      Button($r('app.string.Application5'))
        .margin(10)
        .id('button5')
        .onClick(() => this.setAuthToken())
      Button($r('app.string.Application6'))
        .margin(10)
        .id('button6')
        .onClick(() => this.removeAccount())
    }
    .height('100%')
    .width('100%')
  }
}