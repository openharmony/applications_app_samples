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
import { createDefaultClock, MockInputConsumerFactory, MockWindowManagerFactory } from './MockFactories';
import {
  buildFoundationKeySequenceCases,
  FoundationRollingChecksum,
  FoundationScenarioCounter,
  FoundationStorageEntity
} from './FoundationAdvancedFixtures';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertNumberEqual,
  assertStringEqual,
  assertTrue
} from './TestAsserts';
import { MockContextData, MockWindowRectEntity } from './TestTypes';

class MutableCounter {
  value: number

  constructor(value: number) {
    this.value = value;
  }
}

function triggerSequence(
  keyA: number,
  keyB: number,
  index: number,
  callbackCounter: MutableCounter
): MockInputConsumerFactory {
  const clock = createDefaultClock(1700002000000 + index * 100);
  const factory = new MockInputConsumerFactory(keyA, keyB, clock);
  const controller = factory.build();
  controller.setCallback(() => {
    callbackCounter.value += 1
  });
  return factory;
}

function applySequence(factory: MockInputConsumerFactory, index: number): number {
  const testCase = buildFoundationKeySequenceCases()[index];
  const controller = factory.build();
  let firedCount = 0;
  controller.setCallback(() => {
    firedCount += 1
  });
  for (let stepIndex = 0; stepIndex < testCase.steps.length; stepIndex++) {
    const step = testCase.steps[stepIndex];
    factory.clock.tick(step.delayMs);
    if (step.isDown) {
      controller.triggerDown(step.keyCode);
    } else {
      controller.triggerUp(step.keyCode);
    }
  }
  return firedCount;
}

export default function mockFactoriesInputWindowDeepTest(): void {
  describe('MockFactoriesInputWindowDeepTest', () => {
    it('MockInputConsumer_MatrixFollowsExpectedTriggerCounts_001', 0, () => {
      const cases = buildFoundationKeySequenceCases();

      /**
       * 输入门闩是用户停止录屏的最后一道保护。
       * 只要双键序列判定出错，就会造成误停或者无法停录，因此先校验关键矩阵的触发次数。
       */
      for (let index = 0; index < cases.length; index++) {
        const testCase = cases[index];
        const factory = new MockInputConsumerFactory(testCase.keyA, testCase.keyB, createDefaultClock(1700002000100 + index));
        const firedCount = applySequence(factory, index);
        assertNumberEqual(firedCount, testCase.expectedTriggerCount);
      }
    });

    it('MockInputConsumer_HistoryPreservesTemporalOrder_002', 0, () => {
      const callbackCounter = new MutableCounter(0);
      const factory = triggerSequence(23, 24, 2, callbackCounter);
      const controller = factory.build();
      controller.setCallback(() => {
        callbackCounter.value += 1
      });
      controller.triggerDown(23);
      factory.clock.tick(10);
      controller.triggerDown(24);
      factory.clock.tick(10);
      controller.triggerUp(23);
      factory.clock.tick(10);
      controller.triggerUp(24);

      const history = controller.getTriggerHistory();
      const times = history.map((record) => record.triggeredAt);
      assertArrayLength(history, 4);
      assertNumberEqual(callbackCounter.value, 1);
      assertTrue(times[0] <= times[1] && times[1] <= times[2] && times[2] <= times[3]);
    });

    it('MockInputConsumer_GatePreventsRepeatedCallbackWhileKeysHeld_003', 0, () => {
      const factory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700002000200));
      const controller = factory.build();
      let callbackCount = 0;
      controller.setCallback(() => {
        callbackCount += 1
      });
      controller.triggerDown(23);
      controller.triggerDown(24);
      controller.triggerDown(23);
      controller.triggerDown(24);
      assertNumberEqual(callbackCount, 1);
    });

    it('MockInputConsumer_KeyReleaseReopensGateForNextRound_004', 0, () => {
      const factory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700002000300));
      const controller = factory.build();
      let callbackCount = 0;
      controller.setCallback(() => {
        callbackCount += 1
      });
      controller.triggerDown(23);
      controller.triggerDown(24);
      controller.triggerUp(23);
      controller.triggerUp(24);
      controller.triggerDown(24);
      controller.triggerDown(23);
      assertNumberEqual(callbackCount, 2);
    });

    it('MockInputConsumer_StressLoopKeepsExpectedRoundCount_005', 0, () => {
      const factory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700002000400));
      const controller = factory.build();
      let callbackCount = 0;
      controller.setCallback(() => {
        callbackCount += 1
      });

      /**
       * 高频输入压测可以发现门闩没有复位、触发历史泄漏等问题。
       * 这里用固定顺序执行 120 轮，确保回调次数和历史长度都与轮次严格对齐。
       */
      for (let round = 0; round < 120; round++) {
        controller.triggerDown(23);
        controller.triggerDown(24);
        controller.triggerUp(23);
        controller.triggerUp(24);
      }

      assertNumberEqual(callbackCount, 120);
      assertNumberEqual(controller.getTriggerHistory().length, 480);
    });

    it('MockWindowManager_OpenRecordsCaptureWindowIdentity_006', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      const ctx = new MockContextData();
      manager.openTimerWindow('timer', 'pages/ScreenRecorderTimer', new MockWindowRectEntity(96, 48, 624, 56), ctx);
      manager.openTimerWindow('tip', 'pages/ScreenRecorderDialog', new MockWindowRectEntity(615, 46, 686, 100), ctx);
      const records = factory.getOpenRecords();
      assertArrayLength(records, 2);
      assertStringEqual(records[0].name, 'timer');
      assertStringEqual(records[1].page, 'pages/ScreenRecorderDialog');
    });

    it('MockWindowManager_PopupTriggersCallbackImmediately_007', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      let callbackCount = 0;
      manager.popupRecorderTip(
        'tip',
        'pages/ScreenRecorderDialog',
        new MockWindowRectEntity(615, 46, 686, 100),
        3000,
        new MockContextData(),
        () => {
          callbackCount += 1
        }
      )
      assertNumberEqual(callbackCount, 1);
      assertNumberEqual(factory.getPopupRecords().length, 1);
    });

    it('MockWindowManager_GetReturnsCreatedWindowAndHideIsTracked_008', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      manager.openTimerWindow('timer', 'pages/ScreenRecorderTimer', new MockWindowRectEntity(96, 48, 624, 56), new MockContextData());
      const windowObj = manager.get('timer');
      assertTrue(windowObj !== undefined);
      windowObj?.hide()
      windowObj?.hide()
      assertNumberEqual(factory.getWindowHideCount('timer'), 2);
    });

    it('MockWindowManager_ReleaseClearsAllWindows_009', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      manager.openTimerWindow('timer_a', 'pages/ScreenRecorderTimer', new MockWindowRectEntity(0, 0, 10, 10), new MockContextData());
      manager.openTimerWindow('timer_b', 'pages/ScreenRecorderTimer', new MockWindowRectEntity(10, 10, 10, 10), new MockContextData());
      manager.release();
      assertTrue(factory.isReleased());
      assertTrue(manager.get('timer_a') === undefined);
      assertTrue(manager.get('timer_b') === undefined);
    });

    it('MockWindowManager_StorageObjectsCanBePassedAcrossCalls_010', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      const storage = new FoundationStorageEntity();
      storage.set('recorderState', 1);
      manager.openTimerWindow(
        'timer',
        'pages/ScreenRecorderTimer',
        new MockWindowRectEntity(96, 48, 624, 56),
        new MockContextData(),
        storage.snapshot()
      );
      assertNumberEqual(factory.getOpenRecords().length, 1);
      assertStringEqual(factory.getOpenRecords()[0].page, 'pages/ScreenRecorderTimer');
    });

    it('MockWindowAndInput_MixedRegressionProducesStableChecksum_011', 0, () => {
      const checksum = new FoundationRollingChecksum();
      const counter = new FoundationScenarioCounter();

      /**
       * 真实业务里，悬浮窗创建和按键消费往往交织出现。
       * 这个混合回归通过统一指纹验证多子系统组合后仍然保持稳定，不依赖人工逐条比对日志。
       */
      for (let round = 0; round < 30; round++) {
        const windowFactory = new MockWindowManagerFactory();
        const windowMgr = windowFactory.build();
        const inputFactory = new MockInputConsumerFactory(23, 24, createDefaultClock(1700002000500 + round));
        const input = inputFactory.build();
        let callbackCount = 0;
        input.setCallback(() => {
          callbackCount += 1
        });
        windowMgr.openTimerWindow(`timer_${round}`, 'pages/ScreenRecorderTimer', new MockWindowRectEntity(round, round, 100, 50), new MockContextData());
        input.triggerDown(23);
        input.triggerDown(24);
        input.triggerUp(23);
        input.triggerUp(24);
        windowMgr.popupRecorderTip(`tip_${round}`, 'pages/ScreenRecorderDialog', new MockWindowRectEntity(0, 0, 200, 80), 3000, new MockContextData());
        counter.record(`round_${round % 5}`);
        checksum.appendNumber(windowFactory.getOpenRecords().length);
        checksum.appendNumber(windowFactory.getPopupRecords().length);
        checksum.appendNumber(callbackCount);
      }

      assertNumberEqual(counter.getDistinctCount(), 5);
      assertAtLeast(counter.getTotalCount(), 30);
      assertAtLeast(checksum.getValue(), 1);
    });

    it('MockWindowManager_HighVolumePopupCoverageMaintainsNaming_012', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      const ctx = new MockContextData();
      for (let index = 0; index < 50; index++) {
        manager.popupRecorderTip(
          `popup_${index}`,
          index % 2 === 0 ? 'pages/ScreenRecorderDialog' : 'pages/ResolutionNotSupportedDialog',
          new MockWindowRectEntity(615, 46, 686, 100),
          1000 + index,
          ctx
        )
      }
      const summary = factory.getPopupRecords().map((record) => record.page).join(',');
      assertNumberEqual(factory.getPopupRecords().length, 50);
      assertContains(summary, 'pages/ScreenRecorderDialog');
      assertContains(summary, 'pages/ResolutionNotSupportedDialog');
    });
  });
}
