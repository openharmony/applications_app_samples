/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import adminManager from '@ohos.enterprise.adminManager'
import Want from '@ohos.app.ability.Want'

const admin: Want = {
  bundleName: 'ohos.samples.enterprise_admin_ext_ability',
  abilityName: 'EnterpriseAdminAbility'
}
const enterpriseInfo: adminManager.EnterpriseInfo = { name: 'enterprise', description: 'WuHan' }
const activeAdminType: number = 1

@Entry
@Component
struct Index {
  @State enableAdminMsg: string = ""
  @State disableAdminMsg: string = ""
  @State subscribeManagedEventMsg: string = ""
  @State unsubscribeManagedEventMsg: string = ""

  build() {
    Row() {
      Column() {
        Text($r("app.string.extension_header"))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(40)
        Button() {
          Text($r("app.string.enable_admin"))
            .fontSize(20)
            .fontColor(Color.Blue)
        }
        .key('enableAdmin')
        .type(ButtonType.Capsule)
        .height(60)
        .width(320)
        .margin({
          left: 10,
          right: 10,
          bottom: 5
        })
        .enabled(true)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.enableAdmin()
        })

        Text(this.enableAdminMsg)
          .key('enableAdminMsg')

        Blank().height(20)

        Button() {
          Text($r("app.string.disable_admin"))
            .fontSize(20)
            .fontColor(Color.Blue)
        }
        .key('disableAdmin')
        .type(ButtonType.Capsule)
        .height(60)
        .width(320)
        .margin({
          left: 10,
          right: 10,
          bottom: 5
        })
        .enabled(true)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.disableSuperAdmin()
        })

        Text(this.disableAdminMsg)
          .key('disableAdminMsg')

        Blank().height(20)

        Blank().height(20)

        Button() {
          Text($r("app.string.subscribe_app_install_uninstall_event"))
            .fontSize(20)
            .fontColor(Color.Blue)
        }
        .key('subscribeManagedEvent')
        .type(ButtonType.Capsule)
        .height(60)
        .width(320)
        .margin({
          left: 10,
          right: 10,
          bottom: 5
        })
        .enabled(true)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.subscribeManagedEventCallback()
        })

        Text(this.subscribeManagedEventMsg)
          .key('subscribeManagedEventMsg')

        Blank().height(20)

        Button() {
          Text($r("app.string.unsubscribe_app_install_uninstall_event"))
            .fontSize(20)
            .fontColor(Color.Blue)
        }
        .key('unsubscribeManagedEvent')
        .type(ButtonType.Capsule)
        .height(60)
        .width(320)
        .margin({
          left: 10,
          right: 10,
          bottom: 5
        })
        .enabled(true)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          this.unsubscribeManagedEventPromise()
        })

        Text(this.unsubscribeManagedEventMsg)
          .key('unsubscribeManagedEventMsg')
      }
      .width('100%')
    }
    .height('100%')
  }

  async enableAdmin() {
    await adminManager.enableAdmin(admin, enterpriseInfo, activeAdminType).then(() => {
      this.enableAdminMsg = 'enableAdmin success'
    }).catch((error) => {
      this.enableAdminMsg = 'enableAdmin fail'
    })
  }

  async disableSuperAdmin() {
    await adminManager.disableSuperAdmin(admin.bundleName, (error) => {
      if (error) {
        this.disableAdminMsg = 'disableSuperAdmin fail'
      } else {
        this.disableAdminMsg = 'disableSuperAdmin success'
      }
    })
  }

  async subscribeManagedEventCallback() {
    await adminManager.subscribeManagedEvent(admin,
      [adminManager.ManagedEvent.MANAGED_EVENT_BUNDLE_ADDED,
      adminManager.ManagedEvent.MANAGED_EVENT_BUNDLE_REMOVED], (error) => {
        if (error) {
          this.subscribeManagedEventMsg = 'subscribeManagedEvent fail'
        } else {
          this.subscribeManagedEventMsg = 'subscribeManagedEvent success'
        }
      })
  }

  async unsubscribeManagedEventPromise() {
    await adminManager.unsubscribeManagedEvent(admin,
      [adminManager.ManagedEvent.MANAGED_EVENT_BUNDLE_ADDED,
      adminManager.ManagedEvent.MANAGED_EVENT_BUNDLE_REMOVED]).then(() => {
      this.unsubscribeManagedEventMsg = 'unsubscribeManagedEvent success'
    }).catch((error) => {
      this.unsubscribeManagedEventMsg = 'unsubscribeManagedEvent fail'
    })
  }
}