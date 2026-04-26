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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { window } from '@kit.ArkUI';
import { floatWindowManager } from '../../../../main/ets/utils/FloatWindowManager';
import { WindowMoverManager } from '../../../../main/ets/utils/WindowMoverManager';

interface MockWindow {
  resize(width: number, height: number): Promise<void>;
  show(): Promise<void>;
  destroyWindow(): Promise<void>;
  setWindowFocusable(isFocusable: boolean): Promise<void>;
  setWindowSystemBarEnable(names: Array<string>): Promise<void>;
  setWindowLayoutFullScreen(isFullScreen: boolean): Promise<void>;
  setUIContent(path: string): Promise<void>;
  moveWindowTo(x: number, y: number): Promise<void>;
  getWindowProperties(): Promise<MockWindowProperties>;
}

interface MockWindowRect {
  left: number;
  top: number;
}

interface MockWindowProperties {
  windowRect: MockWindowRect;
}

interface FloatWindowManagerState {
  windowInstance: window.Window | null;
  currentX: number;
  currentY: number;
  windowWidth: number;
  windowHeight: number;
  hasInstance(): boolean;
  getInstance(): window.Window | null;
  moveTo(x?: number, y?: number, useAnimation?: boolean): Promise<void>;
  resize(width?: number, height?: number): Promise<void>;
  show(): Promise<void>;
  hide(): Promise<void>;
  destroy(): Promise<void>;
  focusWindow(isFocusable: boolean): Promise<void>;
  setContent(): Promise<void>;
}

interface FloatWindowManagerInternals extends FloatWindowManagerState {
  isDestroyed: boolean;
  initializeWindow(): Promise<void>;
  setWindowProperties(): Promise<void>;
}

class MockWindowImpl implements MockWindow {
  callOrder: string[];
  resizeCalls: number[][];
  moveCalls: number[][];
  focusStates: boolean[];
  systemBarCalls: string[][];
  fullScreenStates: boolean[];
  contentPaths: string[];
  currentX: number = 0;
  currentY: number = 0;

  constructor(
    callOrder: string[],
    resizeCalls: number[][],
    moveCalls: number[][],
    focusStates: boolean[],
    systemBarCalls: string[][],
    fullScreenStates: boolean[],
    contentPaths: string[]
  ) {
    this.callOrder = callOrder;
    this.resizeCalls = resizeCalls;
    this.moveCalls = moveCalls;
    this.focusStates = focusStates;
    this.systemBarCalls = systemBarCalls;
    this.fullScreenStates = fullScreenStates;
    this.contentPaths = contentPaths;
  }

  async resize(width: number, height: number): Promise<void> {
    this.callOrder.push('resize');
    this.resizeCalls.push([width, height]);
  }

  async show(): Promise<void> {
    this.callOrder.push('show');
  }

  async destroyWindow(): Promise<void> {
    this.callOrder.push('destroyWindow');
  }

  async setWindowFocusable(isFocusable: boolean): Promise<void> {
    this.callOrder.push('setWindowFocusable');
    this.focusStates.push(isFocusable);
  }

  async setWindowSystemBarEnable(names: Array<string>): Promise<void> {
    this.callOrder.push('setWindowSystemBarEnable');
    this.systemBarCalls.push(names);
  }

  async setWindowLayoutFullScreen(isFullScreen: boolean): Promise<void> {
    this.callOrder.push('setWindowLayoutFullScreen');
    this.fullScreenStates.push(isFullScreen);
  }

  async setUIContent(path: string): Promise<void> {
    this.callOrder.push('setUIContent');
    this.contentPaths.push(path);
  }

  async moveWindowTo(x: number, y: number): Promise<void> {
    this.callOrder.push('moveWindowTo');
    this.currentX = x;
    this.currentY = y;
    this.moveCalls.push([x, y]);
  }

  async getWindowProperties(): Promise<MockWindowProperties> {
    return {
      windowRect: {
        left: this.currentX,
        top: this.currentY
      }
    };
  }
}

/**
 * 把测试桩转成窗口类型。
 * @param mockWindow 窗口桩对象
 * @returns 供管理器使用的窗口实例
 */
function asWindow(mockWindow: MockWindow): window.Window {
  return mockWindow as Object as window.Window;
}

/**
 * 创建可记录调用轨迹的窗口桩。
 * @param callOrder 方法调用顺序记录器
 * @param resizeCalls 尺寸调用记录器
 * @param focusStates 聚焦参数记录器
 * @param systemBarCalls 系统栏配置记录器
 * @param fullScreenStates 全屏配置记录器
 * @param contentPaths 内容路径记录器
 * @returns 符合窗口最小契约的测试桩
 */
function createMockWindow(
  callOrder: string[],
  resizeCalls: number[][],
  moveCalls: number[][],
  focusStates: boolean[],
  systemBarCalls: string[][],
  fullScreenStates: boolean[],
  contentPaths: string[]
): MockWindowImpl {
  return new MockWindowImpl(
    callOrder,
    resizeCalls,
    moveCalls,
    focusStates,
    systemBarCalls,
    fullScreenStates,
    contentPaths
  );
}

/**
 * 统一抓取异步方法抛出的错误信息。
 * @param action 需要执行的异步动作
 * @returns 错误消息，未抛错则返回空字符串
 */
async function captureErrorMessage(action: () => Promise<void>): Promise<string> {
  try {
    await action();
    return '';
  } catch (error) {
    let caught = error as Error;
    return caught.message;
  }
}

/**
 * 让动画循环至少推进一帧，避免在同一事件循环内过早断言。
 * @param delayMs 等待时长（毫秒）
 * @returns Promise<void>
 */
function waitForAnimationTick(delayMs: number = 30): Promise<void> {
  return new Promise<void>((resolve) => {
    setTimeout(() => {
      resolve();
    }, delayMs);
  });
}

export default function FloatWindowManagerTest() {
  describe('FloatWindowManagerTest', () => {
    let manager: FloatWindowManagerInternals = floatWindowManager as Object as FloatWindowManagerInternals;

    beforeEach(() => {
      // 业务背景：悬浮窗管理器是进程级单例，位置、实例和销毁态都会跨测试残留。
      // 每条用例前强制回到初始状态，才能确认断言来自当前路径而不是历史副作用。
      manager.windowInstance = null;
      manager.currentX = 300;
      manager.currentY = 300;
      manager.windowWidth = 300;
      manager.windowHeight = 300;
      manager.isDestroyed = false;
    });

    afterEach(() => {
      manager.windowInstance = null;
      manager.isDestroyed = false;
      WindowMoverManager.stop();
    });

    it('FloatWindowManager_HasInstance_ReflectsEmptySingletonState_001', 0, () => {
      // 业务背景：页面层会先探测悬浮窗是否已创建，再决定复用还是新建。
      // 这里固定空实例语义，防止 hasInstance 被悄悄改成只看对象引用存在。
      expect(manager.hasInstance()).assertEqual(false);
      expect(manager.getInstance()).assertEqual(null);
    });

    it('FloatWindowManager_HasInstance_HidesDestroyedWindow_002', 0, () => {
      // 业务背景：销毁后的窗口对象可能短时间还残留在字段里，但业务上必须视为不可用。
      // 这条用例防止“残留引用仍被当成活实例”导致重复操作已失效窗口。
      let callOrder: string[] = [];
      let resizeCalls: number[][] = [];
      let focusStates: boolean[] = [];
      let systemBarCalls: string[][] = [];
      let fullScreenStates: boolean[] = [];
      let contentPaths: string[] = [];
      manager.windowInstance = asWindow(createMockWindow(
        callOrder,
        resizeCalls,
        [],
        focusStates,
        systemBarCalls,
        fullScreenStates,
        contentPaths
      ));
      manager.isDestroyed = true;
      expect(manager.getInstance() !== null).assertTrue();
      expect(manager.hasInstance()).assertEqual(false);
    });

    it('FloatWindowManager_MoveTo_UsesAnimatedMoverAndPersistsCoordinates_003', 0, async () => {
      // 业务背景：拖拽移动走动画分支时，既要调用平滑移动器，也要更新内部坐标快照。
      // 若只验证其中一侧，后续页面重开时就可能出现视觉位置和持久化位置不一致。
      let moveCalls: number[][] = [];
      let mockWindow = createMockWindow([], [], moveCalls, [], [], [], []);
      manager.windowInstance = asWindow(mockWindow);
      await manager.moveTo(120, 240, true);
      await waitForAnimationTick();
      expect(manager.currentX).assertEqual(120);
      expect(manager.currentY).assertEqual(240);
      expect(moveCalls.length > 0).assertTrue();
      expect(mockWindow.currentX > 0).assertTrue();
      expect(mockWindow.currentY > 0).assertTrue();
    });

    it('FloatWindowManager_MoveTo_UsesImmediateMoverWhenAnimationDisabled_004', 0, async () => {
      // 业务背景：初始化和纠偏场景要求窗口直接就位，不能被动画分支拖慢首帧稳定性。
      // 这条用例把两条依赖路径显式区分开，防止参数开关失效后全都走动画逻辑。
      let moveCalls: number[][] = [];
      let mockWindow = createMockWindow([], [], moveCalls, [], [], [], []);
      manager.windowInstance = asWindow(mockWindow);
      await manager.moveTo(66, 88, false);
      expect(moveCalls.length).assertEqual(1);
      expect(moveCalls[0][0]).assertEqual(66);
      expect(moveCalls[0][1]).assertEqual(88);
      expect(manager.currentX).assertEqual(66);
      expect(manager.currentY).assertEqual(88);
    });

    it('FloatWindowManager_Resize_ForwardsWidthAndHeightToWindow_005', 0, async () => {
      // 业务背景：悬浮窗尺寸会随设备规格切换，真正重要的是参数能完整透传到底层窗口。
      // 若这里只改了管理器内部字段而没落到底层，页面内容会一直停留在旧尺寸。
      let callOrder: string[] = [];
      let resizeCalls: number[][] = [];
      let focusStates: boolean[] = [];
      let systemBarCalls: string[][] = [];
      let fullScreenStates: boolean[] = [];
      let contentPaths: string[] = [];
      manager.windowInstance = asWindow(createMockWindow(
        callOrder,
        resizeCalls,
        [],
        focusStates,
        systemBarCalls,
        fullScreenStates,
        contentPaths
      ));
      await manager.resize(640, 360);
      expect(callOrder.length).assertEqual(1);
      expect(callOrder[0]).assertEqual('resize');
      expect(resizeCalls.length).assertEqual(1);
      expect(resizeCalls[0][0]).assertEqual(640);
      expect(resizeCalls[0][1]).assertEqual(360);
    });

    it('FloatWindowManager_SetWindowProperties_DisablesSystemBarsAndFullscreen_006', 0, async () => {
      // 业务背景：悬浮窗必须剥离系统栏和全屏属性，才能保持工具窗而不是沉浸式主窗口体验。
      // 这条测试固定初始化时的窗口属性契约，避免后续样式调整破坏浮窗定位。
      let callOrder: string[] = [];
      let resizeCalls: number[][] = [];
      let focusStates: boolean[] = [];
      let systemBarCalls: string[][] = [];
      let fullScreenStates: boolean[] = [];
      let contentPaths: string[] = [];
      manager.windowInstance = asWindow(createMockWindow(
        callOrder,
        resizeCalls,
        [],
        focusStates,
        systemBarCalls,
        fullScreenStates,
        contentPaths
      ));
      await manager.setWindowProperties();
      expect(callOrder.length).assertEqual(2);
      expect(callOrder[0]).assertEqual('setWindowSystemBarEnable');
      expect(callOrder[1]).assertEqual('setWindowLayoutFullScreen');
      expect(systemBarCalls.length).assertEqual(1);
      expect(systemBarCalls[0].length).assertEqual(0);
      expect(fullScreenStates.length).assertEqual(1);
      expect(fullScreenStates[0]).assertEqual(false);
    });

    it('FloatWindowManager_SetContent_LoadsFloatWindowPage_007', 0, async () => {
      // 业务背景：浮窗真正展示的不是任意页面，而是固定的 `floatWindowPage`。
      // 锁定该入口路径后，后续若改错页面名能在测试阶段直接暴露。
      let contentPaths: string[] = [];
      manager.windowInstance = asWindow(createMockWindow([], [], [], [], [], [], contentPaths));
      await manager.setContent();
      expect(contentPaths.length).assertEqual(1);
      expect(contentPaths[0]).assertEqual('pages/floatWindowPage');
    });

    it('FloatWindowManager_FocusWindow_ForwardsFocusableFlag_008', 0, async () => {
      // 业务背景：浮窗是否可聚焦会直接影响遥控器和按键事件是否落到悬浮窗上。
      // 这里验证布尔值原样透传，避免正反语义在封装层被意外翻转。
      let focusStates: boolean[] = [];
      manager.windowInstance = asWindow(createMockWindow([], [], [], focusStates, [], [], []));
      await manager.focusWindow(true);
      await manager.focusWindow(false);
      expect(focusStates.length).assertEqual(2);
      expect(focusStates[0]).assertEqual(true);
      expect(focusStates[1]).assertEqual(false);
    });

    it('FloatWindowManager_InitializeWindow_RunsStableSetupSequence_009', 0, async () => {
      // 业务背景：初始化链路包含尺寸、位置、属性、内容和显示五个阶段，顺序错了就会出现闪烁或空白窗。
      // 直接守住编排顺序，比只看最终结果更能拦住回归。
      let sequence: string[] = [];
      let mockWindow = createMockWindow(sequence, [], [], [], [], [], []);
      manager.windowInstance = asWindow(mockWindow);
      await manager.initializeWindow();
      expect(sequence.length).assertEqual(6);
      expect(sequence[0]).assertEqual('resize');
      expect(sequence[1]).assertEqual('moveWindowTo');
      expect(sequence[2]).assertEqual('setWindowSystemBarEnable');
      expect(sequence[3]).assertEqual('setWindowLayoutFullScreen');
      expect(sequence[4]).assertEqual('setUIContent');
      expect(sequence[5]).assertEqual('show');
    });

    it('FloatWindowManager_Destroy_ClearsInstanceAndMarksDestroyed_010', 0, async () => {
      // 业务背景：销毁是释放浮窗资源的唯一出口，必须同时清空引用并更新生命周期状态。
      // 若只做其一，业务层要么重复操作旧对象，要么永远无法重新创建新窗口。
      let callOrder: string[] = [];
      let resizeCalls: number[][] = [];
      let focusStates: boolean[] = [];
      let systemBarCalls: string[][] = [];
      let fullScreenStates: boolean[] = [];
      let contentPaths: string[] = [];
      manager.windowInstance = asWindow(createMockWindow(
        callOrder,
        resizeCalls,
        [],
        focusStates,
        systemBarCalls,
        fullScreenStates,
        contentPaths
      ));
      await manager.destroy();
      expect(callOrder.length).assertEqual(1);
      expect(callOrder[0]).assertEqual('destroyWindow');
      expect(manager.getInstance()).assertEqual(null);
      expect(manager.hasInstance()).assertEqual(false);
      expect(manager.isDestroyed).assertEqual(true);
    });

    it('FloatWindowManager_Resize_ThrowsWhenWindowMissing_011', 0, async () => {
      // 业务背景：在窗口未创建前误调用尺寸调整，应明确失败而不是静默吞掉输入。
      // 把报错消息固定下来，能帮助页面层更快识别生命周期调用时机错误。
      let errorMessage = await captureErrorMessage(async (): Promise<void> => {
        await manager.resize(100, 100);
      });
      expect(errorMessage).assertEqual('窗口实例不存在');
    });
  });
}
