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
// [Start Common_registerWindowCallback]
// [Start Common_setContext]
// [Start Common_LocalStorage]
// entryability/EntryAbility.ets
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { ContextUtils } from '../Common/ContextUtils';
import { WindowUIContextUtils } from '../Common/WindowUtils';
import { PixelUtils } from '../Common/UIContext';
import { PixelUtil } from '../Common/Utils';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  // [StartExclude Common_UIContext]
  // [StartExclude Common_registerWindowCallback]
  // [StartExclude Common_LocalStorage]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // [StartExclude Common_setContext]
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    // [Start Common_pxValue]
    let pxValue = PixelUtils.vp2px(20);
    hilog.info(DOMAIN, 'testTag', `20vp equals to ${pxValue}px`);
    // [End Common_pxValue]
    // [EndExclude Common_setContext]
    ContextUtils.setContext(this.context);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'setContext success');
    // [StartExclude Common_setContext]
    // [Start Common_getContext]
    let context = ContextUtils.getContext();
    hilog.info(DOMAIN, 'testTag', `The context is ${context}`);
    // [End Common_getContext]
    // [EndExclude Common_setContext]
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }
  // [EndExclude Common_LocalStorage]
  // [EndExclude Common_registerWindowCallback]
  // [EndExclude Common_UIContext]
  // [StartExclude Common_setContext]
  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    let localStorage = new LocalStorage();
    localStorage.setOrCreate('message', 'Message from Storage')
  // [StartExclude Common_LocalStorage]
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'success localStorage');
    let window = windowStage.getMainWindowSync();
    // 注册主窗的回调。
    WindowUIContextUtils.registerWindowCallback(window);
    // 在loadContent前调用getUIContext时，UI实例未创建，存在异常。
    // [EndExclude Common_LocalStorage]
    windowStage.loadContent('pages/Index', localStorage, (err) => {
      // 需要在loadContent完成后获取UIContext。
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', `loadContent success.`);
      // [StartExclude Common_LocalStorage]
      // 需要在回调中调用。
      try {
        let uiContext = window.getUIContext();
        PixelUtils.setUIContext(uiContext);
        // 主窗获焦可能早于loadContent完成，需要在成功后设置保证有效。
        WindowUIContextUtils.setActiveUIContext(uiContext)
        if (!uiContext) {
          hilog.error(DOMAIN, 'testTag', `Can't get UIContext`);
          return;
        }
        let pxValue = uiContext.vp2px(20);
        hilog.info(DOMAIN, 'testTag', `20vp equals to ${pxValue}px`);
      } catch (e) {
        hilog.error(DOMAIN, 'testTag', `Can't get UIContext, ${e}`);
      }
      // loadContent是异步接口，在此处调用不能保证UI实例已经创建成功。
      // [EndExclude Common_LocalStorage]
    });
  }

  // [StartExclude Common_LocalStorage]
  // [StartExclude Common_UIContext]
  onWindowStageWillDestroy(windowStage: window.WindowStage) {
    let window = windowStage.getMainWindowSync();
    hilog.info(DOMAIN, 'testTag', '%{public}s', `The main window: ${window}`);
    // 注销主窗的回调。
    WindowUIContextUtils.unregisterWindowCallback(window);
  }

  // [EndExclude Common_UIContext]
  // [StartExclude Common_registerWindowCallback]

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    // 在窗口销毁时需要移除失效的UIContext
    PixelUtil.removeUIContext();
  }

  // [StartExclude Common_UIContext]
  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
  // [EndExclude Common_UIContext]
  // [EndExclude Common_registerWindowCallback]
  // [EndExclude Common_LocalStorage]
  // [EndExclude Common_setContext]
}

// [End Common_LocalStorage]
// [End Common_setContext]
// [End Common_registerWindowCallback]
// [End Common_UIContext]
