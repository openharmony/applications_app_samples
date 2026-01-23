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

// [Start create_float_window]
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0X0000;
const TAG: string = '[Sample_CreatFloatWindow]';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    // 1.创建悬浮窗。
    let windowClass: window.Window | null = null;
    let config: window.Configuration = {
      name: 'floatWindow', windowType: window.WindowType.TYPE_FLOAT, ctx: this.context
    };
    window.createWindow(config, (err: BusinessError, data) => {
      let errCode: number = err.code;
      if (errCode) {
        hilog.error(DOMAIN, TAG, `Failed to create the floatWindow. Cause: ${JSON.stringify(err)}`);
        return;
      }
      hilog.info(DOMAIN, TAG, `Succeeded in creating the floatWindow. Data: ${JSON.stringify(data)}`);
      windowClass = data;
      // 2.悬浮窗窗口创建成功后，设置悬浮窗的位置、大小及相关属性等。
      windowClass.moveWindowTo(300, 300, (err: BusinessError) => {
        let errCode: number = err.code;
        if (errCode) {
          hilog.error(DOMAIN, TAG, `Failed to move the window. Cause: ${JSON.stringify(err)}`);
          return;
        }
        hilog.info(DOMAIN, TAG, `Succeeded in moving the window.`);
      });
      windowClass.resize(500, 500, (err: BusinessError) => {
        let errCode: number = err.code;
        if (errCode) {
          hilog.error(DOMAIN, TAG, `Failed to change the window size. Cause: ${JSON.stringify(err)}`);
          return;
        }
        hilog.info(DOMAIN, TAG, `Succeeded in changing the window size.`);
      });
      // 3.为悬浮窗加载对应的目标页面。
      windowClass.setUIContent('pages/Index', (err: BusinessError) => {
        let errCode: number = err.code;
        if (errCode) {
          hilog.error(DOMAIN, TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
          return;
        }
        hilog.info(DOMAIN, TAG, `Succeeded in loading the content.`);
        // 3.显示悬浮窗。
        (windowClass as window.Window).showWindow((err: BusinessError) => {
          let errCode: number = err.code;
          if (errCode) {
            hilog.error(DOMAIN, TAG, `Failed to show the window. Cause: ${JSON.stringify(err)}`);
            return;
          }
          hilog.info(DOMAIN, TAG, `Succeeded in showing the window.`);
        });
      });
      // 4.销毁悬浮窗。当不再需要悬浮窗时，可根据具体实现逻辑，使用destroy对其进行销毁。
    });
  }
};
// [End create_float_window]