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

let accountManager = osAccount.getAccountManager();

@Entry
@Component
struct UseConstraintManagementSystemAccount {
  @State message: string = 'No work done';

  private async setOsAccountConstraints(): Promise<void> {
    let localId: number = 100;
    let constraint: string[] = [ 'constraint.wifi.set' ];
    try {
      accountManager.setOsAccountConstraints(localId, constraint, true);
      console.log('setOsAccountConstraints successfully');
      this.message = 'Successfully set the constraint list for the specified system account';
    } catch (err) {
      console.error('setOsAccountConstraints failed, error: ' + JSON.stringify(err));
      this.message = 'Failed to set the constraint list for the specified system account';
    }
  }

  private async isOsAccountConstraintEnabled(): Promise<void> {
    let localId: number = 100;
    let constraint: string = 'constraint.wifi.set';
    let isEnabled: boolean = await accountManager.isOsAccountConstraintEnabled(localId, constraint);
    if (isEnabled) {
      // your business logic
      this.message = 'Set the constraint list for the specified system account';
    } else {
      this.message = 'Can not set the constraint list for the specified system account';
    }
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