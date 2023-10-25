/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import deviceInfo from '@ohos.deviceInfo';
import window from '@ohos.window';
import { stashOrGetObject } from '../utils/SingleInstanceUtils';
import { Log } from '../utils/Log';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { Constants } from '../constants/Constants';
import { getResourceString } from '../utils/ResourceUtils';
import { GlobalContext } from './GlobalContext';

export enum ColumnSize {
  COLUMN_TWO = 2,
  COLUMN_FOUR = 4,
  COLUMN_SIX = 6,
  COLUMN_EIGHT = 8,
  COLUMN_TWELVE = 12
}

enum ScreenWidth {
  WIDTH_MEDIUM = 520,
  WIDTH_LARGE = 840
}

enum WindowMode {
  UNDEFINED = 1,
  FULL_SCREEN,
  PRIMARY,
  SECONDARY,
  FLOATING
}

interface Size {
  width: number;
  height: number;
}

interface StatusNaviHeight {
  status: number;
  navi: number;
}

interface GetWindowMode {
  getWindowMode(): Promise<WindowMode>;
}

const TAG = 'ScreenManager';

const APP_KEY_SCREEN_MANAGER = 'app_key_screen_manager';

const SCREEN_ORIENTATION_HORIZONTAL: string = 'isHorizontal';
const SCREEN_SIDEBAR: string = 'isSidebar';

const COLUMN_MARGIN: number = 12;
const COLUMN_GUTTER: number = 12;

type CallbackType = Function;

class ScreenManager {
  readonly ON_WIN_SIZE_CHANGED = 'on_win_size_changed';
  readonly ON_LEFT_BLANK_CHANGED = 'on_left_blank_changed';
  readonly DEFAULT_WIDTH: number = 1920;
  readonly DEFAULT_HEIGHT: number = 1080;
  readonly SPLIT_THRESHOLD = 1.7;
  private winWidth = 0.0;
  private winHeight = 0.0;
  private statusBarHeight = 0;
  private naviBarHeight = 0;
  private leftBlank: number[] = [0, 0, 0, 0];
  private events: Map<string, CallbackType[]> = new Map<string, CallbackType[]>();
  private mainWindow: window.Window = undefined;
  private globalThis = GlobalContext.getContext();

  // Default orientation
  private horizontal = deviceInfo.deviceType === 'phone' || deviceInfo.deviceType === 'default' ? false : true;

  // Default sidebar
  private sidebar = deviceInfo.deviceType === 'phone' || deviceInfo.deviceType === 'default' ? false : true;
  private windowMode = WindowMode.UNDEFINED;

  constructor() {
    Log.info(TAG, 'constructor');
  }

  async initializationSize(win): Promise<void> {
    this.mainWindow = win;
    this.setMainWindow(win);
    await this.checkWindowMode();
    this.getWindowProperties(win);
  }

  /**
   * Add Listeners
   *
   * @param event
   * @param fn
   */
  on(event, fn): void {
    if (Array.isArray(event)) {
      for (let i = 0, l = event.length; i < l; i++) {
        this.on(event[i], fn);
      }
    } else {
      if (this.events.get(event) === null || this.events.get(event) === undefined) {
        this.events.set(event, []);
      }
      this.events.get(event).push(fn);
    }
  }

  /**
   * Delete Listeners
   *
   * @param event
   * @param fn
   */
  off(event, fn): void {
    if (event == null || event == undefined) {
      return;
    }
    if (Array.isArray(event)) {
      for (let i = 0, l = event.length; i < l; i++) {
        this.off(event[i], fn);
      }
    }
    const cbs: CallbackType[] = this.events.get(event);
    if (!new Boolean(cbs).valueOf()) {
      return;
    }
    if (fn == null || fn == undefined) {
      return;
    }
    let cb;
    let i = cbs.length;
    while (i-- > 0) {
      cb = cbs[i];
      if (cb === fn || cb.fn === fn) {
        cbs.splice(i, 1);
        break;
      }
    }
  }

  private emit(event, argument: Object[]): void {
    let _self = this;
    if (!new Boolean(this.events.get(event)).valueOf()) {
      return;
    }

    let cbs: CallbackType[] = [];
    for (let i = 0; i < this.events.get(event).length; i++) {
      cbs.push(this.events.get(event)[i]);
    }

    if (cbs.length > 0) {
      for (let i = 0, l = cbs.length; i < l; i++) {
        let ref = cbs[i];
        if (ref != null) {
          try {
            ref.apply(_self, argument);
          } catch (e) {
            new Error(e);
          }
        }
      }
    }
  }

  private isLeftBlankInitialized(): boolean {
    return this.leftBlank[0] !== 0 || this.leftBlank[1] !== 0 || this.leftBlank[2] !== 0 || this.leftBlank[3] !== 0;
  }

  // Unit：vp
  getWinWidth(): number {
    return px2vp(this.winWidth);
  }

  setWinWidth(width: number): void {
    this.winWidth = width;
  }

  // Unit：vp
  getWinHeight(): number {
    return px2vp(this.winHeight);
  }

  getStatusBarHeight(): number {
    return px2vp(this.statusBarHeight);
  }

  getNaviBarHeight(): number {
    return px2vp(this.naviBarHeight);
  }

  async initWindowMode(): Promise<void> {
    Log.debug(TAG, 'start to initialize photos application window mode: ' + this.windowMode);
  }

  isSplitMode(): boolean {
    return (WindowMode.PRIMARY === this.windowMode || WindowMode.SECONDARY === this.windowMode)
  }

  async checkWindowMode(): Promise<void> {
    let before = this.windowMode;
    let photosWindowStage = this.globalThis.getObject('photosWindowStage') as GetWindowMode;
    let mode = await photosWindowStage.getWindowMode();
    Log.info(TAG, 'photos application before/current window mode: ' + before + '/' + mode);

    if (before === mode) {
      return;
    }
    this.windowMode = mode;

    if (WindowMode.FULL_SCREEN == this.windowMode) {
      this.setFullScreen();
    } else {
      this.setSplitScreen();
    }
  }

  private setMainWindow(win: window.Window): void {
        Log.debug(TAG, 'setMainWindow');
        win.on('windowSizeChange', (data: window.Size): void => {
            Log.debug(TAG, 'windowSizeChange ' + JSON.stringify(data));
            this.checkWindowMode();
            this.onWinSizeChanged(data);
        })
    }

  private getWindowProperties(win: window.Window): void {
    Log.debug(TAG, 'getWindowProperties');
    try {
      let properties = win.getWindowProperties();
      if (properties.windowRect.width !== 0 && properties.windowRect.height !== 0) {
        this.winWidth = properties.windowRect.width;
        this.winHeight = properties.windowRect.height;
      }
      Log.debug(TAG, 'this.winWidth = ' + this.winWidth + ' this.winHeight = ' + this.winHeight);
    } catch (exception) {
      console.error('Failed to obtain the window properties. Cause: ' + JSON.stringify(exception));
    }
  }

  private async setFullScreen(): Promise<void> {
    let topWindow: window.Window = AppStorage.Get<window.Window>(Constants.MAIN_WINDOW);
    Log.debug(TAG, 'getTopWindow start');
    try {
      await topWindow.setWindowLayoutFullScreen(true);
      Log.debug(TAG, 'setFullScreen true Succeeded');
      await this.hideStatusBar(topWindow);
    } catch (err) {
      Log.error(TAG, 'setFullScreen err: ' + err);
    }
  }

  setSplitScreen(): void {
    try {
      this.statusBarHeight = 0;
      this.naviBarHeight = 0;
      this.leftBlank = [0, 0, 0, 0];
      AppStorage.SetOrCreate<number[]>(BroadcastConstants.LEFT_BLANK, this.leftBlank);
    } catch (err) {
      Log.error(TAG, 'setSplitScreen err: ' + err);
    }
  }

  private async hideStatusBar(topWindow: window.Window): Promise<void> {
    Log.debug(TAG, 'hideStatusBar start');
    let names: string[] = ['navigation'];
    Log.debug(TAG, 'getTopWindow names: ' + names + ' end');
    try {
      // @ts-ignore
      await topWindow.setWindowSystemBarEnable(names);
      Log.debug(TAG, 'hideStatusBar Succeeded');
      let data = await topWindow.getWindowAvoidArea(0)
      Log.debug(TAG, 'Succeeded in obtaining the area. Data: ' + JSON.stringify(data));
      this.onLeftBlankChanged(data);
      let barColor: string = await getResourceString($r('app.color.default_background_color'));
      let barContentColor: string = await getResourceString($r('app.color.default_bar_content_color'));
      if (!barColor) {
        barColor = '#FFF1F3F5';
      }
      if (!barContentColor) {
        barContentColor = '#FF000000';
      }
      let systemBarProperties: window.SystemBarProperties = {
        navigationBarColor: barColor,
        navigationBarContentColor: barContentColor
      };
      await topWindow.setWindowSystemBarProperties(systemBarProperties);
      Log.info(TAG, 'setStatusBarColor done');
    } catch (err) {
      Log.error(TAG, 'hideStatusBar err: ' + err);
    }
  }

  async setNavigationBarColor(barColor: string, barContentColor: string): Promise<void> {
    Log.debug(TAG, 'setNavigationBarColor start');
    let topWindow: window.Window = AppStorage.Get<window.Window>(Constants.MAIN_WINDOW);
    try {
      let systemBarProperties: window.SystemBarProperties = {
        navigationBarColor: barColor,
        navigationBarContentColor: barContentColor
      };
      topWindow.setWindowSystemBarProperties(
        systemBarProperties,
        (): void  => Log.info(TAG, 'setStatusBarColor done')
      );
      } catch (err) {
      Log.error(TAG, 'setNavigationBarColor err: ' + err);
    }
  }

  setSystemUi(isShowBar: boolean): void {
    Log.debug(TAG, 'setSystemUi start');
    let topWindow: window.Window = AppStorage.Get<window.Window>(Constants.MAIN_WINDOW);
    Log.debug(TAG, 'getTopWindow start');
    let names: string[] = ['navigation'];
    if (!isShowBar) {
      names = [];
    }
    Log.debug(TAG, 'getTopWindow names: ' + names + ' end');
    try {
            // @ts-ignore
            topWindow.setWindowSystemBarEnable(names, async (): Promise<void> => {
                Log.debug(TAG, 'setFullScreen Succeeded');
                if (isShowBar) {
                    let data = await topWindow.getWindowAvoidArea(0);
                    this.onLeftBlankChanged(data);
                }
            })
        } catch (err) {
      Log.error(TAG, 'setSystemUi err: ' + err);
    }
  }

  private onLeftBlankChanged(area: window.AvoidArea): void {
    if (area == null || area == undefined || area.bottomRect.height === 0) {
      return;
    }
    let leftBlankBefore: StatusNaviHeight = {
      status: this.statusBarHeight,
      navi: this.naviBarHeight
    };
    this.statusBarHeight = 0;
    this.naviBarHeight = area.bottomRect.height;
    this.leftBlank = [this.leftBlank[0], this.leftBlank[1], this.leftBlank[2], area.bottomRect.height];
    if (leftBlankBefore.status !== this.statusBarHeight || leftBlankBefore.navi !== this.naviBarHeight) {
      Log.info(TAG, 'leftBlank changed: ' + JSON.stringify(leftBlankBefore) + '-' + JSON.stringify(this.leftBlank))
      AppStorage.SetOrCreate<number[]>(BroadcastConstants.LEFT_BLANK, this.leftBlank);
    }
  }

  private onWinSizeChanged(size): void {
    Log.info(TAG, 'onWinSizeChanged ' + JSON.stringify(size));
    if (size == null || size == undefined) {
      return;
    }
    let sizeBefore: Size = {
      width: this.winWidth,
      height: this.winHeight
    };
    this.winWidth = size.width;
    this.winHeight = size.height;


    if (sizeBefore.width !== this.winWidth || sizeBefore.height !== this.winHeight) {
      Log.info(TAG, 'winSize changed: ' + JSON.stringify(sizeBefore) + ' -> ' + JSON.stringify(size));
      this.emit(screenManager.ON_WIN_SIZE_CHANGED, [size]);
    }
  }

  private onRotationAngleChanged(angle): void {
    if (angle == null || angle == undefined) {
      return;
    }

    if (angle === 0) {
      this.horizontal = false;
    } else {
      this.horizontal = true;
    }
    AppStorage.SetOrCreate<boolean>(SCREEN_ORIENTATION_HORIZONTAL, this.horizontal);
  }

  isHorizontal(): boolean {
    if (AppStorage.Get<boolean>(SCREEN_ORIENTATION_HORIZONTAL) == null) {
      AppStorage.SetOrCreate<boolean>(SCREEN_ORIENTATION_HORIZONTAL, this.horizontal);
    }
    return AppStorage.Get<boolean>(SCREEN_ORIENTATION_HORIZONTAL);
  }

  isSidebar(): boolean {
    if (AppStorage.Get<boolean>(SCREEN_SIDEBAR) == null) {
      AppStorage.SetOrCreate<boolean>(SCREEN_SIDEBAR, this.sidebar);
    }
    return AppStorage.Get<boolean>(SCREEN_SIDEBAR);
  }

  getColumnsWidth(count: number): number {
    let columns = this.getScreenColumns();
    Log.info(TAG, 'getColumnsWidth count is ' + count + ' columns: ' + columns);
    let columnWidth = (px2vp(this.winWidth) - COLUMN_MARGIN) / columns;
    return columnWidth * count - COLUMN_GUTTER;
  }

  getScreenColumns(): number {
    let width = px2vp(this.winWidth);
    if (width < ScreenWidth.WIDTH_MEDIUM) {
      return ColumnSize.COLUMN_FOUR;
    } else if (width >= ScreenWidth.WIDTH_MEDIUM && width < ScreenWidth.WIDTH_LARGE) {
      return ColumnSize.COLUMN_EIGHT;
    } else {
      return ColumnSize.COLUMN_TWELVE;
    }
  }

  setKeepScreenOn(): void {
    Log.info(TAG, 'setKeepScreenOn start');
    let topWindow: window.Window = AppStorage.Get<window.Window>('mainWindow');
    try {
          topWindow.setWindowKeepScreenOn(true, (): void => Log.info(TAG, 'setKeepScreenOn Succeeded'))
      } catch (err) {
      Log.error(TAG, 'setKeepScreenOn err: ' + err);
    }
  }

  setKeepScreenOff(): void {
    Log.info(TAG, 'setKeepScreenOff start');
    let topWindow: window.Window = AppStorage.Get<window.Window>('mainWindow');
    try {
          topWindow.setWindowKeepScreenOn(false, (): void => Log.info(TAG, 'setKeepScreenOff Succeeded'))
      } catch (err) {
      Log.error(TAG, 'setKeepScreenOff err: ' + err);
    }
  }
}

export let screenManager: ScreenManager = stashOrGetObject<ScreenManager>(new ScreenManager(), TAG);
