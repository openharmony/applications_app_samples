/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { window } from '@kit.ArkUI';

// 移除工具类型，使用更简单的类型定义
type DebounceFunction = (x: number, y: number) => void;

export class WindowMoverManager {
  private static targetX: number = 0;
  private static targetY: number = 0;
  private static isAnimating: boolean = false;
  private static animationTimer: number | null = null;
  private static windowRef: window.Window | null = null;

  private static readonly SMOOTH_FACTOR = 0.3; // 响应快
  private static readonly FRAME_INTERVAL = 16;
  private static lastSetX: number | null = null;
  private static lastSetY: number | null = null;
  private static readonly TOLERANCE = 1.0;

  // ==============================
  // 🌟 动画移动：每次从窗口真实位置开始！
  // ==============================
  public static async moveTo(
    windowInstance: window.Window,
    targetX: number,
    targetY: number
  ): Promise<void> {
    if (!windowInstance) {
      throw new Error('Window is null');
    }

    WindowMoverManager.windowRef = windowInstance;
    WindowMoverManager.targetX = targetX;
    WindowMoverManager.targetY = targetY;

    if (!WindowMoverManager.isAnimating) {
      WindowMoverManager.isAnimating = true;
      // 【关键】启动前不假设当前位置，第一帧再获取
      WindowMoverManager.startAnimationLoop();
    }
  }

  private static async startAnimationLoop() {
    // 使用箭头函数避免this问题
    const animate = async () => {
      if (!WindowMoverManager.windowRef || !WindowMoverManager.isAnimating) {
        return;
      }

      try {
        // 【核心】每一帧都从窗口真实位置开始插值！
        const props = await WindowMoverManager.windowRef.getWindowProperties();
        let currentX = props.windowRect.left;
        let currentY = props.windowRect.top;

        // 向目标插值
        currentX += (WindowMoverManager.targetX - currentX) * WindowMoverManager.SMOOTH_FACTOR;
        currentY += (WindowMoverManager.targetY - currentY) * WindowMoverManager.SMOOTH_FACTOR;

        const intX = Math.round(currentX);
        const intY = Math.round(currentY);

        // 防抖
        if (
          WindowMoverManager.lastSetX === null ||
            WindowMoverManager.lastSetY === null ||
            Math.abs(intX - WindowMoverManager.lastSetX) >= WindowMoverManager.TOLERANCE ||
            Math.abs(intY - WindowMoverManager.lastSetY) >= WindowMoverManager.TOLERANCE
        ) {
          await WindowMoverManager.windowRef.moveWindowTo(intX, intY);
          WindowMoverManager.lastSetX = intX;
          WindowMoverManager.lastSetY = intY;
        }

        WindowMoverManager.animationTimer = setTimeout(animate, WindowMoverManager.FRAME_INTERVAL);
      } catch (err) {
        console.error('Animation error:', err);
        WindowMoverManager.stop();
      }
    };

    animate();
  }

  // ==============================
  // ⚡ 瞬时移动
  // ==============================
  public static async moveImmediately(
    windowInstance: window.Window,
    targetX: number,
    targetY: number
  ): Promise<void> {
    WindowMoverManager.stop(); // 停止任何动画
    await windowInstance.moveWindowTo(targetX, targetY);

    // 同步 lastSet 以避免下一帧误判为"大跳变"
    WindowMoverManager.lastSetX = Math.round(targetX);
    WindowMoverManager.lastSetY = Math.round(targetY);
  }

  public static stop() {
    if (WindowMoverManager.animationTimer !== null) {
      clearTimeout(WindowMoverManager.animationTimer);
      WindowMoverManager.animationTimer = null;
    }
    WindowMoverManager.isAnimating = false;
    WindowMoverManager.windowRef = null;
  }

  /**
   * 创建一个防抖函数
   * @param func 要防抖的函数
   * @param delay 延迟时间（毫秒）
   * @returns 防抖后的函数
   */
  public static debounce(func: (x: number, y: number) => void, delay: number): DebounceFunction {
    let timerId: number | null = null;

    // 使用箭头函数避免this问题
    return (x: number, y: number) => {
      // 清除上一次的定时器
      if (timerId !== null) {
        clearTimeout(timerId);
      }

      // 启动新的定时器
      timerId = setTimeout(() => {
        func(x, y);
        timerId = null;
      }, delay);
    };
  }
}
