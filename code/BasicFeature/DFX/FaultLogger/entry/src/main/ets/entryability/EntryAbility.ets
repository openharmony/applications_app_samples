/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import UIAbility from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import { hiAppEvent } from '@kit.PerformanceAnalysisKit';
import PreferencesManager from '../common/PreferencesManager';
import Logger from '../model/Logger';

const TAG = '[Entry]';
const DIVIDER: string = '\n---------------------------------------------------\n';
let crashMsg: string = 'No exception log was obtained';
let freezeMsg: string = 'No exception log was obtained';
let preferencesManager: PreferencesManager | undefined = undefined;

interface CrashAppEventParamsInfo {
  time: number,
  crash_type: string,
  foreground: boolean,
  bundle_version: string,
  bundle_name: string,
  pid: number,
  uid: number,
  uuid: string,
  exception: object,
  hilog: string[],
  threads: object[],
  external_log12: string[],
  log_over_limit12: boolean
}

let crashWatcher: hiAppEvent.Watcher = {
  name: 'crashEventWatcher',
  appEventFilters: [
    {
      domain: hiAppEvent.domain.OS,
      names: [hiAppEvent.event.APP_CRASH]
    }
  ],
  onReceive: (domain: string, appEventGroups: Array<hiAppEvent.AppEventGroup>) => {
    Logger.info(TAG, `HiAppEvent onReceive: appEventGroups=${domain}, appEventGroups len=${appEventGroups.length}`);
    for (const eventGroup of appEventGroups) {
      Logger.info(TAG, `HiAppEvent eventName=${eventGroup.name}`);
      let len = eventGroup.appEventInfos.length;
      Logger.info(TAG, `HiAppEvent eventGroup len=${len}`);
      if (len !== 0) {
        crashMsg = `faultLogger num:${len}`;
        for (let i = 0; i < len; i++) {
          let crashInfo =  eventGroup.appEventInfos[i].params as CrashAppEventParamsInfo;
          crashMsg += `${DIVIDER}Log pid: ${crashInfo.pid}\nLog type:${crashInfo.crash_type}\n`+
            `Log module: ${crashInfo.bundle_name}\n` +
            `Log reason: ${JSON.stringify(crashInfo.exception).substring(0, 200)}\n` +
            `Log text:\n ${crashInfo.hilog.join('\n').substring(0, 800)}`;
        }
        preferencesManager?.putFaultMessage('crashMsg', crashMsg);
      }
    }
  }
};

let freezeWatcher: hiAppEvent.Watcher = {
  name: 'freezeEventWatcher',
  appEventFilters: [
    {
      domain: hiAppEvent.domain.OS,
      names: [hiAppEvent.event.APP_FREEZE]
    }
  ],
  onReceive: (domain: string, appEventGroups: Array<hiAppEvent.AppEventGroup>) => {
    Logger.info(TAG, `HiAppEvent onReceive: appEventGroups=${domain}, appEventGroups len=${appEventGroups.length}`);

    for (const eventGroup of appEventGroups) {
      Logger.info(TAG, `HiAppEvent eventName=${eventGroup.name}`);
      let len = eventGroup.appEventInfos.length;
      Logger.info(TAG, `HiAppEvent eventGroup len=${len}`);
      if (len !== 0) {
        freezeMsg = `faultLogger num:${len}`;
        for (let i = 0; i < len; i++) {
          let freezeInfo =  eventGroup.appEventInfos[i].params as CrashAppEventParamsInfo;
          freezeMsg += `${DIVIDER}Log pid: ${freezeInfo.pid}\nLog type:AppFreeze\n`+
            `Log module: ${freezeInfo.bundle_name}\n` +
            `Log reason: ${JSON.stringify(freezeInfo.exception).substring(0, 200)}\n` +
            `Log text:\n ${freezeInfo.hilog.join('\n').substring(0, 200)}`;
        }
        preferencesManager?.putFaultMessage('freezeMsg', freezeMsg);
      }
    }
  }
};

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'Ability onCreate');
    AppStorage.setOrCreate('context', this.context);
    preferencesManager = new PreferencesManager();
    // 添加崩溃事件观察者
    hiAppEvent.addWatcher(crashWatcher);
    // 添加卡死事件观察者
    hiAppEvent.addWatcher(freezeWatcher);
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: %{public}s, ${JSON.stringify(err) ?? ''}`);
        return;
      }
      Logger.info(TAG, `Succeeded in loading the content. Data: %{public}s, ${JSON.stringify(data) ?? ''}`);
    })
  }

  onDestroy(): void {
    // 移除崩溃事件观察者
    hiAppEvent.removeWatcher(crashWatcher);
    // 移除卡死事件观察者
    hiAppEvent.removeWatcher(freezeWatcher);
  }
}
