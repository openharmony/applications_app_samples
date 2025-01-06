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

let accountManager = osAccount.getAccountManager();

@Entry
@Component
struct ManageSystemAccounts {
  @State message: string = 'No work done';
  @State createLocalId: number = -1;

  private async createOsAccount(): Promise<void> {
    let name: string = 'Bob';
    let type: osAccount.OsAccountType = osAccount.OsAccountType.NORMAL;

    accountManager.createOsAccount(name, type, (err: BusinessError, osAccountInfo: osAccount.OsAccountInfo)=>{
      console.log('createOsAccount err:' + JSON.stringify(err));
      console.log('createOsAccount osAccountInfo:' + JSON.stringify(osAccountInfo));
      if (!err) {
        this.message = 'Account creation successful. Account name: ' + JSON.stringify(osAccountInfo.localName);
        this.createLocalId = osAccountInfo.localId;
      } else {
        this.message = 'Failed to create account: ' + JSON.stringify(err);
      }
    });
  }

  private async findAllOsAccount(): Promise<void> {
    accountManager.queryAllCreatedOsAccounts((err: BusinessError, accountArr: osAccount.OsAccountInfo[])=>{
      console.log('queryAllCreatedOsAccounts err:' + JSON.stringify(err));
      console.log('queryAllCreatedOsAccounts accountArr:' + JSON.stringify(accountArr));
      if (!err) {
        this.message = 'Query account successful. Account name:' + JSON.stringify(accountArr[0].localName);
      } else {
        this.message = 'Query account failed: ' + JSON.stringify(err);
      }
    });
  }

  private async findOsAccount(): Promise<void> {
    let localId: number = 100;
    accountManager.queryOsAccountById(localId, (err: BusinessError, accountInfo: osAccount.OsAccountInfo)=>{
      console.log('queryOsAccountById err:' + JSON.stringify(err));
      console.log('queryOsAccountById accountInfo:' + JSON.stringify(accountInfo));
      if (!err) {
        this.message = 'Query account successful. Account name for account 100: ' + JSON.stringify(accountInfo.localName);
      } else {
        this.message = 'Query account failed: ' + JSON.stringify(err);
      }
    });
  }

  private async changeOsAccountHead(): Promise<void> {
    let localId: number = 100;
    localId = this.createLocalId;
    let newPhoto: string = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAAPCAYAAAA/I0V3AAAAAXNSR0IArs4c6QAAAARnQU1BAA'+
      'Cxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACwSURBVDhPvZLBDYMwDEV/ugsXRjAT0EHCOuFIBwkbdIRewi6unbiAyoGgSn1SFH85+Y'+
      'q/4ljARW62X+LHS8uIzjm4dXUYF+utzBikB52Jo5e5iEPKqpACk7R9NM2RvWm5tIkD2czLCUFNKLD6IjdMHFHDzws285MgGrT0xCtp3WOKHo'+
      '+7q0mP0DZW9pNmoEFUzrQjp5cCnaen2kSJXLFD8ghbXyZCMQf/8e8Ns1XVAG/XAgqKzVnJFAAAAABJRU5ErkJggg=='

    accountManager.setOsAccountProfilePhoto(localId, newPhoto, (err: BusinessError)=>{
      console.log('setOsAccountProfilePhoto err:' + JSON.stringify(err));
      if(!err) {
        this.message = 'Successfully updated system account avatar'
      } else {
        this.message = 'Failed to update system account avatar: ' + JSON.stringify(err);
      }
    });
  }

  private async changeOsAccountName(): Promise<void> {
    let localId: number = 100;
    localId = this.createLocalId;
    let newName: string = 'Tom';
    accountManager.setOsAccountName(localId, newName, (err: BusinessError) => {
      if (err) {
        console.error('setOsAccountName failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to modify system account name: ' + JSON.stringify(err);
      } else {
        console.log('setOsAccountName successfully');
        this.message = 'Successfully modified system account name';
      }
    });
  }

  private async activateOsAccount(): Promise<void> {
    let localId: number = 101;
    localId = this.createLocalId;
    accountManager.activateOsAccount(localId, (err: BusinessError)=>{
      if (err) {
        console.error(`activateOsAccount failed, code is ${err.code}, message is ${err.message}`);
        this.message = 'Failed to activate system account: ' + err.code;
      } else {
        console.log('activateOsAccount successfully');
        this.message = 'Successfully activated system account'
      }
    });
  }

  private async deleteOsAccount(): Promise<void> {
    let localId: number = 101;
    localId = this.createLocalId;
    accountManager.removeOsAccount(localId, (err: BusinessError)=>{
      if (err) {
        console.error('removeOsAccount failed, error: ' + JSON.stringify(err));
        this.message = 'Failed to delete system account: ' + JSON.stringify(err);
      } else {
        console.log('removeOsAccount successfully');
        this.message = 'Successfully deleted system account'
      }
    });
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