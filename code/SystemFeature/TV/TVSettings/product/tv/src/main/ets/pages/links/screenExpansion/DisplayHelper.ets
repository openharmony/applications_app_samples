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

import { window } from '@kit.ArkUI';
import display from '@ohos.display';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG: string = 'DisplayHelper: '
const MAIN_WINDOW_PREFIX = 'customMainWindow_'
const DEFAULT_MAIN_WINDOW_PAGE = "pages/links/screenExpansion/DefaultMainWindowPage"

class DisplayPage {
  public pagePaths: Array<string> = [] //显示屏上创建的子窗口内容界面路径
  public display: display.Display | null = null //已连接的显示屏

  constructor(display: display.Display, pagePaths: Array<string> = []) {
    this.display = display
    this.pagePaths = pagePaths
  }
}

export default class DisplayHelper {
  public defaultDisplay: display.Display | null = null
  private displayDevices: Array<DisplayPage> = []

  private constructor() {
    console.warn(TAG + 'constructor called.')
    try {
      // todo: 临时屏蔽功能
      let diffDisplayEnable = systemParameterEnhance.getSync('persist.display.expand.enabled') == '1'
      console.log(TAG, 'get persist.display.expand.enabled = ' + diffDisplayEnable);
      if(diffDisplayEnable) {
        this.loadDefaultDisplay()
        this.loadAllDisplays()
        this.initDisplayChangeListener()
      }
    } catch (err) {
      console.log(TAG, 'get persist.display.expand.enabled fail');
    }
  }

  public static getInstance(): DisplayHelper {
    return globalThis.DisplayManager ??= new DisplayHelper()
  }

  /**
   * 获取默认display对象(主屏)
   */
  private loadDefaultDisplay() {
    try {
      this.defaultDisplay = display.getDefaultDisplaySync()
      console.info(TAG + 'loadDefaultDisplay. defaultDisplay id: ' + this.defaultDisplay?.id)
    } catch (err) {
      console.error(TAG + 'loadDefaultDisplay occur error. errInfo: ' + JSON.stringify(err))
    }
  }

  private async loadAllDisplays() {
    let displays: Array<display.Display> = await display.getAllDisplays()
    console.log(TAG, 'getAllDisplays size = ' + displays.length)
    for (let display of displays) {
      if (this.displayDevices.findIndex(item => item.display?.id === display.id) < 0) {
        console.info(TAG + 'new display added. detail: ' + JSON.stringify(display))
        this.displayDevices.push(new DisplayPage(display))
        this.createMainWindow(display)
      }
    }
  }

  /**
   * 显示屏添加/删除监听
   */
  private initDisplayChangeListener() {
    display.on('add', displayId => {
      console.info(TAG + 'add new display. id: ' + JSON.stringify(displayId))
      this.loadAllDisplays()
    })

    display.on('remove', displayId => {
      console.info(TAG + 'remove display. id: ' + JSON.stringify(displayId))
      let delIndex: number = this.displayDevices.findIndex(item => item.display?.id === displayId)
      if (delIndex > 0) {
        this.destroyMainWindow(displayId)
        this.displayDevices.splice(delIndex, 1)
      }
    })
  }

  /**
   * 在指定屏幕上创建主window(新屏幕插入时，默认桌面窗口，不支持隐藏;屏幕拔出时，隐藏销毁本窗口)
   * @param display
   */
  private createMainWindow(display: display.Display) {
    if (display.id === this.defaultDisplay?.id) {
      //主屏不需要创建主窗口
      console.log(TAG, `${display.id}  is default display` )
      return
    }
    //
    window.createWindow({
      ctx: globalThis.settingsAbilityContext,
      name: MAIN_WINDOW_PREFIX + display.id,
      windowType: window.WindowType.TYPE_WALLPAPER,
      displayId: display.id
    }).then((resultWindow: window.Window) => {
      resultWindow.resize(display.width, display.height)
      resultWindow.setWindowMode(window.WindowMode.FULLSCREEN)
      resultWindow.setUIContent(DEFAULT_MAIN_WINDOW_PAGE)
      console.info(`${TAG}create main window ${display.id} success.`)

      resultWindow.showWithAnimation()
    }).catch((err: Error) => {
      console.error(TAG + 'create main window failed. reason: ' + JSON.stringify(err))
    })
  }

  private destroyMainWindow(displayId: number) {
    if (displayId === this.defaultDisplay?.id) {
      return
    }
    try {
      let resultWindow = window.findWindow(MAIN_WINDOW_PREFIX + displayId)
      if (resultWindow?.isWindowShowing()) {
        resultWindow.hideWithAnimation()
      }
      resultWindow?.destroyWindow()
      console.info(`${TAG}destroy main window ${displayId} success.`)
    } catch (err) {
      console.error(TAG + 'find MainWindow occur err. errInfo: ' + JSON.stringify(err))
    }
  }

  /**
   * 销毁所有屏幕上创建的window
   */
  public destroyAllWindow() {
    for (let display of this.displayDevices) {
      if (display.display) {
        this.destroyMainWindow(display.display.id)
      }
    }
    display.off('add')
    display.off('remove')
  }
}
