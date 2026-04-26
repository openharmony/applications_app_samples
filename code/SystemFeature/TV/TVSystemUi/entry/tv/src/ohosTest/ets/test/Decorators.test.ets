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
 

import { afterEach, describe, expect, it } from '@ohos/hypium';
import {
  debounce,
  throttle,
  setDecoratorTimerOpsForTest,
  resetDecoratorTimerOpsForTest,
  setNowMsForTest,
  resetNowMsForTest,
  type DecoratorTimerOps,
} from '@ohos/common/src/main/ets/default/Decorators';

class TargetMethodHolder {
  count: number = 0;

  increase(): void {
    this.count++;
  }
}

class DescriptorHolder {
  value: () => void;

  constructor(fn: () => void) {
    this.value = fn;
  }
}

class VirtualTimerTask {
  id: number;
  at: number;
  fn: () => void;

  constructor(id: number, at: number, fn: () => void) {
    this.id = id;
    this.at = at;
    this.fn = fn;
  }
}

/**
 * 虚拟时间与定时器：debounce/throttle 单测完全同步执行，
 * 不依赖真实 setTimeout，避免 Hypium 在 timeout=0 或定时器竞争时出现「用例被提前终止」。
 */
class VirtualTestTime implements DecoratorTimerOps {
  private tasks: VirtualTimerTask[] = [];
  private nextId: number = 1;
  clockMs: number = 0;

  now(): number {
    return this.clockMs;
  }

  schedule(callback: () => void, delayMs: number): number {
    const id = this.nextId++;
    this.tasks.push(new VirtualTimerTask(id, this.clockMs + delayMs, callback));
    return id;
  }

  cancel(timerId: number): void {
    this.tasks = this.tasks.filter((t: VirtualTimerTask): boolean => t.id !== timerId);
  }

  advance(ms: number): void {
    this.clockMs += ms;
    this.flushDue();
  }

  private flushDue(): void {
    let progressed = true;
    while (progressed) {
      progressed = false;
      const due = this.tasks.filter((t: VirtualTimerTask): boolean => t.at <= this.clockMs);
      if (due.length === 0) {
        break;
      }
      const dropId = (id: number): boolean => {
        for (let i = 0; i < due.length; i++) {
          if (due[i].id === id) {
            return true;
          }
        }
        return false;
      };
      const keep: VirtualTimerTask[] = [];
      for (let i = 0; i < this.tasks.length; i++) {
        if (!dropId(this.tasks[i].id)) {
          keep.push(this.tasks[i]);
        }
      }
      this.tasks = keep;
      for (let i = 0; i < due.length; i++) {
        due[i].fn();
        progressed = true;
      }
    }
  }
}

export default function decoratorsTest() {
  describe('Decorators_Test', () => {
    afterEach(() => {
      resetDecoratorTimerOpsForTest();
      resetNowMsForTest();
    });

    it('debounce_should_create_callable_decorator', 0, () => {
      const vt = new VirtualTestTime();
      setDecoratorTimerOpsForTest(vt);
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      debounce(50)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      wrapped();
      vt.advance(120);
      expect(holder.count).assertEqual(1);
    });

    it('debounce_multiple_rapid_calls_only_execute_once', 0, () => {
      const vt = new VirtualTestTime();
      setDecoratorTimerOpsForTest(vt);
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      debounce(80)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      wrapped();
      wrapped();
      wrapped();
      wrapped();
      vt.advance(200);
      expect(holder.count).assertEqual(1);
    });

    it('debounce_no_call_within_timeout_means_zero_execution', 0, () => {
      const vt = new VirtualTestTime();
      setDecoratorTimerOpsForTest(vt);
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      debounce(80)(holder, 'increase', descriptor);
      vt.advance(120);
      expect(holder.count).assertEqual(0);
    });

    it('debounce_call_after_timeout_executes_again', 0, () => {
      const vt = new VirtualTestTime();
      setDecoratorTimerOpsForTest(vt);
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      debounce(50)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      vt.advance(120);
      wrapped();
      vt.advance(120);
      expect(holder.count).assertEqual(2);
    });

    it('throttle_should_limit_calls_within_wait_time', 0, () => {
      const vt = new VirtualTestTime();
      setNowMsForTest((): number => vt.now());
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      throttle(30)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      wrapped();
      vt.advance(40);
      wrapped();
      expect(holder.count).assertEqual(2);
    });

    it('throttle_first_call_always_executes', 0, () => {
      const vt = new VirtualTestTime();
      setNowMsForTest((): number => vt.now());
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      throttle(100)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      expect(holder.count).assertEqual(1);
    });

    it('throttle_calls_within_wait_time_are_ignored', 0, () => {
      const vt = new VirtualTestTime();
      setNowMsForTest((): number => vt.now());
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      throttle(50)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      wrapped();
      wrapped();
      expect(holder.count).assertEqual(1);
    });

    it('throttle_allows_call_after_wait_time_expires', 0, () => {
      const vt = new VirtualTestTime();
      setNowMsForTest((): number => vt.now());
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      throttle(20)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      vt.advance(30);
      wrapped();
      expect(holder.count).assertEqual(2);
    });

    it('throttle_independent_instances_do_not_share_state', 0, () => {
      const vt = new VirtualTestTime();
      setNowMsForTest((): number => vt.now());
      const h1 = new TargetMethodHolder();
      const h2 = new TargetMethodHolder();
      const d1: PropertyDescriptor = new DescriptorHolder(() => h1.increase()) as PropertyDescriptor;
      const d2: PropertyDescriptor = new DescriptorHolder(() => h2.increase()) as PropertyDescriptor;
      throttle(50)(h1, 'increase', d1);
      throttle(50)(h2, 'increase', d2);
      (d1.value as () => void)();
      (d2.value as () => void)();
      expect(h1.count).assertEqual(1);
      expect(h2.count).assertEqual(1);
    });

    it('debounce_independent_instances_do_not_share_timer', 0, () => {
      const vt = new VirtualTestTime();
      setDecoratorTimerOpsForTest(vt);
      const h1 = new TargetMethodHolder();
      const h2 = new TargetMethodHolder();
      const d1: PropertyDescriptor = new DescriptorHolder(() => h1.increase()) as PropertyDescriptor;
      const d2: PropertyDescriptor = new DescriptorHolder(() => h2.increase()) as PropertyDescriptor;
      debounce(50)(h1, 'increase', d1);
      debounce(50)(h2, 'increase', d2);
      (d1.value as () => void)();
      (d2.value as () => void)();
      vt.advance(120);
      expect(h1.count).assertEqual(1);
      expect(h2.count).assertEqual(1);
    });

    it('debounce_zero_timeout_executes_asap', 0, () => {
      const vt = new VirtualTestTime();
      setDecoratorTimerOpsForTest(vt);
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      debounce(0)(holder, 'increase', descriptor);
      (descriptor.value as () => void)();
      vt.advance(0);
      expect(holder.count).assertEqual(1);
    });

    it('throttle_zero_wait_executes_every_call', 0, () => {
      const vt = new VirtualTestTime();
      setNowMsForTest((): number => vt.now());
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      throttle(0)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      wrapped();
      wrapped();
      expect(holder.count).assertEqual(3);
    });

    it('debounce_resets_timer_on_each_call', 0, () => {
      const vt = new VirtualTestTime();
      setDecoratorTimerOpsForTest(vt);
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      debounce(50)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      vt.advance(30);
      wrapped();
      vt.advance(30);
      wrapped();
      vt.advance(120);
      expect(holder.count).assertEqual(1);
    });

    it('throttle_count_correct_after_multiple_intervals', 0, () => {
      const vt = new VirtualTestTime();
      setNowMsForTest((): number => vt.now());
      const holder = new TargetMethodHolder();
      const descriptor: PropertyDescriptor = new DescriptorHolder(() => holder.increase()) as PropertyDescriptor;
      throttle(15)(holder, 'increase', descriptor);
      const wrapped = descriptor.value as () => void;
      wrapped();
      vt.advance(20);
      wrapped();
      vt.advance(20);
      wrapped();
      expect(holder.count).assertEqual(3);
    });

  });
}
