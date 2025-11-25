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

// [Start onCreate]
// [Start onWindowStageCreate]
// [Start onForeground]
// [Start onBackground]
// [Start onWindowStageWillDestroy]
// [Start onWindowStageDestroy]
// [Start onDestroy]
// [Start onNewWant]
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
// [StartExclude onCreate]
// [StartExclude onForeground]
// [StartExclude onBackground]
// [StartExclude onDestroy]
// [StartExclude onNewWant]
import { window } from '@kit.ArkUI';
// [StartExclude onWindowStageDestroy]
import { hilog } from '@kit.PerformanceAnalysisKit';
// [StartExclude onWindowStageCreate]
import { BusinessError } from '@kit.BasicServicesKit';
// [EndExclude onWindowStageCreate]

const DOMAIN = 0x0000;
// [EndExclude onWindowStageDestroy]
// [EndExclude onNewWant]
// [EndExclude onDestroy]
// [EndExclude onBackground]
// [EndExclude onForeground]
// [EndExclude onCreate]

export default class EntryAbility extends UIAbility {
  // [StartExclude onNewWant]
  // [StartExclude onBackground]
  // [StartExclude onForeground]
  // [StartExclude onWindowStageDestroy]
  // [StartExclude onWindowStageCreate]
  // [StartExclude onDestroy]
  // [StartExclude onCreate]
  public windowStage: window.WindowStage | undefined = undefined;
  // [EndExclude onCreate]

  // [StartExclude onWindowStageWillDestroy]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 执行UIAbility整个生命周期中仅发生一次的业务逻辑
  }
  // [EndExclude onDestroy]

  // [StartExclude onCreate]
  onDestroy(): void {
    // 系统资源的释放、数据的保存等
  }
  // [EndExclude onWindowStageWillDestroy]
  // [EndExclude onWindowStageCreate]
  // [EndExclude onWindowStageDestroy]

  // [StartExclude onDestroy]
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // [StartExclude onWindowStageCreate]
    // 加载UI资源
    // [EndExclude onWindowStageCreate]

    // [StartExclude onWindowStageDestroy]
    // [StartExclude onWindowStageCreate]
    this.windowStage = windowStage;
    // [EndExclude onWindowStageCreate]
    // [StartExclude onWindowStageWillDestroy]
    // 设置WindowStage的事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
    try {
      windowStage.on('windowStageEvent', (data) => {
        let stageEventType: window.WindowStageEventType = data;
        switch (stageEventType) {
          case window.WindowStageEventType.SHOWN: // 切到前台
            hilog.info(DOMAIN, 'testTag', `windowStage foreground.`);
            break;
          case window.WindowStageEventType.ACTIVE: // 获焦状态
            hilog.info(DOMAIN, 'testTag', `windowStage active.`);
            break;
          case window.WindowStageEventType.INACTIVE: // 失焦状态
            hilog.info(DOMAIN, 'testTag', `windowStage inactive.`);
            break;
          case window.WindowStageEventType.HIDDEN: // 切到后台
            hilog.info(DOMAIN, 'testTag', `windowStage background.`);
            break;
          case window.WindowStageEventType.RESUMED: // 前台可交互状态
            hilog.info(DOMAIN, 'testTag', `windowStage resumed.`);
            break;
          case window.WindowStageEventType.PAUSED: // 前台不可交互状态
            hilog.info(DOMAIN, 'testTag', `windowStage paused.`);
            break;
          default:
            break;
        }
      });
    } catch (exception) {
      hilog.error(DOMAIN, 'testTag',
        `Failed to enable the listener for window stage event changes. Cause: ${JSON.stringify(exception)}`);
    }
    hilog.info(DOMAIN, 'testTag', `%{public}s`, `Ability onWindowStageCreate`);
    // 设置UI加载
    windowStage.loadContent('pages/Index', (err) => {
      // [StartExclude onWindowStageCreate]
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
      // [EndExclude onWindowStageCreate]
    });
    // [EndExclude onWindowStageWillDestroy]
    // [EndExclude onWindowStageDestroy]
  }

  // [StartExclude onWindowStageCreate]
  // [StartExclude onWindowStageDestroy]
  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    // 释放通过windowStage对象获取的资源
    // 在onWindowStageWillDestroy()中注销WindowStage事件订阅（获焦/失焦、切到前台/切到后台、前台可交互/前台不可交互）
    try {
      if (this.windowStage) {
        this.windowStage.off('windowStageEvent');
      }
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(DOMAIN, 'testTag', `Failed to disable the listener for windowStageEvent. Code is ${code}, message is ${message}`);
    }
  }
  // [EndExclude onWindowStageDestroy]

  // [StartExclude onWindowStageWillDestroy]
  onWindowStageDestroy(): void {
    // 释放UI资源
  }
  // [EndExclude onForeground]

  // [StartExclude onWindowStageDestroy]
  onForeground(): void {
    // 申请系统需要的资源，或者重新申请在onBackground()中释放的资源
  }
  // [EndExclude onBackground]

  // [StartExclude onForeground]
  onBackground(): void {
    // 释放UI不可见时无用的资源
  }
  // [EndExclude onNewWant]

  // [StartExclude onBackground]
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 更新资源、数据
  }
  // [EndExclude onBackground]
  // [EndExclude onForeground]
  // [EndExclude onWindowStageDestroy]
  // [EndExclude onWindowStageWillDestroy]
  // [EndExclude onWindowStageCreate]
  // [EndExclude onDestroy]
  // [EndExclude onCreate]
}
// [End onNewWant]
// [End onDestroy]
// [End onWindowStageDestroy]
// [End onWindowStageWillDestroy]
// [End onBackground]
// [End onForeground]
// [End onWindowStageCreate]
// [End onCreate]