/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import window from '@ohos.window';
import Logger from '../utils/Logger';
import Want from '@ohos.app.ability.Want';

const TAG: string = 'EntryAbility';
let currentWindowStage = null;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want): void {
    Logger.info(TAG, 'MainAbility onCreate' + JSON.stringify(want));
    AppStorage.setOrCreate<Want>('want', want);
    PersistentStorage.persistProp('lazy_for_each', true); // 懒加载初始化
    PersistentStorage.persistProp('reusable', true); // 复用初始化
    PersistentStorage.persistProp('image_sync_load', true); // 图片同步加载初始化
    PersistentStorage.persistProp('page_layout', true); // 页面布局初始化
    PersistentStorage.persistProp('list_cached_count', true); // 列表缓存条数初始化
    AppStorage.setOrCreate('downComplete', false); // 初始化下载完成
    AppStorage.setOrCreate('downLoadStatus', 0); // 初始化下载状态
    AppStorage.setOrCreate('videoDuration', 0); // 初始化播放总时长
    AppStorage.setOrCreate('videoCurrentTime', 0); // 初始化播放当前时长
  }

  onDestroy(): void {
    Logger.info(TAG, 'MainAbility onDestroy');
  }

  onNewWant(want: Want): void {
    if (want.parameters.kindId === undefined) {
      return;
    }
    Logger.info(TAG, "onNewWant want:" + JSON.stringify(want));
    AppStorage.setOrCreate('want', want);
    if (currentWindowStage != null) {
      this.onWindowStageCreate(currentWindowStage);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(TAG, 'MainAbility onWindowStageCreate');

    if (currentWindowStage === null) {
      currentWindowStage = windowStage;
    }
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(TAG, `Succeeded in loading the content. Data:  ${JSON.stringify(data)}`);
    });

    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to obtain the main window.Cause: ${JSON.stringify(err)}`)
        return;
      }
      let windowClass = null;
      windowClass = data;
      // 设置监听键盘变化，用来设置inputView避让输入法
      try {
        windowClass.on('keyboardHeightChange', (data) => {
          Logger.info(TAG, `keyboardHeightChange.Data: ${JSON.stringify(data)}`)
          AppStorage.setOrCreate('keyboardHeight', data)
        })
      } catch (exception) {
        Logger.error(TAG, `Failed to enable the listener for keyboard height changes.Cause: ${JSON.stringify(exception)}`)
      }
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, `MainAbility onWindowStageDestroy`);
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, `MainAbility onForeground`);
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, `MainAbility onBackground`);
  }
}