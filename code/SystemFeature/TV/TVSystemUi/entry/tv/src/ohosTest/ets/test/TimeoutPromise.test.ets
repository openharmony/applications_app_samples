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
 

import { describe, it, expect } from '@ohos/hypium';

/**
 * withTimeout 逻辑单元测试
 * 使用立即 resolve/reject 的 Promise 模拟，验证 Promise.race 竞争语义，
 * 不依赖真实 setTimeout，保证测试稳定性与执行速度。
 *
 * withTimeout 在蓝牙配对流程中用于防止设备无响应时永久挂起，
 * 超时后通过 PairErrorCode.TIMEOUT 让上层感知并重试或提示用户。
 * 使用 Promise.race 而非轮询，是因为蓝牙回调时机不确定，
 * race 能在任意一方先完成时立即决议，无需消耗 CPU 等待。
 */

// ---------- 提取 withTimeout 的核心竞争逻辑，不依赖系统计时器 ----------

interface RaceResult<T> {
  value?: T;
  timedOut: boolean;
  error?: string;
}

// 模拟 withTimeout 的 Promise.race 竞争语义：
// - 主 Promise 先完成 → 返回其结果
// - 超时 Promise 先完成 → 执行 timeoutAction 或 reject
async function raceWithFastTimeout<T>(
  mainResult: T | null,
  mainShouldReject: boolean,
  timeoutFirst: boolean,
  timeoutAction?: () => T | undefined
): Promise<RaceResult<T>> {
  const mainPromise = new Promise<T>((resolve, reject) => {
    if (!timeoutFirst) {
      if (mainShouldReject) {
        reject(new Error('main rejected'));
      } else {
        resolve(mainResult as T);
      }
    }
    // timeoutFirst 时 main 永不 resolve，让超时先触发
  });

  const timeoutPromise = new Promise<T>((resolve, reject) => {
    if (timeoutFirst) {
      if (timeoutAction) {
        const result = timeoutAction();
        if (result !== undefined) {
          resolve(result);
        } else {
          reject(new Error('TIMEOUT'));
        }
      } else {
        reject(new Error('TIMEOUT'));
      }
    }
    // !timeoutFirst 时超时永不触发
  });

  try {
    const value = await Promise.race([mainPromise, timeoutPromise]);
    return { value, timedOut: false };
  } catch (e) {
    const msg: string = (e as Error).message;
    return { timedOut: msg === 'TIMEOUT', error: msg };
  }
}

export default function timeoutPromiseTest() {
  describe('TimeoutPromise_Logic_Test', () => {

    it('main_resolves_first_returns_value', 0, async () => {
      // 设备正常响应时，主 Promise 先完成，超时逻辑不介入
      const result = await raceWithFastTimeout<number>(42, false, false);
      expect(result.timedOut).assertFalse();
      expect(result.value).assertEqual(42);
    });

    it('timeout_first_without_action_rejects_with_timeout', 0, async () => {
      // 设备无响应时超时先触发且无 fallback，应 reject 让上层重试或提示
      const result = await raceWithFastTimeout<number>(null, false, true);
      expect(result.timedOut).assertTrue();
    });

    it('timeout_first_with_action_returning_value_resolves', 0, async () => {
      // timeoutAction 返回非 undefined 值时，超时走降级路径而非 reject，
      // 用于蓝牙配对中超时后返回默认状态而非让流程崩溃
      const result = await raceWithFastTimeout<number>(null, false, true, () => 0);
      expect(result.timedOut).assertFalse();
      expect(result.value).assertEqual(0);
    });

    it('timeout_first_with_action_returning_undefined_rejects', 0, async () => {
      // timeoutAction 返回 undefined 表示无法降级，走 reject 路径
      const result = await raceWithFastTimeout<number>(null, false, true, () => undefined);
      expect(result.timedOut).assertTrue();
    });

    it('main_rejects_propagates_error', 0, async () => {
      // 主 Promise 自身失败时错误应正常传播，不被超时逻辑吞掉
      const result = await raceWithFastTimeout<number>(null, true, false);
      expect(result.error).assertEqual('main rejected');
      expect(result.timedOut).assertFalse();
    });

    it('main_resolves_string_value', 0, async () => {
      const result = await raceWithFastTimeout<string>('ok', false, false);
      expect(result.value).assertEqual('ok');
    });

    it('timeout_action_fallback_value_is_correct', 0, async () => {
      // 验证 timeoutAction 的返回值被正确传递给调用方
      const result = await raceWithFastTimeout<string>(null, false, true, () => 'fallback');
      expect(result.value).assertEqual('fallback');
    });

    it('race_semantics_main_wins_when_resolves_immediately', 0, async () => {
      // Promise.race 的核心保证：第一个 settle 的 Promise 决定结果
      const result = await raceWithFastTimeout<boolean>(true, false, false);
      expect(result.value).assertTrue();
      expect(result.timedOut).assertFalse();
    });

    it('successful_result_has_no_error_field', 0, async () => {
      // 主 Promise 正常完成时，error 字段应为 undefined
      const result = await raceWithFastTimeout<number>(1, false, false);
      expect(result.error === undefined).assertTrue();
    });

    it('main_resolves_zero_value_is_not_treated_as_timeout', 0, async () => {
      // 数字 0 是有效 resolve 值，不应被误判为超时
      const result = await raceWithFastTimeout<number>(0, false, false);
      expect(result.timedOut).assertFalse();
      expect(result.value).assertEqual(0);
    });

    it('timeout_fallback_number_zero_resolves_correctly', 0, async () => {
      // timeoutAction 返回 0 时，0 !== undefined，应走 resolve 路径
      const result = await raceWithFastTimeout<number>(null, false, true, () => 0);
      expect(result.timedOut).assertFalse();
      expect(result.value).assertEqual(0);
    });

    it('timeout_fallback_false_resolves_correctly', 0, async () => {
      // timeoutAction 返回 false 时，false !== undefined，应走 resolve 路径
      const result = await raceWithFastTimeout<boolean>(null, false, true, () => false);
      expect(result.timedOut).assertFalse();
      expect(result.value).assertFalse();
    });

    it('timeout_error_message_contains_TIMEOUT', 0, async () => {
      // 超时 reject 的错误信息应包含 TIMEOUT 标识，便于上层日志分类
      const result = await raceWithFastTimeout<number>(null, false, true);
      expect(result.error).assertEqual('TIMEOUT');
    });

    it('main_reject_error_is_not_timeout', 0, async () => {
      // 主 Promise reject 时，timedOut 必须为 false，区分超时与业务失败
      const result = await raceWithFastTimeout<number>(null, true, false);
      expect(result.timedOut).assertFalse();
      expect(result.error !== 'TIMEOUT').assertTrue();
    });

    it('main_resolves_empty_string_is_valid', 0, async () => {
      const result = await raceWithFastTimeout<string>('', false, false);
      expect(result.timedOut).assertFalse();
      expect(result.value).assertEqual('');
    });

  });
}
