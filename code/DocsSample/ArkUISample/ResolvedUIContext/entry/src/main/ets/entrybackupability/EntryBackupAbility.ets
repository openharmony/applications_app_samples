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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryBackupAbility extends BackupExtensionAbility {
  async onBackup() {
    hilog.info(DOMAIN, 'testTag', 'onBackup ok');
    await Promise.resolve();
  }

  async onRestore(bundleVersion: BundleVersion) {
    hilog.info(DOMAIN, 'testTag', 'onRestore ok %{public}s', JSON.stringify(bundleVersion));
    await Promise.resolve();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // 在loadContent前调用，此时无UI实例，vp2px会根据屏幕默认像素密度返回计算结果。
    let pxValue = vp2px(20);
    hilog.info(DOMAIN, 'testTag', `20vp equals to ${pxValue}px`);
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      // 在loadContent异步回调中调用，此时有UI实例，但上下文不明确，此时会根据主窗的像素密度返回计算结果。
      let pxValue = vp2px(20);
      hilog.info(DOMAIN, 'testTag', `20vp equals to ${pxValue}px`);
    });
    // loadContent是异步接口，在此处调用不能保证UI实例已经创建成功。
    pxValue = vp2px(20);
    hilog.info(DOMAIN, 'testTag', `20vp equals to ${pxValue}px`);
  }
}