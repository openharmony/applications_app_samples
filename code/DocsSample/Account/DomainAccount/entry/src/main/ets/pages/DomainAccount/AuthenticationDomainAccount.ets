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

import { osAccount } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct AuthenticationDomainAccount {
  @State message: string = 'No Message';

  private async passwordAuthenticateDomainAccount(): Promise<void> {
    let domainAccountInfo: osAccount.DomainAccountInfo = {
      domain: 'CHINA',
      accountName: 'zhangsan'
    };
    let credential: Uint8Array = new Uint8Array([0]);
    let callback: osAccount.IUserAuthCallback = {
      onResult: (resultCode: number, authResult: osAccount.AuthResult) => {
        console.log('auth resultCode = ' + resultCode);
        console.log('auth authResult = ' + JSON.stringify(authResult));
        if(resultCode == 0) {
          this.message = 'Successfully authenticated domain account using password';
        } else {
          this.message = 'Failed to authenticate domain account using password: ' + resultCode;
        }

      }
    };
    try {
      osAccount.DomainAccountManager.auth(domainAccountInfo, credential, callback);
    } catch (err) {
      console.error('auth exception = ' + JSON.stringify(err));
    }
  }

  private async popupAuthenticateDomainAccount(): Promise<void> {
    let callback: osAccount.IUserAuthCallback = {
      onResult: (resultCode: number, authResult: osAccount.AuthResult) => {
        console.log('authWithPopup resultCode = ' + resultCode);
        console.log('authWithPopup authResult = ' + JSON.stringify(authResult));
        if(resultCode == 0) {
          this.message = 'Successfully authenticated domain account using popup';
        } else if(resultCode == 12300003) {
          this.message = 'No domain account is bound';
        } else {
          this.message = 'Failed to authenticate domain account using popup: ' + resultCode;
        }
      }
    }
    try {
      osAccount.DomainAccountManager.authWithPopup(callback)
    } catch (err) {
      console.error('authWithPopup exception = ' + JSON.stringify(err));
      this.message = 'Exception occurred during popup authentication: ' + JSON.stringify(err);
    }
  }

  build() {
    Column() {
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.Domain1'))
        .margin(10)
        .id('button1')
        .onClick(() => this.passwordAuthenticateDomainAccount())
      Button($r('app.string.Domain2'))
        .margin(10)
        .id('button2')
        .onClick(() => this.popupAuthenticateDomainAccount())
      Button('Go to plugin')
        .margin(10)
        .id('button3')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/DomainAccount/ManageDomainAccountsPlugin'
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}