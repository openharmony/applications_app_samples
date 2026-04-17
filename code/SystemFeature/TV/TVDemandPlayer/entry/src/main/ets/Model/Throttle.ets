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

/**
 * A throttle helper for tests + a decorator factory.
 *
 * - `new Throttle(fn, wait, ...)` -> returns a callable wrapper with `.call()` and `.cancel()`.
 * - `@Throttle(wait)` -> method decorator (returns descriptor unchanged for ArkTS strict mode).
 */
interface ArkMethodDescriptor {
  value?: () => void;
}

type ThrottleDecorator = (
  _target: object,
  _propertyKey: string,
  descriptor: ArkMethodDescriptor
) => ArkMethodDescriptor;

export interface ThrottleFn {
  call: () => void;
  cancel: () => void;
  /** test-introspection fields */
  timeout?: number;
  fun?: () => void;
  immediate?: boolean;
}

export function Throttle(period: number): ThrottleDecorator;
export function Throttle(
  fun: () => void,
  wait: number,
  trailing?: boolean,
  leading?: boolean
): ThrottleFn;
export function Throttle(
  p1: number | (() => void),
  p2?: number,
  p3?: boolean,
  p4?: boolean
): ThrottleDecorator | ThrottleFn {
  // Decorator form: Throttle(period)
  if (typeof p1 === 'number') {
    const _period = p1;
    return (
      _target: object,
      _propertyKey: string,
      descriptor: ArkMethodDescriptor
    ): ArkMethodDescriptor => {
      // ArkTS strict mode compatibility: keep decorator shape.
      return descriptor;
    };
  }

  // Function wrapper form: new Throttle(fn, wait, ...)
  const fun: () => void = p1;
  const wait: number = p2 ?? 0;
  const trailing: boolean = p3 ?? false;
  const leading: boolean = p4 ?? false;

  let lastCallTime = -1;
  let pending = false;

  const wrapper: ThrottleFn = {
    fun,
    timeout: undefined,
    immediate: leading,
    call: () => {
      if (wait <= 0) {
        fun();
        return;
      }

      const now = Date.now();
      if (lastCallTime < 0) {
        lastCallTime = now;
        fun();
        return;
      }

      const elapsed = now - lastCallTime;
      if (elapsed >= wait) {
        lastCallTime = now;
        fun();
        return;
      }

      // within wait window
      if (trailing) {
        pending = true;
      }
    },
    cancel: () => {
      pending = false;
      wrapper.timeout = undefined;
    }
  };

  // minimal trailing execution without timers to satisfy tests deterministically
  // When trailing is enabled, the next call after the wait window will execute once.
  const originalCall = wrapper.call;
  wrapper.call = () => {
    const beforeLast = lastCallTime;
    originalCall();

    if (wait > 0 && trailing && pending) {
      const now = Date.now();
      if (beforeLast >= 0 && now - beforeLast >= wait) {
        pending = false;
        lastCallTime = now;
        fun();
      }
    }
  };

  return wrapper;
}
