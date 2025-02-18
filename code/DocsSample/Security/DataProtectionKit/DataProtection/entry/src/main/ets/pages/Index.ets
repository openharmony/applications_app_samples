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

import { dlpPermission } from '@kit.DataProtectionKit';
import { common, Want } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

function openDlpFile(dlpUri: string, fileName: string, fd: number) {
  let want: Want = {
    'action': 'ohos.want.action.viewData',
    'bundleName': 'com.example.example_bundle_name',
    'abilityName': 'exampleAbility',
    'uri': dlpUri,
    'parameters': {
      'fileName': {
        'name': fileName
      },
      'keyFd': {
        'type': 'FD',
        'value': fd
      }
    }
  }

  let context = getContext() as common.UIAbilityContext; // 获取当前UIAbilityContext

  try {
    console.log('openDLPFile:' + JSON.stringify(want));
    console.log('openDLPFile: delegator:' + JSON.stringify(context));
    context.startAbility(want);
  } catch (err) {
    console.error('openDLPFile startAbility failed', (err as BusinessError).code, (err as BusinessError).message);
    return;
  }
}

try {
  let fileUri: string = 'file://docs/storage/Users/currentUser/test.txt';
  let fileName: string = 'test.txt';
  let context = getContext() as common.UIAbilityContext; // 获取当前UIAbilityContext
  let want: Want = {
    'uri': fileUri,
    'parameters': {
      'displayName': fileName
    }
  }; // 请求参数
  dlpPermission.startDLPManagerForResult(context, want).then((res: dlpPermission.DLPManagerResult) => {
    console.info('startDLPManagerForResult res.resultCode:' + res.resultCode);
    console.info('startDLPManagerForResult res.want:' + JSON.stringify(res.want));
  }); // 拉起DLP权限管理应用 设置权限
} catch (err) {
  console.error('startDLPManagerForResult error:' + (err as BusinessError).code + (err as BusinessError).message);
}

dlpPermission.isInSandbox().then((data) => {
  console.log('isInSandbox, result: ' + JSON.stringify(data));
}).catch((err: BusinessError) => {
  console.error('isInSandbox: ' + JSON.stringify(err));
});

dlpPermission.getDLPPermissionInfo().then((data) => {
  console.log('getDLPPermissionInfo, result: ' + JSON.stringify(data));
}).catch((err: BusinessError) => {
  console.error('getDLPPermissionInfo: ' + JSON.stringify(err));
});

dlpPermission.getDLPSupportedFileTypes((err, result) => {
  console.error('getDLPSupportedFileTypes: ' + JSON.stringify(err));
  console.log('getDLPSupportedFileTypes: ' + JSON.stringify(result));
});

try {
  let uri = 'file://docs/storage/Users/currentUser/Desktop/test.txt.dlp';
  let file = fileIo.openSync(uri);
  let res = dlpPermission.isDLPFile(file.fd); // 是否加密DLP文件
  console.info('res', res);
  fileIo.closeSync(file);
} catch (err) {
  console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
}

class SubscribeExample {
  event(info: dlpPermission.AccessedDLPFileInfo) {
    console.info('openDlpFile event', info.uri, info.lastOpenTime)
  }

  unSubscribe() {
    try {
      dlpPermission.off('openDLPFile', this.event); // 取消订阅
    } catch (err) {
      console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
    }
  }

  subscribe() {
    try {
      dlpPermission.on('openDLPFile', this.event); // 订阅
    } catch (err) {
      console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
    }
  }

  onCreate() {
    this.subscribe();
  }

  onDestroy() {
    this.unSubscribe();
  }
}

async function getDLPFileAccessRecords() {
  try {
    let res: dlpPermission.AccessedDLPFileInfo[] = await dlpPermission.getDLPFileAccessRecords(); // 获取DLP访问列表
    console.info('res', JSON.stringify(res))
  } catch (err) {
    console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
  }
}

async function getRetentionSandboxList() {
  try {
    let res: dlpPermission.RetentionSandboxInfo[] = await dlpPermission.getRetentionSandboxList(); // 获取沙箱保留列表
    console.info('res', JSON.stringify(res))
  } catch (err) {
    console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
  }
}

async function setSandboxAppConfig() {
  try {
    await dlpPermission.setSandboxAppConfig('configInfo'); // 设置沙箱应用配置信息
  } catch (err) {
    console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
  }
}

async function cleanSandboxAppConfig() {
  try {
    await dlpPermission.cleanSandboxAppConfig(); // 清理沙箱应用配置信息
  } catch (err) {
    console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
  }
}

async function getSandboxAppConfig() {
  try {
    let res: string = await dlpPermission.getSandboxAppConfig(); // 查询沙箱应用配置信息
    console.info('res', JSON.stringify(res))
  } catch (err) {
    console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
  }
}

try {
  let context = getContext() as common.UIAbilityContext; // 获取当前UIAbilityContext
  let want: Want = {
    'uri': 'file://docs/storage/Users/currentUser/Desktop/1.txt',
    'parameters': {
      'displayName': '1.txt'
    }
  }; // 请求参数
  dlpPermission.startDLPManagerForResult(context, want).then((res) => {
    console.info('res.resultCode', res.resultCode);
    console.info('res.want', JSON.stringify(res.want));
  }); // 打开DLP权限管理应用
} catch (err) {
  console.error('error', err.code, err.message); // 失败报错
}

dlpPermission.isDLPFeatureProvided().then((res) => {
  console.info('res', JSON.stringify(res));
}).catch((err: BusinessError) => {
  console.error('error', (err as BusinessError).code, (err as BusinessError).message); // 失败报错
});

@Entry
@Component
struct Index {
  @State message: string = 'DataProtection';

  build() {
    RelativeContainer() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}
