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

import { describe, beforeEach, it, expect } from '@ohos/hypium';
import { preferences } from '@kit.ArkData';
import PreferenceUtils from '../../../../main/ets/utils/PreferencesManager';

type PreferenceValue = string | number | boolean;

interface MockPreferenceStore {
  putSync(key: string, value: PreferenceValue): void;
  getSync(key: string, defaultValue: PreferenceValue): PreferenceValue;
  flush(): void;
}

class TestPreferenceUtils<T extends PreferenceValue> extends PreferenceUtils<T> {
  store: InMemoryPreferencesStore;

  constructor(context: Context, initValue: T, store: InMemoryPreferencesStore) {
    super(context, initValue);
    this.store = store;
  }

  getPres(): preferences.Preferences {
    return this.store as Object as preferences.Preferences;
  }
}

class ThrowingPreferenceUtils extends PreferenceUtils<string> {
  getPres(): preferences.Preferences {
    throw new Error('store unavailable');
  }
}

class InMemoryPreferencesStore implements MockPreferenceStore {
  private values: Map<string, PreferenceValue> = new Map<string, PreferenceValue>();
  flushCount: number = 0;

  putSync(key: string, value: PreferenceValue): void {
    this.values.set(key, value);
  }

  getSync(key: string, defaultValue: PreferenceValue): PreferenceValue {
    if (!this.values.has(key)) {
      return defaultValue;
    }
    return this.values.get(key) as PreferenceValue;
  }

  flush(): void {
    this.flushCount++;
  }

  clear(): void {
    this.values.clear();
  }
}

/**
 * 创建可注入底层存储桩的真实 PreferenceUtils 实例。
 * @param context 用于构造真实对象的上下文桩
 * @param initValue 缺省返回值
 * @param store 需要挂接的共享存储桩
 * @returns 已覆盖 `getPres` 的真实实例
 */
function createPreferenceManager<T extends PreferenceValue>(
  context: Context,
  initValue: T,
  store: InMemoryPreferencesStore
): TestPreferenceUtils<T> {
  return new TestPreferenceUtils<T>(context, initValue, store);
}

export default function PreferencesManagerTest() {
  describe('PreferencesManagerTest', () => {
    let mockContext: Context = {} as Context;
    let sharedStore: InMemoryPreferencesStore;
    let preferenceUtils: TestPreferenceUtils<string>;

    beforeEach(() => {
      // 业务背景：真实 PreferencesManager 每次通过 `getPres()` 拿到底层持久化句柄。
      // 这里统一注入共享内存桩，才能验证多实例共享、默认值回退和 flush 行为。
      sharedStore = new InMemoryPreferencesStore();
      preferenceUtils = createPreferenceManager<string>(mockContext, 'defaultValue', sharedStore);
    });

    it('PreferencesManager_Constructor_PreservesContextAndDefault_001', 0, () => {
      // 业务背景：构造器保存的 context 和 initValue 会影响所有后续读取逻辑。
      // 如果初始化态被污染，缺省值和存储句柄都会在全局范围内偏离预期。
      expect(preferenceUtils !== null).assertTrue();
      expect(preferenceUtils.initValue).assertEqual('defaultValue');
      expect(preferenceUtils.context === mockContext).assertTrue();
    });

    it('PreferencesManager_SetPreValue_PersistsAndFlushes_002', 0, () => {
      // 业务背景：设置值的核心契约是“写入 + flush”，缺一项都会让页面恢复态失真。
      // 直接盯住共享桩的 flush 计数，比只断言 get 回读更能发现持久化退化。
      preferenceUtils.setPreValue('stringKey', 'testValue');
      let value = preferenceUtils.getPreValue('stringKey');
      expect(value).assertEqual('testValue');
      expect(sharedStore.flushCount).assertEqual(1);
    });

    it('PreferencesManager_GetPreValue_ReturnsInitValueForMissingKey_003', 0, () => {
      // 业务背景：首次安装或切换新 key 时，业务层依赖 initValue 完成无配置首帧渲染。
      // 这条测试保证 `getPreValue` 不会把未命中的结果变成 `undefined`。
      expect(preferenceUtils.getPreValue('missingKey')).assertEqual('defaultValue');
    });

    it('PreferencesManager_SetPreValue_UsesLastWriteForSameKey_004', 0, () => {
      // 业务背景：同一偏好项会被用户反复修改，读取结果必须反映最后一次选择。
      // 如果保留旧值，设置页显示和真实持久化状态会马上分叉。
      preferenceUtils.setPreValue('updateKey', 'oldValue');
      preferenceUtils.setPreValue('updateKey', 'newValue');
      let value = preferenceUtils.getPreValue('updateKey');
      expect(value).assertEqual('newValue');
      expect(sharedStore.flushCount).assertEqual(2);
    });

    it('PreferencesManager_GenericNumberAndBoolean_RoundTripThroughRealMethods_005', 0, () => {
      // 业务背景：PreferencesManager 的泛型价值就在于同一封装能承载 number 和 boolean。
      // 把两类值都走一遍真实方法，能守住泛型在运行时未被字符串化的契约。
      let numberPrefs = createPreferenceManager<number>(mockContext, -1, sharedStore);
      let boolPrefs = createPreferenceManager<boolean>(mockContext, false, sharedStore);
      numberPrefs.setPreValue('zeroKey', 0);
      boolPrefs.setPreValue('boolKey', true);
      expect(numberPrefs.getPreValue('zeroKey')).assertEqual(0);
      expect(boolPrefs.getPreValue('boolKey')).assertEqual(true);
    });

    it('PreferencesManager_MultipleInstancesShareUnderlyingStore_006', 0, () => {
      // 业务背景：不同页面或组件各自 new 一份工具时，底层仍应落到同一份首选项存储。
      // 共享存储契约一旦失效，跨页面保存和读取就会互相看不见。
      let prefs1 = createPreferenceManager<string>(mockContext, 'init1', sharedStore);
      let prefs2 = createPreferenceManager<string>(mockContext, 'init2', sharedStore);
      prefs1.setPreValue('sharedKey', 'value1');
      expect(prefs1.getPreValue('sharedKey')).assertEqual('value1');
      expect(prefs2.getPreValue('sharedKey')).assertEqual('value1');
    });

    it('PreferencesManager_RawStoreWritesRemainVisibleToClassReads_007', 0, () => {
      // 业务背景：真实工程里同一 token 可能被其他工具或能力代码直接写入。
      // 读取路径要能看到外部写入，才能保障配置跨模块一致性。
      sharedStore.putSync('externalKey', 'externalValue');
      sharedStore.flush();
      expect(preferenceUtils.getPreValue('externalKey')).assertEqual('externalValue');
    });

    it('PreferencesManager_ClassWritesAreVisibleToSharedStore_008', 0, () => {
      // 业务背景：封装层最终还是服务于底层持久化存储，这里验证写入真正落到了共享句柄。
      // 这样后续页面层若直接读原始 store，也能得到同一结果。
      preferenceUtils.setPreValue('bridgeKey', 'bridgeValue');
      expect(sharedStore.getSync('bridgeKey', '') as string).assertEqual('bridgeValue');
    });

    it('PreferencesManager_SetPreValue_SwallowsStoreAcquisitionErrors_009', 0, () => {
      // 业务背景：源码对 `setPreValue` 做了 try/catch，意图是不让写入异常打断主流程。
      // 固定这个容错行为后，后续即使底层 store 短时异常也不会把 UI 点击直接打崩。
      let brokenPreferenceUtils = new ThrowingPreferenceUtils(mockContext, 'defaultValue');
      try {
        brokenPreferenceUtils.setPreValue('key', 'value');
        expect(true).assertTrue();
      } catch (error) {
        expect(false).assertTrue();
      }
    });
  });
}
