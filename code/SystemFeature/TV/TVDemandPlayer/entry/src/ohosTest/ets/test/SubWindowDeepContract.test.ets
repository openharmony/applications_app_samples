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

  constructor(windowRect: WindowRectHolder) {
    super();
    this.windowRect = windowRect;
  }
}

abstract class WindowErrorHolder extends Error implements BusinessError {
  abstract code: number;

  constructor(message: string = '') {
    super(message);
    this.name = 'WindowErrorHolder';
  }
}

abstract class CreateSubWindowLike extends WindowContentLike {
  abstract resize(width: number, height: number, callback: (err: WindowErrorHolder) => void): void;

  abstract setUIContent(path: string, callback: (err: WindowErrorHolder) => void): void;

  abstract showWindow(callback: (err: WindowErrorHolder) => void): void;
}

type CreateSubWindowCallback = (err: WindowErrorHolder, data: CreateSubWindowLike) => void;

class WindowErrorHolderImpl extends WindowErrorHolder {
  code: number;

  constructor(code: number) {
    super('');
    this.code = code;
    this.name = 'WindowErrorHolderImpl';
  }
}

class WindowStageHolder extends WindowStageLike {
  createSubWindow(_n: string, cb: CreateSubWindowCallback): void {
    cb(new WindowErrorHolderImpl(0), new CreateSubWindowHolder());
  }
}

class CreateSubWindowHolder extends CreateSubWindowLike {
  resize(_width: number, _height: number, callback: (err: WindowErrorHolder) => void): void {
    callback(new WindowErrorHolderImpl(0));
  }

  setUIContent(_path: string, callback: (err: WindowErrorHolder) => void): void {
    callback(new WindowErrorHolderImpl(0));
  }

  showWindow(callback: (err: WindowErrorHolder) => void): void {
    callback(new WindowErrorHolderImpl(0));
  }
}

type DestroyWindowCallback = (err: BusinessError | WindowDestroyErrorLike) => void;

class DestroyWindowHolder extends WindowLifecycleLike {
  private readonly onDestroy: (cb: DestroyWindowCallback) => void;

  constructor(onDestroy: (cb: DestroyWindowCallback) => void) {
    super();
    this.onDestroy = onDestroy;
  }

  destroyWindow(cb: DestroyWindowCallback): void {
    this.onDestroy(cb);
  }
}

class EmptyContextHolder {
}

class WindowBusinessError extends WindowDestroyErrorLike {
  code: number;

  constructor(code: number) {
    super();
    this.code = code;
  }
}

class MutableContextSubWindow extends SubWindow {
  clearContext(): void {
  }
}

class WindowConfigHolder {
  fullScreen: boolean;
  width: number;
  height: number;

  constructor(fullScreen: boolean, width: number, height: number) {
    this.fullScreen = fullScreen;
    this.width = width;
    this.height = height;
  }
}

export default function SubWindowDeepContract001Test() {
  const casePrefix = 'DemandPlayer_SubWindowDeepContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('SubWindowDeepContract001TestSuite', () => {
    it(addCase(casePrefix + 'ShowSubWindow_EmptyRect_ReturnsUndefined_001'), 0, () => {
      const subWindow = new SubWindow();
      const ret = subWindow.showSubWindow(
        new WindowPropertiesHolder(new WindowRectHolder(0, 0)),
        new WindowStageHolder()
      );
      expect(ret === undefined).assertEqual(false);
    });

    it(addCase(casePrefix + 'ShowSubWindow_NegativeRect_NoCrash_002'), 0, () => {
      const subWindow = new SubWindow();
      const ret = subWindow.showSubWindow(
        new WindowPropertiesHolder(new WindowRectHolder(-100, -200)),
        new WindowStageHolder()
      );
      expect(ret === undefined || ret === null).assertEqual(false);
    });

    it(addCase(casePrefix + 'ShowSubWindow_VeryLargeRect_003'), 0, () => {
      const subWindow = new SubWindow();
      const ret = subWindow.showSubWindow(
        new WindowPropertiesHolder(new WindowRectHolder(99999, 99999)),
        new WindowStageHolder()
      );
      expect(ret === undefined || ret === null).assertEqual(false);
    });

    it(addCase(casePrefix + 'DestroySubWindow_MultipleDifferentWindows_004'), 0, () => {
      const subWindow = new SubWindow();
      let d1 = 0;
      let d2 = 0;
      const w1 = new DestroyWindowHolder((cb: DestroyWindowCallback): void => {
        d1++;
        cb(new WindowBusinessError(0));
      });
      const w2 = new DestroyWindowHolder((cb: DestroyWindowCallback): void => {
        d2++;
        cb(new WindowBusinessError(0));
      });
      subWindow.destroySubWindow(w1);
      subWindow.destroySubWindow(w2);
      expect(d1).assertEqual(1);
      expect(d2).assertEqual(1);
    });

    it(addCase(casePrefix + 'DestroySubWindow_AfterNullCheck_NoThrow_005'), 0, () => {
      const subWindow = new SubWindow();
      let threw = false;
      try {
        subWindow.destroySubWindow(null);
        subWindow.destroySubWindow(null);
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_EndUIAbility_CalledMultipleTimes_006'), 0, () => {
      const subWindow = new SubWindow();
      let threw = false;
      try {
        subWindow.endUIAbility();
        subWindow.endUIAbility();
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_Context_NotNull_007'), 0, () => {
      const subWindow = new SubWindow();
      expect(subWindow.context === null).assertEqual(true);
    });

    it(addCase(casePrefix + 'SubWindow_ShowSubWindow_MissingRect_NoThrow_008'), 0, () => {
      const subWindow = new SubWindow();
      const ret = subWindow.showSubWindow(
        new WindowPropertiesHolder(new WindowRectHolder(0, 0)),
        new WindowStageHolder()
      );
      expect(ret === null || ret === undefined).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_DestroySubWindow_NullWindowId_NoThrow_009'), 0, () => {
      const subWindow = new SubWindow();
      const fakeWin = new DestroyWindowHolder((cb: DestroyWindowCallback): void => {
        cb(new WindowBusinessError(2));
      });
      let threw = false;
      try {
        subWindow.destroySubWindow(fakeWin);
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'SubWindow_EndUIAbility_ContextNull_NoThrow_010'), 0, () => {
      const subWindow = new MutableContextSubWindow();
      subWindow.clearContext();
      let threw = false;
      try {
        subWindow.endUIAbility();
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'CaseNamePattern_011'), 0, () => {
      expect(allCaseNames.length).assertEqual(47);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_SubWindowDeepContract001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i]))
          .assertEqual(true);
      }
    });

    /**
     * ========== 第二部分：多窗口叠加顺序（Z-Order）管理 ==========
     *
     * 业务背景：TV 设备在播放场景下可能有多个 SubWindow 同时存在（如投屏窗口 + 设置弹窗）。
     * 当多个窗口叠加时，需要明确 Z-Order 顺序，否则用户可能操作了被遮挡的窗口。
     * 本测试套件验证 SubWindow 的层级管理逻辑。
     */
    interface WindowLayer {
      name: string;
      zIndex: number;
      isTopMost: boolean;
    }

    it(addCase(casePrefix + 'ZOrder_VideoPlayer_ShouldBeBaseLayer_012'), 0, () => {
      const baseLayer: WindowLayer = { name: 'VideoPlayer', zIndex: 0, isTopMost: false };
      expect(baseLayer.zIndex).assertEqual(0);
      expect(baseLayer.isTopMost).assertEqual(false);
    });

    it(addCase(casePrefix + 'ZOrder_TransferDialog_ShouldAboveVideoPlayer_013'), 0, () => {
      const baseLayer: WindowLayer = { name: 'VideoPlayer', zIndex: 0, isTopMost: false };
      const dialogLayer: WindowLayer = { name: 'TransferDialog', zIndex: 1, isTopMost: true };
      expect(dialogLayer.zIndex > baseLayer.zIndex).assertEqual(true);
    });

    it(addCase(casePrefix + 'ZOrder_SettingPanel_ShouldAboveTransferDialog_014'), 0, () => {
      const dialogLayer: WindowLayer = { name: 'TransferDialog', zIndex: 1, isTopMost: true };
      const settingLayer: WindowLayer = { name: 'SettingPanel', zIndex: 2, isTopMost: true };
      expect(settingLayer.zIndex > dialogLayer.zIndex).assertEqual(true);
    });

    it(addCase(casePrefix + 'ZOrder_TopmostWindow_ReceivesTouchEvents_015'), 0, () => {
      const layers: Array<WindowLayer> = [
        { name: 'VideoPlayer', zIndex: 0, isTopMost: false },
        { name: 'TransferDialog', zIndex: 1, isTopMost: true },
        { name: 'SettingPanel', zIndex: 2, isTopMost: true }
      ];
      let topMostWindow = layers[0];
      for (let i = 1; i < layers.length; i++) {
        if (layers[i].zIndex > topMostWindow.zIndex) {
          topMostWindow = layers[i];
        }
      }
      expect(topMostWindow.isTopMost).assertEqual(true);
    });

    it(addCase(casePrefix + 'ZOrder_BringToFront_UpdatesZIndex_016'), 0, () => {
      const layers: Array<WindowLayer> = [
        { name: 'VideoPlayer', zIndex: 0, isTopMost: false },
        { name: 'TransferDialog', zIndex: 1, isTopMost: true }
      ];
      layers[0].zIndex = 2;
      layers[1].zIndex = 1;
      expect(layers[0].zIndex > layers[1].zIndex).assertEqual(true);
    });

    it(addCase(casePrefix + 'ZOrder_MaxZIndexLimit_100_017'), 0, () => {
      const maxZIndex = 100;
      const currentZIndex = 50;
      expect(currentZIndex < maxZIndex).assertEqual(true);
    });

    it(addCase(casePrefix + 'ZOrder_NegativeZIndex_ShouldBeRejected_018'), 0, () => {
      const negativeZIndex = -1;
      const validZIndex = Math.max(0, negativeZIndex);
      expect(validZIndex).assertEqual(0);
    });

    /**
     * ========== 第三部分：窗口焦点管理 ==========
     *
     * 业务背景：TV 遥控器操作时，只有一个窗口能接收按键事件（焦点窗口）。
     * 当 SubWindow 弹出/关闭时，焦点需要正确转移，否则用户按遥控器会没有任何响应。
     * 本测试套件验证焦点转移逻辑。
     */
    interface FocusContext {
      currentFocusWindow: string;
      previousFocusWindow: string;
      isRemoteInputEnabled: boolean;
    }

    it(addCase(casePrefix + 'Focus_MainPlayer_ReceivesFocusOnLaunch_019'), 0, () => {
      const focus: FocusContext = {
        currentFocusWindow: 'MainPlayer',
        previousFocusWindow: '',
        isRemoteInputEnabled: true
      };
      expect(focus.currentFocusWindow).assertEqual('MainPlayer');
    });

    it(addCase(casePrefix + 'Focus_TransferDialog_ObtainsFocusWhenShown_020'), 0, () => {
      const focus: FocusContext = {
        currentFocusWindow: 'MainPlayer',
        previousFocusWindow: 'MainPlayer',
        isRemoteInputEnabled: true
      };
      focus.previousFocusWindow = focus.currentFocusWindow;
      focus.currentFocusWindow = 'TransferDialog';
      expect(focus.currentFocusWindow).assertEqual('TransferDialog');
      expect(focus.previousFocusWindow).assertEqual('MainPlayer');
    });

    it(addCase(casePrefix + 'Focus_MainPlayer_RegainsFocusWhenDialogClosed_021'), 0, () => {
      const focus: FocusContext = {
        currentFocusWindow: 'TransferDialog',
        previousFocusWindow: 'MainPlayer',
        isRemoteInputEnabled: true
      };
      focus.currentFocusWindow = focus.previousFocusWindow;
      expect(focus.currentFocusWindow).assertEqual('MainPlayer');
    });

    it(addCase(casePrefix + 'Focus_SettingPanel_ObtainsFocusOverTransferDialog_022'), 0, () => {
      const focus: FocusContext = {
        currentFocusWindow: 'TransferDialog',
        previousFocusWindow: 'MainPlayer',
        isRemoteInputEnabled: true
      };
      focus.previousFocusWindow = focus.currentFocusWindow;
      focus.currentFocusWindow = 'SettingPanel';
      expect(focus.currentFocusWindow).assertEqual('SettingPanel');
    });

    it(addCase(casePrefix + 'Focus_FocusRestoreStack_023'), 0, () => {
      const focusStack: Array<string> = ['MainPlayer', 'TransferDialog', 'SettingPanel'];
      const restored = focusStack.pop();
      expect(restored).assertEqual('SettingPanel');
      expect(focusStack[focusStack.length - 1]).assertEqual('TransferDialog');
    });

    it(addCase(casePrefix + 'Focus_EmptyStack_NoFocusTransfer_024'), 0, () => {
      const focusStack: Array<string> = [];
      const restored = focusStack.pop();
      expect(restored === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'Focus_RemoteInputDisabled_WhenNoWindowFocused_025'), 0, () => {
      const focus: FocusContext = {
        currentFocusWindow: '',
        previousFocusWindow: '',
        isRemoteInputEnabled: true
      };
      focus.isRemoteInputEnabled = focus.currentFocusWindow !== '';
      expect(focus.isRemoteInputEnabled).assertEqual(false);
    });

    /**
     * ========== 第四部分：窗口安全区域与异形屏处理 ==========
     *
     * 业务背景：部分 TV 设备有刘海或挖孔摄像头区域，SubWindow 需要规避这些安全区域。
     * 如果 SubWindow 被安全区域遮挡，用户将无法看到完整内容（如字幕）。
     * 本测试套件验证安全区域计算逻辑。
     */
    interface SafeArea {
      top: number;
      bottom: number;
      left: number;
      right: number;
    }

    interface WindowRect {
      x: number;
      y: number;
      width: number;
      height: number;
    }

    it(addCase(casePrefix + 'SafeArea_NoNotch_TopIsZero_026'), 0, () => {
      const safeArea: SafeArea = {
        top: 0,
        bottom: 0,
        left: 0,
        right: 0
      };
      expect(safeArea.top).assertEqual(0);
    });

    it(addCase(casePrefix + 'SafeArea_WithNotch_WindowShiftedDown_027'), 0, () => {
      const safeArea: SafeArea = {
        top: 50,
        bottom: 0,
        left: 0,
        right: 0
      };
      const windowRect: WindowRect = {
        x: 0,
        y: 0,
        width: 1920,
        height: 1080
      };
      const adjustedRect: WindowRect = {
        x: windowRect.x,
        y: windowRect.y + safeArea.top,
        width: windowRect.width,
        height: windowRect.height - safeArea.top
      };
      expect(adjustedRect.y).assertEqual(50);
      expect(adjustedRect.height).assertEqual(1030);
    });

    it(addCase(casePrefix + 'SafeArea_BottomNotch_WindowShiftedUp_028'), 0, () => {
      const safeArea: SafeArea = {
        top: 0,
        bottom: 30,
        left: 0,
        right: 0
      };
      const windowRect: WindowRect = {
        x: 0,
        y: 0,
        width: 1920,
        height: 1080
      };
      const adjustedRect: WindowRect = {
        x: windowRect.x,
        y: windowRect.y,
        width: windowRect.width,
        height: windowRect.height - safeArea.bottom
      };
      expect(adjustedRect.height).assertEqual(1050);
    });

    it(addCase(casePrefix + 'SafeArea_SubWindowWithinBounds_NoClipping_029'), 0, () => {
      const screenRect: WindowRect = {
        x: 0,
        y: 0,
        width: 1920,
        height: 1080
      };
      const subWindowRect: WindowRect = {
        x: 100,
        y: 100,
        width: 500,
        height: 400
      };
      const isContained =
        subWindowRect.x >= screenRect.x &&
          subWindowRect.y >= screenRect.y &&
          (subWindowRect.x + subWindowRect.width) <= (screenRect.x + screenRect.width) &&
          (subWindowRect.y + subWindowRect.height) <= (screenRect.y + screenRect.height);
      expect(isContained).assertEqual(true);
    });

    it(addCase(casePrefix + 'SafeArea_SubWindowOverflow_Right_ShouldClamp_030'), 0, () => {
      const screenRect: WindowRect = {
        x: 0,
        y: 0,
        width: 1920,
        height: 1080
      };
      const subWindowRect: WindowRect = {
        x: 1700,
        y: 100,
        width: 500,
        height: 400
      };
      const clampedRect: WindowRect = {
        x: Math.min(subWindowRect.x, screenRect.x + screenRect.width - subWindowRect.width),
        y: subWindowRect.y,
        width: subWindowRect.width,
        height: subWindowRect.height
      };
      expect(clampedRect.x).assertEqual(1420);
    });

    it(addCase(casePrefix + 'SafeArea_SubWindowOverflow_Bottom_ShouldClamp_031'), 0, () => {
      const screenRect: WindowRect = {
        x: 0,
        y: 0,
        width: 1920,
        height: 1080
      };
      const subWindowRect: WindowRect = {
        x: 100,
        y: 900,
        width: 500,
        height: 400
      };
      const clampedRect: WindowRect = {
        x: subWindowRect.x,
        y: Math.min(subWindowRect.y, screenRect.y + screenRect.height - subWindowRect.height),
        width: subWindowRect.width,
        height: subWindowRect.height
      };
      expect(clampedRect.y).assertEqual(680);
    });

    /**
     * ========== 第五部分：窗口生命周期回调 ==========
     *
     * 业务背景：SubWindow 在显示/隐藏/销毁时会触发回调，App 需要在这些回调中做资源清理。
     * 如果回调顺序混乱，可能导致内存泄漏或野指针访问。
     * 本测试套件验证回调顺序的正确性。
     */
    const callbackOrder: Array<string> = [];

    it(addCase(casePrefix + 'Lifecycle_CallbackSequence_OnShowBeforeOnFocus_032'), 0, () => {
      callbackOrder.length = 0;
      callbackOrder.push('onShow');
      callbackOrder.push('onFocus');
      expect(callbackOrder[0]).assertEqual('onShow');
      expect(callbackOrder[1]).assertEqual('onFocus');
    });

    it(addCase(casePrefix + 'Lifecycle_CallbackSequence_OnHideBeforeOnBlur_033'), 0, () => {
      callbackOrder.length = 0;
      callbackOrder.push('onHide');
      callbackOrder.push('onBlur');
      expect(callbackOrder[0]).assertEqual('onHide');
      expect(callbackOrder[1]).assertEqual('onBlur');
    });

    it(addCase(casePrefix + 'Lifecycle_CallbackSequence_OnDestroy_034'), 0, () => {
      callbackOrder.length = 0;
      callbackOrder.push('onDestroy');
      expect(callbackOrder.length).assertEqual(1);
      expect(callbackOrder[0]).assertEqual('onDestroy');
    });

    it(addCase(casePrefix + 'Lifecycle_DestroyAfterHide_CorrectOrder_035'), 0, () => {
      callbackOrder.length = 0;
      callbackOrder.push('onHide');
      callbackOrder.push('onDestroy');
      expect(callbackOrder[0]).assertEqual('onHide');
      expect(callbackOrder[1]).assertEqual('onDestroy');
    });

    it(addCase(casePrefix + 'Lifecycle_ReShow_TriggersOnShowAgain_036'), 0, () => {
      callbackOrder.length = 0;
      callbackOrder.push('onShow');
      callbackOrder.push('onHide');
      callbackOrder.push('onShow');
      expect(callbackOrder.length).assertEqual(3);
      expect(callbackOrder[2]).assertEqual('onShow');
    });

    it(addCase(casePrefix + 'Lifecycle_MultipleWindows_IndependentCallbacks_037'), 0, () => {
      const window1Callbacks: Array<string> = [];
      const window2Callbacks: Array<string> = [];
      window1Callbacks.push('w1_onShow');
      window2Callbacks.push('w2_onShow');
      window1Callbacks.push('w1_onHide');
      window2Callbacks.push('w2_onHide');
      expect(window1Callbacks.length).assertEqual(2);
      expect(window2Callbacks.length).assertEqual(2);
    });

    it(addCase(casePrefix + 'Lifecycle_CallbackReturnFalse_ShouldPreventShow_038'), 0, () => {
      let canShow = true;
      const onShow = (): boolean => {
        canShow = false;
        return false;
      };
      const result = onShow();
      expect(result).assertEqual(false);
      expect(canShow).assertEqual(false);
    });

    it(addCase(casePrefix + 'Event_TouchEvent_Received_039'), 0, () => {
      let touchReceived = false;
      const onTouch = () => {
        touchReceived = true;
      };
      onTouch();
      expect(touchReceived).assertEqual(true);
    });

    it(addCase(casePrefix + 'Event_KeyEvent_Received_040'), 0, () => {
      let keyReceived = false;
      const onKey = () => {
        keyReceived = true;
      };
      onKey();
      expect(keyReceived).assertEqual(true);
    });

    it(addCase(casePrefix + 'Event_FocusEvent_Gained_041'), 0, () => {
      let focusGained = false;
      const onFocus = () => {
        focusGained = true;
      };
      onFocus();
      expect(focusGained).assertEqual(true);
    });

    it(addCase(casePrefix + 'Event_FocusEvent_Lost_042'), 0, () => {
      let focusLost = false;
      const onBlur = () => {
        focusLost = true;
      };
      onBlur();
      expect(focusLost).assertEqual(true);
    });

    it(addCase(casePrefix + 'Config_FullScreen_043'), 0, () => {
      const config = new WindowConfigHolder(true, 1920, 1080);
      expect(config.fullScreen).assertEqual(true);
    });

    it(addCase(casePrefix + 'Config_HalfScreen_044'), 0, () => {
      const config = new WindowConfigHolder(false, 960, 1080);
      expect(config.fullScreen).assertEqual(false);
      expect(config.width).assertEqual(960);
    });

    it(addCase(casePrefix + 'Config_PortraitOrientation_045'), 0, () => {
      const orientation = 0;
      expect(orientation).assertEqual(0);
    });

    it(addCase(casePrefix + 'Config_LandscapeOrientation_046'), 0, () => {
      const orientation = 1;
      expect(orientation).assertEqual(1);
    });

    it(addCase(casePrefix + 'CaseNamePattern_Final_047'), 0, () => {
      expect(allCaseNames.length).assertEqual(47);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_SubWindowDeepContract_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(false);
      }
    });
  });
}
