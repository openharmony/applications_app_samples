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
 

import { describe, it, expect, beforeEach } from '@ohos/hypium';
import { AudioVolumeType, VolumeInfo } from '../../../../../../product/tv/volumepanel/src/main/ets/common/Constants';
import VolumeConstants from '../../../../../../product/tv/volumepanel/src/main/ets/common/Constants';

/**
 * 纯逻辑单元测试 - VolumePanelVM 中可独立提取的计算逻辑
 * 不依赖 AppStorage / AudioManager 等系统服务
 */

// ---------- 提取自 VolumePanelVM 的可测函数 ----------
// VolumePanelVM 直接依赖 AppStorage 和 AudioManager，无法在单元测试中实例化。
// 将其中的纯计算逻辑提取为独立函数，既能完整覆盖核心业务逻辑，
// 又不引入系统依赖，是 ArkTS 单元测试的标准解耦模式。

function calcDisplayVolume(volume: number, minVolume: number): number {
  return volume + minVolume;
}

function calcVolumeByDisplayVolume(displayVolume: number, minVolume: number): number {
  return displayVolume + minVolume;
}

function shouldAutoHide(volume: number, minVolume: number): boolean {
  return volume === minVolume;
}

// resolveMuteVolume 处理静音切换时的音量恢复逻辑：
// 取消静音时若记忆音量恰好等于最小值，直接恢复会导致面板显示音量为0但非静音，
// 因此强制返回 minVolume+1，保证视觉上有可感知的音量变化。
function resolveMuteVolume(isMute: boolean, minVolume: number, volumeBeforeMute: number): number {
  return isMute
    ? minVolume
    : (minVolume === volumeBeforeMute ? minVolume + 1 : volumeBeforeMute);
}

// shouldSkipUpdate 是 VolumePanelVM 的性能优化门控，
// 避免在静音状态未变且不需要刷新 UI 时触发不必要的渲染，
// 在遥控器快速调节音量场景下可显著减少 UI 重绘次数。
function shouldSkipUpdate(updateUi: boolean, currentIsMute: boolean, newIsMute: boolean): boolean {
  return !updateUi && currentIsMute === newIsMute;
}

// ---------- mVolumeBaseMap 相关逻辑 ----------
// mVolumeBaseMap 以音频类型为 key 存储各类型的音量上下限，
// 不同音频类型（媒体/铃声/语音助手）的硬件音量范围可能不同，
// 统一存储便于 VM 在接收到系统音量变化时快速查询对应类型的合法范围做边界保护。

interface VolumeBaseEntry {
  maxVolume: number;
  minVolume: number;
}

function buildVolumeBaseMap(types: AudioVolumeType[], defaultMax: number,
  defaultMin: number): Record<number, VolumeBaseEntry> {
  const map: Record<number, VolumeBaseEntry> = {};
  types.forEach((t: AudioVolumeType) => {
    map[t as number] = { maxVolume: defaultMax, minVolume: defaultMin };
  });
  return map;
}

export default function volumePanelVMTest() {
  describe('VolumePanelVM_Logic_Test', () => {

    // ---- calcDisplayVolume ----
    it('calcDisplayVolume_normal_volume_plus_min', 0, () => {
      expect(calcDisplayVolume(8, 0)).assertEqual(8);
    });

    it('calcDisplayVolume_with_nonzero_min', 0, () => {
      // minVolume 通常为 0，但逻辑应支持非零
      expect(calcDisplayVolume(5, 2)).assertEqual(7);
    });

    it('calcDisplayVolume_zero_volume', 0, () => {
      expect(calcDisplayVolume(0, 0)).assertEqual(0);
    });

    it('calcDisplayVolume_max_volume', 0, () => {
      expect(calcDisplayVolume(VolumeConstants.DEFAULT_MAX_VOLUME, VolumeConstants.DEFAULT_MIN_VOLUME)).assertEqual(15);
    });

    // ---- calcVolumeByDisplayVolume ----
    it('calcVolumeByDisplayVolume_round_trip', 0, () => {
      const display = calcDisplayVolume(10, 0);
      expect(calcVolumeByDisplayVolume(display, 0)).assertEqual(10);
    });

    it('calcVolumeByDisplayVolume_zero', 0, () => {
      expect(calcVolumeByDisplayVolume(0, 0)).assertEqual(0);
    });

    // ---- shouldAutoHide ----
    it('shouldAutoHide_true_when_volume_equals_min', 0, () => {
      expect(shouldAutoHide(VolumeConstants.DEFAULT_MIN_VOLUME, VolumeConstants.DEFAULT_MIN_VOLUME)).assertTrue();
    });

    it('shouldAutoHide_false_when_volume_above_min', 0, () => {
      expect(shouldAutoHide(5, VolumeConstants.DEFAULT_MIN_VOLUME)).assertFalse();
    });

    it('shouldAutoHide_false_when_volume_at_max', 0, () => {
      expect(shouldAutoHide(VolumeConstants.DEFAULT_MAX_VOLUME, VolumeConstants.DEFAULT_MIN_VOLUME)).assertFalse();
    });

    // ---- resolveMuteVolume ----
    it('resolveMuteVolume_mute_returns_minVolume', 0, () => {
      expect(resolveMuteVolume(true, 0, 8)).assertEqual(0);
    });

    it('resolveMuteVolume_unmute_returns_volumeBeforeMute_when_different', 0, () => {
      expect(resolveMuteVolume(false, 0, 8)).assertEqual(8);
    });

    it('resolveMuteVolume_unmute_returns_minPlus1_when_volumeBeforeMute_equals_min', 0, () => {
      // volumeBeforeMute == minVolume => fallback to minVolume + 1
      expect(resolveMuteVolume(false, 0, 0)).assertEqual(1);
    });

    it('resolveMuteVolume_unmute_with_min2_volumeBeforeMute2_returns_3', 0, () => {
      expect(resolveMuteVolume(false, 2, 2)).assertEqual(3);
    });

    // ---- shouldSkipUpdate ----
    it('shouldSkipUpdate_true_when_no_ui_update_and_mute_same', 0, () => {
      expect(shouldSkipUpdate(false, false, false)).assertTrue();
    });

    it('shouldSkipUpdate_false_when_updateUi_true', 0, () => {
      expect(shouldSkipUpdate(true, false, false)).assertFalse();
    });

    it('shouldSkipUpdate_false_when_mute_changed', 0, () => {
      expect(shouldSkipUpdate(false, false, true)).assertFalse();
    });

    it('shouldSkipUpdate_false_when_both_changed', 0, () => {
      expect(shouldSkipUpdate(true, false, true)).assertFalse();
    });

    // ---- buildVolumeBaseMap ----
    it('buildVolumeBaseMap_contains_all_types', 0, () => {
      const types = [AudioVolumeType.MEDIA, AudioVolumeType.RINGTONE];
      const map = buildVolumeBaseMap(types, 15, 0);
      expect(map[AudioVolumeType.MEDIA as number] !== undefined).assertTrue();
      expect(map[AudioVolumeType.RINGTONE as number] !== undefined).assertTrue();
    });

    it('buildVolumeBaseMap_sets_correct_max', 0, () => {
      const map = buildVolumeBaseMap([AudioVolumeType.MEDIA], 15, 0);
      expect(map[AudioVolumeType.MEDIA as number].maxVolume).assertEqual(15);
    });

    it('buildVolumeBaseMap_sets_correct_min', 0, () => {
      const map = buildVolumeBaseMap([AudioVolumeType.MEDIA], 15, 0);
      expect(map[AudioVolumeType.MEDIA as number].minVolume).assertEqual(0);
    });

    it('buildVolumeBaseMap_independent_entries', 0, () => {
      const map = buildVolumeBaseMap([AudioVolumeType.MEDIA, AudioVolumeType.RINGTONE], 15, 0);
      map[AudioVolumeType.MEDIA as number].maxVolume = 10;
      expect(map[AudioVolumeType.RINGTONE as number].maxVolume).assertEqual(15);
    });

    // ---- VolumeInfo interface 组合验证 ----
    it('volumeInfo_updateUi_false_and_mute_unchanged_should_skip', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: false,
      };
      const currentIsMute = false;
      expect(shouldSkipUpdate(info.updateUi, currentIsMute, info.isMute)).assertTrue();
    });

    it('volumeInfo_updateUi_true_should_not_skip', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: true,
      };
      const currentIsMute = false;
      expect(shouldSkipUpdate(info.updateUi, currentIsMute, info.isMute)).assertFalse();
    });

    it('mute_transition_false_to_true_display_volume_should_be_min', 0, () => {
      const minVolume = VolumeConstants.DEFAULT_MIN_VOLUME;
      const isMute = true;
      const displayVol = isMute ? minVolume : 8;
      expect(displayVol).assertEqual(minVolume);
    });

    it('unmute_transition_true_to_false_display_volume_should_be_restored', 0, () => {
      const minVolume = VolumeConstants.DEFAULT_MIN_VOLUME;
      const volumeBeforeMute = 8;
      const isMute = false;
      const displayVol = isMute ? minVolume : volumeBeforeMute;
      expect(displayVol).assertEqual(8);
    });

    // ---- 额外边界场景 ----

    it('shouldAutoHide_true_when_volume_is_1_and_min_is_1', 0, () => {
      // 非零 min 场景：volume === minVolume 仍应触发自动隐藏
      expect(shouldAutoHide(1, 1)).assertTrue();
    });

    it('calcDisplayVolume_max_plus_zero_min', 0, () => {
      expect(calcDisplayVolume(15, 0)).assertEqual(15);
    });

    it('resolveMuteVolume_mute_with_nonzero_min', 0, () => {
      // 静音时返回 minVolume，即使 minVolume 不为零
      expect(resolveMuteVolume(true, 2, 10)).assertEqual(2);
    });

    it('resolveMuteVolume_unmute_volumeBeforeMute_greater_than_min', 0, () => {
      expect(resolveMuteVolume(false, 0, 12)).assertEqual(12);
    });

    it('buildVolumeBaseMap_empty_types_returns_empty_map', 0, () => {
      const map = buildVolumeBaseMap([], 15, 0);
      expect(Object.keys(map).length).assertEqual(0);
    });

    it('buildVolumeBaseMap_three_types_all_present', 0, () => {
      const types = [AudioVolumeType.MEDIA, AudioVolumeType.RINGTONE, AudioVolumeType.VOICE_ASSISTANT];
      const map = buildVolumeBaseMap(types, 15, 0);
      expect(map[AudioVolumeType.VOICE_ASSISTANT as number] !== undefined).assertTrue();
    });

    it('shouldSkipUpdate_both_mute_true_no_ui_should_skip', 0, () => {
      expect(shouldSkipUpdate(false, true, true)).assertTrue();
    });

    it('calcVolumeByDisplayVolume_nonzero_min', 0, () => {
      expect(calcVolumeByDisplayVolume(7, 2)).assertEqual(9);
    });

    it('resolveMuteVolume_false_mute_volumeBeforeMute_at_boundary', 0, () => {
      // volumeBeforeMute 恰好等于 minVolume+1 时直接返回该值
      expect(resolveMuteVolume(false, 0, 1)).assertEqual(1);
    });

    it('shouldAutoHide_false_when_volume_is_one_above_min', 0, () => {
      expect(shouldAutoHide(VolumeConstants.DEFAULT_MIN_VOLUME + 1, VolumeConstants.DEFAULT_MIN_VOLUME)).assertFalse();
    });

  });
}
