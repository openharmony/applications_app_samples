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

/**
 * 回放恢复场景测试合并文件
 *
 * 业务背景：回放恢复场景是播放器类 TV 应用最容易漏测的部分。
 * 本文件汇聚了播放器idle计时器、缓冲加载、页面退出、字幕更新、视频切换等场景。
 */

interface ReplayState {
  isPlaying: boolean;
  videoLoading: boolean;
  settingVisible: boolean;
  transferVisible: boolean;
  timeNotOperated: number;
}

interface ReplayProgressState {
  currentTime: number;
  totalTime: number;
  isPlaying: boolean;
  videoLoading: boolean;
  subtitle: string;
}

class ReplayStateHolder implements ReplayState {
  isPlaying: boolean;
  videoLoading: boolean;
  settingVisible: boolean;
  transferVisible: boolean;
  timeNotOperated: number;

  constructor(isPlaying: boolean, videoLoading: boolean, settingVisible: boolean,
    transferVisible: boolean, timeNotOperated: number) {
    this.isPlaying = isPlaying;
    this.videoLoading = videoLoading;
    this.settingVisible = settingVisible;
    this.transferVisible = transferVisible;
    this.timeNotOperated = timeNotOperated;
  }
}

class ReplayProgressStateHolder implements ReplayProgressState {
  currentTime: number;
  totalTime: number;
  isPlaying: boolean;
  videoLoading: boolean;
  subtitle: string;

  constructor(currentTime: number, totalTime: number, isPlaying: boolean, videoLoading: boolean, subtitle: string) {
    this.currentTime = currentTime;
    this.totalTime = totalTime;
    this.isPlaying = isPlaying;
    this.videoLoading = videoLoading;
    this.subtitle = subtitle;
  }
}

function nextIdleReplayState(state: ReplayState): ReplayState {
  const nextTime = state.isPlaying && !state.settingVisible && !state.transferVisible
    ? state.timeNotOperated + 1
    : 0;
  const shouldHide = nextTime >= 4;
  return new ReplayStateHolder(
    state.isPlaying,
    state.videoLoading,
    shouldHide ? false : state.settingVisible,
    state.transferVisible,
    shouldHide ? 0 : nextTime
  );
}

function shouldShowLoadingOnBuffer(cachedDuration: number, isPlaying: boolean): boolean {
  return isPlaying && cachedDuration < 500;
}

function shouldQuitPlayOnPageHide(isBackQuitPlay: boolean): boolean {
  return !isBackQuitPlay;
}

function shouldResetTransferLoading(networkId?: string): boolean {
  return !!networkId;
}

function applyTimeUpdate(state: ReplayProgressState, nextTime: number): ReplayProgressState {
  return new ReplayProgressStateHolder(
    nextTime,
    state.totalTime,
    state.isPlaying,
    state.videoLoading,
    state.subtitle
  );
}

function applyDurationUpdate(state: ReplayProgressState, nextTotal: number): ReplayProgressState {
  return new ReplayProgressStateHolder(
    state.currentTime,
    nextTotal,
    state.isPlaying,
    state.videoLoading,
    state.subtitle
  );
}

function applySubtitleUpdate(state: ReplayProgressState, subtitle: string): ReplayProgressState {
  return new ReplayProgressStateHolder(
    state.currentTime,
    state.totalTime,
    state.isPlaying,
    state.videoLoading,
    subtitle
  );
}

function clearSubtitleOnHide(state: ReplayProgressState): ReplayProgressState {
  return new ReplayProgressStateHolder(
    state.currentTime,
    state.totalTime,
    state.isPlaying,
    state.videoLoading,
    ''
  );
}

function shouldStartLoadingOnVideoSwitch(url: string): boolean {
  return url.length > 0;
}

export default function ReplayRecoveryScenarioTest() {
  const casePrefix = 'DemandPlayer_ReplayRecoveryScenario_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  /**
   * ========== 第一部分：Idle计时器与页面恢复规则 ==========
   */
  describe('ReplayRecoveryScenario_IdleTimerRules', () => {
    it(addCase(casePrefix + 'IdleTimer_ProgressWhenPlaying_001'), 0, () => {
      const next = nextIdleReplayState(new ReplayStateHolder(true, false, false, false, 1));
      expect(next.timeNotOperated).assertEqual(2);
    });

    it(addCase(casePrefix + 'IdleTimer_ResetWhenPopupVisible_002'), 0, () => {
      const next = nextIdleReplayState(new ReplayStateHolder(true, false, true, false, 3));
      expect(next.timeNotOperated).assertEqual(0);
    });

    it(addCase(casePrefix + 'IdleTimer_HideAtThreshold_003'), 0, () => {
      const next = nextIdleReplayState(new ReplayStateHolder(true, false, true, false, 4));
      expect(next.timeNotOperated).assertEqual(0);
    });

    it(addCase(casePrefix + 'BufferingRule_ShowLoading_004'), 0, () => {
      expect(shouldShowLoadingOnBuffer(100, true)).assertEqual(true);
      expect(shouldShowLoadingOnBuffer(800, true)).assertEqual(false);
      expect(shouldShowLoadingOnBuffer(100, false)).assertEqual(false);
    });

    it(addCase(casePrefix + 'PageHide_QuitPlayRule_005'), 0, () => {
      expect(shouldQuitPlayOnPageHide(false)).assertEqual(true);
      expect(shouldQuitPlayOnPageHide(true)).assertEqual(false);
    });

    it(addCase(casePrefix + 'TransferReset_RequiresNetworkId_006'), 0, () => {
      expect(shouldResetTransferLoading('network-1')).assertEqual(true);
      expect(shouldResetTransferLoading('')).assertEqual(false);
    });

    it(addCase(casePrefix + 'ScenarioData_KeepTransferVisibleIfNotThreshold_007'), 0, () => {
      const next = nextIdleReplayState(new ReplayStateHolder(false, false, false, true, 2));
      expect(next.transferVisible).assertEqual(true);
      expect(next.timeNotOperated).assertEqual(0);
    });

    it(addCase(casePrefix + 'ScenarioData_KeepStateStableWhenPaused_008'), 0, () => {
      const next = nextIdleReplayState(new ReplayStateHolder(false, false, false, false, 1));
      expect(next.timeNotOperated).assertEqual(0);
    });

    /**
     * ========== 第二部分：播放进度与字幕更新规则 ==========
     */
    it(addCase(casePrefix + 'TimeUpdate_Projection_009'), 0, () => {
      const next = applyTimeUpdate({
        currentTime: 0,
        totalTime: 10000,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, 3200);
      expect(next.currentTime).assertEqual(3200);
    });

    it(addCase(casePrefix + 'DurationUpdate_Projection_010'), 0, () => {
      const next = applyDurationUpdate({
        currentTime: 1000,
        totalTime: 0,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, 9000);
      expect(next.totalTime).assertEqual(9000);
    });

    it(addCase(casePrefix + 'SubtitleUpdate_Projection_011'), 0, () => {
      const next = applySubtitleUpdate({
        currentTime: 1000,
        totalTime: 9000,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, 'hello world');
      expect(next.subtitle).assertEqual('hello world');
    });

    it(addCase(casePrefix + 'SubtitleClear_OnPageHide_012'), 0, () => {
      const next = clearSubtitleOnHide({
        currentTime: 1000,
        totalTime: 9000,
        isPlaying: false,
        videoLoading: false,
        subtitle: 'caption'
      });
      expect(next.subtitle).assertEqual('');
    });

    it(addCase(casePrefix + 'VideoSwitch_StartsLoadingWithUrl_013'), 0, () => {
      expect(shouldStartLoadingOnVideoSwitch('https://example.com/a.mp4')).assertEqual(true);
      expect(shouldStartLoadingOnVideoSwitch('')).assertEqual(false);
    });

    it(addCase(casePrefix + 'TimeUpdate_DoesNotChangeSubtitle_014'), 0, () => {
      const next = applyTimeUpdate({
        currentTime: 0,
        totalTime: 5000,
        isPlaying: true,
        videoLoading: true,
        subtitle: 'keep'
      }, 2000);
      expect(next.subtitle).assertEqual('keep');
    });

    it(addCase(casePrefix + 'DurationUpdate_DoesNotChangePlayState_015'), 0, () => {
      const next = applyDurationUpdate({
        currentTime: 0,
        totalTime: 0,
        isPlaying: false,
        videoLoading: false,
        subtitle: ''
      }, 5000);
      expect(next.isPlaying).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubtitleUpdate_PreservesCurrentTime_016'), 0, () => {
      const next = applySubtitleUpdate({
        currentTime: 2500,
        totalTime: 5000,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, '字幕');
      expect(next.currentTime).assertEqual(2500);
    });

    it(addCase(casePrefix + 'CaseNamePattern_017'), 0, () => {
      expect(allCaseNames.length).assertEqual(43);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_ReplayRecoveryScenario_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'IdleTimer_ProgressToThreshold_018'), 0, () => {
      const next = nextIdleReplayState({
        isPlaying: true,
        videoLoading: false,
        settingVisible: false,
        transferVisible: false,
        timeNotOperated: 2
      });
      expect(next.timeNotOperated).assertEqual(3);
    });

    it(addCase(casePrefix + 'IdleTimer_ExactlyAtThreshold_019'), 0, () => {
      const next = nextIdleReplayState({
        isPlaying: true,
        videoLoading: false,
        settingVisible: false,
        transferVisible: false,
        timeNotOperated: 3
      });
      expect(next.timeNotOperated).assertEqual(0);
    });

    it(addCase(casePrefix + 'IdleTimer_BeyondThreshold_Hides_020'), 0, () => {
      const next = nextIdleReplayState({
        isPlaying: true,
        videoLoading: false,
        settingVisible: false,
        transferVisible: false,
        timeNotOperated: 4
      });
      expect(next.timeNotOperated).assertEqual(0);
      expect(next.settingVisible).assertEqual(false);
    });

    it(addCase(casePrefix + 'IdleTimer_PausedState_NoProgress_021'), 0, () => {
      const next = nextIdleReplayState({
        isPlaying: false,
        videoLoading: false,
        settingVisible: false,
        transferVisible: false,
        timeNotOperated: 3
      });
      expect(next.timeNotOperated).assertEqual(0);
    });

    it(addCase(casePrefix + 'IdleTimer_TransferVisible_ResetsCounter_022'), 0, () => {
      const next = nextIdleReplayState({
        isPlaying: true,
        videoLoading: false,
        settingVisible: false,
        transferVisible: true,
        timeNotOperated: 3
      });
      expect(next.timeNotOperated).assertEqual(0);
      expect(next.transferVisible).assertEqual(true);
    });

    it(addCase(casePrefix + 'BufferingRule_BufferFull_NoLoading_023'), 0, () => {
      expect(shouldShowLoadingOnBuffer(1000, true)).assertEqual(false);
      expect(shouldShowLoadingOnBuffer(500, true)).assertEqual(false);
    });

    it(addCase(casePrefix + 'BufferingRule_NotPlaying_NoLoading_024'), 0, () => {
      expect(shouldShowLoadingOnBuffer(100, false)).assertEqual(false);
      expect(shouldShowLoadingOnBuffer(0, false)).assertEqual(false);
    });

    it(addCase(casePrefix + 'PageHide_ForwardQuitPlayRule_025'), 0, () => {
      expect(shouldQuitPlayOnPageHide(true)).assertEqual(false);
      expect(shouldQuitPlayOnPageHide(false)).assertEqual(true);
    });

    it(addCase(casePrefix + 'TransferReset_NoNetworkId_NoReset_026'), 0, () => {
      expect(shouldResetTransferLoading('')).assertEqual(false);
      expect(shouldResetTransferLoading(undefined)).assertEqual(false);
    });

    it(addCase(casePrefix + 'TransferReset_WithNetworkId_Resets_027'), 0, () => {
      expect(shouldResetTransferLoading('device-123')).assertEqual(true);
      expect(shouldResetTransferLoading('abc')).assertEqual(true);
    });

    it(addCase(casePrefix + 'TimeUpdate_ZeroStart_028'), 0, () => {
      const next = applyTimeUpdate({
        currentTime: 0,
        totalTime: 10000,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, 0);
      expect(next.currentTime).assertEqual(0);
    });

    it(addCase(casePrefix + 'TimeUpdate_EndOfVideo_029'), 0, () => {
      const next = applyTimeUpdate({
        currentTime: 0,
        totalTime: 10000,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, 10000);
      expect(next.currentTime).assertEqual(10000);
    });

    it(addCase(casePrefix + 'DurationUpdate_ZeroStart_030'), 0, () => {
      const next = applyDurationUpdate({
        currentTime: 0,
        totalTime: 0,
        isPlaying: true,
        videoLoading: true,
        subtitle: ''
      }, 0);
      expect(next.totalTime).assertEqual(0);
    });

    it(addCase(casePrefix + 'DurationUpdate_LargeVideo_031'), 0, () => {
      const next = applyDurationUpdate({
        currentTime: 0,
        totalTime: 0,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, 7200000);
      expect(next.totalTime).assertEqual(7200000);
    });

    it(addCase(casePrefix + 'SubtitleUpdate_EmptyString_032'), 0, () => {
      const next = applySubtitleUpdate({
        currentTime: 1000,
        totalTime: 5000,
        isPlaying: true,
        videoLoading: false,
        subtitle: 'old'
      }, '');
      expect(next.subtitle).assertEqual('');
    });

    it(addCase(casePrefix + 'SubtitleUpdate_UnicodeText_033'), 0, () => {
      const next = applySubtitleUpdate({
        currentTime: 1000,
        totalTime: 5000,
        isPlaying: true,
        videoLoading: false,
        subtitle: ''
      }, '中文字幕测试');
      expect(next.subtitle).assertEqual('中文字幕测试');
    });

    it(addCase(casePrefix + 'SubtitleClear_AlreadyEmpty_034'), 0, () => {
      const next = clearSubtitleOnHide({
        currentTime: 1000,
        totalTime: 5000,
        isPlaying: false,
        videoLoading: false,
        subtitle: ''
      });
      expect(next.subtitle).assertEqual('');
    });

    it(addCase(casePrefix + 'VideoSwitch_EmptyUrl_NoLoading_035'), 0, () => {
      expect(shouldStartLoadingOnVideoSwitch('')).assertEqual(false);
      expect(shouldStartLoadingOnVideoSwitch(String(null))).assertEqual(true);
    });

    it(addCase(casePrefix + 'VideoSwitch_LocalFile_StartsLoading_036'), 0, () => {
      expect(shouldStartLoadingOnVideoSwitch('/data/video.mp4')).assertEqual(true);
      expect(shouldStartLoadingOnVideoSwitch('file:///storage/video.mkv')).assertEqual(true);
    });

    it(addCase(casePrefix + 'TimeUpdate_PreservesOtherFields_037'), 0, () => {
      const state = new ReplayProgressStateHolder(0, 5000, true, false, 'test');
      const next = applyTimeUpdate(state, 2500);
      expect(next.currentTime).assertEqual(2500);
      expect(next.totalTime).assertEqual(5000);
      expect(next.isPlaying).assertEqual(true);
      expect(next.subtitle).assertEqual('test');
    });

    it(addCase(casePrefix + 'DurationUpdate_PreservesOtherFields_038'), 0, () => {
      const state = new ReplayProgressStateHolder(1000, 0, true, false, 'test');
      const next = applyDurationUpdate(state, 6000);
      expect(next.totalTime).assertEqual(6000);
      expect(next.currentTime).assertEqual(1000);
      expect(next.isPlaying).assertEqual(true);
      expect(next.subtitle).assertEqual('test');
    });

    it(addCase(casePrefix + 'SubtitleUpdate_PreservesOtherFields_039'), 0, () => {
      const state = new ReplayProgressStateHolder(1500, 5000, true, false, '');
      const next = applySubtitleUpdate(state, 'new subtitle');
      expect(next.subtitle).assertEqual('new subtitle');
      expect(next.currentTime).assertEqual(1500);
      expect(next.totalTime).assertEqual(5000);
    });

    it(addCase(casePrefix + 'IdleTimer_SettingVisible_DoesNotResetOnTransfer_040'), 0, () => {
      const next = nextIdleReplayState(new ReplayStateHolder(true, false, true, true, 3));
      expect(next.timeNotOperated).assertEqual(0);
    });

    it(addCase(casePrefix + 'IdleTimer_NeitherPopupVisible_Progresses_041'), 0, () => {
      const next = nextIdleReplayState(new ReplayStateHolder(true, false, false, false, 0));
      expect(next.timeNotOperated).assertEqual(1);
    });

    it(addCase(casePrefix + 'BufferingRule_Boundary500ms_042'), 0, () => {
      expect(shouldShowLoadingOnBuffer(499, true)).assertEqual(true);
      expect(shouldShowLoadingOnBuffer(500, true)).assertEqual(false);
      expect(shouldShowLoadingOnBuffer(501, true)).assertEqual(false);
    });

    it(addCase(casePrefix + 'CaseNamePattern_Final_043'), 0, () => {
      expect(allCaseNames.length).assertEqual(43);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_ReplayRecoveryScenario_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
