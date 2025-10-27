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

// [Start create_main_window]
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const DOMAIN = 0X0000;
const TAG : string = '[Sample_CCreatMainWindow]';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    // 1.获取应用主窗口。
    let windowClass: window.Window | null = null;
    windowStage.getMainWindow((err: BusinessError, data) => {
      let errCode: number = err.code;
      if (errCode) {
        hilog.error(DOMAIN, TAG, `Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      windowClass = data;
      hilog.info(DOMAIN, TAG, `Succeeded in obtaining the main window. Result:${data}`);
      // 2.设置主窗口属性。以设置"是否可触"属性为例。
      let isTouchable: boolean = true;
      windowClass.setWindowTouchable(isTouchable, (err: BusinessError) => {
        let errCode: number = err.code;
        if (errCode) {
          hilog.error(DOMAIN, TAG, `Failed to set the window to be touchable. Cause: ${JSON.stringify(err)}`);
          return;
        }
        hilog.info(DOMAIN, TAG, `Succeeded in setting the window to be touchable.`);
      })
    })
    // 3.为主窗口加载对应的目标页面。
    windowStage.loadContent('pages/Index', (err: BusinessError) => {
      let errCode: number = err.code;
      if (errCode) {
        hilog.error(DOMAIN, TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      hilog.info(DOMAIN, TAG, `Succeeded in loading the content.`);
    });
  }
};
// [End create_main_window]