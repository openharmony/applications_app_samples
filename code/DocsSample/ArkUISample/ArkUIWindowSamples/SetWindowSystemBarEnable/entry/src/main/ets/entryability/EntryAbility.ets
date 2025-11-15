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

// [Start set_window_system_bar_enable]
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const DOMAIN = 0X0000;
const TAG: string = '[Sample_SetWindowSystemBarEnable]';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    // 1.获取应用主窗口。
    let windowClass: window.Window | null = null;
    windowStage.getMainWindow((err: BusinessError, data) => {
      let errCode: number = err.code;
      if (errCode) {
        hilog.error(DOMAIN, TAG, `Failed to obtain the main window. Cause: ${JSON.stringify(err)}`);
        return;
      }
      windowClass = data;
      hilog.info(DOMAIN, TAG, `Succeeded in obtaining the main window. Data: ${JSON.stringify(data)}`);

      // 2.实现沉浸式效果。方式一：设置导航栏、状态栏不显示。
      let names: 'status'[] | 'navigation'[] = [];
      windowClass.setWindowSystemBarEnable(names)
        .then(() => {
          hilog.info(DOMAIN, TAG, `Succeeded in setting the system bar to be visible.`);
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, TAG, `Failed to set the system bar to be visible. Cause: ${JSON.stringify(err)}`);
        });
      // 2.实现沉浸式效果。方式二：设置窗口为全屏布局，配合设置导航栏、状态栏的透明度、背景/文字颜色及高亮图标等属性，与主窗口显示保持协调一致。
      let isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen)
        .then(() => {
          hilog.info(DOMAIN, TAG, `Succeeded in setting the window layout to full-screen mode.`);
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, TAG, `Failed to set the window layout to full-screen mode. Cause: ${JSON.stringify(err)}`);
        });
      let sysBarProps: window.SystemBarProperties = {
        statusBarColor: '#ff00ff',
        navigationBarColor: '#00ff00',
        // 以下两个属性从API Version 8开始支持
        statusBarContentColor: '#ffffff',
        navigationBarContentColor: '#ffffff'
      };
      windowClass.setWindowSystemBarProperties(sysBarProps)
        .then(() => {
          hilog.info(DOMAIN, TAG, `Succeeded in setting the system bar properties.`);
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, TAG, `Failed to set the system bar properties. Cause: ${JSON.stringify(err)}`);
        });
    })
    // 3.为沉浸式窗口加载对应的目标页面。
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
// [End set_window_system_bar_enable]
