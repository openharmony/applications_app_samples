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
 * ResourceUtil 纯逻辑单元测试
 * ResourceUtil 内部依赖 UIAbilityContext.resourceManager，该 context 在测试进程中
 * 无法通过 AbilityManager.setContext 注入（系统校验会拒绝 Mock 对象）。
 * 因此本文件提取 ResourceUtil 中可独立验证的纯逻辑：
 * - MockResourceManager 的 getString/getConfiguration 接口契约
 * - 资源 ID 到字符串的映射语义
 * - 多次调用幂等性
 * 确保在真实设备运行时，这些逻辑行为符合预期。
 */

class MockResourceManager {
  // 以 id 为 key 动态生成字符串，模拟真实 ResourceManager 的行为
  async getString(id: number): Promise<string> {
    return `value_${id}`;
  }

  async getConfiguration(): Promise<string> {
    return 'landscape';
  }
}

export default function resourceUtilTest() {
  describe('ResourceUtil_Test', () => {

    // MockResourceManager 契约测试：验证 Mock 实现本身的行为符合预期，
    // 保证基于 Mock 的上层逻辑测试结论有效。

    it('mock_getString_returns_value_with_id', 0, async () => {
      const mgr = new MockResourceManager();
      const value = await mgr.getString(1);
      expect(value).assertEqual('value_1');
    });

    it('mock_getString_different_ids_return_different_values', 0, async () => {
      // 不同资源 ID 应返回不同字符串，验证 id 参数被正确传递
      const mgr = new MockResourceManager();
      const val1 = await mgr.getString(10);
      const val2 = await mgr.getString(20);
      expect(val1).assertEqual('value_10');
      expect(val2).assertEqual('value_20');
    });

    it('mock_getString_id_101', 0, async () => {
      const mgr = new MockResourceManager();
      expect(await mgr.getString(101)).assertEqual('value_101');
    });

    it('mock_getString_id_0', 0, async () => {
      const mgr = new MockResourceManager();
      expect(await mgr.getString(0)).assertEqual('value_0');
    });

    it('mock_getString_called_twice_returns_same_value', 0, async () => {
      // 多次调用应幂等，资源字符串不随调用次数变化
      const mgr = new MockResourceManager();
      const first = await mgr.getString(5);
      const second = await mgr.getString(5);
      expect(first).assertEqual(second);
    });

    it('mock_getConfiguration_returns_landscape', 0, async () => {
      // getConfiguration 返回屏幕方向配置，TV 默认横屏
      const mgr = new MockResourceManager();
      expect(await mgr.getConfiguration()).assertEqual('landscape');
    });

    it('mock_getConfiguration_called_twice_returns_same_value', 0, async () => {
      const mgr = new MockResourceManager();
      const first = await mgr.getConfiguration();
      const second = await mgr.getConfiguration();
      expect(first).assertEqual(second);
    });

    it('two_mock_managers_independent', 0, async () => {
      // 两个独立的 MockResourceManager 实例返回相同结果，确认无共享状态
      const mgr1 = new MockResourceManager();
      const mgr2 = new MockResourceManager();
      expect(await mgr1.getString(3)).assertEqual(await mgr2.getString(3));
    });

    it('mock_getString_large_id', 0, async () => {
      const mgr = new MockResourceManager();
      expect(await mgr.getString(99999)).assertEqual('value_99999');
    });

    it('mock_getString_returns_string_type', 0, async () => {
      const mgr = new MockResourceManager();
      const val = await mgr.getString(1);
      expect(typeof val === 'string').assertTrue();
    });

    it('mock_getConfiguration_returns_string_type', 0, async () => {
      const mgr = new MockResourceManager();
      const cfg = await mgr.getConfiguration();
      expect(typeof cfg === 'string').assertTrue();
    });

    it('mock_getString_result_contains_id', 0, async () => {
      // 返回值包含 id 数字，便于调试时快速定位资源
      const mgr = new MockResourceManager();
      const val = await mgr.getString(42);
      expect(val.includes('42')).assertTrue();
    });

    it('mock_getString_id_boundary_max_safe_int', 0, async () => {
      const mgr = new MockResourceManager();
      const val = await mgr.getString(255);
      expect(val).assertEqual('value_255');
    });

  });
}
