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

import { router } from '@kit.ArkUI';
import { fileUri } from '@kit.CoreFileKit';
import { Want, wantConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'FileIndex';
const DOMAIN = 0x0000;

@Entry
@Component
struct FileIndex {
  @State hideAbility: string = 'hideAbility';
  @State message: string = '';
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Row() {
      Column() {
        Text(this.hideAbility)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.openFile();
          })
      }
      .width('100%')
    }
    .height('100%')
  }

private openFile() {
  try {
    // 获取文件沙箱路径
    let filePath = this.context.filesDir + '/test.txt';
    this.createTestFile(filePath);
    // 将沙箱路径转换为uri
    let uri = fileUri.getUriFromPath(filePath);
    hilog.info(DOMAIN, TAG, 'Generated file URI: ' + uri);

    // 构造请求数据 - 完全使用示例代码
    let want: Want = {
      action: 'ohos.want.action.viewData', // 表示查看数据的操作，文件打开场景固定为此值
      uri: uri,
      type: 'general.plain-text', // 表示待打开文件的类型
      // 配置被分享文件的读写权限，例如对文件打开应用进行读写授权
      flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      parameters: {'ohos.ability.params.showDefaultPicker' : true}
    };

    this.context.startAbility(want)
      .then(() => {
        hilog.info(DOMAIN, TAG, 'Succeed to invoke startAbility.');
      })
      .catch((err: BusinessError) => {
        hilog.error(DOMAIN, TAG, `Failed to invoke startAbility, code: ${err.code}, message: ${err.message}`);
      });
  } catch (err) {
    hilog.error(DOMAIN, TAG, 'Failed to open file: ' + JSON.stringify(err));
    this.message = 'An error occurred while opening the file.';
  }
}

  private createTestFile(filePath: string) {
    try {
      let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
      fs.writeSync(file.fd, 'This is the content of test file！\nCreate Time: ' + new Date().toLocaleString());
      fs.closeSync(file);
      this.message = 'create file success！Click [Open file]';
      hilog.info(DOMAIN, TAG, 'Test file created successfully');
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to create test file: ' + JSON.stringify(err));
      this.message = 'Failed to create the test file';
    }
  }
}