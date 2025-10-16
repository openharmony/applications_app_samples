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
import { BusinessError, pasteboard} from '@kit.BasicServicesKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';

const permissions: Permissions[] = ['ohos.permission.READ_PASTEBOARD'];
const systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
const patterns: pasteboard.Pattern[] = [pasteboard.Pattern.URL, pasteboard.Pattern.EMAIL_ADDRESS];
let dataPreferences: preferences.Preferences | null = null;

async function isNeedGetPermissionFromUser(): Promise<boolean> {
  try {
    let hasData: boolean = await systemPasteboard.hasData();
    if (!hasData) {
      // 剪贴板不存在数据，无需申请权限
      return false;
    }
    // 获取剪贴板的内容变化次数
    let result : number = systemPasteboard.getChangeCount();
    console.info('Succeeded in getting the ChangeCount. Result: ${result}');
    // 从 Preferences 中读取上次保存的 changeCount
    let storedChangeCount: number = dataPreferences ? Number(dataPreferences.getSync('pasteboardChangeCount', 0)) : 0;
    if (result === storedChangeCount) {
      // 剪贴板无数据变化，无需申请权限
      return false;
    }
    // 更新 Preferences 中的 changeCount
    if (dataPreferences) {
      dataPreferences.putSync('pasteboardChangeCount', result);
      dataPreferences.flushSync(); // 确保数据写入持久化存储
    }
  } catch (err) {
    console.error('Failed to get the ChangeCount. Cause: ${err.message}');
    return false;
  };

  // 查询剪贴板是否存在应用所需数据类型
  try {
    // (可选)涉及口令等应用自身特殊复制内容的，使用detectPatterns过滤口令格式
    let data: pasteboard.Pattern[]  = await systemPasteboard.detectPatterns(patterns);
    if (patterns.sort().join('') != data.sort().join('')) {
      console.info('Not all needed patterns detected, no need to get data.');
      return false;
    }
    // (可选)判断是否有应用需要的数据类型
    let result: boolean = systemPasteboard.hasDataType(pasteboard.MIMETYPE_TEXT_PLAIN);
    console.info('Succeeded in checking the DataType. Result: ${result}');
    if (!result) {
      // 剪贴板不存在应用所需数据类型，无需申请权限
      return false;
    }
  } catch (err) {
    console.error('Failed to check the DataType. Cause:' + err.message);
    return false;
  };
  return true;
}
@Entry
@Component
struct Index {
  @State data: string = '';

  build() {
    Row() {
      Column() {
        TextArea().width(300)
          .onChange((value) => {
            this.data = value;
          })
        Button('复制')
          .fontSize(20)
          .fontWeight(FontWeight.Normal)
          .type(ButtonType.Capsule)
          .margin({ top: 4, left: 4 })
          .width('210')
          .height('30')
          .backgroundColor('#f32dc400')
          .onClick(() => {
            let ret = testNapi.pasteboard_test_set(this.data);
          })
        Button('粘贴')
          .fontSize(20)
          .fontWeight(FontWeight.Normal)
          .type(ButtonType.Capsule)
          .margin({ top: 4, left: 4 })
          .width('210')
          .height('30')
          .backgroundColor('#f32dc400')
          .onClick(() => {
            const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
            if (!isNeedGetPermissionFromUser()) {
              console.info("No neded to bring up the permission pop-up window");
              return;
            }
            let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
            // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗。
            atManager.requestPermissionsFromUser(context, permissions).then((data) => {
              let grantStatus: number[] = data.authResults;
              for (const status of grantStatus) {
                if (status === 0) {
                  // 用户授权，可以继续访问目标操作。
                  let ret = testNapi.pasteboard_test_get();
                } else {
                  // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限。
                  return;
                }
              }
              // 授权成功。
            }).catch((err: BusinessError) => {
              console.error('Failed to request permissions from user. ');
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
