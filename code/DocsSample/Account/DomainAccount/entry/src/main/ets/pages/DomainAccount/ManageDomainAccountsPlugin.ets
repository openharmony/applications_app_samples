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

// [Start import_the_system_account_module]
import { osAccount, AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
// [End import_the_system_account_module]
import { router } from '@kit.ArkUI';

// [Start define_the_plug_in]
let plugin: osAccount.DomainPlugin = {
  auth: (domainAccountInfo: osAccount.DomainAccountInfo, credential: Uint8Array,
    callback: osAccount.IUserAuthCallback) => {
    console.info('plugin auth domain' + domainAccountInfo.domain);
    console.info('plugin auth accountName' + domainAccountInfo.accountName);
    console.info('plugin auth accountId' + domainAccountInfo.accountId);

    let result: osAccount.AuthResult = {
      token: new Uint8Array([0]),
      remainTimes: 5,
      freezingTime: 0
    };
    callback.onResult(0, result);
  },
  authWithPopup: (domainAccountInfo: osAccount.DomainAccountInfo,
    callback: osAccount.IUserAuthCallback) => {
    console.info('plugin authWithPopup domain' + domainAccountInfo.domain);
    console.info('plugin authWithPopup accountName' + domainAccountInfo.accountName);
    console.info('plugin authWithPopup accountId' + domainAccountInfo.accountId);

    let result: osAccount.AuthResult = {
      token: new Uint8Array([0]),
      remainTimes: 5,
      freezingTime: 0
    };
    callback.onResult(0, result);
  },
  authWithToken: (domainAccountInfo: osAccount.DomainAccountInfo,
    token: Uint8Array, callback: osAccount.IUserAuthCallback) => {
    console.info('plugin authWithToken domain' + domainAccountInfo.domain);
    console.info('plugin authWithToken accountName' + domainAccountInfo.accountName);
    console.info('plugin authWithToken accountId' + domainAccountInfo.accountId);
    let result: osAccount.AuthResult = {
      token: new Uint8Array([0]),
      remainTimes: 5,
      freezingTime: 0
    };
    callback.onResult(0, result);
  },
  getAccountInfo: (options: osAccount.GetDomainAccountInfoPluginOptions,
    callback: AsyncCallback<osAccount.DomainAccountInfo>) => {
    console.info('plugin getAccountInfo domain');
    let domainAccountId = Date.now().toString();
    let code: BusinessError = {
      code: 0,
      name: 'mock_name',
      message: 'mock_message'
    };
    let domainStr: string = '';
    if (options.domain != undefined) {
      domainStr = options.domain
    }
    let accountInfo: osAccount.DomainAccountInfo = {
      domain: domainStr,
      accountName: options.accountName,
      accountId: domainAccountId,
      isAuthenticated: false
    };
    callback(code, accountInfo);
  },
  getAuthStatusInfo: (domainAccountInfo: osAccount.DomainAccountInfo,
    callback: AsyncCallback<osAccount.AuthStatusInfo>) => {

    console.info('plugin getAuthStatusInfo domain' + domainAccountInfo.domain);
    console.info('plugin getAuthStatusInfo accountName' + domainAccountInfo.accountName);
    console.info('plugin getAuthStatusInfo accountId' + domainAccountInfo.accountId);

    let code: BusinessError = {
      code: 0,
      name: 'mock_name',
      message: 'mock_message'
    };
    let statusInfo: osAccount.AuthStatusInfo = {
      remainTimes: 5,
      freezingTime: 0
    };
    callback(code, statusInfo);
  },
  bindAccount: (domainAccountInfo: osAccount.DomainAccountInfo, localId: number,
    callback: AsyncCallback<void>) => {
    console.info('plugin bindAccount domain' + domainAccountInfo.domain);
    console.info('plugin bindAccount accountName' + domainAccountInfo.accountName);
    console.info('plugin bindAccount accountId' + domainAccountInfo.accountId);
    let code: BusinessError = {
      code: 0,
      name: 'mock_name',
      message: 'mock_message'
    };
    callback(code);
  },
  unbindAccount: (domainAccountInfo: osAccount.DomainAccountInfo, callback: AsyncCallback<void>) => {
    console.info('plugin unbindAccount domain' + domainAccountInfo.domain);
    console.info('plugin unbindAccount accountName' + domainAccountInfo.accountName);
    console.info('plugin unbindAccount accountId' + domainAccountInfo.accountId);
  },
  isAccountTokenValid: (domainAccountInfo: osAccount.DomainAccountInfo, token: Uint8Array,
    callback: AsyncCallback<boolean>) => {
    console.info('plugin isAccountTokenValid domain' + domainAccountInfo.domain);
    console.info('plugin isAccountTokenValid accountName' + domainAccountInfo.accountName);
    console.info('plugin isAccountTokenValid accountId' + domainAccountInfo.accountId);
    let code: BusinessError = {
      code: 0,
      name: 'mock_name',
      message: 'mock_message'
    };
    callback(code, true);
  },
  getAccessToken: (options: osAccount.GetDomainAccessTokenOptions, callback: AsyncCallback<Uint8Array>) => {
    console.info('plugin getAccessToken domain')
    let code: BusinessError = {
      code: 0,
      name: 'mock_name',
      message: 'mock_message'
    };
    let token: Uint8Array = new Uint8Array([0]);
    callback(code, token);
  }
}
// [End define_the_plug_in]


@Entry
@Component
struct ManageDomainAccountsPlugin {
  @State message: string = 'Manage domain account plugin';

  private async registrationPlugin(): Promise<void> {
    // [Start call_the_api_to_register_the_plug_in]
    try {
      osAccount.DomainAccountManager.registerPlugin(plugin)
      console.info('registerPlugin success');
      // [StartExclude call_the_api_to_register_the_plug_in]
      this.message = 'Successfully registered plugin';
      // [EndExclude call_the_api_to_register_the_plug_in]
    } catch (err) {
      console.error('registerPlugin err: ' + JSON.stringify(err));
      // [StartExclude call_the_api_to_register_the_plug_in]
      this.message = 'Failed to register plugin:  ' + JSON.stringify(err);
      // [EndExclude call_the_api_to_register_the_plug_in]
    }
    // [End call_the_api_to_register_the_plug_in]
  }

  private async logoutPlugin(): Promise<void> {
    // [Start call_the_api_to_log_out_the_plug_in]
    try {
      osAccount.DomainAccountManager.unregisterPlugin();
      console.log('unregisterPlugin success.');
      // [StartExclude call_the_api_to_log_out_the_plug_in]
      this.message = 'unregisterPlugin success';
      // [EndExclude call_the_api_to_log_out_the_plug_in]
    } catch(err) {
      console.error('unregisterPlugin err:' + JSON.stringify(err));
      // [StartExclude call_the_api_to_log_out_the_plug_in]
      this.message = 'Failed to unregister plugin: ' + JSON.stringify(err);
      // [EndExclude call_the_api_to_log_out_the_plug_in]
    }
    // [End call_the_api_to_log_out_the_plug_in]
  }

  build() {
    Column() {
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.Domain3'))
        .margin(10)
        .id('button1')
        .onClick(() => this.registrationPlugin())
      Button($r('app.string.Domain4'))
        .margin(10)
        .id('button2')
        .onClick(() => this.logoutPlugin())
      Button('Return back')
        .id('button3')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/DomainAccount/ManageDomainAccounts'
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}