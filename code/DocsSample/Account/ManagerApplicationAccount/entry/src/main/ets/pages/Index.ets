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

// [Start import_the_application_account_module]
import { appAccount, BusinessError } from '@kit.BasicServicesKit';
// [End import_the_application_account_module]

// [Start obtain_the_instance_object_of_the_application_account]
const appAccountManager = appAccount.createAppAccountManager();
// [End obtain_the_instance_object_of_the_application_account]

@Entry
@Component
struct Index {
  @State message: string = 'No Name';

  private async createAccount(): Promise<void> {
    // [Start parameter_preparation]
    let name: string = 'ZhangSan';
    let options: appAccount.CreateAccountOptions = {
      customData: {
        age: '10'
      }
    };
    // [End parameter_preparation]
    // [Start create_an_app_account_based_on_the_name_and_options]
    try {
      await appAccountManager.createAccount(name, options);
      console.log('createAccount successfully');
      // [StartExclude create_an_app_account_based_on_the_name_and_options]
      this.message = 'Account creation successful';
      // [EndExclude create_an_app_account_based_on_the_name_and_options]
    } catch (err) {
      console.error('createAccount failed, error: ' + JSON.stringify(err));
      // [StartExclude create_an_app_account_based_on_the_name_and_options]
      this.message = 'Account creation failed: ' + JSON.stringify(err);
      // [EndExclude create_an_app_account_based_on_the_name_and_options]
    }
    // [End create_an_app_account_based_on_the_name_and_options]
  }

  private async getAccounts(): Promise<void> {
    // [Start query_the_account_list]
    appAccountManager.getAllAccounts().then((data: appAccount.AppAccountInfo[]) => {
      console.debug('getAllAccounts successfully, data: ' + JSON.stringify(data));
      // [StartExclude query_the_account_list]
      this.message = 'Query account result: ' + data[0].name;
      // [EndExclude query_the_account_list]
    }).catch((err: BusinessError) => {
      console.error('getAllAccounts failed, error: ' + JSON.stringify(err));
      // [StartExclude query_the_account_list]
      this.message = 'Query account failed: ' + JSON.stringify(err);
      // [EndExclude query_the_account_list]
    });
    // [End query_the_account_list]
  }

  private async setCredential(): Promise<void> {
    // [Start prepare_parameters_to_specify_the_account_name_credential_type_and_credential]
    let name: string = 'ZhangSan';
    let credentialType: string = 'PIN_SIX';
    let credential: string = 'xxxxxx';
    // [End prepare_parameters_to_specify_the_account_name_credential_type_and_credential]

    // [Start set_the_credentials_for_your_account]
    await appAccountManager.setCredential(name, credentialType, credential).then(() => {
      console.log('setCredential successfully');
    }).catch((err: BusinessError) => {
      console.error('setCredential failed: ' + JSON.stringify(err));
      // [StartExclude set_the_credentials_for_your_account]
      this.message = 'Failed to set account credentials: ' + JSON.stringify(err);
      // [EndExclude set_the_credentials_for_your_account]
    });
    // [End set_the_credentials_for_your_account]

    // [Start obtain_the_credentials_for_your_account]
    appAccountManager.getCredential(name, credentialType).then((data: string) => {
      console.log('getCredential successfully, data: ' + data);
      // [StartExclude obtain_the_credentials_for_your_account]
      this.message = 'Successfully set account credentials: ' + data;
      // [EndExclude obtain_the_credentials_for_your_account]
    }).catch((err: BusinessError) => {
      console.error('getCredential failed, error: ' + JSON.stringify(err));
      // [StartExclude obtain_the_credentials_for_your_account]
      this.message = 'Failed to query account credentials: ' + JSON.stringify(err);
      // [EndExclude obtain_the_credentials_for_your_account]
    });
    // [End obtain_the_credentials_for_your_account]
  }

  private async setCustomData(): Promise<void> {
    // [Start prepare_parameters_specify_the_account_name_and_custom_key_values]
    let name: string = 'ZhangSan';
    let key: string = 'age';
    let value: string = '12';
    // [End prepare_parameters_specify_the_account_name_and_custom_key_values]
    // [Start set_up_custom_data_for_your_account]
    await appAccountManager.setCustomData(name, key, value).then(() => {
      console.log('setCustomData successfully');
    }).catch((err: BusinessError) => {
      console.error('setCustomData failed: ' + JSON.stringify(err));
      // [StartExclude set_up_custom_data_for_your_account]
      this.message = 'Failed to set custom account credentials: ' + JSON.stringify(err);
      // [EndExclude set_up_custom_data_for_your_account]
    });
    // [End set_up_custom_data_for_your_account]
    // [Start obtain_the_custom_data_of_the_account]
    appAccountManager.getCustomData(name, key).then((data: string) => {
      console.log('getCustomData successfully, data: ' + data);
      // [StartExclude obtain_the_custom_data_of_the_account]
      this.message = 'Successfully set custom account credentials, ' + key + ' is ' + data;
      // [EndExclude obtain_the_custom_data_of_the_account]
    }).catch((err: BusinessError) => {
      console.error('getCustomData failed, error: ' + JSON.stringify(err));
      // [StartExclude obtain_the_custom_data_of_the_account]
      this.message = 'Failed to query custom account credentials: ' + JSON.stringify(err);
      // [EndExclude obtain_the_custom_data_of_the_account]
    });
    // [End obtain_the_custom_data_of_the_account]
  }

  private async setAuthToken(): Promise<void> {
    // [Start prepare_parameters_to_specify_the_account_name_account_owner_authorization_type_and_authorization_token]
    let name: string = 'ZhangSan';
    let owner: string = 'com.example.s9';
    let authType: string = 'getSocialData';
    let token: string = 'xxxxxx';
    // [End prepare_parameters_to_specify_the_account_name_account_owner_authorization_type_and_authorization_token]
    // [Start set_the_authorization_token_for_the_specified_authorization_type]
    await appAccountManager.setAuthToken(name, authType, token).then(() => {
      console.log('setAuthToken successfully');
    }).catch((err: BusinessError) => {
      console.error('setAuthToken failed: ' + JSON.stringify(err));
      // [StartExclude set_the_authorization_token_for_the_specified_authorization_type]
      this.message = 'Failed to store account authorization token: ' + JSON.stringify(err);
      // [EndExclude set_the_authorization_token_for_the_specified_authorization_type]
    });
    // [End set_the_authorization_token_for_the_specified_authorization_type]
    // [Start obtain_an_authorization_token_for_the_specified_authorization_type]
    await appAccountManager.getAuthToken(name, owner, authType).then((data: string) => {
      console.log('getAuthToken successfully, data: ' + data);
      // [StartExclude obtain_an_authorization_token_for_the_specified_authorization_type]
      this.message = 'Successfully stored account authorization token: ' + data;
      // [EndExclude obtain_an_authorization_token_for_the_specified_authorization_type]
    }).catch((err: BusinessError) => {
      console.error('getAuthToken failed, error: ' + JSON.stringify(err));
      // [StartExclude obtain_an_authorization_token_for_the_specified_authorization_type]
      this.message = 'Failed to get account authorization token: ' + JSON.stringify(err);
      // [EndExclude obtain_an_authorization_token_for_the_specified_authorization_type]
    });
    // [End obtain_an_authorization_token_for_the_specified_authorization_type]
  }

  private async removeAccount(): Promise<void> {
    // [Start delete_account]
    let name: string = 'ZhangSan';
    appAccountManager.removeAccount(name).then(() => {
      console.log('removeAccount successfully');
      // [StartExclude delete_account]
      this.message = 'removeAccount successfully';
      // [EndExclude delete_account]
    }).catch((err: BusinessError) => {
      console.error('removeAccount failed, error: ' + JSON.stringify(err));
      // [StartExclude delete_account]
      this.message = 'Account removal failed: ' + JSON.stringify(err);
      // [EndExclude delete_account]
    });
    // [End delete_account]

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