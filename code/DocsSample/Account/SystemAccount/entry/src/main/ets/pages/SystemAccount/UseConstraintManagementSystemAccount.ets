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

// [Start import_system_account_module]
import { osAccount } from '@kit.BasicServicesKit';
// [End import_system_account_module]
import { router } from '@kit.ArkUI';

// [Start obtain_account_single_instance_object]
let accountManager = osAccount.getAccountManager();
// [End obtain_account_single_instance_object]

@Entry
@Component
struct UseConstraintManagementSystemAccount {
  @State message: string = 'No work done';

  private async setOsAccountConstraints(): Promise<void> {
    // [Start constraint_collections]
    let localId: number = 100;
    let constraint: string[] = [ 'constraint.wifi.set' ];
    // [End constraint_collections]
    // [Start system_account_constraint]
    try {
      accountManager.setOsAccountConstraints(localId, constraint, true);
      console.log('setOsAccountConstraints successfully');
      // [StartExclude system_account_constraint]
      this.message = 'Successfully set the constraint list for the specified system account';
      // [EndExclude system_account_constraint]
    } catch (err) {
      console.error('setOsAccountConstraints failed, error: ' + JSON.stringify(err));
      // [StartExclude system_account_constraint]
      this.message = 'Failed to set the constraint list for the specified system account';
      // [EndExclude system_account_constraint]
    }
    // [End system_account_constraint]
  }

  private async isOsAccountConstraintEnabled(): Promise<void> {
    // [Start specify_the_system_account_id_and_constraint_name]
    let localId: number = 100;
    let constraint: string = 'constraint.wifi.set';
    // [End specify_the_system_account_id_and_constraint_name]
    // [Start check_whether_the_specified_constraint_is_enabled]
    let isEnabled: boolean = await accountManager.isOsAccountConstraintEnabled(localId, constraint);
    if (isEnabled) {
      // your business logic
      // [StartExclude check_whether_the_specified_constraint_is_enabled]
      this.message = 'Set the constraint list for the specified system account';
    } else {
      this.message = 'Can not set the constraint list for the specified system account';
      // [EndExclude check_whether_the_specified_constraint_is_enabled]
    }
    // [End check_whether_the_specified_constraint_is_enabled]
  }

  build() {
    Column() {
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.Use1'))
        .margin(10)
        .id('button1')
        .onClick(() => this.setOsAccountConstraints())
      Button($r('app.string.Use2'))
        .margin(10)
        .id('button2')
        .onClick(() => this.isOsAccountConstraintEnabled())
      Button($r('app.string.Use3'))
        .margin(10)
        .id('button3')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/SystemAccount/ManageSystemAccounts'
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}