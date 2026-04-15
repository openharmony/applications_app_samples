/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start contacts_indexImport]
import { common, abilityAccessCtrl, Permissions, PermissionRequestResult } from '@kit.AbilityKit';
import { contact } from '@kit.ContactsKit';
import { BusinessError } from '@kit.BasicServicesKit';

// [End contacts_indexImport]

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('Contacts Kit (联系人服务)')
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .textContentAlign(TextContentAlign.CENTER)
        .fontSize(20)
        .margin({ top: 20, bottom: 10 })
        .width('100%')

      Button('1.使用Picker选择联系人', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .onClick(() => {
          this.selectContactsByPicker();
        })
        .align(Alignment.Start)
        .margin({ top: 20 })
        .width('100%')

      Button('2.联系人管理（受限开放）API添加联系人', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .onClick(() => {
          this.addContactByPermissions();
        })
        .align(Alignment.Start)
        .margin({ top: 20 })
        .width('100%')

      Button('3.使用picker新建联系人', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .onClick(() => {
          this.addContactByPicker();
        })
        .align(Alignment.Start)
        .margin({ top: 20 })
        .width('100%')

      Button('4.使用picker更新联系人', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .onClick(() => {
          this.updateContactByPicker();
        })
        .align(Alignment.Start)
        .margin({ top: 20 })
        .width('100%')
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 30, right: 30, top: 40 })
  }

  // 当用户选择联系人的时候，通过picker的方式，拉起联系人列表，引导用户完成界面操作，接口本身无需申请权限。
  private selectContactsByPicker(): void {
    // [Start contacts_selectContactsByPicker]
    contact.selectContacts({
      isMultiSelect: false
    }, (err: BusinessError, data) => {
      if (err) {
        console.error('selectContact callback, errCode:' + err.code + ', errMessage:' + err.message);
        return;
      }
      console.info('selectContact callback: success data->${JSON.stringify(data)}');
    });
    // [End contacts_selectContactsByPicker]
  }

  // 若需要在应用内实现管理联系人的功能，可以使用permissions接口获取应用对联系人的编辑权限。
  private addContactByPermissions(): void {
    // [Start contacts_addContactByPermissions]
    // 在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const permissions: Array<Permissions> = ['ohos.permission.WRITE_CONTACTS'];
    const contactInfo: contact.Contact = {
      name: { fullName: '王小明' },
      phoneNumbers: [{ phoneNumber: '13912345678' }]
    }
    abilityAccessCtrl.createAtManager()
      .requestPermissionsFromUser(context, permissions)
      .then((result: PermissionRequestResult) => {
        if (result.authResults[0] !== 0) { // 0 表示请求权限成功，其他任何非零值表示请求失败
          console.error('request contact permissions failed');
          return;
        }
        contact.addContact(context, contactInfo).then((data) => {
          console.info(`Succeeded in adding Contact. data: ${JSON.stringify(data)}`);
        }).catch((err: BusinessError) => {
          console.error(`Failed to add Contact. Code: ${err.code}, message: ${err.message}`);
        });
    })
    // [End contacts_addContactByPermissions]
  }

  // 调用新建联系人接口，打开新建联系人UI界面，用户可在UI界面中填写并新建联系人
  private addContactByPicker(): void {
    // [Start contacts_addContactByPicker]
    let contactInfo: contact.Contact = {
      name: {
        fullName: 'xxx'
      },
      phoneNumbers: [{
        phoneNumber: '138xxxxxx'
      }]
    }
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let promise = contact.addContactViaUI(context, contactInfo);
    promise.then((data) => {
      console.info(`Succeeded in add Contact via UI.data->${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to add Contact via UI. Code: ${err.code}, message: ${err.message}`);
    });
    // [End contacts_addContactByPicker]
  }

  // 可以通过拉起picker，将选中的联系人信息更新到现有联系人中。
  private updateContactByPicker(): void {
    // [Start contacts_updateContactByPicker]
    let contactInfo: contact.Contact = {
      id: 1,
      name: {
        fullName: 'xxx'
      },
      phoneNumbers: [{
        phoneNumber: '138xxxxxx'
      }]
    }
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let promise = contact.saveToExistingContactViaUI(context, contactInfo);
    promise.then((data) => {
      console.info(`Succeeded in save to existing Contact via UI.data->${JSON.stringify(data)}`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to save to existing Contact via UI. Code: ${err.code}, message: ${err.message}`);
    });
    // [End contacts_updateContactByPicker]
  }
}