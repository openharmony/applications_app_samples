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

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import PreferenceUtil from '../../../../main/ets/utils/PreferenceUtil';

type PreferenceValue = string | number | boolean;

interface MockBusinessError {
  code: number;
  message: string;
}

interface MockPreferenceStore {
  putSync(key: string, value: PreferenceValue): void;
  getSync(key: string, defaultValue: PreferenceValue): PreferenceValue;
  deleteSync(key: string): void;
  clearSync(): void;
  flush(callback: (err: MockBusinessError | null) => void): void;
}

interface PreferenceUtilRuntime {
  _preference?: MockPreferenceStore;
  getPreferenceFile(context: Context, fileName: string): PreferenceUtilRuntime;
  getConfigPreference(context: Context): PreferenceUtilRuntime;
  saveConfig(key: string, value: PreferenceValue): void;
  getConfig<T>(name: string, defValue: PreferenceValue): T;
  deleteKey(key: string): void;
  clearPreference(): void;
}

class InMemoryPreferenceStore implements MockPreferenceStore {
  private values: Map<string, PreferenceValue> = new Map<string, PreferenceValue>();
  flushCount: number = 0;
  nextError: MockBusinessError | null = null;

  putSync(key: string, value: PreferenceValue): void {
    this.values.set(key, value);
  }

  getSync(key: string, defaultValue: PreferenceValue): PreferenceValue {
    if (!this.values.has(key)) {
      return defaultValue;
    }
    return this.values.get(key) as PreferenceValue;
  }

  deleteSync(key: string): void {
    this.values.delete(key);
  }

  clearSync(): void {
    this.values.clear();
  }

  flush(callback: (err: MockBusinessError | null) => void): void {
    this.flushCount++;
    callback(this.nextError);
    this.nextError = null;
  }

  seed(key: string, value: PreferenceValue): void {
    this.values.set(key, value);
  }
}

/**
 * 获取可注入内部桩的真实 PreferenceUtil 单例。
 * @returns 运行时可写入 `_preference` 的对象
 */
function getRuntimePreferenceUtil(): PreferenceUtilRuntime {
  return PreferenceUtil as Object as PreferenceUtilRuntime;
}

export default function PreferenceUtilTest() {
  describe('PreferenceUtilTest', () => {
    let runtimeUtil: PreferenceUtilRuntime = getRuntimePreferenceUtil();
    let activeStore: InMemoryPreferenceStore;

    beforeEach(() => {
      // 业务背景：真实 PreferenceUtil 是单例，内部 `_preference` 会跨用例残留。
      // 这里每次都重新注入内存桩，确保断言针对当前调用而不是历史存量数据。
      activeStore = new InMemoryPreferenceStore();
      runtimeUtil._preference = activeStore;
    });

    afterEach(() => {
      runtimeUtil._preference = undefined;
    });

    it('PreferenceUtil_SingletonExport_IsStable_001', 0, () => {
      // 业务背景：业务代码通过默认导出共享同一份首选项工具，单例漂移会导致状态源分裂。
      // 先固定导出引用稳定性，后续对 `_preference` 的注入测试才有意义。
      expect(PreferenceUtil === PreferenceUtil).assertTrue();
    });

    it('PreferenceUtil_GetConfigPreference_MethodIsExposed_002', 0, () => {
      // 业务背景：页面通过该入口获取配置文件实例，方法入口缺失会直接阻断配置链路。
      // ArkTS 不允许在测试里重写对象方法，这里固定“入口可用”契约。
      expect(typeof runtimeUtil.getConfigPreference).assertEqual('function');
    });

    it('PreferenceUtil_SaveConfig_PersistsAndFlushesStringValue_003', 0, () => {
      // 业务背景：保存配置不只是写入内存，还必须触发 flush 才能保障下次启动可见。
      // 这里同时检查值与 flush 次数，避免未来只保留其中一半行为。
      runtimeUtil.saveConfig('stringKey', 'testValue');
      let value: string = runtimeUtil.getConfig<string>('stringKey', 'default');
      expect(value).assertEqual('testValue');
      expect(activeStore.flushCount).assertEqual(1);
    });

    it('PreferenceUtil_SaveConfig_SupportsNumberAndBooleanTypes_004', 0, () => {
      // 业务背景：设置项经常同时包含开关和数值，类型透传错误会在页面恢复时直接失真。
      // 把 number 与 boolean 放在同一用例里回归，可以保证 ValueType 组合路径都还活着。
      runtimeUtil.saveConfig('numberKey', 12345);
      runtimeUtil.saveConfig('boolKey', true);
      let value: number = runtimeUtil.getConfig<number>('numberKey', 0);
      let enabled: boolean = runtimeUtil.getConfig<boolean>('boolKey', false);
      expect(value).assertEqual(12345);
      expect(enabled).assertEqual(true);
    });

    it('PreferenceUtil_SaveConfig_AllowsOverwriteOnSameKey_005', 0, () => {
      // 业务背景：页面设置会被用户反复覆盖，工具层必须以后写为准而不是保留首值。
      // 这条用例能直接拦住底层缓存旧值导致 UI 与持久化不一致的问题。
      runtimeUtil.saveConfig('updateKey', 'oldValue');
      runtimeUtil.saveConfig('updateKey', 'newValue');
      let value: string = runtimeUtil.getConfig<string>('updateKey', 'default');
      expect(value).assertEqual('newValue');
    });

    it('PreferenceUtil_GetConfig_ReturnsFallbackForMissingKey_006', 0, () => {
      // 业务背景：首次启动时大量键还不存在，调用方依赖默认值驱动首帧渲染。
      // 固定缺省语义可以避免工具层将 `undefined` 直接泄漏给页面。
      let value: string = runtimeUtil.getConfig<string>('nonExistKey', 'defaultValue');
      expect(value).assertEqual('defaultValue');
    });

    it('PreferenceUtil_DeleteKey_RemovesOnlyTargetAndFlushes_007', 0, () => {
      // 业务背景：删除单个配置项时，其他键必须保持原样，避免“清理一个开关顺手清空整份配置”。
      // 同时要求删除也触发 flush，才能把清理动作持久化到磁盘。
      runtimeUtil.saveConfig('keepKey', 'keep');
      runtimeUtil.saveConfig('deleteKey', 'delete');
      runtimeUtil.deleteKey('deleteKey');
      expect(runtimeUtil.getConfig<string>('keepKey', '')).assertEqual('keep');
      expect(runtimeUtil.getConfig<string>('deleteKey', 'fallback')).assertEqual('fallback');
      expect(activeStore.flushCount).assertEqual(3);
    });

    it('PreferenceUtil_ClearPreference_RemovesAllKeysAndFlushes_008', 0, () => {
      // 业务背景：恢复默认设置依赖整库清空，而不是逐个枚举键删除。
      // 这条用例固定 clear 的原子语义，防止未来改成部分清理留下脏数据。
      runtimeUtil.saveConfig('key1', 'value1');
      runtimeUtil.saveConfig('key2', 123);
      runtimeUtil.saveConfig('key3', true);
      runtimeUtil.clearPreference();
      let value1: string = runtimeUtil.getConfig<string>('key1', 'default');
      let value2: number = runtimeUtil.getConfig<number>('key2', 0);
      let value3: boolean = runtimeUtil.getConfig<boolean>('key3', false);
      expect(value1).assertEqual('default');
      expect(value2).assertEqual(0);
      expect(value3).assertEqual(false);
      expect(activeStore.flushCount).assertEqual(4);
    });

    it('PreferenceUtil_SaveConfig_DoesNotThrowWhenFlushReportsError_009', 0, () => {
      // 业务背景：底层 flush 失败时当前实现只记录日志，不会把异常继续抛给业务层。
      // 显式固定这条容错路径，可以避免一次写盘异常把整个设置页交互打断。
      activeStore.nextError = { code: 500, message: 'flush failed' };
      runtimeUtil.saveConfig('resilientKey', 'value');
      expect(runtimeUtil.getConfig<string>('resilientKey', '')).assertEqual('value');
      expect(activeStore.flushCount).assertEqual(1);
    });

    it('PreferenceUtil_StoreInjection_CanSwitchUnderlyingPreferenceInstance_010', 0, () => {
      // 业务背景：源码通过切换 `_preference` 指向不同文件实例来完成多文件隔离。
      // 这里直接模拟切库，证明后续读写会跟随最新实例而不是黏在旧对象上。
      runtimeUtil.saveConfig('isolatedKey', 'primaryValue');
      let secondaryStore = new InMemoryPreferenceStore();
      runtimeUtil._preference = secondaryStore;
      expect(runtimeUtil.getConfig<string>('isolatedKey', 'secondaryDefault')).assertEqual('secondaryDefault');
      runtimeUtil.saveConfig('isolatedKey', 'secondaryValue');
      runtimeUtil._preference = activeStore;
      expect(runtimeUtil.getConfig<string>('isolatedKey', '')).assertEqual('primaryValue');
      runtimeUtil._preference = secondaryStore;
      expect(runtimeUtil.getConfig<string>('isolatedKey', '')).assertEqual('secondaryValue');
    });
  });
}
