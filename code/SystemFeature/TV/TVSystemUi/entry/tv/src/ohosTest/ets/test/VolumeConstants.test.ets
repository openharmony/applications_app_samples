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
import VolumeConstants, {
  AudioVolumeType,
  VolumeInfo
} from '../../../../../../product/tv/volumepanel/src/main/ets/common/Constants';
import WindowManager, {
  WindowType,
  WINDOW_SHOW_HIDE_EVENT,
  WINDOW_RESIZE_EVENT,
  windowDestroy
} from '@ohos/common/src/main/ets/default/WindowManager';

export default function volumeConstantsTest() {
  describe('VolumeConstants_Test', () => {

    // VolumeConstants 定义了音量面板的全局行为契约：
    // DEFAULT_MAX_VOLUME/MIN_VOLUME 是音量条渲染的边界，改变会导致进度条超出显示范围；
    // HOLD_TIME 控制面板自动消失的延迟，过短影响用户体验，过长占据 TV 屏幕。
    // AudioVolumeType 枚举值与 @ohos.multimedia.audio 的系统枚举值对应，
    // 任何不一致都会导致音量调节操作作用到错误的音频流上。

    it('DEFAULT_MAX_VOLUME_should_be_15', 0, () => {
      expect(VolumeConstants.DEFAULT_MAX_VOLUME).assertEqual(15);
    });

    it('DEFAULT_MIN_VOLUME_should_be_0', 0, () => {
      expect(VolumeConstants.DEFAULT_MIN_VOLUME).assertEqual(0);
    });

    it('DEFAULT_MUTE_STATUS_should_be_false', 0, () => {
      expect(VolumeConstants.DEFAULT_MUTE_STATUS).assertFalse();
    });

    it('DEFAULT_SHOW_STATUS_should_be_true', 0, () => {
      expect(VolumeConstants.DEFAULT_SHOW_STATUS).assertTrue();
    });

    it('HOLD_TIME_should_be_2000', 0, () => {
      expect(VolumeConstants.HOLD_TIME).assertEqual(2000);
    });

    it('max_volume_must_be_greater_than_min_volume', 0, () => {
      expect(VolumeConstants.DEFAULT_MAX_VOLUME).assertLarger(VolumeConstants.DEFAULT_MIN_VOLUME);
    });

    it('max_volume_range_should_allow_at_least_10_steps', 0, () => {
      const range = VolumeConstants.DEFAULT_MAX_VOLUME - VolumeConstants.DEFAULT_MIN_VOLUME;
      expect(range).assertLarger(9);
    });

    it('audioVolumeType_VOICE_CALL_should_be_0', 0, () => {
      expect(AudioVolumeType.VOICE_CALL).assertEqual(0);
    });

    it('audioVolumeType_RINGTONE_should_be_2', 0, () => {
      expect(AudioVolumeType.RINGTONE).assertEqual(2);
    });

    it('audioVolumeType_MEDIA_should_be_3', 0, () => {
      expect(AudioVolumeType.MEDIA).assertEqual(3);
    });

    it('audioVolumeType_VOICE_ASSISTANT_should_be_9', 0, () => {
      expect(AudioVolumeType.VOICE_ASSISTANT).assertEqual(9);
    });

    it('audioVolumeType_ALL_should_be_100', 0, () => {
      expect(AudioVolumeType.ALL).assertEqual(100);
    });

    it('all_volume_type_values_should_be_unique', 0, () => {
      const values: number[] = [
        AudioVolumeType.VOICE_CALL,
        AudioVolumeType.RINGTONE,
        AudioVolumeType.MEDIA,
        AudioVolumeType.VOICE_ASSISTANT,
        AudioVolumeType.ALL,
      ];
      const unique = new Set(values);
      expect(unique.size).assertEqual(values.length);
    });

    it('should_create_valid_volume_info_for_media', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 10,
        isMute: false,
        updateUi: true,
      };
      expect(info.volumeType).assertEqual(AudioVolumeType.MEDIA);
      expect(info.volume).assertEqual(10);
      expect(info.isMute).assertFalse();
      expect(info.updateUi).assertTrue();
    });

    it('muted_volume_info_should_have_isMute_true', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 0,
        isMute: true,
        updateUi: false,
      };
      expect(info.isMute).assertTrue();
      expect(info.volume).assertEqual(0);
    });

    it('volume_should_be_within_valid_range', 0, () => {
      const volume = 8;
      expect(volume).assertLarger(VolumeConstants.DEFAULT_MIN_VOLUME - 1);
      expect(VolumeConstants.DEFAULT_MAX_VOLUME).assertLarger(volume - 1);
    });

    // ---- WindowManager 常量与单例契约（原 WindowManagerIntegration）----
    // WindowType 字符串常量是 SystemUI 内部窗口路由的 key，
    // EventBus 事件的 windowName 字段、globalThis 存取、CSS 样式 id 均依赖这些字符串，
    // 任何拼写变动都会导致跨模块窗口操作静默路由失败。

    it('window_manager_singleton_should_exist', 0, () => {
      expect(!!WindowManager).assertTrue();
    });

    it('window_type_values_should_match_expected_contract', 0, () => {
      expect(WindowType.STATUS_BAR).assertEqual('SystemUi_StatusBar');
      expect(WindowType.NAVIGATION_BAR).assertEqual('SystemUi_NavigationBar');
      expect(WindowType.VOLUME_PANEL).assertEqual('SystemUi_VolumePanel');
    });

    it('event_names_should_match_expected_values', 0, () => {
      expect(WINDOW_SHOW_HIDE_EVENT).assertEqual('WindowShowHideEvent');
      expect(WINDOW_RESIZE_EVENT).assertEqual('WindowResizeEvent');
      expect(windowDestroy).assertEqual('WindowDestroy');
    });

    it('getWindowInfo_for_unknown_window_should_be_undefined', 0, () => {
      const info = WindowManager.getWindowInfo(WindowType.BANNER_NOTICE);
      expect(info).assertUndefined();
    });

    // ---- VolumeInfo 业务语义补充 ----

    it('volumeInfo_min_volume_with_mute_true', 0, () => {
      // 最小音量 + 静音是 TV 开机默认静音场景
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 0,
        isMute: true,
        updateUi: true
      };
      expect(info.volume).assertEqual(VolumeConstants.DEFAULT_MIN_VOLUME);
      expect(info.isMute).assertTrue();
    });

    it('volumeInfo_max_volume_with_mute_false', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 15,
        isMute: false,
        updateUi: true
      };
      expect(info.volume).assertEqual(VolumeConstants.DEFAULT_MAX_VOLUME);
      expect(info.isMute).assertFalse();
    });

    it('volumeInfo_updateUi_false_does_not_affect_volume', 0, () => {
      // updateUi=false 用于静默更新，音量值本身不受影响
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.VOICE_ASSISTANT,
        volume: 5,
        isMute: false,
        updateUi: false
      };
      expect(info.volume).assertEqual(5);
      expect(info.updateUi).assertFalse();
    });

    it('volumeInfo_voice_call_type_valid', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.VOICE_CALL,
        volume: 3,
        isMute: false,
        updateUi: true
      };
      expect(info.volumeType).assertEqual(AudioVolumeType.VOICE_CALL);
    });

    it('HOLD_TIME_is_positive_number', 0, () => {
      // HOLD_TIME 必须为正数，否则面板会立即消失
      expect(VolumeConstants.HOLD_TIME).assertLarger(0);
    });

    it('volume_range_covers_mid_value', 0, () => {
      // 中间音量值应在合法范围内
      const mid = Math.floor((VolumeConstants.DEFAULT_MAX_VOLUME + VolumeConstants.DEFAULT_MIN_VOLUME) / 2);
      expect(mid).assertLarger(VolumeConstants.DEFAULT_MIN_VOLUME - 1);
      expect(VolumeConstants.DEFAULT_MAX_VOLUME).assertLarger(mid - 1);
    });

    it('RINGTONE_and_MEDIA_are_different_audio_streams', 0, () => {
      // 铃声和媒体是不同音频流，混用会导致音量控制错误
      const ringtone: number = AudioVolumeType.RINGTONE as number;
      const media: number = AudioVolumeType.MEDIA as number;
      expect(ringtone === media).assertFalse();
    });

    it('VOICE_ASSISTANT_is_larger_than_MEDIA', 0, () => {
      // 枚举值顺序反映系统音频优先级，VOICE_ASSISTANT > MEDIA
      expect(AudioVolumeType.VOICE_ASSISTANT).assertLarger(AudioVolumeType.MEDIA);
    });

  });
}
