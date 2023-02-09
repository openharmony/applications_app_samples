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

import window from '@ohos.window'
import emitter from "@ohos.events.emitter"
import Logger from '../util/Logger'
import { WindowColor, WindowType, WindowEventId } from "../util/WindowConst"

const windowPoint = {
  x: 50, // 窗口移动的起始坐标X
  y: 250, // 窗口移动的起始坐标Y
}

class WindowManger {
  private TAG: string = 'WindowManger'

  initMainWindow(windowStage: window.WindowStage) {
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        Logger.error(this.TAG, 'Failed to obtain the main window. Cause: ' + JSON.stringify(err))
        return
      }
      let mainWindow = data
      // 窗口规避区域
      mainWindow.on('avoidAreaChange', ({type, area}) => {
        if (type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.SetOrCreate<number>("topHeight", area.topRect.height)
          AppStorage.SetOrCreate<number>("topWidth", area.topRect.width)
        }
      })
      mainWindow.getAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      // 设置主窗口沉浸式
      mainWindow.setLayoutFullScreen(true)
      // 设置主窗口导航栏、状态栏、文字颜色等属性
      let sysBarProps = {
        statusBarColor: WindowColor.statusBarColor,
        navigationBarColor: WindowColor.navigationBarColor,
        statusBarContentColor: WindowColor.statusBarContentColor,
        navigationBarContentColor: WindowColor.navigationBarContentColor
      }
      // 加载状态变量
      mainWindow.setSystemBarProperties(sysBarProps)
    })
  }

  initSubWindow(windowStage: window.WindowStage) {
    // onTouch的坐标绑定
    let innerEvent = {
      eventId: WindowEventId.SUB_WINDOW_INNER_EVENT_ID
    }
    let callback = (eventData) => {
      Logger.info(this.TAG, 'onTouchEventData' + eventData.data.x)
      subWindow.moveTo(windowPoint.x + eventData.data.x, windowPoint.y + eventData.data.y)
    }
    emitter.on(innerEvent, callback)
    let subWindow = null
    // 创建应用子窗口
    windowStage.createSubWindow("mySubWindow", (err, data) => {
      if (err.code) {
        Logger.error(this.TAG, 'Failed to createSubWindow ' + JSON.stringify(err))
        return
      }
      subWindow = data
      // 获取子窗口规避区域
      subWindow.on('avoidAreaChange', ({type, area}) => {
        if (type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.SetOrCreate<number>("topHeight", area.topRect.height)
          AppStorage.SetOrCreate<number>("bottomHeight", area.bottomRect.height)
        }
      })
      // 监听窗口销毁
      subWindow.on('touchOutside', () => {
        subWindow.destroy()
      })
      subWindow.show()
      subWindow.loadContent("pages/Video")
    })
  }

  async setSubWindowAttribute(windowStage: window.WindowStage, windowAttribute: WindowType) {
    let subWindow: window.Window = await windowStage.getMainWindow()
    await subWindow.moveTo(windowAttribute.moveToWidth, windowAttribute.moveToHeight)
    // 设置子窗口为可触状态
    await subWindow.setTouchable(windowAttribute.setTouchable)
    // 设置子窗口的大小
    await subWindow.resetSize(windowAttribute.resetSizeWidth, windowAttribute.resetSizeHeight)
    // 设置子窗口亮度
    await subWindow.setBrightness(windowAttribute.setBrightness)
    // 设置子窗口为隐私模式
    await subWindow.setPrivacyMode(windowAttribute.setPrivacyMode)
  }

  changeWindowDirection(windowStage: window.WindowStage) {
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        Logger.error(this.TAG, 'Failed to change the window: ' + JSON.stringify(err))
        return
      }
      data.setPreferredOrientation(window.Orientation.LANDSCAPE)
    })
  }
}

export default new WindowManger()