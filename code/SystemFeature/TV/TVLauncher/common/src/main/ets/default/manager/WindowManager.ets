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

import { window, display } from '@kit.ArkUI';
import { commonEventManager as kitCommonEvent, AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { AbilityConstant, common } from '@kit.AbilityKit';
import commonEventManager from './CommonEventManager'
import { Log } from '../utils/Log';
import { StyleConstants } from '../constants/StyleConstants';


const TAG = 'WindowManager';

interface DisplayInfo {
  id: number;
  width: number;
  height: number;
  refreshRate: number;
}

interface WindowRect {
  width: number;
  height: number;
}

interface RecentEventParameters {
  windowMode?: string;
  missionId?: number;
}

interface MediaQueryResult {
  matches: boolean;
}

/**
 * Wrapper class for window interfaces.
 */
class WindowManager {
  private mDisplayData: DisplayInfo | null = null;
  private static subscriber: kitCommonEvent.CommonEventSubscriber;
  private static eventCallback: AsyncCallback<kitCommonEvent.CommonEventData>;
  public RECENT_WINDOW_NAME = 'RecentView';
  public DESKTOP_WINDOW_NAME = 'EntryView';
  public APP_CENTER_WINDOW_NAME = 'AppCenterView';
  public FORM_MANAGER_WINDOW_NAME = 'FormManagerView';
  public DESKTOP_RANK = window.WindowType.TYPE_DESKTOP;
  public RECENT_RANK = window.WindowType.TYPE_LAUNCHER_RECENT;
  public DOCK_RANK = window.WindowType.TYPE_LAUNCHER_DOCK;

  /**
   * get WindowManager instance
   *
   * @return WindowManager singleton
   */
  static getInstance(): WindowManager {
    if (globalThis.WindowManager == null) {
      globalThis.WindowManager = new WindowManager();
      WindowManager.eventCallback = WindowManager.winEventCallback.bind(WindowManager);
      WindowManager.initSubscriber();
    }
    return globalThis.WindowManager;
  }

  /**
   * get window width
   *
   * @return windowWidth
   */
  async getWindowWidth(): Promise<number> {
    if (this.mDisplayData == null) {
      this.mDisplayData = await this.getWindowDisplayData();
    }
    const displayData = this.mDisplayData;
    if (displayData == null) {
      return 0;
    }
    return px2vp(displayData.width);
  }

  /**
   * get window height
   *
   * @return windowHeight
   */
  async getWindowHeight(): Promise<number> {
    if (this.mDisplayData == null) {
      this.mDisplayData = await this.getWindowDisplayData();
    }
    const displayData = this.mDisplayData;
    if (displayData == null) {
      return 0;
    }
    return px2vp(displayData.height);
  }

  private async getWindowDisplayData(): Promise<DisplayInfo | null> {
    let displayData: DisplayInfo | null = null;
    await display.getDefaultDisplay()
      .then((res: DisplayInfo) => {
        displayData = res;
      }).catch((err: BusinessError) => {
        Log.showError(TAG, 'getWindowDisplayData error:' + err);
      });
    return displayData;
  }

  isSplitWindowMode(mode: number): boolean {
    if ((mode == AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY) ||
      (mode == AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY)) {
      return true;
    }
    return false;
  }

  /**
   * set window size
   *
   * @param width window width
   * @param height window height
   */
  async setWindowSize(width: number, height: number): Promise<void> {
    const abilityWindow = await window.getLastWindow(globalThis.desktopContext)
    void abilityWindow.resetSize(width, height);
  }

  /**
   * set window position
   *
   * @param x coordinate x
   * @param y coordinate y
   */
  async setWindowPosition(x: number, y: number): Promise<void> {
    const abilityWindow = await window.getLastWindow(globalThis.desktopContext)
    void abilityWindow.moveTo(x, y);
  }

  getBackgroundColor(name: string) {
    if (name == this.DESKTOP_WINDOW_NAME) {
      return StyleConstants.DEFAULT_DESKTOP_BG_COLOR
    } else {
      return StyleConstants.DEFAULT_SYSTEM_UI_COLOR
    }
  }

  createWindow(context: common.UIAbilityContext, name: string, windowType: number, loadContent: string,
    isShow: boolean, callback?: (win: window.Window) => void) {
    window.create(context, name, windowType).then((win: window.Window) => {
      AppStorage.setOrCreate('windowId', win.getWindowProperties().id)
      void win.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
      void win.loadContent(loadContent).then(() => {
        void win.setSystemBarProperties({
          navigationBarColor: this.getBackgroundColor(name),
          statusBarColor: this.getBackgroundColor(name)
        }).then(() => {
          win.setBackgroundColor(this.getBackgroundColor(name), () => {
            if (name == this.RECENT_WINDOW_NAME) {
              win.setBackdropBlur(40)
            }
            Log.showDebug(TAG, `then begin ${name} window loadContent in then!`);
            if (name !== this.RECENT_WINDOW_NAME) {
              void win.setLayoutFullScreen(true).then(() => {
                Log.showDebug(TAG, `${name} setLayoutFullScreen`);
              });
            }
            if (callback) {
              callback(win);
            }
            // there is a low probability that white flashes when no delay because of setBackgroundColor is asynchronous
            setTimeout(() => {
              isShow && this.showWindow(name);
            }, StyleConstants.WINDOW_SHOW_DELAY)
          })
        });
      }, (error: BusinessError) => {
        Log.showError(TAG, `createWindow, create error: ${JSON.stringify(error)}`);
      });
    });
  }

  createWindowIfAbsent(context: common.UIAbilityContext, name: string, windowType: number, loadContent: string): void {
    Log.showDebug(TAG, `create, name ${name}`);
    window.find(name).then((win: window.Window) => {
      void win.show().then(() => {
        Log.showDebug(TAG, `show launcher ${name}`);
      });
    }).catch((error: BusinessError) => {
      Log.showError(TAG, `${name} ability is not created, because ${error}`);
      this.createWindow(context, name, windowType, loadContent, true);
    });
  }

  resetSizeWindow(name: string, rect: WindowRect, callback?: (win: window.Window) => void): void {
    Log.showDebug(TAG, `resetSizeWindow, name ${name} rect: ${JSON.stringify(rect)}`);
    this.findWindow(name, (win: window.Window) => {
      Log.showDebug(TAG, `resetSizeWindow, findWindow callback name: ${name}`);
      win.resetSize(rect.width, rect.height).then(() => {
        Log.showDebug(TAG, `resetSizeWindow, resetSize then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
    });
  }

  showWindow(name: string, callback?: (win: window.Window) => void): void {
    Log.showDebug(TAG, `showWindow, name ${name}`);
    this.findWindow(name, (win: window.Window) => {
      Log.showDebug(TAG, `showWindow, findWindow callback name: ${name}`);
      win.show().then(() => {
        Log.showDebug(TAG, `showWindow, show then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
    });
  }

  hideWindow(name: string, callback?: (win: window.Window) => void): void {
    Log.showDebug(TAG, `hideWindow, name ${name}`);
    this.findWindow(name, (win: window.Window) => {
      Log.showDebug(TAG, `hideWindow, findWindow callback name: ${name}`);
      win.hide().then(() => {
        Log.showDebug(TAG, `hideWindow, hide then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
    });
  }

  minimizeAllApps(): void {
    display.getDefaultDisplay().then((dis: DisplayInfo) => {
      window.minimizeAll(dis.id).then(() => {
        Log.showDebug(TAG, 'Launcher minimizeAll');
      });
    });
    this.destroyWindow(this.FORM_MANAGER_WINDOW_NAME);
  }

  destroyWindow(name: string, callback?: (win: window.Window) => void): void {
    Log.showDebug(TAG, `destroyWindow, name ${name}`);
    this.findWindow(name, (win: window.Window) => {
      Log.showDebug(TAG, `hideWindow, findWindow callback name: ${name}`);
      win.destroy().then(() => {
        Log.showDebug(TAG, `destroyWindow, destroy then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
    });
  }

  findWindow(name: string, callback?: (win: window.Window) => void): void {
    Log.showDebug(TAG, `findWindow, name ${name}`);
    void window.find(name)
      .then((win: window.Window) => {
        Log.showDebug(TAG, `findWindow, find then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
  }

  createRecentWindow(mode?: number): void {
    Log.showDebug(TAG, 'createRecentWindow Begin, mode=' + mode);
    let setWinMode: (win: window.Window) => void = (mode && this.isSplitWindowMode(mode)) ? (win: window.Window) => {
      globalThis.recentMode = mode;
      win.setWindowMode(mode).then();
    } : (win: window.Window) => {
      globalThis.recentMode = AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN;
      win.setFullScreen(true).then(() => {
        Log.showDebug(TAG, `${this.RECENT_WINDOW_NAME} setFullScreen`);
      });
    };
    let registerWinEvent = (_win: window.Window): void => {
      Log.showDebug(TAG, 'registerWinEvent skipped');
    };
    window.find(windowManager.RECENT_WINDOW_NAME).then((win: window.Window) => {
      setWinMode(win);
      void win.show().then(() => {
        Log.showDebug(TAG, 'show launcher recent ability');
      });
    }).catch((error: BusinessError) => {
      Log.showDebug(TAG, `recent window is not created, because ${error}`);
      let callback = (win: window.Window): void => {
        Log.showDebug(TAG, 'Post recent window created');
        registerWinEvent(win);
        setWinMode(win);
      }
      this.createWindow(globalThis.desktopContext, windowManager.RECENT_WINDOW_NAME, windowManager.RECENT_RANK,
        'pages/' + windowManager.RECENT_WINDOW_NAME, true, callback);
    });
  }

  destroyRecentWindow() {
    this.findWindow(windowManager.RECENT_WINDOW_NAME, (targetWin: window.Window) => {
      targetWin.destroy().then(() => {
        Log.showDebug(TAG, 'destroyRecentWindow');
      });
    });
  }

  private static initSubscriber() {
    if (WindowManager.subscriber != null) {
      return;
    }
    const subscribeInfo: kitCommonEvent.CommonEventSubscribeInfo = {
      events: [commonEventManager.RECENT_FULL_SCREEN, commonEventManager.RECENT_SPLIT_SCREEN]
    };
    kitCommonEvent.createSubscriber(subscribeInfo)
      .then((commonEventSubscriber: kitCommonEvent.CommonEventSubscriber) => {
        Log.showDebug(TAG, 'init SPLIT_SCREEN subscriber success');
        WindowManager.subscriber = commonEventSubscriber;
      }, (err: BusinessError) => {
        Log.showError(TAG, `Failed to createSubscriber ${err}`)
      })
  }

  /**
   * Register window event listener.
   */
  public registerWindowEvent() {
    WindowManager.initSubscriber()
    try {
      commonEventManager.registerCommonEvent(WindowManager.subscriber, WindowManager.eventCallback);
    } catch (err) {
      setTimeout(() => {
        this.registerWindowEvent()
      }, 1000)
    }
  }

  /**
   * Unregister window event listener.
   */
  public unregisterWindowEvent() {
    commonEventManager.unregisterCommonEvent(WindowManager.subscriber, WindowManager.eventCallback);
  }

  /**
   * Window event handler.
   */
  private static async winEventCallback(error: BusinessError, data: kitCommonEvent.CommonEventData) {
    Log.showDebug(TAG, `Launcher WindowManager winEventCallback receive data: ${JSON.stringify(data)}.`);
    if (error.code != 0) {
      Log.showError(TAG, `get winEventCallback error: ${JSON.stringify(error)}`);
      return;
    }

    switch (data.event) {
      case commonEventManager.RECENT_FULL_SCREEN:
        // full screen recent window
        windowManager.createRecentWindow();
        break;
      case commonEventManager.RECENT_SPLIT_SCREEN:
        // split window mode
        const params: RecentEventParameters = (data.parameters as RecentEventParameters) ?? {};
        const windowMode = params.windowMode;
        if (windowMode != 'Primary' && windowMode != 'Secondary') {
          break;
        }
        const targetWindowMode = windowMode == 'Primary'
          ? AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY
          : AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY;
        windowManager.createRecentWindow(targetWindowMode);
        globalThis.splitMissionId = params.missionId;
        await WindowManager.subscriber.setCode(0)
        await WindowManager.subscriber.finishCommonEvent();
        break;
      default:
        break;
    }
  }

  /**
   * Screen rotation callback.
   */
  public async onPortrait(mediaQueryResult: MediaQueryResult): Promise<void> {
    if (mediaQueryResult.matches) {
      Log.showInfo(TAG, 'screen change to landscape');
      AppStorage.setOrCreate('isPortrait', false);
    } else {
      Log.showInfo(TAG, 'screen change to portrait');
      AppStorage.setOrCreate('isPortrait', true);
    }
    display.getDefaultDisplay()
      .then((dis: DisplayInfo) => {
        Log.showInfo(TAG, `change to display: ${JSON.stringify(dis)}`);
        AppStorage.setOrCreate('screenWidth', px2vp(dis.width));
        AppStorage.setOrCreate('screenHeight', px2vp(dis.height));
        Log.showDebug(TAG,
          `screenWidth and screenHeight: ${AppStorage.get('screenWidth')},${AppStorage.get('screenHeight')}`);
      });
  }

  public createWindowWithName = ((windowName: string, windowRank: number): void => {
    Log.showInfo(TAG, `createWindowWithName begin windowName: ${windowName}`);
    if (windowName === windowManager.RECENT_WINDOW_NAME) {
      windowManager.createRecentWindow();
    } else {
      windowManager.createWindowIfAbsent(globalThis.desktopContext, windowName, windowRank, 'pages/' + windowName);
    }
  })
}

export const windowManager = WindowManager.getInstance();