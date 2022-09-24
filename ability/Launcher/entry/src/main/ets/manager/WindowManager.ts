/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import display from '@ohos.display'
import CommonEvent from '@ohos.commonEvent'
import Window from '@ohos.window'
import prompt from '@ohos.prompt'
import { EventConstants,Logger } from '@ohos/base'

const TAG: string = 'WindowManager'

export const WINDOW_NAMES = {
  HOME: 'Home',
  RECENTS: 'RecentsPage',
}

export const WINDOW_PAGES = {
  HOME: 'pages/Home',
  RECENTS: 'pages/RecentsPage',
}

const SUBSCRIBER_INFO = {
  events: [
    EventConstants.EVENT_ENTER_HOME,
    EventConstants.EVENT_ENTER_RECENTS,
    EventConstants.EVENT_CLEAR_RECENTS
  ]
}

export default class WindowManager {
  public mWindowSize: number[] = [720, 1080]
  private subscriber = undefined
  private context: any = undefined

  constructor(context) {
    this.context = context
  }

  subscribeCallBack = async (err, data) => {
    if (err.code) {
      Logger.error(TAG, `subscribe, failed: ${JSON.stringify(err)}`)
      return
    }
    Logger.info(TAG, `subscribe, ${JSON.stringify(data)}`)
    switch (data.event) {
      case EventConstants.EVENT_CLEAR_RECENTS:
        let message = this.context.resourceManager.getStringSync($r('app.string.clear_all_missions_message').id)
        prompt.showToast({
          message: message
        })
      case EventConstants.EVENT_ENTER_HOME:
        this.hideWindow(WINDOW_NAMES.RECENTS)
        this.showOrCreateWindow(WINDOW_NAMES.HOME, WINDOW_PAGES.HOME, false)
        break
      case EventConstants.EVENT_ENTER_RECENTS:
        this.showOrCreateWindow(WINDOW_NAMES.RECENTS, WINDOW_PAGES.RECENTS, true)
        break
      default:
        break
    }
  }

  async registerWindowEvent() {
    this.subscriber = await CommonEvent.createSubscriber(SUBSCRIBER_INFO)
    CommonEvent.subscribe(this.subscriber, this.subscribeCallBack)
  }

  async getWindowSize() {
    let displayData = await display.getDefaultDisplay()
    this.mWindowSize = [displayData.width, displayData.height]
    return this.mWindowSize
  }

  /**
 * 设置窗口大小
 *
 * @param width 窗口宽度
 * @param width 窗口高度
 */
  async setWindowSize(width: number, height: number): Promise<void> {
    const abilityWindow = await Window.getTopWindow()
    void abilityWindow.resetSize(width, height)
  }

  async createWindow(windowName: string, page: string, isFullScreen) {
    Logger.info(TAG, `createWindow, name: ${windowName}  page: ${page}`)
    try {
      let displayData = await display.getDefaultDisplay()
      let window = await Window.create(this.context, windowName, Window.WindowType.TYPE_DESKTOP)
      await window.resetSize(displayData.height, displayData.width)
      await window.loadContent(page)
      if (isFullScreen) {
        await window.setFullScreen(true)
      }
      await window.show()
    } catch (error) {
      Logger.error(TAG, `createWindow, create error: ${JSON.stringify(error)}`)
    }
  }

  async showOrCreateWindow(windowName: string, page: string, isFullScreen) {
    Logger.info(TAG, `showOrCreateWindow, name ${windowName}`)
    try {
      let window = await Window.find(windowName)
      await window.show()
    } catch (error) {
      Logger.error(TAG, `showWindow, show error: ${JSON.stringify(error)}`)
      await this.createWindow(windowName, page, isFullScreen)
    }
  }

  async hideWindow(windowName: string) {
    Logger.info(TAG, 'hideWindow')
    try {
      let window = await Window.find(windowName)
      await window.hide()
    } catch (error) {
      Logger.error(TAG, `showWindow, show error: ${JSON.stringify(error)}`)
    }
  }

  async destoryWindow(windowName: string) {
    Logger.info(TAG, 'destoryWindow')
    try {
      let window = await Window.find(windowName)
      await window.destroy()
    } catch (error) {
      Logger.error(TAG, `showWindow, show error: ${JSON.stringify(error)}`)
    }
  }
}