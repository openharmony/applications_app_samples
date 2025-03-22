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

// [Start import_the_distributed_account_module]
import { distributedAccount, BusinessError } from '@kit.BasicServicesKit';
// [End import_the_distributed_account_module]

// [Start obtain_the_single-instance_object_of_the_distributed_account]
const distributedAccountAbility = distributedAccount.getDistributedAccountAbility();
// [End obtain_the_single-instance_object_of_the_distributed_account]

@Entry
@Component
struct Index {
  @State message: string = 'No Name';

  private async bindCurrentManageDistributedAccounts(): Promise<void> {
    // [Start define_the_distributed_account_information_to_be_logged_in]
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGIN',
    };
    // [End define_the_distributed_account_information_to_be_logged_in]

    // [Start bind_the_current_system_account_to_the_specified_distributed_account]
    await distributedAccountAbility.setOsAccountDistributedInfo(distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfo successfully');
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfo exception: '  + JSON.stringify(err));
      // [StartExclude bind_the_current_system_account_to_the_specified_distributed_account]
      this.message = 'Failed to bind distributed account: ' + JSON.stringify(err);
      // [EndExclude bind_the_current_system_account_to_the_specified_distributed_account]
    });
    // [End bind_the_current_system_account_to_the_specified_distributed_account]

    // [Start view_the_login_information_of_distributed_account]
    distributedAccountAbility.getOsAccountDistributedInfo().then((data: distributedAccount.DistributedInfo) => {
      console.log('distributed information: ' + JSON.stringify(data));
      // [StartExclude view_the_login_information_of_distributed_account]
      this.message = 'Bind distributed account: ' + data.name;
      // [EndExclude view_the_login_information_of_distributed_account]
    }).catch((err: BusinessError) => {
      console.error('getOsAccountDistributedInfo exception: '  + JSON.stringify(err));
      // [StartExclude view_the_login_information_of_distributed_account]
      this.message = 'Failed to get distributed account: ' + JSON.stringify(err);
      // [EndExclude view_the_login_information_of_distributed_account]
    });
    // [End view_the_login_information_of_distributed_account]
  }

  private async unbindCurrentManageDistributedAccounts(): Promise<void> {
    // [Start define_the_distributed_account_information_to_be_logged_out]
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGOUT',
    };
    // [End define_the_distributed_account_information_to_be_logged_out]

    // [Start unbind_the_specified_distributed_account_from_the_current_system_account]
    distributedAccountAbility.setOsAccountDistributedInfo(distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfo successfully');
      // [StartExclude unbind_the_specified_distributed_account_from_the_current_system_account]
      this.message = 'Successfully unbound distributed account'
      // [EndExclude unbind_the_specified_distributed_account_from_the_current_system_account]
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfo exception: '  + JSON.stringify(err));
      // [StartExclude unbind_the_specified_distributed_account_from_the_current_system_account]
      this.message = 'Failed to unbind distributed account'
      // [EndExclude unbind_the_specified_distributed_account_from_the_current_system_account]
    });
    // [End unbind_the_specified_distributed_account_from_the_current_system_account]
  }

  private async bindSpecifyManageDistributedAccounts(): Promise<void> {
    // [Start determine_the_target_system_account_and_define_the_distributed_account_information_to_be_logged_in]
    let localId: number = 100;
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGIN',
    };
    // [End determine_the_target_system_account_and_define_the_distributed_account_information_to_be_logged_in]

    // [Start bind_the_specified_distributed_account_to_the_current_system_account]
    await distributedAccountAbility.setOsAccountDistributedInfoByLocalId(localId, distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfoByLocalId successfully');
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfoByLocalId exception: '  + JSON.stringify(err));
      // [StartExclude bind_the_specified_distributed_account_to_the_current_system_account]
      this.message = 'Failed to bind distributed account on the specified system account: ' + JSON.stringify(err);
      // [EndExclude bind_the_specified_distributed_account_to_the_current_system_account]
    });
    // [End bind_the_specified_distributed_account_to_the_current_system_account]

    // [Start view_the_login_information_of_a_distributed_account]
    distributedAccountAbility.getOsAccountDistributedInfoByLocalId(localId)
      .then((data: distributedAccount.DistributedInfo) => {
      console.log('distributed information: ' + JSON.stringify(data));
      // [StartExclude view_the_login_information_of_a_distributed_account]
      this.message = 'Bind distributed account on the specified system account: ' + data.name;
      // [EndExclude view_the_login_information_of_a_distributed_account]
    }).catch((err: BusinessError) => {
      console.error('getOsAccountDistributedInfoByLocalId exception: '  + JSON.stringify(err));
      // [StartExclude view_the_login_information_of_a_distributed_account]
      this.message = 'Failed to get distributed account on the specified system account: ' + JSON.stringify(err);
      // [EndExclude view_the_login_information_of_a_distributed_account]
    });
    // [End view_the_login_information_of_a_distributed_account]
  }

  private async unbindSpecifyManageDistributedAccounts(): Promise<void> {
    // [Start determine_the_target_system_account_and_define_the_distributed_account_information_to_be_logged_out]
    let localId: number = 100;
    let distributedInfo: distributedAccount.DistributedInfo = {
      name: 'ZhangSan',
      id: '12345',
      event: 'Ohos.account.event.LOGOUT',
    };
    // [End determine_the_target_system_account_and_define_the_distributed_account_information_to_be_logged_out]

    // [Start unbind_the_specified_distributed_account_from_the_target_system_account]
    distributedAccountAbility.setOsAccountDistributedInfoByLocalId(localId, distributedInfo).then(() => {
      console.log('setOsAccountDistributedInfoByLocalId successfully');
      // [StartExclude unbind_the_specified_distributed_account_from_the_target_system_account]
      this.message = 'Successfully logged out and unbound distributed account on the specified system account'
      // [EndExclude unbind_the_specified_distributed_account_from_the_target_system_account]
    }).catch((err: BusinessError) => {
      console.error('setOsAccountDistributedInfoByLocalId exception: '  + JSON.stringify(err));
      // [StartExclude unbind_the_specified_distributed_account_from_the_target_system_account]
      this.message = 'Failed to log out and unbind distributed account on the specified system account'
      // [EndExclude unbind_the_specified_distributed_account_from_the_target_system_account]
    });
    // [End unbind_the_specified_distributed_account_from_the_target_system_account]
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