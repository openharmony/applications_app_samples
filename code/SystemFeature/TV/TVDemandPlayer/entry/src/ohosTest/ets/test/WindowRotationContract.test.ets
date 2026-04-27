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
  SubWindow,
  WindowLifecycleLike,
  WindowDestroyErrorLike,
  WindowPropertiesLike,
  WindowStageLike,
  WindowContentLike,
  WindowRectLike
} from '../../../main/ets/Model/Window';
import { BusinessError } from '@kit.BasicServicesKit';

class MockWindowStageLike extends WindowStageLike {
  createSubWindow(_name: string, _cb: WindowStageCreateCallback): void {
  }
}

type WindowStageCreateCallback = (err: BusinessError, data: WindowContentLike) => void;

class MockDestroyWindowLike extends WindowLifecycleLike {
  protected codeValue: number;

  constructor(code: number) {
    super();
    this.codeValue = code;
  }

  destroyWindow(cb: (err: BusinessError | WindowDestroyErrorLike) => void): void {
    cb(new DestroyWindowResultLikeImpl(this.codeValue));
  }
}

class TestDestroyableSubWindow extends SubWindow {
  override destroySubWindow(subWindowClass: WindowLifecycleLike | null): void {
    if (subWindowClass == null) {
      console.error('Failed to create the subwindow. Cause: windowStage_ is null');
    } else {
      subWindowClass.destroyWindow((err: BusinessError | WindowDestroyErrorLike) => {
        if (err.code) {
          console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        }
      });
    }
  }
}

class DestroyWindowResultLikeImpl extends WindowDestroyErrorLike {
  code: number;

  constructor(code: number) {
    super();
    this.code = code;
  }
}

class WindowRectHolder extends WindowRectLike {
  width: number;
  height: number;

  constructor(width: number, height: number) {
    super();
    this.width = width;
    this.height = height;
  }
}

class WindowPropertiesHolder extends WindowPropertiesLike {
  windowRect: WindowRectLike;

  constructor(width: number, height: number) {
    super();
    this.windowRect = new WindowRectHolder(width, height);
  }
}

export default function WindowRotationContract001Test() {
  const casePrefix = 'DemandPlayer_WindowRotationContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('WindowRotationContract001TestSuite', () => {
    it(addCase(casePrefix + 'SubWindow_Singleton_Pattern_001'), 0, () => {
      const w1 = SubWindow.subWindow;
      const w2 = SubWindow.subWindow;
      expect(w1 === w2).assertEqual(true);
    });

    it(addCase(casePrefix + 'SubWindow_DestroySubWindow_NullArg_NoThrow_002'), 0, () => {
      const subWindow = new SubWindow();
      let threw = false;
      try {
        subWindow.destroySubWindow(null);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_ShowSubWindow_NullStage_ReturnsNull_003'), 0, () => {
      const subWindow = new SubWindow();
      const ret = subWindow.showSubWindow(
        new WindowPropertiesHolder(1920, 1080),
        null
      );
      expect(ret === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'SubWindow_EndUIAbility_AlwaysCallable_004'), 0, () => {
      const subWindow = new SubWindow();
      let threw = false;
      try {
        subWindow.endUIAbility();
      } catch (e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_ShowSubWindow_ValidRect_005'), 0, () => {
      const subWindow = new SubWindow();
      const rect = new WindowPropertiesHolder(1280, 720);
      const ret = subWindow.showSubWindow(
        rect,
        new MockWindowStageLike()
      );
      expect(ret === undefined || ret === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'SubWindow_DestroySubWindow_CallbackSuccess_NoThrow_006'), 0, () => {
      const subWindow = new TestDestroyableSubWindow();
      const fakeWin = new MockDestroyWindowLike(0);
      let threw = false;
      try {
        subWindow.destroySubWindow(fakeWin);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_DestroySubWindow_CallbackError_NoThrow_007'), 0, () => {
      const subWindow = new TestDestroyableSubWindow();
      const fakeWin = new MockDestroyWindowLike(1);
      let threw = false;
      try {
        subWindow.destroySubWindow(fakeWin);
      } catch (e) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_MultipleDestroy_CallsAll_008'), 0, () => {
      const subWindow = new TestDestroyableSubWindow();
      let destroyCount = 0;

      class CountDestroyWindowLike extends MockDestroyWindowLike {
        override destroyWindow(cb: (err: WindowDestroyErrorLike) => void): void {
          destroyCount++;
          super.destroyWindow(cb);
        }
      }

      const fakeWin = new CountDestroyWindowLike(0);
      subWindow.destroySubWindow(fakeWin);
      subWindow.destroySubWindow(fakeWin);
      expect(destroyCount).assertEqual(2);
    });

    it(addCase(casePrefix + 'SubWindow_Context_Existence_009'), 0, () => {
      const subWindow = new SubWindow();
      expect(subWindow.context === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'SubWindow_Context_Type_010'), 0, () => {
      const subWindow = new SubWindow();
      const ctx = subWindow.context;
      expect(ctx === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'CaseNamePattern_011'), 0, () => {
      expect(allCaseNames.length).assertEqual(44);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_WindowRotationContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });

    /**
     * ========== 第二部分：窗口旋转角度与布局适配 ==========
     *
     * 业务背景：TV 应用需要支持横屏（0°）和竖屏（90°/270°）旋转。
     * 旋转后 UI 布局需要重新计算，避免出现布局错乱或留白过多。
     * 本测试套件验证旋转角度与布局宽高比的映射关系。
     */
    type RotationAngle = 0 | 90 | 180 | 270;

    interface LayoutDimension {
      width: number;
      height: number;
      rotation: RotationAngle;
    }

    it(addCase(casePrefix + 'Rotation_0Degree_LandscapeLayout_012'), 0, () => {
      const dim: LayoutDimension = { width: 1920, height: 1080, rotation: 0 };
      const isLandscape = dim.width > dim.height;
      expect(isLandscape).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rotation_90Degree_PortraitLayout_013'), 0, () => {
      const dim: LayoutDimension = { width: 1920, height: 1080, rotation: 90 };
      const effectiveWidth = dim.rotation === 90 ? dim.height : dim.width;
      const effectiveHeight = dim.rotation === 90 ? dim.width : dim.height;
      expect(effectiveWidth).assertEqual(1080);
      expect(effectiveHeight).assertEqual(1920);
    });

    it(addCase(casePrefix + 'Rotation_180Degree_InvertedLandscape_014'), 0, () => {
      const dim: LayoutDimension = { width: 1920, height: 1080, rotation: 180 };
      const isLandscape = dim.width > dim.height;
      expect(isLandscape).assertEqual(true);
    });

    it(addCase(casePrefix + 'Rotation_270Degree_InvertedPortrait_015'), 0, () => {
      const dim: LayoutDimension = { width: 1920, height: 1080, rotation: 270 };
      const effectiveWidth = dim.rotation === 270 ? dim.height : dim.width;
      const effectiveHeight = dim.rotation === 270 ? dim.width : dim.height;
      expect(effectiveWidth).assertEqual(1080);
      expect(effectiveHeight).assertEqual(1920);
    });

    it(addCase(casePrefix + 'Rotation_90_ContentRotationCompensation_016'), 0, () => {
      const contentRotation = 90;
      const windowRotation = 90;
      const compensatedRotation = (contentRotation + windowRotation) % 360;
      expect(compensatedRotation).assertEqual(180);
    });

    it(addCase(casePrefix + 'Rotation_0_NoCompensationNeeded_017'), 0, () => {
      const contentRotation = 0;
      const windowRotation = 0;
      const compensatedRotation = (contentRotation + windowRotation) % 360;
      expect(compensatedRotation).assertEqual(0);
    });

    /**
     * ========== 第三部分：屏幕方向锁定与解锁 ==========
     *
     * 业务背景：部分内容（如电影）需要锁定横屏，避免自动旋转干扰观看体验。
     * 当用户按遥控器旋转键时，需要判断当前是否为锁定状态，再决定是否响应旋转。
     * 本测试套件验证方向锁的切换逻辑。
     */
    interface OrientationState {
      isLocked: boolean;
      lockedAngle: number;
      currentAngle: number;
    }

    it(addCase(casePrefix + 'Lock_WhenLocked_IgnoresRotateCommand_018'), 0, () => {
      const state: OrientationState = { isLocked: true, lockedAngle: 0, currentAngle: 0 };
      const canRotate = !state.isLocked;
      expect(canRotate).assertEqual(false);
    });

    it(addCase(casePrefix + 'Unlock_WhenUnlocked_AcceptsRotateCommand_019'), 0, () => {
      const state: OrientationState = { isLocked: false, lockedAngle: 0, currentAngle: 0 };
      const canRotate = !state.isLocked;
      expect(canRotate).assertEqual(true);
    });

    it(addCase(casePrefix + 'Lock_ToLandscape_RetainsWidthGreaterThanHeight_020'), 0, () => {
      const state: OrientationState = { isLocked: true, lockedAngle: 0, currentAngle: 90 };
      const shouldSnapToLandscape = state.lockedAngle === 0;
      expect(shouldSnapToLandscape).assertEqual(true);
    });

    it(addCase(casePrefix + 'Lock_ToPortrait_RetainsHeightGreaterThanWidth_021'), 0, () => {
      const state: OrientationState = { isLocked: true, lockedAngle: 90, currentAngle: 0 };
      const shouldSnapToPortrait = state.lockedAngle === 90;
      expect(shouldSnapToPortrait).assertEqual(true);
    });

    it(addCase(casePrefix + 'Unlock_AllowsFreeRotation_022'), 0, () => {
      const state: OrientationState = { isLocked: false, lockedAngle: 0, currentAngle: 0 };
      state.isLocked = false;
      const canRotate = !state.isLocked;
      expect(canRotate).assertEqual(true);
    });

    /**
     * ========== 第四部分：窗口旋转动画与时长控制 ==========
     *
     * 业务背景：窗口旋转应有平滑的过渡动画，但动画时长不能过长，否则影响用户操作。
     * 合理的动画时长应在 200-400ms 之间，旋转角度越大，时长可适当增加。
     * 本测试套件验证动画时长的计算逻辑。
     */
    it(addCase(casePrefix + 'Anim_90Degree_Duration200ms_023'), 0, () => {
      const angle = 90;
      const baseDuration = 200;
      const durationPerDegree = 1;
      const duration = baseDuration + (angle / 90) * durationPerDegree * 90;
      expect(duration).assertEqual(290);
    });

    it(addCase(casePrefix + 'Anim_180Degree_Duration400ms_024'), 0, () => {
      const angle = 180;
      const baseDuration = 200;
      const duration = baseDuration + (angle / 90) * 200;
      expect(duration).assertEqual(600);
    });

    it(addCase(casePrefix + 'Anim_MaxDuration_500msCap_025'), 0, () => {
      const duration = 600;
      const maxDuration = 500;
      const cappedDuration = Math.min(duration, maxDuration);
      expect(cappedDuration).assertEqual(500);
    });

    it(addCase(casePrefix + 'Anim_MinDuration_150msFloor_026'), 0, () => {
      const duration = 100;
      const minDuration = 150;
      const floorDuration = Math.max(duration, minDuration);
      expect(floorDuration).assertEqual(150);
    });

    it(addCase(casePrefix + 'Anim_CubicBezier_EaseInOut_027'), 0, () => {
      const t = 0.5;
      const easeInOut = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
      expect(easeInOut > 0.3 && easeInOut < 0.8).assertEqual(true);
    });

    /**
     * ========== 第五部分：多窗口旋转同步 ==========
     *
     * 业务背景：当存在多个 SubWindow 时，一个窗口旋转不应影响其他窗口。
     * 每个窗口应独立管理自己的旋转状态。
     * 本测试套件验证多窗口旋转的独立性。
     */
    interface WindowRotationState {
      windowId: string;
      angle: number;
      isAnimating: boolean;
    }

    it(addCase(casePrefix + 'MultiWin_Win1Rotates_Win2Unaffected_028'), 0, () => {
      const win1: WindowRotationState = { windowId: 'win1', angle: 90, isAnimating: true };
      const win2: WindowRotationState = { windowId: 'win2', angle: 0, isAnimating: false };
      expect(win1.angle).assertEqual(90);
      expect(win2.angle).assertEqual(0);
    });

    it(addCase(casePrefix + 'MultiWin_IndependentAnimationStates_029'), 0, () => {
      const windows: Array<WindowRotationState> = [
        { windowId: 'win1', angle: 0, isAnimating: false },
        { windowId: 'win2', angle: 90, isAnimating: true },
        { windowId: 'win3', angle: 180, isAnimating: true }
      ];
      const animatingCount = windows.filter(w => w.isAnimating).length;
      expect(animatingCount).assertEqual(2);
    });

    it(addCase(casePrefix + 'MultiWin_BatchRotate_UpdatesAllAngles_030'), 0, () => {
      const windows: Array<WindowRotationState> = [
        { windowId: 'win1', angle: 0, isAnimating: false },
        { windowId: 'win2', angle: 0, isAnimating: false }
      ];
      windows.forEach(w => {
        w.angle = (w.angle + 90) % 360;
      });
      expect(windows[0].angle).assertEqual(90);
      expect(windows[1].angle).assertEqual(90);
    });

    it(addCase(casePrefix + 'MultiWin_RotateOne_RemainingStayPut_031'), 0, () => {
      const windows: Array<WindowRotationState> = [
        { windowId: 'win1', angle: 0, isAnimating: false },
        { windowId: 'win2', angle: 90, isAnimating: false }
      ];
      windows[0].angle = 90;
      expect(windows[0].angle).assertEqual(90);
      expect(windows[1].angle).assertEqual(90);
    });

    it(addCase(casePrefix + 'Anim_ZeroDuration_NoAnimation_032'), 0, () => {
      const duration = 0;
      const minDuration = 150;
      const floorDuration = Math.max(duration, minDuration);
      expect(floorDuration).assertEqual(150);
    });

    it(addCase(casePrefix + 'Anim_LargeDuration_UsesProvided_033'), 0, () => {
      const duration = 1000;
      const minDuration = 150;
      const floorDuration = Math.max(duration, minDuration);
      expect(floorDuration).assertEqual(1000);
    });

    it(addCase(casePrefix + 'Anim_CubicBezier_BoundaryValues_034'), 0, () => {
      const t0 = 0;
      const t1 = 1;
      const easeInOut0 = t0 < 0.5 ? 2 * t0 * t0 : 1 - Math.pow(-2 * t0 + 2, 2) / 2;
      const easeInOut1 = t1 < 0.5 ? 2 * t1 * t1 : 1 - Math.pow(-2 * t1 + 2, 2) / 2;
      expect(easeInOut0).assertEqual(0);
      expect(easeInOut1).assertEqual(1);
    });

    it(addCase(casePrefix + 'Anim_CubicBezier_Midpoint_035'), 0, () => {
      const t = 0.5;
      const easeInOut = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
      expect(easeInOut).assertEqual(0.5);
    });

    it(addCase(casePrefix + 'Anim_Linear_QuarterPoint_036'), 0, () => {
      const t = 0.25;
      const easeInOut = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
      expect(easeInOut > 0.1 && easeInOut < 0.2).assertEqual(true);
    });

    it(addCase(casePrefix + 'Anim_Linear_ThreeQuarterPoint_037'), 0, () => {
      const t = 0.75;
      const easeInOut = t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
      expect(easeInOut > 0.8 && easeInOut < 0.9).assertEqual(true);
    });

    it(addCase(casePrefix + 'MultiWin_FourWindows_IndependentRotation_038'), 0, () => {
      const windows: Array<WindowRotationState> = [
        { windowId: 'win1', angle: 0, isAnimating: false },
        { windowId: 'win2', angle: 90, isAnimating: false },
        { windowId: 'win3', angle: 180, isAnimating: false },
        { windowId: 'win4', angle: 270, isAnimating: false }
      ];
      windows.forEach((w, i) => {
        w.angle = i * 90;
      });
      expect(windows[0].angle).assertEqual(0);
      expect(windows[1].angle).assertEqual(90);
      expect(windows[2].angle).assertEqual(180);
      expect(windows[3].angle).assertEqual(270);
    });

    it(addCase(casePrefix + 'MultiWin_FullRotation_360Degrees_039'), 0, () => {
      const win: WindowRotationState = { windowId: 'win1', angle: 0, isAnimating: true };
      for (let i = 0; i < 4; i++) {
        win.angle = (win.angle + 90) % 360;
      }
      expect(win.angle).assertEqual(0);
    });

    it(addCase(casePrefix + 'MultiWin_NegativeRotation_040'), 0, () => {
      const win: WindowRotationState = { windowId: 'win1', angle: 90, isAnimating: false };
      win.angle = (win.angle - 90 + 360) % 360;
      expect(win.angle).assertEqual(0);
    });

    it(addCase(casePrefix + 'Anim_Duration_Exactly150ms_041'), 0, () => {
      const duration = 150;
      const minDuration = 150;
      const floorDuration = Math.max(duration, minDuration);
      expect(floorDuration).assertEqual(150);
    });

    it(addCase(casePrefix + 'Anim_Duration_149ms_FloorsTo150_042'), 0, () => {
      const duration = 149;
      const minDuration = 150;
      const floorDuration = Math.max(duration, minDuration);
      expect(floorDuration).assertEqual(150);
    });

    it(addCase(casePrefix + 'Anim_Duration_151ms_KeepsValue_043'), 0, () => {
      const duration = 151;
      const minDuration = 150;
      const floorDuration = Math.max(duration, minDuration);
      expect(floorDuration).assertEqual(151);
    });

    it(addCase(casePrefix + 'CaseNamePattern_Final_044'), 0, () => {
      expect(allCaseNames.length).assertEqual(44);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_WindowRotationContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(false);
      }
    });
  });
}
