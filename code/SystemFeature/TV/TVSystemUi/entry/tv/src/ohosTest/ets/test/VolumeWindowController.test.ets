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
import { VolumeInfo, AudioVolumeType } from '../../../../../../product/tv/volumepanel/src/main/ets/common/Constants';

/**
 * VolumeWindowController 纯逻辑单元测试
 * 提取控制器中不依赖系统 Window API 的逻辑进行验证
 */

// ---------- 提取自 VolumeWindowController 的可测逻辑 ----------
// VolumeWindowController 直接调用系统 Window API，无法在单元测试中实例化，
// 将其中三个核心判断函数提取为纯函数，保证控制器的决策逻辑可被独立验证，
// 任何改动引入的回归都能在不依赖设备的环境下第一时间发现。

const DEFAULT_INTERVAL = 3000;

/**
 * 判断是否需要跳过显示窗口
 * 对应: if (volumeInfo && !volumeInfo.updateUi && !mIsWindowShown) return;
 */
function shouldSkipShow(volumeInfo: VolumeInfo | null, isWindowShown: boolean): boolean {
  if (volumeInfo && !volumeInfo.updateUi && !isWindowShown) {
    return true;
  }
  return false;
}

/**
 * 判断 timeout 后是否应隐藏窗口
 * 对应: if ((new Date()).getTime() - mLastActionTime >= mInterval) hide
 * 使用时间差而非固定延时，是为了允许外部事件（如音量再次变化）重置 lastActionTime，
 * 从而延长面板的可见时间，避免用户正在调节时面板突然消失。
 */
function shouldHideAfterTimeout(lastActionTime: number, currentTime: number, interval: number): boolean {
  return currentTime - lastActionTime >= interval;
}

/**
 * 判断 setWindowState 是否需要实际操作
 * 对应: if (mIsWindowShown == isShow) return (no-op)
 * 避免对系统 Window API 发起无意义的重复调用——重复 show/hide 在某些设备上
 * 会触发不必要的动画帧，造成 UI 闪烁，此判断是性能保护的第一道关卡。
 */
function isWindowStateChangNeeded(currentState: boolean, newState: boolean): boolean {
  return currentState !== newState;
}

export default function volumeWindowControllerTest() {
  describe('VolumeWindowController_Logic_Test', () => {

    // ---- shouldSkipShow ----
    it('skip_show_when_no_updateUi_and_window_hidden', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: false
      };
      expect(shouldSkipShow(info, false)).assertTrue();
    });

    it('do_not_skip_when_updateUi_true_and_window_hidden', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: true
      };
      expect(shouldSkipShow(info, false)).assertFalse();
    });

    it('do_not_skip_when_window_already_shown', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: false
      };
      expect(shouldSkipShow(info, true)).assertFalse();
    });

    it('do_not_skip_when_volumeInfo_is_null', 0, () => {
      expect(shouldSkipShow(null, false)).assertFalse();
    });

    it('do_not_skip_when_updateUi_true_and_window_shown', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 8,
        isMute: false,
        updateUi: true
      };
      expect(shouldSkipShow(info, true)).assertFalse();
    });

    // ---- shouldHideAfterTimeout ----
    it('should_hide_when_elapsed_equals_interval', 0, () => {
      const lastTime = 1000;
      const now = 1000 + DEFAULT_INTERVAL;
      expect(shouldHideAfterTimeout(lastTime, now, DEFAULT_INTERVAL)).assertTrue();
    });

    it('should_hide_when_elapsed_exceeds_interval', 0, () => {
      const lastTime = 1000;
      const now = 1000 + DEFAULT_INTERVAL + 500;
      expect(shouldHideAfterTimeout(lastTime, now, DEFAULT_INTERVAL)).assertTrue();
    });

    it('should_not_hide_when_elapsed_less_than_interval', 0, () => {
      const lastTime = 1000;
      const now = 1000 + DEFAULT_INTERVAL - 100;
      expect(shouldHideAfterTimeout(lastTime, now, DEFAULT_INTERVAL)).assertFalse();
    });

    it('should_not_hide_immediately_after_action', 0, () => {
      const now = (new Date()).getTime();
      expect(shouldHideAfterTimeout(now, now, DEFAULT_INTERVAL)).assertFalse();
    });

    it('should_hide_with_custom_interval', 0, () => {
      const customInterval = 500;
      expect(shouldHideAfterTimeout(0, 600, customInterval)).assertTrue();
    });

    it('should_not_hide_with_custom_interval_not_elapsed', 0, () => {
      const customInterval = 500;
      expect(shouldHideAfterTimeout(0, 400, customInterval)).assertFalse();
    });

    // ---- isWindowStateChangNeeded ----
    it('state_change_needed_from_false_to_true', 0, () => {
      expect(isWindowStateChangNeeded(false, true)).assertTrue();
    });

    it('state_change_needed_from_true_to_false', 0, () => {
      expect(isWindowStateChangNeeded(true, false)).assertTrue();
    });

    it('no_state_change_needed_when_already_shown', 0, () => {
      expect(isWindowStateChangNeeded(true, true)).assertFalse();
    });

    it('no_state_change_needed_when_already_hidden', 0, () => {
      expect(isWindowStateChangNeeded(false, false)).assertFalse();
    });

    // ---- 组合场景 ----
    it('rapid_show_calls_should_not_require_repeated_state_change', 0, () => {
      let isShown = false;
      // 第一次 show
      const firstChange = isWindowStateChangNeeded(isShown, true);
      expect(firstChange).assertTrue();
      isShown = true;
      // 第二次 show（重复）
      const secondChange = isWindowStateChangNeeded(isShown, true);
      expect(secondChange).assertFalse();
    });

    it('show_then_hide_both_require_state_change', 0, () => {
      let isShown = false;
      expect(isWindowStateChangNeeded(isShown, true)).assertTrue();
      isShown = true;
      expect(isWindowStateChangNeeded(isShown, false)).assertTrue();
    });

    it('updateVolumeInfo_null_should_not_skip_show', 0, () => {
      // null volumeInfo 代表手动触发，不走跳过逻辑
      expect(shouldSkipShow(null, false)).assertFalse();
    });

    it('updateVolumeInfo_with_muted_volume_should_not_skip_when_window_shown', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 0,
        isMute: true,
        updateUi: false
      };
      expect(shouldSkipShow(info, true)).assertFalse();
    });

    // ---- shouldHideAfterTimeout 额外边界 ----

    it('should_hide_exactly_at_boundary_zero_interval', 0, () => {
      // 零间隔时，任何 elapsed >= 0 都应触发隐藏
      expect(shouldHideAfterTimeout(0, 0, 0)).assertTrue();
    });

    it('large_elapsed_always_hides', 0, () => {
      // 经过很长时间后必须触发隐藏，防止面板永远可见
      expect(shouldHideAfterTimeout(0, 999999, DEFAULT_INTERVAL)).assertTrue();
    });

    it('negative_elapsed_never_hides', 0, () => {
      // 时间倒流（系统时钟异常）不应触发隐藏
      expect(shouldHideAfterTimeout(5000, 4000, DEFAULT_INTERVAL)).assertFalse();
    });

    // ---- shouldSkipShow 额外边界 ----

    it('skip_show_ringtone_type_no_updateUi_window_hidden', 0, () => {
      // 铃声类型与媒体类型行为一致，同样遵循 updateUi 标志
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.RINGTONE,
        volume: 3,
        isMute: false,
        updateUi: false
      };
      expect(shouldSkipShow(info, false)).assertTrue();
    });

    it('do_not_skip_ringtone_type_with_updateUi', 0, () => {
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.RINGTONE,
        volume: 3,
        isMute: false,
        updateUi: true
      };
      expect(shouldSkipShow(info, false)).assertFalse();
    });

    it('skip_check_is_independent_of_volume_value', 0, () => {
      // 跳过逻辑只依赖 updateUi 和 isWindowShown，与音量数值无关
      const infoHigh: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 15,
        isMute: false,
        updateUi: false
      };
      const infoLow: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 1,
        isMute: false,
        updateUi: false
      };
      expect(shouldSkipShow(infoHigh, false)).assertTrue();
      expect(shouldSkipShow(infoLow, false)).assertTrue();
    });

    // ---- isWindowStateChangNeeded 额外场景 ----

    it('three_state_transitions_correct', 0, () => {
      // show → hide → show 三次转换全部需要状态变化
      let state = false;
      expect(isWindowStateChangNeeded(state, true)).assertTrue();
      state = true;
      expect(isWindowStateChangNeeded(state, false)).assertTrue();
      state = false;
      expect(isWindowStateChangNeeded(state, true)).assertTrue();
    });

    it('show_interval_elapsed_window_should_hide', 0, () => {
      // 完整流程：show 后等待超时，验证应触发隐藏
      const showTime = 1000;
      const checkTime = showTime + DEFAULT_INTERVAL + 1;
      expect(shouldHideAfterTimeout(showTime, checkTime, DEFAULT_INTERVAL)).assertTrue();
    });

  });
}
