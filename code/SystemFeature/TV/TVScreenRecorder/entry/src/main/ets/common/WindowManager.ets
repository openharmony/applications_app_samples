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
 
import { display, window } from '@kit.ArkUI'
import { Rect } from '@kit.ArkGraphics3D'
import Logger from './Logger'
import { BusinessError } from '@kit.BasicServicesKit'
import { common } from '@kit.AbilityKit'

const TAG = '[WindowMgr]-->'

export enum WindowType {
  TimerWindow = 0,
  TipWindow
}

export default class WindowMgr {
  private static instance: WindowMgr | undefined
  private data: Map<string, window.Window> = new Map()

  private constructor() {

  }

  public static getInstance(): WindowMgr {
    if (!WindowMgr.instance) {
      WindowMgr.instance = new WindowMgr()
    }
    return WindowMgr.instance
  }

  public set(name: string, windowClass: window.Window) {
    if (this.data.has(name)) {
      Logger.info(TAG, 'windowClass exist')
      return
    }
    this.data.set(name, windowClass)
    Logger.info(TAG, 'set windowClass succeeded')
  }

  public get(name: string) {
    if (!this.data.has(name)) {
      Logger.info(TAG, 'windowClass is not exist')
      return
    }
    return this.data.get(name)
  }

  public release() {
    this.data.forEach((windowClass) => {
      windowClass.destroyWindow()
    })
    this.data.clear()
    Logger.info(TAG, 'WindowMgr release succeeded')
  }

  public openTimerWindow(name: string, page: string, rect: Rect, ctx: common.Context, storage?: LocalStorage) {
    if (this.data.has(name)) {
      Logger.info(TAG, 'TimerWindow exist')
      return
    }
    let config: window.Configuration = {
      name,
      windowType: window.WindowType.TYPE_FLOAT,
      ctx
    };
    window.createWindow(config, (err: BusinessError, windowClass: window.Window) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to create the TimerWindow: ' + JSON.stringify(err))
        return
      }
      Logger.info(TAG, 'Succeeded in creating the TimerWindow.')
      this.set(name, windowClass);
      windowClass.moveWindowTo(rect.x, rect.y, (err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to move the window. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in moving the window.')
      })
      windowClass.resize(rect.width, rect.height, (err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to resetSize. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in resetting size.')
      })
      windowClass.setWindowFocusable(false, (err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to setWindowFocusable. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in setWindowFocusable.')
      })
      windowClass.loadContent(page, storage, (err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to load ScreenRecorder page. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in loading ScreenRecorder page.')

        windowClass && windowClass.setWindowBackgroundColor('#00000000')

        windowClass && windowClass.showWithAnimation((err: BusinessError) => {
          if (err.code) {
            Logger.error(TAG, 'Failed to show window. Case: ' + JSON.stringify(err))
            return
          }
          Logger.info(TAG, 'Succeeded in showing the window. ')
        })
      })
    })
  }

  public popupRecorderTip(name: string, page: string, rect: Rect, duration: number, ctx: common.Context,
    callback?: () => void) {
    if (this.data.has(name)) {
      const windowClass = this.data.get(name)
      windowClass && windowClass.showWithAnimation((err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to show window. Case: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded showWithAnimation.')

        setTimeout(() => {
          windowClass && windowClass.hideWithAnimation((err: BusinessError) => {
            if (err.code) {
              Logger.error(TAG, 'Failed to hideWithAnimation. Case: ' + JSON.stringify(err))
              return
            }
            Logger.info(TAG, 'Succeeded in hideWithAnimation. Data:')

            callback && callback()
          })
        }, duration)
      })
      return
    }

    let config: window.Configuration = {
      name,
      windowType: window.WindowType.TYPE_FLOAT,
      ctx
    };
    window.createWindow(config, (err: BusinessError, windowClass: window.Window) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to create the TipWindow: ' + JSON.stringify(err))
        return
      }
      Logger.info(TAG, 'Succeeded in creating the TipWindow.')
      this.set(name, windowClass)
      const displayClass = display.getDefaultDisplaySync();
      windowClass.moveWindowTo((displayClass.width - rect.width) / 2, rect.y, (err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to move the window. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in moving the window. Data:' + JSON.stringify(err))
      })
      windowClass.resize(rect.width, rect.height, (err: BusinessError, data) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to resetSize. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in resetting size. Data:' + JSON.stringify(data))
      })
      windowClass.setWindowFocusable(false, (err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to setWindowFocusable false. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in setWindowFocusable false.')
      })
      windowClass.setUIContent(page, (err: BusinessError) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to load screenRecorderDialog page. Cause: ' + JSON.stringify(err))
          return
        }
        Logger.info(TAG, 'Succeeded in loading screenRecorderDialog page.')

        windowClass && windowClass.setWindowBackgroundColor('#00000000')

        windowClass && windowClass.showWithAnimation((err: BusinessError) => {
          if (err.code) {
            Logger.error(TAG, 'Failed to show window. Case: ' + JSON.stringify(err))
            return
          }
          Logger.info(TAG, 'Succeeded showWithAnimation.')

          setTimeout(() => {
            windowClass && windowClass.hideWithAnimation((err: BusinessError) => {
              if (err.code) {
                Logger.error(TAG, 'Failed to hideWithAnimation. Case: ' + JSON.stringify(err))
                return
              }
              Logger.info(TAG, 'Succeeded in hideWithAnimation. Data:')

              callback && callback()
            })
          }, duration)

        })
      })
    })
  }
}
