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
import { WindowMoverManager } from '../../../../main/ets/utils/WindowMoverManager';

interface WindowRectShape {
  left: number;
  top: number;
}

interface WindowPropertiesShape {
  windowRect: WindowRectShape;
}

interface MovableWindow {
  moveWindowTo(x: number, y: number): Promise<void>;
  getWindowProperties(): Promise<WindowPropertiesShape>;
}

interface WindowMoverManagerInternals {
  targetX: number;
  targetY: number;
  isAnimating: boolean;
  animationTimer: number | null;
  windowRef: window.Window | null;
  lastSetX: number | null;
  lastSetY: number | null;
  startAnimationLoop(): Promise<void>;
}

class MovableWindowImpl implements MovableWindow {
  private moveCalls: number[][];
  private currentLeft: number;
  private currentTop: number;

  constructor(moveCalls: number[][], initialLeft: number, initialTop: number) {
    this.moveCalls = moveCalls;
    this.currentLeft = initialLeft;
    this.currentTop = initialTop;
  }

  async moveWindowTo(x: number, y: number): Promise<void> {
    this.moveCalls.push([x, y]);
    this.currentLeft = x;
    this.currentTop = y;
  }

  async getWindowProperties(): Promise<WindowPropertiesShape> {
    let rect: WindowRectShape = { left: this.currentLeft, top: this.currentTop };
    return { windowRect: rect };
  }
}

/**
 * 将测试窗口桩转成窗口实例类型。
 * @param mockWindow 支持移动与读取位置的窗口桩
 * @returns 可供 WindowMoverManager 使用的窗口对象
 */
function asWindow(mockWindow: MovableWindow): window.Window {
  return mockWindow as Object as window.Window;
}

/**
 * 创建带位置状态的窗口桩。
 * @param moveCalls 移动调用轨迹
 * @param initialLeft 初始横坐标
 * @param initialTop 初始纵坐标
 * @returns 可驱动动画循环的窗口桩
 */
function createMovableWindow(
  moveCalls: number[][],
  initialLeft: number,
  initialTop: number
): MovableWindow {
  return new MovableWindowImpl(moveCalls, initialLeft, initialTop);
}

/**
 * 等待定时器推进，便于验证防抖与动画行为。
 * @param delay 等待的毫秒数
 * @returns 延时 Promise
 */
function sleep(delay: number): Promise<void> {
  return new Promise<void>((resolve) => {
    setTimeout(() => {
      resolve();
    }, delay);
  });
}

export default function WindowMoverManagerTest() {
  describe('WindowMoverManagerTest', () => {
    let manager = WindowMoverManager as Object as WindowMoverManagerInternals;

    beforeEach(() => {
      // 业务背景：WindowMoverManager 使用静态字段保存动画状态，历史用例会直接影响后续断言。
      // 每次执行前先清零目标、引用和缓存位置，才能稳定验证移动器的真实边界。
      WindowMoverManager.stop();
      manager.targetX = 0;
      manager.targetY = 0;
      manager.isAnimating = false;
      manager.animationTimer = null;
      manager.windowRef = null;
      manager.lastSetX = null;
      manager.lastSetY = null;
    });

    afterEach(() => {
      WindowMoverManager.stop();
      manager.lastSetX = null;
      manager.lastSetY = null;
    });

    it('WindowMoverManager_MoveImmediately_StopsAnimationAndCachesRoundedTarget_001', 0, async () => {
      // 业务背景：立即移动用于首帧定位和强制纠偏，必须先打断旧动画，避免窗口被下一帧拉回旧轨迹。
      // 同时缓存四舍五入后的坐标，才能让后续平滑动画从正确基线继续。
      let moveCalls: number[][] = [];
      let mockWindow = asWindow(createMovableWindow(moveCalls, 0, 0));
      manager.isAnimating = true;
      manager.windowRef = mockWindow;
      manager.animationTimer = setTimeout(() => {
      }, 1000);
      await WindowMoverManager.moveImmediately(mockWindow, 15.6, 20.2);
      expect(moveCalls.length).assertEqual(1);
      expect(moveCalls[0][0]).assertEqual(15.6);
      expect(moveCalls[0][1]).assertEqual(20.2);
      expect(manager.isAnimating).assertEqual(false);
      expect(manager.windowRef).assertEqual(null);
      expect(manager.animationTimer).assertEqual(null);
      expect(manager.lastSetX).assertEqual(16);
      expect(manager.lastSetY).assertEqual(20);
    });

    it('WindowMoverManager_Stop_ClearsTimerAndReferenceState_002', 0, () => {
      // 业务背景：拖拽取消、窗口销毁和异常路径都会共用 stop 作为收敛出口。
      // 若 stop 清理不彻底，下一次动画会复用旧引用或旧定时器，直接造成串窗。
      let moveCalls: number[][] = [];
      manager.isAnimating = true;
      manager.windowRef = asWindow(createMovableWindow(moveCalls, 4, 5));
      manager.animationTimer = setTimeout(() => {
      }, 1000);
      WindowMoverManager.stop();
      expect(manager.isAnimating).assertEqual(false);
      expect(manager.windowRef).assertEqual(null);
      expect(manager.animationTimer).assertEqual(null);
    });

    it('WindowMoverManager_Debounce_OnlyRunsLatestCoordinates_003', 0, async () => {
      // 业务背景：窗口拖拽会高频产生坐标变更，真正需要持久化的只有最后一次稳定位置。
      // 这条用例守住“覆盖旧值”的防抖语义，避免频繁落盘拖慢主线程。
      let persisted: number[][] = [];
      let debounced = WindowMoverManager.debounce((x: number, y: number): void => {
        persisted.push([x, y]);
      }, 20);
      debounced(10, 10);
      debounced(30, 40);
      await sleep(50);
      expect(persisted.length).assertEqual(1);
      expect(persisted[0][0]).assertEqual(30);
      expect(persisted[0][1]).assertEqual(40);
    });

    it('WindowMoverManager_MoveTo_StoresLatestTargetWhileAnimating_004', 0, async () => {
      // 业务背景：平滑移动不直接跳坐标，而是更新目标点并拉起统一动画循环。
      // 高频调用时应只更新最新目标，避免窗口继续朝过期目标移动。
      let moveCalls: number[][] = [];
      let mockWindow = asWindow(createMovableWindow(moveCalls, 0, 0));
      await WindowMoverManager.moveTo(mockWindow, 200, 300);
      await WindowMoverManager.moveTo(mockWindow, 260, 360);
      expect(manager.windowRef === mockWindow).assertTrue();
      expect(manager.targetX).assertEqual(260);
      expect(manager.targetY).assertEqual(360);
      expect(manager.isAnimating).assertEqual(true);
      WindowMoverManager.stop();
    });

    it('WindowMoverManager_StartAnimationLoop_InterpolatesFromRealWindowPosition_005', 0, async () => {
      // 业务背景：源码强调“每一帧从真实窗口位置开始”，这是避免外部纠偏后动画抖动的关键契约。
      // 直接验证第一帧插值结果，能拦住把真实位置误换成缓存位置的回归。
      let moveCalls: number[][] = [];
      manager.windowRef = asWindow(createMovableWindow(moveCalls, 0, 0));
      manager.targetX = 10;
      manager.targetY = 10;
      manager.isAnimating = true;
      manager.lastSetX = null;
      manager.lastSetY = null;
      await manager.startAnimationLoop();
      await sleep(25);
      WindowMoverManager.stop();
      expect(moveCalls.length > 0).assertTrue();
      expect(moveCalls[0][0]).assertEqual(3);
      expect(moveCalls[0][1]).assertEqual(3);
    });

    it('WindowMoverManager_MoveTo_ThrowsWhenWindowMissing_006', 0, async () => {
      // 业务背景：调用方若把空窗口传进移动器，应尽早失败而不是默默吞掉，方便定位生命周期错误。
      // 这里固定抛错契约，也顺带保证空指针保护仍然存在。
      let errorMessage = '';
      let nullWindow: window.Window | null = null;
      try {
        await WindowMoverManager.moveTo(nullWindow!, 1, 1);
      } catch (error) {
        errorMessage = (error as Error).message;
      }
      expect(errorMessage).assertEqual('Window is null');
    });
  });
}
