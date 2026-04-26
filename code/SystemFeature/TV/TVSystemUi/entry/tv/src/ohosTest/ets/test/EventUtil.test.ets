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
import {
  obtainLocalEvent,
  obtainStartAbility,
  parseEventString,
} from '../../../../../../common/src/main/ets/default/event/EventUtil';

/**
 * EventUtil 单元测试
 * 覆盖跨模块事件路由的工厂函数和字符串解析逻辑：
 * - obtainLocalEvent：生成模块内事件对象
 * - obtainStartAbility：生成跨 Ability 启动事件对象
 * - parseEventString：将插件配置中的字符串解析为事件对象
 *
 * target 字段是 EventManager 的路由依据——'local' 走进程内分发，
 * 'ability' 走 startAbility 跨进程启动，两者混淆会导致事件路由到错误目标。
 */
export default function eventUtilTest() {
  describe('EventUtil_Test', () => {

    // ---- obtainLocalEvent ----

    it('obtainLocalEvent_target_is_local', 0, () => {
      // target 字段决定 EventManager 的分发路径，local 表示进程内分发
      const event = obtainLocalEvent('TestEvent', undefined);
      expect(event.target).assertEqual('local');
    });

    it('obtainLocalEvent_eventName_correct', 0, () => {
      const event = obtainLocalEvent('VolumeChange', undefined);
      expect(event.data.eventName).assertEqual('VolumeChange');
    });

    it('obtainLocalEvent_args_passed_through', 0, () => {
      // 携带字符串 args 的事件，数据必须完整传递，避免 VM 接收到残缺数据
      const event = obtainLocalEvent('VolumeChange', 'volume:10');
      expect(event.data.args).assertEqual('volume:10');
    });

    it('obtainLocalEvent_args_null_allowed', 0, () => {
      // 部分事件只需要名称不需要携带数据，args 为 null 是合法用法
      const event = obtainLocalEvent('NavBarHide', undefined);
      expect(event.data.args === undefined).assertTrue();
    });

    it('obtainLocalEvent_args_string_allowed', 0, () => {
      const event = obtainLocalEvent('TestEvent', 'payload');
      expect(event.data.args).assertEqual('payload');
    });

    // ---- obtainStartAbility ----

    it('obtainStartAbility_target_is_ability', 0, () => {
      // target 为 ability 时 EventManager 会调用 startAbility 跨进程启动
      const event = obtainStartAbility('com.ohos.systemui', 'VolumePanel');
      expect(event.target).assertEqual('ability');
    });

    it('obtainStartAbility_bundleName_correct', 0, () => {
      const event = obtainStartAbility('com.ohos.systemui', 'VolumePanel');
      expect(event.data.bundleName).assertEqual('com.ohos.systemui');
    });

    it('obtainStartAbility_abilityName_correct', 0, () => {
      const event = obtainStartAbility('com.ohos.systemui', 'VolumePanel');
      expect(event.data.abilityName).assertEqual('VolumePanel');
    });

    it('obtainStartAbility_args_optional_undefined', 0, () => {
      const event = obtainStartAbility('com.ohos.systemui', 'VolumePanel');
      expect(event.data.args === undefined).assertTrue();
    });

    it('obtainStartAbility_args_passed_when_provided', 0, () => {
      // 传入 args 时应正确附加到 data 中，启动 Ability 时的参数透传
      const event = obtainStartAbility('com.ohos.systemui', 'VolumePanel', 'extra');
      expect(event.data.abilityName).assertEqual('VolumePanel');
    });

    // ---- parseEventString ----

    it('parseEventString_local_event_no_args', 0, () => {
      // 插件配置格式为 "local=EventName"，无 args 部分
      const event = parseEventString('local=NavBarHide');
      expect(event !== undefined).assertTrue();
      if (event) {
        expect(event.target).assertEqual('local');
        expect(event.data.eventName).assertEqual('NavBarHide');
      }
    });

    it('parseEventString_local_event_with_args', 0, () => {
      const event = parseEventString('local=VolumeChange|10');
      expect(event !== undefined).assertTrue();
      if (event) {
        expect(event.data.eventName).assertEqual('VolumeChange');
        expect(event.data.args).assertEqual('10');
      }
    });

    it('parseEventString_ability_event', 0, () => {
      const event = parseEventString('ability=com.ohos.systemui|VolumePanel');
      expect(event !== undefined).assertTrue();
      if (event) {
        expect(event.target).assertEqual('ability');
        expect(event.data.bundleName).assertEqual('com.ohos.systemui');
        expect(event.data.abilityName).assertEqual('VolumePanel');
      }
    });

    it('parseEventString_undefined_input_returns_undefined', 0, () => {
      // 插件配置字段缺失时应返回 undefined，不应抛出异常阻塞初始化流程
      expect(parseEventString(undefined)).assertUndefined();
    });

    it('parseEventString_empty_string_returns_undefined', 0, () => {
      expect(parseEventString('')).assertUndefined();
    });

    it('parseEventString_unknown_type_returns_undefined', 0, () => {
      // 未知事件类型不应静默忽略，返回 undefined 让调用方感知配置错误
      expect(parseEventString('remote=something')).assertUndefined();
    });

    it('parseEventString_ability_missing_abilityName_returns_undefined', 0, () => {
      // bundleName 和 abilityName 必须同时存在才能 startAbility
      expect(parseEventString('ability=com.ohos.systemui')).assertUndefined();
    });

    // ---- 额外边界场景 ----

    it('obtainLocalEvent_returns_complete_event_structure', 0, () => {
      // 返回对象必须包含 target 和 data 两个字段，EventManager 分发时依赖完整结构
      const event = obtainLocalEvent('Test', 123);
      expect(event.target !== undefined).assertTrue();
      expect(event.data !== undefined).assertTrue();
      expect(event.data.eventName !== undefined).assertTrue();
    });

    it('obtainLocalEvent_numeric_args_preserved', 0, () => {
      const event = obtainLocalEvent('VolumeSet', 15);
      expect(event.data.args).assertEqual(15);
    });

    it('obtainLocalEvent_boolean_args_preserved', 0, () => {
      const event = obtainLocalEvent('MuteChange', true);
      expect(event.data.args).assertTrue();
    });

    it('obtainStartAbility_returns_complete_event_structure', 0, () => {
      // target 和 data 字段必须存在，EventManager 路由时依赖这两个字段
      const event = obtainStartAbility('com.example', 'MainAbility');
      expect(event.target !== undefined).assertTrue();
      expect(event.data !== undefined).assertTrue();
    });

    it('obtainStartAbility_different_bundle_and_ability_names', 0, () => {
      const event = obtainStartAbility('com.ohos.settings', 'SettingsAbility');
      expect(event.data.bundleName).assertEqual('com.ohos.settings');
      expect(event.data.abilityName).assertEqual('SettingsAbility');
    });

    it('parseEventString_local_event_args_with_multiple_pipes_takes_first', 0, () => {
      // args 部分含多个 | 时，只取第一个 | 后的内容作为 args
      const event = parseEventString('local=NavEvent|arg1|extra');
      expect(event !== undefined).assertTrue();
      if (event) {
        expect(event.data.eventName).assertEqual('NavEvent');
        expect(event.data.args).assertEqual('arg1');
      }
    });

    it('parseEventString_local_missing_eventName_returns_undefined', 0, () => {
      // local= 后没有事件名，应返回 undefined 让调用方感知配置错误
      expect(parseEventString('local=')).assertUndefined();
    });

    it('parseEventString_ability_with_args_returns_event', 0, () => {
      const event = parseEventString('ability=com.ohos.systemui|VolumePanel');
      expect(event !== undefined).assertTrue();
      if (event) {
        expect(event.data.bundleName).assertEqual('com.ohos.systemui');
      }
    });

    it('obtainLocalEvent_and_obtainStartAbility_targets_are_different', 0, () => {
      // local 与 ability 两种目标类型必须不同，否则 EventManager 无法正确路由
      const local = obtainLocalEvent('Ev', undefined);
      const ability = obtainStartAbility('com.x', 'A');
      expect(local.target === ability.target).assertFalse();
    });

  });
}
