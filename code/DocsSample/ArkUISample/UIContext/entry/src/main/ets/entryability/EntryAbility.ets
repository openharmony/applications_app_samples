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

// [Start Common_UIContext]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { ContextUtils } from '../Common/ContextUtils';
import { WindowUIContextUtils } from '../Common/WindowUtils';
import { PixelUtils } from '../Common/UIContext';

const DOMAIN = 0x0000;

// [Start Common_setContext]
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN,'testTag','%{public}s', 'Ability onCreate');
    // [Start Common_pxValue]
    let pxValue = PixelUtils.vp2px(20);
    hilog.info(DOMAIN,'testTag',`20vp equals to ${pxValue}px`);
    // [End Common_pxValue]
    ContextUtils.setContext(this.context);
    hilog.info(DOMAIN,'testTag','%{public}s', 'setContext success');
    // [Start Common_getContext]
    let context = ContextUtils.getContext();
    hilog.info(DOMAIN,'testTag',`The context is ${context}`);
    // [End Common_getContext]
  }
  // [End Common_setContext]

  //[StartExclude Common_UIContext]
  onDestroy(): void {
    hilog.info(DOMAIN,'testTag','%{public}s', 'Ability onDestroy');
  }

  // [EndExclude Common_UIContext]

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN,'testTag','%{public}s', 'Ability onWindowStageCreate');
    // [Start Common_LocalStorage]
    let localStorage = new LocalStorage();
    localStorage.setOrCreate('message', 'Message from Storage')
    // [End Common_LocalStorage]
    hilog.info(DOMAIN,'testTag','%{public}s', 'success localStorage');
    // [Start Common_GetMainWindowSync]
    let window = windowStage.getMainWindowSync();
    // [Start Common_RegisterWindowCallback]
    WindowUIContextUtils.registerWindowCallback(window);
    windowStage.loadContent('pages/Index', localStorage, (err) => {
      if (err.code) {
        hilog.error(DOMAIN,'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      try {
        let uiContext = window.getUIContext();
        // [Start Common_SetUIContext]
        PixelUtils.setUIContext(uiContext);
        // [End Common_SetUIContext]
        WindowUIContextUtils.setActiveUIContext(uiContext)
        if (!uiContext) {
          hilog.error(DOMAIN,'testTag', `Can't get UIContext`);
          return;
        }
        let pxValue = uiContext.vp2px(20);
        hilog.info(DOMAIN,'testTag',`20vp equals to ${pxValue}px`);
      } catch (e) {
        hilog.error(DOMAIN,'testTag', `Can't get UIContext, ${e}`);
      }
      // [End Common_GetMainWindowSync]
      hilog.info(DOMAIN,'testTag',`loadContent success.`);
    });
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage) {
    let window = windowStage.getMainWindowSync();
    hilog.info(DOMAIN,'testTag','%{public}s', `The main window: ${window}`);
    // 注销主窗的回调。
    WindowUIContextUtils.unregisterWindowCallback(window);
  }
  // [End Common_RegisterWindowCallback]

  //[StartExclude Common_UIContext]
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN,'testTag','%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN,'testTag','%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN,'testTag','%{public}s', 'Ability onBackground');
  }
  // [EndExclude Common_UIContext]
}
// [End Common_UIContext]
