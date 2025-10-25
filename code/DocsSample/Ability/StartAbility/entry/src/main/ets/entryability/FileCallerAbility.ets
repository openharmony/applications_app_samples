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
// [Start file_caller_ability_import]
import { fileUri } from '@kit.CoreFileKit';
import { UIAbility, Want, wantConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
// [End file_caller_ability_import]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'ExpressAbility';
const DOMAIN = 0x0000;

// [Start file_caller_ability_start]
// [Start file_caller_ability_create_request]
// [Start file_caller_ability_get_url]
export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    // 获取文件沙箱路径
    let filePath = this.context.filesDir + '/test.txt';
    // 将沙箱路径转换为uri
    let uri = fileUri.getUriFromPath(filePath);
    // 获取的uri为"file://com.example.demo/data/storage/el2/base/files/test.txt"
    // [StartExclude file_caller_ability_get_url]
    // 构造请求数据
    let want: Want = {
      action: 'ohos.want.action.viewData', // 表示查看数据的操作，文件打开场景固定为此值
      uri: uri,
      type: 'general.plain-text', // 表示待打开文件的类型
      // 配置被分享文件的读写权限，例如对文件打开应用进行读写授权
      flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION
    };
    // [StartExclude file_caller_ability_create_request]
    // 调用接口启动
    this.context.startAbility(want)
      .then(() => {
        hilog.info(DOMAIN, TAG, 'Succeed to invoke startAbility.');
      })
      .catch((err: BusinessError) => {
        hilog.error(DOMAIN, TAG, `Failed to invoke startAbility, code: ${err.code}, message: ${err.message}`);
      });
    // [EndExclude file_caller_ability_create_request]
    // [EndExclude file_caller_ability_get_url]
  }
}
// [End file_caller_ability_get_url]
// [End file_caller_ability_create_request]
// [End file_caller_ability_start]