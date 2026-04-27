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

import { BusinessError } from '@kit.BasicServicesKit';
import { Environment, fileIo } from '@kit.CoreFileKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';


const permissions: Permissions[] = ['ohos.permission.READ_WRITE_DOWNLOAD_DIRECTORY'];


// [Start get_user_dir_example]
function getUserDirExample() {
  try {
    const downloadPath = Environment.getUserDownloadDir();
    console.info(`Succeeded in getting user download dir: ${downloadPath}`);
    const documentsPath = Environment.getUserDocumentDir();
    console.info(`Succeeded in getting user document dir: ${documentsPath}`);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to get user dir. Code: ${err.code}, message: ${err.message}`);
  }
}
// [End get_user_dir_example]

// [Start read_user_download_dir_example]
function readUserDownloadDirExample(context: common.UIAbilityContext) {
  try {
    // 获取 Download 目录
    const downloadPath = Environment.getUserDownloadDir();
    console.info(`Succeeded in getting user download dir: ${downloadPath}`);
    const dirPath = context.filesDir;
    // 查看 Download 目录下的文件并拷贝到沙箱目录中
    let fileList: string[] = fileIo.listFileSync(downloadPath);
    fileList.forEach((file, index) => {
      console.info(`${downloadPath} ${index}: ${file}`);
      if (fileIo.statSync(`${downloadPath}/${file}`).isFile()) {
        fileIo.copyFileSync(`${downloadPath}/${file}`, `${dirPath}/${file}`);
      }
    });
    // 查看沙箱目录下对应的文件
    fileList = fileIo.listFileSync(dirPath);
    fileList.forEach((file, index) => {
      console.info(`Succeeded in listing file, ${dirPath} ${index}: ${file}`);
    });
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to read user download dir. Code: ${err.code}, message: ${err.message}`);
  }
}
// [End read_user_download_dir_example]

// [Start write_user_download_dir_example]
function writeUserDownloadDirExample() {
  // 检查是否具有 READ_WRITE_DOWNLOAD_DIRECTORY 权限，无权限则需要向用户申请授予权限。
  try {
    // 获取 Download 目录
    const downloadPath = Environment.getUserDownloadDir();
    console.info(`Succeeded in getting user download dir: ${downloadPath}`);
    // 保存 temp.txt 到 Download 目录下
    const file = fileIo.openSync(`${downloadPath}/temp.txt`, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
    fileIo.writeSync(file.fd, 'write a message');
    fileIo.closeSync(file);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to write user download dir. Code: ${err.code}, message: ${err.message}`);
  }
}
// [End write_user_download_dir_example]

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
    console.error(`Failed to request permissions from user. Code: ${err.code}, message: ${err.message}`);
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
        Button($r('app.string.getUserDirExample'))
          .onClick(() => {
            getUserDirExample();
            this.message += 'getUserDirExample SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.readUserDownloadDirExample'))
          .onClick(async () => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            readUserDownloadDirExample(context);
            this.message += 'readUserDownloadDirExample SUCCESS' + '\n';
          })
      }

      Row() {
        Button($r('app.string.writeUserDownloadDirExample'))
          .onClick(async () => {
            writeUserDownloadDirExample();
            this.message += 'writeUserDownloadDirExample SUCCESS' + '\n';
          })
      }
    }

  }
}