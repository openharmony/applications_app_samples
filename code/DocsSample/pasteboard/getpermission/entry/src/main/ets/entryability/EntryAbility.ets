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

// [Start oh_jsvm_get_arraybuffer_info]
import { window } from '@kit.ArkUI';
import { abilityAccessCtrl, common, Permissions, UIAbility } from '@kit.AbilityKit';
import {BusinessError, pasteboard} from '@kit.BasicServicesKit';

let systemPasteboard: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();

// 校验当前应用是否需要向用户申请剪贴板权限
async function isNeedGetPermissionFromUser(): Promise<boolean> {
  try {
    let hasData: boolean = await systemPasteboard.hasData();
    if (!hasData) {
      // 剪贴板不存在数据，无需申请权限
      return false;
    }
    // 获取剪贴板的内容变化次数
    let changeCount = 0;
    let result : number = systemPasteboard.getChangeCount();
    console.info(`Succeeded in getting the ChangeCount. Result: ${result}`);
    if (result == changeCount) {
      // 剪贴板无数据变化，无需申请权限
      return false;
    }
    changeCount = result;
  } catch (err) {
    console.error(`Failed to get the ChangeCount. Cause: ${err.message}`);
    return false;
  };

  // 查询剪贴板是否存在应用所需数据类型
  try {
    let result: boolean = systemPasteboard.hasDataType(pasteboard.MIMETYPE_TEXT_PLAIN);
    console.info(`Succeeded in checking the DataType. Result: ${result}`);
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

let patterns: Array<pasteboard.Pattern> = [pasteboard.Pattern.URL, pasteboard.Pattern.EMAIL_ADDRESS];
// 涉及口令等应用自身特殊复制内容的，使用detectPatterns过滤口令格式
systemPasteboard.detectPatterns(patterns).then((data: Array<pasteboard.Pattern>) => {
  if (patterns.sort().join('')==data.sort().join('')) {
    console.info('All needed patterns detected, next get data');
    try {
      let result: pasteboard.PasteData = systemPasteboard.getDataSync();
      console.info('Succeeded in getting PasteData.');
      if (!result) {
        // 格式不匹配，则不访问剪贴板
      } else {
        // 执行判断口令逻辑，如果是本应用口令，建议使用cleardata清除剪贴板口令内容
      }
    } catch (err) {
      console.error('Failed to get PasteData. Cause:' + err.message);
    };
  } else {
    console.info("Not all needed patterns detected, no need to get data.");
  }
});

// 拉起弹窗
const permissions: Array<Permissions> = ['ohos.permission.READ_PASTEBOARD'];

function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  if (!isNeedGetPermissionFromUser()) {
    console.info("No neded to bring up the permission pop-up window");
    return;
  }
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗。
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: Array<number> = data.authResults;
    for (const status of grantStatus) {
      if (status === 0) {
        // 用户授权，可以继续访问目标操作。
      } else {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限。
        return;
      }
    }
    // 授权成功。
  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
  })
}
export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // ...
    windowStage.loadContent('pages/Index', (err, data) => {
      reqPermissionsFromUser(permissions, this.context);
      // ...
    });
  }
  // ...
}
// [End oh_jsvm_get_arraybuffer_info]