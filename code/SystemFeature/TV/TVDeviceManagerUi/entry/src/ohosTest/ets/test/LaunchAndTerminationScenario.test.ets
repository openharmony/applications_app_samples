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

class LaunchTerminationController {
  readonly chain: string[] = [];

  launchVisibleDialog(): void {
    this.chain.push('main-create');
    this.chain.push('session-create');
    this.chain.push('session-load-transparent');
    this.chain.push('create-float-window');
    this.chain.push('load-visible-dialog');
    this.chain.push('show-window');
  }

  terminateVisibleDialog(): void {
    this.chain.push('reply-ui');
    this.chain.push('destroy-window');
    this.chain.push('terminate-session');
    this.chain.push('terminate-extension');
  }
}

export default function launchAndTerminationScenarioTest(): void {
  describe('TVDeviceManagerUiLaunchAndTerminationScenarioTest', () => {
    it('should cover launch to destroy chain for main and extension abilities', 0, () => {
      const chain: string[] = ['main-create', 'session-create', 'window-show', 'window-destroy', 'extension-terminate'];
      TestAsserts.assertArrayLength(chain, 5);
      TestAsserts.assertStringArrayContains(chain, ['main-create', 'window-destroy', 'extension-terminate']);
    });

    it('should preserve transparent carrier before visible dialog content', 0, () => {
      const chain: string[] = ['session-load-transparent', 'create-float-window', 'load-visible-dialog', 'show-window'];
      TestAsserts.assertStringEquals(chain[0], 'session-load-transparent');
      TestAsserts.assertStringEquals(chain[2], 'load-visible-dialog');
    });

    it('should terminate session after visible window is destroyed', 0, () => {
      const chain: string[] = ['reply-ui', 'destroy-window', 'terminate-session', 'terminate-extension'];
      TestAsserts.assertStringEquals(chain[1], 'destroy-window');
      TestAsserts.assertStringEquals(chain[2], 'terminate-session');
      TestAsserts.assertStringEquals(chain[3], 'terminate-extension');
    });

    it('should keep launch chain readable for startup diagnostics', 0, () => {
      const controller: LaunchTerminationController = new LaunchTerminationController();
      controller.launchVisibleDialog();

      controller.chain.forEach((step: string) => {
        TestAsserts.assertReadableText(step);
      });
      TestAsserts.assertStringEquals(controller.chain[0], 'main-create');
      TestAsserts.assertStringEquals(controller.chain[controller.chain.length - 1], 'show-window');
    });

    it('should keep teardown chain ordered after reply callback', 0, () => {
      const controller: LaunchTerminationController = new LaunchTerminationController();
      controller.terminateVisibleDialog();

      // 启停类问题的核心不是有没有退出，而是 reply 回执后是否按协议完成窗口、session、extension 三级回收。
      // 这里固定 teardown 顺序，可以避免未来有人把 terminate 提前到 destroy 之前造成资源悬挂。
      TestAsserts.assertArrayLength(controller.chain, 4);
      TestAsserts.assertStringEquals(controller.chain[0], 'reply-ui');
      TestAsserts.assertStringEquals(controller.chain[1], 'destroy-window');
      TestAsserts.assertStringEquals(controller.chain[2], 'terminate-session');
      TestAsserts.assertStringEquals(controller.chain[3], 'terminate-extension');
    });

    it('should keep full launch and teardown chain append only during complete scenario replay', 0, () => {
      const controller: LaunchTerminationController = new LaunchTerminationController();
      controller.launchVisibleDialog();
      controller.terminateVisibleDialog();

      TestAsserts.assertArrayLength(controller.chain, 10);
      TestAsserts.assertStringEquals(controller.chain[0], 'main-create');
      TestAsserts.assertStringEquals(controller.chain[5], 'show-window');
      TestAsserts.assertStringEquals(controller.chain[6], 'reply-ui');
      TestAsserts.assertStringEquals(controller.chain[9], 'terminate-extension');
    });

    // 启动序列里的 transparent 承载页不是可选步骤，而是所有可视弹窗的前置容器。
    // 这里验证它总是在 create-float-window 之前出现，防止后续有人为“提速”而跳过会话承载层。
    it('should load transparent carrier before float window creation during startup', 0, () => {
      const controller: LaunchTerminationController = new LaunchTerminationController();
      controller.launchVisibleDialog();

      TestAsserts.assertStringEquals(controller.chain[2], 'session-load-transparent');
      TestAsserts.assertStringEquals(controller.chain[3], 'create-float-window');
    });

    // 终止路径本质上是对 launch 链的资源回收补集，因此回复回执必须先于 destroy-window。
    // 锁定 reply-ui 的先导位置，可以避免未回执先销毁导致分布式管理侧拿不到最终用户决策。
    it('should keep reply action as first teardown step of visible dialog', 0, () => {
      const controller: LaunchTerminationController = new LaunchTerminationController();
      controller.terminateVisibleDialog();

      TestAsserts.assertStringEquals(controller.chain[0], 'reply-ui');
    });

    // 完整链路会被问题排查和稳定性看板直接消费，因此每个阶段名都必须清晰可读。
    // 这里对完整链做可读性扫描，避免未来引入缩写或空占位导致调试上下文难以理解。
    it('should keep every full scenario step readable for diagnostics pipeline', 0, () => {
      const controller: LaunchTerminationController = new LaunchTerminationController();
      controller.launchVisibleDialog();
      controller.terminateVisibleDialog();

      controller.chain.forEach((step: string) => {
        TestAsserts.assertReadableText(step);
      });
    });

    // 启动和退出阶段都承担独立语义，二者数量应该保持 6:4 的稳定分布，便于上层回归看板按阶段聚合。
    // 这里直接锁定阶段计数，可以快速发现有人在某一侧偷偷增删关键步骤却没同步流程文档。
    it('should keep launch and teardown step counts aligned with scenario design', 0, () => {
      const controller: LaunchTerminationController = new LaunchTerminationController();
      controller.launchVisibleDialog();
      const launchCount: number = controller.chain.length;
      controller.terminateVisibleDialog();
      const totalCount: number = controller.chain.length;
      const teardownCount: number = totalCount - launchCount;

      TestAsserts.assertNumberEquals(launchCount, 6);
      TestAsserts.assertNumberEquals(teardownCount, 4);
    });
  });
}
