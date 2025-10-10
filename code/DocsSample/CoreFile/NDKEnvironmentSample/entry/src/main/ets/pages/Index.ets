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

import testNapi from 'libentry.so';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const permissions: Permissions[] = ['ohos.permission.READ_WRITE_DOWNLOAD_DIRECTORY'];

function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗。
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: number[] = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作。
      } else {
        // 当用户拒绝授权时，系统应提示用户必须授予相应权限才能使用当前页面的功能，并指导用户前往系统设置开启所需权限。
        return;
      }
    }
    // 授权成功。
  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user, code: ${err.code}, message: ${err.message}`);
  })
}

@Entry
@Component
struct Index {
  @State message: string = '';

  aboutToAppear() {
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    reqPermissionsFromUser(permissions, context);
  }

  build() {
    Column() {
      TextArea({
        text: this.message,
        placeholder: '',
      })
        .width('100%')
        .height('50%')

      Row() {
        Button($r('app.string.getUserDownloadDirExample'))
          .onClick(() => {
            testNapi.doGetUserDownloadDirExample();
            this.message += "GetUserDownloadDirExample SUCCESS" + '\n';
          })
      }

      Row() {
        Button($r('app.string.ScanUserDownloadDirPathExample'))
          .onClick(async () => {
            testNapi.doScanUserDownloadDirPathExample();
            this.message += "ScanUserDownloadDirPathExample SUCCESS" + '\n';
          })
      }

      Row() {
        Button($r('app.string.WriteUserDownloadDirPathExample'))
          .onClick(async () => {
            testNapi.doWriteUserDownloadDirPathExample();
            this.message += "WriteUserDownloadDirPathExample SUCCESS" + '\n';
          })
      }

      Row() {
        Button($r('app.string.GetUserDownloadDirPathExample'))
          .onClick(async () => {
            testNapi.doGetUserDownloadDirPathExample();
            this.message += 'GetUserDownloadDirPathExample SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.GetUserDesktopDirPathExample'))
          .onClick(async () => {
            testNapi.doGetUserDesktopDirPathExample();
            this.message += 'GetUserDesktopDirPathExample SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.GetUserDocumentDirPathExample'))
          .onClick(async () => {
            testNapi.doGetUserDocumentDirPathExample();
            this.message += 'GetUserDocumentDirPathExample SUCCESS' + '\n';
          })
      }
    }
  }
}
