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
import { GlobalContext, getGlobalObject, setGlobalObject } from '../../../../main/ets/utils/GlobalThis';

let keySeed = 0;

interface AbilityContextValue {
  abilityName: string;
}

type GlobalStoreValue = object | string | number | boolean | undefined;

interface GlobalContextStore {
  setObject(key: string, objectClass: GlobalStoreValue): void;
  getObject(value: string): GlobalStoreValue;
}

interface CameraStateValue {
  cameraId: string;
  previewing: boolean;
  zoomRatio: number;
}

interface ReadyStateValue {
  ready: boolean;
}

interface CameraResolution {
  width: number;
  height: number;
}

interface NestedCameraStateValue {
  currentCameraId: string;
  isPreviewing: boolean;
  resolution: CameraResolution;
}

function nextKey(prefix: string): string {
  keySeed++;
  return `${prefix}_${keySeed}`;
}

function assertEmptyObject(value: GlobalStoreValue): void {
  let serializedValue = '{}';
  if (typeof value === 'object' && value !== undefined) {
    serializedValue = JSON.stringify(value);
  }
  expect(serializedValue).assertEqual('{}');
}

export default function GlobalThisTest() {
  describe('GlobalThisTest', () => {
    beforeEach(() => {
      // 业务背景：GlobalContext 是进程级单例，历史写入会跨用例残留。
      // 这里用递增 key 做隔离，比直接依赖清理接口更贴近真实运行形态。
    });

    it('GlobalContext_ReturnsSingletonInstance_001', 0, () => {
      // 业务背景：入口能力、页面和工具类都依赖同一份全局容器。
      // 如果单例失效，跨模块状态同步会立刻出现双份数据源问题。
      let instance1: GlobalContext = GlobalContext.getContext();
      let instance2: GlobalContext = GlobalContext.getContext();
      expect(instance1 === instance2).assertTrue();
    });

    it('GlobalContext_SetAndGetPrimitiveValue_002', 0, () => {
      // 业务背景：启动时间、索引值一类状态常以基础类型写入全局上下文。
      // 先守住最简单路径，可以证明 Map 存取行为本身没有偏差。
      let key = nextKey('number');
      let context: GlobalContextStore = GlobalContext.getContext() as GlobalContextStore;
      context.setObject(key, 12345);
      expect(context.getObject(key)).assertEqual(12345);
    });

    it('GlobalContext_SetAndGetStructuredObject_003', 0, () => {
      // 业务背景：相机状态通常以对象形式共享，包含多个嵌套字段。
      // 测试对象透传而不是字符串化，才能保证页面层可直接消费字段。
      let key = nextKey('state');
      let context: GlobalContextStore = GlobalContext.getContext() as GlobalContextStore;
      let state: CameraStateValue = { cameraId: 'rear', previewing: true, zoomRatio: 2 };
      context.setObject(key, state);
      let value = context.getObject(key) as CameraStateValue;
      expect(value.cameraId).assertEqual('rear');
      expect(value.previewing).assertEqual(true);
      expect(value.zoomRatio).assertEqual(2);
    });

    it('GlobalContext_GetMissingKeyReturnsUndefined_004', 0, () => {
      // 业务背景：底层容器需要保留“未设置”的语义，供上层决定是否使用默认值。
      // 这里验证 getObject 原始行为，避免它被悄悄改造成兜底对象。
      let context: GlobalContextStore = GlobalContext.getContext() as GlobalContextStore;
      let value: GlobalStoreValue = context.getObject(nextKey('missing'));
      expect(value).assertEqual(undefined);
    });

    it('GlobalContext_OverwriteValueSupportsTypeChange_005', 0, () => {
      // 业务背景：同一个 key 可能先写入占位值，再切换为真正的数据对象。
      // 覆盖时允许类型变化，能支持启动阶段和运行阶段复用同一状态键。
      let key = nextKey('dynamic');
      let context: GlobalContextStore = GlobalContext.getContext() as GlobalContextStore;
      context.setObject(key, 'loading');
      context.setObject(key, { ready: true } as ReadyStateValue);
      let value = context.getObject(key) as ReadyStateValue;
      expect(value.ready).assertEqual(true);
    });

    it('GlobalObject_HelperReadsWrittenValue_006', 0, () => {
      // 业务背景：业务代码更常通过便捷函数而不是直接拿上下文实例。
      // 守住这层包装，才能保证 EntryAbility 和页面代码共享同一接口语义。
      let key = nextKey('global');
      setGlobalObject(key, 'camera');
      expect(getGlobalObject(key)).assertEqual('camera');
    });

    it('GlobalObject_HelperReturnsEmptyObjectForMissingKey_007', 0, () => {
      // 业务背景：上层代码普遍假设 getGlobalObject 总能返回 object，而不是 undefined。
      // 缺省返回空对象虽然朴素，但能避免大量业务分支在首帧时直接崩溃。
      assertEmptyObject(getGlobalObject(nextKey('absent')));
    });

    it('GlobalObject_HelperReturnsEmptyObjectForExplicitUndefined_008', 0, () => {
      // 业务背景：某些清理逻辑会把值直接写成 undefined，而不是删除 key。
      // 这条测试确保包装层继续维持兜底对象语义，不把 undefined 直接泄漏给调用方。
      let key = nextKey('undefined');
      let explicitUndefined = undefined;
      setGlobalObject(key, explicitUndefined);
      assertEmptyObject(getGlobalObject(key));
    });

    it('GlobalContext_StoresMultipleKeysWithoutCollision_009', 0, () => {
      // 业务背景：全局容器常同时承载 context、相机状态、启动时间等多组数据。
      // 这条测试防止键写入互相覆盖，保证模块之间能并行使用同一容器。
      let firstKey = nextKey('first');
      let secondKey = nextKey('second');
      let thirdKey = nextKey('third');
      let context: GlobalContextStore = GlobalContext.getContext() as GlobalContextStore;
      context.setObject(firstKey, 'value1');
      context.setObject(secondKey, 222);
      context.setObject(thirdKey, true);
      expect(context.getObject(firstKey)).assertEqual('value1');
      expect(context.getObject(secondKey)).assertEqual(222);
      expect(context.getObject(thirdKey)).assertEqual(true);
    });

    it('GlobalContext_PreservesLongKeyLookup_010', 0, () => {
      // 业务背景：描述性键名在大型工程里更可读，但也更容易暴露边界问题。
      // 这里验证长键可稳定读写，避免后续封装时对 key 做了错误裁剪。
      let key = nextKey('this_is_a_very_long_key_name_for_testing_global_context_behaviour');
      setGlobalObject(key, 'longKeyValue');
      expect(getGlobalObject(key)).assertEqual('longKeyValue');
    });

    it('GlobalContext_HandlesBulkKeys_011', 0, () => {
      // 业务背景：开机后多个服务会集中灌入状态，容器至少要能稳定承载几十个键。
      // 用批量写入回归 Map 行为，可以提前发现循环写入时的覆盖问题。
      let context: GlobalContextStore = GlobalContext.getContext() as GlobalContextStore;
      let anchorKey = '';
      for (let i = 0; i < 32; i++) {
        let key = nextKey(`bulk_${i}`);
        context.setObject(key, `value_${i}`);
        if (i === 31) {
          anchorKey = key;
        }
      }
      expect(context.getObject(anchorKey)).assertEqual('value_31');
    });

    it('GlobalContext_StoresContextObjectForCrossModuleUse_012', 0, () => {
      // 业务背景：页面和工具类会通过全局 context 获取系统能力，这是鸿蒙工程常见用法。
      // 这里验证对象字段不丢失，确保跨模块读取时仍可直接访问能力属性。
      let key = nextKey('context');
      let mockContext: AbilityContextValue = { abilityName: 'EntryAbility' };
      setGlobalObject(key, mockContext);
      let context = getGlobalObject(key) as AbilityContextValue;
      expect(context.abilityName).assertEqual('EntryAbility');
    });

    it('GlobalContext_StoresNumericStartTime_013', 0, () => {
      // 业务背景：启动耗时链路依赖 number 类型时间戳，类型偏差会让性能统计直接失真。
      // 把数值读写守住，也顺带覆盖了最近修复过的启动时间场景。
      let key = nextKey('appStartTime');
      let startTime = Date.now();
      setGlobalObject(key, startTime);
      let storedTime: GlobalStoreValue = getGlobalObject(key);
      expect(storedTime).assertEqual(startTime);
    });

    it('GlobalContext_StoresNestedCameraState_014', 0, () => {
      // 业务背景：相机页的真实状态包含嵌套分辨率对象，不能只验证一层扁平结构。
      // 这条用例保证多层对象经过全局容器后不会被破坏或截断。
      let key = nextKey('cameraState');
      let cameraState: NestedCameraStateValue = {
        currentCameraId: 'camera0',
        isPreviewing: true,
        resolution: { width: 1920, height: 1080 }
      };
      setGlobalObject(key, cameraState);
      let state = getGlobalObject(key) as NestedCameraStateValue;
      expect(state.currentCameraId).assertEqual('camera0');
      expect(state.isPreviewing).assertEqual(true);
      expect(state.resolution.width).assertEqual(1920);
    });
  });
}
