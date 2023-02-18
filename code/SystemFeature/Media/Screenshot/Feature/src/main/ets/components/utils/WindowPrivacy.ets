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
import display from '@ohos.display'
import { ResponseData } from '../models/ResponseData'
import { Logger } from './Logger'

// 获取当前窗口
export function getCurrentWindow(context: Context) {
  return window.getTopWindow(context)
}

// 判断隐私窗口
export function hasPrivate(): ResponseData {
  let currentDisplay = null
  try {
    currentDisplay = display.getDefaultDisplaySync()
  } catch (exception) {
    return { status: 'failed', errorMessage: JSON.stringify(exception) }
  }
  if (currentDisplay === null) {
    return { status: 'failed', errorMessage: 'get current display failed' }
  }
  let ret = undefined
  try {
    ret = display.hasPrivateWindow(currentDisplay.id)
  } catch (exception) {
    return { status: 'failed', errorMessage: JSON.stringify(exception) }
  }
  if (ret === undefined) {
    return { status: 'failed', errorMessage: 'ret is undefined' }
  }
  return ret ? { status: 'success', errorMessage: '', result: true } :
    { status: 'success', errorMessage: '', result: false }
}


// 设置隐私窗口
export function setWindowPrivacyMode(context: Context, windowPrivacyMode: boolean) {
  let currentWindow = null
  getCurrentWindow(context)
    .then(res => {
      currentWindow = res
      try {
        currentWindow.setWindowPrivacyMode(windowPrivacyMode, (err) => {
          if (err.code) {
            Logger.error('set window privacy mode failed cause: ' + JSON.stringify(err))
            return
          }
          Logger.info(`set window privacy mode success ${windowPrivacyMode}`)
        })
      } catch (exception) {
        Logger.info('set window mode failed cause: ' + JSON.stringify(exception))
      }
    })
}