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
import CameraSettingsManager from '../../../../main/ets/model/CameraSettingsManager';

type SettingsListener = (key: string, value: string) => void;

interface CameraSettingsManagerApi {
  getSetting(key: string): string;
  setSetting(key: string, value: string): boolean;
  getAllSettings(): Record<string, string>;
  saveSettings(): boolean;
  loadSettings(): boolean;
  resetSettings(): boolean;
  validateSetting(key: string, value: string): boolean;
  addListener(listener: SettingsListener): boolean;
  removeListener(listener: SettingsListener): boolean;
}

interface CameraSettingsManagerPrivateApi extends CameraSettingsManagerApi {
  settings: Map<string, string>;
  listeners: SettingsListener[];
}

interface KeyValueCase {
  key: string;
  value: string;
}

/**
 * 功能描述：获取带内部状态访问能力的待测实例。
 * 参数说明：无。
 * 返回值：`CameraSettingsManagerPrivateApi`，用于测试级状态复位与监听器隔离。
 */
function getManager(): CameraSettingsManagerPrivateApi {
  return CameraSettingsManager as Object as CameraSettingsManagerPrivateApi;
}

/**
 * 功能描述：把单例恢复为可重复测试的初始状态。
 * 参数说明：`manager` 为待测设置管理实例。
 * 返回值：void，用于清空监听器、副作用键和非默认设置。
 */
function resetManagerState(manager: CameraSettingsManagerPrivateApi): void {
  manager.settings = new Map<string, string>([
    ['photoResolution', '1920x1080'],
    ['videoResolution', '1080p']
  ]);
  manager.listeners = [];
}

/**
 * 功能描述：把监听轨迹拼成稳定字符串。
 * 参数说明：`records` 为按触发顺序收集的监听日志。
 * 返回值：string，用于验证回调顺序和次数而不引入复杂对象比较。
 */
function joinRecords(records: string[]): string {
  return records.join('|');
}

/**
 * 功能描述：注册 CameraSettingsManager 主测试集合。
 * 参数说明：无。
 * 返回值：void，用于向 Hypium 挂载设置状态、监听和重置契约测试。
 */
export default function CameraSettingsManagerTest(): void {
  describe('CameraSettingsManagerTest', () => {
    let manager: CameraSettingsManagerPrivateApi;

    beforeEach(() => {
      // 业务背景：CameraSettingsManager 是单例，前一条用例留下的监听器会污染后一条用例。
      // 直接重建内部 Map 和监听数组，才能保证矩阵测试在真实单例上保持彼此独立。
      manager = getManager();
      resetManagerState(manager);
    });

    afterEach(() => {
      // 业务背景：部分用例会故意写入自定义键和重复监听器。
      // 在 afterEach 统一回收内部状态，可以避免“上一次合法副作用变成下一次前置条件”。
      resetManagerState(manager);
    });

    it('CameraSettingsManager_SingletonReferenceIsStable_001', 0, () => {
      // 业务背景：设置管理被多个页面共享，单例引用漂移会让设置页和相机页读取不同状态。
      // 这里先锁定单例契约，再开展后续所有状态类测试。
      expect(getManager() === getManager()).assertTrue();
    });

    it('CameraSettingsManager_DefaultSettingsAreReadable_002', 0, () => {
      // 业务背景：首次启动时页面要直接读取默认分辨率，否则 UI 会出现空文案。
      // 同时验证两个默认键，避免 reset 只恢复其中一个键的半失效状态。
      expect(manager.getSetting('photoResolution')).assertEqual('1920x1080');
      expect(manager.getSetting('videoResolution')).assertEqual('1080p');
    });

    it('CameraSettingsManager_UnknownKeyReturnsEmptyString_003', 0, () => {
      // 业务背景：未配置项在现状实现中使用空字符串代表“没有值”。
      // 固化这个边界行为，调用方以后升级成异常或 null 时能及时感知变更。
      expect(manager.getSetting('not-exist')).assertEqual('');
    });

    it('CameraSettingsManager_SetSettingPersistsLastValue_004', 0, () => {
      // 业务背景：设置页连续修改同一项时，最终生效值必须是最后一次提交。
      // 这条用例验证 Map 中没有保留过期值或被回调链回滚。
      expect(manager.setSetting('photoResolution', '2560x1440')).assertTrue();
      expect(manager.setSetting('photoResolution', '3840x2160')).assertTrue();
      expect(manager.getSetting('photoResolution')).assertEqual('3840x2160');
    });

    it('CameraSettingsManager_GetAllSettingsContainsDefaultsAndCustomKeys_005', 0, () => {
      // 业务背景：设置页保存前通常会取完整快照，因此自定义键和值都必须可见。
      // 这里同时覆盖默认键保留和新键追加，避免 getAllSettings 只返回部分字段。
      manager.setSetting('photoResolution', '2560x1440');
      manager.setSetting('captureMode', 'night');

      let snapshot = manager.getAllSettings();
      expect(snapshot.photoResolution).assertEqual('2560x1440');
      expect(snapshot.videoResolution).assertEqual('1080p');
      expect(snapshot.captureMode).assertEqual('night');
    });

    it('CameraSettingsManager_GetAllSettingsReturnsDetachedSnapshot_006', 0, () => {
      // 业务背景：UI 层经常会在快照上做临时拼装，如果返回内部引用会反向污染真实设置。
      // 通过篡改快照再回读单例，能够验证对外暴露的是只读语义的副本。
      let snapshot = manager.getAllSettings();
      snapshot.photoResolution = 'mutated-by-ui';
      snapshot.videoResolution = 'mutated-video';

      expect(manager.getSetting('photoResolution')).assertEqual('1920x1080');
      expect(manager.getSetting('videoResolution')).assertEqual('1080p');
    });

    it('CameraSettingsManager_ResetSettingsRestoresDefaultCoreKeys_007', 0, () => {
      // 业务背景：恢复默认设置是用户纠错的重要兜底路径，核心键必须回到出厂值。
      // 测试先写入非默认值，再验证 reset 是否对核心配置真正生效。
      manager.setSetting('photoResolution', '3840x2160');
      manager.setSetting('videoResolution', '4k');

      expect(manager.resetSettings()).assertTrue();
      expect(manager.getSetting('photoResolution')).assertEqual('1920x1080');
      expect(manager.getSetting('videoResolution')).assertEqual('1080p');
    });

    it('CameraSettingsManager_ResetSettingsKeepsExtendedKeys_008', 0, () => {
      // 业务背景：当前 reset 只重置核心键，不会主动清理扩展键。
      // 这是现状行为而非理想设计，先用测试固化，后续若重构清理策略可以显式评估兼容性。
      manager.setSetting('captureMode', 'portrait');
      manager.setSetting('watermark', 'enabled');

      manager.resetSettings();

      expect(manager.getSetting('captureMode')).assertEqual('portrait');
      expect(manager.getSetting('watermark')).assertEqual('enabled');
    });

    it('CameraSettingsManager_ValidatePhotoResolutionRequiresSeparator_009', 0, () => {
      // 业务背景：图片分辨率的最低合法性约束是包含宽高分隔符 x。
      // 这类浅校验虽然简单，但直接决定设置页是否会拦下明显无效输入。
      expect(manager.validateSetting('photoResolution', '3840x2160')).assertTrue();
      expect(manager.validateSetting('photoResolution', '38402160')).assertFalse();
    });

    it('CameraSettingsManager_ValidateNonResolutionRequiresNonEmptyValue_010', 0, () => {
      // 业务背景：非分辨率字段当前按“非空即可”处理，属于统一的宽松校验契约。
      // 这里覆盖 true/false 两个分支，避免未来把空字符串悄悄放行。
      expect(manager.validateSetting('captureMode', 'night')).assertTrue();
      expect(manager.validateSetting('captureMode', '')).assertFalse();
    });

    it('CameraSettingsManager_AddListenerTriggersCallbackOnMutation_011', 0, () => {
      // 业务背景：设置联动依赖监听器实时刷新页面和业务模型。
      // 只测 add/remove 的返回值没有意义，必须验证真正发生回调。
      let records: string[] = [];
      let listener: SettingsListener = (key: string, value: string): void => {
        records.push(`${key}=${value}`);
      };

      manager.addListener(listener);
      manager.setSetting('photoResolution', '2560x1440');

      expect(joinRecords(records)).assertEqual('photoResolution=2560x1440');
    });

    it('CameraSettingsManager_ListenersFireInRegistrationOrder_012', 0, () => {
      // 业务背景：多个子系统可能依赖回调先后顺序做缓存更新与界面刷新。
      // 固定顺序可以减少联动状态错乱，所以这里直接验证触发序列。
      let records: string[] = [];
      let first: SettingsListener = (key: string, value: string): void => {
        records.push(`first:${key}:${value}`);
      };
      let second: SettingsListener = (key: string, value: string): void => {
        records.push(`second:${key}:${value}`);
      };

      manager.addListener(first);
      manager.addListener(second);
      manager.setSetting('captureMode', 'macro');

      expect(joinRecords(records)).assertEqual('first:captureMode:macro|second:captureMode:macro');
    });

    it('CameraSettingsManager_DuplicateListenerRegistrationTriggersTwice_013', 0, () => {
      // 业务背景：当前实现没有去重监听器，重复注册会产生重复通知。
      // 这个行为本身未必理想，但必须先被固定，否则排查重复刷新时没有行为基线。
      let count = 0;
      let listener: SettingsListener = (): void => {
        count++;
      };

      manager.addListener(listener);
      manager.addListener(listener);
      manager.setSetting('timer', '3s');

      expect(count).assertEqual(2);
    });

    it('CameraSettingsManager_RemoveListenerStopsFutureNotifications_014', 0, () => {
      // 业务背景：页面销毁后若监听器仍被触发，最常见的问题就是内存泄漏和脏 UI 更新。
      // 这里先订阅再移除，再做一次设置变更，确保旧观察者已经完全退出。
      let count = 0;
      let listener: SettingsListener = (): void => {
        count++;
      };

      manager.addListener(listener);
      manager.removeListener(listener);
      manager.setSetting('ratio', '16:9');

      expect(count).assertEqual(0);
    });

    it('CameraSettingsManager_RemoveListenerRemovesAllDuplicateReferences_015', 0, () => {
      // 业务背景：当前 remove 使用 filter，会把同一引用的重复注册全部移除。
      // 这是现状契约，锁定后能帮助后续重构时评估是否需要改成只移除一次。
      let count = 0;
      let listener: SettingsListener = (): void => {
        count++;
      };

      manager.addListener(listener);
      manager.addListener(listener);
      manager.removeListener(listener);
      manager.setSetting('hdr', 'on');

      expect(count).assertEqual(0);
    });

    it('CameraSettingsManager_RemoveListenerDoesNotAffectOtherListeners_016', 0, () => {
      // 业务背景：一个模块注销监听不应伤害其他仍在工作的模块。
      // 这条用例验证删除条件是按引用匹配，而不是粗暴清空整个监听数组。
      let records: string[] = [];
      let listenerA: SettingsListener = (): void => {
        records.push('A');
      };
      let listenerB: SettingsListener = (): void => {
        records.push('B');
      };

      manager.addListener(listenerA);
      manager.addListener(listenerB);
      manager.removeListener(listenerA);
      manager.setSetting('hdr', 'off');

      expect(joinRecords(records)).assertEqual('B');
    });

    it('CameraSettingsManager_ListenerCanReadLatestValueSynchronously_017', 0, () => {
      // 业务背景：某些监听器会立即回读当前值刷新页面，要求回调与写入在同一事务中完成。
      // 如果回调早于写入落库，就会读到旧值，形成“通知到了但 UI 没更新”的假象。
      let observedValue = '';
      let listener: SettingsListener = (key: string): void => {
        observedValue = manager.getSetting(key);
      };

      manager.addListener(listener);
      manager.setSetting('photoResolution', '4096x2160');

      expect(observedValue).assertEqual('4096x2160');
    });

    it('CameraSettingsManager_SaveAndLoadRemainTrueAfterMutations_018', 0, () => {
      // 业务背景：虽然当前 save/load 还是占位实现，但调用方已经按成功路径串联流程。
      // 先写入多组设置再调用，可以把“只在初始状态返回 true”的伪实现排除掉。
      let pairs: KeyValueCase[] = [
        { key: 'photoResolution', value: '2560x1440' },
        { key: 'videoResolution', value: '720p' },
        { key: 'captureMode', value: 'night' }
      ];

      for (let index = 0; index < pairs.length; index++) {
        manager.setSetting(pairs[index].key, pairs[index].value);
      }

      expect(manager.saveSettings()).assertTrue();
      expect(manager.loadSettings()).assertTrue();
    });

    it('CameraSettingsManager_HighFrequencyUpdatesKeepFinalSnapshotConsistent_019', 0, () => {
      // 业务背景：滑杆或快速切换按钮会在很短时间内产生大量连续写入。
      // 重点不是性能数字，而是高频更新后最终快照仍然自洽且可读取。
      for (let index = 0; index < 60; index++) {
        manager.setSetting('exposure', `ev-${index}`);
      }

      let snapshot = manager.getAllSettings();
      expect(manager.getSetting('exposure')).assertEqual('ev-59');
      expect(snapshot.exposure).assertEqual('ev-59');
    });

    it('CameraSettingsManager_BulkCustomSettingsAreExposedThroughSnapshot_020', 0, () => {
      // 业务背景：后续功能扩展会不断新增键，设置管理至少要支持透明透传。
      // 用批量新键验证可扩展性，避免只对两个默认字段有效的伪通过。
      for (let index = 0; index < 20; index++) {
        manager.setSetting(`custom.${index}`, `value.${index}`);
      }

      let snapshot = manager.getAllSettings();
      expect(snapshot['custom.0']).assertEqual('value.0');
      expect(snapshot['custom.19']).assertEqual('value.19');
    });
  });
}
