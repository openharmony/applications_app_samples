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
 

import { window as windowStage } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import Log from './Log';
import EventManager from './event/EventManager';
import { obtainLocalEvent } from './event/EventUtil';
import { Rect } from './Constants';
import createOrGet from './SingleInstanceHelper';

export interface WindowInfo {
  visibility: boolean;
  rect: Rect;
}
interface WindowEventData {
  windowName: WindowType;
  isShow?: boolean;
  isDestroy?: boolean;
  rect?: Rect;
}

export enum WindowType {
  STATUS_BAR = 'SystemUi_StatusBar',
  NAVIGATION_BAR = 'SystemUi_NavigationBar',
  DROPDOWN_PANEL = 'SystemUi_DropdownPanel',
  NOTIFICATION_PANEL = 'SystemUi_NotificationPanel',
  CONTROL_PANEL = 'SystemUi_ControlPanel',
  VOLUME_PANEL = 'SystemUi_VolumePanel',
  BANNER_NOTICE = 'SystemUi_BannerNotice',
  SPLIT_BAR = 'SystemUi_SplitBar',
  PRIVACY_INDICATOR = 'SystemUi_PrivacyIndicator',
  FLOAT_BALL = 'SystemUi_FloatBall'
}

export const WINDOW_SHOW_HIDE_EVENT = 'WindowShowHideEvent';

export const WINDOW_RESIZE_EVENT = 'WindowResizeEvent';

export const windowDestroy = 'WindowDestroy';

const TAG = 'WindowManager';

const SYSTEM_WINDOW_TYPE_MAP: Map<WindowType, windowStage.WindowType> =
  new Map<WindowType, windowStage.WindowType>([
  [WindowType.STATUS_BAR, windowStage.WindowType.TYPE_STATUS_BAR],
  [WindowType.NAVIGATION_BAR, windowStage.WindowType.TYPE_NAVIGATION_BAR],
  [WindowType.DROPDOWN_PANEL, windowStage.WindowType.TYPE_PANEL],
  [WindowType.NOTIFICATION_PANEL, windowStage.WindowType.TYPE_VOLUME_OVERLAY],
  [WindowType.CONTROL_PANEL, windowStage.WindowType.TYPE_VOLUME_OVERLAY],
  [WindowType.VOLUME_PANEL, windowStage.WindowType.TYPE_VOLUME_OVERLAY],
  [WindowType.BANNER_NOTICE, windowStage.WindowType.TYPE_VOLUME_OVERLAY],
  [WindowType.SPLIT_BAR, 2101 as windowStage.WindowType],
  [WindowType.PRIVACY_INDICATOR, windowStage.WindowType.TYPE_VOLUME_OVERLAY],
  [WindowType.FLOAT_BALL, windowStage.WindowType.TYPE_VOLUME_OVERLAY],
]);

const DEFAULT_WINDOW_INFO: WindowInfo = {
  visibility: false,
  rect: {
    left: 0,
    top: 0,
    width: 0,
    height: 0
  },
};

// SystemUI 的各功能面板（导航栏、音量面板、控制面板）需要在特定系统窗口层级上独立渲染，
// WindowManager 统一管理这些系统级窗口的创建、显示、隐藏和销毁，
// 并在每次状态变更后通过 EventManager 广播事件，使各模块能感知窗口可见性变化并调整自身行为。
class WindowManager {
  private mergeWindowInfo(name: WindowType, patch: WindowInfo): WindowInfo {
    const oldInfo: WindowInfo | undefined = this.mWindowInfos.get(name);
    if (!oldInfo) {
      return patch;
    }
    return {
      visibility: patch.visibility,
      rect: patch.rect
    };
  }

  private publishWindowEvent(eventName: string, data: WindowEventData): void {
    EventManager.publish(obtainLocalEvent(eventName, data));
  }

  private mWindowInfos: Map<WindowType, WindowInfo> = new Map();

  // 创建窗口时严格按照 SYSTEM_WINDOW_TYPE_MAP 映射系统窗口类型，
  // 因为不同类型决定了窗口在 Z 轴上的层叠顺序和触摸事件路由策略，
  // 例如音量面板必须覆盖在普通应用上方但不能遮挡输入法。
  async createWindow(context: common.ServiceExtensionContext, name: WindowType, rect: Rect,
    loadContent: string): Promise<windowStage.Window> {
    Log.showInfo(TAG, `createWindow name: ${name}, rect: ${JSON.stringify(rect)}, url: ${loadContent}`);
    const mappedWindowType: windowStage.WindowType | undefined = SYSTEM_WINDOW_TYPE_MAP.get(name);
    if (mappedWindowType === undefined) {
      throw new Error(`window type not found: ${name}`);
    }
    let winHandle =
      await windowStage.createWindow({ ctx: context, name, windowType: mappedWindowType });
    await winHandle.moveTo(rect.left, rect.top);
    await winHandle.resize(rect.width, rect.height);
    await winHandle.setUIContent(loadContent)
    this.mWindowInfos.set(name, { visibility: false, rect });
    Log.showInfo(TAG, `create window[${name}] success.`);
    return winHandle;
  }

  async resetSizeWindow(name: WindowType, rect: Rect): Promise<void> {
    let win = await windowStage.find(name);
    await win.moveTo(rect.left, rect.top);
    await win.resetSize(rect.width, rect.height);
    this.mWindowInfos.set(name, this.mergeWindowInfo(name,
      { visibility: this.getWindowInfo(name)?.visibility ?? false, rect }));
    this.publishWindowEvent(WINDOW_RESIZE_EVENT, { windowName: name, rect });
    Log.showInfo(TAG, `resize window[${name}] success, rect: ${JSON.stringify(rect)}.`);
  }

  async moveTo(name: WindowType, rect: Rect): Promise<void> {
    Log.showInfo(TAG, `moveTo window[${name}] success, rect: ${JSON.stringify(rect)}.`);
    let win = await windowStage.find(name);
    await win.moveTo(rect.left, rect.top);
  }

  // 显示/隐藏窗口后同步更新 mWindowInfos 并广播事件，
  // 是因为导航栏等模块需要根据音量面板是否可见来决定是否拦截遥控器按键焦点。
  async showWindow(name: WindowType): Promise<void> {
    let win = await windowStage.find(name);
    await win.show();
    this.mWindowInfos.set(name, this.mergeWindowInfo(name, {
      visibility: true,
      rect: this.getWindowInfo(name)?.rect ?? DEFAULT_WINDOW_INFO.rect
    }));
    this.publishWindowEvent(WINDOW_SHOW_HIDE_EVENT, { windowName: name, isShow: true });
    Log.showInfo(TAG, `show window[${name}] success.`);
  }

  async hideWindow(name: WindowType): Promise<void> {
    let win = await windowStage.find(name);
    await win.hide();
    this.mWindowInfos.set(name, this.mergeWindowInfo(name, {
      visibility: false,
      rect: this.getWindowInfo(name)?.rect ?? DEFAULT_WINDOW_INFO.rect
    }));
    this.publishWindowEvent(WINDOW_SHOW_HIDE_EVENT, { windowName: name, isShow: false });
    Log.showInfo(TAG, `hide window[${name}] success.`);
  }

  async destroyWindow(name: WindowType): Promise<void> {
    let win = await windowStage.find(name);
    await win.destroy()
    this.mWindowInfos.delete(name)
    this.publishWindowEvent(windowDestroy, { windowName: name, isDestroy: true });
  }

  getWindowInfo(name: WindowType): WindowInfo | undefined {
    return this.mWindowInfos.get(name);
  }

  async setWindowBgColor(name: WindowType, bgColor: string): Promise<void> {
    let win = await windowStage.find(name);
    win.setWindowBackgroundColor(bgColor);

  }

  async setWindowTouchable(windowName: string, touchable: boolean): Promise<void> {
    let win = await windowStage.find(windowName);
    win.setWindowTouchable(touchable);
  }
}

let sWindowManager = createOrGet(() => new WindowManager(), TAG);

export default sWindowManager;
