/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import abilityAccessCtrl ,{Permissions}from '@ohos.abilityAccessCtrl'
import promptAction from '@ohos.promptAction'
import common from '@ohos.app.ability.common'
import bundleManager from '@ohos.bundle.bundleManager'
import Logger from '../../model/Logger'

const TAG = 'VerifyIndex'

@Entry
@Component
struct Index {
  @StorageProp('bundleName') bundleName: string = ''
  @StorageProp('permission') permission: string = ''
  @State tokenID: number = 0
  private cancel: string = ''
  private confirm: string = ''
  private ctx: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  async aboutToAppear() {
    let resource = await this.ctx.resourceManager
    this.cancel = resource.getStringSync($r('app.string.cancel').id)
    this.confirm = resource.getStringSync($r('app.string.confirm').id)
    let bundleFlag = 0
    let appInfo = await bundleManager.getApplicationInfo(this.bundleName, bundleFlag)
    this.tokenID = appInfo.accessTokenId
    this.grantUserPermissions(this.permission as Permissions)
  }

  async grantUserPermissions(grantPermissions: Permissions) {
    let atManager = abilityAccessCtrl.createAtManager()
    let result = await promptAction.showDialog({
      title: $r('app.string.title'),
      message: grantPermissions,
      buttons: [
        {
          text: this.cancel,
          color: $r('app.color.cancel'),
        },
        {
          text: this.confirm,
          color: $r('app.color.confirm'),
        }
      ]
    })
    if (result.index === 0) {
      this.ctx.terminateSelf()
    } else {
      let permissionFlag = 2
      try {
        await atManager.grantUserGrantedPermission(this.tokenID, grantPermissions, permissionFlag)
        this.ctx.terminateSelf()
      } catch (err) {
        Logger.info(`err ${JSON.stringify(err)}`)
      }
    }
  }

  build() {
    Row() {
      Column() {
      }
      .width('100%')
    }
    .height('100%')
  }
}