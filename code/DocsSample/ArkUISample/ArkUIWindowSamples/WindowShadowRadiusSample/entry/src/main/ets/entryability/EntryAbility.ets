/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { AbilityConstant, ConfigurationConstant, UIAbility, Want, common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

const DOMAIN = 0x0000;
let windowStage_: window.WindowStage | null = null;
let floatWindowObj: window.Window | null = null;

export default class EntryAbility extends UIAbility {
  async  showFloatWindow() {
    // 1.创建全局悬浮窗。
    if (windowStage_ == null) {
      console.error('Failed to create the floatWindow. Cause: windowStage_ is null');
    } else {
      let config: window.Configuration = {
        name: 'floatWindow',
        windowType: window.WindowType.TYPE_FLOAT,
        ctx: this.context
      };
      try {
        // 创建系统窗口
        let windowObj: window.Window = await window.createWindow(config);
        floatWindowObj = windowObj;
        AppStorage.setOrCreate('floatWindow', windowObj);
        await windowObj.setUIContent('pages/Page1');
        await windowObj.moveWindowTo(230, 600);
        await windowObj.resize(800, 1000);
        windowObj.showWindow();
      } catch (err) {
        console.error('创建窗口失败: ' + JSON.stringify(err));
      }
    }
  }

  destroyFloatWindow() {
    if (!floatWindowObj) {
      console.error('floatWindowObj is null');
      return;
    }
    // 4.销毁全局悬浮窗。当不再需要全局悬浮窗时，可根据具体实现逻辑，使用destroy对其进行销毁。
    floatWindowObj.destroyWindow((err: BusinessError) => {
      let errCode: number = err.code;
      if (errCode) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
    windowStage_ = windowStage;
    // 开发者可以在适当的时机，如主窗口上按钮点击事件等，创建全局悬浮窗。并不一定需要在onWindowStageCreate调用，这里仅作展示
    this.showFloatWindow();
  }
}
