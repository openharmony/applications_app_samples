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

import { describe, expect, it } from '@ohos/hypium';
import { AlbumType } from '../../../main/ets/models/PhotoModel';
import { SessionModel } from '../../../main/ets/smaba/NasSessionManager';
import { TestDataFactory } from './base/TestDataFactory';
import { MockInputConsumer, MockFocusController } from './base/TestDoubles';

const SESSION_PREFIX = 'session_';
const FOCUS_RETRY_NUM = 7;

class SessionRouteRecord {
  url: string;
  photoTitle?: string;
  photoType?: AlbumType;

  constructor(url: string, photoTitle?: string, photoType?: AlbumType) {
    this.url = url;
    this.photoTitle = photoTitle;
    this.photoType = photoType;
  }
}

class InputOptions {
}

class KeyEventRecord {
  keyCode: number;
  type: number;

  constructor(keyCode: number, type: number) {
    this.keyCode = keyCode;
    this.type = type;
  }
}

class PlaceholderLengthScenario {
  name: string;
  count: number;
  expectedLength: number;

  constructor(name: string, count: number, expectedLength: number) {
    this.name = name;
    this.count = count;
    this.expectedLength = expectedLength;
  }
}

type SessionDirection = 'left' | 'up' | 'right' | 'down';

class NeighborScenario {
  name: string;
  currentIndex: number;
  direction: SessionDirection;
  expected: number;

  constructor(name: string, currentIndex: number, direction: SessionDirection, expected: number) {
    this.name = name;
    this.currentIndex = currentIndex;
    this.direction = direction;
    this.expected = expected;
  }
}

class MoveFocusScenario {
  keyCode: number;
  startIndex: number;
  expectedFocus: string;
  expectedIndex: number;

  constructor(keyCode: number, startIndex: number, expectedFocus: string, expectedIndex: number) {
    this.keyCode = keyCode;
    this.startIndex = startIndex;
    this.expectedFocus = expectedFocus;
    this.expectedIndex = expectedIndex;
  }
}

class RouteScenario {
  name: string;
  keyCode: number;
  usePlaceholder: boolean;
  expectedUrl: string;

  constructor(name: string, keyCode: number, usePlaceholder: boolean, expectedUrl: string) {
    this.name = name;
    this.keyCode = keyCode;
    this.usePlaceholder = usePlaceholder;
    this.expectedUrl = expectedUrl;
  }
}

class FocusScenario {
  name: string;
  focusId: string;
  index: number;

  constructor(name: string, focusId: string, index: number) {
    this.name = name;
    this.focusId = focusId;
    this.index = index;
  }
}

class RetryFailureScenario {
  name: string;
  failTimes: number;
  focusId: string;
  index: number;

  constructor(name: string, failTimes: number, focusId: string, index: number) {
    this.name = name;
    this.failTimes = failTimes;
    this.focusId = focusId;
    this.index = index;
  }
}

class ShowHideScenario {
  name: string;
  repeat: number;
  expectedRegister: number;
  expectedUnregister: number;

  constructor(name: string, repeat: number, expectedRegister: number, expectedUnregister: number) {
    this.name = name;
    this.repeat = repeat;
    this.expectedRegister = expectedRegister;
    this.expectedUnregister = expectedUnregister;
  }
}

const PLACEHOLDER_LENGTH_SCENARIOS: PlaceholderLengthScenario[] = [
  new PlaceholderLengthScenario('single_session_plus_placeholder', 1, 2),
  new PlaceholderLengthScenario('three_sessions_plus_placeholder', 3, 4),
  new PlaceholderLengthScenario('five_sessions_plus_placeholder', 5, 6)
];

const NEIGHBOR_SCENARIOS: NeighborScenario[] = [
  new NeighborScenario('left_from_second', 1, 'left', 0),
  new NeighborScenario('right_from_first', 0, 'right', 1),
  new NeighborScenario('down_from_first', 0, 'down', 5),
  new NeighborScenario('left_from_placeholder', 6, 'left', 5),
  new NeighborScenario('right_from_last', 6, 'right', -1),
  new NeighborScenario('up_from_middle_row', 6, 'up', 1)
];

const MOVE_FOCUS_SCENARIOS: MoveFocusScenario[] = [
  new MoveFocusScenario(2012, 1, 'session_0', 0),
  new MoveFocusScenario(2013, 0, 'session_1', 1),
  new MoveFocusScenario(2015, 0, 'session_5', 5),
  new MoveFocusScenario(2014, 6, 'session_1', 1)
];

const ROUTE_SCENARIOS: RouteScenario[] = [
  new RouteScenario('enter_real_session', 2016, false, 'pages/PhotoList'),
  new RouteScenario('center_real_session', 2054, false, 'pages/PhotoList'),
  new RouteScenario('enter_placeholder', 2016, true, 'pages/NasClientPage'),
  new RouteScenario('center_placeholder', 2054, true, 'pages/NasClientPage')
];

const FOCUS_SCENARIOS: FocusScenario[] = [
  new FocusScenario('focus_first_tile', 'session_0', 0),
  new FocusScenario('focus_middle_tile', 'session_3', 3),
  new FocusScenario('focus_last_tile', 'session_6', 6)
];

const RETRY_FAILURE_SCENARIOS: RetryFailureScenario[] = [
  new RetryFailureScenario('no_retry_failure', FOCUS_RETRY_NUM + 1, 'session_2', 2),
  new RetryFailureScenario('single_retry_failure', FOCUS_RETRY_NUM + 3, 'session_5', 5)
];

const SHOW_HIDE_SCENARIOS: ShowHideScenario[] = [
  new ShowHideScenario('show_hide_once', 1, 1, 1),
  new ShowHideScenario('show_hide_twice', 2, 2, 2)
];

class MockSessionManager {
  registerCount: number = 0;
  unregisterCount: number = 0;
  disconnectHistory: string[] = [];
  private observer?: (models: SessionModel[]) => void;

  registerSessionCallback(observer: (models: SessionModel[]) => void): void {
    this.registerCount++;
    this.observer = observer;
  }

  unRegisterSessionCallback(observer: (models: SessionModel[]) => void): void {
    this.unregisterCount++;
    if (this.observer === observer) {
      this.observer = undefined;
    }
  }

  disconnectSession(host: string): void {
    this.disconnectHistory.push(host);
  }

  emit(models: SessionModel[]): void {
    this.observer?.(models);
  }
}

class RetryFocusController {
  private focusHistory: string[] = [];
  private failurePlan: Map<string, number> = new Map();

  allowWithFailures(id: string, failTimes: number): void {
    this.failurePlan.set(id, failTimes);
  }

  requestFocus(id: string): boolean {
    const remain = this.failurePlan.get(id) ?? 0;
    if (remain > 0) {
      this.failurePlan.set(id, remain - 1);
      return false;
    }
    this.focusHistory.push(id);
    return true;
  }

  getFocusHistory(): string[] {
    return [...this.focusHistory];
  }
}

class NasSessionHarness {
  sessionModels: SessionModel[] = [];
  focusStr: string = `${SESSION_PREFIX}0`;
  focusIndex: number = 0;
  dialogFlag: boolean = false;
  dialogFocusStr: string = '';
  albumGridRowCount: number = 5;
  routeHistory: SessionRouteRecord[] = [];
  scrollHistory: number[] = [];
  dialogOpenCount: number = 0;
  focusRetryNum: number = 0;
  onPageShowCount: number = 0;
  onPageHideCount: number = 0;
  private readonly menuCallback = () => {
    this.keyCallback();
  };
  private sessionManager: MockSessionManager;
  private inputConsumer: MockInputConsumer;
  private focusController: MockFocusController | RetryFocusController;

  constructor(sessionManager?: MockSessionManager, inputConsumer?: MockInputConsumer,
    focusController?: MockFocusController | RetryFocusController) {
    this.sessionManager = sessionManager ?? new MockSessionManager();
    this.inputConsumer = inputConsumer ?? new MockInputConsumer();
    this.focusController = focusController ?? new MockFocusController();
    if (this.focusController instanceof MockFocusController) {
      this.focusController.allow([
        'session_0',
        'session_1',
        'session_2',
        'session_3',
        'session_4',
        'session_5',
        'session_6',
        'session_7'
      ]);
    }
  }

  readonly nasSessionObserver = (models: SessionModel[]) => {
    this.sessionModels = [...models, TestDataFactory.createPlaceholderSession()];
  };

  disconnect(): void {
    this.sessionManager.disconnectSession(this.sessionModels[this.focusIndex].host);
  }

  keyCallback(): void {
    if (!this.dialogFlag && !this.sessionModels[this.focusIndex].isPlaceHolder) {
      this.dialogOpenCount++;
    }
  }

  onPageShow(): void {
    this.onPageShowCount++;
    this.sessionManager.registerSessionCallback(this.nasSessionObserver);
    this.clickFocusBtn(this.focusStr, this.focusIndex);
    this.inputConsumer.on('key', new InputOptions(), this.menuCallback);
  }

  onPageHide(): void {
    this.onPageHideCount++;
    this.sessionManager.unRegisterSessionCallback(this.nasSessionObserver);
    this.focusRetryNum = 0;
    this.inputConsumer.off('key', new InputOptions(), this.menuCallback);
  }

  onEvent(index: number, session: SessionModel, event: KeyEventRecord): void {
    if (event.type !== 0) {
      return;
    }
    switch (event.keyCode) {
      case 2012:
        this.nextAlbumClick(index, 'left');
        break;
      case 2013:
        this.nextAlbumClick(index, 'right');
        break;
      case 2015:
        this.nextAlbumClick(index, 'down');
        break;
      case 2014:
        this.nextAlbumClick(index, 'up');
        break;
      case 2016:
      case 2054:
        this.openSession(index);
        break;
    }
  }

  openSession(index: number): void {
    const targetSession = this.sessionModels[index];
    if (targetSession.isPlaceHolder) {
      this.routeHistory.push(new SessionRouteRecord('pages/NasClientPage'));
      return;
    }
    this.routeHistory.push(new SessionRouteRecord('pages/PhotoList', targetSession.host, AlbumType.NAS_SESSION));
  }

  nextAlbumClick(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down'): void {
    const index = this.getNextAlbum(currentIndex, direction);
    if (index !== -1) {
      this.clickFocusBtn(`${SESSION_PREFIX}${index}`, index);
    }
  }

  getNextAlbum(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down'): number {
    const indexs: number[] = [];
    let trueIndex = 0;
    this.sessionModels.forEach((value, index) => {
      indexs.push(index);
      if (index === currentIndex) {
        trueIndex = indexs.length - 1;
      }
    });

    let newIndex = -1;
    if (direction === 'left' && trueIndex > 0) {
      newIndex = indexs[trueIndex - 1];
    }
    if (direction === 'right' && trueIndex < indexs.length - 1) {
      newIndex = indexs[trueIndex + 1];
    }
    if (direction === 'up' && trueIndex > this.albumGridRowCount) {
      newIndex = indexs[trueIndex - this.albumGridRowCount];
    }
    if (direction === 'down' && trueIndex < indexs.length - this.albumGridRowCount) {
      newIndex = indexs[trueIndex + this.albumGridRowCount];
    }
    return newIndex;
  }

  clickFocusBtn(str: string, index: number): boolean {
    const isSuccess = this.focusController.requestFocus(str);
    if (isSuccess) {
      this.focusStr = str;
      this.focusIndex = index;
      this.scrollHistory.push(index);
      this.focusRetryNum = 0;
    } else {
      this.focusRetryNum++;
      if (this.focusRetryNum > FOCUS_RETRY_NUM) {
        return false;
      }
      return this.clickFocusBtn(str, index);
    }
    return isSuccess;
  }

  getInputConsumer(): MockInputConsumer {
    return this.inputConsumer;
  }

  getSessionManager(): MockSessionManager {
    return this.sessionManager;
  }

  getFocusHistory(): string[] {
    if (this.focusController instanceof MockFocusController) {
      return this.focusController.getFocusHistory().map((item) => item.focusId);
    }
    return this.focusController.getFocusHistory();
  }
}

function createSessions(count: number): SessionModel[] {
  return TestDataFactory.createSessionModels(count);
}

function createKeyEvent(keyCode: number, type?: number): KeyEventRecord {
  return new KeyEventRecord(keyCode, type ?? 0);
}

export default function nasSessionInteractionTest() {
  describe('NasSessionInteractionTest', () => {
    it('should append placeholder tile after nas session observer updates', 0, () => {
      const harness = new NasSessionHarness();
      const sessions = createSessions(2);

      harness.nasSessionObserver(sessions);

      expect(harness.sessionModels.length).assertEqual(3);
      expect(harness.sessionModels[0].host).assertEqual(sessions[0].host);
      expect(harness.sessionModels[2].isPlaceHolder).assertTrue();
    });

    it('should register callbacks and focus default session on page show', 0, () => {
      const sessionManager = new MockSessionManager();
      const inputConsumer = new MockInputConsumer();
      const harness = new NasSessionHarness(sessionManager, inputConsumer);
      harness.sessionModels = createSessions(2);

      harness.onPageShow();

      expect(harness.onPageShowCount).assertEqual(1);
      expect(sessionManager.registerCount).assertEqual(1);
      expect(harness.focusStr).assertEqual('session_0');
      expect(inputConsumer.getSubscriptionCount('key')).assertEqual(1);
    });

    it('should unregister callbacks and reset retry state on page hide', 0, () => {
      const sessionManager = new MockSessionManager();
      const harness = new NasSessionHarness(sessionManager, new MockInputConsumer());
      harness.focusRetryNum = 3;

      harness.onPageHide();

      expect(harness.onPageHideCount).assertEqual(1);
      expect(sessionManager.unregisterCount).assertEqual(1);
      expect(harness.focusRetryNum).assertEqual(0);
    });

    it('should open disconnect dialog only for real session tiles', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = [...createSessions(1), TestDataFactory.createPlaceholderSession()];
      harness.focusIndex = 0;

      harness.keyCallback();
      expect(harness.dialogOpenCount).assertEqual(1);

      harness.focusIndex = 1;
      harness.keyCallback();
      expect(harness.dialogOpenCount).assertEqual(1);
    });

    it('should disconnect currently focused session host', 0, () => {
      const sessionManager = new MockSessionManager();
      const harness = new NasSessionHarness(sessionManager);
      harness.sessionModels = createSessions(2);
      harness.focusIndex = 1;

      harness.disconnect();

      expect(sessionManager.disconnectHistory.length).assertEqual(1);
      expect(sessionManager.disconnectHistory[0]).assertEqual(harness.sessionModels[1].host);
    });

    it('should route placeholder session to nas client page', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = [TestDataFactory.createPlaceholderSession()];

      harness.openSession(0);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/NasClientPage');
    });

    it('should route real session to photo list with nas type params', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = createSessions(1);

      harness.openSession(0);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/PhotoList');
      expect(harness.routeHistory[0].photoTitle).assertEqual(harness.sessionModels[0].host);
      expect(harness.routeHistory[0].photoType).assertEqual(AlbumType.NAS_SESSION);
    });

    it('should process enter key through session event dispatcher', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = createSessions(1);

      harness.onEvent(0, harness.sessionModels[0], createKeyEvent(2016));

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/PhotoList');
    });

    it('should ignore non-down key events in session dispatcher', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = createSessions(1);

      harness.onEvent(0, harness.sessionModels[0], createKeyEvent(2016, 1));

      expect(harness.routeHistory.length).assertEqual(0);
      expect(harness.focusStr).assertEqual('session_0');
    });

    it('should compute session neighbors across horizontal and vertical movement', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = [...createSessions(6), TestDataFactory.createPlaceholderSession()];

      expect(harness.getNextAlbum(0, 'right')).assertEqual(1);
      expect(harness.getNextAlbum(1, 'left')).assertEqual(0);
      expect(harness.getNextAlbum(0, 'down')).assertEqual(5);
      expect(harness.getNextAlbum(5, 'up')).assertEqual(-1);
      expect(harness.getNextAlbum(6, 'left')).assertEqual(5);
    });

    it('should move focus to the computed session neighbor', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = [...createSessions(6), TestDataFactory.createPlaceholderSession()];

      harness.nextAlbumClick(0, 'down');

      expect(harness.focusStr).assertEqual('session_5');
      expect(harness.focusIndex).assertEqual(5);
      expect(harness.scrollHistory[harness.scrollHistory.length - 1]).assertEqual(5);
    });

    it('should retry focus until session tile becomes focusable', 0, () => {
      const focusController = new RetryFocusController();
      focusController.allowWithFailures('session_3', 2);
      const harness = new NasSessionHarness(undefined, undefined, focusController);

      const result = harness.clickFocusBtn('session_3', 3);

      expect(result).assertTrue();
      expect(harness.focusStr).assertEqual('session_3');
      expect(harness.focusIndex).assertEqual(3);
      expect(harness.getFocusHistory().length).assertEqual(1);
    });

    it('should stop retrying focus after exceeding retry budget', 0, () => {
      const focusController = new RetryFocusController();
      focusController.allowWithFailures('session_4', FOCUS_RETRY_NUM + 1);
      const harness = new NasSessionHarness(undefined, undefined, focusController);

      const result = harness.clickFocusBtn('session_4', 4);

      expect(result).assertFalse();
      expect(harness.focusStr).assertEqual('session_0');
      expect(harness.focusRetryNum).assertEqual(FOCUS_RETRY_NUM + 1);
      expect(harness.getFocusHistory().length).assertEqual(0);
    });

    it('should receive session updates through registered observer contract', 0, () => {
      const sessionManager = new MockSessionManager();
      const harness = new NasSessionHarness(sessionManager);
      harness.onPageShow();
      const sessions = createSessions(3);

      sessionManager.emit(sessions);

      expect(harness.sessionModels.length).assertEqual(4);
      expect(harness.sessionModels[3].isPlaceHolder).assertTrue();
    });

    it('should keep focus history aligned with session navigation path', 0, () => {
      const harness = new NasSessionHarness();
      harness.sessionModels = [...createSessions(3), TestDataFactory.createPlaceholderSession()];

      harness.clickFocusBtn('session_1', 1);
      harness.nextAlbumClick(1, 'right');

      const focusHistory = harness.getFocusHistory();
      expect(focusHistory[0]).assertEqual('session_1');
      expect(focusHistory[1]).assertEqual('session_2');
    });

    PLACEHOLDER_LENGTH_SCENARIOS.forEach((scenario: PlaceholderLengthScenario) => {
      it(`should append placeholder deterministically for ${scenario.name}`, 0, () => {
        const harness = new NasSessionHarness();

        harness.nasSessionObserver(createSessions(scenario.count));

        expect(harness.sessionModels.length).assertEqual(scenario.expectedLength);
        expect(harness.sessionModels[harness.sessionModels.length - 1].isPlaceHolder).assertTrue();
      });
    });

    NEIGHBOR_SCENARIOS.forEach((scenario: NeighborScenario) => {
      it(`should compute nas session neighbor for ${scenario.name}`, 0, () => {
        const harness = new NasSessionHarness();
        harness.sessionModels = [...createSessions(6), TestDataFactory.createPlaceholderSession()];

        expect(harness.getNextAlbum(scenario.currentIndex, scenario.direction)).assertEqual(scenario.expected);
      });
    });

    MOVE_FOCUS_SCENARIOS.forEach((scenario: MoveFocusScenario) => {
      it(`should move session focus through key event ${scenario.keyCode}`, 0, () => {
        const harness = new NasSessionHarness();
        harness.sessionModels = [...createSessions(6), TestDataFactory.createPlaceholderSession()];

        harness.onEvent(scenario.startIndex, harness.sessionModels[scenario.startIndex], createKeyEvent(scenario.keyCode));

        expect(harness.focusStr).assertEqual(scenario.expectedFocus);
        expect(harness.focusIndex).assertEqual(scenario.expectedIndex);
      });
    });

    ROUTE_SCENARIOS.forEach((scenario: RouteScenario) => {
      it(`should route session event for ${scenario.name}`, 0, () => {
        const harness = new NasSessionHarness();
        harness.sessionModels = scenario.usePlaceholder
          ? [TestDataFactory.createPlaceholderSession()]
          : createSessions(1);

        harness.onEvent(0, harness.sessionModels[0], createKeyEvent(scenario.keyCode));

        expect(harness.routeHistory.length).assertEqual(1);
        expect(harness.routeHistory[0].url).assertEqual(scenario.expectedUrl);
      });
    });

    FOCUS_SCENARIOS.forEach((scenario: FocusScenario) => {
      it(`should focus nas session tile for ${scenario.name}`, 0, () => {
        const harness = new NasSessionHarness();
        harness.sessionModels = [...createSessions(6), TestDataFactory.createPlaceholderSession()];

        const result = harness.clickFocusBtn(scenario.focusId, scenario.index);

        expect(result).assertTrue();
        expect(harness.focusStr).assertEqual(scenario.focusId);
        expect(harness.focusIndex).assertEqual(scenario.index);
        expect(harness.scrollHistory[harness.scrollHistory.length - 1]).assertEqual(scenario.index);
      });
    });

    RETRY_FAILURE_SCENARIOS.forEach((scenario: RetryFailureScenario) => {
      it(`should preserve default focus when retry budget is exceeded for ${scenario.name}`, 0, () => {
        const focusController = new RetryFocusController();
        focusController.allowWithFailures(scenario.focusId, scenario.failTimes);
        const harness = new NasSessionHarness(undefined, undefined, focusController);

        const result = harness.clickFocusBtn(scenario.focusId, scenario.index);

        expect(result).assertFalse();
        expect(harness.focusStr).assertEqual('session_0');
        expect(harness.focusIndex).assertEqual(0);
        expect(harness.getFocusHistory().length).assertEqual(0);
      });
    });

    SHOW_HIDE_SCENARIOS.forEach((scenario: ShowHideScenario) => {
      it(`should keep session callback counts stable for ${scenario.name}`, 0, () => {
        const sessionManager = new MockSessionManager();
        const inputConsumer = new MockInputConsumer();
        const harness = new NasSessionHarness(sessionManager, inputConsumer);
        harness.sessionModels = createSessions(2);

        for (let index = 0; index < scenario.repeat; index++) {
          harness.onPageShow();
          harness.onPageHide();
        }

        expect(sessionManager.registerCount).assertEqual(scenario.expectedRegister);
        expect(sessionManager.unregisterCount).assertEqual(scenario.expectedUnregister);
        expect(inputConsumer.getSubscriptionCount('key')).assertEqual(0);
      });
    });
  });
}
