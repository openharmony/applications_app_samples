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
// [Start file_ability]
import fs from '@ohos.file.fs';
import { Want, AbilityConstant, UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'FileHandlerAbility';
const DOMAIN = 0x0000;

export default class FileHandlerAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 从want信息中获取uri字段
    let uri = want.uri;
    if (uri == null || uri == undefined) {
      hilog.info(DOMAIN, TAG, 'uri is invalid');
      return;
    }
    try {
      // 根据待打开文件的URI进行相应操作。例如同步读写的方式打开URI获取file对象
      let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      hilog.info(DOMAIN, TAG, 'Succeed to open file.');
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      hilog.error(DOMAIN, TAG, `Failed to open file openSync, code: ${error.code}, message: ${error.message}`);
    }
  }
}
// [End file_ability]