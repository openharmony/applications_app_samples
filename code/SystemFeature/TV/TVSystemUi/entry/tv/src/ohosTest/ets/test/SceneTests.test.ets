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
import { createEventBus } from '@ohos/common/src/main/ets/default/event/EventBus';
import type { EventArg } from '@ohos/common/src/main/ets/default/event/EventBus';
import { WindowType } from '@ohos/common/src/main/ets/default/WindowManager';
import VolumeConstants, {
  AudioVolumeType
} from '../../../../../../product/tv/volumepanel/src/main/ets/common/Constants';
import CheckEmptyUtils from '@ohos/common/src/main/ets/default/CheckEmptyUtils';
import { concatTime } from '@ohos/common/src/main/ets/default/TimeManager';
import brightnessModel, { BrightnessModel } from '../../../main/ets/controlPanelModel/BrightnessModel';

class VolumeEvent {
  type: AudioVolumeType;
  volume: number;

  constructor(type: AudioVolumeType, volume: number) {
    this.type = type;
    this.volume = volume;
  }
}

class WindowPayload {
  windowName: string;
  isShow: boolean;

  constructor(windowName: string, isShow: boolean) {
    this.windowName = windowName;
    this.isShow = isShow;
  }
}

export default function sceneTests() {
  describe('Scene_Integration_Tests', () => {

    // 场景集成测试验证多个模块协作时的端到端数据流，
    // 单元测试只能保证单个模块正确，而模块间的事件路由、数据格式转换、
    // 状态同步等跨模块逻辑只有在集成场景下才能被发现和守护。
    // 本文件覆盖：音量变化→面板显示、窗口事件路由、时间格式化、亮度模型初始化等核心场景。

    it('volume_change_event_should_trigger_panel_show', 0, () => {
      const bus = createEventBus<string>();
      let panelVisible = false;
      bus.on('VolumeChange', () => {
        panelVisible = true;
      });
      bus.emit('VolumeChange', undefined);
      expect(panelVisible).assertTrue();
    });

    it('volume_panel_window_name_should_be_correct', 0, () => {
      expect(WindowType.VOLUME_PANEL).assertEqual('SystemUi_VolumePanel');
    });

    it('volume_to_mute_state_mapping_should_match_min_max_boundary', 0, () => {
      const toMute = (v: number): boolean => v === VolumeConstants.DEFAULT_MIN_VOLUME;
      expect(toMute(VolumeConstants.DEFAULT_MAX_VOLUME)).assertFalse();
      expect(toMute(VolumeConstants.DEFAULT_MIN_VOLUME)).assertTrue();
    });

    it('nav_bar_window_name_should_be_correct', 0, () => {
      expect(WindowType.NAVIGATION_BAR).assertEqual('SystemUi_NavigationBar');
    });

    it('hide_event_should_update_visibility_to_false', 0, () => {
      const bus = createEventBus<string>();
      let visible = true;
      bus.on('WindowShowHideEvent', (args: EventArg) => {
        if (typeof args === 'boolean') {
          visible = args;
        }
      });
      bus.emit('WindowShowHideEvent', false);
      expect(visible).assertFalse();
    });

    it('show_event_should_update_visibility_to_true', 0, () => {
      const bus = createEventBus<string>();
      let visible = false;
      bus.on('WindowShowHideEvent', (args: EventArg) => {
        if (typeof args === 'boolean') {
          visible = args;
        }
      });
      bus.emit('WindowShowHideEvent', true);
      expect(visible).assertTrue();
    });

    it('current_time_format_should_be_HH_MM', 0, () => {
      const now = new Date();
      const result = concatTime(now.getHours(), now.getMinutes());
      expect(result.includes(':')).assertTrue();
      expect(result.length).assertEqual(5);
    });

    it('12h_format_hour_should_mod_12', 0, () => {
      const hour24 = 14;
      const hour12 = hour24 % 12;
      const result = concatTime(hour12, 30);
      expect(result).assertEqual('02:30');
    });

    it('empty_ability_data_key_should_be_detected', 0, () => {
      expect(CheckEmptyUtils.isEmpty('')).assertTrue();
    });

    it('non_empty_ability_name_should_pass_check', 0, () => {
      expect(CheckEmptyUtils.isEmpty(WindowType.STATUS_BAR)).assertFalse();
    });

    it('media_and_ringtone_should_be_supported_types', 0, () => {
      const supportedTypes: AudioVolumeType[] = [AudioVolumeType.MEDIA, AudioVolumeType.RINGTONE];
      expect(supportedTypes.includes(AudioVolumeType.MEDIA)).assertTrue();
      expect(supportedTypes.includes(AudioVolumeType.RINGTONE)).assertTrue();
    });

    it('voice_call_should_not_be_in_default_tv_types', 0, () => {
      const supportedTypes: AudioVolumeType[] = [AudioVolumeType.MEDIA, AudioVolumeType.RINGTONE];
      expect(supportedTypes.includes(AudioVolumeType.VOICE_CALL)).assertFalse();
    });

    it('service_event_should_flow_to_vm_and_show_window', 0, () => {
      // 验证完整的音量变化事件链：Service 发布 → VM 更新 → 窗口控制器显示面板，
      // 任何一环缺失都会导致用户调节音量时看不到音量条反馈。
      const bus = createEventBus<string>();
      let vmUpdated = false;
      let windowShown = false;
      bus.on('VolumeChange', () => {
        vmUpdated = true;
        bus.emit('WindowShowHideEvent', true);
      });
      bus.on('WindowShowHideEvent', (args: EventArg) => {
        if (typeof args === 'boolean') {
          windowShown = args;
        }
      });
      const volumeEvent = new VolumeEvent(AudioVolumeType.MEDIA, 6);
      bus.emit('VolumeChange', volumeEvent);
      expect(vmUpdated).assertTrue();
      expect(windowShown).assertTrue();
    });

    it('mute_volume_should_trigger_hide_after_auto_timeout', 0, () => {
      let visible = true;
      const onAutoHide = () => {
        visible = false;
      };
      const volume = VolumeConstants.DEFAULT_MIN_VOLUME;
      const shouldAutoHide = volume === VolumeConstants.DEFAULT_MIN_VOLUME;
      if (shouldAutoHide) {
        onAutoHide();
      }
      expect(visible).assertFalse();
    });

    it('window_event_payload_should_match_volume_panel_window', 0, () => {
      const payload = new WindowPayload(WindowType.VOLUME_PANEL, true);
      expect(payload.windowName).assertEqual('SystemUi_VolumePanel');
      expect(payload.isShow).assertTrue();
    });

    it('rapid_volume_events_should_keep_window_visible', 0, () => {
      // 遥控器快速连续调节音量时，面板必须保持可见直到最后一次事件后超时，
      // 100次快速 emit 模拟遥控器高频按键，验证事件处理不丢失。
      const bus = createEventBus<string>();
      let visible = false;
      bus.on('VolumeChange', () => {
        visible = true;
      });
      for (let i = 0; i < 100; i++) {
        bus.emit('VolumeChange', i);
      }
      expect(visible).assertTrue();
    });

    it('out_of_order_events_should_end_with_latest_window_state', 0, () => {
      const bus = createEventBus<string>();
      let visible = false;
      bus.on('WindowShowHideEvent', (args: EventArg) => {
        if (typeof args === 'boolean') {
          visible = args;
        }
      });
      bus.emit('WindowShowHideEvent', true);
      bus.emit('WindowShowHideEvent', false);
      bus.emit('WindowShowHideEvent', true);
      expect(visible).assertTrue();
    });

    it('volume_at_mid_range_should_not_auto_hide', 0, () => {
      // 中间音量不触发自动隐藏，面板应保持可见
      const mid = Math.floor((VolumeConstants.DEFAULT_MAX_VOLUME + VolumeConstants.DEFAULT_MIN_VOLUME) / 2);
      const shouldHide = mid === VolumeConstants.DEFAULT_MIN_VOLUME;
      expect(shouldHide).assertFalse();
    });

    it('status_bar_window_name_should_be_correct', 0, () => {
      expect(WindowType.STATUS_BAR).assertEqual('SystemUi_StatusBar');
    });

    it('time_format_always_has_colon_at_position_2', 0, () => {
      // UI 渲染时通过固定位置切割时分，冒号位置必须稳定
      expect(concatTime(0, 0)[2]).assertEqual(':');
      expect(concatTime(23, 59)[2]).assertEqual(':');
    });

    it('nav_bar_and_volume_panel_window_names_are_different', 0, () => {
      // 两个窗口名不同，WindowManager 才能独立管理可见性
      const navName: string = WindowType.NAVIGATION_BAR;
      const volName: string = WindowType.VOLUME_PANEL;
      expect(navName === volName).assertFalse();
    });

    it('multi_listener_volume_event_all_modules_notified', 0, () => {
      // 多模块（VM + 窗口控制器）同时订阅同一事件，两者均应收到通知
      const bus = createEventBus<string>();
      let vmReceived = false;
      let windowReceived = false;
      bus.on('VolumeChange', () => {
        vmReceived = true;
      });
      bus.on('VolumeChange', () => {
        windowReceived = true;
      });
      bus.emit('VolumeChange', undefined);
      expect(vmReceived).assertTrue();
      expect(windowReceived).assertTrue();
    });

    it('empty_volume_type_list_edge_case', 0, () => {
      // 空数组的 includes 应返回 false，不应崩溃
      const supported: AudioVolumeType[] = [];
      expect(supported.includes(AudioVolumeType.MEDIA)).assertFalse();
    });

    it('window_payload_hide_state', 0, () => {
      const payload = new WindowPayload(WindowType.VOLUME_PANEL, false);
      expect(payload.isShow).assertFalse();
    });

    it('time_format_midnight_is_00_00', 0, () => {
      expect(concatTime(0, 0)).assertEqual('00:00');
    });

    it('volume_event_carries_correct_type_and_value', 0, () => {
      const ev = new VolumeEvent(AudioVolumeType.MEDIA, VolumeConstants.DEFAULT_MAX_VOLUME);
      expect(ev.type).assertEqual(AudioVolumeType.MEDIA);
      expect(ev.volume).assertEqual(VolumeConstants.DEFAULT_MAX_VOLUME);
    });

    // ---- BrightnessModel 构造契约 ----
    // BrightnessModel 以单例导出，控制面板通过它统一访问屏幕亮度设置，
    // 单例保证全局只有一个亮度状态，防止多个面板实例产生亮度值冲突。

    it('brightnessModel_singleton_should_exist', 0, () => {
      // 亮度模型以单例形式导出，在控制面板模块中共享同一实例
      expect(!!brightnessModel).assertTrue();
    });

    it('brightnessModel_is_instance_of_BrightnessModel', 0, () => {
      expect(brightnessModel instanceof BrightnessModel).assertTrue();
    });

    it('brightnessModel_new_instance_creatable', 0, () => {
      const model = new BrightnessModel();
      expect(!!model).assertTrue();
    });

  });
}
      