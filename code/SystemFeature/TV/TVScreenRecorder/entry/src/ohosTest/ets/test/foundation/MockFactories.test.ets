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
import {
  createDefaultClock,
  MockInputConsumerFactory,
  MockPhotoAccessHelperFactory,
  MockSRApiFactory,
  MockWindowManagerFactory
} from './MockFactories';
import {
  assertArrayLength,
  assertAtLeast,
  assertContains,
  assertIncreasing,
  assertNumberEqual,
  assertStateEqual,
  assertStringEqual,
  assertTrue
} from './TestAsserts';
import { MockContextData, MockRecordingState, MockWindowRectEntity } from './TestTypes';

export default function mockFactoriesTest(): void {
  describe('MockFactoriesFoundationTest', () => {
    it('MockPhotoAccessFactory_CreateAsset_001', 0, async () => {
      const clock = createDefaultClock(1000);
      const factory = new MockPhotoAccessHelperFactory(clock);
      const helper = factory.build();
      const result = await helper.createAsset('REC_001.mp4', { subtype: 1 });
      assertContains(result.uri, 'REC_001.mp4');
      assertStringEqual(result.fileName, 'REC_001.mp4');
      assertNumberEqual(result.createdAt, 1000);
      assertNumberEqual(factory.getAssetCount(), 1);
    });

    it('MockPhotoAccessFactory_GetAssets_002', 0, async () => {
      const factory = new MockPhotoAccessHelperFactory();
      const helper = factory.build();
      await helper.createAsset('REC_A.mp4', { subtype: 1 });
      await helper.createAsset('REC_B.mp4', { subtype: 1 });
      await helper.createAsset('REC_C.mp4', { subtype: 1 });
      const fetchResult = await helper.getAssets({});
      assertNumberEqual(fetchResult.getCount(), 3);
    });

    it('MockPhotoAccessFactory_ThrowOnCreate_003', 0, async () => {
      const factory = new MockPhotoAccessHelperFactory();
      factory.setThrowOnCreateAsset(true);
      const helper = factory.build();
      let thrown = false;
      try {
        await helper.createAsset('REC_ERR.mp4', { subtype: 1 });
      } catch (_) {
        thrown = true;
      }
      assertTrue(thrown);
      assertNumberEqual(factory.getAssetCount(), 0);
    });

    it('MockPhotoAccessFactory_ThrowOnGetAssets_004', 0, async () => {
      const factory = new MockPhotoAccessHelperFactory();
      factory.setThrowOnGetAssets(true);
      const helper = factory.build();
      let thrown = false;
      try {
        await helper.getAssets({});
      } catch (_) {
        thrown = true;
      }
      assertTrue(thrown);
    });

    it('MockPhotoAccessFactory_CreationCounter_005', 0, async () => {
      const factory = new MockPhotoAccessHelperFactory();
      const helper = factory.build();
      for (let index = 0; index < 12; index++) {
        await helper.createAsset(`REC_${index}.mp4`, { subtype: 1 });
      }
      assertNumberEqual(factory.getCreationCounter(), 12);
      assertNumberEqual(factory.getAssetCount(), 12);
    });

    it('MockWindowManager_OpenWindow_006', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      manager.openTimerWindow('timer', 'pages/screenRecorderTimer', new MockWindowRectEntity(1, 2, 300, 120), new MockContextData());
      const records = factory.getOpenRecords();
      assertArrayLength(records, 1);
      assertStringEqual(records[0].name, 'timer');
      assertStringEqual(records[0].page, 'pages/screenRecorderTimer');
      assertNumberEqual(records[0].width, 300);
      assertNumberEqual(records[0].height, 120);
    });

    it('MockWindowManager_GetAndHide_007', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      manager.openTimerWindow('timer', 'pages/screenRecorderTimer', new MockWindowRectEntity(1, 2, 100, 60), new MockContextData());
      const target = manager.get('timer');
      assertTrue(target !== undefined);
      target?.hide();
      target?.hide();
      assertNumberEqual(factory.getWindowHideCount('timer'), 2);
    });

    it('MockWindowManager_PopupCallback_008', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      let callbackCounter = 0;
      manager.popupRecorderTip('tip', 'pages/screenRecorderDialog', new MockWindowRectEntity(1, 2, 3, 4), 3000, new MockContextData(), () => {
        callbackCounter += 1;
      });
      const records = factory.getPopupRecords();
      assertArrayLength(records, 1);
      assertNumberEqual(records[0].duration, 3000);
      assertNumberEqual(callbackCounter, 1);
    });

    it('MockWindowManager_Release_009', 0, () => {
      const factory = new MockWindowManagerFactory();
      const manager = factory.build();
      manager.openTimerWindow('timer', 'pages/screenRecorderTimer', new MockWindowRectEntity(0, 0, 10, 10), new MockContextData());
      manager.release();
      assertTrue(factory.isReleased());
      const target = manager.get('timer');
      assertTrue(target === undefined);
    });

    it('MockSRApi_StartSuccess_010', 0, () => {
      const factory = new MockSRApiFactory();
      const api = factory.build();
      api.setStartReturn(0);
      const code = api.startRecording('fd://10');
      assertNumberEqual(code, 0);
      assertStateEqual(api.getRecorderState() as MockRecordingState, MockRecordingState.Recording);
      assertStringEqual(api.getLastStartUrl(), 'fd://10');
    });

    it('MockSRApi_StartFail_011', 0, () => {
      const factory = new MockSRApiFactory();
      const api = factory.build();
      api.setStartReturn(-1);
      const code = api.startRecording('fd://11');
      assertNumberEqual(code, -1);
      assertStateEqual(api.getRecorderState() as MockRecordingState, MockRecordingState.Error);
    });

    it('MockSRApi_StopSuccess_012', 0, () => {
      const factory = new MockSRApiFactory();
      const api = factory.build();
      api.setState(MockRecordingState.Recording);
      api.setStopReturn(0);
      const code = api.stopRecording();
      assertNumberEqual(code, 0);
      assertStateEqual(api.getRecorderState() as MockRecordingState, MockRecordingState.Stopped);
    });

    it('MockSRApi_StopFail_013', 0, () => {
      const factory = new MockSRApiFactory();
      const api = factory.build();
      api.setState(MockRecordingState.Recording);
      api.setStopReturn(-2);
      const code = api.stopRecording();
      assertNumberEqual(code, -2);
      assertStateEqual(api.getRecorderState() as MockRecordingState, MockRecordingState.Error);
    });

    it('MockSRApi_StateChangeCallback_014', 0, () => {
      const factory = new MockSRApiFactory();
      const api = factory.build();
      const callbackHistory: number[] = [];
      api.onStateChange((state: number) => {
        callbackHistory.push(state);
      });
      api.emitState(MockRecordingState.Recording);
      api.emitState(MockRecordingState.Stopped);
      api.emitState(MockRecordingState.Idle);
      assertArrayLength(callbackHistory, 3);
      assertNumberEqual(callbackHistory[0], MockRecordingState.Recording);
      assertNumberEqual(callbackHistory[2], MockRecordingState.Idle);
    });

    it('MockSRApi_StateHistory_015', 0, () => {
      const factory = new MockSRApiFactory();
      const api = factory.build();
      api.emitState(MockRecordingState.Recording);
      api.emitState(MockRecordingState.Stopped);
      api.emitState(MockRecordingState.Idle);
      const history = api.getStateHistory();
      assertAtLeast(history.length, 4);
      assertNumberEqual(history[0], MockRecordingState.Idle);
      assertNumberEqual(history[history.length - 1], MockRecordingState.Idle);
    });

    it('MockInputConsumer_TriggerSequence_016', 0, () => {
      const clock = createDefaultClock(100);
      const factory = new MockInputConsumerFactory(7, 8, clock);
      const consumer = factory.build();
      let callbackCounter = 0;
      consumer.setCallback(() => {
        callbackCounter += 1;
      });
      consumer.triggerDown(7);
      clock.tick(5);
      consumer.triggerDown(8);
      clock.tick(5);
      consumer.triggerUp(7);
      consumer.triggerUp(8);
      assertNumberEqual(callbackCounter, 1);
      const history = consumer.getTriggerHistory();
      assertArrayLength(history, 4);
      assertNumberEqual(history[0].keyCode, 7);
      assertTrue(history[0].isDown);
      assertTrue(history[2].isDown === false);
    });

    it('MockInputConsumer_GateControl_017', 0, () => {
      const factory = new MockInputConsumerFactory(100, 200);
      const consumer = factory.build();
      let callbackCounter = 0;
      consumer.setCallback(() => {
        callbackCounter += 1;
      });
      consumer.triggerDown(100);
      consumer.triggerDown(200);
      consumer.triggerDown(100);
      consumer.triggerDown(200);
      assertNumberEqual(callbackCounter, 1);
      consumer.triggerUp(100);
      consumer.triggerDown(100);
      assertNumberEqual(callbackCounter, 2);
    });

    it('MockInputConsumer_IgnoreOtherKeys_018', 0, () => {
      const factory = new MockInputConsumerFactory(10, 20);
      const consumer = factory.build();
      let callbackCounter = 0;
      consumer.setCallback(() => {
        callbackCounter += 1;
      });
      consumer.triggerDown(11);
      consumer.triggerDown(21);
      consumer.triggerUp(11);
      consumer.triggerUp(21);
      assertNumberEqual(callbackCounter, 0);
    });

    it('MockClock_TickIncreasing_019', 0, () => {
      const clock = createDefaultClock(1000);
      const values: number[] = [];
      values.push(clock.now());
      values.push(clock.tick(1));
      values.push(clock.tick(2));
      values.push(clock.tick(3));
      values.push(clock.tick(4));
      assertIncreasing(values);
      assertNumberEqual(values[0], 1000);
      assertNumberEqual(values[4], 1010);
    });

    it('MockClock_Set_020', 0, () => {
      const clock = createDefaultClock(1000);
      assertNumberEqual(clock.now(), 1000);
      clock.set(5000);
      assertNumberEqual(clock.now(), 5000);
      clock.tick(20);
      assertNumberEqual(clock.now(), 5020);
    });
  });
}
