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

import { distributedAccount, BusinessError } from '@kit.BasicServicesKit';

const distributedAccountAbility = distributedAccount.getDistributedAccountAbility();

@Entry
@Component
struct Index {
  @State message: string = 'No Name';

  private async bindCurrentManageDistributedAccounts(): Promise<void> {
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGIN',
    };

    await distributedAccountAbility.setOsAccountDistributedInfo(distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfo successfully');
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfo exception: '  + JSON.stringify(err));
      this.message = 'Failed to bind distributed account: ' + JSON.stringify(err);
    });

    distributedAccountAbility.getOsAccountDistributedInfo().then((data: distributedAccount.DistributedInfo) => {
      console.log('distributed information: ' + JSON.stringify(data));
      this.message = 'Bind distributed account: ' + data.name;
    }).catch((err: BusinessError) => {
      console.error('getOsAccountDistributedInfo exception: '  + JSON.stringify(err));
      this.message = 'Failed to get distributed account: ' + JSON.stringify(err);
    });
  }

  private async unbindCurrentManageDistributedAccounts(): Promise<void> {
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGOUT',
    };

    distributedAccountAbility.setOsAccountDistributedInfo(distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfo successfully');
      this.message = 'Successfully unbound distributed account'
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfo exception: '  + JSON.stringify(err));
      this.message = 'Failed to unbind distributed account'
    });
  }

  private async bindSpecifyManageDistributedAccounts(): Promise<void> {
    let localId: number = 100;
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGIN',
    };

    await distributedAccountAbility.setOsAccountDistributedInfoByLocalId(localId, distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfoByLocalId successfully');
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfoByLocalId exception: '  + JSON.stringify(err));
      this.message = 'Failed to bind distributed account on the specified system account: ' + JSON.stringify(err);
    });

    distributedAccountAbility.getOsAccountDistributedInfoByLocalId(localId)
      .then((data: distributedAccount.DistributedInfo) => {
      console.log('distributed information: ' + JSON.stringify(data));
      this.message = 'Bind distributed account on the specified system account: ' + data.name;
    }).catch((err: BusinessError) => {
      console.error('getOsAccountDistributedInfoByLocalId exception: '  + JSON.stringify(err));
      this.message = 'Failed to get distributed account on the specified system account: ' + JSON.stringify(err);
    });
  }

  private async unbindSpecifyManageDistributedAccounts(): Promise<void> {
    let localId: number = 100;
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGOUT',
    };

    distributedAccountAbility.setOsAccountDistributedInfoByLocalId(localId, distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfoByLocalId successfully');
      this.message = 'Successfully logged out and unbound distributed account on the specified system account'
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfoByLocalId exception: '  + JSON.stringify(err));
      this.message = 'Failed to log out and unbind distributed account on the specified system account'
    });
  }

  build() {
    Column() {
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.DistributedAccount1'))
        .margin(10)
        .id('button1')
        .onClick(() => this.bindCurrentManageDistributedAccounts())
      Button($r('app.string.DistributedAccount2'))
        .margin(10)
        .id('button2')
        .onClick(() => this.unbindCurrentManageDistributedAccounts())
      Button($r('app.string.DistributedAccount3'))
        .margin(10)
        .id('button3')
        .onClick(() => this.bindSpecifyManageDistributedAccounts())
      Button($r('app.string.DistributedAccount4'))
        .margin(10)
        .id('button4')
        .onClick(() => this.unbindSpecifyManageDistributedAccounts())
    }
    .height('100%')
    .width('100%')
  }
}