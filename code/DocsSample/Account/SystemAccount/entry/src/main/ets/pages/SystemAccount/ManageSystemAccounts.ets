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
import { osAccount, BusinessError } from '@kit.BasicServicesKit';
// [End import_system_account_module]

// [Start obtain_account_management_single_instance_object]
let accountManager = osAccount.getAccountManager();
// [End obtain_account_management_single_instance_object]

@Entry
@Component
struct ManageSystemAccounts {
  @State message: string = 'No work done';
  @State createLocalId: number = -1;

  private async createOsAccount(): Promise<void> {
    // [Start specify_nickname_and_type_information_to_create_system_account]
    let name: string = 'Bob';
    let type: osAccount.OsAccountType = osAccount.OsAccountType.NORMAL;

    accountManager.createOsAccount(name, type, (err: BusinessError, osAccountInfo: osAccount.OsAccountInfo)=>{
      console.log('createOsAccount err:' + JSON.stringify(err));
      console.log('createOsAccount osAccountInfo:' + JSON.stringify(osAccountInfo));
      // [StartExclude specify_nickname_and_type_information_to_create_system_account]
      if (!err) {
        this.message = 'Account creation successful. Account name: ' + JSON.stringify(osAccountInfo.localName);
        this.createLocalId = osAccountInfo.localId;
      } else {
        this.message = 'Failed to create account: ' + JSON.stringify(err);
      }
      // [EndExclude specify_nickname_and_type_information_to_create_system_account]
    });
    // [End specify_nickname_and_type_information_to_create_system_account]
  }

  private async findAllOsAccount(): Promise<void> {
    // [Start query_the_full_account]
    accountManager.queryAllCreatedOsAccounts((err: BusinessError, accountArr: osAccount.OsAccountInfo[])=>{
      console.log('queryAllCreatedOsAccounts err:' + JSON.stringify(err));
      console.log('queryAllCreatedOsAccounts accountArr:' + JSON.stringify(accountArr));
      // [StartExclude query_the_full_account]
      if (!err) {
        this.message = 'Query account successful. Account name:' + JSON.stringify(accountArr[0].localName);
      } else {
        this.message = 'Query account failed: ' + JSON.stringify(err);
      }
      // [EndExclude query_the_full_account]
    });
    // [End query_the_full_account]
  }

  private async findOsAccount(): Promise<void> {
    // [Start query_information_of_the_specified_account]
    let localId: number = 100;
    accountManager.queryOsAccountById(localId, (err: BusinessError, accountInfo: osAccount.OsAccountInfo)=>{
      console.log('queryOsAccountById err:' + JSON.stringify(err));
      console.log('queryOsAccountById accountInfo:' + JSON.stringify(accountInfo));
      // [StartExclude query_information_of_the_specified_account]
      if (!err) {
        this.message = 'Query account successful. Account name for account 100: ' + JSON.stringify(accountInfo.localName);
      } else {
        this.message = 'Query account failed: ' + JSON.stringify(err);
      }
      // [EndExclude query_information_of_the_specified_account]
    });
    // [End query_information_of_the_specified_account]
  }

  private async changeOsAccountHead(): Promise<void> {
    // [Start change_system_account_avatar]
    let localId: number = 100;
    // [StartExclude change_system_account_avatar]
    localId = this.createLocalId;
    // [EndExclude change_system_account_avatar]
    let newPhoto: string = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAAPCAYAAAA/I0V3AAAAAXNSR0IArs4c6QAAAARnQU1BAA'+
      'Cxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACwSURBVDhPvZLBDYMwDEV/ugsXRjAT0EHCOuFIBwkbdIRewi6unbiAyoGgSn1SFH85+Y'+
      'q/4ljARW62X+LHS8uIzjm4dXUYF+utzBikB52Jo5e5iEPKqpACk7R9NM2RvWm5tIkD2czLCUFNKLD6IjdMHFHDzws285MgGrT0xCtp3WOKHo'+
      '+7q0mP0DZW9pNmoEFUzrQjp5cCnaen2kSJXLFD8ghbXyZCMQf/8e8Ns1XVAG/XAgqKzVnJFAAAAABJRU5ErkJggg=='

    accountManager.setOsAccountProfilePhoto(localId, newPhoto, (err: BusinessError)=>{
      console.log('setOsAccountProfilePhoto err:' + JSON.stringify(err));
      // [StartExclude change_system_account_avatar]
      if(!err) {
        this.message = 'Successfully updated system account avatar'
      } else {
        this.message = 'Failed to update system account avatar: ' + JSON.stringify(err);
      }
      // [EndExclude change_system_account_avatar]
    });
    // [End change_system_account_avatar]
  }

  private async changeOsAccountName(): Promise<void> {
    // [Start change_system_account_name]
    let localId: number = 100;
    // [StartExclude change_system_account_name]
    localId = this.createLocalId;
    // [EndExclude change_system_account_name]
    let newName: string = 'Tom';
    accountManager.setOsAccountName(localId, newName, (err: BusinessError) => {
      if (err) {
        console.error('setOsAccountName failed, error: ' + JSON.stringify(err));
        // [StartExclude change_system_account_name]
        this.message = 'Failed to modify system account name: ' + JSON.stringify(err);
        // [EndExclude change_system_account_name]
      } else {
        console.log('setOsAccountName successfully');
        // [StartExclude change_system_account_name]
        this.message = 'Successfully modified system account name';
        // [EndExclude change_system_account_name]
      }
    });
    // [End change_system_account_name]
  }

  private async activateOsAccount(): Promise<void> {
    // [Start activate_system_account]
    let localId: number = 101;
    // [StartExclude activate_system_account]
    localId = this.createLocalId;
    // [EndExclude activate_system_account]
    accountManager.activateOsAccount(localId, (err: BusinessError)=>{
      if (err) {
        console.error(`activateOsAccount failed, code is ${err.code}, message is ${err.message}`);
        // [StartExclude activate_system_account]
        this.message = 'Failed to activate system account: ' + err.code;
        // [EndExclude activate_system_account]
      } else {
        console.log('activateOsAccount successfully');
        // [StartExclude activate_system_account]
        this.message = 'Successfully activated system account'
        // [EndExclude activate_system_account]
      }
    });
    // [End activate_system_account]
  }

  private async deleteOsAccount(): Promise<void> {
    // [Start delete_the_specified_account]
    let localId: number = 101;
    localId = this.createLocalId;
    accountManager.removeOsAccount(localId, (err: BusinessError)=>{
      if (err) {
        console.error('removeOsAccount failed, error: ' + JSON.stringify(err));
        // [StartExclude delete_the_specified_account]
        this.message = 'Failed to delete system account: ' + JSON.stringify(err);
        // [EndExclude delete_the_specified_account]
      } else {
        console.log('removeOsAccount successfully');
        // [StartExclude delete_the_specified_account]
        this.message = 'Successfully deleted system account'
        // [EndExclude delete_the_specified_account]
      }
    });
    // [End delete_the_specified_account]
  }

  build() {
    Column() {
      Text(this.message)
        .id('show')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.Manager1'))
        .margin(10)
        .id('button1')
        .onClick(() => this.createOsAccount())
      Button($r('app.string.Manager2'))
        .margin(10)
        .id('button2')
        .onClick(() => this.findAllOsAccount())
      Button($r('app.string.Manager3'))
        .margin(10)
        .id('button3')
        .onClick(() => this.findOsAccount())
      Button($r('app.string.Manager4'))
        .margin(10)
        .id('button4')
        .onClick(() => this.changeOsAccountHead())
      Button($r('app.string.Manager5'))
        .margin(10)
        .id('button5')
        .onClick(() => this.changeOsAccountName())
      Button($r('app.string.Manager6'))
        .margin(10)
        .id('button6')
        .onClick(() => this.activateOsAccount())
      Button($r('app.string.Manager7'))
        .margin(10)
        .id('button7')
        .onClick(() => this.deleteOsAccount())
    }
    .height('100%')
    .width('100%')
  }
}