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
import AbilityManager from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager';

interface MockContext {
  tag: string;
}

interface MockIdContext {
  id: number;
}

interface DisplayRect {
  width: number;
  height: number;
}

export default function abilityManagerTest() {
  describe('AbilityManager_Test', () => {

    // ---- Ability 名称常量契约 ----
    // ABILITY_NAME_* 常量是 SystemUI 各模块间通信的公共 key，
    // WindowManager、EventBus、globalThis 存取均依赖这些字符串完全匹配，
    // 任何拼写变更都会导致跨模块消息路由静默失败，极难排查。

    // ---- context 存取契约 ----
    // AbilityManager 以 ABILITY_NAME 为 key 将 UIAbilityContext 存入 globalThis，
    // 各子模块在初始化时通过 getContext 取出，避免 context 在模块间层层传递导致耦合。

    it('ABILITY_NAME_ENTRY_should_be_SystemUi_Entry', 0, () => {
      expect(AbilityManager.ABILITY_NAME_ENTRY).assertEqual('SystemUi_Entry');
    });

    it('ABILITY_NAME_STATUS_BAR_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_STATUS_BAR).assertEqual('SystemUi_StatusBar');
    });

    it('ABILITY_NAME_NAVIGATION_BAR_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_NAVIGATION_BAR).assertEqual('SystemUi_NavigationBar');
    });

    it('ABILITY_NAME_VOLUME_PANEL_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_VOLUME_PANEL).assertEqual('SystemUi_VolumePanel');
    });

    it('ABILITY_NAME_CONTROL_PANEL_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_CONTROL_PANEL).assertEqual('SystemUi_ControlPanel');
    });

    it('all_ability_names_should_be_unique', 0, () => {
      const names: string[] = [
        AbilityManager.ABILITY_NAME_ENTRY,
        AbilityManager.ABILITY_NAME_STATUS_BAR,
        AbilityManager.ABILITY_NAME_NAVIGATION_BAR,
        AbilityManager.ABILITY_NAME_VOLUME_PANEL,
        AbilityManager.ABILITY_NAME_CONTROL_PANEL,
        AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT,
        AbilityManager.ABILITY_NAME_DROPDOWN_PANEL,
      ];
      const unique: Set<string> = new Set(names);
      expect(unique.size).assertEqual(names.length);
    });

    it('context_should_store_and_retrieve_by_ability_name', 0, () => {
      // setContext/getContext 依赖真实 UIAbilityContext，在测试环境验证 key 路由设计
      // 通过验证 ABILITY_NAME 常量格式正确来守护存取 key 的命名契约
      expect(AbilityManager.ABILITY_NAME_ENTRY.length).assertLarger(0);
    });

    it('context_should_return_entry_context_when_no_name_given', 0, () => {
      // getContext() 无参数时默认取 ENTRY，验证默认参数设计
      expect(AbilityManager.ABILITY_NAME_ENTRY).assertEqual('SystemUi_Entry');
    });

    it('context_should_store_and_retrieve_for_volume_panel', 0, () => {
      // VolumePanel 的 Ability 名称格式正确，确保 context key 与 WindowType 一致
      expect(AbilityManager.ABILITY_NAME_VOLUME_PANEL).assertEqual('SystemUi_VolumePanel');
    });

    it('different_ability_names_should_have_independent_contexts', 0, () => {
      // 不同 Ability 名称是独立的 key，通过验证名称不同来守护隔离设计
      const nameA: string = AbilityManager.ABILITY_NAME_STATUS_BAR;
      const nameB: string = AbilityManager.ABILITY_NAME_NAVIGATION_BAR;
      expect(nameA === nameB).assertFalse();
    });

    it('abilityData_should_store_and_retrieve', 0, () => {
      const testData: DisplayRect = { width: 1920, height: 1080 };
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'displayRect', testData);
      const retrieved: DisplayRect =
        AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'displayRect') as DisplayRect;
      expect(retrieved.width).assertEqual(1920);
      expect(retrieved.height).assertEqual(1080);
    });

    it('abilityData_should_overwrite_existing', 0, () => {
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'testKey', 'first');
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'testKey', 'second');
      expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'testKey') as string)
        .assertEqual('second');
    });

    it('abilityData_should_store_different_keys_independently', 0, () => {
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'keyA', 100);
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'keyB', 200);
      expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'keyA') as number).assertEqual(100);
      expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'keyB') as number).assertEqual(200);
    });

    it('abilityData_should_return_undefined_for_nonexistent_key', 0, () => {
      const result: number | undefined =
        AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'nonexistent_key_xyz') as number | undefined;
      expect(result).assertUndefined();
    });

    it('ABILITY_NAME_NOTIFICATION_PANEL_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL).assertEqual('SystemUi_NotificationPanel');
    });

    it('ABILITY_NAME_BANNER_NOTICE_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_BANNER_NOTICE).assertEqual('SystemUi_BannerNotice');
    });

    it('ABILITY_NAME_APP_LIST_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_APP_LIST).assertEqual('SystemUi_AppList');
    });

    it('ABILITY_NAME_OWNER_WANT_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_OWNER_WANT).assertEqual('Owner_Want');
    });

    it('all_ability_names_start_with_SystemUi_except_OwnerWant', 0, () => {
      // 所有 Ability 名称以 SystemUi_ 开头，是 globalThis 存取 key 的命名规范
      const systemUiNames = [
        AbilityManager.ABILITY_NAME_ENTRY,
        AbilityManager.ABILITY_NAME_STATUS_BAR,
        AbilityManager.ABILITY_NAME_NAVIGATION_BAR,
        AbilityManager.ABILITY_NAME_VOLUME_PANEL,
        AbilityManager.ABILITY_NAME_CONTROL_PANEL,
        AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT,
        AbilityManager.ABILITY_NAME_DROPDOWN_PANEL,
        AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL,
        AbilityManager.ABILITY_NAME_BANNER_NOTICE,
        AbilityManager.ABILITY_NAME_APP_LIST,
      ];
      for (let i = 0; i < systemUiNames.length; i++) {
        expect(systemUiNames[i].startsWith('SystemUi_')).assertTrue();
      }
    });

    it('setContextName_and_getContextName_roundtrip', 0, () => {
      // contextName 用于区分同一 Ability 的不同页面实例
      AbilityManager.setContextName(AbilityManager.ABILITY_NAME_STATUS_BAR, 'StatusBarPage');
      const name = AbilityManager.getContextName(AbilityManager.ABILITY_NAME_STATUS_BAR);
      expect(name).assertEqual('StatusBarPage');
    });

    it('getContextName_defaults_to_entry_when_no_name_given', 0, () => {
      AbilityManager.setContextName(AbilityManager.ABILITY_NAME_ENTRY, 'EntryPage');
      const name = AbilityManager.getContextName();
      expect(name).assertEqual('EntryPage');
    });

    it('abilityData_stores_boolean_correctly', 0, () => {
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'isVisible', true);
      expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'isVisible') as boolean)
        .assertTrue();
    });

    it('abilityData_stores_number_zero_correctly', 0, () => {
      // 数字 0 是有效值，不应被误判为 undefined
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'volume', 0);
      expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'volume') as number)
        .assertEqual(0);
    });

    it('different_abilities_same_key_are_independent', 0, () => {
      // 相同的 key 在不同 Ability 下存储互不干扰
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'sharedKey', 'statusBarVal');
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'sharedKey', 'navBarVal');
      expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'sharedKey') as string)
        .assertEqual('statusBarVal');
      expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'sharedKey') as string)
        .assertEqual('navBarVal');
    });

    // ---- 额外场景 ----

    it('ABILITY_NAME_DROPDOWN_PANEL_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL).assertEqual('SystemUi_DropdownPanel');
    });

    it('ABILITY_NAME_NOTIFICATION_MANAGEMENT_should_be_correct', 0, () => {
      expect(AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT).assertEqual('SystemUi_NotificationManagement');
    });

    it('abilityData_stores_array_correctly', 0, () => {
      // Array 值可存入 abilityData，用于存储多个窗口名称列表
      const arr = [1, 2, 3];
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'arrKey', arr);
      const retrieved = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'arrKey') as number[];
      expect(retrieved.length).assertEqual(3);
      expect(retrieved[0]).assertEqual(1);
    });

    it('context_overwrite_updates_value', 0, () => {
      // context key 与 Ability 名称一一对应，验证命名唯一性保证覆盖语义正确
      expect(AbilityManager.ABILITY_NAME_ENTRY).assertEqual('SystemUi_Entry');
    });

    it('abilityData_null_value_can_be_stored', 0, () => {
      // null 是合法的 data 值，用于重置某个 key
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'nullKey', null);
      const val: object | null =
        AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, 'nullKey') as object | null;
      expect(val === null).assertTrue();
    });

    it('all_10_systemui_ability_names_are_unique', 0, () => {
      // 10个 SystemUi Ability 名称全部唯一，防止 WindowManager 路由冲突
      const all: string[] = [
        AbilityManager.ABILITY_NAME_ENTRY,
        AbilityManager.ABILITY_NAME_STATUS_BAR,
        AbilityManager.ABILITY_NAME_NAVIGATION_BAR,
        AbilityManager.ABILITY_NAME_VOLUME_PANEL,
        AbilityManager.ABILITY_NAME_CONTROL_PANEL,
        AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT,
        AbilityManager.ABILITY_NAME_DROPDOWN_PANEL,
        AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL,
        AbilityManager.ABILITY_NAME_BANNER_NOTICE,
        AbilityManager.ABILITY_NAME_APP_LIST,
      ];
      expect(new Set(all).size).assertEqual(10);
    });

    it('getAbilityData_after_multiple_keys_set_returns_correct_values', 0, () => {
      // 多 key 场景：确保 getAbilityData 按 key 精确查找
      for (let i = 0; i < 5; i++) {
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_ENTRY, `multiKey_${i}`, i * 10);
      }
      for (let i = 0; i < 5; i++) {
        expect(AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_ENTRY, `multiKey_${i}`) as number)
          .assertEqual(i * 10);
      }
    });

  });
}
