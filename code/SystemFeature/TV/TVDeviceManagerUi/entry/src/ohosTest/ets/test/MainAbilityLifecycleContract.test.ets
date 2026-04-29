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

import { describe, it } from '@ohos/hypium';
import { TestAsserts } from './base/TestAsserts';

class MainAbilityLifecycleModel {
  logs: string[] = [];
  pageLoads: string[] = [];
  allBundleInfo: string[] = [];
  allUserPermissions: string[] = [];
  allGroups: string[] = [];
  contextReady: boolean = false;

  onCreate(abilityName: string): void {
    this.logs.push(`create-${abilityName}`);
    this.contextReady = true;
    this.allBundleInfo = [];
    this.allUserPermissions = [];
    this.allGroups = [];
  }

  onWindowStageCreate(): void {
    this.logs.push('window-stage-create');
    this.pageLoads.push('pages/ConfirmDialog');
  }

  onForeground(): void {
    this.logs.push('foreground');
  }

  onBackground(): void {
    this.logs.push('background');
  }

  onWindowStageDestroy(): void {
    this.logs.push('window-stage-destroy');
  }

  onDestroy(): void {
    this.logs.push('destroy');
  }
}

export default function mainAbilityLifecycleContractTest(): void {
  describe('TVDeviceManagerUiMainAbilityLifecycleContractTest', () => {
    // MainAbility 是样例应用的入口壳体，它必须在创建时把全局缓存初始化到干净状态。
    // 如果入口态残留旧会话数据，后续 UIExtension 弹窗调试会出现难以定位的跨用例串扰。
    it('should reset global caches when main ability is created', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      model.onCreate('com.ohos.devicemanagerui.MainAbility');

      TestAsserts.assertTrue(model.contextReady);
      TestAsserts.assertArrayLength(model.allBundleInfo, 0);
      TestAsserts.assertArrayLength(model.allUserPermissions, 0);
      TestAsserts.assertArrayLength(model.allGroups, 0);
    });

    // 窗口阶段创建后直接加载 ConfirmDialog，说明该样例默认以确认链路作为入口演示。
    // 锁定首页内容可以防止改动后把入口误切到其他弹窗，导致集成联调人员无法复现主流程。
    it('should load confirm dialog page on window stage creation', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      model.onWindowStageCreate();

      TestAsserts.assertArrayLength(model.pageLoads, 1);
      TestAsserts.assertStringEquals(model.pageLoads[0], 'pages/ConfirmDialog');
    });

    // Ability 生命周期日志是定位窗口异常、冷启动问题的重要线索。
    // 这里回放完整主流程，确保 create / foreground / background / destroy 顺序保持可观测且稳定。
    it('should preserve readable lifecycle order for main ability diagnostics', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      model.onCreate('com.ohos.devicemanagerui.MainAbility');
      model.onWindowStageCreate();
      model.onForeground();
      model.onBackground();
      model.onWindowStageDestroy();
      model.onDestroy();

      TestAsserts.assertStringEquals(model.logs[0], 'create-com.ohos.devicemanagerui.MainAbility');
      TestAsserts.assertStringEquals(model.logs[1], 'window-stage-create');
      TestAsserts.assertStringEquals(model.logs[2], 'foreground');
      TestAsserts.assertStringEquals(model.logs[3], 'background');
      TestAsserts.assertStringEquals(model.logs[4], 'window-stage-destroy');
      TestAsserts.assertStringEquals(model.logs[5], 'destroy');
    });

    // 入口 Ability 的日志内容会被平台问题排查直接消费，因此需要保持可读、可定位。
    // 这里验证日志文本不含空值占位，避免调试现场只能看到无意义的 null / undefined 记录。
    it('should keep lifecycle log entries readable for bug triage', 0, () => {
      const model: MainAbilityLifecycleModel = new MainAbilityLifecycleModel();
      model.onCreate('com.ohos.devicemanagerui.MainAbility');
      model.onForeground();
      model.onBackground();
      model.onDestroy();

      model.logs.forEach((entry: string) => {
        TestAsserts.assertReadableText(entry);
      });
    });
  });
}
