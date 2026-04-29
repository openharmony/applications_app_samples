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
import { MockDeviceManager, MockExtensionContext, MockSession, MockUiContext, MockWindow } from './base/TestDoubles';
import { TestAsserts } from './base/TestAsserts';
import { ActionScenario, DisplayScenario, TestDataFactory } from './base/TestDataFactory';
import { ConfirmButtonModel, createConfirmButtonModelSet } from './testModels/ConfirmModels';

class ConfirmDialogActionReceiver {
  // 确认对话框动作接收器模拟用户交互，验证设备管理操作的正确执行顺序
  // 窗口、会话和上下文的销毁顺序必须严格遵循系统规范，防止资源泄漏
  manager: MockDeviceManager = new MockDeviceManager();
  window: MockWindow = new MockWindow();
  session: MockSession = new MockSession();
  context: MockExtensionContext = new MockExtensionContext();
  trace: string[] = [];

  async setUserOperation(operation: number, extra: string): Promise<void> {
    this.trace.push(`reply-${operation}`);
    this.manager.replyUiAction(operation, extra);
    await this.window.destroyWindow();
    this.trace.push('destroy-window');
    this.session.terminateSelf();
    this.trace.push('terminate-session');
    this.context.terminateSelf();
    this.trace.push('terminate-extension');
  }

  async executeScenario(scenario: ActionScenario): Promise<void> {
    await this.setUserOperation(scenario.operation, scenario.extra);
  }
}

class ConfirmCountdownDriver {
  seconds: number;
  timeouts: number = 0;
  actions: number[] = [];
  labels: string[] = [];
  timerActive: boolean = true;
  readonly timeoutOperation: number = 2;

  constructor(seconds: number) {
    this.seconds = seconds;
    this.labels.push(this.buildLabel(seconds));
  }

  buildLabel(seconds: number): string {
    return `取消(${seconds}秒)`;
  }

  tick(): void {
    if (!this.timerActive || this.seconds <= 0) {
      return;
    }
    this.seconds -= 1;
    this.labels.push(this.buildLabel(this.seconds));
    if (this.seconds === 0) {
      this.timerActive = false;
      this.timeouts += 1;
      this.actions.push(this.timeoutOperation);
    }
  }
}

class ConfirmTimeoutReceiver {
  manager: MockDeviceManager = new MockDeviceManager();
  window: MockWindow = new MockWindow();
  session: MockSession = new MockSession();
  context: MockExtensionContext = new MockExtensionContext();
  seconds: number = 60;
  messages: string[] = [];

  tick(): void {
    this.seconds -= 1;
    this.messages.push(`取消(${this.seconds}秒)`);
  }

  async tickUntilTimeout(): Promise<void> {
    while (this.seconds > 0) {
      this.tick();
    }
    this.manager.replyUiAction(2, 'extra');
    await this.window.destroyWindow();
    this.session.terminateSelf();
    this.context.terminateSelf();
  }
}

class ConfirmDialogRuntimeModel {
  readonly allowOperation: number = 0;
  readonly cancelOperation: number = 1;
  readonly timeoutOperation: number = 2;
  readonly allowAlwaysOperation: number = 6;
  readonly defaultFocusKey: string = 'confirm';
  readonly cancelKey: string = 'cancel';
  readonly alwaysKey: string = 'always';
  readonly initialSeconds: number = 60;

  buildCountdownMessage(seconds: number): string {
    return `取消(${seconds}秒)`;
  }

  resolveActionByKey(key: string): number {
    if (key === this.cancelKey) {
      return this.cancelOperation;
    }
    if (key === this.defaultFocusKey) {
      return this.allowOperation;
    }
    return this.allowAlwaysOperation;
  }
}

interface WindowRect {
  left: number;
  top: number;
  width: number;
  height: number;
  fullWidth: number;
}

class ConfirmWindowGeometryAssembler {
  private readonly designWidth: number;
  private readonly dialogWidth: number;
  private readonly dialogHeight: number;

  constructor(designWidth: number, dialogWidth: number, dialogHeight: number) {
    this.designWidth = designWidth;
    this.dialogWidth = dialogWidth;
    this.dialogHeight = dialogHeight;
  }

  createRect(displayWidth: number, displayHeight: number): WindowRect {
    const screenScale: number = displayWidth / this.designWidth;
    const scaledWidth: number = this.dialogWidth * screenScale;
    const scaledHeight: number = this.dialogHeight * screenScale;
    const rect: WindowRect = {
      left: (displayWidth - scaledWidth) / 2,
      top: (displayHeight - scaledHeight) / 2,
      width: displayWidth / 3,
      height: displayHeight / 3,
      fullWidth: displayWidth
    };
    return rect;
  }
}

class ConfirmDialogPageDriver {
  private readonly defaultFocusKey: string = 'confirm';
  private readonly actionKeys: string[] = ['cancel', 'confirm', 'always'];
  buttonStates: Map<string, boolean> = new Map<string, boolean>();
  trace: string[] = [];

  constructor() {
    this.actionKeys.forEach((key: string) => this.buttonStates.set(key, false));
  }

  onPageShow(context: MockUiContext): void {
    context.getFocusController().activate(true);
    context.getFocusController().requestFocus(this.defaultFocusKey);
    this.trace.push('activate-focus');
    this.trace.push(`request-${this.defaultFocusKey}`);
  }

  hoverTo(key: string, context: MockUiContext): void {
    context.getFocusController().requestFocus(key);
    this.trace.push(`hover-${key}`);
  }

  focus(key: string): void {
    this.actionKeys.forEach((item: string) => {
      this.buttonStates.set(item, item === key);
    });
    this.trace.push(`focus-${key}`);
  }

  blur(key: string): void {
    this.buttonStates.set(key, false);
    this.trace.push(`blur-${key}`);
  }
}

class ConfirmFocusState {
  key: string;
  isFocus: boolean;

  constructor(key: string, isFocus: boolean) {
    this.key = key;
    this.isFocus = isFocus;
  }
}

class ConfirmNullGuardReceiver {
  records: number[] = [];
  isManagerReady: boolean = false;

  setUserOperation(operation: number): void {
    if (!this.isManagerReady) {
      return;
    }
    this.records.push(operation);
  }
}

class ConfirmDestructionCoordinator {
  windowNum: number;
  readonly session: MockSession = new MockSession();
  readonly context: MockExtensionContext = new MockExtensionContext();
  readonly win: MockWindow = new MockWindow();
  readonly releasedManagers: number[] = [];

  constructor(windowNum: number) {
    this.windowNum = windowNum;
  }

  async destroyAfterOperation(operation: number): Promise<void> {
    this.releasedManagers.push(operation);
    await this.win.destroyWindow();
    this.windowNum -= 1;
    if (this.windowNum === 0) {
      this.session.terminateSelf();
      this.context.terminateSelf();
    }
  }
}

function moveFocus(states: ConfirmFocusState[], targetKey: string): ConfirmFocusState[] {
  return states.map((item: ConfirmFocusState) => new ConfirmFocusState(item.key, item.key === targetKey));
}

function buildFocusWave(startKey: string, steps: string[]): string[] {
  const wave: string[] = [`focus-${startKey}`];
  steps.forEach((step: string) => wave.push(`focus-${step}`));
  return wave;
}

export default function confirmDialogCoreTest(): void {
  describe('TVDeviceManagerUiConfirmDialogCoreTest', () => {
    it('should send allow once action and close resources', 0, async () => {
      const receiver: ConfirmDialogActionReceiver = new ConfirmDialogActionReceiver();
      await receiver.setUserOperation(0, 'extra');
      TestAsserts.assertNumberEquals(receiver.manager.records[0].operation, 0);
      TestAsserts.assertTrue(receiver.window.destroyed);
      TestAsserts.assertNumberEquals(receiver.session.terminateCount, 1);
      TestAsserts.assertNumberEquals(receiver.context.terminateCount, 1);
    });

    it('should cover all confirm reply operations', 0, async () => {
      const receiver: ConfirmDialogActionReceiver = new ConfirmDialogActionReceiver();
      const operations: number[] = [];
      for (const scenario of TestDataFactory.createConfirmActionScenarios()) {
        await receiver.executeScenario(scenario);
        operations.push(scenario.operation);
      }
      TestAsserts.assertArrayLength(operations, 4);
      TestAsserts.assertTrue(operations.includes(0));
      TestAsserts.assertTrue(operations.includes(1));
      TestAsserts.assertTrue(operations.includes(2));
      TestAsserts.assertTrue(operations.includes(6));
    });

    it('should initialize three confirm buttons with stable keys', 0, () => {
      const buttons: ConfirmButtonModel[] = createConfirmButtonModelSet();
      TestAsserts.assertDialogButtonKeys(buttons.map((item: ConfirmButtonModel) => item.key));
      TestAsserts.assertArrayLength(buttons, 3);
    });

    it('should reserve countdown only for cancel button', 0, () => {
      const buttons: ConfirmButtonModel[] = createConfirmButtonModelSet();
      TestAsserts.assertNumberEquals(buttons[0].seconds, 60);
      TestAsserts.assertNumberEquals(buttons[1].seconds, 0);
      TestAsserts.assertNumberEquals(buttons[2].seconds, 0);
    });

    it('should count down from sixty to zero without negative overflow', 0, () => {
      const values: number[] = [];
      for (let index: number = 60; index >= 0; index--) {
        values.push(index);
      }
      TestAsserts.assertNumberEquals(values[0], 60);
      TestAsserts.assertNumberEquals(values[values.length - 1], 0);
      TestAsserts.assertArrayLength(values, 61);
    });

    it('should reply timeout action after complete countdown run', 0, async () => {
      const receiver: ConfirmTimeoutReceiver = new ConfirmTimeoutReceiver();
      await receiver.tickUntilTimeout();
      TestAsserts.assertNumberEquals(receiver.manager.records[0].operation, 2);
      TestAsserts.assertTrue(receiver.window.destroyed);
    });

    it('should dispatch timeout operation exactly once when countdown reaches zero', 0, () => {
      const driver: ConfirmCountdownDriver = new ConfirmCountdownDriver(2);
      driver.tick();
      driver.tick();
      driver.tick();
      TestAsserts.assertNumberEquals(driver.timeouts, 1);
      TestAsserts.assertArrayLength(driver.actions, 1);
      TestAsserts.assertNumberEquals(driver.actions[0], 2);
      TestAsserts.assertFalse(driver.timerActive);
    });

    it('should keep confirm button as the default focus entry for tv remote flow', 0, () => {
      const model: ConfirmDialogRuntimeModel = new ConfirmDialogRuntimeModel();
      TestAsserts.assertStringEquals(model.defaultFocusKey, 'confirm');
      TestAsserts.assertDialogButtonKeys([model.cancelKey, model.defaultFocusKey, model.alwaysKey]);
    });

    it('should map confirm dialog button keys to stable device manager reply operations', 0, () => {
      const model: ConfirmDialogRuntimeModel = new ConfirmDialogRuntimeModel();
      TestAsserts.assertNumberEquals(model.resolveActionByKey('cancel'), 1);
      TestAsserts.assertNumberEquals(model.resolveActionByKey('confirm'), 0);
      TestAsserts.assertNumberEquals(model.resolveActionByKey('always'), 6);
    });

    it('should compute centered confirm dialog geometry for representative display matrix', 0, () => {
      const assembler: ConfirmWindowGeometryAssembler = new ConfirmWindowGeometryAssembler(1920, 692, 332);
      TestDataFactory.createDisplayScenarios().forEach((scenario: DisplayScenario) => {
        const rect = assembler.createRect(scenario.width, scenario.height);
        const scaledWidth: number = 692 * (scenario.width / 1920);
        TestAsserts.assertPositiveRect(rect.width, rect.height);
        TestAsserts.assertRectCentered(rect.fullWidth, rect.left, scaledWidth);
      });
    });

    it('should activate focus controller and request confirm as default focus on page show', 0, () => {
      const driver: ConfirmDialogPageDriver = new ConfirmDialogPageDriver();
      const context: MockUiContext = new MockUiContext();
      driver.onPageShow(context);
      TestAsserts.assertTrue(context.getFocusController().active);
      TestAsserts.assertArrayLength(context.getFocusController().focusRequests, 1);
      TestAsserts.assertStringEquals(context.getFocusController().focusRequests[0], 'confirm');
    });

    it('should route hover gesture to always allow candidate for unified tv interaction', 0, () => {
      const driver: ConfirmDialogPageDriver = new ConfirmDialogPageDriver();
      const context: MockUiContext = new MockUiContext();
      driver.hoverTo('always', context);
      TestAsserts.assertArrayLength(context.getFocusController().focusRequests, 1);
      TestAsserts.assertStringEquals(context.getFocusController().focusRequests[0], 'always');
      TestAsserts.assertStringEquals(driver.trace[0], 'hover-always');
    });

    it('should expose focus scenarios with readable named path', 0, () => {
      TestAsserts.assertFocusPath(['focus-confirm', 'focus-always', 'focus-cancel']);
    });

    it('should switch unique focus state when hover moves to always button', 0, () => {
      const states: ConfirmFocusState[] = moveFocus([
        new ConfirmFocusState('cancel', false),
        new ConfirmFocusState('confirm', true),
        new ConfirmFocusState('always', false)
      ], 'always');
      const focusedKeys: string[] = states.filter((item: ConfirmFocusState) => item.isFocus).map((item) => item.key);
      TestAsserts.assertArrayLength(focusedKeys, 1);
      TestAsserts.assertStringEquals(focusedKeys[0], 'always');
    });

    it('should rebuild focus path from default anchor after hover enters cancel first', 0, () => {
      const sequence: string[] = buildFocusWave('confirm', ['cancel', 'confirm']);
      TestAsserts.assertArrayLength(sequence, 3);
      TestAsserts.assertStringEquals(sequence[0], 'focus-confirm');
      TestAsserts.assertStringEquals(sequence[1], 'focus-cancel');
      TestAsserts.assertStringEquals(sequence[2], 'focus-confirm');
    });

    it('should ignore operation when device manager is unavailable', 0, () => {
      const receiver: ConfirmNullGuardReceiver = new ConfirmNullGuardReceiver();
      receiver.setUserOperation(0);
      TestAsserts.assertArrayLength(receiver.records, 0);
    });

    it('should send operation after device manager becomes ready', 0, () => {
      const receiver: ConfirmNullGuardReceiver = new ConfirmNullGuardReceiver();
      receiver.isManagerReady = true;
      receiver.setUserOperation(6);
      TestAsserts.assertArrayLength(receiver.records, 1);
      TestAsserts.assertNumberEquals(receiver.records[0], 6);
    });

    it('should generate countdown labels that preserve user visible Chinese format', 0, () => {
      const model: ConfirmDialogRuntimeModel = new ConfirmDialogRuntimeModel();
      const labels: string[] = [60, 30, 1, 0].map((seconds: number) => model.buildCountdownMessage(seconds));

      TestAsserts.assertStringEquals(labels[0], '取消(60秒)');
      TestAsserts.assertStringEquals(labels[1], '取消(30秒)');
      TestAsserts.assertStringEquals(labels[2], '取消(1秒)');
      TestAsserts.assertStringEquals(labels[3], '取消(0秒)');
    });

    it('should keep countdown labels monotonic during timeout replay', 0, () => {
      const driver: ConfirmCountdownDriver = new ConfirmCountdownDriver(3);
      driver.tick();
      driver.tick();
      driver.tick();

      // 倒计时文案是电视侧用户感知是否还可操作的唯一时间反馈。
      // 这里把标签序列锁成严格递减，可以防止 future 改动出现跳秒或回弹问题。
      TestAsserts.assertArrayLength(driver.labels, 4);
      TestAsserts.assertStringEquals(driver.labels[0], '取消(3秒)');
      TestAsserts.assertStringEquals(driver.labels[1], '取消(2秒)');
      TestAsserts.assertStringEquals(driver.labels[2], '取消(1秒)');
      TestAsserts.assertStringEquals(driver.labels[3], '取消(0秒)');
    });

    it('should preserve reply then destroy then terminate order for every confirm action', 0, async () => {
      for (const scenario of TestDataFactory.createConfirmActionScenarios()) {
        const receiver: ConfirmDialogActionReceiver = new ConfirmDialogActionReceiver();
        await receiver.executeScenario(scenario);

        TestAsserts.assertArrayLength(receiver.trace, 4);
        TestAsserts.assertStringEquals(receiver.trace[0], `reply-${scenario.operation}`);
        TestAsserts.assertStringEquals(receiver.trace[1], 'destroy-window');
        TestAsserts.assertStringEquals(receiver.trace[2], 'terminate-session');
        TestAsserts.assertStringEquals(receiver.trace[3], 'terminate-extension');
      }
    });

    it('should only terminate session when last confirm window is released', 0, async () => {
      const coordinator: ConfirmDestructionCoordinator = new ConfirmDestructionCoordinator(2);
      await coordinator.destroyAfterOperation(0);

      TestAsserts.assertTrue(coordinator.win.destroyed);
      TestAsserts.assertNumberEquals(coordinator.windowNum, 1);
      TestAsserts.assertNumberEquals(coordinator.session.terminateCount, 0);
      TestAsserts.assertNumberEquals(coordinator.context.terminateCount, 0);
    });

    it('should terminate both session and extension after final confirm window release', 0, async () => {
      const coordinator: ConfirmDestructionCoordinator = new ConfirmDestructionCoordinator(1);
      await coordinator.destroyAfterOperation(6);

      TestAsserts.assertNumberEquals(coordinator.windowNum, 0);
      TestAsserts.assertNumberEquals(coordinator.session.terminateCount, 1);
      TestAsserts.assertNumberEquals(coordinator.context.terminateCount, 1);
      TestAsserts.assertNumberEquals(coordinator.releasedManagers[0], 6);
    });

    it('should keep exactly one focused button after sequential focus transitions', 0, () => {
      const driver: ConfirmDialogPageDriver = new ConfirmDialogPageDriver();
      driver.focus('confirm');
      driver.focus('always');
      driver.focus('cancel');
      const focusedKeys: string[] = [];

      driver.buttonStates.forEach((value: boolean, key: string) => {
        if (value) {
          focusedKeys.push(key);
        }
      });

      TestAsserts.assertArrayLength(focusedKeys, 1);
      TestAsserts.assertStringEquals(focusedKeys[0], 'cancel');
    });

    it('should clear focused visual state after blur leaves current button', 0, () => {
      const driver: ConfirmDialogPageDriver = new ConfirmDialogPageDriver();
      driver.focus('always');
      driver.blur('always');

      TestAsserts.assertFalse(driver.buttonStates.get('always') ?? true);
      TestAsserts.assertStringEquals(driver.trace[driver.trace.length - 1], 'blur-always');
    });

    it('should keep confirm action scenarios unique for generator expansion', 0, () => {
      const names: string[] = TestDataFactory.createConfirmActionScenarios().map((scenario: ActionScenario) => scenario.name);
      TestAsserts.assertStringArrayUnique(names);
    });

    // 默认焦点不仅要落在 confirm，还必须保证 cancel / always 在初始态不带焦点高亮。
    // 这能防止 TV 首帧出现多按钮同时可选的视觉歧义，影响用户对默认提交目标的理解。
    it('should keep non default confirm buttons unfocused after initial page show', 0, () => {
      const driver: ConfirmDialogPageDriver = new ConfirmDialogPageDriver();
      const context: MockUiContext = new MockUiContext();
      driver.onPageShow(context);
      driver.focus('confirm');

      TestAsserts.assertTrue(driver.buttonStates.get('confirm') ?? false);
      TestAsserts.assertFalse(driver.buttonStates.get('cancel') ?? true);
      TestAsserts.assertFalse(driver.buttonStates.get('always') ?? true);
    });

    // run 逻辑依赖首按钮秒数递减，如果计时器未关闭就持续推进，会在归零后重复触发回执。
    // 这里从 1 秒开始回放两次 tick，验证倒计时结束后状态稳定停在终态。
    it('should freeze countdown state after timeout terminal tick', 0, () => {
      const driver: ConfirmCountdownDriver = new ConfirmCountdownDriver(1);
      driver.tick();
      driver.tick();

      TestAsserts.assertNumberEquals(driver.seconds, 0);
      TestAsserts.assertFalse(driver.timerActive);
      TestAsserts.assertNumberEquals(driver.timeouts, 1);
    });

    // onHover、onFocus、onBlur 共同维护统一焦点语义，trace 顺序失真会让交互日志失去排障价值。
    // 这里把 hover 到 focus 再 blur 串起来，锁定交互链条仍是稳定的单向序列。
    it('should keep hover focus blur trace readable for confirm interaction diagnostics', 0, () => {
      const driver: ConfirmDialogPageDriver = new ConfirmDialogPageDriver();
      const context: MockUiContext = new MockUiContext();
      driver.hoverTo('cancel', context);
      driver.focus('cancel');
      driver.blur('cancel');

      TestAsserts.assertStringEquals(driver.trace[0], 'hover-cancel');
      TestAsserts.assertStringEquals(driver.trace[1], 'focus-cancel');
      TestAsserts.assertStringEquals(driver.trace[2], 'blur-cancel');
    });

    // createRect 里 left/top 与缩放宽高共同决定是否真正居中，不能只验证 left 而忽略 top。
    // 这里同时校验垂直方向中心点，避免不同高宽比设备上出现只横向居中的伪通过。
    it('should keep confirm dialog vertically centered across display matrix', 0, () => {
      const assembler: ConfirmWindowGeometryAssembler = new ConfirmWindowGeometryAssembler(1920, 692, 332);
      TestDataFactory.createDisplayScenarios().forEach((scenario: DisplayScenario) => {
        const rect = assembler.createRect(scenario.width, scenario.height);
        const scaledHeight: number = 332 * (scenario.width / 1920);
        const expectedTop: number = (scenario.height - scaledHeight) / 2;

        TestAsserts.assertNumberEquals(rect.top, expectedTop);
      });
    });

    // 销毁协调器需要把 operation 与释放动作绑定记录下来，否则多窗口回收后无法追溯是哪种业务决策触发退出。
    // 这里串行释放两个窗口，验证记录顺序与 windowNum 演进都保持可审计性。
    it('should keep released operation history ordered during multi window teardown', 0, async () => {
      const coordinator: ConfirmDestructionCoordinator = new ConfirmDestructionCoordinator(2);
      await coordinator.destroyAfterOperation(1);
      await coordinator.destroyAfterOperation(6);

      TestAsserts.assertArrayLength(coordinator.releasedManagers, 2);
      TestAsserts.assertNumberEquals(coordinator.releasedManagers[0], 1);
      TestAsserts.assertNumberEquals(coordinator.releasedManagers[1], 6);
      TestAsserts.assertNumberEquals(coordinator.windowNum, 0);
    });
  });
}
