/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import prompt from '@ohos.prompt'
import bundle from '@ohos.bundle'
import Logger from '../../MainAbility/model/Logger'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import featureAbility from '@ohos.ability.featureAbility'

const TAG: string = '[Index]'

@Entry
@Component
struct Index {
  private tokenID: number = 0
  private permission: string = ''
  private bundleName: string = ''
  private atManager: abilityAccessCtrl.AtManager

  aboutToAppear() {
    featureAbility.getWant(async (error, want) => {
      Logger.info(TAG, `featureAbility.getWant = ${JSON.stringify(want.parameters)}`);
      this.bundleName = want.parameters.bundleName
      this.permission = want.parameters.permissions
      let bundleFlags = 0
      let appInfo = await  bundle.getApplicationInfo(this.bundleName, bundleFlags)
      this.tokenID = appInfo.accessTokenId
      this.atManager = abilityAccessCtrl.createAtManager()
      Logger.info(TAG, `this.atManager = ${JSON.stringify(this.atManager)}`)
      this.grantUserPermissions(this.permission)
    })
  }

  grantUserPermissions = (grantPermissions: string) => {
    AlertDialog.show({
      title: $r('app.string.title'),
      message: grantPermissions,
      primaryButton: {
        value: $r('app.string.cancel'),
        fontColor: Color.Red,
        action: () => {
          Logger.info(TAG, `grantUserPermissions cancel`)
        }
      },
      secondaryButton: {
        value: $r('app.string.confirm'),
        fontColor: Color.Blue,
        action: () => {
          let permissionFlag = 2 // 授权选项，表示允许后不在提醒
          this.atManager.grantUserGrantedPermission(this.tokenID, grantPermissions, permissionFlag, () => {
            Logger.info(TAG, `grantUserPermissions confirm`)
          })
        }
      }
    })
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.button'))
          .key('checkPermission')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let bundleFlag = 0 // 返回的应用信息对象中包含信息的标记,默认值：0
            bundle.getApplicationInfo('ohos.samples.abilityaccessctrl', bundleFlag).then((data) => {
              let appInfo = data
              let tokenID = appInfo.accessTokenId
              Logger.info(TAG, `test AccessTokenTest accessTokenId = ${appInfo.accessTokenId}, name = ${appInfo.name}`)
              this.atManager = abilityAccessCtrl.createAtManager()
              this.atManager.verifyAccessToken(tokenID, "ohos.permission.MICROPHONE").then((data) => {
                Logger.info(TAG, `test grantUserGrantedPermission = ${JSON.stringify(data)}`)
                if (data === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
                  prompt.showToast({ message: '权限已被授予' })
                } else {
                  prompt.showToast({ message: '权限授予失败' })
                }
              })
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}