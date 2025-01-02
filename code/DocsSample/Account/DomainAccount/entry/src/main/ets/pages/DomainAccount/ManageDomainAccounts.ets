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

import { osAccount, BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

let osAccountMgr = osAccount.getAccountManager();

@Entry
@Component
struct ManageDomainAccounts {
  @State message: string = 'Hello World';

  private async domainAccountExists(): Promise<void> {
    let domainAccountInfo: osAccount.DomainAccountInfo = {
      accountName: 'testAccountName',
      domain: 'testDomain'
    }

    let isAccountExisted: boolean = await osAccount.DomainAccountManager.hasAccount(domainAccountInfo);
    console.log('domainAccount isAccountExisted:' + isAccountExisted);
    if(isAccountExisted) {
      this.message = 'Domain account already exists';
    } else {
      this.message = 'Domain account does not exist';
    }
  }

  private async createDomainAccount(): Promise<void> {
    let domainInfo: osAccount.DomainAccountInfo = {
      domain: 'testDomain',
      accountName: 'testAccountName'
    };

    try {
      osAccountMgr.createOsAccountForDomain(osAccount.OsAccountType.NORMAL, domainInfo,
        (err: BusinessError, osAccountInfo: osAccount.OsAccountInfo)=>{
          console.log('createOsAccountForDomain err:' + JSON.stringify(err));
          console.log('createOsAccountForDomain osAccountInfo:' + JSON.stringify(osAccountInfo));
          this.message = 'Account creation information: ' + JSON.stringify(osAccountInfo.localName);
        });
    } catch (e) {
      console.error('createOsAccountForDomain exception: ' + JSON.stringify(e));
      this.message = 'Account creation failed: ' + JSON.stringify(e);
    }
  }

  private async deleteDomainAccount(): Promise<void> {
    let domainInfo: osAccount.DomainAccountInfo = {
      domain: 'testDomain',
      accountName: 'testAccountName'
    };
    let localId: number = 0;
    try {
      localId = await osAccountMgr.getOsAccountLocalIdForDomain(domainInfo);
    } catch (err) {
      console.error('getOsAccountLocalIdForDomain exception: ' + JSON.stringify(err));
      this.message = 'Failed to get account deletion information: ' + JSON.stringify(err);
    }
    try {
      osAccountMgr.removeOsAccount(localId, (err: BusinessError)=>{
        if (err) {
          console.log('removeOsAccount failed, error: ' + JSON.stringify(err));
          this.message = 'Failed to delete account: ' + JSON.stringify(err);
        } else {
          console.log('removeOsAccount successfully');
          this.message = 'Successfully deleted account';
        }
      });
    } catch (err) {
      console.error('removeOsAccount exception: ' + JSON.stringify(err));
    }

  }

  private async queryDomainAccount(): Promise<void> {
    let options: osAccount.GetDomainAccountInfoOptions = {
      domain: 'testDomain',
      accountName: 'testAccountName'
    }
    try {
      osAccount.DomainAccountManager.getAccountInfo(options,
        (err: BusinessError, result: osAccount.DomainAccountInfo) => {
          if (err) {
            console.log('call getAccountInfo failed, error: ' + JSON.stringify(err));
            this.message = 'Query failed: ' + JSON.stringify(err);
          } else {
            console.log('getAccountInfo result: ' + result);
            this.message = 'Queried account information: ' + JSON.stringify(result.accountName);
          }
        });
    } catch (err) {
      console.error('getAccountInfo exception = ' + JSON.stringify(err));
      this.message = 'Failed to query account information: ' + JSON.stringify(err);
    }
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