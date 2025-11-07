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
import { osAccount, BusinessError } from '@kit.BasicServicesKit';
// [End import_the_system_account_module]
import { router } from '@kit.ArkUI';

// [Start obtain_the_system_account_management_object]
let osAccountMgr = osAccount.getAccountManager();
// [End obtain_the_system_account_management_object]

@Entry
@Component
struct ManageDomainAccounts {
  @State message: string = 'Hello World';

  private async domainAccountExists(): Promise<void> {
    // [Start define_the_domain_account_information_to_be_determined]
    let domainAccountInfo: osAccount.DomainAccountInfo = {
      accountName: 'testAccountName',
      domain: 'testDomain'
    }
    // [End define_the_domain_account_information_to_be_determined]

    // [Start call_the_hasaccount_operation]
    osAccount.DomainAccountManager.hasAccount(domainAccountInfo).then((isAccountExisted: boolean)=>{
      console.info('execute hasAccount successfully, isAccountExisted:' + JSON.stringify(isAccountExisted));
      // [StartExclude call_the_hasaccount_operation]
      if(isAccountExisted) {
        this.message = 'Domain account already exists';
      } else {
        this.message = 'Domain account does not exist';
      }
      // [EndExclude call_the_hasaccount_operation]
    }).catch((err: BusinessError)=>{
      console.error(`execute hasAccount code is ${err.code}, message is ${err.message}`);
      // [StartExclude call_the_hasaccount_operation]
      this.message = `execute hasAccount code is ${err.code}, message is ${err.message}`;
      // [EndExclude call_the_hasaccount_operation]
    });
    // [End call_the_hasaccount_operation]
  }

  private async createDomainAccount(): Promise<void> {
    // [Start define_the_domain_account_information]
    let domainInfo: osAccount.DomainAccountInfo = {
      domain: 'testDomain',
      accountName: 'testAccountName'
    };
    // [End define_the_domain_account_information]

    // [Start create_a_domain_account]
    try {
      osAccountMgr.createOsAccountForDomain(osAccount.OsAccountType.NORMAL, domainInfo,
        (err: BusinessError, osAccountInfo: osAccount.OsAccountInfo)=>{
          if (err) {
            console.error(`createOsAccountForDomain exception: code is ${err.code}, message is ${err.message}`);
            // [StartExclude create_a_domain_account]
            this.message = `createOsAccountForDomain exception: code is ${err.code}, message is ${err.message}`;
            // [EndExclude create_a_domain_account]
          } else {
            console.info('createOsAccountForDomain osAccountInfo:' + JSON.stringify(osAccountInfo));
            // [StartExclude create_a_domain_account]
            this.message = 'Account creation information: ' + JSON.stringify(osAccountInfo.localName);
            // [EndExclude create_a_domain_account]
          }
        });
    } catch (e) {
      const err = e as BusinessError;
      console.error(`createOsAccountForDomain exception: code is ${err.code}, message is ${err.message}`);
      // [StartExclude create_a_domain_account]
      this.message = 'Account creation failed: ' + JSON.stringify(err);
      // [EndExclude create_a_domain_account]
    }
    // [End create_a_domain_account]
  }

  private async deleteDomainAccount(): Promise<void> {
    // [Start obtain_the_system_account_id_based_on_the_domain_account_information]
    let domainInfo: osAccount.DomainAccountInfo = {
      domain: 'testDomain',
      accountName: 'testAccountName'
    };
    let localId: number = 0;
    try {
      localId = await osAccountMgr.getOsAccountLocalIdForDomain(domainInfo);
    } catch (e) {
      const err = e as BusinessError;
      console.error(`getOsAccountLocalIdForDomain exception: code is ${err.code}, message is ${err.message}`);
      // [StartExclude obtain_the_system_account_id_based_on_the_domain_account_information]
      this.message = 'Failed to get account deletion information: ' + JSON.stringify(err);
      // [EndExclude obtain_the_system_account_id_based_on_the_domain_account_information]
    }
    // [End obtain_the_system_account_id_based_on_the_domain_account_information]
    // [Start delete_the_domain_account]
    try {
      osAccountMgr.removeOsAccount(localId, (err: BusinessError)=>{
        if (err) {
          console.error(`removeOsAccount failed, code is ${err.code}, message is ${err.message}`);
          // [StartExclude delete_the_domain_account]
          this.message = 'Failed to delete account: ' + JSON.stringify(err);
          // [EndExclude delete_the_domain_account]
        } else {
          console.info('removeOsAccount successfully');
          // [StartExclude delete_the_domain_account]
          this.message = 'Successfully deleted account';
          // [EndExclude delete_the_domain_account]
        }
      });
    } catch (e) {
      const err = e as BusinessError;
      console.error(`removeOsAccount exception: code is ${err.code}, message is ${err.message}`);
    }
    // [End delete_the_domain_account]

  }

  private async queryDomainAccount(): Promise<void> {
    // [Start define_query_options]
    let options: osAccount.GetDomainAccountInfoOptions = {
      domain: 'testDomain',
      accountName: 'testAccountName'
    }
    // [End define_query_options]
    // [Start query_the_domain_account_information]
    try {
      osAccount.DomainAccountManager.getAccountInfo(options,
        (err: BusinessError, result: osAccount.DomainAccountInfo) => {
          if (err) {
            console.error(`call getAccountInfo failed, code is ${err.code}, message is ${err.message}`);
            // [StartExclude query_the_domain_account_information]
            this.message = 'Query failed: ' + JSON.stringify(err);
            // [EndExclude query_the_domain_account_information]
          } else {
            console.info('getAccountInfo result: ' + result);
            // [StartExclude query_the_domain_account_information]
            this.message = 'Queried account information: ' + JSON.stringify(result.accountName);
            // [EndExclude query_the_domain_account_information]
          }
        });
    } catch (e) {
      const err = e as BusinessError;
      console.error(`getAccountInfo exception = code is ${err.code}, message is ${err.message}`);
      // [StartExclude query_the_domain_account_information]
      this.message = 'Failed to query account information: ' + JSON.stringify(err);
      // [EndExclude query_the_domain_account_information]
    }
    // [End query_the_domain_account_information]
  }

  build() {
    Column() {
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.Domain5'))
        .margin(10)
        .id('button1')
        .onClick(() => this.domainAccountExists())
      Button($r('app.string.Domain6'))
        .margin(10)
        .id('button2')
        .onClick(() => this.createDomainAccount())
      Button($r('app.string.Domain7'))
        .margin(10)
        .id('button3')
        .onClick(() => this.deleteDomainAccount())
      Button($r('app.string.Domain8'))
        .margin(10)
        .id('button4')
        .onClick(() => this.queryDomainAccount())
      Button('Go to AuthenticationDomainAccount')
        .margin(10)
        .id('button5')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/DomainAccount/AuthenticationDomainAccount'
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}