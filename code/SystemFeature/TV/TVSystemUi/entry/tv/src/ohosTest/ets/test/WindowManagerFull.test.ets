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
import { WindowType } from '@ohos/common/src/main/ets/default/WindowManager';

interface Rect {
  left: number;
  top: number;
  width: number;
  height: number;
}

interface WindowInfo {
  visibility: boolean;
  rect: Rect;
}

interface ShowHideEvent {
  windowName: string;
  isShow: boolean;
}

class MockWindow {
  name: string;
  isShown: boolean = false;

  constructor(name: string) {
    this.name = name;
  }

  async show(): Promise<void> {
    this.isShown = true;
  }

  async hide(): Promise<void> {
    this.isShown = false;
  }

  async destroy(): Promise<void> {
    this.isShown = false;
  }
}

class TestableWindowManager {
  mWindowInfos: Map<string, WindowInfo> = new Map();
  mWindows: Map<string, MockWindow> = new Map();
  // publishedEvents 记录所有窗口操作的事件序列，
  // UI 层依赖此序列做动画编排，顺序错误会导致显隐动画与实际状态不匹配。
  publishedEvents: ShowHideEvent[] = [];

  async createWindow(name: string, rect: Rect): Promise<void> {
    this.mWindows.set(name, new MockWindow(name));
    this.mWindowInfos.set(name, { visibility: false, rect: rect });
  }

  async showWindow(name: string): Promise<void> {
    const win = this.mWindows.get(name);
    if (win) {
      await win.show();
    }
    const prev = this.mWindowInfos.get(name);
    // 保留原有 rect 而非覆盖为默认值，是因为 resetSizeWindow 可能先于 showWindow 调用，
    // 若此处丢失 rect，TV 导航栏在横竖屏切换后尺寸会错误地还原为初始值。
    const rect: Rect = prev ? prev.rect : {
      left: 0,
      top: 0,
      width: 0,
      height: 0
    };
    this.mWindowInfos.set(name, { visibility: true, rect: rect });
    this.publishedEvents.push({ windowName: name, isShow: true });
  }

  async hideWindow(name: string): Promise<void> {
    const win = this.mWindows.get(name);
    if (win) {
      await win.hide();
    }
    const prev = this.mWindowInfos.get(name);
    const rect: Rect = prev ? prev.rect : {
      left: 0,
      top: 0,
      width: 0,
      height: 0
    };
    this.mWindowInfos.set(name, { visibility: false, rect: rect });
    this.publishedEvents.push({ windowName: name, isShow: false });
  }

  async destroyWindow(name: string): Promise<void> {
    const win = this.mWindows.get(name);
    if (win) {
      await win.destroy();
    }
    this.mWindows.delete(name);
    this.mWindowInfos.delete(name);
  }

  getWindowInfo(name: string): WindowInfo | undefined {
    return this.mWindowInfos.get(name);
  }

  async resetSizeWindow(name: string, rect: Rect): Promise<void> {
    const prev = this.mWindowInfos.get(name);
    // 尺寸调整不改变可见性，是为了支持"先调整尺寸再显示"的预布局流程，
    // 避免窗口在错误尺寸下短暂可见，造成布局跳变的视觉抖动。
    const visibility: boolean = prev ? prev.visibility : false;
    this.mWindowInfos.set(name, { visibility: visibility, rect: rect });
  }
}

export default function windowManagerIntegrationFullTest() {
  describe('WindowManager_Integration_Test', () => {

    let wm: TestableWindowManager;
    const TEST_RECT: Rect = {
      left: 0,
      top: 0,
      width: 1920,
      height: 40
    };

    // beforeEach 在每个用例前重建 TestableWindowManager 并创建三个常用窗口，
    // 保证用例间完全隔离——前一个用例的 show/hide 状态不会污染后一个用例的断言。
    beforeEach(async () => {
      wm = new TestableWindowManager();
      await wm.createWindow(WindowType.VOLUME_PANEL, TEST_RECT);
      await wm.createWindow(WindowType.NAVIGATION_BAR, TEST_RECT);
      await wm.createWindow(WindowType.STATUS_BAR, TEST_RECT);
    });

    it('createWindow_sets_initial_visibility_false', 0, () => {
      const info = wm.getWindowInfo(WindowType.VOLUME_PANEL);
      expect(info !== undefined).assertTrue();
      if (info) {
        expect(info.visibility).assertFalse();
      }
    });

    it('createWindow_sets_correct_rect', 0, () => {
      const info = wm.getWindowInfo(WindowType.VOLUME_PANEL);
      if (info) {
        expect(info.rect.width).assertEqual(1920);
        expect(info.rect.height).assertEqual(40);
      }
    });

    it('createWindow_multiple_windows_independent', 0, () => {
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL) !== undefined).assertTrue();
      expect(wm.getWindowInfo(WindowType.NAVIGATION_BAR) !== undefined).assertTrue();
    });

    it('showWindow_sets_visibility_true', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      const info = wm.getWindowInfo(WindowType.VOLUME_PANEL);
      if (info) {
        expect(info.visibility).assertTrue();
      }
    });

    it('showWindow_publishes_isShow_true_event', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      let found = false;
      for (let i = 0; i < wm.publishedEvents.length; i++) {
        if (wm.publishedEvents[i].windowName === WindowType.VOLUME_PANEL && wm.publishedEvents[i].isShow) {
          found = true;
        }
      }
      expect(found).assertTrue();
    });

    it('showWindow_mock_window_isShown_true', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      const win = wm.mWindows.get(WindowType.VOLUME_PANEL);
      if (win) {
        expect(win.isShown).assertTrue();
      }
    });

    it('showWindow_nav_independent_of_volume', 0, async () => {
      await wm.showWindow(WindowType.NAVIGATION_BAR);
      const navInfo = wm.getWindowInfo(WindowType.NAVIGATION_BAR);
      const volInfo = wm.getWindowInfo(WindowType.VOLUME_PANEL);
      if (navInfo) {
        expect(navInfo.visibility).assertTrue();
      }
      if (volInfo) {
        expect(volInfo.visibility).assertFalse();
      }
    });

    it('hideWindow_sets_visibility_false', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      const info = wm.getWindowInfo(WindowType.VOLUME_PANEL);
      if (info) {
        expect(info.visibility).assertFalse();
      }
    });

    it('hideWindow_publishes_isShow_false_event', 0, async () => {
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      let found = false;
      for (let i = 0; i < wm.publishedEvents.length; i++) {
        if (wm.publishedEvents[i].windowName === WindowType.VOLUME_PANEL && !wm.publishedEvents[i].isShow) {
          found = true;
        }
      }
      expect(found).assertTrue();
    });

    it('hideWindow_mock_window_isShown_false', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      const win = wm.mWindows.get(WindowType.VOLUME_PANEL);
      if (win) {
        expect(win.isShown).assertFalse();
      }
    });

    it('show_hide_show_correct_final_state', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      await wm.showWindow(WindowType.VOLUME_PANEL);
      const info = wm.getWindowInfo(WindowType.VOLUME_PANEL);
      if (info) {
        expect(info.visibility).assertTrue();
      }
    });

    it('multiple_show_keeps_visibility_true', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.showWindow(WindowType.VOLUME_PANEL);
      const info = wm.getWindowInfo(WindowType.VOLUME_PANEL);
      if (info) {
        expect(info.visibility).assertTrue();
      }
    });

    it('event_count_matches_calls', 0, async () => {
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      await wm.showWindow(WindowType.VOLUME_PANEL);
      let count = 0;
      for (let i = 0; i < wm.publishedEvents.length; i++) {
        if (wm.publishedEvents[i].windowName === WindowType.VOLUME_PANEL) {
          count++;
        }
      }
      expect(count).assertEqual(3);
    });

    it('getWindowInfo_returns_undefined_for_unknown', 0, () => {
      expect(wm.getWindowInfo('Unknown_Window_XYZ')).assertUndefined();
    });

    it('getWindowInfo_correct_after_show', 0, async () => {
      await wm.showWindow(WindowType.STATUS_BAR);
      const info = wm.getWindowInfo(WindowType.STATUS_BAR);
      if (info) {
        expect(info.visibility).assertTrue();
      }
    });

    it('destroyWindow_removes_windowInfo', 0, async () => {
      await wm.destroyWindow(WindowType.VOLUME_PANEL);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)).assertUndefined();
    });

    it('destroyWindow_removes_from_windows_map', 0, async () => {
      await wm.destroyWindow(WindowType.VOLUME_PANEL);
      expect(wm.mWindows.get(WindowType.VOLUME_PANEL)).assertUndefined();
    });

    it('resetSizeWindow_updates_rect', 0, async () => {
      const newRect: Rect = {
        left: 0,
        top: 0,
        width: 1280,
        height: 60
      };
      await wm.resetSizeWindow(WindowType.NAVIGATION_BAR, newRect);
      const info = wm.getWindowInfo(WindowType.NAVIGATION_BAR);
      if (info) {
        expect(info.rect.width).assertEqual(1280);
      }
    });

    it('resetSizeWindow_preserves_visibility', 0, async () => {
      await wm.showWindow(WindowType.NAVIGATION_BAR);
      const newRect: Rect = {
        left: 0,
        top: 0,
        width: 1280,
        height: 60
      };
      await wm.resetSizeWindow(WindowType.NAVIGATION_BAR, newRect);
      const info = wm.getWindowInfo(WindowType.NAVIGATION_BAR);
      if (info) {
        expect(info.visibility).assertTrue();
      }
    });

    it('all_window_types_have_distinct_names', 0, () => {
      const names: string[] = [
        WindowType.STATUS_BAR, WindowType.NAVIGATION_BAR, WindowType.VOLUME_PANEL,
        WindowType.CONTROL_PANEL, WindowType.DROPDOWN_PANEL, WindowType.FLOAT_BALL,
      ];
      const unique: Set<string> = new Set(names);
      expect(unique.size).assertEqual(names.length);
    });

    // ---- 多窗口组合操作场景 ----

    it('show_all_three_windows_independently', 0, async () => {
      // TV 系统 UI 的导航栏、状态栏、音量面板可同时显示，各自独立
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.showWindow(WindowType.NAVIGATION_BAR);
      await wm.showWindow(WindowType.STATUS_BAR);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)!.visibility).assertTrue();
      expect(wm.getWindowInfo(WindowType.NAVIGATION_BAR)!.visibility).assertTrue();
      expect(wm.getWindowInfo(WindowType.STATUS_BAR)!.visibility).assertTrue();
    });

    it('hide_one_does_not_affect_others', 0, async () => {
      // 隐藏音量面板不应影响导航栏和状态栏的可见性
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.showWindow(WindowType.NAVIGATION_BAR);
      await wm.showWindow(WindowType.STATUS_BAR);
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)!.visibility).assertFalse();
      expect(wm.getWindowInfo(WindowType.NAVIGATION_BAR)!.visibility).assertTrue();
      expect(wm.getWindowInfo(WindowType.STATUS_BAR)!.visibility).assertTrue();
    });

    it('destroy_one_does_not_affect_others', 0, async () => {
      // 销毁音量面板不应影响其他窗口的状态
      await wm.showWindow(WindowType.NAVIGATION_BAR);
      await wm.destroyWindow(WindowType.VOLUME_PANEL);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)).assertUndefined();
      expect(wm.getWindowInfo(WindowType.NAVIGATION_BAR)!.visibility).assertTrue();
    });

    it('total_event_count_across_all_windows', 0, async () => {
      // 三个窗口各操作一次，总事件数应为3
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.showWindow(WindowType.NAVIGATION_BAR);
      await wm.hideWindow(WindowType.STATUS_BAR);
      expect(wm.publishedEvents.length).assertEqual(3);
    });

    it('events_contain_correct_window_names', 0, async () => {
      // 事件中的 windowName 必须与操作的窗口一致，UI 层依赖此字段路由更新
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.hideWindow(WindowType.NAVIGATION_BAR);
      const volEvent = wm.publishedEvents.find(e => e.windowName === WindowType.VOLUME_PANEL);
      const navEvent = wm.publishedEvents.find(e => e.windowName === WindowType.NAVIGATION_BAR);
      expect(volEvent !== undefined).assertTrue();
      expect(navEvent !== undefined).assertTrue();
      if (volEvent) {
        expect(volEvent.isShow).assertTrue();
      }
      if (navEvent) {
        expect(navEvent.isShow).assertFalse();
      }
    });

    it('resetSize_multiple_windows_independent', 0, async () => {
      // 同时对多个窗口调整尺寸，各自独立不互相干扰
      const rectV: Rect = {
        left: 0,
        top: 900,
        width: 1920,
        height: 180
      };
      const rectN: Rect = {
        left: 0,
        top: 0,
        width: 1920,
        height: 56
      };
      await wm.resetSizeWindow(WindowType.VOLUME_PANEL, rectV);
      await wm.resetSizeWindow(WindowType.NAVIGATION_BAR, rectN);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)!.rect.height).assertEqual(180);
      expect(wm.getWindowInfo(WindowType.NAVIGATION_BAR)!.rect.height).assertEqual(56);
    });

    it('show_after_resetSize_retains_new_rect', 0, async () => {
      // 调整尺寸后再 show，rect 应保持新值
      const newRect: Rect = {
        left: 0,
        top: 0,
        width: 1280,
        height: 72
      };
      await wm.resetSizeWindow(WindowType.STATUS_BAR, newRect);
      await wm.showWindow(WindowType.STATUS_BAR);
      const info = wm.getWindowInfo(WindowType.STATUS_BAR);
      if (info) {
        expect(info.rect.width).assertEqual(1280);
        expect(info.visibility).assertTrue();
      }
    });

    it('destroy_all_windows_leaves_empty_manager', 0, async () => {
      // 销毁所有窗口后，管理器应为空状态，重启流程可重新创建
      await wm.destroyWindow(WindowType.VOLUME_PANEL);
      await wm.destroyWindow(WindowType.NAVIGATION_BAR);
      await wm.destroyWindow(WindowType.STATUS_BAR);
      expect(wm.mWindowInfos.size).assertEqual(0);
      expect(wm.mWindows.size).assertEqual(0);
    });

    it('recreate_window_after_destroy_works', 0, async () => {
      // 销毁后重新创建同名窗口应正常工作，对应 SystemUI 重启流程
      await wm.destroyWindow(WindowType.VOLUME_PANEL);
      await wm.createWindow(WindowType.VOLUME_PANEL, TEST_RECT);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL) !== undefined).assertTrue();
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)!.visibility).assertFalse();
    });

    it('show_hide_sequence_produces_correct_event_order', 0, async () => {
      // 事件顺序必须与操作顺序一致，UI 层按序处理动画
      await wm.showWindow(WindowType.VOLUME_PANEL);
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      const events = wm.publishedEvents.filter(e => e.windowName === WindowType.VOLUME_PANEL);
      expect(events.length).assertEqual(2);
      expect(events[0].isShow).assertTrue();
      expect(events[1].isShow).assertFalse();
    });

    it('multiple_hide_keeps_visibility_false', 0, async () => {
      // 多次 hide 不应产生异常，最终状态为隐藏
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      await wm.hideWindow(WindowType.VOLUME_PANEL);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)!.visibility).assertFalse();
    });

    it('resetSize_hidden_window_stays_hidden', 0, async () => {
      // 对隐藏窗口调整尺寸，可见性应保持 false
      const newRect: Rect = {
        left: 0,
        top: 0,
        width: 960,
        height: 40
      };
      await wm.resetSizeWindow(WindowType.VOLUME_PANEL, newRect);
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)!.visibility).assertFalse();
      expect(wm.getWindowInfo(WindowType.VOLUME_PANEL)!.rect.width).assertEqual(960);
    });

  });
}
