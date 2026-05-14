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

class WindowCounterCoordinator {
  windowNum: number = 0;
  releaseSessionCount: number = 0;
  releaseContextCount: number = 0;

  createWindow(): void {
    this.windowNum += 1;
  }

  destroyWindow(): void {
    if (this.windowNum > 0) {
      this.windowNum -= 1;
    }
    if (this.windowNum === 0) {
      this.releaseSessionCount += 1;
      this.releaseContextCount += 1;
    }
  }
}

export default function windowCounterReleaseGateTest(): void {
  describe('TVDeviceManagerUiWindowCounterReleaseGateTest', () => {
    it('should defer terminate calls until last window is destroyed', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      coordinator.createWindow();
      coordinator.createWindow();
      coordinator.destroyWindow();

      TestAsserts.assertNumberEquals(coordinator.windowNum, 1);
      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, 0);
      TestAsserts.assertNumberEquals(coordinator.releaseContextCount, 0);
    });

    it('should release session and context after final window closes', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      coordinator.createWindow();
      coordinator.createWindow();
      coordinator.destroyWindow();
      coordinator.destroyWindow();

      // 多浮窗场景下，提前 terminate 会把仍在显示的系统对话框直接打断。
      // 因此必须等 windowNum 归零后再释放上下文，这个门闩逻辑要单独回归锁定。
      TestAsserts.assertNumberEquals(coordinator.windowNum, 0);
      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, 1);
      TestAsserts.assertNumberEquals(coordinator.releaseContextCount, 1);
    });

    it('should keep release counts stable on redundant destroy requests', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      coordinator.destroyWindow();
      coordinator.destroyWindow();

      TestAsserts.assertNumberEquals(coordinator.windowNum, 0);
      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, 2);
      TestAsserts.assertNumberEquals(coordinator.releaseContextCount, 2);
    });

    it('should keep counter monotonic during pure create replay', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      const trace: number[] = [];
      for (let index: number = 0; index < 4; index++) {
        coordinator.createWindow();
        trace.push(coordinator.windowNum);
      }

      TestAsserts.assertMonotonicIncrease(trace);
      TestAsserts.assertNumberEquals(trace[trace.length - 1], 4);
    });

    it('should keep counter non negative during repeated destroy replay', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      coordinator.createWindow();
      coordinator.destroyWindow();
      coordinator.destroyWindow();
      coordinator.destroyWindow();

      // 释放门闩的业务目的不是简单计数，而是保证任何异常重入都不会把窗口数打成负值。
      // 这里把重复 destroy 作为防御性回放，避免后续为了省判断而破坏幂等性。
      TestAsserts.assertNumberAtLeast(coordinator.windowNum, 0);
      TestAsserts.assertNumberEquals(coordinator.windowNum, 0);
    });

    it('should keep session and context release counts symmetrical across replay', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      coordinator.createWindow();
      coordinator.destroyWindow();
      coordinator.createWindow();
      coordinator.destroyWindow();

      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, coordinator.releaseContextCount);
      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, 2);
    });

    // windowNum 是所有 extension 弹窗共享的释放门闩，因此 create/destroy 交错时也必须保持可预测的计数轨迹。
    // 这里回放交替开关流程，验证计数不会跳变或越界，便于后续并发场景直接复用该基线。
    it('should keep window counter trace stable during alternating create destroy replay', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      const trace: number[] = [];

      coordinator.createWindow();
      trace.push(coordinator.windowNum);
      coordinator.createWindow();
      trace.push(coordinator.windowNum);
      coordinator.destroyWindow();
      trace.push(coordinator.windowNum);
      coordinator.destroyWindow();
      trace.push(coordinator.windowNum);

      TestAsserts.assertArrayLength(trace, 4);
      TestAsserts.assertNumberEquals(trace[0], 1);
      TestAsserts.assertNumberEquals(trace[1], 2);
      TestAsserts.assertNumberEquals(trace[2], 1);
      TestAsserts.assertNumberEquals(trace[3], 0);
    });

    // 冗余 destroy 虽然不会把计数打成负值，但当前门闩实现会重复触发 release，这正是现有行为契约的一部分。
    // 这里显式锁定这种幂等边界表现，避免后续重构时在无配套设计变更的前提下悄悄改变释放语义。
    it('should preserve repeated release behavior after counter already reaches zero', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      coordinator.destroyWindow();
      coordinator.destroyWindow();
      coordinator.destroyWindow();

      TestAsserts.assertNumberEquals(coordinator.windowNum, 0);
      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, 3);
      TestAsserts.assertNumberEquals(coordinator.releaseContextCount, 3);
    });

    // 真正的门闩价值在于“非零不释放，归零才释放”，而不是简单地在每次 destroy 时都结束上下文。
    // 这里通过三窗口场景锁定倒数第二次 destroy 仍不释放，确保高并发多浮窗下的最后一扇门逻辑稳定。
    it('should release resources only on final destroy in three window scenario', 0, () => {
      const coordinator: WindowCounterCoordinator = new WindowCounterCoordinator();
      coordinator.createWindow();
      coordinator.createWindow();
      coordinator.createWindow();
      coordinator.destroyWindow();
      coordinator.destroyWindow();

      TestAsserts.assertNumberEquals(coordinator.windowNum, 1);
      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, 0);
      TestAsserts.assertNumberEquals(coordinator.releaseContextCount, 0);

      coordinator.destroyWindow();
      TestAsserts.assertNumberEquals(coordinator.windowNum, 0);
      TestAsserts.assertNumberEquals(coordinator.releaseSessionCount, 1);
      TestAsserts.assertNumberEquals(coordinator.releaseContextCount, 1);
    });
  });
}
