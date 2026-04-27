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
 

import Log from './Log';

const TAG = 'Decorators';

/** 可注入计时器，供 ohosTest 虚拟时间驱动，避免依赖真实 setTimeout / Hypium 用例超时 */
export interface DecoratorTimerOps {
  schedule(callback: () => void, delayMs: number): number;

  cancel(timerId: number): void;
}

class SystemDecoratorTimerOps implements DecoratorTimerOps {
  schedule(callback: () => void, delayMs: number): number {
    return setTimeout(callback, delayMs);
  }

  cancel(timerId: number): void {
    clearTimeout(timerId);
  }
}

const defaultTimerOps: DecoratorTimerOps = new SystemDecoratorTimerOps();

let activeTimerOps: DecoratorTimerOps = defaultTimerOps;

let nowMsSource: () => number = (): number => Date.now();

/** @internal 单测注入定时器实现，用毕须 resetDecoratorTimerOpsForTest */
export function setDecoratorTimerOpsForTest(ops: DecoratorTimerOps): void {
  activeTimerOps = ops;
}

export function resetDecoratorTimerOpsForTest(): void {
  activeTimerOps = defaultTimerOps;
}

/** @internal 单测注入时间源，用毕须 resetNowMsForTest */
export function setNowMsForTest(getter: () => number): void {
  nowMsSource = getter;
}

export function resetNowMsForTest(): void {
  nowMsSource = (): number => Date.now();
}

export function debounce(timeout: number) {
  return (target: Object, propKey: string, descriptor: TypedPropertyDescriptor<(...args: string[]) => void>): void => {
    let curFunc: number = 0;
    const original = descriptor.value;
    if (!original) {
      return;
    }
    descriptor.value = (...args: string[]): void => {
      Log.showInfo(TAG, `debounce invoke ${propKey} curFunc: ${curFunc}`);
      if (curFunc !== 0) {
        activeTimerOps.cancel(curFunc);
      }
      curFunc = activeTimerOps.schedule((): void => {
        original(...args);
      }, timeout);
    };
  };
}

export function throttle(waitTime: number) {
  return (target: Object, propKey: string, descriptor: TypedPropertyDescriptor<(...args: string[]) => void>): void => {
    let lastTime: number = -1;
    const original = descriptor.value;
    if (!original) {
      return;
    }
    descriptor.value = (...args: string[]): void => {
      let curTime: number = nowMsSource();
      Log.showInfo(TAG, `throttle invoke ${propKey} timeInterval: ${curTime - lastTime}`);
      if (lastTime < 0 || curTime - lastTime >= waitTime) {
        original(...args);
        lastTime = curTime;
      }
    };
  };
}
