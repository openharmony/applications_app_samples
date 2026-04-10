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
import { MockFocusController } from './base/TestDoubles';

const CLIENT_PREFIX = 'client_';
const KEY_DOWN = 0;
const KEY_UP = 1;
const KEYCODE_DPAD_LEFT = 2012;
const KEYCODE_DPAD_RIGHT = 2013;
const KEYCODE_DPAD_UP = 2014;
const KEYCODE_DPAD_DOWN = 2015;
const KEYCODE_DPAD_CENTER = 2016;
const KEYCODE_ENTER = 2054;

type ClientDirection = 'left' | 'up' | 'right' | 'down';

class ClientRecord {
  host: string;

  constructor(host: string) {
    this.host = host;
  }
}

class AuthRecord {
  host: string;
  userName: string;
  password: string;

  constructor(host: string, userName: string, password: string) {
    this.host = host;
    this.userName = userName;
    this.password = password;
  }
}

class KeyEventRecord {
  keyCode: number;
  type: number;

  constructor(keyCode: number, type: number) {
    this.keyCode = keyCode;
    this.type = type;
  }
}

class ClientLoadScenario {
  name: string;
  count: number;

  constructor(name: string, count: number) {
    this.name = name;
    this.count = count;
  }
}

class ClientNeighborScenario {
  currentIndex: number;
  direction: ClientDirection;
  expected: number;

  constructor(currentIndex: number, direction: ClientDirection, expected: number) {
    this.currentIndex = currentIndex;
    this.direction = direction;
    this.expected = expected;
  }
}

class ClientEventMoveScenario {
  keyCode: number;
  startIndex: number;
  expectedFocus: string;

  constructor(keyCode: number, startIndex: number, expectedFocus: string) {
    this.keyCode = keyCode;
    this.startIndex = startIndex;
    this.expectedFocus = expectedFocus;
  }
}

class DialogKeyScenario {
  name: string;
  keyCode: number;
  expectedHost: string;

  constructor(name: string, keyCode: number, expectedHost: string) {
    this.name = name;
    this.keyCode = keyCode;
    this.expectedHost = expectedHost;
  }
}

class ClientAuthScenario {
  name: string;
  count: number;
  selectedIndex: number;
  authResult: Promise<boolean>;
  expectedToast: string;
  expectedRemain: number;
  expectedBackCount: number;

  constructor(name: string, count: number, selectedIndex: number, authResult: Promise<boolean>, expectedToast: string,
    expectedRemain: number, expectedBackCount: number) {
    this.name = name;
    this.count = count;
    this.selectedIndex = selectedIndex;
    this.authResult = authResult;
    this.expectedToast = expectedToast;
    this.expectedRemain = expectedRemain;
    this.expectedBackCount = expectedBackCount;
  }
}

class FocusScenario {
  focusId: string;
  index: number;

  constructor(focusId: string, index: number) {
    this.focusId = focusId;
    this.index = index;
  }
}

class MockNasSessionManager {
  findNasCalls: number = 0;
  authHistory: AuthRecord[] = [];
  private findNasResult: Promise<ClientRecord[]> = Promise.resolve([]);
  private authResults: Map<string, Promise<boolean>> = new Map();

  setFindNasResult(result: Promise<ClientRecord[]>): void {
    this.findNasResult = result;
  }

  setAuthResult(host: string, result: Promise<boolean>): void {
    this.authResults.set(host, result);
  }

  findNas(): Promise<ClientRecord[]> {
    this.findNasCalls++;
    return this.findNasResult;
  }

  authNasSession(params: AuthRecord): Promise<boolean> {
    this.authHistory.push(params);
    return this.authResults.get(params.host) ?? Promise.resolve(true);
  }
}

class NasClientHarness {
  isNasFindFailed: boolean = false;
  clients: ClientRecord[] = [];
  focusStr: string = `${CLIENT_PREFIX}0`;
  loading: boolean = true;
  selectClient?: ClientRecord;
  albumGridRowCount: number = 5;
  dialogOpenCount: number = 0;
  dialogCloseCount: number = 0;
  progressOpenCount: number = 0;
  progressCloseCount: number = 0;
  toastHistory: string[] = [];
  routeBackCount: number = 0;
  scrollHistory: number[] = [];
  private pendingTasks: Array<() => void> = [];
  private sessionManager: MockNasSessionManager;
  private focusController: MockFocusController;

  constructor(sessionManager?: MockNasSessionManager, focusController?: MockFocusController) {
    this.sessionManager = sessionManager ?? new MockNasSessionManager();
    this.focusController = focusController ?? new MockFocusController();
    this.focusController.allow([
      'client_0',
      'client_1',
      'client_2',
      'client_3',
      'client_4',
      'client_5',
      'client_6',
      'client_7'
    ]);
  }

  async onPageShow(): Promise<void> {
    try {
      const clients = await this.sessionManager.findNas();
      this.clients = clients;
      this.loading = false;
      if (this.clients.length > 0) {
        this.pendingTasks.push(() => {
          this.clickFocusBtn(`${CLIENT_PREFIX}0`, 0);
        });
      }
    } catch (error) {
      this.loading = false;
      this.isNasFindFailed = true;
    }
  }

  flushPendingTasks(): void {
    while (this.pendingTasks.length > 0) {
      const task = this.pendingTasks.shift();
      task?.();
    }
  }

  async authClient(userName: string, password: string): Promise<void> {
    if (!this.selectClient) {
      return;
    }
    this.progressOpenCount++;
    try {
      const isAuthSuccess = await this.sessionManager.authNasSession(
        new AuthRecord(this.selectClient.host, userName, password)
      );
      if (!isAuthSuccess) {
        this.progressCloseCount++;
        this.toastHistory.push('dfs_connect_failed');
        return;
      }
      const index = this.clients.findIndex((client) => client.host === this.selectClient?.host);
      if (index !== -1) {
        this.clients.splice(index, 1);
      }
      this.progressCloseCount++;
      this.toastHistory.push('dfs_connect_success');
      if (this.clients.length === 0) {
        this.routeBackCount++;
      }
    } catch (error) {
      this.progressCloseCount++;
      this.toastHistory.push('dfs_connect_failed');
    }
  }

  onClickClient(index: number): void {
    this.selectClient = this.clients[index];
    this.dialogOpenCount++;
  }

  onDialogCancel(): void {
    this.dialogCloseCount++;
  }

  async onDialogConfirm(userName: string, password: string): Promise<void> {
    this.dialogCloseCount++;
    await this.authClient(userName, password);
  }

  onEvent(index: number, client: ClientRecord, event: KeyEventRecord): void {
    if (event.keyCode === KEYCODE_DPAD_LEFT && event.type === KEY_DOWN) {
      this.nextAlbumClick(index, 'left');
    }
    if (event.keyCode === KEYCODE_DPAD_RIGHT && event.type === KEY_DOWN) {
      this.nextAlbumClick(index, 'right');
    }
    if (event.keyCode === KEYCODE_DPAD_DOWN && event.type === KEY_DOWN) {
      this.nextAlbumClick(index, 'down');
    }
    if (event.keyCode === KEYCODE_DPAD_UP && event.type === KEY_DOWN) {
      this.nextAlbumClick(index, 'up');
    }
    if ((event.keyCode === KEYCODE_DPAD_CENTER || event.keyCode === KEYCODE_ENTER) && event.type === KEY_DOWN) {
      this.selectClient = client;
      this.dialogOpenCount++;
    }
  }

  nextAlbumClick(currentIndex: number, direction: ClientDirection): void {
    const index = this.getNextAlbum(currentIndex, direction);
    if (index !== -1) {
      this.clickFocusBtn(`${CLIENT_PREFIX}${index}`, index);
    }
  }

  getNextAlbum(currentIndex: number, direction: ClientDirection): number {
    const indexs: number[] = [];
    let trueIndex = 0;
    this.clients.forEach((value, index) => {
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
      this.scrollHistory.push(index);
    }
    return isSuccess;
  }

  getFocusHistory(): string[] {
    return this.focusController.getFocusHistory().map((item) => item.focusId);
  }
}

function createClients(count: number): ClientRecord[] {
  const clients: ClientRecord[] = [];
  for (let index = 0; index < count; index++) {
    clients.push(new ClientRecord(`192.168.2.${index + 10}`));
  }
  return clients;
}

function createKeyEvent(keyCode: number, type?: number): KeyEventRecord {
  return new KeyEventRecord(keyCode, type ?? KEY_DOWN);
}

const CLIENT_LOAD_SCENARIOS: ClientLoadScenario[] = [
  new ClientLoadScenario('single_client_load', 1),
  new ClientLoadScenario('double_client_load', 2),
  new ClientLoadScenario('five_client_load', 5)
];

const CLIENT_NEIGHBOR_SCENARIOS: ClientNeighborScenario[] = [
  new ClientNeighborScenario(1, 'left', 0),
  new ClientNeighborScenario(0, 'right', 1),
  new ClientNeighborScenario(0, 'down', 5),
  new ClientNeighborScenario(6, 'left', 5),
  new ClientNeighborScenario(6, 'up', 1),
  new ClientNeighborScenario(6, 'right', -1)
];

const CLIENT_EVENT_MOVE_SCENARIOS: ClientEventMoveScenario[] = [
  new ClientEventMoveScenario(KEYCODE_DPAD_LEFT, 1, 'client_0'),
  new ClientEventMoveScenario(KEYCODE_DPAD_RIGHT, 0, 'client_1'),
  new ClientEventMoveScenario(KEYCODE_DPAD_DOWN, 0, 'client_5'),
  new ClientEventMoveScenario(KEYCODE_DPAD_UP, 6, 'client_1')
];

const DIALOG_KEY_SCENARIOS: DialogKeyScenario[] = [
  new DialogKeyScenario('center_key', KEYCODE_DPAD_CENTER, '192.168.2.11'),
  new DialogKeyScenario('enter_key', KEYCODE_ENTER, '192.168.2.11')
];

const CLIENT_AUTH_SCENARIOS: ClientAuthScenario[] = [
  new ClientAuthScenario('successful_middle_client', 3, 1, Promise.resolve(true), 'dfs_connect_success', 2, 0),
  new ClientAuthScenario('successful_last_client', 1, 0, Promise.resolve(true), 'dfs_connect_success', 0, 1),
  new ClientAuthScenario('failed_result_client', 2, 0, Promise.resolve(false), 'dfs_connect_failed', 2, 0),
  new ClientAuthScenario('thrown_result_client', 2, 0, Promise.reject(new Error('auth fail')), 'dfs_connect_failed', 2, 0)
];

const FOCUS_SCENARIOS: FocusScenario[] = [
  new FocusScenario('client_0', 0),
  new FocusScenario('client_3', 3),
  new FocusScenario('client_6', 6)
];

export default function nasClientInteractionTest() {
  describe('NasClientInteractionTest', () => {
    it('should load nas clients and focus the first card after deferred show flow', 0, async () => {
      const sessionManager = new MockNasSessionManager();
      sessionManager.setFindNasResult(Promise.resolve(createClients(3)));
      const harness = new NasClientHarness(sessionManager);

      await harness.onPageShow();

      expect(harness.loading).assertFalse();
      expect(harness.clients.length).assertEqual(3);
      expect(harness.focusStr).assertEqual('client_0');
      expect(harness.getFocusHistory().length).assertEqual(0);

      harness.flushPendingTasks();

      expect(harness.focusStr).assertEqual('client_0');
      expect(harness.getFocusHistory()[0]).assertEqual('client_0');
    });

    it('should mark find failure state when nas discovery rejects', 0, async () => {
      const sessionManager = new MockNasSessionManager();
      sessionManager.setFindNasResult(Promise.reject(new Error('find fail')));
      const harness = new NasClientHarness(sessionManager);

      await harness.onPageShow();

      expect(harness.loading).assertFalse();
      expect(harness.isNasFindFailed).assertTrue();
      expect(harness.clients.length).assertEqual(0);
    });

    it('should open login dialog when client card is clicked', 0, () => {
      const harness = new NasClientHarness();
      harness.clients = createClients(2);

      harness.onClickClient(1);

      expect(harness.dialogOpenCount).assertEqual(1);
      expect(harness.selectClient?.host).assertEqual('192.168.2.11');
    });

    it('should close dialog and authenticate selected client on confirm', 0, async () => {
      const sessionManager = new MockNasSessionManager();
      const harness = new NasClientHarness(sessionManager);
      harness.clients = createClients(2);
      harness.selectClient = harness.clients[0];

      await harness.onDialogConfirm('tester', '123456');

      expect(harness.dialogCloseCount).assertEqual(1);
      expect(sessionManager.authHistory.length).assertEqual(1);
      expect(sessionManager.authHistory[0].host).assertEqual('192.168.2.10');
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('dfs_connect_success');
      expect(harness.clients.length).assertEqual(1);
    });

    it('should route back after the last client authenticates successfully', 0, async () => {
      const harness = new NasClientHarness();
      harness.clients = createClients(1);
      harness.selectClient = harness.clients[0];

      await harness.authClient('tester', '123456');

      expect(harness.clients.length).assertEqual(0);
      expect(harness.routeBackCount).assertEqual(1);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('dfs_connect_success');
    });

    it('should keep client list when authentication returns false', 0, async () => {
      const sessionManager = new MockNasSessionManager();
      sessionManager.setAuthResult('192.168.2.10', Promise.resolve(false));
      const harness = new NasClientHarness(sessionManager);
      harness.clients = createClients(2);
      harness.selectClient = harness.clients[0];

      await harness.authClient('tester', 'bad');

      expect(harness.clients.length).assertEqual(2);
      expect(harness.progressOpenCount).assertEqual(1);
      expect(harness.progressCloseCount).assertEqual(1);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('dfs_connect_failed');
    });

    it('should keep client list when authentication throws', 0, async () => {
      const sessionManager = new MockNasSessionManager();
      sessionManager.setAuthResult('192.168.2.10', Promise.reject(new Error('auth fail')));
      const harness = new NasClientHarness(sessionManager);
      harness.clients = createClients(2);
      harness.selectClient = harness.clients[0];

      await harness.authClient('tester', 'bad');

      expect(harness.clients.length).assertEqual(2);
      expect(harness.progressOpenCount).assertEqual(1);
      expect(harness.progressCloseCount).assertEqual(1);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('dfs_connect_failed');
    });

    it('should navigate horizontally and vertically across nas clients', 0, () => {
      const harness = new NasClientHarness();
      harness.clients = createClients(7);

      expect(harness.getNextAlbum(0, 'right')).assertEqual(1);
      expect(harness.getNextAlbum(1, 'left')).assertEqual(0);
      expect(harness.getNextAlbum(0, 'down')).assertEqual(5);
      expect(harness.getNextAlbum(6, 'left')).assertEqual(5);
      expect(harness.getNextAlbum(5, 'up')).assertEqual(-1);
    });

    it('should move focus to computed nas client neighbor', 0, () => {
      const harness = new NasClientHarness();
      harness.clients = createClients(7);

      harness.nextAlbumClick(0, 'down');

      expect(harness.focusStr).assertEqual('client_5');
      expect(harness.scrollHistory[harness.scrollHistory.length - 1]).assertEqual(5);
    });

    it('should open login dialog from center and enter key events', 0, () => {
      const harness = new NasClientHarness();
      harness.clients = createClients(2);

      harness.onEvent(1, harness.clients[1], createKeyEvent(KEYCODE_DPAD_CENTER));
      harness.onEvent(0, harness.clients[0], createKeyEvent(KEYCODE_ENTER));

      expect(harness.dialogOpenCount).assertEqual(2);
      expect(harness.selectClient?.host).assertEqual('192.168.2.10');
    });

    it('should ignore non-down key events in client dispatcher', 0, () => {
      const harness = new NasClientHarness();
      harness.clients = createClients(2);

      harness.onEvent(0, harness.clients[0], createKeyEvent(KEYCODE_DPAD_CENTER, KEY_UP));

      expect(harness.dialogOpenCount).assertEqual(0);
      expect(harness.focusStr).assertEqual('client_0');
    });

    it('should keep focus unchanged when neighbor does not exist', 0, () => {
      const harness = new NasClientHarness();
      harness.clients = createClients(2);

      harness.nextAlbumClick(0, 'left');

      expect(harness.focusStr).assertEqual('client_0');
      expect(harness.scrollHistory.length).assertEqual(0);
    });

    it('should keep focus unchanged when target card cannot receive focus', 0, () => {
      const focusController = new MockFocusController();
      focusController.allow(['client_0']);
      const harness = new NasClientHarness(undefined, focusController);
      harness.clients = createClients(3);

      const result = harness.clickFocusBtn('client_2', 2);

      expect(result).assertFalse();
      expect(harness.focusStr).assertEqual('client_0');
      expect(harness.getFocusHistory().length).assertEqual(0);
    });

    CLIENT_LOAD_SCENARIOS.forEach((scenario) => {
      it(`should load client list for ${scenario.name}`, 0, async () => {
        const sessionManager = new MockNasSessionManager();
        sessionManager.setFindNasResult(Promise.resolve(createClients(scenario.count)));
        const harness = new NasClientHarness(sessionManager);

        await harness.onPageShow();
        harness.flushPendingTasks();

        expect(harness.loading).assertFalse();
        expect(harness.clients.length).assertEqual(scenario.count);
        if (scenario.count > 0) {
          expect(harness.focusStr).assertEqual('client_0');
          expect(harness.getFocusHistory()[0]).assertEqual('client_0');
        }
      });
    });

    CLIENT_NEIGHBOR_SCENARIOS.forEach((scenario) => {
      it(`should compute nas client neighbor from ${scenario.currentIndex} using ${scenario.direction}`, 0, () => {
        const harness = new NasClientHarness();
        harness.clients = createClients(7);

        expect(harness.getNextAlbum(scenario.currentIndex, scenario.direction)).assertEqual(scenario.expected);
      });
    });

    CLIENT_EVENT_MOVE_SCENARIOS.forEach((scenario) => {
      it(`should move nas client focus through directional key ${scenario.keyCode}`, 0, () => {
        const harness = new NasClientHarness();
        harness.clients = createClients(7);

        harness.onEvent(scenario.startIndex, harness.clients[scenario.startIndex], createKeyEvent(scenario.keyCode));

        expect(harness.focusStr).assertEqual(scenario.expectedFocus);
      });
    });

    DIALOG_KEY_SCENARIOS.forEach((scenario) => {
      it(`should open authentication dialog from ${scenario.name}`, 0, () => {
        const harness = new NasClientHarness();
        harness.clients = createClients(2);

        harness.onEvent(1, harness.clients[1], createKeyEvent(scenario.keyCode));

        expect(harness.dialogOpenCount).assertEqual(1);
        expect(harness.selectClient?.host).assertEqual(scenario.expectedHost);
      });
    });

    CLIENT_AUTH_SCENARIOS.forEach((scenario) => {
      it(`should authenticate client flow for ${scenario.name}`, 0, async () => {
        const sessionManager = new MockNasSessionManager();
        const harness = new NasClientHarness(sessionManager);
        harness.clients = createClients(scenario.count);
        harness.selectClient = harness.clients[scenario.selectedIndex];
        sessionManager.setAuthResult(harness.selectClient.host, scenario.authResult);

        await harness.authClient('tester', '123456');

        expect(harness.progressOpenCount).assertEqual(1);
        expect(harness.progressCloseCount).assertEqual(1);
        expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual(scenario.expectedToast);
        expect(harness.clients.length).assertEqual(scenario.expectedRemain);
        expect(harness.routeBackCount).assertEqual(scenario.expectedBackCount);
      });
    });

    FOCUS_SCENARIOS.forEach((scenario) => {
      it(`should record focus history for ${scenario.focusId}`, 0, () => {
        const harness = new NasClientHarness();
        harness.clients = createClients(7);

        const result = harness.clickFocusBtn(scenario.focusId, scenario.index);

        expect(result).assertTrue();
        expect(harness.focusStr).assertEqual(scenario.focusId);
        expect(harness.scrollHistory[harness.scrollHistory.length - 1]).assertEqual(scenario.index);
      });
    });
  });
}
